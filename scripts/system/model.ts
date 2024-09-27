/**
 * Yao模型管理
 * 模型的增删改查
 * 模型导入
 * 模型导出
 */
import {
  getModelFromDB,
  loadModeltoMemory,
  ConvertTableLineToModel,
  deepCopyObject,
  migrateModel,
  checkAndloadDefaultTableForm
} from '@scripts/system/model_db';

import {
  DotName,
  UnderscoreName,
  IsMysql,
  SlashName
} from '@scripts/system/lib';

import { RunTransaction } from '@scripts/system/db';

import { queryToQueryParam, mergeQueryObject } from '@scripts/amis/data/lib';

import {
  FindAndLoadYaoModelById,
  FilterCachedModelList,
  CachedModelIDList,
  FindAndLoadDBModelById,
  FindCachedModelById
} from '@scripts/system/model_lib';

import { convertColTypeToYao } from '@scripts/system/col_type';

import { Process, Exception, FS, log } from '@yao/yao';
import {
  AmisModelDB,
  AmisRelation,
  AmisModelColumn,
  AmisModel,
  ModelId,
  CachedModel,
  AmisUIModel,
  AmisUIColumn
} from '@yao/types';
import { YaoModel } from '@yaoapps/types';

/**
 * yao run scripts.system.model.page
 * 模型定义列表分页查询，结果在列表中显示。
 * @param {number} page
 * @param {number} pagesize
 * @param {object} querysIn
 * @param {object} queryParams
 * @param {object} payload
 * @returns
 */
export function page(pageIn, pagesizeIn, querysIn, queryParams, payload) {
  const page = pageIn || 1;
  const pagesize = pagesizeIn || 10;
  const querys = mergeQueryObject(querysIn, payload);
  const modelDsl = FindAndLoadYaoModelById('ddic.model');
  let queryParam = queryToQueryParam(modelDsl, querys, queryParams);
  queryParam = queryParam || {};
  queryParam['select'] = [
    'id',
    'name',
    'identity',
    'comment',
    'table_name',
    'table_comment'
  ];
  const data = Process(
    `models.ddic.model.Paginate`,
    queryParam,
    page,
    pagesize
  );
  return {
    items: data.data,
    total: data.total
  };
}

/**
 * 读取所有的模型id的列表
 * yao run scripts.system.model.DatabaseModelList
 * @returns array
 */
function DatabaseModelList(): AmisModelDB[] {
  const list = Process('models.ddic.model.get', {
    select: ['identity', 'name', 'comment']
  });
  list.forEach((item) => {
    if (item.comment == null) {
      item.comment = item.name ? item.name : item.identity;
    }
  });
  return list;
}

/**
 * 补全模型的定义
 * @param {object} modelDsl
 * @returns object
 */
function CompleteModel(modelDsl: AmisModel) {
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
  modelDsl.columns.forEach((col) => {
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
    const type = col.type?.toUpperCase();
    if (
      type &&
      !type.includes('DOUBLE') &&
      !type.includes('DEMICAL') &&
      !type.includes('FLOAT')
    ) {
      delete col.scale;
      delete col.precision;
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

    if (col.type == 'boolean' && typeof col.default === 'string') {
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
    const colType = col.type.toLowerCase();
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
      if (!(typeof col.default === 'object')) {
        try {
          col.default = JSON.parse(col.default);
        } catch (error) {
          log.Error(
            `Failed to convert the default value for field:${col.name}` +
              error.message
          );
        }
      }
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
  });

  if (modelDsl.relations != null) {
    for (const r in modelDsl.relations) {
      modelDsl.relations[r].label ||= r;
    }
  }

  return modelDsl;
}

/**
 * 转换模型定义成数据库表
 * @param {object} modelDsl 模型定义
 * @returns
 */
function ConvertModelToTableLine(modelDsl: AmisModel) {
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

/**
 * Save the model dsl to local file
 * @param {object} modelDsl
 * @returns
 */
function SaveModelToLocal(modelDsl: AmisModel) {
  const yaoEnv = Process('utils.env.Get', 'YAO_ENV');
  if (yaoEnv !== 'development') {
    return;
  }

  // 控制是否需要保存到本地
  const saveFlag = Process('utils.env.Get', 'SAVE_MODEL_FILE_TO_LOCAL');
  if (saveFlag !== 'true') {
    return;
  }

  // hacked,don't do this in production envirement
  // @ts-ignore
  __yao_data = { ROOT: true };
  let model_id = modelDsl.ID;
  if (!model_id) {
    model_id = modelDsl.table?.name;
  }
  if (!model_id) {
    console.log(`模型不完整，不保存成文件！`);
    return;
  }
  const model = ConvertDBmodelToYaoModel(modelDsl);

  const dsl = new FS('dsl');
  model_id = SlashName(model_id);
  dsl.WriteFile(`/models/${model_id}.mod.yao`, JSON.stringify(model));
  // @ts-ignore
  __yao_data = { ROOT: false };
}

function SaveModelTableLine(payload: AmisModelDB, force?: boolean): number {
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

// 删除关联表数据
export function BeforeDelete(id: number) {
  DeleteModelolumns(id);
}

export function isAscOrder(arr: { id: string }[]) {
  for (let i = 0; i < arr.length - 1; i++) {
    if (arr[i].id > arr[i + 1].id) {
      return false;
    }
  }
  return true;
}

/**
 * 保存ddic.model.column
 * @param {string} modelId
 * @param {object} payload
 * @param {boolean} force 强制保存
 * @returns
 */
function SaveColumns(modelId: number, payload, force?: boolean) {
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

function ConvertModelColToTableLine(
  model: AmisModelDB,
  modelCol: AmisModelColumn
) {
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
 * 把AmisModel转换成YaoModel
 * @param {object} modelDsl
 */
export function ConvertAmisUIModelToModel(modelDsl: AmisUIModel): AmisModel {
  const model = { ...modelDsl } as unknown as AmisModel;
  model.id = modelDsl.header?.id;
  model.ID = modelDsl.header?.identity;
  model.comment = modelDsl.header?.comment;
  model.name = modelDsl.header?.name;

  delete model.header;

  if (Array.isArray(model.columns)) {
    const cols = model.columns as unknown as AmisUIColumn[];
    cols.forEach((col) => {
      // 兼容处理,amis index字段用于表格索引,使用is_index作替代
      if (Object.prototype.hasOwnProperty.call(col, 'is_index')) {
        col.index = col.is_index as unknown as number;
        delete col.is_index;
      }
      if (Object.prototype.hasOwnProperty.call(col, '__index')) {
        delete col.__index;
      }
    });
  }
  return model;
}
/**
 * 从YaoModel转换成AmisModel
 * @param {object} modelDsl
 */
export function ConvertModelToAmisUIModel(modelDsl: AmisModel) {
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
 * 保存模型定义，并返回更新后的模型定义
 * @param {object} payload 模型定义
 * @returns object
 */
export function saveModelApi(payload: AmisUIModel) {
  // 处理amis与yao的兼容性
  let model = ConvertAmisUIModelToModel(payload);

  model = CompleteModel(model);
  CheckModel(model);

  // 传入的是模型数据，转成表结构后再保存
  SaveModelToLocal(model);
  const line = ConvertModelToTableLine(model);
  const id = SaveModelTableLine(line, model.option?.migrate_force);

  if (id != null) {
    const err = loadModeltoMemory(
      model,
      !model.option?.read_only,
      model.option?.migrate_force
    );

    if (err?.message) {
      return Process('scripts.return.ErrorMessage', err.Code, err.Message);
    }
  } else {
    return Process('scripts.return.ErrorMessage', 403, '保存模型失败');
  }

  return Process('scripts.return.RSuccess', getModelApi(id), '保存成功');
}

/**
 * 保存Yao模型到数据库，并返回id,
 * 注意这个方法并不作模型迁移
 * scripts.system.model.ImportCachedModelToDB
 * @param {object} modelDsl Yao模型
 * @returns id
 */
function ImportCachedModelToDB(modelDsl: CachedModel): number {
  const model = CompleteModel(modelDsl);
  CheckModel(model);

  // 导入缓存不要保存本地模型
  // SaveModelToLocal(model)
  // console.log("ImportCachedModelToDB", model)
  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  return SaveModelTableLine(line, true) as unknown as number;
}

/**
 * 把模型元定义从缓存中导入到数据库,有缓存，相当于本地模型
 * yao run scripts.system.model.ImportCachedModelById
 * @param {string} modelId 模型ID
 * @returns
 */
function ImportCachedModelById(modelId: string) {
  const model = FindCachedModelById(modelId);
  if (!model) {
    throw new Exception(`模型：${modelId} 未加载`);
  }
  // 传入的是模型数据，转成表结构后再保存
  const id = ImportCachedModelToDB(model);
  if (id) {
    const err = migrateModel(modelId, false);
    if (err?.code && err.message) {
      throw new Exception(err.message, err.code);
    }
  }
}

/**
 * yao run scripts.system.model.DeleteModelMetaById 90
 * 删除模型
 * @param {number} modelId 模型标识
 */
export function DeleteModelMetaByIdBatch(modelId: string) {
  const models = modelId + '';
  const ids = models.split(',');
  ids.forEach((id) => DeleteModelMetaById(id));
}
/**
 * 根据模型id删除模型定义
 * @param {string} modelId model id
 * @returns
 */
function DeleteModelMetaById(modelId: string) {
  // 检查是否存在，不存在会报错
  Process('models.ddic.model.Find', modelId, {});

  DeleteModelLocalFile(modelId);

  const deleteFun = function (modelId: string) {
    // 先删除列定义
    let ret = Process('models.ddic.model.column.DeleteWhere', {
      wheres: [{ column: 'model_id', value: modelId }]
    });
    if (ret?.code && ret.message) {
      throw ret;
    }

    ret = Process('models.ddic.model.Delete', modelId);
    if (ret?.code && ret.message) {
      throw ret;
    }
  };
  return RunTransaction(deleteFun, modelId as undefined);
}

/**
 * 删除本地模型定义文件
 * @param {string} modelId model id
 * @returns
 */
function DeleteModelLocalFile(modelId: string) {
  const yaoEnv = Process('utils.env.Get', 'YAO_ENV');
  if (yaoEnv !== 'development') {
    return;
  }
  const saveFlag = Process('utils.env.Get', 'SAVE_MODEL_FILE_TO_LOCAL');
  if (saveFlag !== 'true') {
    return;
  }
  // @ts-ignore
  __yao_data = { ROOT: true };
  const dsl = new FS('dsl');
  const model_id = SlashName(modelId);
  const fname = `/models/${model_id}.mod.yao`;
  if (dsl.Exists(fname)) {
    dsl.Remove(fname);
  }
  // @ts-ignore
  __yao_data = { ROOT: false };
}

/**
 * 根据模型ID获取模型定义
 * 模型有可能会保存在两个位置，一个是在数据库里，根据数据库ID,
 * 读取已经加载在内存中的模型的定义，受限里yao的程序解析
 * 数据库中的信息会比内存的信息更加丰富，可以自由扩展
 * yao run scripts.system.model.getModelApi admin.auth.role
 * @param {string | number} modelId
 * @returns
 */
export function getModelApi(modelId: string | number) {
  return ConvertModelToAmisUIModel(getModelDslById(modelId));
}

/**
 *
 * @param {string} modelId 模型ID
 * @returns
 */
export function getModelColumnsApi(modelId: string) {
  const model = ConvertModelToAmisUIModel(getModelDslById(modelId));
  if (Array.isArray(model?.columns) && model.columns.length) {
    model?.columns?.forEach((x, idx) => {
      x.checked = true;
      x.index = idx;
    });
  }
  // 前端使用的是input-table,不要使用items，会有异常。
  // 前端在引用时也要使用columns,不要把input-table的name设置成items。
  return {
    columns: model?.columns || []
  };
}

/**
 * 加载模型标识，优先从数据库中加载，找不到再在缓存中加载
 * 数据库的模型信息会更多
 * yao run scripts.system.model.getModelDslById
 * @param {string} modelId 模型标识
 * @returns
 */
export function getModelDslById(modelId: ModelId) {
  return FindAndLoadDBModelById(modelId);
}

// function getYaoModel(modelId) {
//   if (!modelId) {
//     return;
//   }
//   // 如果数据库里没有，从内存中加载定义
//   // 只有加载到内存的才能获取的了
//   let model = FindAndLoadYaoModelById(modelId);
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
 * yao run scripts.system.model.getYaoModelColumnMap admin.auth.role
 * 返回模型的columns定义
 * @param {string} modelId 模型ID
 * @returns 返回模型的columns定义
 */
export function getYaoModelColumnMap(modelId: string) {
  const modelDsl = FindAndLoadYaoModelById(modelId);
  const columnMap = {};
  if (modelDsl && modelDsl.columns) {
    modelDsl.columns.forEach((col) => {
      columnMap[col.name] = col;
    });
  }
  // fillup the miss col
  if (modelDsl.option?.soft_deletes) {
    columnMap['deleted_at'] = {
      type: 'datetime'
    };
  } else if (modelDsl.option?.timestamps) {
    columnMap['updated_at'] = {
      type: 'datetime'
    };
    columnMap['created_at'] = {
      type: 'datetime'
    };
  }
  return columnMap;
}
/**
 * get the model source in json format
 * yao run scripts.system.model.ExportModelToYaoSource
 * @param {string} modelId
 * @returns
 */
export function ExportModelSource(modelId: string) {
  const model = Process('models.ddic.model.Find', modelId, {
    withs: {
      columns: { withs: { element: {} } }
    }
  });

  const m = ConvertTableLineToModel(model);

  // m = ConvertDBmodelToYaoModel(m);

  return { source: m };
}

/**
 * get the model source in yao format
 * yao run scripts.system.model.ExportModelYaoSource
 * @param {string} modelId
 * @returns
 */
export function ExportModelYaoSource(modelId: string) {
  const model = Process('models.ddic.model.Find', modelId, {
    withs: {
      columns: { withs: { element: {} } }
    }
  });

  let m = ConvertTableLineToModel(model);

  m = ConvertDBmodelToYaoModel(m);

  return { source: m };
}

/**
 * Db模型转换成yao模型
 * @param {object} modelDsl
 * @returns
 */
function ConvertDBmodelToYaoModel(modelDsl: AmisModel) {
  const m = deepCopyObject(modelDsl);
  m.columns.forEach((col) => {
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
    col = convertColTypeToYao(col);

    ['index', 'nullable', 'primary', 'unique'].forEach((item) => {
      if (item in col && col[item] === false) {
        delete col[item];
      }
    });
  });
  if (m.option) {
    delete m.option.migrate_force;
  }
  delete m.id;
  delete m.ID;

  return m;
}

/**
 * 检查模型定义的完整性，Check the model dsl
 * @param {object} modelDsl model dsl
 */
function CheckModel(modelDsl: AmisModel) {
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

  const cModelList = CachedModelIDList();
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
            const col = cmodelDsl.columns.find((c) => c.name == relation.key);
            if (col == null) {
              message.push(
                `关联模型${relation.model}的字段${relation.key}不存在`
              );
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
/**
 * 移除模型类定义中的id字段，在一些使用场景中需要全新插入，需要先移除所有的id
 * @param {object} modelDsl model dsl
 * @returns
 */
function removeModelColumnIds(modelDsl: AmisModel) {
  if (!Array.isArray(modelDsl.columns) || !modelDsl.columns.length) {
    return modelDsl;
  }
  modelDsl.columns.forEach((col) => delete col.id);
  return modelDsl;
}

/**
 * 从源代码导入模型定义
 * @param {object} payload 外部传的源代码
 * @returns
 */
export function ImportModelFromSource(payload: { ID: string; source: string }) {
  const ID = payload.ID;
  let newCode = payload.source;
  newCode = newCode.replace(/\/\/.*$/gm, '');
  newCode = newCode.replace(/\/\*.*?\*\//gs, '');
  let model = JSON.parse(newCode);
  model.ID = ID || model.ID;
  model = CompleteModel(model);
  CheckModel(model);
  model = removeModelColumnIds(model);
  SaveModelToLocal(model);
  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  const id = SaveModelTableLine(line) as unknown as number;
  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.Message) {
      return Process('scripts.return.ErrorMessage', err.Code, err.Message);
    }
  } else {
    return Process(
      'scripts.return.ErrorMessage',
      403,
      '模型保存失败，导入失败'
    );
  }

  return Process('scripts.return.RSuccess', { id: id }, '导入成功');
}

/**
 * 批量把所有的数据库的模型加载到缓存
 * yao run scripts.system.model.importDBModelsToCache
 */
export function importDBModelsToCache() {
  const list = DatabaseModelList();

  list.forEach((m) => {
    const modelDsl = getModelFromDB(m.identity);

    loadModeltoMemory(modelDsl);
  });
  loadDefaultFormTableFormAllModel();
}
/**
 * 加载所有的模型关联的form与table定义
 */
export function loadDefaultFormTableFormAllModel() {
  // need import the db model first.
  const list = allModelIds();
  list.forEach((l) => checkAndloadDefaultTableForm(l));
}
/**
 * return the id and the name info for all models.
 * yao run scripts.system.model.allModelIdAndName
 * @returns
 */
export function allModelIdAndName(): { id: string; name: string }[] {
  const modelIds = FilterCachedModelList('ID');
  const modelsFromDb = DatabaseModelList();

  // 使用Map提高性能
  const modelMap = new Map<string, string>();

  // 处理内存中的模型
  modelIds.forEach((m) => modelMap.set(m.ID, m.ID));

  // 处理数据库中的模型，优先使用name
  modelsFromDb.forEach((m) => modelMap.set(m.identity, m.name || m.identity));

  // 将Map转换为数组
  return Array.from(modelMap, ([id, name]) => ({ id, name }));
}

/**
 * 所有模型的ID
 */
export function allModelIds() {
  let modelIds = CachedModelIDList();
  // const models = FilterCachedModelList('ID');
  // models.forEach((m) => modelIds.push(m.ID));
  const modelsFromDb = DatabaseModelList();
  modelsFromDb.forEach((m) => modelIds.push(m.identity));

  modelIds = [...new Set(modelIds)];
  return modelIds;
}

/**
 * 加载内部模型到数据库库，内部模型定义会在yao启动时自动加载到内存中。
 * yao run scripts.system.model.ImportCachedToDBBatch
 */
function ImportCachedToDBBatch() {
  const models = FilterCachedModelList();

  models.forEach((model) => {
    ImportCachedModelToDB(model);
  });
}
export function ImportSystemModels() {
  ImportCachedToDBBatch();
  return { message: '导入成功' };
}
/**
 * yao run scripts.system.model.modelNameOption
 * @returns 返回模型ID列表
 */
export function modelNameOption() {
  const list = CachedModelIDList();
  const models = list.map((model) => {
    return { label: model, value: model };
  });
  // 不要直接返回数组，amis并不推荐直接返回数组
  // amis默认会使用items属性
  return { items: models };
}
// yao run scripts.system.model.modelNameList
export function modelNameList() {
  const list = DatabaseModelList();
  const models = list.map((model) => {
    let label = model.comment ? model.comment : model.name;
    label = label ? label : model.identity;
    return {
      label: label,
      value: model.identity
    };
  });
  return { items: models };
}

/**
 * 导入表结构,会强制刷新数据库与缓存
 * @param {object} payload 需要导入的模型
 * @returns
 */
function ImportTableAction(payload: { name: string }) {
  // const ms = cachedModels.filter((m) => m.table.name == payload.name);
  // if (Array.isArray(ms) && ms.length) {
  //   // 如果已经在缓存中存在，不要覆盖
  //   ms.forEach((module) => ImportCachedModelToDB(module));
  // } else {
  // 如果不存在，把表结构转换成模型，转换成模型，再加载

  let model = Process('schemas.default.TableGet', payload.name) as AmisModel;
  model.table = model.table || {};
  model.table.name = payload.name;
  model.ID = DotName(payload.name);
  model.name = payload.name;

  model = CompleteModel(model);
  CheckModel(model);
  model = removeModelColumnIds(model);

  SaveModelToLocal(model);

  let dbModel = deepCopyObject(model);
  dbModel = guessModelColumnsType(dbModel);
  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(dbModel);
  const id = SaveModelTableLine(line);

  if (id) {
    const err = loadModeltoMemory(model, false);
    if (err && err.Message) {
      return Process('scripts.return.ErrorMessage', err.Code, err.Message);
    }
  } else {
    return Process('scripts.return.ErrorMessage', 403, '保存模型失败');
  }
  // }
}

function isTextColumn(column) {
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
function guessModelColumnsType(modelDsl: AmisModel) {
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
 * 从数据库读取模型并加载到内存中。
 * @param {*} payload
 * @returns
 */
export function LoadToCacheFromDB(payload: { model: string }) {
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  const modelId = payload.model;
  const model = getModelFromDB(modelId);
  if (model != null) {
    const err = loadModeltoMemory(model, false, true);
    if (err?.code && err?.Message) {
      throw Error(err?.Message + err?.code);
    }
  } else {
    return { message: `模型:${modelId}不存在`, code: 503 };
  }
  return { message: '缓存加载成功' };
}

function CheckImportModelLine(modelId: string, tableName: string) {
  // 根据表名或是模型名称，检查是否已经存在同样ID的模型，防止误更更新
  const wheres = [];
  if (tableName) {
    wheres.push({ column: 'table_name', value: tableName });
    wheres.push({
      method: 'orwhere',
      column: 'identity',
      value: modelId
    });
  } else {
    wheres.push({ method: 'where', column: 'identity', value: modelId });
  }

  const [data] = Process('models.ddic.model.get', {
    wheres: wheres,
    withs: {}
  });
  return data;
  // return data.filter((line) => !line.read_only)[0];
}

/**
 * 从Neo助手生成的模型导入
 * @param {object} payload 模型对象
 * @returns
 */
export function ImportFromNeo(payload: AmisUIModel) {
  // 处理amis与yao的兼容性
  let model = ConvertAmisUIModelToModel(payload);

  model = CompleteModel(model);
  CheckModel(model);

  SaveModelToLocal(model);
  // 传入的是模型数据，转成表结构后再保存
  const line = ConvertModelToTableLine(model);
  const id = SaveModelTableLine(line);

  if (id) {
    const err = loadModeltoMemory(model, !model.option?.read_only);
    if (err && err.message) {
      throw new Exception(err.message, err.code);
    }
  } else {
    throw new Exception('保存模型失败', 503);
  }
  return id;
}
export function ImportFromCached(payload) {
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  ImportCachedModelById(payload.model);
  return { message: `模型:${payload.model}导入成功` };
}

/**
 * 批量导入本地缓存
 * @param {object} payload 请求数据
 * @returns
 */
export function ImportFromCachedBatch(payload) {
  const items = payload.items;
  if (!Array.isArray(items)) {
    return { message: '传入数据不正确' };
  }
  items.forEach((item) => {
    ImportCachedModelById(item.model);
  });
  return { message: '批量导入本地缓存完成' };
}
export function ImportTableStruct(payload) {
  // console.log(payload);
  if (!payload) {
    return Process('scripts.return.ErrorMessage', 500, '数据不正确');
  }
  const model = CheckImportModelLine(payload.model, payload.name);
  if (model != null) {
    return {
      message: `模型:${payload.model}，表:${payload.name} 已经存在，禁止导入`
    };
  }
  // 先根据表名检查是否缓存中已经有对应的模型，如果存在，加载到数据库，
  // const models = FilterCachedModelList();
  ImportTableAction(payload);
  return { message: '导入表结构成功' };
}

function guessJsonType(value) {
  if (!value) {
    return 'string';
  }
  const isNumber = /^-?\d*\.?\d+$/.test(value);

  if (value === null) {
    return 'string';
  } else if (isNumber) {
    if (/^-?\d+$/.test(value)) {
      return 'integer';
    } else if (!isNaN(value)) {
      return 'float';
    }
  } else if (typeof value === 'boolean') {
    return 'boolean';
  } else if (typeof value === 'string') {
    const timestamp = Date.parse(value); // Parse the datetime string

    if (!isNaN(timestamp)) {
      const date = new Date(timestamp); // Create a new date object from the timestamp
      if (
        date.getHours() === 0 &&
        date.getMinutes() === 0 &&
        date.getSeconds() === 0
      ) {
        return 'date';
      } else {
        return 'datetime';
      }
    }
    return 'string';
  } else if (Array.isArray(value)) {
    return 'json';
  } else if (typeof value === 'object') {
    return 'json';
  } else {
    return 'string';
  }
}
function getLastPart(str) {
  // Split the string at "-" and get the last part (if "-" exists)
  const parts = str.split('-');
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
    return 'string';
  }
  let type = typeIn.toLowerCase();
  type = getLastPart(type);
  // type = type.replace("input-", "");
  // type = type.replace("static-", "");
  // type = type.replace("list-", "");
  // type = type.replace("tree-", "");

  if (type.includes('text')) {
    return 'string';
  }
  if (type.endsWith('_id')) {
    return 'integer';
  }
  switch (type) {
    case 'number':
      return 'integer';
    case 'select':
      return 'enum';
    case 'switch':
    case 'picker':
      return 'boolean';

    default:
      break;
  }
  return 'string';
}
function GuessAmisCols(columns) {
  const cols = [];
  function traverse(node) {
    if (Array.isArray(node)) {
      node.forEach((x) => traverse(x));
      return;
    }
    if (Array.isArray(node.body)) {
      node.body.forEach((x) => traverse(x));
      return;
    }

    const column = {
      name: node.name,
      type: guessAmisType(node.type),
      label: node.label
    } as AmisModelColumn;
    if (node.required) {
      column.nullable = false;
    }
    if (node.description) {
      column.comment = node.description;
    }
    if (column.type == 'enum') {
      column.options = node.options;
    }

    cols.push(column);
  }
  traverse(columns);
  return {
    columns: cols,
    status: 'ok',
    message: 'JSON检查成功'
  };
}
export function CheckAndGuessJson(payload) {
  let json = payload.json;
  const type = payload.type;

  // console.log("json::::", json);
  if (json == null) {
    return {
      columns: [],
      code: 500,
      message: '请检查输入数据'
    };
  }
  if (typeof json === 'string') {
    try {
      json = JSON.parse(payload.json);
    } catch (error) {
      throw new Exception('数据格式不正确' + error.message, 500);
    }
  }

  if (!(typeof json == 'object')) {
    throw new Exception('数据格式不正确', 500);
  }

  if (type === 'amis') {
    return GuessAmisCols(json);
  }

  if (Array.isArray(json)) {
    json = json[0];
  }

  const columns = [];

  for (const [name, value] of Object.entries(json)) {
    const column = {
      name,
      type: guessJsonType(value),
      label: name
    };
    if (name.toLowerCase() == 'id' && typeof value === 'number') {
      column.type = 'id';
    }
    columns.push(column);
  }

  return {
    columns: columns,
    status: 'ok',
    message: 'JSON检查成功'
  };
}
/**
 * 从数据库表中导入到模型
 * @param {object} payload 数据库表列表
 * @returns
 */
export function ImportFromTableBatch(payload) {
  const items = payload.items;
  if (!Array.isArray(items)) {
    return { message: '传入数据格式不正确，需要传入数组！' };
  }

  for (const item of items) {
    const model = CheckImportModelLine(item.model, item.name);

    if (model != null) {
      return {
        code: 503,
        message: `模型:${item.model}，表:${item.name} 已经存在，禁止导入！`
      };
    }
    ImportTableAction(item);
  }
  return { message: '批量导入表结构成功。' };
}
