const { getModelDefinition } = Require("amis.lib");
const { DotName, IsMysql, SlashName } = Require("amis.lib_tool");

/**
 * generate xgen table views
 * yao run scripts.xgen.schema.generateTableView 'admin.user'
 * @param {string} modelId
 * @param {Array} columns
 * @param {boolean} simple 简单模式
 */
function generateTableView(modelId, columns, simple) {
  if (simple) {
    return {
      name: modelId,
      action: { bind: { model: modelId } },
    };
  }
  const modelDsl = getModelDefinition(modelId, columns);

  return getXgenTableSchema(modelDsl);
}

/**
 * generate xgen form views
 * @param {string} modelId
 * @param {Array} columns
 * @param {boolean} simple 简单模式
 */
function generateFormView(modelId, columns, simple, type) {
  if (simple) {
    return {
      name: modelId,
      action: { bind: { model: modelId } },
    };
  }

  const modelDsl = getModelDefinition(modelId, columns);
  return getXgenFormSchema(modelDsl, type);
}

function getXgenTableSchema(modelDsl) {
  // const copiedObject = JSON.parse(JSON.stringify(modelDsl.columns));
  let columns = modelDsl.columns || [];
  const table_dot_name = DotName(modelDsl.table.name);
  let tableTemplate = {
    name: modelDsl.name || "表格",
    action: {
      bind: {
        model: table_dot_name,
        option: { withs: {}, option: { form: table_dot_name } },
      },
    },
    layout: {
      primary: "id",
      header: { preset: {}, actions: [] },
      filter: {
        columns: [],
        actions: [
          {
            title: "添加",
            icon: "icon-plus",
            width: 3,
            action: [
              {
                name: "OpenModal",
                type: "Common.openModal",
                payload: {
                  Form: { type: "edit", model: table_dot_name },
                },
              },
            ],
          },
        ],
      },
      table: {
        columns: [],
        operation: {
          fold: false,
          actions: [
            {
              title: "查看",
              icon: "icon-eye",
              action: [
                {
                  payload: {
                    Form: {
                      model: table_dot_name + "_view",
                      type: "view",
                    },
                  },
                  name: "OpenModal",
                  type: "Common.openModal",
                },
              ],
            },
            {
              title: "编辑",
              icon: "icon-edit-2",
              action: [
                {
                  name: "OpenModal",
                  type: "Common.openModal",
                  payload: {
                    Form: {
                      type: "edit",
                      model: table_dot_name,
                    },
                  },
                },
              ],
            },
            {
              title: "删除",
              icon: "icon-trash-2",
              action: [
                {
                  name: "Confirm",
                  type: "Common.confirm",
                  payload: {
                    title: "确认删除",
                    content: "删除后不可撤销！",
                  },
                },
                {
                  name: "Delete",
                  type: "Table.delete",
                  payload: {
                    model: table_dot_name,
                  },
                },
              ],
            },
          ],
        },
      },
    },
    fields: {
      filter: {},
      table: {},
    },
  };
  columns = MakeColumnOrder(columns);
  columns.forEach((column) => {
    let table = TableColumnCast(column, modelDsl);
    if (table) {
      table.layout.table.columns.forEach((tc) => {
        tableTemplate.layout.table.columns.push(tc);
      });
      table.fields.table.forEach((c) => {
        tableTemplate.fields.table[c.name] = c.component;
      });
      table.fields.filter.forEach((ff) => {
        tableTemplate.layout.filter.columns.push({ name: ff.name, width: 4 });
        tableTemplate.fields.filter[ff.name] = ff.component;
      });
    }
  });
  tableTemplate.action.bind.option.withs = GetWiths(modelDsl);
  return tableTemplate;
}

function getXgenFormSchema(modelDsl, type = "view") {
  // const copiedObject = JSON.parse(JSON.stringify(modelDsl.columns));
  let columns = modelDsl.columns || [];
  const table_dot_name = DotName(modelDsl.table.name);
  const actions = [
    {
      title: "切换全屏",
      icon: "icon-maximize-2",
      showWhenAdd: true,
      showWhenView: true,
      action: [
        {
          name: "Fullscreen",
          type: "Form.fullscreen",
          payload: {},
        },
      ],
    },
    {
      title: "重新生成代码",
      icon: "icon-layers",
      showWhenAdd: true,
      showWhenView: true,
      action: [
        {
          name: "StudioModel",
          type: "Studio.model.cmd",
          payload: { method: "CreateOne", args: [table_dot_name] },
        },
        {
          name: "Confirm",
          type: "Common.confirm",
          payload: {
            title: "提示",
            content: "处理完成",
          },
        },
      ],
    },
    {
      title: "返回",
      icon: "icon-arrow-left",
      showWhenAdd: true,
      showWhenView: true,
      action: [
        {
          name: "CloseModal",
          type: "Common.closeModal",
          payload: {},
        },
      ],
    },
    {
      title: "保存",
      icon: "icon-check",
      style: "primary",
      showWhenAdd: true,
      action: [
        {
          name: "Submit",
          type: "Form.submit",
          payload: {},
        },
        {
          name: "Back",
          type: "Common.closeModal",
          payload: {},
        },
      ],
    },
    {
      icon: "icon-trash-2",
      style: "danger",
      title: "Delete",
      action: [
        {
          name: "Confirm",
          type: "Common.confirm",
          payload: {
            title: "提示",
            content: "确认删除，删除后数据无法恢复？",
          },
        },
        {
          name: "Delete",
          payload: {
            model: table_dot_name,
          },
          type: "Form.delete",
        },
        {
          name: "Back",
          type: "Common.closeModal",
          payload: {},
        },
      ],
    },
  ];
  let formTemplate = {
    name: modelDsl.name || "表单",
    action: {
      bind: {
        model: table_dot_name,
        option: { withs: {} },
      },
    },
    layout: {
      primary: "id",
      actions,
      form: {
        props: {},
        sections: [
          {
            columns: [],
          },
        ],
      },
    },
    fields: {
      form: {},
    },
  };
  columns = MakeColumnOrder(columns);
  columns.forEach((column) => {
    let form = FormColumnCast(column, modelDsl);
    if (form) {
      form.layout.forEach((tc) => {
        if (tc.width < 24) {
          formTemplate.layout.form.sections[0].columns.push(tc);
        } else {
          formTemplate = AddTabColumn(formTemplate, tc);
        }
      });
      form.fields.forEach((ft) => {
        formTemplate.fields.form[ft.name] = ft.component;
      });
    }
  });
  formTemplate.action.bind.option.withs = GetWiths(modelDsl);
  formTemplate = updateReference(formTemplate, modelDsl);
  if (type === "view") {
    formTemplate = relationTable(formTemplate, modelDsl);
  } else {
    formTemplate = relationList(formTemplate, modelDsl);
  }
  return formTemplate;
}

//  *  yao studio run model.relation.GetWiths
//  * @param modelDsl
//  */
function GetWiths(modelDsl) {
  const relations = modelDsl.relations || {};
  let withs = {};
  for (const rel in relations) {
    withs[rel] = {};
  }
  return withs;
}
/**
 * @param columns 类型定义数据列
 * @returns 排序后的数据列
 */
function MakeColumnOrder(columns) {
  const typeMapping = GetDBTypeMap();
  let columnsBefore = [];
  //json或是textarea控件放在最后
  let columnsAfter = [];
  columns.forEach((column) => {
    if (
      ["TextArea"].includes(typeMapping[column.type]) ||
      column.type === "json"
    ) {
      columnsAfter.push(column);
    } else {
      columnsBefore.push(column);
    }
  });
  return columnsBefore.concat(columnsAfter);
}

/**
 * 数据库类型与控件类型对应字段
 * yao studio run model.column.component.GetDBTypeMap
 * @returns
 */
function GetDBTypeMap() {
  return {
    string: "Input",
    char: "Input",
    text: "TextArea",
    mediumText: "TextArea",
    richtext: "TextArea",
    longText: "TextArea",
    date: "DatePicker",
    datetime: "DatePicker",
    datetimeTz: "DatePicker",
    time: "DatePicker",
    timeTz: "DatePicker",
    timestamp: "DatePicker",
    timestampTz: "DatePicker",
    tinyInteger: "InputNumber",
    tinyIncrements: "InputNumber",
    unsignedTinyInteger: "InputNumber",
    smallInteger: "InputNumber",
    unsignedSmallInteger: "InputNumber",
    integer: "InputNumber",
    bigInteger: "InputNumber",
    decimal: "InputNumber",
    unsignedDecimal: "InputNumber",
    float: "InputNumber",
    boolean: "Input",
    enum: "Select",
    color: "ColorPicker",
    phone: "Input",
    url: "Input",
    code: "CodeEditor",
  };
}
/**
 * yao studio model.column.component.FilterFields
 * @returns
 */
function FilterFields() {
  return ["name", "title"];
}
/**
 * yao run studio model.column.table.Cast
 * @param column 模型列定义
 * @param modelDsl 模型定义
 * @returns 表定义
 */
function TableColumnCast(column, modelDsl) {
  // const props = column.props || {};
  let title = column.label || column.name;
  const name = column.name;
  const ismysql = IsMysql();
  // 不展示隐藏列
  let hidden = HiddenFields(true);
  if (hidden.indexOf(name) != -1) {
    // console.log("castTableColumn: hidden");
    return false;
  }
  const typeMapping = GetDBTypeMap();
  if (!name) {
    // console.log("castTableColumn: missing name");
    log.Error("castTableColumn: missing name");
    return false;
  }
  if (!title) {
    // console.log("castTableColumn: missing title");
    log.Error("castTableColumn: missing title");
    return false;
  }
  let res = {
    layout: {
      filter: { columns: [] },
      table: { columns: [] },
    },
    fields: {
      filter: [],
      table: [],
    },
  };
  const bind = name;
  let component = {
    is_select: false,
    bind: name,
    view: { type: "Text", props: {} },
    edit: {
      type: "Input",
      bind: bind,
      props: {},
    },
  };
  let width = 160;
  if (title.length > 5) {
    width = 250;
  }
  // 如果是json的,去看看是不是图片文件
  if (column.type === "json") {
    //可以再优化下
    component = {
      bind: bind,
      view: {
        props: {},
        // compute: "scripts.ddic.compute.json.View",
        type: "Tooltip",
      },
      edit: {
        // compute: "scripts.ddic.compute.json.Edit",
        props: {},
        type: "TextArea",
      },
    };
    // log.Error("castTableColumn: Type %s does not support", column.type);
  } else if (column.type === "enum") {
    component = {
      bind: bind,
      edit: {
        props: {
          options: Enum(column["option"]),
          placeholder: "请选择" + title,
        },
        type: "Select",
      },
      view: {
        props: {
          options: Enum(column["option"]),
          placeholder: "请选择" + title,
        },
        type: "Tag",
      },
    };
  } else if (
    column.type === "boolean" ||
    (column.type === "tinyInteger" &&
      ismysql &&
      (column.default === 0 || column.default === 1))
  ) {
    let checkedValue = true;
    let unCheckedValue = false;
    if (ismysql) {
      checkedValue = 1;
      unCheckedValue = 0;
    }
    component = {
      bind: bind,
      view: {
        type: "Switch",
        props: {
          checkedChildren: "是",
          checkedValue: checkedValue,
          unCheckedChildren: "否",
          unCheckedValue: unCheckedValue,
        },
      },
    };
  } else if (column.type == "color" || /color/i.test(column.name)) {
    component.edit.type = "ColorPicker";
    width = 80;
  } else if (column.crypt === "PASSWORD") {
    component.view = component.view || {};
    component.view.compute = "Hide";
    component.edit.type = "Password";
    width = 180;
  } else {
    if (column.type in typeMapping) {
      component.edit.type = typeMapping[column.type];
    }
  }
  component = IsFile(column, component, modelDsl);
  //检查是否下拉框显示
  component = RelationSelect(column, modelDsl, component);
  // 如果是下拉的,则增加查询条件
  if (component.is_select) {
    const where_bind = "where." + name + ".in";
    res.fields.filter.push({
      name: title,
      component: {
        bind: where_bind,
        edit: component.edit,
      },
    });
  } else {
    const filter_target = FilterFields();
    for (const f in filter_target) {
      if (name.indexOf(filter_target[f]) != -1) {
        res.fields.filter.push({
          name: title,
          component: {
            bind: "where." + name + ".match",
            edit: {
              type: "Input",
              compute: "Trim",
              props: { placeholder: "请输入" + title },
            },
          },
        });
      }
    }
  }

  component = EditPropes(component, column);
  component = updateViewSwitchPropes(component, column);
  if (column.type !== "json" && !component.view?.props?.ddic_hide) {
    res.layout.table.columns.push({
      name: title,
      width: width,
    });
  }
  delete component.is_select;
  res.fields.table.push({
    name: title,
    component: component,
  });
  return res;
}
/**
 * 更新一些编辑属性
 * @param component
 * @param column
 */
function updateViewSwitchPropes(component, column) {
  if (!component || !component?.view) {
    return component;
  }
  if (column.type !== "Switch") {
    return component;
  }
  component.view.props = component.view.props || {};
  const { unique, nullable, default: columnDefault, type } = column;
  if (unique || (!columnDefault && !nullable)) {
    component.view.props.itemProps = { rules: [{ required: true }] };
  }
  if (column.comment) {
    component.view.props["itemProps"] = component.edit.props["itemProps"] || {};
    component.view.props["itemProps"]["tooltip"] = column.comment;
  }
  if (column.default != null) {
    const ismysql = IsMysql();
    const defaultValue =
      ismysql && type === "Switch" ? (column.default ? 1 : 0) : column.default;
    component.view.props["defaultValue"] = defaultValue;
    component.view.props["value"] = defaultValue;
  }
  return component;
}
/**
 * 根据参数类型返回需要排除的字段列表
 * yao studio run model.column.component.Hidden
 * @param isTable true获取Table页面排除,false获取form布局排除字段
 * @returns 排除字段列表
 */
function HiddenFields(isTable) {
  let hidden = [];
  if (isTable) {
    // Table页面不展示的字段列表
    hidden = ["del", "delete", "deleted", "deleted_at", "pwd", "deleted"];
  } else {
    // Form页面不展示的字段列表
    hidden = [
      "del",
      "delete",
      "deleted",
      "deleted_at",
      "created_at",
      "updated_at",
      "id",
      "ID",
      "update_time",
    ];
  }
  return hidden;
}
/**
 * 把模型中的option定义转换成控件select option对象
 * yao studio run model.column.component.Enum
 * @param option 选择列表
 * @returns
 */
function Enum(option) {
  let res = [];
  for (const i in option) {
    res.push({ label: "::" + option[i], value: option[i] });
  }
  return res;
}

/**
 * 判断是否文件显示组件
 * yao studio run model.column.file.IsFile
 * @param column 模型列定义
 * @param component 更新的组件
 * @returns
 */
function IsFile(column, component, modelDsl) {
  if (
    !["text", "json", "string", "logngtext", "mediumText"].includes(column.type)
  ) {
    return component;
  }
  const { viewType, fileType } = GetFileType(column);
  if (fileType === "unknown") {
    return component;
  }
  const name = column.name;
  component = {
    bind: name,
    view: {
      type: viewType,
      compute: "scripts.xgen.file.upload.View",
      props: {},
    },
    edit: {
      type: "Upload",
      compute: {
        process: "scripts.xgen.file.upload.Edit",
        args: ["$C(row)", name, modelDsl.table.name],
      },
      props: {
        maxCount: 100,
        filetype: fileType,
        $api: {
          process: "fs.system.Upload",
        },
      },
    },
  };
  return component;
}
const imageNamePattern = [
  "img",
  "image",
  "_pic",
  "pic_",
  "picture",
  "oss",
  "photo",
  "icon",
  "avatar",
  "Img",
  "logo",
  "cover",
  "url",
  "gallery",
  "pic",
];

const videoNamePattern = ["video", "_video", "video_"];
const fileNamePattern = ["file", "_file", "file_"];

function GetFileType(column) {
  const name = column.name;

  let viewType = "A";
  let fileType = "unknown";
  const patterns = [
    ...imageNamePattern,
    ...videoNamePattern,
    ...fileNamePattern,
  ];

  if (column.type == "image" || column.type == "images") {
    viewType = "Image";
    fileType = "image";
  } else if (column.type == "video") {
    viewType = "Image";
    fileType = "video";
  } else if (column.type == "file") {
    viewType = "A";
    fileType = "file";
  }
  if (fileType == "unknown") {
    for (const pattern of patterns) {
      if (name.includes(pattern)) {
        if (imageNamePattern.includes(pattern)) {
          viewType = "Image";
          fileType = "image";
        } else if (videoNamePattern.includes(pattern)) {
          viewType = "Image";
          fileType = "video";
        } else {
          viewType = "A";
          fileType = "file";
        }
        break;
      }
    }
  }
  return {
    viewType,
    fileType,
  };
}

/**
 * yao studio run model.relation.Select
 * 把hasOne变成下拉选择
 * @param {*} column
 * @param {*} modelDsl
 * @param {*} component
 * @returns
 */
function RelationSelect(column, modelDsl, component) {
  const props = column.props || {};
  // const title = column.label;
  const name = column.name;
  const bind = `${name}`;
  const relation = modelDsl.relations || {};
  for (const rel in relation) {
    if (
      relation[rel].type == "hasOne" &&
      column.name == relation[rel]["foreign"]
    ) {
      const dotName = DotName(relation[rel].model);
      const field = remoteSelect(rel, relation[rel]);
      let component = {
        is_select: true,
        // bind: i + "." + field,
        bind,
        view: {
          type: "Tag",
          props: {
            xProps: {
              $remote: {
                process: "yao.component.SelectOptions",
                query: {
                  model: dotName,
                  label: field,
                  value: "id",
                },
              },
            },
            ...props,
          },
        },
        edit: {
          type: "Select",
          props: {
            xProps: {
              $remote: {
                process: "yao.component.SelectOptions",
                query: {
                  model: dotName,
                  label: field,
                  value: "id",
                },
              },
            },
            ...props,
          },
        },
      };
      return component;
    }
    // component = Withs(component, rel);
  }
  return component;
}
/**
 * //根据关联关系找到列，并查找列对应的模型
 * yao studio run model.remote.select
 * @param relation_name
 * @param relation
 * @returns
 */
function remoteSelect(relation_name, releation) {
  //首先从关联关系的模型中找到模型
  let model = getModelDefinition(releation.model);
  if (!model) {
    model = Process("schemas.default.TableGet", relation_name);
  }
  const columns = model.columns;
  let res = Speculation(columns);
  if (!res) {
    res = Other(columns);
  }
  //CreateScripts(relation_name, res, relation);
  return res;
}
/**
 * 字段推测
 * @param {*} column
 * @returns
 */
function Speculation(columns) {
  const target = ["name", "title"];
  for (const t of target) {
    const res = GetTarget(t, columns);
    if (res) {
      return res;
    }
  }
  return false;
}
function GetTarget(target, columns) {
  const columnNames = columns.map((col) => col.name);
  return (
    columnNames.find((name) => name === target) ??
    columnNames.find((name) => name.includes(target)) ??
    false
  );
}
/**
 * 没有其他的话,就找个string类型的
 * @param {*} columns
 * @returns
 */
function Other(columns) {
  const stringColumn = columns.find((col) => col.type === "string");
  return stringColumn?.name ?? "id";
}
/**
 * yao run studio model.column.component.EditPropes
 * 更新一些编辑属性
 * @param component
 * @param column
 */
function EditPropes(component, column) {
  if (!component || !component.edit) {
    return component;
  }
  component.edit.props = component.edit.props || {};
  if (column.comment) {
    component.edit.props.itemProps = component.edit.props.itemProps || {};
    component.edit.props.itemProps.tooltip = column.comment;
  }
  const rules = GetRules(column, component);
  if (rules?.length) {
    component.edit.props.itemProps = {
      ...component.edit.props.itemProps,
      rules: [
        ...(component.edit.props.itemProps?.rules || []),
        ...(rules.length === 1 &&
        component.edit.props.itemProps?.rules?.length === 1
          ? [Object.assign(component.edit.props.itemProps.rules[0], rules[0])]
          : rules),
      ],
    };
  }
  // 默认值
  if (
    column.default != null &&
    column.default != "TlVMTA==" &&
    component.edit.type !== "Upload"
  ) {
    component.edit.props.itemProps = component.edit.props.itemProps || {};
    const ismysql = IsMysql();
    const defaultValue =
      ismysql && column.type === "boolean"
        ? column.default
          ? 1
          : 0
        : column.default;
    component.edit.props.itemProps.initialValue = defaultValue;
  }
  return component;
}
function GetRules(column, component) {
  const validationTypeMap = {
    string: "string",
    integer: "integer",
    float: "float",
    number: "number",
    datetime: "date",
    bool: "number",
  };
  const dbTypeToAntd = {
    // string: "string",有可能是json
    // char: "string",
    // text: "string",
    // mediumText: "string",
    // longText: "string",
    date: "date",
    datetime: "date",
    datetimeTz: "date",
    time: "date",
    timeTz: "date",
    timestamp: "date",
    timestampTz: "date",
    tinyInteger: "integer",
    tinyIncrements: "integer",
    unsignedTinyInteger: "integer",
    smallInteger: "integer",
    unsignedSmallInteger: "integer",
    integer: "integer",
    bigInteger: "integer",
    // decimal: "number", 过于严格
    // unsignedDecimal: "number",
    // float: "number",
    boolean: "boolean",
    enum: "enum",
    image: "array",
  };
  const rules = [];
  let rule = {};
  const {
    index,
    unique,
    nullable,
    default: columnDefault,
    type: dbColumnType,
  } = column;
  const antdType = dbTypeToAntd[dbColumnType];
  if (dbColumnType in dbTypeToAntd) {
    if (antdType === "enum") {
      rule.type = antdType;
      rule.enum = column.option;
    } else if (antdType !== null && antdType !== undefined) {
      rule.type = antdType;
    }
  }
  // if (column.length) {
  //MAX Length
  // rule.max = column.length;
  // }
  if (
    !/^id$/i.test(dbColumnType) &&
    (unique ||
      (!nullable &&
        (columnDefault === null ||
          columnDefault === undefined ||
          columnDefault === "TlVMTA==")))
  ) {
    rule.required = true;
  }
  const validations = column.validations;
  if (validations && validations.length) {
    validations.forEach((validation) => {
      switch (validation.method) {
        case "typeof":
          rule.type = validation.args.find((arg) => validationTypeMap[arg]);
          break;
        case "maxLength":
          if (validation.args && validation.args.length) {
            rule.max = validation.args[0];
          }
          break;
        case "minLength":
          if (validation.args && validation.args.length) {
            rule.min = validation.args[0];
          }
          break;
        case "enum":
          if (validation.args && validation.args.length) {
            rule.type = "enum";
            rule.enum = validation.args;
          }
          break;
        case "pattern":
          if (validation.args && validation.args.length) {
            rules.push({
              pattern: validation.args[0],
              message: validation.message,
            });
          }
          break;
        default:
          break;
      }
    });
  }
  //控件值跟数据库有关,不能使用boolean类型验证
  if (
    antdType === "boolean" &&
    ["RadioGroup", "Switch", "Select"].includes(component.edit.type)
  ) {
    delete rule.type;
  }
  // if (rule?.type?.length > 0 || rule.required) {
  if (Object.keys(rule).length !== 0) {
    rules.push(rule);
  }
  // }
  return rules;
}
function updateReference(formTemplate, modelDsl) {
  const hasCount = Object.values(modelDsl.relations || { type: "" }).filter(
    (rel) => rel.type === "hasOne"
  ).length;
  if (hasCount === 0) {
    return formTemplate; // no need to modify the form if there are no 'hasOne' relations
  }
  formTemplate = MergeObject(formTemplate, {
    layout: {
      form: {
        props: {
          reference: {},
        },
      },
    },
  });
  const referenceContent = [];
  for (const rel in modelDsl.relations || {}) {
    if (modelDsl.relations[rel].type === "hasOne") {
      referenceContent.push({
        name: modelDsl.relations[rel].label || rel,
        payload: {
          Form: {
            type: "view",
            model: modelDsl.relations[rel].model + "_view",
            id: `{{${modelDsl.relations[rel].foreign}}}`,
          },
        },
      });
    }
  }
  if (hasCount === 1) {
    formTemplate.layout.form.props.reference.flatContent = {
      name: referenceContent[0].name,
      defaultOpen: false,
      payload: {
        Form: {
          type: "view",
          model: referenceContent[0].payload.Form.model,
          id: `${referenceContent[0].payload.Form.id}`,
        },
      },
    };
  } else {
    formTemplate.layout.form.props.reference.floatContents = referenceContent;
  }
  return formTemplate;
}
/**
 * 合并两个js对象，并返回新对象。
 * yao studio run model.utils.MergeObject
 * @param target 目标对象
 * @param source 源对象
 * @returns
 */
function MergeObject(target, source) {
  if (
    target === null ||
    target === undefined ||
    typeof target !== "object" ||
    source === null || //mybe undefined
    source === undefined ||
    typeof source !== "object"
  ) {
    return target;
  }
  for (const [key, value] of Object.entries(source)) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (
        target[key] &&
        typeof target[key] === "object" &&
        typeof value === "object" &&
        !Array.isArray(value)
      ) {
        MergeObject(target[key], value);
      } else if (Array.isArray(target[key]) && Array.isArray(value)) {
        target[key].push(...value);
      } else {
        target[key] = value;
      }
    } else {
      target[key] = value;
    }
  }
  return target;
}

/**
 * 把hasMany变成表单中的Table
 */
function relationTable(formDsl, modelDsl) {
  const relations = modelDsl.relations || {};
  for (const rel in relations) {
    // console.log(`translate.translate:${i}`);
    if (relations[rel].type != "hasMany") {
      continue;
    }
    let label = relations[rel].label;
    if (!label) {
      label = rel;
      // label = "列表" + Studio("model.translate.translate", rel);
    }
    if (!label) {
      label = rel;
    }
    formDsl.fields.form[label] = {
      bind: "id",
      edit: {
        type: "Table",
        props: {
          model: relations[rel].model,
          query: {
            [`where.${relations[rel].key}.eq`]: "{{id}}",
          },
        },
      },
    };
    formDsl = AddTabColumn(formDsl, {
      name: label,
      width: 24,
    });
  }
  return formDsl;
}
/**
 * yao studio run model.relation.List
 * 把hasMany变成表单中的List
 */
function relationList(formDsl, modelDsl) {
  const relations = modelDsl.relations || {};
  let RelList = [];
  // let tabs: YaoForm.SectionDSL[] = [];
  for (const rel in relations) {
    // console.log(`translate.translate:${i}`);
    if (relations[rel].type != "hasMany") {
      continue;
    }
    RelList.push({
      name: rel,
      model: relations[rel].model,
      key: relations[rel].key,
    });
    //创建控件
    let label = relations[rel].label;
    if (!label) {
      label = rel;
      // label = "列表" + Studio("model.translate.translate", rel);
    }
    if (!label) {
      label = rel;
    }
    formDsl.fields.form[label] = {
      bind: rel,
      edit: {
        type: "List",
        props: {
          name: relations[rel].model,
          showLabel: true,
        },
      },
    };
    formDsl = AddTabColumn(formDsl, {
      name: label,
      width: 24,
    });
  }
  if (RelList.length === 0) {
    return formDsl;
  }
  const tabName = modelDsl.table.name;
  // let funtionName = SlashName(tabName);
  let modelName = DotName(tabName);
  RelList.forEach((rel) => CreateListFile(rel));
  //function templates
  // const saveDataFunList = RelList.map((rel) => CreateDataSaveCode(rel));
  // const deleteDataFunList = RelList.map((rel) => CreateDataDeleteCode(rel));
  // const AfterFind = CreateAfterFind(relations);
  // //called code list
  // const saveDataCodes = RelList.map((rel) => `Save_${rel.name}(id,payload);`);
  // const deleteDataCodes = RelList.map((rel) => `Delete_${rel.name}(id);`);
  if (RelList.length) {
    formDsl.action.save = {
      process: `scripts.${modelName}.Save`,
    };
    formDsl.action["before:delete"] = `scripts.${modelName}.BeforeDelete`;
    formDsl.action["after:find"] = `scripts.${modelName}.AfterFind`;
    // WriteScript(
    //   funtionName,
    //   modelName,
    //   saveDataCodes,
    //   deleteDataCodes,
    //   saveDataFunList,
    //   deleteDataFunList,
    //   AfterFind
    // );
  }
  return formDsl;
}
/**
 * yao studio run model.column.form.AddTabColumn
 * @param formTemplate form template
 * @param column column
 * @returns new form template
 */
function AddTabColumn(formTemplate, column) {
  let section = formTemplate.layout.form.sections.find((sec) =>
    sec.columns?.find((col) => col.tabs != null)
  );
  if (section) {
    let col = section.columns.find((col) => col.tabs != null);
    col.tabs.push({
      title: column.name,
      columns: [column],
    });
  } else {
    formTemplate.layout.form.sections.push({
      columns: [
        {
          name: "列表",
          tabs: [{ title: column.name, columns: [column] }],
          width: 24,
        },
      ],
    });
  }
  return formTemplate;
}
/**
 *根据模型定义生成Form定义
 * yao run scripts.xgen.schema.FormColumnCast
 * @param column 模型列定义
 * @param modelDsl 模型定义
 * @param type 类型
 * @returns
 */
function FormColumnCast(column, modelDsl) {
  const types = GetDBTypeMap();
  const ismysql = IsMysql();
  const title = column.label || column.name;
  const name = column.name;
  if (!name) {
    //log.Error("castFormColumn: missing name");
    return false;
  }
  if (!title) {
    // log.Error("castFormColumn: missing title");
    return false;
  }
  // 不展示隐藏列
  const hidden = HiddenFields(false);
  if (hidden.indexOf(name) != -1) {
    return false;
  }
  let res = {
    layout: [],
    fields: [],
  };
  let component = {
    bind: name,
    edit: {
      type: "Input",
      props: {},
    },
  };
  let width = 8;
  const bind = name;
  if (column.type == "json") {
    component = {
      bind: bind,
      edit: {
        // compute: "scripts.ddic.compute.json.Edit",
        props: {
          language: "json",
          height: 200,
        },
        type: "CodeEditor",
      },
    };
  } else if (column.type == "enum") {
    component = {
      bind: bind,
      edit: {
        props: {
          options: Enum(column["option"]),
          placeholder: "请选择" + title,
        },
        type: "Select",
      },
    };
  } else if (
    column.type === "boolean" ||
    (column.type === "tinyInteger" &&
      ismysql &&
      (column.default === 0 || column.default === 1))
  ) {
    let checkedValue = true;
    let unCheckedValue = false;
    if (ismysql) {
      checkedValue = 1;
      unCheckedValue = 0;
    }
    component = {
      bind: bind,
      edit: {
        type: "RadioGroup",
        props: {
          options: [
            {
              label: "是",
              value: checkedValue,
            },
            {
              label: "否",
              value: unCheckedValue,
            },
          ],
        },
      },
    };
  } else if (column.type == "color" || /color/i.test(column.name)) {
    component.edit.type = "ColorPicker";
  } else if (column.crypt === "PASSWORD") {
    component.edit.type = "Password";
    component.view = component.view || {};
    component.view.compute = "Hide";
  } else {
    if (column.type in types) {
      component.edit.type = types[column.type];
    }
  }
  if (["TextArea"].includes(types[column.type]) || column.type === "json") {
    width = 24;
  }
  component = IsFormFile(column, component, modelDsl);
  component = EditSelect(column, modelDsl, component);
  if (component.is_upload) {
    width = 24;
  }
  delete component.is_upload;
  component = EditPropes(component, column);
  if (!component.edit?.props?.ddic_hide) {
    res.layout.push({
      name: title,
      width: width,
    });
  }
  if (component.edit?.type === "CodeEditor") {
    component.view = component.view || {};
    component.view.compute = "scripts.xgen.compute.json.View";
  }
  res.fields.push({
    name: title,
    component: component,
  });
  return res;
}
/**
 * yao studio run model.column.file.IsFormFile
 * 根据图片组件更新组件类型,可上传
 * @param column 模型中的字段定义
 * @param component 数据库字段定义
 * @param modelDsl 模型引用
 * @returns
 */
function IsFormFile(column, component, modelDsl) {
  if (
    !["text", "json", "string", "logngtext", "mediumText"].includes(column.type)
  ) {
    return component;
  }
  const { viewType, fileType } = GetFileType(column);
  if (fileType === "unknown") {
    return component;
  }
  const name = column.name;
  var component = {
    is_upload: true,
    bind: name,
    view: {
      type: viewType,
      compute: "scripts.xgen.file.upload.View",
      props: {},
    },
    edit: {
      type: "Upload",
      compute: {
        process: "scripts.xgen.file.upload.Edit",
        args: ["$C(row)", name, modelDsl.table.name],
      },
      props: {
        maxCount: 100,
        filetype: fileType,
        $api: { process: "fs.system.Upload" },
      },
    },
  };
  return component;
}
/**
 * yao studio run model.relation.EditSelect
 * Select控件。
 * @param column 模型的列
 * @param modelDsl 模型实例
 * @param component 新对象
 * @returns 返回新对象
 */
function EditSelect(column, modelDsl, component) {
  const props = column.props || {};
  const name = column.name;
  const bind = `${name}`;
  const relation = modelDsl.relations || {};
  for (const rel in relation) {
    if (
      relation[rel].type === "hasOne" &&
      column.name == relation[rel]["foreign"]
    ) {
      const field = remoteSelect(rel, relation[rel]);
      let component = {
        bind: bind,
        edit: {
          type: "Select",
          props: {
            xProps: {
              $remote: {
                process: "yao.component.SelectOptions",
                query: {
                  model: Studio("model.file.DotName", relation[rel].model),
                  label: field,
                  value: "id",
                },
              },
            },
            ...props,
          },
        },
      };
      return component;
    }
    // component = Withs(component, rel);
  }
  return component;
}
