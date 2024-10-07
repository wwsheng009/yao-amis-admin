/**
 * 模型转换过程：
 * 模型信息输入：amisUiModel【用户输入】->amisModel【amis模型】->yaoModel【缓存】->tableMeta【数据库表结构】
 *
 * 模型信息输出：tableMeta->yaoModel->amisModel->amisUiModel
 *
 * 模型信息保存：amisModel->database
 * 模型信息读取：database->amisModel
 *
 * AmisUIModel 在前端由用户输入信息
 *
 * AmisModel 在后端保存模型的详细信息
 *
 * YaoModel Yao引擎对模型的定义
 *
 * TableMeta 数据库表的元信息，只有最少的模型信息
 */

import {
  AmisModel,
  AmisModelColumn,
  AmisModelDB,
  AmisRelation,
  AmisUIColumn,
  AmisUIModel
} from '@yao/types';
import { Exception, Process } from '@yao/yao';
import { log } from '@yao/yao';
import { ClearFalsyKeys, DotName, IsMysql, UnderscoreName } from './lib';
import { YaoModel } from '@yaoapps/types';
import { deepCopyObject } from './model_load';
import { FindCachedModelById, getCachedModelIDList } from './model_lib';

/**
 * 转换amisModel成前端显示用的模型定义。
 * @param {object} modelDsl
 */
export function amisModelToAmisUiModel(modelDsl: AmisModel): AmisUIModel {
  const model = { ...modelDsl } as unknown as AmisUIModel;

  model.header = model.header || {};
  model.columns = model.columns || [];

  model.header.id = modelDsl.id;
  model.header.identity = modelDsl.ID;
  model.header.comment = modelDsl.comment;
  model.header.name = modelDsl.name;

  if (Array.isArray(model.columns)) {
    model.columns.forEach((col) => {
      // 兼容处理,amis index字段用于表格索引,使用is_index作替代
      if (Object.prototype.hasOwnProperty.call(col, 'index')) {
        col.is_index = col.index as unknown as boolean;
        delete col.index;
      }
    });
  }
  return model;
}
/**
 * 转换Amis模型定义成数据库表
 * @param {object} modelDsl 模型定义
 * @returns
 */
export function amisModelToAmisModelDB(modelDsl: AmisModel): AmisModelDB {
  const line = {} as AmisModelDB;
  line.id = modelDsl.id;
  line.identity = DotName(modelDsl.ID);
  line.name = modelDsl.name;
  line.table_name = UnderscoreName(modelDsl.table?.name);
  line.comment = modelDsl.comment;
  line.table_comment = modelDsl.table?.comment;
  line.soft_deletes = modelDsl.option?.soft_deletes ? true : false;
  line.timestamps = modelDsl.option?.timestamps ? true : false;
  line.read_only = modelDsl.option?.read_only ? true : false;
  line.columns = modelDsl.columns.map((item) =>
    ConvertModelColToTableLine(line, item)
  );

  // 关联关系
  if (modelDsl.relations) {
    line.relations = [];
    const relations = [];
    for (const key in modelDsl.relations) {
      relations.push(UpdateRelationFromDsl(key, modelDsl.relations[key]));
    }
    line.relations = relations;
  }

  // 不是新的对象
  if (line.id !== null && line.id !== undefined) {
    return line;
  }
  // 没有ID
  // 根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  const tableName = line.table_name;
  const wheres = [];
  if (tableName) {
    wheres.push({ column: 'table_name', value: tableName });
    wheres.push({
      method: 'orwhere',
      column: 'identity',
      value: line.identity
    });
  } else {
    wheres.push({ method: 'where', column: 'identity', value: line.identity });
  }

  const [row] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {}
  });
  line.id = row?.id;
  return line;
}

function ConvertModelColToTableLine(
  model: AmisModelDB,
  modelCol: AmisModelColumn
): AmisModelColumn {
  // 复制而不是直接修改
  const col = { ...modelCol };

  // 增加模型标识，方便搜索
  col.model_identity = model.identity;

  if (!col.label) {
    col.label = col.name;
  }
  if (!col.comment && col.label) {
    col.comment = col.label;
  }
  // 转换

  const ismysql = IsMysql();
  ['index', 'nullable', 'unique', 'primary'].forEach((key) => {
    if (col[key] !== null && col[key] !== undefined) {
      if (col[key] !== false && col[key] > 0) {
        col[key] = ismysql ? 1 : true;
      } else {
        col[key] = ismysql ? 0 : false;
      }
    }
  });

  return col;
}

function UpdateRelationFromDsl(
  key: string,
  rel: YaoModel.Relation
): AmisRelation {
  const data = rel as AmisRelation;
  data.name = key;
  data.label = rel.label || key;
  data.model = rel.model;
  data.query = rel.query;
  return data;
}
/**
 * 从数据库转成到Yao模型配置
 *
 * 转换数据库中保存的模型信息到AmisModel
 *
 * scripts.system.model.ConvertTableLineToModel
 * @param {AmisModelDB} line
 * @returns
 */
export function amisModelToAmisModel(line: AmisModelDB): AmisModel {
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
    // 在界面上复制，而不是在数据库保存时复制
    // if (col.element_id) {
    //   const ele = Process('models.ddic.model.element.Find', col.element_id, {});
    //   ['type', 'length', 'scale', 'precision'].forEach((field) => {
    //     if (
    //       col[field] == null &&
    //       Object.prototype.hasOwnProperty.call(ele, field)
    //     ) {
    //       col[field] = ele[field];
    //     }
    //   });
    //   if (colNew.validations == null) {
    //     colNew.validations = ele?.validations;
    //   }

    //   if (colNew.option == null && Array.isArray(ele?.options)) {
    //     colNew.option = [];
    //     ele.options.forEach((opt) => {
    //       colNew.option.push(opt.value);
    //     });
    //   }

    //   // delete col.element_id;
    // }
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
 * 把AmisModel转换成YaoModel
 *
 * 把前端用户输入的模型信息转换成AmisModel，
 * @param {object} modelDsl
 */
export function amisUIModelToAmisModel(modelDsl: AmisUIModel): AmisModel {
  let model = { ...modelDsl } as unknown as AmisModel;
  model.id = modelDsl.header?.id;
  model.ID = modelDsl.header?.identity;
  model.comment = modelDsl.header?.comment;
  model.name = modelDsl.header?.name;

  delete model['header'];

  if (Array.isArray(model.columns)) {
    const cols = model.columns as unknown as AmisUIColumn[];
    /** ui element should the same name as the model column name,but theres is some case */
    cols.forEach((col) => {
      delete col.index;
      delete col.__index;
      // 兼容处理,amis index字段用于表格索引,使用is_index作替代
      if (Object.prototype.hasOwnProperty.call(col, 'is_index')) {
        col.index = col.is_index as unknown as number;
        delete col.is_index;
      }
    });
  }
  model = completeAmisModel(model);
  return model;
}

/**
 * 补全模型的定义
 * @param {object} modelDsl
 * @returns object
 */
export function completeAmisModel(modelDsl: AmisModel): AmisModel {
  modelDsl = modelDsl || {};
  modelDsl.table = modelDsl.table || {};
  modelDsl.option = modelDsl.option || {};
  modelDsl.columns = modelDsl.columns || [];
  modelDsl.relations = modelDsl.relations || {};

  // 如果没有ID，转换表名
  if (!modelDsl.ID?.length) {
    if (modelDsl.table?.name?.length !== 0) {
      // 名称为空
      modelDsl.ID = DotName(modelDsl.table?.name);
    }
  }
  // 如果没有表名，但是有ID
  if (modelDsl.ID?.length && !modelDsl.table?.name?.length) {
    modelDsl.table.name = modelDsl.ID;
  }
  modelDsl.table.name = UnderscoreName(modelDsl.table?.name);

  if (!modelDsl.name?.length) {
    modelDsl.name = modelDsl.table?.comment || modelDsl.comment || modelDsl.ID;
  }

  // 在导入数据时，过滤隐藏的字段
  modelDsl.columns = modelDsl.columns.filter((column) => {
    if (modelDsl.option) {
      //
      if (modelDsl.option?.timestamps) {
        if (column.name == 'updated_at' || column.name == 'created_at') {
          return false;
        }
      }
      if (modelDsl.option?.soft_deletes) {
        if (column.name == 'deleted_at') {
          return false;
        }
      }
    }
    return true;
  });
  modelDsl.columns.forEach((col, idx) => {
    // 传换成bool类型
    ['index', 'nullable', 'unique', 'primary'].forEach((key) => {
      if (col[key] !== null && col[key] !== undefined) {
        if (col[key] !== false && col[key] > 0) {
          col[key] = true;
        } else {
          col[key] = false;
        }
      }
    });
    // 非浮点类型不需要scale属性。
    const colType = col.type.toLowerCase();
    if (
      colType &&
      !colType.includes('double') &&
      !colType.includes('demical') &&
      !colType.includes('float')
    ) {
      delete col.scale;
      delete col.precision;
    }

    if (['longtext', 'json', 'text', 'mediumtext'].includes(colType)) {
      delete col.length;
    }
    if (colType == 'mediumint') {
      col.type = 'integer';
    } else if (colType == 'datetime') {
      if (col.default?.toString().indexOf('(') > -1) {
        delete col.default;
      }
    } else if (colType == 'bit') {
      col.type = 'bool';
      if (col.default == false || col.default.toString() == '0') {
        col.default = false;
      } else if (col.default == "b'1" || col.default.toString() == '1') {
        col.default = true;
      }
    } else if (colType == 'mediumblob') {
      col.type = 'binary';
    }

    if (Array.isArray(col.options) && col.options.length > 0) {
      col.option = [];
      col.options.forEach((opt) => {
        col.option.push(opt.value);
      });
    } else {
      if (col.option != null && typeof col.option === 'string') {
        try {
          col.option = JSON.parse(col.option);
        } catch (err) {
          log.Error(err);
        }
      }
      if (Array.isArray(col.option) && col.option.length > 0) {
        col.options = [];
        col.option.forEach((opt) => {
          col.options.push({
            label: opt + '',
            value: opt
          });
        });
      }
    }

    if (colType == 'boolean' && typeof col.default === 'string') {
      if (col.default.toLowerCase() == 'true') {
        col.default = true;
      } else if (col.default.toLowerCase() == 'false') {
        col.default = false;
      }
    }
    // 长度不能为字符串
    if (!col.length) {
      delete col.length;
    }
    // add the primary attribute for id field
    if (colType == 'id' || col.name.toLowerCase() == 'id') {
      if (col.primary == null) {
        col.primary = true;
      }
    }
    //fix the column datetime type and id type
    if (colType == 'datetime') {
      col.type = 'datetime';
    }
    if (colType == 'id') {
      col.type = 'id';
    }

    if (colType == 'json' && col.default != null) {
      if (col.default == '') {
        delete col.default;
      } else if (!(typeof col.default === 'object')) {
        try {
          col.default = JSON.parse(col.default);
        } catch (e) {
          delete col.default;
        }
      }
    }
    if (col.crypt == '') {
      col.crypt = undefined;
    }
    if (colType === 'phone' || colType === 'email' || colType === 'url') {
      if (col.validations == null) {
        col.validations = [];
      }
      if (col.validations.length == 0) {
        if (colType === 'url') {
          col.validations.push({
            method: 'pattern',
            args: [
              `^(https?:\/\/)?([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\/.*)*$`
            ],
            message: ' {{label}}URL地址格式不正确'
          });
        } else if (colType === 'phone') {
          col.validations.push({
            method: 'pattern',
            args: [`^[1]([3-9])[0-9]{9}$`],
            message: ' {{label}}手机号码格式不正确'
          });
        } else if (colType === 'email') {
          col.validations.push({
            method: 'pattern',
            args: [`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`],
            message: ' {{label}}邮箱地址格式不正确'
          });
        }
      }
    }
    if (!col.check_model) {
      delete col.check_model_label;
      delete col.check_model_value;
    }
    modelDsl.columns[idx] = col;
  });

  if (modelDsl.relations != null) {
    for (const r in modelDsl.relations) {
      modelDsl.relations[r].label ||= r;
    }
  }

  return modelDsl;
}

export function updateModelMetaFields(
  modelDsl: YaoModel.ModelDSL
): YaoModel.ModelDSL {
  if (!modelDsl) {
    return modelDsl;
  }
  if (!modelDsl?.columns || !Array.isArray(modelDsl?.columns)) {
    return modelDsl;
  }
  if (!modelDsl.option?.timestamps && !modelDsl.option?.soft_deletes) {
    return modelDsl;
  }
  modelDsl?.columns?.forEach((c) => {
    if (modelDsl.option?.timestamps) {
      if (c.name == 'created_at' && c.label == '::Created At') {
        c.label = '创建时间';
      } else if (c.name == 'updated_at' && c.label == '::Updated At') {
        c.label = '更新时间';
      }
    }
    if (modelDsl?.option?.soft_deletes) {
      if (c.name == 'deleted_at' && c.label == '::Deleted At') {
        c.label = '删除时间';
      }
    }
  });
  return modelDsl;
}

/**
 * Db模型转换成yao模型
 * @param {object} modelDsl
 * @returns
 */
export function amisModelToYaoModel(modelDsl: AmisModel): YaoModel.ModelDSL {
  const m = deepCopyObject(modelDsl);
  m.columns.forEach((col, idx) => {
    m.columns[idx] = convertAmisColToYaoCol(col);
  });
  if (m.option) {
    delete m.option.migrate_force;
  }
  if (m.name == m.table?.name) {
    m.name = DotName(m.table.name);
  }
  delete m.id;
  delete m.ID;

  return m;
}

/**
 * column 类型定义,把meta字段类型转换成yao模型字段类型,
 * @param {object} col
 * @returns
 */
export function convertAmisColToYaoCol(
  col: AmisModelColumn
): YaoModel.ModelColumn {
  delete col.id;
  delete col.model_id;
  delete col.element_id;
  delete col.model_identity;
  delete col.check_model_label;
  delete col.check_model_value;
  delete col.check_model_multi;
  delete col.check_model;
  delete col.options;
  delete col.language;
  delete col.is_public;

  ['index', 'nullable', 'primary', 'unique'].forEach((item) => {
    if (item in col && col[item] === false) {
      delete col[item];
    }
  });
  switch (col.type?.toLowerCase()) {
    case 'image':
    case 'video':
    case 'images':
    case 'file':
      col.type = 'longText';
      col.length = undefined;
      break;
    case 'richtext':
      col.type = 'longText';
      col.length = undefined;
      break;
    case 'url':
      col.type = 'string';
      break;
    case 'code':
      col.type = 'longText';
      col.length = undefined;
      break;
    case 'phone':
      col.type = 'string';
      break;
    case 'email':
      col.type = 'string';
      break;
    case 'color':
      col.type = 'string';
      break;
    case 'uuid':
      col.type = 'string';
      break;
    default:
      break;
  }
  return col;
}

function isTextColumn(column: AmisModelColumn) {
  const ty = column.type.toLowerCase();
  if (ty === 'string' || ty.includes('text') || ty === 'json') {
    return true;
  }
  return false;
}
/**
 * guess the column type from the name or the comment
 * @param {object} modelDsl
 * @returns
 */
export function guessModelColumnsType(modelDsl: AmisModel) {
  modelDsl.columns.forEach((column) => {
    const comment = column.comment ? column.comment.toLowerCase() : '';
    const colName = column.name ? column.name.toLowerCase() : '';
    const colType = column.type ? column.type.toLowerCase() : '';

    if (isTextColumn(column)) {
      if (comment.includes('json')) {
        column.type = 'json';
      }

      if (
        colName.includes('pic') ||
        colName.includes('image') ||
        colName.includes('img') ||
        comment.includes('图片')
      ) {
        column.type = 'image';
      } else if (
        colName.includes('pics') ||
        colName.includes('images') ||
        colName.includes('imgs') ||
        comment.includes('图片集')
      ) {
        column.type = 'images';
      }
      // else if (colName.includes("date") || comment.includes("日期")) {
      //   column.type = "date"
      // } else if (colName.includes("time") || comment.includes("时间")) {
      //   column.type = "time"
      // }
    } else {
      if (
        colType === 'integer' ||
        colType === 'tinyinteger' ||
        colType === 'tinyint'
      ) {
        if (colName.includes('status') || comment.includes('状态')) {
          column.type = 'boolean';
        }
      }
    }
  });
  return modelDsl;
}

/**
 * 更新模型，增加元数据字段如果它们不存在，
 *
 * 字段包含：创建时间，更新时间，删除时间字段。
 * @param {object} modelDsl yao模型定义
 * @returns 新的模型定义
 */
export function AddModelMetaFields(
  modelDsl: YaoModel.ModelDSL
): YaoModel.ModelDSL {
  if (modelDsl.option?.timestamps) {
    let result = modelDsl.columns?.some((item) => item.name === 'created_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'created_at',
        label: '创建时间',
        type: 'datetime'
      });
    }
    result = modelDsl.columns?.some((item) => item.name === 'updated_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'updated_at',
        label: '更新时间',
        type: 'datetime'
      });
    }
  }
  if (modelDsl.option?.soft_deletes) {
    const result = modelDsl.columns?.some((item) => item.name === 'deleted_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'deleted_at',
        label: '删除时间',
        type: 'datetime'
      });
    }
  }

  return modelDsl;
}

/**
 * 检查模型定义的完整性，Check the model dsl
 * @param {object} modelDsl model dsl
 */
export function CheckAmisModel(modelDsl: AmisModel) {
  const message = [];

  if (!modelDsl.ID || !modelDsl.ID.length) {
    message.push(`模型标识不能为空`);
  }
  if (!modelDsl.table?.name || !modelDsl.table?.name.length) {
    message.push(`数据库表名称不能为空`);
  }
  if (modelDsl.id != null) {
    const line = Process('models.ddic.model.Find', modelDsl.id, {});
    //  不存在会直接报错
    if (modelDsl.ID && modelDsl.ID != line.identity) {
      message.push(
        `模型已经存在，但是模型标识[${modelDsl.ID}]与数据库表[${line.identity}]不一致`
      );
    }
    if (modelDsl.table?.name && modelDsl.table.name != line.table_name) {
      message.push(
        `模型已经存在，但是表名称不一致，新表名${modelDsl.table?.name},已经存在${line.table_name}`
      );
    }
  }

  const cModelList = getCachedModelIDList();
  if (modelDsl.relations != null) {
    for (const key in modelDsl.relations) {
      if (Object.prototype.hasOwnProperty.call(modelDsl.relations, key)) {
        const relation = modelDsl.relations[key];
        // 有可能是自我引用
        if (relation.model != null && relation.model !== modelDsl.ID) {
          if (!cModelList.includes(relation.model)) {
            message.push(`关联模型${relation.model}不存在`);
          } else if (relation.key != null) {
            const cmodelDsl = FindCachedModelById(relation.model);
            if (cmodelDsl) {
              const col = cmodelDsl?.columns?.find(
                (c) => c.name == relation.key
              );
              if (col == null) {
                message.push(
                  `关联模型${relation.model}的字段${relation.key}不存在`
                );
              }
            }
          } else if (relation.foreign != null) {
            const col = modelDsl.columns.find((c) => c.name == relation.key);
            if (col == null) {
              message.push(`模型${modelDsl.ID}的字段${relation.foreign}不存在`);
            }
          }
        }
      }
    }
  }

  // 根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  const tableName = modelDsl.table.name;
  const wheres = [];
  wheres.push({ column: 'table_name', value: tableName });
  const [one] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {}
  });

  if (one?.id && modelDsl.id != null && one?.id != modelDsl.id) {
    message.push(
      `存在同名的表[${tableName}]，但是id不同[${modelDsl.id}]=>${one.id}`
    );
  }
  if (!Array.isArray(modelDsl.columns)) {
    message.push(`列定义应该是数组`);
  }

  if (modelDsl.columns.length == 0) {
    message.push(`不存在列定义`);
  }
  if (message.length > 0) {
    throw new Exception(message.join('\n'));
  }
}
