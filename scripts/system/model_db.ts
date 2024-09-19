// model db operations

import { IsSqlite, ClearFalsyKeys } from '@scripts/amis/lib_tool';

import { convertColTypeToYao } from '@scripts/system/col_type';

import { FileNameConvert } from '@scripts/amis/lib_tool';
import { Process, Exception, log } from '@yao/yao';
import { YaoModel } from '@yaoapps/types';
import { AmisModel, AmisRelation, YaoModelEx } from '@yao/types';

export function deepCopyObject(obj) {
  return JSON.parse(JSON.stringify(obj));
}
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
 * @param {int/string} modelId 模型ID标识
 * @returns
 */
export function getModelFromDB(modelId: string) {
  // 数字ID可能是数据库数据

  const wheres = [];
  if (checkType(modelId) === 'number') {
    wheres.push({
      method: 'where',
      column: 'id',
      value: modelId,
    });
  } else {
    wheres.push({ column: 'identity', value: modelId });
  }

  // 根据id在数据库表中查找
  const [line] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {
      columns: {},
    },
  });
  if (line != null) {
    // 数据库表信息转成模型定义
    return ConvertTableLineToModel(line);
  }
}

/**
 * 从数据库转成到Yao模型配置
 * scripts.system.model.ConvertTableLineToModel
 * @param {*} line
 * @returns
 */
export function ConvertTableLineToModel(line: AmisModel): YaoModelEx {
  let model = {
    table: {},
    option: {},
    relations: {},
    columns: [],
  } as YaoModelEx;
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

/**
 * 把模型定义加载到模型缓存中。
 * Yao中的模型定义可以保存在文件中，也可以放在别的地方，最终是加载到Yao的应用缓存中
 * @param {object} modelDsl 模型定义
 * @param {boolean} migrate 更新数据库
 * @param {boolean} force 强制更新
 * @returns
 */
export function loadModeltoMemory(
  modelDsl: YaoModel.ModelDSL,
  migrate?: boolean,
  force?: boolean,
) {
  if (!Array.isArray(modelDsl.columns) || !modelDsl.columns?.length) {
    return;
  }

  const modelYao = deepCopyObject(modelDsl) as YaoModelEx;
  modelYao.columns.forEach((col) => {
    convertColTypeToYao(col);
  });
  if (modelYao.table?.name && modelYao.ID && modelYao.columns?.length) {
    let fname = `${modelYao.ID}.mod.json`;
    fname = FileNameConvert(fname);

    // console.log("modelYao", modelYao);
    let err = Process(
      `models.${modelYao.ID}.load`,
      fname,
      JSON.stringify(modelYao),
    );
    if (!err && migrate) {
      err = migrateModel(modelYao.ID, force);
    }
    return err;
  } else {
    throw new Exception('模型定义不完整，缺少必要信息');
  }
}

function bytesToString(bytes: number[]) {
  let string = '';
  for (let i = 0; i < bytes.length; i++) {
    string += String.fromCharCode(bytes[i]);
  }
  return string;
}

export function migrateModel(modelId: string, forceIn?: boolean) {
  let force = forceIn;
  if (IsSqlite()) {
    force = true;
  }
  if (force == null) {
    force = false;
  }

  // console.log("migrate force:", force);

  if (modelId.toLowerCase().startsWith('ddic.model') && force) {
    throw new Exception(`不能删除系统模型:${modelId}`);
  }
  const err = Process(`models.${modelId}.migrate`, force);
  // console.log("migrate err:", err);
  if (err?.Message && err?.Number) {
    const sqlStateString = bytesToString(err.SQLState);

    throw new Exception(
      `Message:${err.Message},Number:${err.Number},SQLState:${sqlStateString}`,
      500,
    );
  }

  return err;
}

// module.exports = {
//   getModelFromDB,
//   ConvertTableLineToModel,
//   loadModeltoMemory,
//   deepCopyObject,
//   migrateModel,
// };
// checkType('product');
