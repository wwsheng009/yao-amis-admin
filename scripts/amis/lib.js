//在别的脚本中可以使用Require("scripts.lib")的语法引用在这里导出的函数
//导出的函数方法有两种，一是使用es的语法格式export作函数修饰，不能使用nodejs执行。
//二是nodejs的语法格式的module.exports = {},可以在vscode中使用nodejs执行调试。
//建议使用第二种方法，调试处理起来会比较方便
//代码调试：
//使用nodejs调试时，需要把Require()转换成require()
//使用yao run调试时，需要把module.exports或是export拿掉。

//模型字段的详细定义查看https://yaoapps.com/doc/%E6%89%8B%E5%86%8C/Widgets/Model
//todo检查模型定义来更新字段

const { DotName, UnderscoreName, IsMysql } = Require("amis.lib_tool");

const Exception = Error;

// /**
//  * 获得默认连接中的数据表的列定义
//  * @param {数据库表名} tableName string
//  * @returns object
//  */
// function getTableSchema(tableName) {
//   const schema = Process("schemas.default.TableGet", UnderscoreName(tableName));
//   return schema;
// }

// function ColumnArrayToMap(columns) {
//   if (!Array.isArray(columns)) {
//     return {};
//   }
//   let columMap = {};
//   if (Array.isArray(columns)) {
//     for (const column of columns) {
//       columMap[column.name] = column;
//     }
//   }
//   columMap;
// }
/**
 * 读取已经加载在内存中的模型的定义
 * @param {string} modelName 模型名称
 * @returns
 */
function getModelDefinition(modelName, columnsIn) {
  let model = Process(
    "scripts.system.model.getModelById", //优先从数据库中加载，
    DotName(modelName)
  );
  if (!model) {
    throw new Exception(`模型:${modelName}不存在`);
  }
  if (columnsIn != null && Array.isArray(columnsIn) && columnsIn.length > 0) {
    const columns = columnsIn.filter((col) => col.checked === true);
    model.columns = columns.length > 0 ? columns : model.columns || [];
  } else {
    model.columns = model.columns || [];
  }

  model = AddMetaFields(model);
  return model;
}

/**
 * 根据模型字段的定义信息更新检验报错文本
 * @param {string} text 报错文本
 * @param {object} col 模型字段定义
 * @returns 新文本
 */
function updateMessage(text, col) {
  let newString = text.replace(/\{\{label\}\}/g, col.label);
  newString = newString.replace(/\{\{input\}\}/g, "${col.name}");

  return newString;
}

/**
 * 根据模型数据更新查看页面的配置
 * @param {object} amisColumn amis字段定义
 * @param {object} column yao模型字体定义
 * @returns amis字段定义
 */
function updateViewColFromModel(amisColumn, column, modelDsl) {
  if (column == null) {
    return amisColumn;
  }

  amisColumn.label = amisColumn.label || column.label || column.comment;

  if (modelDsl.option?.soft_deletes) {
    //
    if (column.name == "deleted_at") {
      amisColumn.__ignore = true; //在表格里不需要输出
    }
  }
  if (modelDsl.option?.timestamps) {
    if (column.name == "updated_at") {
      amisColumn.static = true;
      amisColumn.type = "date";
    } else if (column.name == "created_at") {
      amisColumn.static = true;
      amisColumn.type = "date";
    }
  }
  return amisColumn;
}

/**
 * 根据模型数据更新查看页面的配置
 * @param {object} amisColumn amis字段定义
 * @param {object} column 系统模型列定义
 * @param {object} modelDsl 系统模型定义
 * @returns amis字段定义
 */
function updateFormColCommon(amisColumn, column, modelDsl) {
  if (column == null) {
    return amisColumn;
  }

  amisColumn.label = amisColumn.label || column.label || column.comment;

  if (modelDsl.option?.soft_deletes) {
    if (column.name == "deleted_at") {
      amisColumn.type = "static-datetime";
      amisColumn.visibleOn = "!!this.deleted_at";
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    }
  }
  if (modelDsl.option?.timestamps) {
    if (column.name == "updated_at") {
      amisColumn.type = "static-datetime";
      amisColumn.visibleOn = "!!this.updated_at";
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    } else if (column.name == "created_at") {
      amisColumn.type = "static-datetime";
      amisColumn.visibleOn = "!!this.created_at";
      if (amisColumn.required != null) {
        delete amisColumn.required;
      }
    }
  }

  // 检查是否存在外键
  if (/.*_id/i.test(amisColumn.name)) {
    // let model_name = amisColumn.name.split("_")[0];
    if (modelDsl.relations) {
      for (const key in modelDsl.relations) {
        const rel = modelDsl.relations[key];
        if (
          rel.type == "hasOne" &&
          rel.foreign == amisColumn.name
          // rel.model.endsWith(model_name)
        ) {
          // found
          amisColumn.type = "select";
          amisColumn.source = `/api/v1/table/data/${rel.model}/select_options`;
        }
      }
    }
  }

  return amisColumn;
}
/**
 * 根据yao模型的字段定义更新amisForm模型定义
 * @param {object} amisColumn amis字段定义
 * @param {object} modelColumn yao模型字体定义
 * @returns 返回更新后的amis字段定义
 */
function updateFormColFromModel(amisColumn, modelColumn) {
  if (modelColumn == null) {
    return amisColumn;
  }

  amisColumn.label = amisColumn.label || modelColumn.label;

  const type = modelColumn.type.toUpperCase();
  if (type == "JSON" || type == "JSONB") {
    amisColumn.type = "editor";
    amisColumn.language = "json";
  }

  if (modelColumn.validations && modelColumn.validations.length) {
    amisColumn.validations = amisColumn.validations || {};
    amisColumn.validationErrors = amisColumn.validationErrors || {};
    let regexCount = 0;
    for (const validation of modelColumn.validations) {
      let isCheck = false;
      let validationKey = "";

      switch (validation.method) {
        case "typeof":
          switch (validation.args[0]) {
            case "integer":
              validationKey = "isInt";
              amisColumn.validations[validationKey] = true;
              isCheck = true;
              break;
            case "number":
              validationKey = "isNumeric";
              amisColumn.validations[validationKey] = true;
              isCheck = true;
              break;
            case "float":
              validationKey = "isFloat";
              amisColumn.validations[validationKey] = true;
              isCheck = true;
              break;
            //时间用控件类型来控制
            // case "datetime":
            //   amisColumn.validations["isFloat"] = true;
            //   break;
            // case "string, integer, float, number, datetime, timestamp,bool":
            default:
              break;
          }
          break;
        case "mobile":
          validationKey = "isTelNumber";
          amisColumn.validations[validationKey] = true;
          isCheck = true;
          break;
        case "email":
          validationKey = "isEmail";
          amisColumn.validations[validationKey] = true;
          isCheck = true;
          break;
        case "min":
          validationKey = "minimum";
          amisColumn.validations[validationKey] = validation.args[0];
          isCheck = true;
          break;
        case "max":
          validationKey = "maximum";
          amisColumn.validations[validationKey] = validation.args[0];
          isCheck = true;
          break;
        case "minLength":
          validationKey = "minLength";
          amisColumn.validations[validationKey] = validation.args[0];
          isCheck = true;
          break;
        case "maxLength":
          validationKey = "maxLength";
          amisColumn.validations[validationKey] = validation.args[0];
          isCheck = true;
          break;
        case "pattern":
          validationKey = "matchRegexp";
          if (regexCount > 0) {
            validationKey = `matchRegexp${regexCount}`;
          }
          amisColumn.validations[validationKey] = validation.args[0];
          regexCount += 1;
          isCheck = true;
          break;
        default:
          break;
      }
      if (isCheck === true) {
        amisColumn.validationErrors[validationKey] = updateMessage(
          validation.message,
          modelColumn
        );
      }
    }
    if (Object.keys(amisColumn.validations) == 0) {
      delete amisColumn.validations;
    }
    if (Object.keys(amisColumn.validationErrors) == 0) {
      delete amisColumn.validationErrors;
    }
  }
  return amisColumn;
}

function getFormDefinition(tableName) {
  return {};
  try {
    //模型对应的table定义可能不存在
    const setting = Process("yao.form.Setting", tableName);
    const columns = (setting.form && setting.form.sections[0].columns) || [];
    const fields = (setting.fields && setting.fields.form) || {};
    let fieldsNew = {};
    columns.forEach((column) => {
      let key = "";
      let field = fields[column.name];

      if (field) {
        if (field.bind) {
          key = field.bind;
        } else if (field.view && field.view.bind) {
          key = field.view.bind;
        } else if (field.edit && field.edit.bind) {
          key = field.edit.bind;
        }
      }
      if (key && key.length) {
        fieldsNew[key] = { ...field };
        fieldsNew[key] = {} || fieldsNew[key];
        fieldsNew[key].label = column.name;
        fieldsNew[key].name = key;
        fieldsNew[key].width = column.width;
        // console.log("fieldsNew:", key, fieldsNew[key]);
      }
    });
    return fieldsNew;
  } catch (error) {
    return {};
  }
}

function getTableDefinition(tableName) {
  return {};
  try {
    //模型对应的table定义可能不存在
    const setting = Process("yao.table.Setting", tableName);
    const columns = (setting.table && setting.table.columns) || [];
    const fields = (setting.fields && setting.fields.table) || {};
    let fieldsNew = {};
    columns.forEach((column) => {
      let key = "";
      let field = fields[column.name];

      if (field) {
        if (field.bind) {
          key = field.bind;
        } else if (field.view && field.view.bind) {
          key = field.view.bind;
        } else if (field.edit && field.edit.bind) {
          key = field.edit.bind;
        }
      }
      if (key && key.length) {
        fieldsNew[key] = { ...field };
        fieldsNew[key] = {} || fieldsNew[key];
        fieldsNew[key].label = column.name;
        fieldsNew[key].name = key;
        fieldsNew[key].width = column.width;
        // console.log("fieldsNew:", key, fieldsNew[key]);
      }
    });
    return fieldsNew;
  } catch (error) {
    return {};
  }
}

function getFormViewFields(tableName, columnsIn) {
  // 模型定义
  const model = getModelDefinition(tableName, columnsIn);
  const columns = model.columns;
  let schemas = [];
  columns.forEach((column) => {
    let col = column2AmisFormViewColumn(column);
    col = updateFormColCommon(col, column, model);
    delete col.displayOnly;
    schemas.push(col);
  });
  return schemas;
}
/**
 * 读取一个表的所有字段列表
 * 注意：这个功能并不一定适用于官方版本的yao,在字段的处理器是有经过增强处理的
 * @param {string} tableName 数据库表或是模型名
 * @returns
 */
function getTableFields(tableName, columnsIn) {
  let model = getModelDefinition(tableName, columnsIn);
  const columns = model.columns;
  //从模型定义中获取数据

  let schemas = [];
  columns.forEach((column) => {
    let { newColumn: col } = column2AmisTableViewColumn(column);
    col = updateViewColFromModel(col, column, model);

    if (col.__ignore !== true) {
      schemas.push(col);
    }
  });

  return schemas;
}

/**
 * 更新模型，增加元数据字段
 * @param {object} model 模型
 * @returns
 */
function AddMetaFields(model) {
  if (model.option?.timestamps) {
    let result = model.columns?.some((item) => item.name === "created_at");
    if (!result) {
      model.columns.push({
        name: "created_at",
        label: "创建时间",
        static: true,
        type: "datetime",
        format: "YYYY-MM-DD HH:mm:ss",
      });
    }
    result = model.columns?.some((item) => item.name === "updated_at");
    if (!result) {
      model.columns.push({
        name: "updated_at",
        label: "更新时间",
        static: true,
        type: "datetime",
        format: "YYYY-MM-DD HH:mm:ss",
      });
    }
  }
  if (model.option?.soft_deletes) {
    const result = model.columns?.some((item) => item.name === "deleted_at");
    if (!result) {
      model.columns.push({
        name: "deleted_at",
        label: "删除时间",
        static: true,
        type: "datetime",
        format: "YYYY-MM-DD HH:mm:ss",
      });
    }
  }

  return model;
}

//转换表字段清单成amis的form schema
function getFormFields(tableName, columnsIn, excludeFields) {
  let model = getModelDefinition(tableName, columnsIn);
  const columns = model.columns;

  let schemas = [];
  for (const column of columns) {
    let col = column2AmisFormItem(column);
    // if (col.isID) {
    //   continue;
    // }

    col = updateFormColFromModel(col, column);
    col = updateFormColCommon(col, column, model);

    schemas.push(col);
  }
  if (Array.isArray(excludeFields)) {
    excludeFields.forEach((exclude) => {
      schemas = schemas.filter((col) => col.name !== exclude);
    });
  }
  return schemas;
}

//转换表字段清单成amis的form filter
function getFilterFormFields(tableName, columnsIn) {
  //从数据库表中获取定义
  // const schema = getTableSchema(tableName);
  // const columns = schema.columns;
  const model = getModelDefinition(tableName, columnsIn);
  const columns = model?.columns || [];

  let schemas = [];
  for (const column of columns) {
    let col = column2AmisFormItem(column);
    col = updateFormColFromModel(col, column);
    col = updateFormColCommon(col, column, model);

    if (col.isID) {
      col.type = "input-number";
    }
    delete col.isID;
    //筛选框不强制输入
    delete col.required;

    if (col.type === "editor") {
      continue;
    }
    schemas.push(col);
  }

  return schemas;
}

/**
 * 根据数据库表的定义生成amis crud页面中的列表字段定义，字段定义会带有快捷编辑功能。
 * @param {string} tableName 数据库表名
 * @returns
 */
function getTableFieldsWithQuick(tableName, columnsIn) {
  let model = getModelDefinition(tableName, columnsIn);
  const columns = model?.columns || [];
  //yao的原始字段设置
  let newFields = [];
  for (const column of columns) {
    let { newColumn: viewColumn, displayOnly } =
      column2AmisTableViewColumn(column);
    let formColumn = column2AmisFormItem(column);
    let label = column.label;

    formColumn = updateFormColFromModel(formColumn, column);
    formColumn = updateFormColCommon(formColumn, column, model);
    if (formColumn.isID) {
      formColumn.quickEdit = false;
      delete formColumn.isID;
    }
    viewColumn = updateViewColFromModel(viewColumn, column, model);
    if (viewColumn.__ignore) {
      continue;
    }

    label = viewColumn.label;
    delete formColumn.name;
    delete formColumn.label;
    viewColumn.label = label;

    let fieldNew = {
      searchable: true,
      sortable: true,
      name: column.name,
      label: column.label,
      quickEdit: {
        ...formColumn,
        saveImmediately: true,
      },
      ...viewColumn,
    };
    delete fieldNew.static;
    if (displayOnly) {
      fieldNew.quickEdit = false;
    }
    if (model.option?.timestamps) {
      if (column.name == "updated_at" || column.name == "created_at") {
        fieldNew.quickEdit = false;
      }
    }
    // 不需要弹出快速编辑
    if (model.option?.soft_deletes && column.name == "deleted_at") {
      fieldNew.quickEdit = false;
    }
    newFields.push(fieldNew);
  }
  return newFields;
}
/**
 * 转换一个数据库表的列定义成amis form item定义，主要用于数据编辑
 * @param {object} column 数据库表列定义
 * @returns amis form item 定义
 */
function column2AmisFormItem(column) {
  const name = column.name.toUpperCase();
  let newColumn = {};
  newColumn.name = column.name;
  newColumn.label = column.label;

  // 必填项
  if (column.primary !== true) {
    if (
      //不为空且没有默认值
      column.nullable !== true &&
      (column.default === null || column.default === undefined)
    ) {
      newColumn.required = true;
    } else if (column.unique === true || column.index === true) {
      //唯值一或是索引
      newColumn.required = true;
    }
  }
  if (column.default != null) {
    newColumn.value = column.default;
  }

  newColumn.type = "input-text";
  const type = column.type.toUpperCase();
  switch (type) {
    case "STRING":
    case "CHAR":
      newColumn.type = "input-text";
      if (column.length) {
        newColumn.maxLength = column.length;
      }
      break;
    case "TEXT":
    case "MEDIUMTEXT":
    case "LONGTEXT":
      newColumn.type = "textarea";
      if (column.length) {
        newColumn.maxLength = column.length;
      }
      break;
    case "JSON":
    case "JSONB":
      newColumn.type = "editor";
      newColumn.language = "json";
      if (column.length) {
        newColumn.maxLength = column.length;
      }
      break;
    case "DATE":
      newColumn.type = "input-date";
      newColumn.format = "YYYY-MM-DD";
      break;
    case "DATETIME":
      newColumn.type = "input-datetime";
      newColumn.format = "YYYY-MM-DD HH:mm:ss";
      break;
    case "DATETIMETZ":
      newColumn.type = "input-datetime";
      newColumn.format = "YYYY-MM-DDTHH:mm:ssZ";
      break;
    case "TIME":
      newColumn.type = "input-time";
      newColumn.format = "HH:mm:ss";
      break;
    case "TIMETZ":
      newColumn.type = "input-time";
      newColumn.format = "HH:mm:ssZ";
      break;
    case "TIMESTAMP":
    case "TIMESTAMPTZ":
      newColumn.type = "input-datetime";
      break;
    case "TINYINTEGER":
    case "SMALLINTEGER":
    case "INTEGER":
    case "BIGINTEGE":
      newColumn.type = "input-number";
      break;
    case "UNSIGNEDTINYINTEGER":
    case "UNSIGNEDSMALLINTEGER":
    case "UNSIGNEDINTEGER":
      newColumn.type = "input-number";
      newColumn.min = 0;
      break;
    case "UNSIGNEDBIGINTEGER":
      newColumn.type = "input-number";
      newColumn.min = 0;
      newColumn.big = true;
      break;
    case "ID":
    case "TINYINCREMENTS":
    case "SMALLINCREMENTS":
    case "INCREMENTS":
      // 自增长的类型不应该手工输入
      newColumn.type = "input-number"; //"input-number";
      newColumn.isID = true;
      // 自增不需要手动输入
      delete newColumn.required;
      break;
    case "BIGINCREMENTS":
      newColumn.type = "input-number";
      newColumn.big = true;
      break;
    case "FLOAT":
    case "DOUBLE":
    case "DEMICAL":
      newColumn.type = "input-number";
      newColumn.precision = column.precision;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "UNSIGNEDFLOAT":
    case "UNSIGNEDDOUBLE":
    case "UNSIGNEDDECIMAL":
      newColumn.type = "input-number";
      newColumn.precision = column.precision;
      newColumn.min = 0;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "BOOLEAN":
      newColumn.type = "switch";
      //if is mysql
      if (IsMysql()) {
        newColumn.trueValue = 1;
        newColumn.falseValue = 0;
      }
      break;
    case "UUID":
      newColumn.type = "uuid";
      break;
    case "ENUM":
      newColumn.type = "select";
      if (
        column.options != null &&
        Array.isArray(column.options) &&
        column.options.length
      ) {
        newColumn.options = column.options;
      } else {
        let options =
          column.option &&
          column.option.map((option) => {
            return {
              label: option,
              value: option,
            };
          });
        newColumn.options = options;
      }

      break;
    default:
      break;
  }
  //布尔
  if (
    type === "TINYINTEGER" &&
    (column.default === 0 || column.default === 1)
  ) {
    newColumn.type = "switch";
    if (IsMysql()) {
      newColumn.trueValue = 1;
      newColumn.falseValue = 0;
    }
  }
  //只是只一个猜测
  if (name.includes("PASSWORD")) {
    newColumn.type = "input-password";
  }
  if (name.includes("EMAIL")) {
    newColumn.type = "input-email";
    // newColumn.validations = newColumn.validations || {};
    // newColumn.validations.isEmail = true;
  }
  return newColumn;
}

/**
 * 根据表字段定义转换成amis table表列定义
 *
 * @param {object} column 数据库表列定义
 * @returns 返回amis formitem定义
 */
function column2AmisTableViewColumn(column) {
  // 只读字段的处理有两种方式，一种是使用static-类控件，
  // 另外一种是使用input-控件再加上static属性进行组合控制
  // 哪种更好需要测试后才知道
  const name = column.name.toUpperCase();
  let displayOnly = false;
  let newColumn = {};
  newColumn.name = column.name;
  newColumn.label = column.label;

  // 查看没必要使用必填项
  // if (column.primary !== true) {
  //   if (column.nullable) {
  //     newColumn.required = true;
  //   }
  // }
  newColumn.type = "text";
  const type = column.type.toUpperCase();
  switch (type) {
    case "STRING":
    case "CHAR":
      break;
    case "TEXT":
    case "MEDIUMTEXT":
    case "LONGTEXT":
      newColumn.type = "textarea";
      break;
    case "JSON":
    case "JSONB":
      newColumn.type = "json";
      newColumn.levelExpand = 0; //不展开
      // newColumn.language = "json";
      break;
    case "DATE":
      newColumn.type = "date";
      newColumn.format = "YYYY-MM-DD";
      break;
    case "DATETIME":
      newColumn.type = "date";
      newColumn.format = "YYYY-MM-DD HH:mm:ss";
      break;
    case "DATETIMETZ":
      newColumn.type = "date";
      newColumn.format = "YYYY-MM-DDTHH:mm:ssZ";
      break;
    case "TIME":
      newColumn.type = "date";
      newColumn.format = "HH:mm:ss";
      break;
    case "TIMETZ":
      newColumn.type = "date";
      newColumn.format = "HH:mm:ssZ";
      break;
    case "TIMESTAMP":
    case "TIMESTAMPTZ":
      newColumn.type = "date";
      break;
    case "TINYINTEGER":
    case "SMALLINTEGER":
    case "INTEGER":
    case "BIGINTEGE":
      newColumn.type = "number";
      break;
    case "UNSIGNEDTINYINTEGER":
    case "UNSIGNEDSMALLINTEGER":
    case "UNSIGNEDINTEGER":
      newColumn.type = "number";
      newColumn.min = 0;
      break;
    case "UNSIGNEDBIGINTEGER":
      newColumn.type = "number";
      newColumn.min = 0;
      newColumn.big = true;
      break;
    case "ID":
    case "TINYINCREMENTS":
    case "SMALLINCREMENTS":
    case "INCREMENTS":
      newColumn.type = "number"; //"input-number";
      displayOnly = true; //主键列只显示
      break;
    case "BIGINCREMENTS":
      newColumn.type = "number";
      newColumn.big = true;
      break;
    case "FLOAT":
    case "DOUBLE":
    case "DEMICAL":
      newColumn.type = "number";
      newColumn.precision = column.precision;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "UNSIGNEDFLOAT":
    case "UNSIGNEDDOUBLE":
    case "UNSIGNEDDECIMAL":
      newColumn.type = "number";
      newColumn.precision = column.precision;
      newColumn.min = 0;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "BOOLEAN":
      newColumn.type = "status";
      if (IsMysql()) {
        newColumn.trueValue = 1;
        newColumn.falseValue = 0;
      }
      break;
    case "UUID":
      newColumn.type = "uuid";
      break;
    case "ENUM":
      newColumn.type = "text";
      break;
    default:
      break;
  }
  //布尔
  if (
    type === "TINYINTEGER" &&
    (column.default === 0 || column.default === 1)
  ) {
    newColumn.type = "status";
  }
  if (name.includes("PASSWORD")) {
    newColumn.type = "static-password";
  }

  return { newColumn, displayOnly };
}

/**
 * 根据表字段定义转换成amis form显示字段定义
 *
 * @param {object} column 数据库表列定义
 * @returns 返回amis formitem定义
 */
function column2AmisFormViewColumn(column) {
  // 只读字段的处理有两种方式，一种是使用static-类控件，
  // 另外一种是使用input-控件再加上static属性进行组合控制
  // 哪种更好需要测试后才知道
  const name = column.name.toUpperCase();
  let newColumn = {};
  newColumn.name = column.name;
  newColumn.label = column.label;

  // 必填项，查看界面没必要要显示必输
  // if (column.primary !== true) {
  //   if (column.nullable) {
  //     newColumn.required = true;
  //   }
  // }
  const type = column.type.toUpperCase();
  switch (type) {
    case "STRING":
    case "CHAR":
      newColumn.type = "input-text";
      newColumn.static = true;
      break;
    case "TEXT":
    case "MEDIUMTEXT":
    case "LONGTEXT":
      newColumn.type = "textarea";
      break;
    case "JSON":
    case "JSONB":
      newColumn.type = "static-json";
      newColumn.levelExpand = 1;
      break;
    case "DATE":
      newColumn.type = "static-date";
      newColumn.format = "YYYY-MM-DD";
      break;
    case "DATETIME":
      newColumn.type = "static-date";
      newColumn.format = "YYYY-MM-DD HH:mm:ss";
      break;
    case "DATETIMETZ":
      newColumn.type = "static-date";
      newColumn.format = "YYYY-MM-DDTHH:mm:ssZ";
      break;
    case "TIME":
      newColumn.type = "static-date";
      newColumn.format = "HH:mm:ss";
      break;
    case "TIMETZ":
      newColumn.type = "static-date";
      newColumn.format = "HH:mm:ssZ";
      break;
    case "TIMESTAMP":
    case "TIMESTAMPTZ":
      newColumn.type = "static-date";
      break;
    case "TINYINTEGER":
    case "SMALLINTEGER":
    case "INTEGER":
    case "BIGINTEGE":
      newColumn.type = "input-number";
      newColumn.static = true;
      break;
    case "UNSIGNEDTINYINTEGER":
    case "UNSIGNEDSMALLINTEGER":
    case "UNSIGNEDINTEGER":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.min = 0;
      break;
    case "UNSIGNEDBIGINTEGER":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.min = 0;
      newColumn.big = true;
      break;
    case "ID":
    case "TINYINCREMENTS":
    case "SMALLINCREMENTS":
    case "INCREMENTS":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.displayOnly = true;
      break;
    case "BIGINCREMENTS":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.big = true;
      break;
    case "FLOAT":
    case "DOUBLE":
    case "DEMICAL":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.precision = column.precision;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "UNSIGNEDFLOAT":
    case "UNSIGNEDDOUBLE":
    case "UNSIGNEDDECIMAL":
      newColumn.type = "input-number";
      newColumn.static = true;
      newColumn.precision = column.precision;
      newColumn.min = 0;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "BOOLEAN":
      newColumn.type = "static-status"; //加上static-才会显示标签
      if (IsMysql()) {
        newColumn.trueValue = 1;
        newColumn.falseValue = 0;
      }
      break;
    case "UUID":
      newColumn.type = "uuid";
      break;
    case "ENUM":
      //input-tag
      newColumn.type = "input-text";
      newColumn.static = true;
      break;
    default:
      break;
  }
  //布尔
  if (
    type === "TINYINTEGER" &&
    (column.default === 0 || column.default === 1)
  ) {
    newColumn.type = "static-status";
  }
  if (name.includes("PASSWORD")) {
    newColumn.type = "input-password";
    newColumn.static = true;
  }
  if (name.includes("EMAIL")) {
    newColumn.type = "input-email";
    newColumn.static = true;
  }
  return newColumn;
}

/**
 * 根据表的定义生成一个excel mapping定义，用户再根据自己的需要进行修改
 * @param {string} tableName 数据库表名
 * @returns 字段定义
 */
function excelMapping(tableName, columnsIn) {
  const model = getModelDefinition(tableName, columnsIn);
  const columns = model?.columns;

  // const schema = getTableSchema(tableName);
  // const columns = schema.columns;
  let obj = {};
  columns.forEach((column) => {
    const type = column.type.toUpperCase();
    switch (type) {
      // 自增长的不要
      case "ID":
      case "TINYINCREMENTS":
      case "SMALLINCREMENTS":
      case "INCREMENTS":
        break;
      default:
        obj[column.name] = "${" + column.name + "}";
        break;
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
//如果是使用yao run 的调试方法，需要先把module.exports注释掉
module.exports = {
  getFormViewFields,
  excelMapping,
  getTableFields,
  getTableFieldsWithQuick,
  getFilterFormFields,
  getFormFields,
};
