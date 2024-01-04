// 转换列配置成yao的模型配置，才能适配数据库
const { IsMysql } = Require("amis.lib_tool");

// 集中管理类型字段类型转换处理

/**
 * column 类型定义,把meta字段类型转换成yao模型字段类型
 * @param {object} col
 * @returns
 */
function convertColTypeToYao(col) {
  switch (col.type?.toLowerCase()) {
    case "image":
    case "video":
    case "images":
    case "file":
      col.type = "longText";
      col.length = undefined;
      break;
    case "richtext":
      col.type = "longText";
      col.length = undefined;
      break;
    case "url":
      col.type = "string";
      break;
    case "code":
      col.type = "longText";
      col.length = undefined;
      break;
    case "phone":
      col.type = "string";
      break;
    case "email":
      col.type = "string";
    case "color":
      col.type = "string";
    default:
      break;
  }
  return col;
}

function GetColumnTypeList() {
  return [
    {
      label: "字符串",
      value: "string",
    },
    {
      label: "文本",
      value: "text",
    },
    {
      label: "富文本",
      value: "richtext",
    },
    {
      label: "JSON",
      value: "json",
    },
    {
      label: "代码",
      value: "code",
    },
    {
      label: "链接",
      value: "url",
    },
    {
      label: "日期",
      value: "date",
    },
    {
      label: "日期时间",
      value: "datetime",
    },
    {
      label: "时间",
      value: "time",
    },
    {
      label: "图片",
      value: "image",
    },
    {
      label: "图片集",
      value: "images",
    },
    {
      label: "视频",
      value: "video",
    },
    {
      label: "文件",
      value: "file",
    },
    {
      label: "手机号码",
      value: "phone",
    },
    {
      label: "邮箱",
      value: "email",
    },
    {
      label: "颜色",
      value: "color",
    },
    {
      label: "自增ID",
      value: "id",
    },
    {
      label: "整型",
      value: "integer",
    },
    {
      label: "浮点数",
      value: "float",
    },
    {
      label: "双精度",
      value: "double",
    },
    {
      label: "小数",
      value: "decimal",
    },
    {
      label: "布尔型",
      value: "boolean",
    },
    {
      label: "枚举型",
      value: "enum",
    },
  ];
}

/**
 * 根据表字段定义转换成amis table表列定义
 *
 * @param {object} column 数据库表列定义
 * @returns 返回amis formitem定义
 */
function column2AmisTableViewColumn(column) {
  // 只读字段的处理有两种方式，一种是使用static-类控件，
  // 不要使用input-控件再加上static属性进行组合控制，会使用quickEdit失效
  // 哪种更好需要测试后才知道
  // const name = column.name.toUpperCase();
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
      newColumn.type = "text";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "TEXT":
    case "MEDIUMTEXT":
    case "LONGTEXT":
      newColumn.type = "text";
      newColumn.searchable = true;
      newColumn.sortable = true;
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
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "DATETIME":
      newColumn.type = "date";
      newColumn.format = "YYYY-MM-DD HH:mm:ss";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "DATETIMETZ":
      newColumn.type = "date";
      newColumn.format = "YYYY-MM-DDTHH:mm:ssZ";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "TIME":
      newColumn.type = "date";
      newColumn.format = "HH:mm:ss";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "TIMETZ":
      newColumn.type = "date";
      newColumn.format = "HH:mm:ssZ";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "TIMESTAMP":
    case "TIMESTAMPTZ":
      newColumn.type = "date";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "TINYINTEGER":
    case "SMALLINTEGER":
    case "INTEGER":
    case "BIGINTEGE":
      newColumn.type = "number";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "UNSIGNEDTINYINTEGER":
    case "UNSIGNEDSMALLINTEGER":
    case "UNSIGNEDINTEGER":
      newColumn.type = "number";
      newColumn.min = 0;
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "UNSIGNEDBIGINTEGER":
      newColumn.type = "number";
      newColumn.min = 0;
      newColumn.big = true;
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "ID":
    case "TINYINCREMENTS":
    case "SMALLINCREMENTS":
    case "INCREMENTS":
      newColumn.type = "number"; //"input-number";
      displayOnly = true; //主键列只显示
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "BIGINCREMENTS":
      newColumn.type = "number";
      newColumn.big = true;
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "FLOAT":
    case "DOUBLE":
    case "DEMICAL":
      newColumn.type = "number";
      newColumn.precision = column.precision;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "UNSIGNEDFLOAT":
    case "UNSIGNEDDOUBLE":
    case "UNSIGNEDDECIMAL":
      newColumn.type = "number";
      newColumn.precision = column.precision;
      newColumn.min = 0;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "BOOLEAN":
      newColumn.type = "status";
      if (IsMysql()) {
        newColumn.trueValue = 1;
        newColumn.falseValue = 0;
      }
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "UUID":
      newColumn.type = "uuid";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "ENUM":
      newColumn.type = "text";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "FILE":
      newColumn.type = "static-link";
      newColumn.href = "${" + `${column.name}` + "}";
      newColumn.body = "${" + `${column.name}` + "}";
      newColumn.searchable = true;
      newColumn.sortable = true;
      break;
    case "IMAGE":
      newColumn.type = "static-image";
      break;
    case "IMAGES":
      newColumn.type = "static-images";
      break;
    case "VIDEO":
      newColumn.type = "static-video";
      break;
    case "RICHTEXT":
      newColumn.type = "html";
      newColumn.toggled = false; //如果内容很多，显示会占用太多的空间
      break;
    case "CODE":
      newColumn.type = "text";
      break;
    case "URL":
      newColumn.type = "link";
      break;
    case "PHONE":
      newColumn.type = "text";
      break;
    case "EMAIL":
      newColumn.type = "text";
      break;
    case "COLOR":
      newColumn.type = "color";
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
  if (column.crypt?.toUpperCase() === "PASSWORD") {
    newColumn.type = "static-password";
    newColumn.searchable = undefined;
    newColumn.sortable = undefined;
  }
  if (column.check_model != null) {
    // if (column.check_model_multi) {
    //   newColumn.multiple = true;
    // }
    newColumn.type = "tag";
    // 这里不要使用input-tag + static=true的组合，会使用quickEdit控件失效
    // 如果是纯显示，可以使用input-tag + static=true的组合来显示标签的值，而不是value字段
    // newColumn.source = {
    //   cache: 2000,
    //   method: 'post',
    //   url: `/api/v1/system/model/${column.check_model}/select_options`,
    //   data: {
    //     __label: column.check_model_label || 'name',
    //     __value: column.check_model_value || 'id',
    //   }
    // }
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
  // const name = column.name.toUpperCase();
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
  newColumn.type = "static-text";
  switch (type) {
    case "STRING":
    case "CHAR":
      newColumn.type = "static-text";
      break;
    case "TEXT":
    case "MEDIUMTEXT":
    case "LONGTEXT":
      newColumn.type = "textarea";
      newColumn.static = true;
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
      newColumn.type = "static-number";
      break;
    case "UNSIGNEDTINYINTEGER":
    case "UNSIGNEDSMALLINTEGER":
    case "UNSIGNEDINTEGER":
      newColumn.type = "static-number";
      newColumn.min = 0;
      break;
    case "UNSIGNEDBIGINTEGER":
      newColumn.type = "static-number";
      newColumn.min = 0;
      newColumn.big = true;
      break;
    case "ID":
    case "TINYINCREMENTS":
    case "SMALLINCREMENTS":
    case "INCREMENTS":
      newColumn.type = "static-number";
      newColumn.displayOnly = true;
      break;
    case "BIGINCREMENTS":
      newColumn.type = "static-number";
      newColumn.big = true;
      break;
    case "FLOAT":
    case "DOUBLE":
    case "DEMICAL":
      newColumn.type = "static-number";
      newColumn.precision = column.precision;
      newColumn.step = column.scale && 0.1 ^ column.scale;
      break;
    case "UNSIGNEDFLOAT":
    case "UNSIGNEDDOUBLE":
    case "UNSIGNEDDECIMAL":
      newColumn.type = "static-number";
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
      newColumn.type = "static-uuid";
      break;
    case "ENUM":
      //input-tag
      newColumn.type = "static-text";
      break;
    case "FILE":
      newColumn.type = "static-link";
      newColumn.href = "${" + `${column.name}` + "}";
      newColumn.body = "${" + `${column.name}` + "}";
      break;
    case "IMAGE":
      newColumn.type = "static-image";
      break;
    case "IMAGES":
      newColumn.type = "static-images";
      break;
    case "VIDEO":
      newColumn.type = "static-video";
      break;
    case "RICHTEXT":
      newColumn.type = "static-rich-text";
      break;
    case "CODE":
      newColumn.type = "static-code";
      newColumn.language = column.language || "html";
      break;
    case "URL":
      newColumn.type = "static-text";
      break;
    case "PHONE":
      newColumn.type = "static-text";
      break;
    case "EMAIL":
      newColumn.type = "static-text";
      break;
    case "COLOR":
      newColumn.type = "static-color";
      break;
    default:
      break;
  }
  if (column.check_model != null) {
    if (column.check_model_multi) {
      newColumn.multiple = true;
    }
    newColumn.type = "input-tag";
    newColumn.static = true;
    newColumn.source = {
      cache: 2000,
      method: "post",
      url: `/api/v1/system/model/${column.check_model}/select_options`,
      data: {
        __label: column.check_model_label || "name",
        __value: column.check_model_value || "id",
      },
    };
  }
  //布尔
  if (
    type === "TINYINTEGER" &&
    (column.default === 0 || column.default === 1)
  ) {
    newColumn.type = "static-status";
  }
  if (column.crypt?.toUpperCase() === "PASSWORD") {
    newColumn.type = "static-password";
  }
  // if (name.includes("EMAIL")) {
  //   newColumn.type = "static-text";
  // }
  return newColumn;
}
function isDateTimeType(column) {
  const columnType = column.type?.toUpperCase();
  switch (columnType) {
    case "DATE":
    case "DATETIME":
    case "DATETIMETZ":
    case "TIME":
    case "TIMETZ":
    case "TIMESTAMP":
    case "TIMESTAMPTZ":
      return true;
  }
  return false;
}
/**
 * 转换一个数据库表的列定义成amis form item定义，主要用于数据编辑
 * @param {object} column 数据库表列定义
 * @returns amis form item 定义
 */
function column2AmisFormEditColumn(column) {
  //   const name = column.name.toUpperCase();
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
  const columnType = column.type.toUpperCase();
  switch (columnType) {
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
      // newColumn.static = true;在过滤中也会用到，不能设置static
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
    case "FILE":
      newColumn.type = "input-file";
      newColumn.receiver = "/api/v1/fs/public/file/upload";
      newColumn.useChunk = false; //暂时关闭，分块还不知怎么处理
      break;
    case "IMAGE":
      newColumn.type = "input-image";
      newColumn.receiver = "/api/v1/fs/public/file/upload";
      break;
    case "IMAGES":
      newColumn.type = "input-image";
      newColumn.receiver = "/api/v1/fs/public/file/upload";
      newColumn.multiple = true;
      break;
    case "VIDEO":
      newColumn.type = "input-file";
      newColumn.receiver = "/api/v1/fs/public/file/upload";
      newColumn.useChunk = false; //暂时关闭，分块还不知怎么处理
      break;
    case "RICHTEXT":
      newColumn.type = "input-rich-text";
      newColumn.receiver = "/api/v1/fs/public/file/upload";
      newColumn.useChunk = false; //暂时关闭，分块还不知怎么处理
      break;
    case "CODE":
      newColumn.type = "editor";
      newColumn.language = column.language || "html";
      break;
    case "URL":
      newColumn.type = "input-text";
      newColumn.validations = newColumn.validations || {};
      newColumn.validations["isUrl"] = true;
      break;
    case "PHONE":
      newColumn.type = "input-text";
      newColumn.validations = newColumn.validations || {};
      newColumn.validations["isPhoneNumber"] = true;
      break;
    case "EMAIL":
      newColumn.type = "input-text";
      newColumn.validations = newColumn.validations || {};
      newColumn.validations["isEmail"] = true;
      break;
    case "COLOR":
      newColumn.type = "input-color";
    default:
      break;
  }
  //布尔
  if (
    columnType === "TINYINTEGER" &&
    (column.default === 0 || column.default === 1)
  ) {
    newColumn.type = "switch";
    if (IsMysql()) {
      newColumn.trueValue = 1;
      newColumn.falseValue = 0;
    }
  }
  //只是只一个猜测

  if (column.crypt?.toUpperCase() === "PASSWORD") {
    newColumn.type = "input-password";
  }
  //   if (name.includes("EMAIL")) {
  //     newColumn.type = "input-email";
  //   }
  if (column.check_model != null) {
    if (column.check_model_multi) {
      newColumn.multiple = true;
    }
    const labelField = column.check_model_label || "name";
    newColumn.type = "select";
    newColumn.source = {
      method: "post",
      url: `/api/v1/system/model/${column.check_model}/select_options`,
      data: {
        __label: labelField,
        __value: column.check_model_value || "id",
      },
    };
  }
  return newColumn;
}

module.exports = {
  convertColTypeToYao,
  GetColumnTypeList,
  column2AmisFormViewColumn,
  column2AmisTableViewColumn,
  column2AmisFormEditColumn,
  isDateTimeType,
};
