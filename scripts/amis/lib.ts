// 在别的脚本中可以使用Require("scripts.lib")的语法引用在这里导出的函数
// 导出的函数方法有两种，一是使用es的语法格式export作函数修饰，不能使用nodejs执行。
// 二是nodejs的语法格式的module.exports = {},可以在vscode中使用nodejs执行调试。
// 建议使用第二种方法，调试处理起来会比较方便
// 代码调试：
// 使用nodejs调试时，需要把Require()转换成require()
// 使用yao run调试时，需要把module.exports或是export拿掉。

// 模型字段的详细定义查看https://yaoapps.com/doc/%E6%89%8B%E5%86%8C/Widgets/Model
// todo检查模型定义来更新字段

import {
  column2AmisTableViewColumn,
  column2AmisFormViewColumn,
  column2AmisFormEditColumn
} from '@scripts/amis/column_convert';
import { AmisModel, AmisUIColumn, ModelId } from '@yao/types';
import { Exception } from '@yao/yao';
import { YaoModel } from '@yaoapps/types';
import { getModelDslById } from '@scripts/system/model';
import { amisUIModelToAmisModel } from '@scripts/system/model_convert';

type ActionType = 'view' | 'create' | 'update';
/**
 * 读取已经加载在内存中的模型的定义,并根据传入列的类型定义更新模型定义
 *
 * 如果传入第二个参数，模型的字段定义使用此参数，
 * 此功能一般用于前端传入用户选择或是修改过的字段定义
 * @param {string} modelId 模型名称
 * @param {Array} columnsIn 字段列表字义，从前端传入
 * @returns
 */
export function getModelDefinition(
  modelId: ModelId,
  columnsIn?: AmisUIColumn[]
): AmisModel {
  // let model = Process(
  //   'scripts.system.model.getModelDslById', // 优先从数据库中加载，
  //   DotName(modelId)
  // );
  let model = getModelDslById(modelId);
  if (!model) {
    throw new Exception(`模型:${modelId}不存在`);
  } else {
    model = AddMetaFields(model);
  }
  if (Array.isArray(columnsIn) && columnsIn.length > 0) {
    const columns = columnsIn.filter((col) => col.checked === true);
    const model2 = amisUIModelToAmisModel({ columns });
    model.columns =
      model2.columns.length > 0 ? model2.columns : model.columns || [];
  } else {
    model.columns = model.columns || [];
  }

  return model;
}

/**
 * 根据模型数据更新查看页面的配置
 * @param {object} amisColumn amis字段定义
 * @param {object} column yao模型字段定义
 * @param {object} modelDsl yao模型定义
 * @returns amis字段定义
 */
function updateAmisViewColMetaFields(
  amisColumn: AmisUIColumn,
  column: YaoModel.ModelColumn,
  modelDsl: YaoModel.ModelDSL
) {
  if (column == null) {
    return amisColumn;
  }
  amisColumn.label = amisColumn.label || column.label || column.comment;
  if (modelDsl.option?.soft_deletes) {
    if (column.name == 'deleted_at') {
      amisColumn.__ignore = true; // 在表格里不需要输出
    }
  }
  if (modelDsl.option?.timestamps) {
    if (column.name == 'updated_at') {
      amisColumn.static = true;
      amisColumn.type = 'date';
    } else if (column.name == 'created_at') {
      amisColumn.static = true;
      amisColumn.type = 'date';
    }
  }
  return amisColumn;
}

/**
 * 根据模型信息更新查看页面的配置
 * @param {object} amisColumn amis字段定义
 * @param {object} column yao模型字段定义
 * @param {object} modelDsl yao模型定义
 * @returns amis字段定义
 */
function updateAmisFormMetaFields(
  amisColumn: AmisUIColumn,
  column: YaoModel.ModelColumn,
  modelDsl: YaoModel.ModelDSL,
  formType: 'view' | 'create' | 'update'
) {
  if (column == null) {
    return amisColumn;
  }

  amisColumn.label = amisColumn.label || column.label || column.comment;

  if (modelDsl.option?.soft_deletes) {
    if (column.name == 'deleted_at') {
      amisColumn.type = 'static-datetime';
      amisColumn.visibleOn = '!!this.deleted_at';
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    }
  }
  if (modelDsl.option?.timestamps) {
    if (column.name == 'updated_at') {
      amisColumn.type = 'static-datetime';
      amisColumn.visibleOn = '!!this.updated_at && this.id';
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    } else if (column.name == 'created_at') {
      amisColumn.type = 'static-datetime';
      amisColumn.visibleOn = '!!this.created_at && this.id';
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    }
  }

  // 检查是否存在外键
  // if (/.*_id/i.test(amisColumn.name)) {
  // let model_name = amisColumn.name.split("_")[0];
  if (modelDsl.relations) {
    for (const key in modelDsl.relations) {
      const rel = modelDsl.relations[key];
      if (
        rel.type == 'hasOne' &&
        amisColumn.name == rel.foreign
        // rel.model.endsWith(model_name)
      ) {
        // found
        amisColumn.clearable = true;
        amisColumn.type = 'select';
        amisColumn.searchable = true;
        amisColumn.source = `/api/v1/system/model/${rel.model}/select_options`;
        if (formType == 'view') {
          amisColumn.static = true;
        }
        break;
      }
    }
  }
  // }

  return amisColumn;
}

/**
 * 根据模型字段的定义信息更新检验报错文本
 * @param {string} text 报错文本
 * @param {object} col 模型字段定义
 * @returns 新文本
 */
function updateValidationMessage(text: string, col: { label: string }) {
  let newString = text.replace(/\{\{label\}\}/g, col.label);
  newString = newString.replace(/\{\{input\}\}/g, '${col.name}');
  return newString;
}

/**
 * 根据yao模型的字段定义更新amisForm模型定义
 * @param {object} amisColumn amis字段定义
 * @param {object} yaoColumn yao模型字段定义
 * @returns 返回更新后的amis字段定义
 */
function updateAmisFormValidations(
  amisColumn: AmisUIColumn,
  yaoColumn: YaoModel.ModelColumn
): AmisUIColumn {
  if (yaoColumn == null) {
    return amisColumn;
  }

  amisColumn.label = amisColumn.label || yaoColumn.label;

  if (Array.isArray(yaoColumn.validations) && yaoColumn.validations.length) {
    amisColumn.validations = amisColumn.validations || {};
    amisColumn.validationErrors = amisColumn.validationErrors || {};
    let regexCount = 0;
    for (const validation of yaoColumn.validations) {
      let isCheck = false;
      let validationKey = '';

      switch (validation.method) {
        case 'typeof':
          if (Array.isArray(validation.args) && validation.args.length) {
            switch (validation.args[0]) {
              case 'integer':
                validationKey = 'isInt';
                amisColumn.validations[validationKey] = true;
                isCheck = true;
                break;
              case 'number':
                validationKey = 'isNumeric';
                amisColumn.validations[validationKey] = true;
                isCheck = true;
                break;
              case 'float':
                validationKey = 'isFloat';
                amisColumn.validations[validationKey] = true;
                isCheck = true;
                break;
              // 时间用控件类型来控制
              // case "datetime":
              //   amisColumn.validations["isFloat"] = true;
              //   break;
              // case "string, integer, float, number, datetime, timestamp,bool":
              default:
                break;
            }
          }
          break;
        case 'mobile':
          validationKey = 'isTelNumber';
          amisColumn.validations[validationKey] = true;
          isCheck = true;
          break;
        case 'email':
          validationKey = 'isEmail';
          amisColumn.validations[validationKey] = true;
          isCheck = true;
          break;
        case 'min':
          if (Array.isArray(validation.args) && validation.args.length) {
            validationKey = 'minimum';
            amisColumn.validations[validationKey] = validation.args[0];
            isCheck = true;
          }
          break;
        case 'max':
          if (Array.isArray(validation.args) && validation.args.length) {
            validationKey = 'maximum';
            amisColumn.validations[validationKey] = validation.args[0];
            isCheck = true;
          }
          break;
        case 'minLength':
          if (Array.isArray(validation.args) && validation.args.length) {
            validationKey = 'minLength';
            amisColumn.validations[validationKey] = validation.args[0];
            isCheck = true;
          }
          break;
        case 'maxLength':
          if (Array.isArray(validation.args) && validation.args.length) {
            validationKey = 'maxLength';
            amisColumn.validations[validationKey] = validation.args[0];
            isCheck = true;
          }
          break;
        case 'pattern':
          if (Array.isArray(validation.args) && validation.args.length) {
            validationKey = 'matchRegexp';
            if (regexCount > 0) {
              validationKey = `matchRegexp${regexCount}`;
            }
            amisColumn.validations[validationKey] = validation?.args[0] || '';
            regexCount += 1;
            isCheck = true;
          }
          break;
        default:
          break;
      }
      if (isCheck === true) {
        amisColumn.validationErrors[validationKey] = updateValidationMessage(
          validation.message,
          yaoColumn
        );
      }
    }
    if (Object.keys(amisColumn.validations).length == 0) {
      delete amisColumn.validations;
    }
    if (Object.keys(amisColumn.validationErrors).length == 0) {
      delete amisColumn.validationErrors;
    }
  }
  return amisColumn;
}

/**
 * 读取一个表的所有字段列表
 * 注意：这个功能并不一定适用于官方版本的yao,在字段的处理器是有经过增强处理的
 * @param {string} modelId 数据库表或是模型名
 * @param {Array} columnsIn 传入的模型字段列表字义,可以从前端界面上传入
 * @returns
 */
export function getModelFieldsForAmis(
  modelId: ModelId,
  columnsIn?: AmisUIColumn[]
) {
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model.columns;
  // 从模型定义中获取数据

  const schemas = [];
  columns.forEach((column) => {
    let col = column2AmisTableViewColumn(column);
    col = updateAmisViewColMetaFields(col, column, model);

    if (col.__ignore !== true) {
      col.__ignore = undefined;
      schemas.push(col);
    }
  });

  return schemas;
}

/**
 * 更新模型，增加元数据字段如果它们不存在，
 *
 * 字段包含：创建时间，更新时间，删除时间字段。
 * @param {object} modelDsl yao模型定义
 * @returns 新的模型定义
 */
function AddMetaFields(modelDsl2: YaoModel.ModelDSL): AmisModel {
  const modelDsl = modelDsl2 as AmisModel;
  if (modelDsl.option?.timestamps) {
    let result = modelDsl.columns?.some((item) => item.name === 'created_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'created_at',
        label: '创建时间',
        static: true,
        type: 'datetime',
        format: 'YYYY-MM-DD HH:mm:ss'
      });
    }
    result = modelDsl.columns?.some((item) => item.name === 'updated_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'updated_at',
        label: '更新时间',
        static: true,
        type: 'datetime',
        format: 'YYYY-MM-DD HH:mm:ss'
      });
    }
  }
  if (modelDsl.option?.soft_deletes) {
    const result = modelDsl.columns?.some((item) => item.name === 'deleted_at');
    if (!result) {
      modelDsl.columns.push({
        name: 'deleted_at',
        label: '删除时间',
        static: true,
        type: 'datetime',
        format: 'YYYY-MM-DD HH:mm:ss'
      });
    }
  }

  return modelDsl;
}

/**
 * 获取模型的关联查询的定义withUrl定义
 * @param {string} modelId 模型标识
 * @returns
 */
export function getWithsUrl(modelId: ModelId) {
  const model = getModelDefinition(modelId, null);
  if (model.relations) {
    return `with=${Object.keys(model.relations).join(',')}`;
  }
}

/**
 *  模型对应的表单显示界面配置
 *
 *  yao run scripts.amis.lib.getFormViewFields
 * @param {*} modelId
 * @param {*} columnsIn
 * @param {*} noRelation 模型之间有可能是相互关联，设置成true,避免递归
 * @returns
 */
export function getFormViewFields(
  modelId: ModelId,
  columnsIn?: AmisUIColumn[],
  noRelation?: boolean
) {
  // 模型定义
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model.columns;
  const schemaColumns = [] as AmisUIColumn[];
  columns.forEach((column) => {
    let col = column2AmisFormViewColumn(column);
    col = updateAmisFormMetaFields(col, column, model, 'view');
    schemaColumns.push({ ...col });
  });
  // 避免递归
  if (!noRelation) {
    updateFormRelations(schemaColumns, model, 'view');
  }
  return schemaColumns;
}

/**
 * 更新表单中的模型关联关系
 * @param {Array} columns form schema
 * @param {object} model modelDsl object
 * @param {ActionType} actionType
 * @returns
 */
function updateFormRelations(
  columns: AmisUIColumn[],
  model: AmisModel,
  actionType: ActionType
) {
  const hasOnes = {} as { [key: string]: YaoModel.Relation };
  const hasManys = {} as { [key: string]: YaoModel.Relation };
  if (model.relations) {
    for (const key in model.relations) {
      if (Object.hasOwnProperty.call(model.relations, key)) {
        const element = model.relations[key];
        if (element.type === 'hasOne') {
          hasOnes[key] = element;
        } else if (element.type === 'hasMany') {
          hasManys[key] = element;
        }
      }
    }
  }
  for (const key in hasOnes) {
    const element = hasOnes[key];
    const label = element.label || key;
    let fields = [];
    if (actionType == 'view') {
      fields = getFormViewFields(element.model, null, true);
    } else {
      fields = getFormFields(element.model, actionType, null, null, true);
    }
    fields = fields.filter((col) => col.name !== element.key);
    columns.push({
      visibleOn: `typeof this.${key} == 'object' && Object.keys(this.${key}).length > 0`,
      type: 'input-sub-form',
      name: key,
      label: label,
      btnLabel: '明细',
      form: {
        // body: {
        //   type: "service",
        //   schemaApi: `get:/api/v1/system/schema/${element.model}/form-edit`,
        // },
        body: fields
      }
    });
  }

  const tabList = [];
  for (const key in hasManys) {
    const element = hasManys[key];
    const label = element.label || key;
    let fields = [];
    let tableSchema = {};
    if (actionType === 'view') {
      fields = getModelFieldsForAmis(element.model, null);
      fields = fields.filter((col) => col.name !== element.key);

      tableSchema = {
        visibleOn: `Array.isArray(this.${key})`,
        columns: fields,
        source: '${' + key + '}',
        type: 'table'
      };
    } else {
      fields = getModelFieldsWithQuick(element.model, null);
      fields = fields.filter((col) => col.name !== element.key);

      tableSchema = {
        labelClassName: 'hidden',
        columns: fields,
        name: key,
        source: '${' + key + '}',
        copyable: true,
        editable: true,
        removable: true,
        showIndex: true,
        addable: true,
        type: 'input-table'
      };
    }
    const tab = {
      title: label,
      body: tableSchema
    };
    tabList.push(tab);
  }
  // console.log("tabList", tabList)
  // 多个就使用页签显示，一个就直接显示表格
  if (tabList.length > 1) {
    const tabs = {
      label: '关联表',
      type: 'static-tabs',
      swipeable: true,
      tabs: []
    };

    for (const tab of tabList) {
      tabs.tabs.push(tab);
    }
    columns.push(tabs);
  } else if (tabList.length == 1) {
    const table = tabList[0].body;
    delete table.labelClassName;
    table.label = tabList[0].title;
    if (actionType === 'view') {
      table.type = 'static-table';
    }
    columns.push(table);
  }
  return columns;
}
/**
 * 转换表字段清单成amis的form schema
 * @param {string} modelId modelId
 * @param {string} actionType 'create' 'view' 'update' 'filter'
 * @param {Array} columnsIn array of column
 * @param {Array} excludeFields
 * @param {boolean}noRelation 模型之间有可能是相互关联，设置成true,避免递归
 * @returns
 */
export function getFormFields(
  modelId: ModelId,
  actionType: ActionType,
  columnsIn?: AmisUIColumn[],
  excludeFields?: string[],
  noRelation: boolean = false
) {
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model.columns;

  const formType = actionType ? actionType.toLowerCase() : 'view';
  let outputCols = [];

  for (const column of columns) {
    let output = true;
    let col = column2AmisFormEditColumn(column);

    // form表单字段在不同的场景下有不同的展现方式。
    switch (formType) {
      case 'view':
        if (col.isID || col.displayOnly) {
          col.static = true;
        }
        break;
      case 'update':
        if (col.isID || col.displayOnly) {
          col.static = true;
        }
        if (col.type.toLowerCase() == 'uuid') {
          col.type = 'static-text';
          col.static = true;
        }
        break;
      case 'create':
        //创建数据时，不需要输出id字段。
        if (col.isID) {
          output = false;
        }
        break;
      default:
        break;
    }
    if (!output) {
      continue;
    }
    col = updateAmisFormValidations(col, column);
    col = updateAmisFormMetaFields(col, column, model, actionType);
    delete col.isID;
    outputCols.push({ ...col });
  }
  if (Array.isArray(excludeFields)) {
    excludeFields.forEach((exclude) => {
      outputCols = outputCols.filter(
        (col) => col.name.toLowerCase() !== exclude.toLowerCase()
      );
    });
  }
  if (!noRelation) {
    updateFormRelations(outputCols, model, actionType);
  }

  return outputCols;
}

// 转换表字段清单成amis的form filter
export function getFilterFormFields(
  modelId: ModelId,
  columnsIn?: AmisUIColumn[]
) {
  // 从数据库表中获取定义
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model?.columns || [];

  const schemas = [];
  for (const column of columns) {
    let col = column2AmisFormEditColumn(column);
    col = updateAmisFormValidations(col, column);
    col = updateAmisFormMetaFields(col, column, model, 'update');

    if (col.isID) {
      col.type = 'input-number';
    }

    // 筛选框不强制输入
    delete col.required;

    let output = true;

    if (column.crypt?.toUpperCase() === 'PASSWORD') {
      output = false;
    }
    switch (column.type?.toLowerCase()) {
      case 'editor':
      case 'richtext':
      case 'video':
      case 'file':
      case 'image':
      case 'json':
      case 'images':
        output = false;
        break;
    }
    switch (col.type?.toLowerCase()) {
      case 'editor':
        output = false;
        break;
      default:
        break;
    }
    if (output) {
      delete col.isID;
      schemas.push({ ...col });
    }
  }

  return schemas;
}

/**
 * 根据数据库表的定义生成amis crud页面中的列表字段定义，字段定义会带有快捷编辑功能。
 * @param {string} modelId 数据库表名
 * @returns
 */
export function getModelFieldsWithQuick(
  modelId: ModelId,
  columnsIn?: AmisUIColumn[]
) {
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model?.columns || [];
  // yao的原始字段设置
  const newFields = [];
  for (const column of columns) {
    let formColumn = column2AmisFormEditColumn(column);
    let label = column.label;

    formColumn = updateAmisFormValidations(formColumn, column);
    formColumn = updateAmisFormMetaFields(formColumn, column, model, 'create');

    let viewColumn = column2AmisTableViewColumn(column);
    viewColumn = updateAmisViewColMetaFields(viewColumn, column, model);
    if (viewColumn.__ignore) {
      viewColumn.__ignore = undefined;
      continue;
    }

    const noQuickEdit =
      formColumn.displayOnly ||
      formColumn.isID ||
      viewColumn.isID ||
      formColumn.type.toLowerCase() == 'uuid';
    delete formColumn.displayOnly;

    label = viewColumn.label;
    delete formColumn.name;
    delete formColumn.label;
    delete formColumn.isID;
    delete viewColumn.isID;
    viewColumn.label = label;

    const fieldNew = {
      name: column.name,
      label: column.label,
      quickEdit: {
        ...formColumn,
        saveImmediately: true
      },
      ...viewColumn
    };
    if (fieldNew.displayOnly || noQuickEdit) {
      fieldNew.quickEdit = false;
      delete fieldNew.displayOnly;
    }
    if (model.option?.timestamps) {
      if (column.name == 'updated_at' || column.name == 'created_at') {
        fieldNew.quickEdit = false;
      }
    }
    // 不需要弹出快速编辑
    if (model.option?.soft_deletes && column.name == 'deleted_at') {
      fieldNew.quickEdit = false;
    }
    newFields.push(fieldNew);
  }
  return newFields;
}

/**
 * 根据表的定义生成一个excel mapping定义，用户再根据自己的需要进行修改
 * @param {string} modelId 数据库表名
 * @returns 字段定义
 */
export function excelMapping(modelId: ModelId, columnsIn?: AmisUIColumn[]) {
  const model = getModelDefinition(modelId, columnsIn);
  const columns = model?.columns;

  // const schema = getTableSchema(tableName);
  // const columns = schema.columns;
  const obj = {};
  columns.forEach((column) => {
    const type = column.type.toUpperCase();
    let ignore = false;
    switch (type) {
      // 自增长的不要
      case 'ID':
      case 'TINYINCREMENTS':
      case 'SMALLINCREMENTS':
      case 'INCREMENTS':
        ignore = true;
        break;
      default:
        break;
    }
    if (column.name === 'deleted_at' && model.option?.soft_deletes) {
      ignore = true;
    } else if (column.name === 'created_at' && model.option?.timestamps) {
      ignore = true;
    } else if (column.name === 'updated_at' && model.option?.timestamps) {
      ignore = true;
    }
    if (!ignore) {
      obj[column.name] = '${' + column.name + '}';
    }
  });
  return obj;

  // try {
  //   const setting = Process("yao.table.Setting", tableName);
  //   const columns = setting.table.columns;

  //   //yao的原始字段设置
  //   const fields = setting.fields.table;
  //   let obj = {};
  //   columns.forEach((column) => {
  //     let field = fields[column.name];
  //     if (field && field.bind.toLowerCase() !== "id") {
  //       obj[field.bind] = "${" + field.bind + "}";
  //     }
  //   });
  //   return obj;
  // } catch (error) {
  //   return {};
  // }
}

export function getPrimaryField(modelId: ModelId, columnsIn?: AmisUIColumn[]) {
  const model = getModelDefinition(modelId, columnsIn);

  if (!model || !Array.isArray(model.columns)) {
    return 'id';
  }
  for (const col of model.columns) {
    if (col.primary) {
      return col.name;
    }
    const colType = col.type.toLowerCase();
    switch (colType) {
      // 自增长的不要
      case 'ID':
      case 'TINYINCREMENTS':
      case 'SMALLINCREMENTS':
      case 'INCREMENTS':
        return col.name;
        break;
      default:
        break;
    }
  }
  return 'id';
}
