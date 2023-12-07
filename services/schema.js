function getCodeGenerationList() {
  return [
    {
      label: "增删改查-所有",
      value: "CRUDAllTemplate",
    },
    {
      label: "增删改查-查看",
      value: "CRUDListTemplate",
    },
    {
      label: "增删改查-创建",
      value: "CRUDNewTemplate",
    },
    {
      label: "列表视图-字段列表",
      value: "getTableAmisViewFields",
    },
    {
      label: "表单查看-字段列表",
      value: "getTableAmisFormViewFields",
    },
    {
      label: "表单修改-字段列表",
      value: "getTableAmisFormFields",
    },
    {
      label: "表单修改-带快速-字段列表",
      value: "getTableAmisViewFieldsWithQuick",
    },
    {
      label: "Xgen表格定义",
      value: "getXgenTable",
    },
    {
      label: "Xgen表单定义",
      value: "getXgenForm",
    },
    {
      label: "TypeScript类型定义",
      value: "getTSType",
    },
  ];
}

/**
 * 返回数据库表列表
 * @returns list
 */
function getTables() {
  //跟studio的service不同，services不需要跨域
  //    curl -X POST http://127.0.0.1:5099/api/__yao/app/service/schema \
  //    -H 'Content-Type: application/json' \
  //    -H 'Authorization: Bearer <Studio JWT>' \
  //    -d '{ "args":[],"method":"getTables"}'

  const list = Process("schemas.default.Tables");
  const tables = list.map((table) => {
    return { item: table };
  });
  return { rows: tables };
}
/**
 * 返回一个适配amis option类控件的数据库表清单
 * @returns list
 */
function getTables2() {
  //跟studio的service不同，services不需要跨域
  //    curl -X POST http://127.0.0.1:5099/api/__yao/app/service/schema \
  //    -H 'Content-Type: application/json' \
  //    -H 'Authorization: Bearer <Studio JWT>' \
  //    -d '{ "args":[],"method":"getTables"}'

  return Process("scripts.system.model.modelNameOption");
}

/**
 * 读取一个数据库表的字段配置信息
 *
 * @param {string} table 表名
 * @returns 表的字段定义
 */
function getTable(table) {
  // 注意不要直接返回`{columns}`,返回columns会改变amis的table 的columns设置
  const data = Process("schemas.default.TableGet", table);
  return { items: data.columns };
}
function CRUDNewTemplate(modelId, columns) {
  return {
    __code_source: Process("scripts.amis.schema.curdNewPage", modelId, columns),
  };
}

function CRUDListTemplate(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.amis.schema.curdListPage",
      modelId,
      columns
    ),
  };
}

function CRUDAllTemplate(modelId, columns) {
  return {
    __code_source: Process("scripts.amis.curd.curdTemplate", modelId, columns),
  };
}

/**
 * 生成模型的TS类型定义
 * @param {string} modelId 模型定义
 * @returns string
 */
function getTSType(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.system.tstype.createModelType",
      modelId,
      columns
    ),
  };
}
/**
 * 生成amis table控件的列表字段定义
 * @param {string} modelId 模型名称
 * @returns list
 */
function getTableAmisViewFields(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.amis.schema.generateViewFields",
      modelId,
      columns
    ),
  };
}
/**
 * 生成amis表单编辑定义字段列表
 * @param {string} modelId 模型名称
 * @returns list
 */
function getTableAmisFormFields(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.amis.schema.generateEditFormFields",
      modelId,
      columns
    ),
  };
}

/**
 * 生成amis表单查看字段列表
 * @param {string} modelId 模型名称
 * @returns list
 */
function getTableAmisFormViewFields(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.amis.schema.formViewFieldsSchema",
      modelId,
      columns
    ),
  };
}

/**
 * 根据模型名称生成amis crud控件的查看字段列表，并带有快速编辑功能
 * @param {string} modelId 模型名称
 * @returns
 */
function getTableAmisViewFieldsWithQuick(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.amis.schema.generateViewFieldsWithQuick",
      modelId,
      columns
    ),
  };
}

/**
 * 根据模型信息生成xgen表定义
 * @param {string} modelId
 * @param {Array} columns
 * @returns
 */
function getXgenTable(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.xgen.schema.generateTableView",
      modelId,
      columns
    ),
  };
}

/**
 * 根据模型信息生成xgen表单定义
 * @param {string} modelId
 * @param {Array} columns
 * @returns
 */
function getXgenForm(modelId, columns) {
  return {
    __code_source: Process(
      "scripts.xgen.schema.generateFormView",
      modelId,
      columns
    ),
  };
}
