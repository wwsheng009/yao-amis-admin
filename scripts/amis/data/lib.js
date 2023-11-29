const { FindCachedModelById } = Require("system.model_lib");
const { IsMysql } = Require("amis.lib_tool");

// 推荐在循环对象属性的时候，使用for...in,
// 在遍历数组的时候的时候使用for...of。
// for...in循环出的是key，for...of循环出的是value
// 注意，for...of是ES6新引入的特性。修复了ES5引入的for...in的不足
// for...of不能循环普通的对象，需要通过和Object.keys()搭配使用
function mergeQueryObject(querysIn, payload) {
  // console.log(`types of querysIn${typeof querysIn}`);
  // console.log(`types of payload${typeof payload}`);

  let querys = querysIn;
  if (querysIn == null || payload == null) {
    return querysIn;
  }
  if (typeof querysIn !== "object") {
    return querysIn;
  }
  if (payload != null && typeof payload === "object") {
    for (const key in payload) {
      if (Object.hasOwnProperty.call(payload, key)) {
        const element = payload[key];
        let values = querys[key];
        if (Array.isArray(values)) {
          if (!values.some((x) => x == element)) {
            //使用弱比较，'1'应该等于1
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
 * @param {object} model 模型定义
 * @param {object} querys URL查询对象
 * @param {object} queryParams yao解析的queryParams
 * @returns 返回Yao QueryParam
 */
function queryToQueryParam(modelIn, querysIn, queryParams) {
  let model = modelIn;
  if (querysIn == null && queryParams == null) {
    return {};
  }
  let querys = querysIn;
  //查询条件
  let queryParam = queryParams || {};
  let orders = [];
  let wheres = [];
  //根据url参数信息，构造yao的查询条件
  let whereCount = 1;

  let columnMap = {};
  if (typeof model === "string") {
    model = FindCachedModelById(model);
  }
  model.columns?.forEach((col) => {
    columnMap[col.name] = col;
  });

  let select = [];
  if (querys.hasOwnProperty("select")) {
    const joinedString = querys["select"].join(",");
    const selectArray = joinedString.split(",");
    select = [...new Set(selectArray)];
    delete querys["select"];
    select = select.filter((col) => columnMap.hasOwnProperty(col));
  }

  const keywords = querys["keywords"];
  delete querys["keywords"];

  delete querys["page"];
  delete querys["perPage"];

  const orderby = querys["orderBy"];
  const orderDir = querys["orderDir"];
  delete querys["orderBy"];
  delete querys["orderDir"];
  let option = "asc";
  if (orderDir && orderDir.length && orderDir[0] != "") {
    option = orderDir[0];
  }
  // only one object
  if (orderby && orderby.length && orderby[0] != "") {
    orders.push({
      column: orderby[0],
      option: option,
    });
  }

  for (const key in querys) {
    // 不存在列
    if (!columnMap.hasOwnProperty(key)) {
      continue;
    }
    const conditions = querys[key]; //查询都是一个数组

    for (const condition of conditions) {
      if (condition === "") {
        //前端无法清空搜索值
        continue;
      }
      let param = {};
      //*xx* 转换成数据库的%%
      if (typeof condition === "string" && condition.includes("*")) {
        if (condition === "*") {
          continue;
        }
        let newcondt = condition.replaceAll(/\*/g, "%");
        param = {
          column: key,
          value: newcondt,
          op: "like",
        };
      } else {
        param = {
          column: key,
          value: condition,
        };
      }
      //超过一个条件，使用交叉查询
      if (whereCount > 1) {
        param["method"] = "where";
      }
      wheres.push(param);
      whereCount += 1;
    }
  }

  //使用keywords进行模糊
  if (
    keywords &&
    Array.isArray(keywords) &&
    keywords.length &&
    keywords[0] != "" &&
    keywords[0] != "*" &&
    wheres.length == 0
  ) {
    let keyword = keywords[0] + "";
    for (const colname in columnMap) {
      // const type = column.type.toUpperCase();
      if (
        colname == "deleted_at" ||
        colname == "updated_at" ||
        colname == "created_at" ||
        colname == "__restore_data"
      ) {
        continue;
      }
      if (Object.hasOwnProperty.call(columnMap, colname)) {
        // console.log("colname:", colname);
        const column = columnMap[colname];
        if (column == null) {
          continue;
        }
        let param = {
          column: column.name,
          value: `%${keyword}%`,
          op: "like",
        };
        if (keyword.includes("*")) {
          let newcondt = keyword.replaceAll(/\*/g, "%");
          param.value = newcondt;
        }

        if (whereCount > 1) {
          param["method"] = "orwhere";
        }
        wheres.push(param);
        whereCount += 1;
      }
    }
  }
  if (wheres.length) {
    queryParam["wheres"] = wheres;
  }
  if (orders.length) {
    queryParam["orders"] = orders;
  }
  if (select.length) {
    queryParam["select"] = select;
  }

  return queryParam;
}

function getModelColumnMap(model) {
  let modelDsl = model;
  if (typeof model === "string") {
    modelDsl = FindCachedModelById(model);
  }

  let columnMap = {};
  modelDsl.columns?.forEach((col) => {
    columnMap[col.name] = col;
  });
  if (Object.keys(columnMap).length == 0) {
    throw new Exception("模型定义不正确，缺少字段定义", 500);
  }
  return columnMap;
}
/**
 * amis form控件会自动的把json数据作stringfly处理，需要在保存时反向操作
 * 拦截处理json格式的数据
 * @param {string} model 模型名称
 * @param {any} Data 保存到数据库的数据
 * @returns 处理后的Data
 */
function updateInputData(model, Data) {
  if (typeof Data !== "object" || Data === null || Data === undefined) {
    return Data;
  }
  const columnMap = getModelColumnMap(model);

  // let testData = Data;

  // if (Array.isArray(Data) && Data.length) {
  //   testData = Data[0];
  // }
  // const columns = Object.keys(testData);
  // let jsonKeys = [];
  // for (const key of columns) {
  //   const modelCol = columnMap[key];
  //   if (modelCol) {
  //     const ty = modelCol.type.toLowerCase();
  //     if (ty === "json") {
  //       jsonKeys.push(key);
  //     }
  //   }
  // }
  const hasUserId = columnMap["user_id"] !== null; // columns.some(col=>col.name = 'user_id')
  const user_id = Process("session.get", "user_id");

  function updateLine(line) {
    for (const key in columnMap) {
      const modelCol = columnMap[key];
      const type = modelCol.type.toUpperCase();
      if (!Object.hasOwnProperty.call(line, key)) {
        continue;
      }
      const field = line[key];
      if (field == null) {
        continue;
      }
      switch (type) {
        case "TINYINTEGER":
        case "SMALLINTEGER":
        case "INTEGER":
        case "BIGINTEGE":
        case "UNSIGNEDTINYINTEGER":
        case "UNSIGNEDSMALLINTEGER":
        case "UNSIGNEDINTEGER":
        case "UNSIGNEDBIGINTEGER":
        case "ID":
        case "TINYINCREMENTS":
        case "SMALLINCREMENTS":
        case "INCREMENTS":
        case "BIGINCREMENTS":
          if (typeof field === "string" && field === "") {
            // tree-select控件清空时的值是字符串
            line[key] = 0;
          }
          break;
        case "FLOAT":
        case "DOUBLE":
        case "DEMICAL":
        case "UNSIGNEDFLOAT":
        case "UNSIGNEDDOUBLE":
        case "UNSIGNEDDECIMAL":
          if (typeof field === "string" && field === "") {
            // tree-select控件清空时的值是字符串
            line[key] = 0.0;
          }
          break;
        case "BOOLEAN":
          if (line[key]) {
            line[key] = IsMysql() ? 1 : true;
          } else {
            line[key] = IsMysql() ? 0 : false;
          }
          break
        case "STRING":
        case "TEXT":
        case "LONGTEXT":
          if (typeof field !== "string") {
            line[key] = line[key] + ""
          }
          break
        default:
          break;
      }
      if (type.includes("DATE") || type.includes("TIME")) {
        if (field === "") {
          line[key] = undefined;
        }
      } else if (
        type === "JSON" &&
        field != null &&
        typeof field === "string" &&
        field.length > 0 &&
        !/^\s*\[/.test(field)
      ) {
        try {
          line[key] = JSON.parse(field);
        } catch (error) { }
      }
    }

    // 存在用户ID定义,但是前台没有明显输入
    if (hasUserId && line["user_id"] == null) {
      if (user_id != null) {
        line["user_id"] = user_id;
      }
    }
  }

  if (Array.isArray(Data)) {
    Data.forEach((line) => updateLine(line));
  } else {
    updateLine(Data);
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
function paginateArray(arr, pageIn, pageSizeIn, orderBy, orderDirection) {
  if (!Array.isArray(arr) || arr.length == 0) {
    return arr;
  }
  // console.log(
  //   `====>paginateArray1,page:${pageIn},perage:${pageSizeIn},orderBy${orderBy},orderDir:${orderDirection}`
  // );

  const page = pageIn ? parseInt(pageIn) : 1;
  const pageSize = pageSizeIn ? parseInt(pageSizeIn) : 10;

  // console.log(
  //   `====>paginateArray2,page:${page},perage:${pageSize},orderBy${orderBy},orderDir:${orderDirection}`
  // );

  // Apply sorting based on the orderBy and orderDirection parameters
  if (orderBy && orderDirection) {
    const orderMultiplier = orderDirection === "desc" ? -1 : 1;
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

function getArrayItem(querys, key) {
  if (typeof querys !== "object") {
    return;
  }
  if (Array.isArray(querys[key]) && querys[key].length) {
    return querys[key][0];
  } else {
    return querys[key];
  }
}

/**
 * 搜索数组，并进行分页返回数据
 * @param {Array} data 需要分页搜索数组
 * @param {object} querysIn 查询条件,请求中的query对象，一般是{"key":[value]}
 * @param {object} payload 查询条件,请求中的query对象，一般是{"key":"value"}
 * @param {Array} searchFields 使用keyword搜索时，限制模糊匹配的字段列表。
 * @returns 数组
 */
function PaginateArrayWithQuery(data, querysIn, payload, searchFields) {
  const querys = mergeQueryObject(querysIn, payload);

  const orderBy = getArrayItem(querys, "orderBy");
  const orderDir = getArrayItem(querys, "orderDir");

  let page = getArrayItem(querys, "page") || 1;
  let perPage = getArrayItem(querys, "perPage") || 10;


  // console.log(
  //   `querys:${querys},page:${page},perage:${perPage},orderBy${orderBy},orderDir:${orderDir}`
  // );
  let list = FilterArrayWithQuery(data, querys, searchFields);
  let count = list.length;

  // console.log(
  //   `====>dataLen:${count},querys:${querys},page:${page},perage:${perPage},orderBy${orderBy},orderDir:${orderDir}`
  // );
  let items = paginateArray(list, page, perPage, orderBy, orderDir);
  return {
    items: items,
    total: count,
  };
}
function FilterArrayWithQuery(list, querysIn, searchFields) {
  if (!Array.isArray(list) || list.length == 0) {
    return list;
  }
  let querys = querysIn || {};

  let first = list[0];

  if (!typeof first === "object") {
    return list;
  }

  delete querys["page"];
  delete querys["perPage"];
  delete querys["orderDir"];
  delete querys["orderBy"];



  let keyword = getArrayItem(querys, "keywords");

  const keywordQuery = {}
  if (querys["keywords"] != null && !first["keywords"]) {
    // 只有keywords
    searchFields = searchFields || [];
    if (!Array.isArray(searchFields)) {
      searchFields = [];
    }
    for (const key in first) {
      if (Object.hasOwnProperty.call(first, key)) {
        if (keyword.includes("*")) {
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
    delete querys["keywords"];
  }

  for (const key in querys) {
    if (!Object.hasOwnProperty.call(first, key)) {
      delete querys[key];
      continue
    }
    // 前端无法重置空值
    if (querys[key] + "" == "") {
      delete querys[key];
      continue
    }
  }

  function filterArray(queryObject, AndMode) {
    const arr = list.filter((item) => {
      for (let key in queryObject) {
        let value = queryObject[key] + "";
        if (Array.isArray(queryObject[key]) && queryObject[key].length) {
          value = queryObject[key][0] + "";
        }
        if (value === undefined) continue;
        if (value.includes("*")) {
          const pattern = new RegExp(`^${value.replace(/\*/g, ".*")}`, "i");
          if (AndMode) {
            if (!pattern.test(item[key])) return false;
          } else {
            if (pattern.test(item[key])) return true;
          }
        } else {
          if (AndMode) {
            if (item[key] + "" != value) return false;
          } else {
            if (item[key] + "" == value) return true;
          }
        }
      }
      if (AndMode) {
        return true;
      } else {
        return false;
      }
    });
    return arr
  }
  // console.log("querys", querys)
  if (Object.keys(querys).length > 0) {
    list = filterArray(querys, true)
  }
  // console.log("keywordQuery", keywordQuery)
  if (Object.keys(keywordQuery).length > 0) {
    list = filterArray(keywordQuery, false)
  }
  return list;
}

// const {mergeQueryObject} = Require("amis.data.lib")
module.exports = {
  mergeQueryObject,
  updateInputData,
  queryToQueryParam,
  paginateArray,
  PaginateArrayWithQuery,
  getArrayItem,
};
