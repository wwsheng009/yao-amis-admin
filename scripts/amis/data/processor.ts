import { getYaoModelColumnMap } from '@scripts/system/model';
import { ModelId } from '@yao/types';
import { Exception, Process } from '@yao/yao';
import { YaoQueryParam } from '@yaoapps/types';
import { updateOutputData, updateInputData } from './lib';

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
  return data;
}

/**
 * search the model data with page
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

export function saveModelData(modelId: ModelId, payload: any) {
  if (payload == null) {
    return;
  }
  payload = updateInputData(modelId, payload);

  if (isModelTableExist(modelId)) {
    return Process(`yao.table.save`, modelId, payload);
  }
  return Process(`models.${modelId}.Save`, payload);
}

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
      return Process(`yao.table.save`, modelId, payload);
    }
  }
  if (Array.isArray(payload)) {
    return Process(`models.${modelId}.eachSave`, payload);
  } else {
    return Process(`models.${modelId}.Save`, payload);
  }
}

export function eachSaveAfterDelete(
  modelId: ModelId,
  idsDeleted: number[],
  lines: object[],
  share: object
) {
  const checkTable = isModelTableExist(modelId);

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
  if (checkTable) {
    Process(`yao.table.deletein`, modelId, idsDeleted.join(','));
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

function isModelTableExist(modelId: ModelId) {
  return Process('yao.table.exists', modelId);
}
