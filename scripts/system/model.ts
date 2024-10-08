/**
 * Yao模型管理
 * 模型的增删改查
 * 模型导入
 * 模型导出
 */
import { getModelFromDB, saveAmisModel } from '@scripts/system/model_db';
import {
  loadModeltoMemory,
  deepCopyObject,
  migrateModel,
  checkAndloadDefaultTableForm
} from '@scripts/system/model_load';

import { DotName, SlashName } from '@scripts/system/lib';

import { RunTransaction } from '@scripts/system/db';

import { queryToQueryParam, mergeQueryObject } from '@scripts/amis/data/lib';

import {
  FindAndLoadYaoModelById,
  getCachedModelIDList,
  FindCachedModelById,
  getCachedModelList
} from '@scripts/system/model_lib';

import { Process, Exception, FS } from '@yao/yao';
import {
  AmisModelDB,
  AmisModelColumn,
  AmisModel,
  ModelId,
  CachedModel,
  AmisUIModel
} from '@yao/types';
import { YaoModel, YaoQueryParam } from '@yaoapps/types';
import { QueryObjectIn } from '@yao/request';
import {
  AddModelMetaFields,
  amisModelToAmisModelDB,
  amisModelToAmisUiModel,
  amisModelToYaoModel,
  amisUIModelToAmisModel,
  CheckAmisModel,
  completeAmisModel,
  guessModelColumnsType
} from './model_convert';
import { ErrorMessage, SuccessMessage } from '@scripts/return';
import { deleteModelLocalFile, saveModelToFile } from './model_file';

/**
 * yao run scripts.system.model.page
 * 模型定义列表分页查询，结果在列表中显示。
 * @param {number} pageIn
 * @param {number} pagesizeIn
 * @param {object} querysIn
 * @param {object} queryParams
 * @param {object} payload
 * @returns
 */
export function page(
  pageIn: number,
  pagesizeIn: number,
  querysIn: QueryObjectIn,
  queryParams: YaoQueryParam.QueryParam,
  payload: object
) {
  const page = pageIn || 1;
  const pagesize = pagesizeIn || 10;
  const querys = mergeQueryObject(querysIn, payload);
  const modelDsl = FindAndLoadYaoModelById('ddic.model');
  let queryParam = queryToQueryParam(modelDsl, querys, queryParams);
  queryParam = queryParam || {};
  queryParam['select'] = [
    'id',
    'name',
    'identity',
    'comment',
    'table_name',
    'table_comment'
  ];
  const data = Process(
    `models.ddic.model.Paginate`,
    queryParam,
    page,
    pagesize
  );
  return {
    items: data.data,
    total: data.total
  };
}

/**
 * 读取所有的模型id的列表
 * yao run scripts.system.model.getDatabaseModelList
 * @returns array
 */
function getDatabaseModelList(): AmisModelDB[] {
  const list = Process('models.ddic.model.get', {
    select: ['identity', 'name', 'comment'],
    limit: 1000000
  } as YaoQueryParam.QueryParam);

  list.forEach((item) => {
    if (item.comment == null) {
      item.comment = item.name ? item.name : item.identity;
    }
  });
  return list;
}

// // 删除关联表数据
// export function BeforeDelete(id: number) {
//   DeleteModelolumns(id);
// }

export function isAscOrder(arr: { id: string }[]) {
  for (let i = 0; i < arr.length - 1; i++) {
    if (arr[i].id > arr[i + 1].id) {
      return false;
    }
  }
  return true;
}

/**
 * 保存模型定义，并返回更新后的模型定义
 * @param {object} payload 模型定义
 * @returns object
 */
export function saveModelApi(payload: AmisUIModel) {
  // 处理amis与yao的兼容性
  const model = amisUIModelToAmisModel(payload);

  CheckAmisModel(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = amisModelToAmisModelDB(model);
  const id = saveAmisModel(line, model.option?.migrate_force);

  if (id != null) {
    const err = loadModeltoMemory(
      model,
      !model.option?.read_only,
      model.option?.migrate_force
    );

    if (err?.message) {
      return Process('scripts.return.ErrorMessage', err.Code, err.Message);
    }
  } else {
    return Process('scripts.return.ErrorMessage', 403, '保存模型失败');
  }
  saveModelToFile(model);

  return Process('scripts.return.RSuccess', getModelApi(id), '保存成功');
}

/**
 * 保存Yao模型到数据库，并返回id,
 * 注意这个方法并不作模型迁移
 * scripts.system.model.ImportCachedModelToDB
 * @param {object} modelDsl Yao模型
 * @returns id
 */
function ImportCachedModelToDB(modelDsl: CachedModel): number {
  const model = completeAmisModel(modelDsl);
  CheckAmisModel(model);

  // 导入缓存不要保存本地模型
  // saveModelToFile(model)
  // console.log("ImportCachedModelToDB", model)
  // 传入的是模型数据，转成表结构后再保存
  const line = amisModelToAmisModelDB(model);
  return saveAmisModel(line, true);
}

/**
 * 把模型元定义从缓存中导入到数据库,有缓存，相当于本地模型
 * yao run scripts.system.model.ImportCachedModelById
 * @param {string} modelId 模型ID
 * @returns
 */
function ImportCachedModelById(modelId: string) {
  const model = FindCachedModelById(modelId);
  if (!model) {
    throw new Exception(`模型：${modelId} 未加载`);
  }
  // 传入的是模型数据，转成表结构后再保存
  const id = ImportCachedModelToDB(model);
  if (id) {
    const err = migrateModel(modelId, false);
    if (err?.code && err.message) {
      throw new Exception(err.message, err.code);
    }
  }
}

/**
 * yao run scripts.system.model.DeleteModelMetaById 90
 * 删除模型
 * @param {number} modelId 模型标识
 */
export function DeleteModelMetaByIdBatch(modelId: string) {
  const models = modelId + '';
  const ids = models.split(',');
  ids.forEach((id) => DeleteModelMetaById(id));
}
/**
 * 根据模型id删除模型定义
 * @param {string} modelId model id
 * @returns
 */
function DeleteModelMetaById(modelId: string) {
  // 检查是否存在，不存在会报错
  Process('models.ddic.model.Find', modelId, {});

  const deleteFun = function (modelId: string) {
    // 先删除列定义
    let ret = Process('models.ddic.model.column.DeleteWhere', {
      wheres: [{ column: 'model_id', value: modelId }]
    });
    if (ret?.code && ret.message) {
      throw ret;
    }

    ret = Process('models.ddic.model.Delete', modelId);
    if (ret?.code && ret.message) {
      throw ret;
    }
  };
  RunTransaction(deleteFun, modelId as undefined);

  return deleteModelLocalFile(modelId);
}

/**
 * 根据模型ID获取模型定义
 * 模型有可能会保存在两个位置，一个是在数据库里，根据数据库ID,
 * 读取已经加载在内存中的模型的定义，受限里yao的程序解析
 * 数据库中的信息会比内存的信息更加丰富，可以自由扩展
 * yao run scripts.system.model.getModelApi admin.auth.role
 * @param {string | number} modelId
 * @returns
 */
export function getModelApi(modelId: string | number) {
  return amisModelToAmisUiModel(getModelDslById(modelId));
}

/**
 *
 * @param {string} modelId 模型ID
 * @returns
 */
export function getModelColumnsApi(modelId: string) {
  const model = amisModelToAmisUiModel(getModelDslById(modelId));
  if (Array.isArray(model?.columns) && model.columns.length) {
    model?.columns?.forEach((x, idx) => {
      x.checked = true;
      x.index = idx;
    });
  }
  // 前端使用的是input-table,不要使用items，会有异常。
  // 前端在引用时也要使用columns,不要把input-table的name设置成items。
  return {
    columns: model?.columns || []
  };
}

/**
 * 加载模型标识，优先从数据库中加载，找不到再在缓存中加载
 * 数据库的模型信息会更多
 *
 * yao run scripts.system.model.getModelDslById admin.user
 * @param {string} modelId 模型标识
 * @returns
 */
export function getModelDslById(modelId: ModelId) {
  if (!modelId) {
    throw new Exception(`缺少模型标识`);
  }
  let modelDsl = getModelFromDB(modelId);
  const modelDsl2 = FindCachedModelById(modelId);

  if (modelDsl != null && modelDsl2 == null) {
    loadModeltoMemory(modelDsl, false);
  }
  if (modelDsl == null && modelDsl2 != null) {
    modelDsl = modelDsl2;
  }
  if (modelDsl == null) {
    throw new Exception(`模型：${modelId}不存在`);
  }

  return modelDsl;
}

/**
 * yao run scripts.system.model.getYaoModelColumnMap admin.auth.role
 * 返回模型的columns定义
 * @param {string} model 模型ID
 * @returns 返回模型的columns定义
 */
export function getYaoModelColumnMap(model: ModelId | YaoModel.ModelDSL) {
  let modelDsl = model as YaoModel.ModelDSL;

  if (typeof model === 'string') {
    modelDsl = FindAndLoadYaoModelById(model);
  }
  const columnMap = {};
  if (modelDsl && modelDsl.columns) {
    modelDsl.columns.forEach((col) => {
      columnMap[col.name] = col;
    });
  }
  modelDsl = AddModelMetaFields(modelDsl);
  return columnMap;
}
/**
 * get the model source in json format
 * yao run scripts.system.model.ExportModelToYaoSource
 * @param {string} modelId
 * @returns
 */
export function exportAmisModelSource(modelId: ModelId) {
  return { source: getModelFromDB(modelId) };
}

/**
 * get the model source in yao format
 * yao run scripts.system.model.exportAmisModelToYao
 * @param {string} modelId
 * @returns
 */
export function exportAmisModelToYao(modelId: ModelId) {
  let model = getModelFromDB(modelId);
  model = amisModelToYaoModel(model);

  return { source: model };
}

/**
 * 移除模型类定义中的id字段，在一些使用场景中需要全新插入，需要先移除所有的id
 * @param {object} modelDsl model dsl
 * @returns
 */
function removeModelColumnIds(modelDsl: AmisModel) {
  if (!Array.isArray(modelDsl.columns) || !modelDsl.columns.length) {
    return modelDsl;
  }
  modelDsl.columns.forEach((col) => delete col.id);
  return modelDsl;
}

/**
 * 从源代码导入模型定义
 * @param {object} payload 外部传的源代码
 * @returns
 */
export function ImportModelFromSource(payload: { ID: string; source: string }) {
  const ID = payload.ID;
  let newCode = payload.source;
  newCode = newCode.replace(/\/\/.*$/gm, '');
  newCode = newCode.replace(/\/\*.*?\*\//gs, '');
  let model = JSON.parse(newCode) as AmisModel;
  model.ID = ID || model.ID;
  model = completeAmisModel(model);
  CheckAmisModel(model);
  model = removeModelColumnIds(model);
  // 传入的是模型数据，转成表结构后再保存
  const line = amisModelToAmisModelDB(model);
  const id = saveAmisModel(line) as unknown as number;
  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.Message) {
      return Process('scripts.return.ErrorMessage', err.Code, err.Message);
    }
  } else {
    return Process(
      'scripts.return.ErrorMessage',
      403,
      '模型保存失败，导入失败'
    );
  }
  saveModelToFile(model);

  return Process('scripts.return.RSuccess', { id: id }, '导入成功');
}

/**
 * 批量把所有的数据库的模型加载到缓存
 * yao run scripts.system.model.importDBModelsToCache
 */
export function importDBModelsToCache() {
  const list = getDatabaseModelList();

  list.forEach((m) => {
    const modelDsl = getModelFromDB(m.identity);
    loadModeltoMemory(modelDsl);
  });

  //load the default table and form config for model if not exist;
  const cachedMList = getCachedModelIDList();
  cachedMList.forEach((l) => {
    if (!Process('yao.table.exists', l)) {
      checkAndloadDefaultTableForm(l);
    }
  });
}
/**
 * return the id and the name info for all models.
 *
 * yao run scripts.system.model.getAllModelIdAndName
 * @returns
 */
export function getAllModelIdAndName(): { id: string; name: string }[] {
  const modelIds = getCachedModelIDList();
  const modelsFromDb = getDatabaseModelList();

  // 使用Map提高性能
  const modelMap = new Map<string, string>();

  // 处理内存中的模型
  modelIds.forEach((m) => modelMap.set(m, m));

  // 处理数据库中的模型，优先使用name
  modelsFromDb.forEach((m) => modelMap.set(m.identity, m.name || m.identity));

  // 将Map转换为数组
  return Array.from(modelMap, ([id, name]) => ({ id, name }));
}

/**
 * 读取所有模型的ID
 *
 * yao run scripts.system.model.getAllModelIds
 */
export function getAllModelIds() {
  let modelIds = getCachedModelIDList();
  // models.forEach((m) => modelIds.push(m.ID));
  const modelsFromDb = getDatabaseModelList();
  modelsFromDb.forEach((m) => modelIds.push(m.identity));

  modelIds = [...new Set(modelIds)];
  return modelIds;
}

/**
 * 加载内部模型到数据库库，内部模型定义会在yao启动时自动加载到内存中。
 * yao run scripts.system.model.ImportCachedToDBBatch
 */
function ImportCachedToDBBatch() {
  const models = getCachedModelList();

  models.forEach((model) => {
    ImportCachedModelToDB(model);
  });
}
export function ImportSystemModels() {
  ImportCachedToDBBatch();
  return { message: '导入成功' };
}
/**
 * get all model name list as select options only include the cached model.
 * yao run scripts.system.model.getCachedModelsNameOptions
 * @returns 返回模型ID列表
 */
export function getCachedModelsNameOptions() {
  const list = getCachedModelIDList();
  const models = list.map((model) => {
    return { label: model, value: model };
  });
  // 不要直接返回数组，amis并不推荐直接返回数组
  // amis默认会使用items属性
  return { items: models };
}

/**
 * get all model name list as select options only include the database model.
 *
 * yao run scripts.system.model.getDbModelsNameOptions
 * @returns
 */
export function getDbModelsNameOptions() {
  const list = getDatabaseModelList();
  const models = list.map((model) => {
    let label = model.comment ? model.comment : model.name;
    label = label ? label : model.identity;
    return {
      label: label,
      value: model.identity
    };
  });
  return { items: models };
}

/**
 * get all model name list as select options including the cached and the database.
 *
 * yao run scripts.system.model.getAllModelNameOptions
 * @returns
 */
export function getAllModelNameOptions() {
  const modelIds = getCachedModelIDList();

  const modelsFromDb = getDbModelsNameOptions().items;

  // 使用Map提高性能
  const modelMap = new Map<string, string>();

  // 处理内存中的模型
  modelIds.forEach((m) => modelMap.set(m, m));

  // 处理数据库中的模型，优先使用name
  modelsFromDb.forEach((m) => modelMap.set(m.value, m.label));

  // 将Map转换为数组
  const items = Array.from(modelMap, ([value, label]) => ({ value, label }));
  return { items };
}

/**
 * 导入表结构,会强制刷新数据库与缓存
 * @param {object} payload 需要导入的模型
 * @returns
 */
function ImportTableAction(payload: { name: string }) {
  // const ms = cachedModels.filter((m) => m.table.name == payload.name);
  // if (Array.isArray(ms) && ms.length) {
  //   // 如果已经在缓存中存在，不要覆盖
  //   ms.forEach((module) => ImportCachedModelToDB(module));
  // } else {
  // 如果不存在，把表结构转换成模型，转换成模型，再加载

  let model = Process('schemas.default.TableGet', payload.name) as AmisModel;
  model.table = model.table || {};
  model.table.name = payload.name;
  model.ID = DotName(payload.name);
  model.name = payload.name;

  model = completeAmisModel(model);
  CheckAmisModel(model);
  model = removeModelColumnIds(model);

  let dbModel = deepCopyObject(model);
  dbModel = guessModelColumnsType(dbModel);
  // 传入的是模型数据，转成表结构后再保存
  const line = amisModelToAmisModelDB(dbModel);
  const id = saveAmisModel(line);

  if (id) {
    const err = loadModeltoMemory(model, false);
    if (err && err.Message) {
      return ErrorMessage(err.Code, err.Message);
    }
  } else {
    return ErrorMessage(403, '保存模型失败');
  }

  saveModelToFile(model);
  return SuccessMessage('保存模型成功');
}

/**
 * 从数据库读取模型并加载到内存中。
 * @param {*} payload
 * @returns
 */
export function LoadToCacheFromDB(payload: { model: string }) {
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  const modelId = payload.model;
  const model = getModelFromDB(modelId);
  if (model != null) {
    const err = loadModeltoMemory(model, false, true);
    if (err?.code && err?.Message) {
      throw Error(err?.Message + err?.code);
    }
  } else {
    return { message: `模型:${modelId}不存在`, code: 503 };
  }
  return { message: '缓存加载成功' };
}

function CheckImportModelLine(modelId: string, tableName: string) {
  // 根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  const wheres = [];
  if (tableName) {
    wheres.push({ column: 'table_name', value: tableName });
    wheres.push({
      method: 'orwhere',
      column: 'identity',
      value: modelId
    });
  } else {
    wheres.push({ method: 'where', column: 'identity', value: modelId });
  }

  const [data] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {}
  });
  return data;
  // return data.filter((line) => !line.read_only)[0];
}

/**
 * 从Neo助手生成的模型导入
 * @param {AmisUIModel} modelDsl 模型对象
 * @returns
 */
export function ImportFromNeo(modelDsl: AmisUIModel) {
  // 处理amis与yao的兼容性
  const model = amisUIModelToAmisModel(modelDsl);

  CheckAmisModel(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = amisModelToAmisModelDB(model);
  const id = saveAmisModel(line);

  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.message) {
      throw new Exception(err.message, err.code);
    }
  } else {
    throw new Exception('保存模型失败', 503);
  }
  saveModelToFile(model);
  return id;
}
export function ImportFromCached(payload: { model: string }) {
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  ImportCachedModelById(payload.model);
  return { message: `模型:${payload.model}导入成功` };
}

/**
 * 批量导入本地缓存
 * @param {object} payload 请求数据
 * @returns
 */
export function ImportFromCachedBatch(payload: { items: { model: string }[] }) {
  const items = payload.items;
  if (!Array.isArray(items)) {
    return { message: '传入数据不正确' };
  }
  items.forEach((item) => {
    ImportCachedModelById(item.model);
  });
  return { message: '批量导入本地缓存完成' };
}
export function ImportTableStruct(payload) {
  // console.log(payload);
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  const model = CheckImportModelLine(payload.model, payload.name);
  if (model != null) {
    return {
      message: `模型:${payload.model}，表:${payload.name} 已经存在，禁止导入`
    };
  }
  // 先根据表名检查是否缓存中已经有对应的模型，如果存在，加载到数据库，
  return ImportTableAction(payload);
}

function guessJsonType(value) {
  if (!value) {
    return 'string';
  }
  const isNumber = /^-?\d*\.?\d+$/.test(value);

  if (value === null) {
    return 'string';
  } else if (isNumber) {
    if (/^-?\d+$/.test(value)) {
      return 'integer';
    } else if (!isNaN(value)) {
      return 'float';
    }
  } else if (typeof value === 'boolean') {
    return 'boolean';
  } else if (typeof value === 'string') {
    const timestamp = Date.parse(value); // Parse the datetime string

    if (!isNaN(timestamp)) {
      const date = new Date(timestamp); // Create a new date object from the timestamp
      if (
        date.getHours() === 0 &&
        date.getMinutes() === 0 &&
        date.getSeconds() === 0
      ) {
        return 'date';
      } else {
        return 'datetime';
      }
    }
    return 'string';
  } else if (Array.isArray(value)) {
    return 'json';
  } else if (typeof value === 'object') {
    return 'json';
  } else {
    return 'string';
  }
}
function getLastPart(str: string) {
  // Split the string at "-" and get the last part (if "-" exists)
  const parts = str.split('-');
  const lastPart = parts[parts.length - 1];

  // If the last part is not undefined or null, return it
  if (lastPart) {
    return lastPart;
  } else {
    // If "-" does not exist in the string, return the original string
    return str;
  }
}
function guessAmisType(typeIn: string) {
  if (!typeIn) {
    return 'string';
  }
  let type = typeIn.toLowerCase();
  type = getLastPart(type);
  // type = type.replace("input-", "");
  // type = type.replace("static-", "");
  // type = type.replace("list-", "");
  // type = type.replace("tree-", "");

  if (type.includes('text')) {
    return 'string';
  }
  if (type.endsWith('_id')) {
    return 'integer';
  }
  switch (type) {
    case 'number':
      return 'integer';
    case 'select':
      return 'enum';
    case 'switch':
    case 'picker':
      return 'boolean';

    default:
      break;
  }
  return 'string';
}
function guessAmisCols(columns: object[]) {
  const cols = [];
  function traverse(node) {
    if (Array.isArray(node)) {
      node.forEach((x) => traverse(x));
      return;
    }
    if (Array.isArray(node.body)) {
      node.body.forEach((x) => traverse(x));
      return;
    }

    const column = {
      name: node.name,
      type: guessAmisType(node.type),
      label: node.label
    } as AmisModelColumn;
    if (node.required) {
      column.nullable = false;
    }
    if (node.description) {
      column.comment = node.description;
    }
    if (column.type == 'enum') {
      column.options = node.options;
    }

    cols.push(column);
  }
  traverse(columns);
  return {
    columns: cols,
    status: 'ok',
    message: 'JSON检查成功'
  };
}
export function CheckAndGuessJson(payload) {
  let json = payload.json;
  const type = payload.type;

  // console.log("json::::", json);
  if (json == null) {
    return {
      columns: [],
      code: 500,
      message: '请检查输入数据'
    };
  }
  if (typeof json === 'string') {
    try {
      json = JSON.parse(payload.json);
    } catch (error) {
      throw new Exception('数据格式不正确' + error.message, 500);
    }
  }

  if (!(typeof json == 'object')) {
    throw new Exception('数据格式不正确', 500);
  }

  if (type === 'amis') {
    return guessAmisCols(json);
  }

  if (Array.isArray(json)) {
    json = json[0];
  }

  const columns = [];

  for (const [name, value] of Object.entries(json)) {
    const column = {
      name,
      type: guessJsonType(value),
      label: name
    };
    if (name.toLowerCase() == 'id' && typeof value === 'number') {
      column.type = 'id';
    }
    columns.push(column);
  }

  return {
    columns: columns,
    status: 'ok',
    message: 'JSON检查成功'
  };
}
/**
 * 从数据库表中导入到模型
 * @param {object} payload 数据库表列表
 * @returns
 */
export function ImportFromTableBatch(payload: {
  items: { model: string; name: string }[];
}) {
  const items = payload.items;
  if (!Array.isArray(items)) {
    return { code: 503, message: '传入数据格式不正确，需要传入数组！' };
  }

  for (const item of items) {
    const model = CheckImportModelLine(item.model, item.name);

    if (model != null) {
      return {
        code: 503,
        message: `模型:${item.model}，表:${item.name} 已经存在，禁止导入！`
      };
    }
    const { status, msg } = ImportTableAction(item);
    if (status !== 0) {
      return { message: msg, code: status };
    }
  }
  return { message: '批量导入表结构成功。' };
}
