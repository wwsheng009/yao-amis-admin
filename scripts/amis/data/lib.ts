/**
 * @file 数据处理工具库
 * @description 提供了一系列用于处理数据转换、查询参数处理、数组分页等功能的工具函数
 *
 * 主要功能：
 * 1. 查询参数处理：将URL查询参数转换为YAO查询参数
 * 2. 数据转换：处理输入输出数据的格式转换
 * 3. 数组操作：提供数组分页、过滤等功能
 *
 * 主要导出函数：
 * - mergeQueryObject: 合并查询对象
 * - queryToQueryParam: 将URL查询对象转换为YAO查询参数
 * - updateOutputData: 更新输出数据格式
 * - updateInputData: 更新输入数据格式
 * - PaginateArrayWithQuery: 数组分页查询
 * - getArrayItem: 获取数组项
 */

import { FindAndLoadYaoModelById } from '@scripts/system/model_lib';
import { IsMysql } from '@scripts/system/lib';
import { isDateTimeType } from '@scripts/amis/column_convert';

import { Process, Exception, log } from '@yao/yao';
import { YaoModel, YaoQueryParam } from '@yaoapps/types';
import { ModelId } from '@yao/types';
import { QueryObjectIn } from '@yao/request';
import { getModelDslById, getYaoModelColumnMap } from '@scripts/system/model';

import { addModelMetaFields } from '@scripts/system/model_convert';

// 推荐在循环对象属性的时候，使用for...in,
// 在遍历数组的时候的时候使用for...of。
// for...in循环出的是key，for...of循环出的是value
// 注意，for...of是ES6新引入的特性。修复了ES5引入的for...in的不足
// for...of不能循环普通的对象，需要通过和Object.keys()搭配使用

/**
 * 合并查询对象
 * @param {QueryObjectIn} querysIn - 原始查询对象,通常来自URL查询参数,格式为 {"key": [value]}
 * @param {object} payload - 需要合并的对象,格式为 {"key": value}
 * @returns {QueryObjectIn} 合并后的查询对象
 *
 * @description
 * 该函数用于合并两个查询对象:
 * 1. querysIn: URL查询参数对象,其中值通常是数组
 * 2. payload: 普通对象,值为单个值
 *
 * 合并规则:
 * - 如果querysIn中对应key的值是数组,则将payload中的值添加到数组中(去重)
 * - 如果querysIn中不存在该key,则创建新数组包含payload中的值
 * - 使用弱比较(==)进行值的比较,如'1'等于1
 *
 * @example
 * // 基础合并
 * mergeQueryObject({"type": ["1"]}, {"type": "2"})
 * // 返回: {"type": ["1", "2"]}
 *
 * // 去重合并
 * mergeQueryObject({"type": ["1"]}, {"type": "1"})
 * // 返回: {"type": ["1"]}
 *
 * // 新建字段
 * mergeQueryObject({"type": ["1"]}, {"status": "active"})
 * // 返回: {"type": ["1"], "status": ["active"]}
 */
export function mergeQueryObject(querysIn: QueryObjectIn, payload: object) {
  // console.log(`types of querysIn${typeof querysIn}`);
  // console.log(`types of payload${typeof payload}`);

  const querys = querysIn;
  if (querysIn == null || payload == null) {
    return querysIn;
  }
  if (typeof querysIn !== 'object') {
    return querysIn;
  }
  if (payload != null && typeof payload === 'object') {
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
 * 转换URL查询对象成YAO的QueryParam对象
 * @param {object} modelIn 模型定义
 * @param {object} querysIn URL查询对象
 * @param {object} queryParamsIn yao解析的queryParams
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
    model = FindAndLoadYaoModelById(model);
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

  const keywords = querys['keywords'];
  // 只要有keyword的关键字就触发模糊搜索。
  const hasKeyword = keywords != null && keywords.length ? true : false;

  delete querys['keywords'];

  delete querys['page'];
  delete querys['perPage'];

  const orderby = querys['orderBy'];
  const orderDir = querys['orderDir'];
  delete querys['orderBy'];
  delete querys['orderDir'];
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
      // const type = column.type.toUpperCase();
      if (
        colname == 'deleted_at' ||
        colname == 'updated_at' ||
        colname == 'created_at' ||
        colname == '__restore_data'
      ) {
        continue;
      }
      if (Object.hasOwnProperty.call(columnMap, colname)) {
        // console.log("colname:", colname);
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
 * 获取数据库模型的字段映射
 * @param {ModelId | YaoModel.ModelDSL} model 模型ID或模型定义
 * @returns {object} 字段映射对象,key为字段名,value为字段定义
 * @throws {Exception} 当模型定义不正确时抛出异常
 *
 * @example
 * // 使用模型ID
 * const columnMap = getDbModelColumnMap('user');
 *
 * // 使用模型定义
 * const modelDsl = {
 *   columns: [
 *     { name: 'id', type: 'ID' },
 *     { name: 'name', type: 'string' }
 *   ]
 * };
 * const columnMap = getDbModelColumnMap(modelDsl);
 */

function getDbModelColumnMap(model: ModelId | YaoModel.ModelDSL) {
  let modelDsl = model as YaoModel.ModelDSL;
  if (typeof model === 'string') {
    modelDsl = getModelDslById(model);
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

export function updateOutputData(model: ModelId | YaoModel.ModelDSL, Data) {
  if (Data == null) {
    return Data;
  }
  let modelDsl = model;
  if (typeof modelDsl === 'string') {
    // 如果使用yao model定义，无法获取用户定义的类型，比如json类型的数据就可能有多种含义。
    modelDsl = getModelDslById(model as string);
  }
  const dbColmap = getDbModelColumnMap(modelDsl);

  if (Array.isArray(Data)) {
    return Data.map((line) => updateOutputDataLine(dbColmap, line));
  }
  return updateOutputDataLine(dbColmap, Data);
}
/**
 * 更新输出数据行
 * @param {object} dbColMap 数据库字段映射
 * @param {object} line 数据行
 * @returns {object} 更新后的数据行
 *
 * @description
 * 该函数用于处理单行数据的输出格式转换。主要处理以下几种类型:
 * 1. IMAGES - 将JSON字符串转换为数组
 * 2. DECIMAL - 将字符串转换为数字
 * 3. BOOLEAN - 转换为布尔值
 *
 * 对于每个字段:
 * - 如果字段值未定义则跳过
 * - 根据字段类型进行相应转换
 * - 保持其他类型字段不变
 *
 * @example
 * const dbColMap = {
 *   images: { type: 'IMAGES' },
 *   price: { type: 'DECIMAL' },
 *   active: { type: 'BOOLEAN' }
 * };
 *
 * const line = {
 *   images: '["/img1.jpg","/img2.jpg"]',
 *   price: "99.99",
 *   active: 1
 * };
 *
 * updateOutputDataLine(dbColMap, line);
 * // 返回:
 * // {
 * //   images: ["/img1.jpg","/img2.jpg"],
 * //   price: 99.99,
 * //   active: true
 * // }
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
      // 如果数据库中使用的是json的字符串，作一次转换
      // 在amis编辑保存后会自动的转换成","拼接的字符串
      case 'IMAGES':
        if (
          typeof field === 'string' &&
          field.length >= 2 &&
          field[0] === '[' &&
          field[field.length - 1] === ']'
        ) {
          try {
            const array = JSON.parse(field);
            if (Array.isArray(array)) {
              if (array.length > 0) {
                line[key] = array;
              } else {
                line[key] = null;
              }
            }
          } catch (error) {
            log.Error('invalid field data' + error.message);
            // Handle error if required
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

/**
 * amis form控件会自动的把json数据作stringfly处理，需要在保存时反向操作
 * 拦截处理json格式的数据
 * @param {string} model 模型名称
 * @param {object | object[]} Data 保存到数据库的数据
 * @returns 处理后的Data
 */
export function updateInputData(
  model: ModelId | YaoModel.ModelDSL,
  Data: object | object[]
): object | object[] {
  if (typeof Data !== 'object' || Data === null || Data === undefined) {
    return Data;
  }
  const yaoColMap = getYaoModelColumnMap(model);

  const hasUserId = yaoColMap['user_id'] !== null; // columns.some(col=>col.name = 'user_id')
  const user_id = Process('session.get', 'user_id');

  function updateLine(line: { [x: string]: any }) {
    if (typeof line !== 'object') {
      return line;
    }
    for (const key in yaoColMap) {
      const modelCol = yaoColMap[key];
      const colType = modelCol.type.toUpperCase();
      const field = line[key];
      if (colType == 'UUID' && modelCol.primary == true && !field) {
        // 自动生成uuid
        line[key] = Process('utils.str.UUID');
        continue;
      }
      if (!Object.hasOwnProperty.call(line, key)) {
        continue;
      }

      if (field == null) {
        continue;
      }
      switch (colType) {
        case 'TINYINTEGER':
        case 'SMALLINTEGER':
        case 'INTEGER':
        case 'BITINT':
        case 'BIGINTEGER':
        case 'UNSIGNEDTINYINTEGER':
        case 'UNSIGNEDSMALLINTEGER':
        case 'UNSIGNEDINTEGER':
        case 'UNSIGNEDBIGINTEGER':
        case 'ID':
        case 'TINYINCREMENTS':
        case 'SMALLINCREMENTS':
        case 'INCREMENTS':
        case 'BIGINCREMENTS':
          if (typeof field === 'string') {
            if (field === '') {
              // tree-select控件清空时的值是字符串
              line[key] = 0;
            } else {
              line[key] = Number(line[key]);
            }
          }
          break;
        case 'FLOAT':
        case 'DOUBLE':
        case 'DECIMAL':
        case 'UNSIGNEDFLOAT':
        case 'UNSIGNEDDOUBLE':
        case 'UNSIGNEDDECIMAL':
          if (typeof field === 'string') {
            if (field === '') {
              // tree-select控件清空时的值是字符串
              line[key] = 0.0;
            } else {
              line[key] = Number(line[key]);
            }
          }
          break;
        case 'BOOLEAN':
          if (line[key]) {
            line[key] = IsMysql() ? 1 : true;
          } else {
            line[key] = IsMysql() ? 0 : false;
          }
          break;
        case 'STRING':
        case 'TEXT':
        case 'LONGTEXT':
          if (typeof field !== 'string') {
            line[key] = line[key] + '';
          }
          break;
        case 'ENUM':
          if (modelCol.nullable && !modelCol.option?.includes(field)) {
            line[key] = undefined;
          }
          break;
        default:
          break;
      }
      if (colType.includes('DATE') || colType.includes('TIME')) {
        if (field === '') {
          line[key] = undefined;
        }
      } else if (
        colType === 'JSON' &&
        field != null &&
        typeof field === 'string' &&
        field.length > 0
      ) {
        try {
          line[key] = JSON.parse(field);
        } catch (e) {
          throw new Exception(`Invalid json data for field ${key}`);
        }
      }
      return line;
    }

    // 存在用户ID定义,但是前台没有明显输入
    if (hasUserId && line['user_id'] == null) {
      if (user_id != null) {
        line['user_id'] = user_id;
      }
    }
  }

  if (Array.isArray(Data)) {
    Data.forEach((line) => updateLine(line));
  } else {
    Data = updateLine(Data);
  }

  return Data;
}

/**
 * 对数组进行分页处理
 * @param {Array} arr Array of object
 * @param {number} page page
 * @param {number} pageSize page size
 * @param {string} orderBy orderby field
 * @param {string} orderDirection asc / desc
 * @returns Array
 */
function paginateArray(
  arr: object[],
  pageIn: number,
  pageSizeIn: number,
  orderBy: string,
  orderDirection: string
) {
  if (!Array.isArray(arr) || arr.length == 0) {
    return arr;
  }
  // console.log(
  //   `====>paginateArray1,page:${pageIn},perage:${pageSizeIn},orderBy${orderBy},orderDir:${orderDirection}`
  // );

  const page = pageIn ? pageIn : 1;
  const pageSize = pageSizeIn ? pageSizeIn : 10;

  // console.log(
  //   `====>paginateArray2,page:${page},perage:${pageSize},orderBy${orderBy},orderDir:${orderDirection}`
  // );

  // Apply sorting based on the orderBy and orderDirection parameters
  if (orderBy && orderDirection) {
    const orderMultiplier = orderDirection === 'desc' ? -1 : 1;
    arr.sort((a, b) =>
      a[orderBy] > b[orderBy] ? orderMultiplier : -orderMultiplier
    );
  }

  // Calculate the start and end index of the current page
  const startIndex = (page - 1) * pageSize;
  const endIndex = 0 + startIndex + pageSize;
  // console.log(
  //   `====>paginateArray3,startIndex:${startIndex},endIndex:${endIndex},orderBy${orderBy},orderDir:${orderDirection}`
  // );
  // Return the sliced array of objects for the current page
  return arr.slice(startIndex, endIndex);
}
/**
 * 从对象中获取指定键的第一个数组项，如果键不存在或对应的值不是数组，则返回默认值
 * @param querys - 要搜索的对象
 * @param key - 要搜索的键
 * @param defaultValue - 键不存在或对应的值不是数组时的默认值
 * @returns 找到的第一个数组项或默认值
 */
export function getArrayItem(
  querys: { [x: string]: any },
  key: string,
  defaultValue?: any
): string {
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
 * 搜索数组，并进行分页返回数据
 * @param {Array} data 需要分页搜索数组
 * @param {object} querysIn 查询条件,请求中的query对象，一般是{"key":[value]}
 * @param {object} payload 查询条件,请求中的query对象，一般是{"key":"value"}
 * @param {Array} searchFields 使用keyword搜索时，限制模糊匹配的字段列表。
 * @returns 数组
 */
export function PaginateArrayWithQuery(
  data: Array<object>,
  querysIn: QueryObjectIn,
  payload: object,
  searchFields: Array<string> = []
) {
  const querys = mergeQueryObject(querysIn, payload);

  const orderBy = getArrayItem(querys, 'orderBy');
  const orderDir = getArrayItem(querys, 'orderDir');

  const page = parseInt(getArrayItem(querys, 'page', 1));
  const perPage = parseInt(getArrayItem(querys, 'perPage', 10));

  // console.log(
  //   `querys:${querys},page:${page},perage:${perPage},orderBy${orderBy},orderDir:${orderDir}`
  // );
  const list = FilterArrayWithQuery(data, querys, searchFields);
  const count = list.length;

  // console.log(
  //   `====>dataLen:${count},querys:${querys},page:${page},perage:${perPage},orderBy${orderBy},orderDir:${orderDir}`
  // );
  const items = paginateArray(list, page, perPage, orderBy, orderDir);
  return {
    items: items,
    total: count
  };
}
/**
 * 对数组进行分页
 * @param {Array} list 需要分页的数组
 * @param {number} page 页码,从1开始
 * @param {number} perPage 每页数量
 * @param {string} orderBy 排序字段
 * @param {string} orderDir 排序方向,asc或desc
 * @returns {Array} 分页后的数组
 *
 * @description
 * 该函数用于对数组进行分页处理,支持以下功能:
 * 1. 基础分页 - 根据页码和每页数量截取数组
 * 2. 排序 - 支持按指定字段正序或倒序排序
 *
 * 排序规则:
 * - 如果未指定orderBy,保持原数组顺序
 * - orderDir默认为asc(升序)
 * - 支持对数字、字符串类型字段排序
 *
 * @example
 * const list = [{id:1}, {id:2}, {id:3}, {id:4}, {id:5}];
 *
 * // 基础分页
 * paginateArray(list, 1, 2);
 * // 返回: [{id:1}, {id:2}]
 *
 * // 带排序的分页
 * paginateArray(list, 1, 2, 'id', 'desc');
 * // 返回: [{id:5}, {id:4}]
 */

function FilterArrayWithQuery(
  list: object[],
  querysIn: QueryObjectIn,
  searchFields: Array<string> = []
) {
  if (!Array.isArray(list) || list.length == 0) {
    return list;
  }
  const querys = querysIn || {};

  const first = list[0];

  if (!(typeof first === 'object')) {
    return list;
  }

  delete querys['page'];
  delete querys['perPage'];
  delete querys['orderDir'];
  delete querys['orderBy'];

  const keyword = getArrayItem(querys, 'keywords');

  const keywordQuery = {};
  if (
    querys['keywords'] != null &&
    querys['keywords'].length && //如果是空值，没必要过滤
    !first['keywords']
  ) {
    // 只有keywords
    searchFields = searchFields || [];
    if (!Array.isArray(searchFields)) {
      searchFields = [];
    }
    for (const key in first) {
      if (Object.hasOwnProperty.call(first, key)) {
        if (keyword.includes('*')) {
          keywordQuery[key] = [keyword];
        } else {
          keywordQuery[key] = [`*${keyword}*`];
        }
      }
      // 排除不需要的字段，限制需要搜索的字段列表
      if (searchFields.length && !searchFields.includes(key)) {
        delete keywordQuery[key];
      }
    }
    delete querys['keywords'];
  }

  for (const key in querys) {
    if (!Object.hasOwnProperty.call(first, key)) {
      delete querys[key];
      continue;
    }
    // 前端无法重置空值
    if (querys[key] + '' == '') {
      delete querys[key];
      continue;
    }
  }

  function filterArray(queryObject: QueryObjectIn, AndMode: boolean) {
    const arr = list.filter((item) => {
      for (const key in queryObject) {
        let value = queryObject[key] + '';
        if (Array.isArray(queryObject[key]) && queryObject[key].length) {
          value = queryObject[key][0] + '';
        }
        if (value === undefined) continue;
        if (value.includes('*')) {
          const pattern = new RegExp(`^${value.replace(/\*/g, '.*')}`, 'i');
          if (AndMode) {
            if (!pattern.test(item[key])) return false;
          } else {
            if (pattern.test(item[key])) return true;
          }
        } else {
          if (AndMode) {
            if (item[key] + '' != value) return false;
          } else {
            if (item[key] + '' == value) return true;
          }
        }
      }
      if (AndMode) {
        return true;
      } else {
        return false;
      }
    });
    return arr;
  }
  if (Object.keys(querys).length > 0) {
    list = filterArray(querys, true);
  }
  // console.log("keywordQuery", keywordQuery)
  if (Object.keys(keywordQuery).length > 0) {
    list = filterArray(keywordQuery, false);
  }
  return list;
}
