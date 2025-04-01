import { getModelFromDB } from '@scripts/system/model_db';
import { ModelId, AmisModel, CachedModelTree, CachedModel } from '@yao/types';

import { Process, Exception } from '@yao/yao';
import { YaoModel } from '@yaoapps/types';
import { loadModeltoMemory } from '@scripts/system/model_load';
import { updateModelMetaFields } from './model_convert';

/**
 * get the id list of the cached models 读取所有的模型id的列表
 *
 * yao run scripts.system.model_lib.getCachedModelIDList
 * @returns list of the cached model ids
 */
export function getCachedModelIDList(): string[] {
  return Process('model.list').map((m) => m.id);
  // const models = Process('widget.models');

  // return modelIdListFromMemory(models);
}

/**
 * 返回所有缓存中的模型列表
 *
 * yao run scripts.system.model_lib.getCachedModelList
 * @returns []object
 */
export function getCachedModelList(): CachedModel[] {
  const modelsList = Process('model.list', { metadata: true });

  return modelsList.map((m) => {
    m.metadata.ID = m.id;
    return m.metadata;
    // return m as CachedModel;
  });

  // const models = Process('widget.models');
  // return modelListFromMemory(models);
}
/**
 * 解析内存中的模型数据,可以使用路径表达式
 *
 * yao run scripts.system.model_lib.FilterCachedModelList 'ID'
 *
 * yao run scripts.system.model_lib.FilterCachedModelList name,ID
 * @param {*} attr
 * @returns
 */
function FilterCachedModelList(attr?: string[] | string) {
  const models = Process('widget.models');
  return FilterAndFlatTreeByAttr(models, attr);
}
/**
 * 扁平化模型列表
 * @param {object} models yao 模型 嵌套的数据结构
 * @param {string} attr,使用路径表达式抽取子对象
 * @returns
 */
function FilterAndFlatTreeByAttr(
  models: CachedModelTree[],
  attr?: string[] | string
) {
  const list = [] as CachedModel[];

  const getProperty = (object: object, path: string) => {
    const properties = path.split('.');
    let currentObject = object;

    for (let i = 0; i < properties.length; i++) {
      currentObject = currentObject[properties[i]];
    }
    return currentObject;
  };

  const setProperty = (object, path, value) => {
    const properties = path.split('.');
    let currentObject = object;

    for (let i = 0; i < properties.length - 1; i++) {
      if (currentObject === undefined) {
        throw new Error(
          `Property '${properties[i]}' does not exist in path '${path}'`
        );
      }
      //   注意，不支持生成数组
      if (!Object.prototype.hasOwnProperty.call(currentObject, properties[i])) {
        currentObject[properties[i]] = {};
      }
      currentObject = currentObject[properties[i]];
    }

    currentObject[properties[properties.length - 1]] = value;
  };
  let attr2 = [];
  if (attr != null) {
    if (typeof attr === 'string') {
      // 单个属性
      attr2 = attr.split(',');
    } else if (Array.isArray(attr)) {
      attr2 = attr;
    }
  }
  const traverse = (node: any) => {
    if (node.children) {
      traverse(node.children);
    } else if (Array.isArray(node)) {
      node.forEach((line) => {
        traverse(line);
      });
    } else {
      if (attr2.length) {
        const o = {};
        attr2.forEach((a) => {
          let p = getProperty(node, a);
          if (p != null) {
            // o[a] = p;
            setProperty(o, a, p);
          }
          p = getProperty(node.data, a);
          if (p != null) {
            // o[a] = p;
            setProperty(o, a, p);
          }
        });
        if (Object.keys(o).length > 0) {
          list.push(o);
        }
      } else if (node.data) {
        list.push(node.data);
      }
    }
  };
  traverse(models);
  return list;
}
/**
 * 根据模型ID在缓存中查找模型定义
 * yao run scripts.system.model_lib.FindCachedModelById
 * @param {string} modelId 模型标识
 * @returns YaoModel.ModelDSL | null
 */
export function FindCachedModelById(modelId: ModelId): AmisModel {
  const exist = Process(`models.${modelId}.exists`);
  if (exist) {
    const model = Process(`model.dsl`, modelId, { metadata: true }).metadata;
    const modelDsl = updateModelMetaFields(model);
    return modelDsl;
  } else {
    return null;
  }
}

/**
 * 优先从缓存中加载模型，如果不存在，从数据库中加载并转换成yao模型,确保可以找到模型
 * @param {string} modelId
 */
export function FindAndLoadYaoModelById(modelId: ModelId): YaoModel.ModelDSL {
  const modelDsl = FindCachedModelById(modelId);
  if (modelDsl == null) {
    let modelDsl = getModelFromDB(modelId);

    if (modelDsl != null) {
      // 加载到内存中。
      const err = loadModeltoMemory(modelDsl, false);
      if (err?.code && err?.Message) {
        throw Error(err?.Message + err?.code);
      }
      modelDsl = FindCachedModelById(modelId);
    }
  }

  if (!modelDsl) {
    throw new Exception(`模型${modelId}定义不存在，未加载？`, 500);
  }
  return modelDsl;
}

/**
 * 解析内存中的模型数据
 * @param {*} modelData
 * @returns
 */
export function modelIdListFromMemory(modelData: CachedModelTree) {
  let idList = [];
  if (modelData.children) {
    modelData.children.forEach((line) => {
      const subLine = modelIdListFromMemory(line);
      idList = idList.concat(subLine);
    });
  } else if (modelData.data) {
    idList.push(modelData.data.ID);
  } else if (Array.isArray(modelData)) {
    modelData.forEach((line) => {
      const subLine = modelIdListFromMemory(line);
      idList = idList.concat(subLine);
    });
  }
  return idList;
}

export function modelListFromMemory(modelData: CachedModelTree) {
  let modelList = [];
  if (modelData.children) {
    modelData.children.forEach((line) => {
      const subLine = modelListFromMemory(line);
      modelList = modelList.concat(subLine);
    });
  } else if (modelData.data != null) {
    modelList.push(modelData.data);
  } else if (Array.isArray(modelData)) {
    modelData.forEach((line) => {
      const subLine = modelListFromMemory(line);
      modelList = modelList.concat(subLine);
    });
  }
  return modelList;
}

/**
 * 检查模型关联的同名的表格配置是否存在，这里的表格是tables目录下的配置，不是数据库的表
 *
 * 使用模型关联表的处理器可以间接使用表格配置中的hook处理器，方便加强处理逻辑
 * @param modelId model id
 * @returns
 */
export function isModelTableExist(modelId: ModelId): boolean {
  return Process('yao.table.exists', modelId);
}
