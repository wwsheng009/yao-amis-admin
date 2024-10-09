import { getYaoModelColumnMap } from '@scripts/system/model';
import { ModelId } from '@yao/types';
import { Exception, Process } from '@yao/yao';
import { YaoQueryParam } from '@yaoapps/types';
import { updateOutputData, updateInputData } from './lib';
import { ClearFalsyKeys } from '@scripts/system/lib';
import { isModelTableExist } from '@scripts/system/model_lib';

export type TableAction = 'create' | 'update';
/**
 * get the data from model using the query object
 * yao run scripts.amis.data.model.getModelData
 * @param modelId model id
 * @param queryParam query dsl
 * @param updateOutput need to update output data
 * @returns new data
 */
export function getModelData(
  modelId: ModelId,
  queryParam: YaoQueryParam.QueryParam,
  updateOutput: boolean = true
) {
  let data = null;
  if (isModelTableExist(modelId)) {
    // we can use the table hooks
    data = Process('yao.table.get', modelId, queryParam);
  } else {
    data = Process(`models.${modelId}.Get`, queryParam);
  }
  if (updateOutput && data != null) {
    data = updateOutputData(modelId, data);
  }
  return data;
}

/**
 * 根据模型 ID 和记录 ID 查找模型数据
 * 如果模型是表格类型，则使用表格钩子查找数据；否则，使用模型的查找方法
 * 如果 updateOutput 为 true，则更新输出数据
 * 清除数据中的虚假键值
 * @param modelId - 模型 ID
 * @param id - 记录 ID
 * @param queryParam - 查询参数
 * @param updateOutput - 是否更新输出数据，默认为 true
 * @returns 查找的数据
 */
export function findModelData(
  modelId: ModelId,
  id: number,
  queryParam: YaoQueryParam.QueryParam,
  updateOutput: boolean = true
) {
  let data = null;
  if (isModelTableExist(modelId)) {
    // we can use the table hooks
    data = Process('yao.table.find', modelId, id, queryParam);
  } else {
    data = Process(`models.${modelId}.find`, id, queryParam);
  }
  if (updateOutput && data != null) {
    data = updateOutputData(modelId, data);
  }
  data = ClearFalsyKeys(data);
  return data;
}

/**
 * search the model data with page
 *
 * 分页搜索模型数据
 * @param modelId model id
 * @param queryParam
 * @param page
 * @param perPage
 * @returns
 */
export function searchModelData(
  modelId: ModelId,
  queryParam: YaoQueryParam.QueryParam,
  page: number,
  perPage: number
) {
  let modelData = null;
  if (isModelTableExist(modelId)) {
    // we can use the table hooks
    modelData = Process(`yao.table.search`, modelId, queryParam, page, perPage);
  } else {
    modelData = Process(
      `models.${modelId}.Paginate`,
      queryParam,
      page,
      perPage
    );
  }
  return modelData;
}

/**
 * 保存模型数据到数据库
 * @param modelId - 模型ID
 * @param payload - 要保存的数据
 * @param action - 执行的操作，create 或 save
 * @returns 返回保存操作的结果
 */
export function saveModelData(
  modelId: ModelId,
  payload: any,
  action: TableAction
) {
  if (payload == null) {
    return;
  }

  payload = updateInputData(modelId, payload);
  const dbAction = action == 'create' ? 'create' : 'save';
  if (isModelTableExist(modelId)) {
    return Process(`yao.table.${dbAction}`, modelId, payload);
  } else {
    return Process(`models.${modelId}.${dbAction}`, payload);
  }
}

/**
 * 批量保存模型数据
 * @param modelId model id
 * @param payload payload,数组或是单个对象
 */
export function saveModelDataBatch(modelId: ModelId, payload: any) {
  if (payload == null) {
    return;
  }
  payload = updateInputData(modelId, payload);

  if (isModelTableExist(modelId)) {
    if (Array.isArray(payload)) {
      payload.forEach((l) => {
        Process(`yao.table.save`, modelId, l);
      });
    } else {
      Process(`yao.table.save`, modelId, payload);
    }
  } else {
    if (Array.isArray(payload)) {
      return Process(`models.${modelId}.eachSave`, payload);
    } else {
      return Process(`models.${modelId}.Save`, payload);
    }
  }
}
/**
 * 在删除数据之后，更新其他数据
 * @param modelId model id
 * @param idsDeleted 需要删除的数据的主键列表
 * @param lines 需要更新的数据
 * @param share 需要共享的数据
 * @returns
 */
export function eachSaveAfterDelete(
  modelId: ModelId,
  idsDeleted: number[],
  lines: object[],
  share: object
) {
  const isExist = isModelTableExist(modelId);

  if (Array.isArray(lines) && lines.length) {
    const yaoColMap = getYaoModelColumnMap(modelId);
    lines.forEach((l, i) => {
      // copy the shared object
      if (Object.keys(share).length) {
        Object.keys(share).forEach((key) => {
          lines[i][key] = share[key];
        });
      }
    });
    lines = updateInputData(yaoColMap, lines) as object[];
  }
  if (isExist) {
    Process(
      `yao.table.deletein`,
      modelId,
      Array.isArray(idsDeleted) ? idsDeleted.join(',') : idsDeleted
    );
    if (Array.isArray(lines) && lines.length) {
      lines.forEach((l) => {
        Process(`yao.table.save`, modelId, l);
      });
    }
  } else {
    return Process(
      `models.${modelId}.EachSaveAfterDelete`,
      idsDeleted,
      lines,
      {}
    );
  }
}
/**
 * 根据主键删除模型数据
 * @param modelId
 * @param ids
 */
export function deleteModelData(modelId: ModelId, ids: string) {
  const myArray = ids.split(',');
  if (isModelTableExist(modelId)) {
    if (ids.includes(',')) {
      Process(`yao.table.deletein`, modelId, ids);
    } else {
      myArray.forEach((id: string) => {
        Process(`yao.table.delete`, modelId, id);
      });
    }
  } else {
    myArray.forEach((id: string) => {
      Process(`models.${modelId}.Delete`, id);
    });
  }
}

/**
 * 批量更新模型的数据
 * @param modelId model id
 * @param ids ids
 * @param payload payload
 */
export function bulkUpdateModelData(
  modelId: ModelId,
  ids: string,
  payload: object
) {
  if (payload == null) {
    return;
  }
  if (!ids) {
    throw new Exception(`Ids is missing for batch update data`);
  }
  payload = updateInputData(modelId, payload);

  if (isModelTableExist(modelId)) {
    if (ids.includes(',')) {
      return Process(`yao.table.updatein`, modelId, ids, payload);
    } else {
      return Process(`yao.table.update`, modelId, ids, payload);
    }
  } else {
    const myArray = ids.split(',');
    myArray.forEach((id: string) => {
      // Process("yao.model.Update", model, id, payload);
      Process(`models.${modelId}.Update`, id, payload);
    });
  }
}
