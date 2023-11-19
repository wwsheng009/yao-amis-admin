//使用models*类型的处理，这类处理器是直接对表数据的操作，相对tables*处理器，性能会更好
const { DotName } = Require("amis.lib_tool");

const { queryToQueryParam, updateInputData, getArrayItem, mergeQueryObject } =
  Require("amis.data.lib");
//查找数据
//yao run scripts.amis.data.model.Search
function Search(model, pageIn, perPageIn, querysIn, payload) {
  let querys = mergeQueryObject(querysIn, payload);

  let page = pageIn;
  let perPage = perPageIn;
  if (!page || page == null) {
    page = getArrayItem(querys, "page") || 1;
  }
  if (!perPage || perPage == null) {
    perPage = getArrayItem(querys, "perPage") || 10;
  }

  // 当是post请求是，payload生效
  const queryParam = queryToQueryParam(model, querys);
  // console.log("queryParam>>>", queryParam, page, perPage);
  let data = Process(`models.${model}.Paginate`, queryParam, page, perPage);
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
function saveData(model, payload) {
  payload = updateInputData(model, payload);

  const id = Process(`models.${model}.Save`, payload);
  if (id) {
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
