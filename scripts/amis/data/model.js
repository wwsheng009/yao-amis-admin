//使用models*类型的处理，这类处理器是直接对表数据的操作，相对tables*处理器，性能会更好
const { DotName } = Require("amis.lib_tool");
const { FindCachedModelById } = Require("system.model_lib");
const { queryToQueryParam, updateInputData, getArrayItem, mergeQueryObject } =
  Require("amis.data.lib");

/**
 * 查找数据
 * yao run scripts.amis.data.model.Search
 * Model Data Search
 * @param {string} model model id
 * @param {number} pageIn page
 * @param {number} perPageIn numbers per page
 * @param {object} querysIn querys
 * @param {object} queryParams queryparams
 * @param {object} payload request payload
 * @returns
 */
function Search(model, pageIn, perPageIn, querysIn, queryParams, payload) {
  let querys = mergeQueryObject(querysIn, payload);

  let page = pageIn;
  let perPage = perPageIn;
  if (!page || page == null) {
    page = getArrayItem(querys, "page") || 1;
  }
  if (!perPage || perPage == null) {
    perPage = getArrayItem(querys, "perPage") || 10;
  }

  const modelDsl = FindCachedModelById(model);

  // 当是post请求是，payload生效
  const queryParam = queryToQueryParam(modelDsl, querys, queryParams);
  // console.log("queryParam>>>", queryParam, page, perPage);

  let withs2 = {};
  if (!modelDsl.relations || Object.keys(modelDsl.relations) == 0) {
    // reset the withs
    queryParam.withs = undefined;
  } else {
    const withs = queryParam.withs || {};
    for (const key in withs) {
      if (Object.hasOwnProperty.call(modelDsl.relations, key)) {
        const w = modelDsl.relations[key];
        // if (w != null && w.type === "hasMany") {
        withs2[key] = w;
        // }
      }
    }
    // hasOne关系，如果数据不存在，yao会返回null对象,直接在脚本中处理
    // 同时存在两个hasmany会有异常,使用下面的处理方法
    // if (Object.keys(withs2).length > 1) {
    //   Object.keys(withs2).forEach((w) => (queryParam.withs[w] = undefined));
    // }
    queryParam.withs = undefined;
  }

  let data = Process(`models.${model}.Paginate`, queryParam, page, perPage);
  if (Array.isArray(data.data) && data.data.length) {
    if (Object.keys(withs2).length > 0) {
      data.data.forEach((line) => {
        for (const key in withs2) {
          const element = withs2[key];
          let query = {};
          if (element.query) {
            query = { ...element.query };
          }
          query.wheres = query.wheres || [];
          query.wheres.push({
            column: element.key,
            value: line[element.foreign],
          });
          if (element.type === "hasMany") {
            line[key] = Process(`models.${element.model}.Get`, query);
          } else if (element.type === "hasOne") {
            const [ele] = Process(`models.${element.model}.Get`, query);

            if (ele != null) {
              line[key] = ele;
            }
          }
        }
      });
    }
  }

  return {
    items: data.data,
    total: data.total,
  };
}

//表数据预览，可以用于amis curd控件的api接口测试
function PreViewtableData(table) {
  let model_name = DotName(table);
  let data = Process(`models.${model_name}.Get`, { limit: 10 });
  return data;
  // return Process("scripts.return.Success", data);
}
//根据id获取记录
function getData(model, id) {
  let data = Process(`models.${DotName(model)}.Find`, id, {});
  return data;
}

//保存记录
//yao run scripts.amis.data.model.saveData
function saveData(modelId, payload) {
  const modelDsl = FindCachedModelById(modelId);

  payload = updateInputData(modelDsl, payload);

  const hasOnes = {};
  const hasManys = {};
  if (modelDsl.relations) {
    for (const key in modelDsl.relations) {
      if (Object.hasOwnProperty.call(payload, key) && payload[key] != null) {
        const element = modelDsl.relations[key];
        if (element.type === "hasOne") {
          hasOnes[key] = element;
        } else if (element.type === "hasMany") {
          hasManys[key] = element;
        }
      }
    }
  }

  const id = Process(`models.${modelId}.Save`, payload);
  if (id) {
    payload.id = id;
    for (const key in hasOnes) {
      const element = hasOnes[key];
      // 设置外键
      payload[key][element.key] = payload[element.foreign];
      console.log("payload[key]:", payload[key]);
      Process(`models.${element.model}.Save`, payload[key]);
    }

    return { id: id, message: `记录${id}保存成功` };
  } else {
    return { message: `记录保存失败` };
  }
}

//保存记录
//yao run scripts.amis.data.model.saveDataById
function saveDataById(model, id, payload) {
  payload.id = id;
  return saveData(model, payload);
}
//创建新记录
function newData(model, payload) {
  return saveData(model, payload);
}

//批量创建新记录
function newBatchData(model, payload) {
  payload.batch = updateInputData(model, payload.batch);
  Process(`models.${model}.eachSave`, payload.batch);
}

//删除记录，支持单条或是批量
function deleteData(model, ids) {
  let myArray = ids.split(",");
  myArray &&
    myArray.forEach((id) => {
      // Process("yao.model.Delete", model, id);
      Process(`models.${model}.Delete`, id);
    });
}
//批量更新数据
function bulkUpdate(model, ids, payload) {
  let myArray = ids.split(",");
  myArray &&
    myArray.forEach((id) => {
      // Process("yao.model.Update", model, id, payload);
      payload = updateInputData(model, payload);
      Process(`models.${model}.Update`, id, payload);
    });
}

//scripts.amis.data.model.dummy
function dummy() {
  return { message: "请传入ID" };
}

/**
 * 可以直接读取表，也可以读取在模型model.selectOptions中定义的条件，如果没有表中没有定义，使用模型读取。
 * yao run scripts.amis.data.model.selectOptions ddic.model
 * yao run scripts.amis.data.model.selectOptions model_list
 * @param {string} model model id
 * @param {object} querys querys
 */
function selectOptions(model, querysIn, payload) {
  if (!model) {
    throw new Exception("需要指定模型");
  }
  let querys = mergeQueryObject(querysIn, payload);
  const [row] = Process("models.ddic.selectoption.get", {
    wheres: [{ column: "name", value: model }],
    limit: 1,
  });

  let query = { model: model };
  let wheres = undefined;
  let join = false;
  if (row != null) {
    query.model = row.model;
    query.value = row.value_field;
    query.label = row.label_field;
    if (row.wheres) {
      query.wheres = JSON.parse(row.wheres);
    }
    join = row.join;
  }

  if (querys["__value"]) {
    query.value = querys["__value"][0];
  }
  if (querys["__label"]) {
    query.label = querys["__label"][0];
  }

  const queryParam = queryToQueryParam(query.model, querys);
  wheres = queryParam?.wheres;
  if (wheres != null) {
    query.wheres = wheres;
  }
  // 传入原始搜索
  if (querys["__wheres"]) {
    query.wheres = querys["__wheres"][0];
  }

  let data = Process("yao.component.SelectOptions", query);
  data.forEach((x) => {
    let isNull = x.label == null;
    x.label = x.label || x.value;
    if (join && !isNull) {
      x.label = `${x.value}[${x.label}]`;
    }
  });

  return data;
}
