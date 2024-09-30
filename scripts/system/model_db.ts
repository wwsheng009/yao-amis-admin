// model db operations

import { ClearFalsyKeys } from '@scripts/system/lib';
import { Process, log } from '@yao/yao';
import { AmisModelDB, AmisRelation, AmisModel, ModelId } from '@yao/types';

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
    return ConvertTableLineToModel(line);
  }
}

/**
 * 从数据库转成到Yao模型配置
 * scripts.system.model.ConvertTableLineToModel
 * @param {AmisModelDB} line
 * @returns
 */
export function ConvertTableLineToModel(line: AmisModelDB): AmisModel {
  let model = {
    table: {},
    option: {},
    relations: {},
    columns: []
  } as AmisModel;
  model.id = line.id;
  model.ID = line.identity;
  model.name = line.name;
  model.comment = line.comment;
  model.table.name = line.table_name;
  // option
  model.table.comment = line.table_comment;

  if (line.soft_deletes != null && line.soft_deletes) {
    model.option.soft_deletes = true;
  }
  if (line.timestamps != null && line.timestamps) {
    model.option.timestamps = true;
  }
  if (line.read_only != null && line.read_only) {
    model.option.read_only = true;
  }
  line.relations?.forEach((rel: AmisRelation) => {
    model.relations[rel.name] = rel;
    //
    if (typeof rel.query == 'string') {
      try {
        model.relations[rel.name].query = JSON.parse(rel.query);
      } catch (error) {
        log.Error(error.message);
        model.relations[rel.name].query = {};
      }
    }
  });
  line.columns?.forEach((col) => {
    ['index', 'nullable', 'unique', 'primary'].forEach((key) => {
      if (Object.prototype.hasOwnProperty.call(col, key)) {
        if (col[key] !== false && col[key] > 0) {
          col[key] = true;
        } else {
          col[key] = false;
        }
      }
    });
    // 复制options到option,option只保存了值列表
    if (Array.isArray(col.options) && col.option == null) {
      col.option = [];
      col.options.forEach((opt) => {
        col.option.push(opt.value);
      });
      // don't delete it
      // delete col.options;
    }

    const colNew = { ...col };
    // 如果存在模板配置，把元素配置复制过来
    if (col.element_id) {
      const ele = Process('models.ddic.model.element.Find', col.element_id, {});
      ['type', 'length', 'scale', 'precision'].forEach((field) => {
        if (
          col[field] == null &&
          Object.prototype.hasOwnProperty.call(ele, field)
        ) {
          col[field] = ele[field];
        }
      });
      if (colNew.validations == null) {
        colNew.validations = ele?.validations;
      }

      if (colNew.option == null && Array.isArray(ele?.options)) {
        colNew.option = [];
        ele.options.forEach((opt) => {
          colNew.option.push(opt.value);
        });
      }

      // delete col.element_id;
    }
    // 非浮点类型不需要scale属性。
    const type = colNew.type?.toUpperCase();
    if (
      type &&
      !type.includes('DOUBLE') &&
      !type.includes('DEMICAL') &&
      !type.includes('FLOAT')
    ) {
      delete colNew.scale;
      delete colNew.precision;
    }

    if (col.default != null && col.type == 'boolean') {
      if (col.default > 0 || col.default?.toLowerCase() == 'true') {
        colNew.default = true;
      } else {
        colNew.default = false;
      }
    }

    model.columns.push(colNew);
  });

  // 如果配置了时间戳或是软删除，不需要输出两列
  model.columns = model.columns.filter((column) => {
    if (model.option?.timestamps) {
      if (column.name == 'updated_at' || column.name == 'created_at') {
        return false;
      }
    }
    if (model.option?.soft_deletes) {
      if (column.name == 'deleted_at') {
        return false;
      }
    }
    return true;
  });

  model = ClearFalsyKeys(model);

  return model;
}
