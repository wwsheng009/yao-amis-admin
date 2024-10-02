// model db operations

import { Exception, Process } from '@yao/yao';
import { AmisModel, AmisModelDB, ModelId } from '@yao/types';
import { amisModelToAmisModel } from './model_convert';
import { RunTransaction } from './db';

/**
 * yao run scripts.system.model_db.checkType
 * @param value object
 * @returns type
 */
function checkType(value: string | number) {
  if (typeof value === 'number') {
    if (!isNaN(value)) {
      return 'number';
    }
  } else if (typeof value === 'string') {
    if (value.trim() !== '' && !isNaN(value as unknown as number)) {
      return 'number';
    } else {
      return 'string';
    }
  }
  return 'other';
}
/**
 * 从数据库中加载Yao模型,返回一个Yao模型定义
 * yao run scripts.system.model.getModelFromDB
 * @param {number | string} modelId 模型ID标识
 * @returns
 */
export function getModelFromDB(modelId: ModelId): AmisModel {
  // 数字ID可能是数据库数据

  const wheres = [];
  if (checkType(modelId) === 'number') {
    wheres.push({
      method: 'where',
      column: 'id',
      value: modelId
    });
  } else {
    wheres.push({ column: 'identity', value: modelId });
  }

  // 根据id在数据库表中查找
  const [line] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {
      columns: { withs: { element: {} } }
    },
    limit: 1
  });
  if (line != null) {
    // 数据库表信息转成模型定义
    return amisModelToAmisModel(line);
  }
}

export function saveAmisModel(payload: AmisModelDB, force?: boolean): number {
  // 先保存主表，获取id后再保存从表
  const saveFun = function (payload: AmisModelDB) {
    const res = Process('models.ddic.model.Save', payload);
    if (res && res.code && res.code > 300) {
      throw res;
    }
    if (res != null) {
      SaveRelations(res, payload, force);
    }
    return res;
  };
  return RunTransaction(saveFun, payload as undefined) as unknown as number;
}
// 保存关联表数据
function SaveRelations(id: number, payload: AmisModelDB, force?: boolean) {
  // BeforeDelete(id);
  SaveColumns(id, payload, force);
  return id;
}

/**
 * 保存ddic.model.column
 * @param {string} modelId
 * @param {object} payload
 * @param {boolean} force 强制保存
 * @returns
 */
function SaveColumns(modelId: number, payload: AmisModelDB, force?: boolean) {
  if (modelId == null) {
    throw new Exception('无法保存columns,缺少模型主键！');
  }
  const cols = payload.columns || [];

  if (force == true) {
    force = true;
  }
  if (!cols.length) {
    return;
  }
  // let needDelete = force;

  // let hasOneColId = false;
  // //检查记录中至少有一个主键。如果都没有ID，说明是新记录
  // cols.forEach((col) => {
  //   if (col.id != null) {
  //     hasOneColId = true;
  //   }
  // });
  // //一个主键都没有，新对象
  // if (hasOneColId === false) {
  //   needDelete = true;
  // }
  // // 排序有变化
  // if (!needDelete) {
  //   if (!isAscOrder(cols)) {
  //     // console.log("排序有变化", cols);
  //     needDelete = true;
  //   }
  // }
  // if (!needDelete) {
  //   // 如果导入的列的数量比数据库中的少，需要先删除。
  //   const columns = Process("models.ddic.model.column.get", {
  //     wheres: [{ column: "model_id", value: modelId }],
  //   });
  //   if (columns.length > cols.length) {
  //     needDelete = true;
  //   }
  // }
  // let needDelete = true;
  // if (needDelete) {
  // cols.forEach((col) => delete col.id);
  DeleteModelolumns(modelId);
  cols.forEach((col, idx) => (col.id = modelId * 10000 + idx));
  // }
  // 保存列清单
  const res = Process('models.ddic.model.column.EachSave', cols, {
    model_id: modelId
  });
  if (res?.code && res.message) {
    throw res;
  } else {
    return modelId;
  }
}

/**
 * 删除模型的列定义，删除ddic.model.column == model_id
 * @param {string} modelId
 * @returns
 */
function DeleteModelolumns(modelId: number) {
  const err = Process('models.ddic.model.column.DeleteWhere', {
    wheres: [{ column: 'model_id', value: modelId }]
  });
  if (err?.message) {
    throw new Exception(err.message, err.code);
  }
  // remembe to return the id in array format
  return [modelId];
}
