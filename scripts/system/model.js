/**
 * Yao模型管理
 */

const { DotName, UnderscoreName, IsMysql, IsSqlite, ClearFalsyKeys } =
  Require("amis.lib_tool");
const { FileNameConvert } = Require("amis.lib_tool");

const { queryToQueryParam, updateInputData } = Require("amis.data.lib");

const { FindCachedModelById, MomoryModelList, ModelIDList } =
  Require("system.model_lib");

//查找模型
//yao run scripts.system.model.page
function page(page, pagesize, querys, payload) {
  let queryParam = queryToQueryParam("ddic.model", querys, payload);
  queryParam = queryParam || {};
  queryParam["select"] = [
    "id",
    "name",
    "comment",
    "table_name",
    "table_comment",
  ];
  let data = Process(`models.ddic.model.Paginate`, queryParam, page, pagesize);
  return {
    items: data.data,
    total: data.total,
  };
}

//读取所有的模型id的列表
//yao run scripts.system.model.DatabaseModelList
function DatabaseModelList() {
  let list = Process("models.ddic.model.get", {
    select: ["identity", "name", "comment"],
  });
  list.forEach((item) => {
    if (item.comment == null) {
      item.comment = item.name ? item.name : item.identity;
    }
  });
  return list;
}

//完成模型的定义
function CompleteModel(modelDsl) {
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
  //如果没有表名，但是有ID
  if (modelDsl.ID?.length && !modelDsl.table?.name?.length) {
    modelDsl.table.name = modelDsl.ID;
  }
  modelDsl.table.name = UnderscoreName(modelDsl.table?.name);

  if (!modelDsl.name?.length) {
    modelDsl.name = modelDsl.table?.comment || modelDsl.comment || modelDsl.ID;
  }

  //在导入数据时，过滤隐藏的字段
  modelDsl.columns = modelDsl.columns.filter((column) => {
    if (modelDsl.option) {
      //
      if (modelDsl.option?.timestamps) {
        if (column.name == "updated_at" || column.name == "created_at") {
          return false;
        }
      }
      if (modelDsl.option?.soft_deletes) {
        if (column.name == "deleted_at") {
          return false;
        }
      }
    }
    return true;
  });
  modelDsl.columns.forEach((col) => {
    // 传换成bool类型
    ["index", "nullable", "unique", "primary"].forEach((key) => {
      if (col[key] !== null && col[key] !== undefined) {
        if (col[key] === true || col[key] > 0) {
          col[key] = true;
        }
      }
    });
    // 非浮点类型不需要scale属性。
    let type = col.type?.toUpperCase();
    if (
      type &&
      !type.includes("DOUBLE") &&
      !type.includes("DEMICAL") &&
      !type.includes("FLOAT")
    ) {
      delete col.scale;
    }

    if (Array.isArray(col.options) && col.options.length > 0) {
      col.option = [];
      col.options.forEach((opt) => {
        col.option.push(opt.value);
      });
    } else {
      if (col.option != null && typeof col.option === "string") {
        try {
          col.option = JSON.parse(col.option);
        } catch (error) {}
      }
      if (Array.isArray(col.option) && col.option.length > 0) {
        col.options = [];
        col.option.forEach((opt) => {
          col.options.push({
            label: opt,
            value: opt,
          });
        });
      }
    }

    if (col.type == "boolean" && typeof col.default === "string") {
      if (col.default.toLowerCase() == "true") {
        col.default = true;
      } else if (col.default.toLowerCase() == "false") {
        col.default = false;
      }
    }
    // 长度不能为字符串
    if (col.length == "") {
      delete col.length;
    }

    if (col.type.toLowerCase() == "json" && col.default != null) {
      // console.log(
      //   `checking json default value for field ${col.name},default:${col.default}`
      // );
      if (!typeof col.default == "Object") {
        try {
          col.default = JSON.parse(col.default);
        } catch (error) {
          console.log(
            `Failed to convert the default value for field:${col.name}`
          );
        }
      }
    }
  });
  return modelDsl;
}
function ConvertModelToTableLine(modelDsl) {
  let line = {};
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

  //关联关系
  if (modelDsl.relations) {
    line.relations = [];
    let relations = [];
    for (const key in modelDsl.relations) {
      relations.push(UpdateRelationFromDsl(key, modelDsl.relations[key]));
    }
    line.relations = relations;
  }

  // 不是新的对象
  if (line.id !== null && line.id !== undefined) {
    return line;
  }
  //没有ID
  //根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  let tableName = line.table_name;
  const wheres = [];
  if (tableName) {
    wheres.push({ column: "table_name", value: tableName });
    wheres.push({
      method: "orwhere",
      column: "identity",
      value: line.identity,
    });
  } else {
    wheres.push({ method: "where", column: "identity", value: line.identity });
  }

  const [row] = Process("models.ddic.model.get", {
    wheres: wheres,
    with: {},
  });
  line.id = row?.id;
  return line;
}

function SaveModelTableLine(payload, force) {
  //先保存主表，获取id后再保存从表
  let saveFun = function (payload) {
    res = Process("models.ddic.model.Save", payload);
    if (res && res.code && res.code > 300) {
      throw res;
    }
    if (res != null) {
      SaveRelations(res, payload, force);
    }
    return res;
  };
  return RunTransaction(saveFun, payload);
}
//保存关联表数据
function SaveRelations(id, payload, force) {
  // BeforeDelete(id);
  SaveColumns(id, payload, force);
  return id;
}

//删除关联表数据
function BeforeDelete(id) {
  DeleteModelolumns(id);
}

function isAscOrder(arr) {
  for (let i = 0; i < arr.length - 1; i++) {
    if (arr[i].id > arr[i + 1].id) {
      return false;
    }
  }
  return true;
}
//保存ddic.model.column
function SaveColumns(modelId, payload, force) {
  if (modelId == null) {
    throw new Exception("无法保存columns,缺少模型主键！");
  }
  let cols = payload.columns || [];

  if (!cols.length) {
    return;
  }
  let needDelete = force;

  let hasOneColId = false;
  //检查记录中至少有一个主键。如果都没有ID，说明是新记录
  cols.forEach((col) => {
    if (col.id != null) {
      hasOneColId = true;
    }
  });
  //一个主键都没有，新对象
  if (hasOneColId === false) {
    needDelete = true;
  }
  // 排序有变化
  if (!needDelete) {
    if (!isAscOrder(cols)) {
      // console.log("排序有变化", cols);
      needDelete = true;
    }
  }
  if (!needDelete) {
    // 如果导入的列的数量比数据库中的少，需要先删除。
    const columns = Process("models.ddic.model.column.get", {
      wheres: [{ column: "model_id", value: modelId }],
    });
    if (columns.length > cols.length) {
      needDelete = true;
    }
  }
  if (needDelete) {
    cols.forEach((col) => delete col.id);
    DeleteModelolumns(modelId);
  }
  // 保存列清单
  var res = Process("models.ddic.model.column.EachSave", cols, {
    model_id: modelId,
  });
  if (res?.code && res.message) {
    throw res;
  } else {
    return modelId;
  }
}

//删除ddic.model.column == model_id
function DeleteModelolumns(id) {
  const err = Process("models.ddic.model.column.DeleteWhere", {
    wheres: [{ column: "model_id", value: id }],
  });
  if (err?.message) {
    throw new Exception(err.message, err.code);
  }
  //remembe to return the id in array format
  return [id];
}

//多对一表数据查找
function AfterFind(payload) {
  const t = new Query();
  payload["columns"] = t.Get({
    from: "ddic_model_column",
    wheres: [{ column: "model_id", op: "=", value: payload.id }],
    select: [
      "id",
      "model_id",
      "name",
      "label",
      "index",
      "unique",
      "element_id",
      "type",
      "length",
      "precision",
      "scale",
      "nullable",
      "crypt",
      "default",
      "comment",
    ],
  });
  return payload;
}

function ConvertModelColToTableLine(model, modelCol) {
  //复制而不是直接修改
  let col = { ...modelCol };

  // 增加模型标识，方便搜索
  col.model_identity = model.identity;

  if (!col.label) {
    col.label = col.name;
  }
  if (!col.comment && col.label) {
    col.comment = col.label;
  }
  // 转换

  let ismysql = IsMysql();
  ["index", "nullable", "unique", "primary"].forEach((key) => {
    if (col[key] !== null && col[key] !== undefined) {
      if (col[key] === true || col[key] > 0) {
        col[key] = ismysql ? 1 : true;
      }
    }
  });

  // if (Array.isArray(col.option)) {
  //   col.options = col.options || [];

  //   col.options = col.option?.map((item) => {
  //     return { label: item, value: item };
  //   });
  // }
  return col;
}

function UpdateRelationFromDsl(key, rel) {
  let data = rel;
  data.name = key;
  data.model = rel.model;
  //must do this in case xgen will dump
  // data.query = JSON.stringify(rel.query);
  data.query = rel.query;
  return data;
}

/**
 * 把AmisModel转换成YaoModel
 * @param {object} modelDsl
 */
function ConvertApiObjectToModel(modelDsl) {
  let model = { ...modelDsl };
  model.id = model.header?.id;
  model.ID = model.header?.identity;
  model.comment = model.header?.comment;
  model.name = model.header?.name;

  delete model.header;

  if (Array.isArray(model.columns)) {
    model.columns.forEach((col) => {
      // 兼容处理,amis index字段用于表格索引,使用is_index作替代
      if (col.hasOwnProperty("is_index")) {
        col.index = col.is_index;
        delete col.is_index;
      }
    });
  }
  return model;
}
/**
 * 从YaoModel转换成AmisModel
 * @param {object} modelDsl
 */
function ConvertModelToApiObject(modelDsl) {
  let model = { ...modelDsl };

  model.header = model.header || {};
  model.columns = model.columns || {};

  model.header.id = model.id;
  model.header.identity = model.ID;
  model.header.comment = model.comment;
  model.header.name = model.name;

  if (Array.isArray(model.columns)) {
    model.columns.forEach((col) => {
      // 兼容处理,amis index字段用于表格索引,使用is_index作替代
      if (col.hasOwnProperty("index")) {
        col.is_index = col.index;
        delete col.index;
      }
    });
  }
  return model;
}

function bytesToString(bytes) {
  let string = "";
  for (let i = 0; i < bytes.length; i++) {
    string += String.fromCharCode(bytes[i]);
  }
  return string;
}
function migrateModel(modelId, forceIn) {
  let force = forceIn;
  if (IsSqlite()) {
    force = true;
  }
  if (force == null) {
    force = false;
  }

  // console.log("migrate force:", force);

  if (modelId.toLowerCase().startsWith("ddic.model") && force) {
    throw new Exception(`不能删除系统模型:${modelId}`);
  }
  err = Process(`models.${modelId}.migrate`, force);
  // console.log("migrate err:", err);
  if (err?.Message && err?.Number) {
    const sqlStateString = bytesToString(err.SQLState);

    throw new Exception(
      `Message:${err.Message},Number:${err.Number},SQLState:${sqlStateString}`,
      500
    );
  }

  return err;
}
/**
 * 把模型定义加载到模型缓存中。
 * Yao中的模型定义可以保存在文件中，也可以放在别的地方，最终是加载到Yao的应用缓存中
 * @param {object} modelDsl 模型定义
 * @param {boolean} migrate 更新数据库
 * @param {boolean} force 强制更新
 * @returns
 */
function loadModeltoMemory(modelDsl, migrate, force) {
  if (!Array.isArray(modelDsl.columns) && !modelDsl.columns?.length) {
    return;
  }
  if (modelDsl.table?.name && modelDsl.ID && modelDsl.columns?.length) {
    let fname = `${modelDsl.ID}.mod.json`;
    fname = FileNameConvert(fname);

    // console.log("modelDsl", modelDsl);
    let err = Process(
      `models.${modelDsl.ID}.load`,
      fname,
      JSON.stringify(modelDsl)
    );
    if (!err && migrate) {
      err = migrateModel(modelDsl.ID, force);
    }
    return err;
  } else {
    throw new Exception("模型定义不完整，缺少必要信息");
  }
}
/**
 * 保存模型定义，并返回更新后的模型定义
 * @param {object} payload 模型定义
 * @returns object
 */
function saveModelApi(payload) {
  //处理amis与yao的兼容性
  let model = ConvertApiObjectToModel(payload);

  model = CompleteModel(model);
  CheckModel(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  let id = SaveModelTableLine(line, model.option?.migrate_force);

  if (id) {
    let err = loadModeltoMemory(
      model,
      !model.option?.read_only,
      model.option?.migrate_force
    );

    if (err?.message) {
      return Process("scripts.return.ErrorMessage", err.Code, err.Message);
    }
  } else {
    return Process("scripts.return.ErrorMessage", 403, "保存模型失败");
  }

  return Process("scripts.return.Success", getModelApi(id), "保存成功");
}

/**
 * 保存Yao模型到数据库，并返回id,
 * 注意这个方法并不作模型迁移
 * scripts.system.model.ImportCachedModelToDB
 * @param {object} modelDsl Yao模型
 * @returns id
 */
function ImportCachedModelToDB(modelDsl) {
  let model = CompleteModel(modelDsl);
  CheckModel(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  return SaveModelTableLine(line, true);
}

/**
 * 把模型元定义从缓存中导入到数据库,有缓存，相当于本地模型
 * yao run scripts.system.model.ImportCachedModelById
 * @param {string} modelId 模型ID
 * @returns
 */
function ImportCachedModelById(modelId) {
  let model = FindCachedModelById(modelId);
  if (!model) {
    throw new Exception(`模型:${modelId}不存在于缓存中`, 500);
  }
  // 传入的是模型数据，转成表结构后再保存
  let id = ImportCachedModelToDB(model);
  if (id) {
    const err = migrateModel(modelId, false);
    if (err?.code && err.message) {
      throw new Exception(err.message, err.code);
    }
  }
}

function RunTransaction(fun, ...args) {
  const t = new Query();
  const ismysql = IsMysql();
  if (ismysql) {
    t.Run({
      sql: {
        stmt: "START TRANSACTION;",
      },
    });
  }

  try {
    // var firstParam = Array.prototype.shift.call(arguments);
    const ret = fun(...args);

    if (ismysql) {
      t.Run({
        sql: {
          stmt: "COMMIT;",
        },
      });
    }
    return ret;
  } catch (error) {
    if (ismysql) {
      t.Run({
        sql: {
          stmt: "ROLLBACK;",
        },
      });
    }
    throw error;
  }
}

/**
 * yao run scripts.system.model.DeleteModelMetaById 90
 * 删除模型
 * @param {number} modelId 模型标识
 */
function DeleteModelMetaByIdBatch(modelId) {
  let models = modelId + "";
  const ids = models.split(",");
  ids.forEach((id) => DeleteModelMetaById(id));
}
function DeleteModelMetaById(modelId) {
  // 检查是否存在，不存在会报错
  Process("models.ddic.model.Find", modelId, {});

  const deleteFun = function (modelId) {
    // 先删除列定义
    let ret = Process("models.ddic.model.column.DeleteWhere", {
      wheres: [{ column: "model_id", value: modelId }],
    });
    if (ret?.code && ret.message) {
      throw ret;
    }

    ret = Process("models.ddic.model.Delete", modelId);
    if (ret?.code && ret.message) {
      throw ret;
    }
  };
  return RunTransaction(deleteFun, modelId);
}

/**
 * 从数据库转成到Yao模型配置
 * scripts.system.model.ConvertTableLineToModel
 * @param {*} line
 * @returns
 */
function ConvertTableLineToModel(line) {
  let model = {
    table: {},
    option: {},
    relations: {},
    columns: [],
  };
  model.id = line.id;
  model.ID = line.identity;
  model.name = line.name;
  model.comment = line.comment;
  model.table.name = line.table_name;
  //option
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

  line.relations?.forEach((rel) => {
    model.relations[rel.name] = rel;
    //
    if (typeof rel.query == "string") {
      try {
        model.relations[rel.name].query = JSON.parse(rel.query);
      } catch (error) {
        model.relations[rel.name].query = {};
      }
    }
  });
  line.columns?.forEach((col) => {
    ["index", "nullable", "unique", "primary"].forEach((key) => {
      if (col.hasOwnProperty(key)) {
        if (col[key] === true || col[key] > 0) {
          col[key] = true;
        }
      }
    });
    //复制options到option,option只保存了值列表
    if (Array.isArray(col.options) && col.option == null) {
      col.option = [];
      col.options.forEach((opt) => {
        col.option.push(opt.value);
      });
      // don't delete it
      // delete col.options;
    }

    let colNew = { ...col };
    // 如果存在模板配置，把元素配置复制过来
    if (col.element_id) {
      const ele = Process("models.ddic.model.element.Find", col.element_id, {});
      ["type", "length", "scale", "precision"].forEach((field) => {
        if (col[field] == null && ele.hasOwnProperty(field)) {
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

    if (col.default != null && col.type == "boolean") {
      if (col.default > 0 || col.default?.toLowerCase() == "true") {
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
      if (column.name == "updated_at" || column.name == "created_at") {
        return false;
      }
    }
    if (model.option?.soft_deletes) {
      if (column.name == "deleted_at") {
        return false;
      }
    }
    return true;
  });

  model = ClearFalsyKeys(model);

  return model;
}

/**
 * 从数据库中加载Yao模型,返回一个Yao模型定义
 * yao run scripts.system.model.getModelFromDB
 * @param {int/string} modelId 模型ID标识
 * @returns
 */
function getModelFromDB(modelId) {
  //数字ID可能是数据库数据

  //根据id在数据库表中查找
  const [line] = Process("models.ddic.model.get", {
    wheres: [
      { column: "identity", value: modelId },
      {
        method: "orwhere",
        column: "id",
        value: modelId,
      },
    ],
    withs: {
      columns: {},
    },
  });

  if (line != null) {
    // 数据库表信息转成模型定义
    let model = ConvertTableLineToModel(line);
    return model;
  }
}

/**
 * 根据模型ID获取模型定义
 * 模型有可能会保存在两个位置，一个是在数据库里，根据数据库ID,
 * 读取已经加载在内存中的模型的定义，受限里yao的程序解析
 * 数据库中的信息会比内存的信息更加丰富，可以自由扩展
 * yao run scripts.system.model.getModelApi system.auth.role
 * @param {string/number} modelId
 * @returns
 */
function getModelApi(modelId) {
  return ConvertModelToApiObject(getModelById(modelId));
}

/**
 *
 * @param {string} modelId 模型ID
 * @returns
 */
function getModelColumnsApi(modelId) {
  const model = ConvertModelToApiObject(getModelById(modelId));
  if (model?.columns) {
    model?.columns.forEach((x, idx) => {
      x.checked = true;
      x.index = idx;
    });
  }
  // 前端使用的是input-table,不要使用items，会有异常。
  // 前端在引用时也要使用columns,不要把input-table的name设置成items。
  return {
    columns: model?.columns || [],
  };
}

/**
 * 加载模型标识，优先从数据库中加载，找不到再在缓存中加载
 * 数据库的模型信息会更多
 * yao run scripts.system.model.getModelById
 * @param {string} modelId 模型标识
 * @returns
 */
function getModelById(modelId) {
  if (!modelId) {
    return;
  }
  let model = getModelFromDB(modelId);
  if (model == null) {
    model = FindCachedModelById(modelId);
  }
  if (model != null) {
    // 已经存在数据库，并不能保证已经加载到缓存
    const model2 = FindCachedModelById(modelId);
    if (model2 == null) {
      try {
        // 加载到内存中。
        let err = loadModeltoMemory(model, false);
        if (err?.code && err?.Message) {
          throw Error(err?.Message + err?.code);
        }
      } catch (error) {
        // 在读取时，如果有错误，不需要报错
        console.log(
          `Error Where Load loadModeltoMemory:${model.ID},error:${error}`
        );
      }
    }
  }
  return model;
}

// function getYaoModel(modelId) {
//   if (!modelId) {
//     return;
//   }
//   // 如果数据库里没有，从内存中加载定义
//   // 只有加载到内存的才能获取的了
//   let model = FindCachedModelById(modelId);
//   if (model == null) {
//     //check and load from db
//     model = getModelFromDB(modelId);
//     if (model) {
//       // 加载到内存中。
//       let err = loadModeltoMemory(model, false);
//       if (err?.code && err?.Message) {
//         throw err;
//       }
//     }
//   }
//   return model;
// }

/**
 * yao run scripts.system.model.getModelColumnMap system.auth.role
 * 返回模型的columns定义
 * @param {string} modelId 模型ID
 * @returns 返回模型的columns定义
 */
function getModelColumnMap(modelId) {
  const modelData = FindCachedModelById(modelId);
  let columnMap = {};
  if (modelData && modelData.columns) {
    modelData.columns.forEach((col) => {
      columnMap[col.name] = col;
    });
  }
  return columnMap;
}

function Source(modelId) {
  const model = Process("models.ddic.model.Find", modelId, {
    withs: {
      columns: { withs: { element: {} } },
    },
  });

  const m = ConvertTableLineToModel(model);
  m.columns.forEach((col) => {
    delete col.id;
    delete col.model_id;
    delete col.element_id;
    delete col.model_identity;
  });
  delete m.id;
  delete m.ID;
  return { source: m };
}

function CheckModel(model) {
  let message = [];

  if (!model.ID || !model.ID.length) {
    message.push(`模型标识不能为空`);
  }
  if (!model.table?.name || !model.table?.name.length) {
    message.push(`数据库表名称不能为空`);
  }
  if (model.id != null) {
    let line = Process("models.ddic.model.Find", model.id, {});
    //  不存在会直接报错
    if (model.ID && model.ID != line.identity) {
      message.push(
        `模型已经存在，但是模型标识[${model.ID}]与数据库表[${line.identity}]不一致`
      );
    }
    if (model.table?.name && model.table.name != line.table_name) {
      message.push(
        `模型已经存在，但是表名称不一致，新表名${model.table?.name},已经存在${line.table_name}`
      );
    }
  }

  //根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  let tableName = model.table.name;
  const wheres = [];
  wheres.push({ column: "table_name", value: tableName });
  const [one] = Process("models.ddic.model.get", {
    wheres: wheres,
    with: {},
  });

  if (one?.id && model.id != null && one?.id != model.id) {
    message.push(
      `存在同名的表[${tableName}]，但是id不同[${model.id}]=>${one.id}`
    );
  }
  if (!Array.isArray(model.columns)) {
    message.push(`列定义应该是数组`);
  }

  if (model.columns.length == 0) {
    message.push(`不存在列定义`);
  }
  if (message.length > 0) {
    throw message.join("\n");
  }
}
function removeModelColumnIds(model) {
  if (!Array.isArray(model.columns) || !model.columns.length) {
    return model;
  }
  model.columns.forEach((col) => delete col.id);
  return model;
}
function ImportModelSource(payload) {
  let newCode = payload.source;
  newCode = newCode.replace(/\/\/.*[\r]\n/g, "");
  let model = JSON.parse(newCode);

  model = CompleteModel(model);
  CheckModel(model);
  model = removeModelColumnIds(model);
  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  const id = SaveModelTableLine(line);
  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.Message) {
      return Process("scripts.return.ErrorMessage", err.Code, err.Message);
    }
  } else {
    return Process(
      "scripts.return.ErrorMessage",
      403,
      "模型保存失败，导入失败"
    );
  }

  return Process("scripts.return.Success", { id: id }, "导入成功");
}

/**
 * 加载内部模型到数据库库，内部模型定义会在yao启动时自动加载到内存中。
 * yao run scripts.system.model.ImportCachedToDBBatch
 */
function ImportCachedToDBBatch() {
  const models = MomoryModelList();

  models.forEach((model) => {
    ImportCachedModelToDB(model);
  });
}
function ImportSystemModels() {
  ImportCachedToDBBatch();
  return { message: "导入成功" };
}
/**
 * yao run scripts.system.model.modelNameOption
 * @returns 返回模型ID列表
 */
function modelNameOption() {
  const list = ModelIDList();
  const models = list.map((model) => {
    return { label: model, value: model };
  });
  //不要直接返回数组，amis并不推荐直接返回数组
  // amis默认会使用items属性
  return { items: models };
}
//yao run scripts.system.model.modelNameList
function modelNameList() {
  const list = DatabaseModelList();
  const models = list.map((model) => {
    let label = model.comment ? model.comment : model.name;
    label = label ? label : model.identity;
    return {
      label: label,
      value: model.identity,
    };
  });
  return { items: models };
}

/**
 * 导入表结构,会强制刷新数据库与缓存
 * @param {object} payload 需要导入的模型
 * @returns
 */
function ImportTableAction(payload) {
  // const ms = cachedModels.filter((m) => m.table.name == payload.name);
  // if (Array.isArray(ms) && ms.length) {
  //   // 如果已经在缓存中存在，不要覆盖
  //   ms.forEach((module) => ImportCachedModelToDB(module));
  // } else {
  //如果不存在，把表结构转换成模型，转换成模型，再加载

  let model = Process("schemas.default.TableGet", payload.name);
  model.table = model.table || {};
  model.table.name = payload.name;
  model.ID = DotName(payload.name);
  model.name = payload.name;

  model = CompleteModel(model);
  CheckModel(model);
  model = removeModelColumnIds(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  let id = SaveModelTableLine(line);

  if (id) {
    const err = loadModeltoMemory(model, false);
    if (err && err.Message) {
      return Process("scripts.return.ErrorMessage", err.Code, err.Message);
    }
  } else {
    return Process("scripts.return.ErrorMessage", 403, "保存模型失败");
  }
  // }
}
/**
 * 从数据库读取模型并加载到内存中。
 * @param {*} payload
 * @returns
 */
function LoadToCacheFromDB(payload) {
  if (!payload) {
    return Process("scripts.return.ErrorMessage", 500, "数据不正确");
  }
  let modelId = payload.model;
  let model = getModelFromDB(modelId);
  if (model != null) {
    let err = loadModeltoMemory(model, false, true);
    if (err?.code && err?.Message) {
      throw Error(err?.Message + err?.code);
    }
  } else {
    return { message: `模型:${modelId}不存在`, code: 503 };
  }
  return { message: "缓存加载成功" };
}

function CheckImportModelLine(modelId, tableName) {
  //根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  const wheres = [];
  if (tableName) {
    wheres.push({ column: "table_name", value: tableName });
    wheres.push({
      method: "orwhere",
      column: "identity",
      value: modelId,
    });
  } else {
    wheres.push({ method: "where", column: "identity", value: modelId });
  }

  let [data] = Process("models.ddic.model.get", {
    wheres: wheres,
    with: {},
  });
  return data;
  // return data.filter((line) => !line.read_only)[0];
}

/**
 * 从Neo助手生成的模型导入
 * @param {object} payload 模型对象
 * @returns
 */
function ImportFromNeo(payload) {
  //处理amis与yao的兼容性
  let model = ConvertApiObjectToModel(payload);

  model = CompleteModel(model);
  CheckModel(model);

  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  let id = SaveModelTableLine(line);

  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.message) {
      throw new Exception(err.message, err.code);
    }
  } else {
    throw new Exception("保存模型失败", 503);
  }
  return id;
}
function ImportFromCached(payload) {
  if (!payload) {
    return Process("scripts.return.ErrorMessage", 500, "数据不正确");
  }
  ImportCachedModelById(payload.model);
  return { message: `模型:${payload.model}导入成功` };
}

/**
 * 批量导入本地缓存
 * @param {object} payload 请求数据
 * @returns
 */
function ImportFromCachedBatch(payload) {
  let items = payload.items;
  if (!Array.isArray(items)) {
    return { message: "传入数据不正确" };
  }
  items.forEach((item) => {
    ImportCachedModelById(item.model);
  });
  return { message: "批量导入本地缓存完成" };
}
function ImportFromTable(payload) {
  // console.log(payload);
  if (!payload) {
    return Process("scripts.return.ErrorMessage", 500, "数据不正确");
  }
  const model = CheckImportModelLine(payload.model, payload.name);
  if (model != null) {
    return {
      message: `模型:${payload.model}，表:${payload.name} 已经存在，禁止导入`,
    };
  }
  //先根据表名检查是否缓存中已经有对应的模型，如果存在，加载到数据库，
  // const models = MomoryModelList();
  ImportTableAction(payload);
  return { message: "导入表结构成功" };
}

function guessType(value) {
  if (!value) {
    return "string";
  }
  if (Number.isInteger(value)) {
    return "integer";
  } else if (!isNaN(value)) {
    return "float";
  }

  const timestamp = Date.parse(value); // Parse the datetime string

  if (!isNaN(timestamp)) {
    const date = new Date(timestamp); // Create a new date object from the timestamp
    if (
      date.getHours() === 0 &&
      date.getMinutes() === 0 &&
      date.getSeconds() === 0
    ) {
      return "date";
    } else {
      return "datetime";
    }
  }

  if (value === null) {
    return "string";
  } else if (typeof value === "number") {
    return "number";
  } else if (typeof value === "boolean") {
    return "boolean";
  } else if (typeof value === "string") {
    return "string";
  } else if (Array.isArray(value)) {
    return "json";
  } else if (typeof value === "object") {
    return "json";
  } else {
    return "string";
  }
}
function getLastPart(str) {
  // Split the string at "-" and get the last part (if "-" exists)
  const parts = str.split("-");
  const lastPart = parts[parts.length - 1];

  // If the last part is not undefined or null, return it
  if (lastPart) {
    return lastPart;
  } else {
    // If "-" does not exist in the string, return the original string
    return str;
  }
}
function guessAmisType(typeIn) {
  if (!typeIn) {
    return "unkown:" + typeIn;
  }
  let type = typeIn.toLowerCase();
  type = getLastPart(type);
  // type = type.replace("input-", "");
  // type = type.replace("static-", "");
  // type = type.replace("list-", "");
  // type = type.replace("tree-", "");

  if (type.includes("text")) {
    return "string";
  }
  if (type.endsWith("_id")) {
    return "integer";
  }
  switch (type) {
    case "number":
      return "integer";
    case "select":
      return "enum";
    case "switch":
    case "picker":
      return "boolean";

    default:
      break;
  }
  return "amis:" + typeIn;
}
function GuessAmisCols(columns) {
  let cols = [];
  function traval(node) {
    if (Array.isArray(node)) {
      node.forEach((x) => traval(x));
      return;
    }
    if (Array.isArray(node.body)) {
      node.body.forEach((x) => traval(x));
      return;
    }
    if (!node.type) {
      console.log("undeinfed");
      console.log(node);
    }
    let column = {
      name: node.name,
      type: guessAmisType(node.type),
      label: node.label,
    };
    if (node.required) {
      column.nullable = false;
    }
    if (node.description) {
      column.comment = node.description;
    }
    if (column.type == "enum") {
      column.options = node.options;
    }
    // console.log("column:==========>", column);

    cols.push(column);
  }
  traval(columns);
  return {
    columns: cols,
    status: "ok",
    message: "JSON检查成功",
  };
}
function CheckAndGuessJson(payload) {
  let json = payload.json;
  let type = payload.type;

  // console.log("json::::", json);
  if (json == null) {
    return {
      columns: [],
      code: 500,
      message: "请检查输入数据",
    };
  }
  if (typeof json === "string") {
    try {
      json = JSON.parse(payload.json);
    } catch (error) {
      throw new Exception("数据格式不正确", 500);
    }
  }

  if (!typeof json == "object") {
    throw new Exception("数据格式不正确", 500);
  }

  if (type === "amis") {
    return GuessAmisCols(json);
  }

  if (Array.isArray(json)) {
    json = json[0];
  }

  let columns = [];

  for (const [name, value] of Object.entries(json)) {
    let column = {
      name,
      type: guessType(value),
      label: name,
    };
    if (name.toLowerCase() == "id" && typeof value === "number") {
      column.type = "id";
    }
    columns.push(column);
  }

  return {
    columns: columns,
    status: "ok",
    message: "JSON检查成功",
  };
}
/**
 * 从数据库表中导入到模型
 * @param {object} payload 数据库表列表
 * @returns
 */
function ImportFromTableBatch(payload) {
  let items = payload.items;
  if (!Array.isArray(items)) {
    return { message: "传入数据不正确" };
  }

  items.forEach((item) => {
    const model = CheckImportModelLine(item.model, item.name);

    if (model != null) {
      return {
        message: `模型:${item.model}，表:${item.name} 已经存在，禁止导入`,
      };
    }
    ImportTableAction(item);
  });
  return { message: "批量导入表结构成功" };
}
