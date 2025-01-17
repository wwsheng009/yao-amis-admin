import { ModelId, SearchResult } from '@yao/types';
import { Exception, log, Process } from '@yaoapps/client';
import { QueryObjectIn } from '@yao/request';
import { YaoModel, YaoQueryParam } from '@yaoapps/types';
import { PaginateSearchResult } from '@yao/types';
import { convertKeysToSnakeCase } from './utils';

export function saveDataById(modelId: ModelId, id: string, payload: object) {
  return Process(`models.${modelId}.update`, id, payload);
}

/**
 * 分页查询模型数据
 *
 * @param modelId - 模型ID
 * @param queryIn - 查询对象 get请求
 * @param payload - 查询对象 post请求
 * @param queryParamsIn  - 数据查询条件
 * @returns 分页查询结果
 */
export function dataPaginate(
  modelId: ModelId,
  queryIn: QueryObjectIn,
  payload: object,
  queryParamsIn?: YaoQueryParam.QueryParam
) {
  let querys = convertKeysToSnakeCase(queryIn);
  querys = mergeQueryObject(querys, payload);

  const page = parseInt(getArrayItem(querys, 'page'), 1);
  const perPage = parseInt(getArrayItem(querys, 'limit', 10));

  const queryParams =
    queryParamsIn != null ? { ...queryParamsIn } : { limit: 10000 };

  const queryParam = queryToQueryParam(modelId, querys, queryParams);

  const paginateData = searchModelData(modelId, queryParam, page, perPage);
  paginateData.data = updateOutputData(modelId, paginateData.data);
  return paginateToSearchResult(paginateData);
}

// 推荐在循环对象属性的时候，使用for...in,
// 在遍历数组的时候的时候使用for...of。
// for...in循环出的是key，for...of循环出的是value
// 注意，for...of是ES6新引入的特性。修复了ES5引入的for...in的不足
// for...of不能循环普通的对象，需要通过和Object.keys()搭配使用

/**
 * 合并查询对象
 *
 * @param querysIn - 输入的查询对象
 * @param payload - 要合并的负载对象
 * @returns 合并后的查询对象
 */
export function mergeQueryObject(querysIn: QueryObjectIn, payload: object) {
  if (payload == null) {
    return querysIn;
  }
  if (querysIn == null) {
    querysIn = {};
  }
  if (typeof querysIn !== 'object') {
    return querysIn;
  }
  const querys = querysIn;

  if (typeof payload === 'object' && Object.keys(payload).length) {
    for (const key in payload) {
      if (Object.hasOwnProperty.call(payload, key)) {
        const element = payload[key];
        const values = querys[key];
        if (Array.isArray(values)) {
          if (!values.some((x) => x == element)) {
            // 使用弱比较，'1'应该等于1
            querys[key].push(element);
          }
        } else {
          querys[key] = [element];
        }
      }
    }
  }

  return querys;
}

/**
 * 从对象中获取指定键的第一个数组项，如果键不存在或对应的值不是数组，则返回默认值
 * @param querys - 要搜索的对象
 * @param key - 要搜索的键
 * @returns 找到的第一个数组项或默认值
 */
export function getArrayItem(
  querys: { [x: string]: string[] },
  key: string,
  defaultValue?: any
) {
  if (typeof querys !== 'object') {
    return defaultValue;
  }
  if (Array.isArray(querys[key]) && querys[key].length) {
    return querys[key][0];
  } else if (Object.hasOwnProperty.call(querys, key)) {
    return querys[key];
  }
  return defaultValue;
}

/**
 * 转换URL查询对象成YAO的QueryParam对象
 * @param {object} modelIn 模型定义
 * @param {object} querysIn URL查询对象
 * @param {object} queryParamsIn Yao查询参数对象
 * @returns 返回Yao QueryParam
 */
export function queryToQueryParam(
  modelIn: ModelId | YaoModel.ModelDSL,
  querysIn: QueryObjectIn,
  queryParamsIn?: YaoQueryParam.QueryParam
) {
  if (querysIn == null && queryParamsIn == null) {
    return {};
  }
  const querys = querysIn || {};
  // 查询条件
  const queryParam = queryParamsIn || {};
  const orders = [];
  const wheres = [];
  // 根据url参数信息，构造yao的查询条件
  let whereCount = 1;

  const columnMap = {};
  let model = modelIn as YaoModel.ModelDSL;

  if (typeof model === 'string') {
    model = FindCachedModelById(model);
  }

  model = addModelMetaFields(model);

  model.columns?.forEach((col) => {
    columnMap[col.name] = col;
  });

  let select = [];
  if (
    querys != null &&
    Object.prototype.hasOwnProperty.call(querys, 'select')
  ) {
    let selectArray = querys.select;
    if (selectArray && typeof selectArray === 'string') {
      selectArray = (selectArray + '').split(',');
    }

    select = [...new Set(selectArray)];
    delete querys['select'];
    select = select.filter((col) =>
      Object.prototype.hasOwnProperty.call(columnMap, col)
    );
  }

  const keywords = querys['keyword'];
  // 只要有keyword的关键字就触发模糊搜索。
  const hasKeyword = keywords != null && keywords.length ? true : false;

  delete querys['keyword'];

  delete querys['page'];
  delete querys['limit'];

  const orderby = querys['sort'];
  const orderDir = querys['order'];
  delete querys['sort'];
  delete querys['order'];
  let option = 'asc';
  if (orderDir && orderDir.length && orderDir[0] != '') {
    option = orderDir[0];
  }
  // only one object
  if (orderby && orderby.length && orderby[0] != '') {
    orders.push({
      column: orderby[0],
      option: option
    });
  }
  // 关键字与其它条件的交叉查询可以根据实际情况来做调整。可以作交叉查询，也可以作联合查询。
  // 一般来说，使用了关键字模糊查询，其它的条件就不做查询。
  if (!hasKeyword) {
    //delete undefined in querys
    for (const key in querys) {
      if (querys[key] === undefined) {
        delete querys[key];
      }
    }
    for (const key in querys) {
      // 不存在列
      if (!Object.prototype.hasOwnProperty.call(columnMap, key)) {
        continue;
      }
      const column = columnMap[key];
      if (column == null) {
        continue;
      }
      const isDateTime = isDateTimeType(column);

      const conditions = querys[key]; // 查询都是一个数组

      for (const condition of conditions) {
        if (condition === '' || condition === undefined) {
          // 前端无法清空搜索值
          continue;
        }
        // 时间范围查询
        if (isDateTime && condition.includes(',')) {
          const conds = condition.split(',');
          if (conds.length === 2) {
            const low = conds[0];
            const high = conds[1];
            wheres.push({
              column: key,
              value: low,
              method: 'where',
              op: 'ge' // >=
            });
            wheres.push({
              column: key,
              value: high,
              method: 'where',
              op: 'le' // <=
            });
            whereCount += 2;
            continue;
          }
        }

        let param = {};
        //* xx* 转换成数据库的%%
        if (typeof condition === 'string' && condition.includes('*')) {
          if (condition === '*') {
            continue;
          }
          const newcondt = condition.replaceAll(/\*/g, '%');
          param = {
            column: key,
            value: newcondt,
            op: 'like'
          };
        } else {
          param = {
            column: key,
            value: condition
          };
        }
        // 超过一个条件，使用交叉查询
        if (whereCount > 1) {
          param['method'] = 'where';
        }
        wheres.push(param);
        whereCount += 1;
      }
    }
  }

  // 使用keywords进行模糊
  if (
    hasKeyword &&
    Array.isArray(keywords) &&
    keywords.length &&
    keywords[0] != '' &&
    keywords[0] != '*'
  ) {
    const keyword = keywords[0] + '';
    for (const colname in columnMap) {
      // 排除一些字段，可以限制在那么有索引的字段里。
      if (
        colname == 'deleted_at' ||
        colname == 'updated_at' ||
        colname == 'created_at' ||
        colname == '__restore_data'
      ) {
        continue;
      }

      if (Object.hasOwnProperty.call(columnMap, colname)) {
        const column = columnMap[colname];
        if (column == null) {
          continue;
        }
        // 只针对有索引的字段
        if (!column.index) {
          continue;
        }
        const param = {
          column: column.name,
          value: `%${keyword}%`,
          op: 'like'
        };
        if (keyword.includes('*')) {
          const newcondt = keyword.replaceAll(/\*/g, '%');
          param.value = newcondt;
        }

        if (whereCount > 1) {
          param['method'] = 'orwhere';
        }
        wheres.push(param);
        whereCount += 1;
      }
    }
  }
  if (wheres.length) {
    queryParam['wheres'] = queryParam['wheres'] || [];
    queryParam['wheres'] = queryParam['wheres'].concat(wheres);
  }
  if (orders.length) {
    queryParam['orders'] = queryParam['orders'] || [];
    queryParam['orders'] = queryParam['orders'].concat(orders);
  }
  if (select.length) {
    queryParam['select'] = queryParam['select'] || [];
    queryParam['select'] = queryParam['select'].concat(select);
    queryParam['select'] = [...new Set(queryParam['select'])];
  }

  return queryParam;
}

/**
 * 根据模型ID在缓存中查找模型定义
 * yao run scripts.system.model_lib.FindCachedModelById
 * @param {string} modelId 模型标识
 * @returns YaoModel.ModelDSL | null
 */
export function FindCachedModelById(modelId: ModelId) {
  const exist = Process(`models.${modelId}.exists`);
  if (exist) {
    const model = Process(`models.${modelId}.read`);
    const modelDsl = updateModelMetaFields(model);
    return modelDsl;
  } else {
    throw new Exception(`模型${modelId}不存在`);
  }
}

/**
 * 获取数据库模型列映射
 *
 * 该函数用于获取数据库模型的列映射。它接受一个模型 ID 或 YaoModel.ModelDSL 对象作为参数，并返回一个包含模型列信息的映射对象。
 *
 * @param model - 模型 ID 或 YaoModel.ModelDSL 对象
 * @returns 一个对象，其中键是列名，值是对应的列对象
 * @throws {Exception} 如果模型定义不正确或缺少字段定义，将抛出异常
 */
function getDbModelColumnMap(model: ModelId | YaoModel.ModelDSL) {
  let modelDsl = model as YaoModel.ModelDSL;
  if (typeof model === 'string') {
    modelDsl = FindCachedModelById(model);
  }

  const columnMap = {};
  modelDsl.columns?.forEach((col) => {
    columnMap[col.name] = col;
  });
  if (Object.keys(columnMap).length == 0) {
    throw new Exception('模型定义不正确，缺少字段定义', 500);
  }
  return columnMap;
}

/**
 * 更新模型元数据字段
 *
 * 这个函数用于更新模型的元数据字段，例如列的标签。它接受一个模型的 DSL 对象，并根据模型的选项（如时间戳和软删除）来更新列的标签。
 *
 * @param modelDsl - 要更新的模型的 DSL 对象
 * @returns 更新后的模型 DSL 对象
 * @throws {Exception} 如果模型定义不正确或缺少字段定义，将抛出异常
 */
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
      if (c.name == 'deleted_at' && c.label == '::Delete At') {
        c.label = '删除时间';
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
function addModelMetaFields(modelDsl2: YaoModel.ModelDSL) {
  const modelDsl = modelDsl2;
  if (!modelDsl) {
    return modelDsl;
  }
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
 * 检查列类型是否为日期时间类型
 *
 * 这个函数用于判断给定的列是否属于日期时间类型。它通过检查列的类型属性来确定这一点。
 *
 * @param column - 要检查的列对象
 * @returns 如果列类型是日期时间类型之一，则返回 true，否则返回 false
 */
export function isDateTimeType(column) {
  const columnType = column.type?.toUpperCase();
  switch (columnType) {
    case 'DATE':
    case 'DATETIME':
    case 'DATETIMETZ':
    case 'TIME':
    case 'TIMETZ':
    case 'TIMESTAMP':
    case 'TIMESTAMPTZ':
      return true;
  }
  return false;
}

/**
 * search the model data with page
 *
 * 分页搜索模型数据
 * @param modelId model id
 * @param queryParam
 * @param page
 * @param perPage
 * @returns
 */
export function searchModelData(
  modelId: ModelId,
  queryParam: YaoQueryParam.QueryParam,
  page: number,
  perPage: number
): PaginateSearchResult {
  page = page || 1;
  perPage = perPage || 10;

  return Process(`models.${modelId}.Paginate`, queryParam, page, perPage);
}

/**
 * 将分页搜索结果转换为搜索结果对象
 *
 * @param pageData - 分页搜索结果对象
 * @returns 转换后的搜索结果对象
 * @description 该函数接受一个包含分页搜索结果的对象，并将其转换为一个包含列表、页码、总页数、总数和限制的搜索结果对象
 */
export function paginateToSearchResult(
  pageData: PaginateSearchResult
): SearchResult {
  const result: SearchResult = {
    list: pageData.data,
    page: pageData.page,
    pages: pageData.pagecnt,
    total: pageData.total,
    limit: pageData.pagesize
  };
  return result;
}

/**
 * 更新模型输出数据
 *
 * 这个函数用于更新模型的输出数据。它接受一个模型对象和一个数据对象，并根据模型的列映射来更新数据对象中的列。
 *
 * 注意：非递归检查转换，只处理数据集或是单个行项目
 *
 * @param model - 模型对象，可以是模型 ID 或 YaoModel.ModelDSL 对象
 * @param data - 要更新的数据对象，可以是数组或单个对象
 * @returns 更新后的数据对象
 * @throws {Exception} 如果模型定义不正确或缺少字段定义，将抛出异常
 */
export function updateOutputData(model: ModelId | YaoModel.ModelDSL, Data) {
  if (Data == null) {
    return Data;
  }
  let modelDsl = model;
  if (typeof modelDsl === 'string') {
    // 如果使用yao model定义，无法获取用户定义的类型，比如json类型的数据就可能有多种含义。
    modelDsl = FindCachedModelById(model as string);
  }
  const dbColmap = getDbModelColumnMap(modelDsl);

  if (Array.isArray(Data)) {
    return Data.map((line) => updateOutputDataLine(dbColmap, line));
  }
  return updateOutputDataLine(dbColmap, Data);
}
/**
 * update the data line before output
 * @param {object} dbColMap
 * @param {object} line
 * @returns
 */
function updateOutputDataLine(dbColMap: object, line: object) {
  if (line == null || typeof line !== 'object') {
    return line;
  }
  for (const key in dbColMap) {
    const modelCol = dbColMap[key];
    const colType = modelCol.type.toUpperCase();
    const field = line[key];
    if (field === undefined) {
      continue;
    }
    switch (colType) {
      case 'JSON':
        if (typeof field === 'string' && field.length >= 2) {
          try {
            line[key] = JSON.parse(field);
          } catch (error) {
            log.Error('invalid field data' + error.message);
          }
        }
        break;
      case 'DECIMAL':
        if (field) {
          line[key] = Number(field);
        }
        break;
      case 'BOOLEAN':
        if (field) {
          line[key] = true;
        } else {
          line[key] = false;
        }
    }
  }
  return line;
}
