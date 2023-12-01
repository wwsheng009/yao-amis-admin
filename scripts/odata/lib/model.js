//yao run scripts.main.models
function getModels() {
  const modelsList = Process("widget.models");
  const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  let modelObj = {};
  list.forEach((model) => {
    delete model.values;
    let colObj = {};
    model.columns.forEach((col) => {
      colObj[col.name] = col;
    });
    model.columns = colObj;
    modelObj[model.ID] = model;
  });
  return modelObj;
}

function getModelsEntityset() {
  const modelsList = Process("widget.models");
  const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  let modelObj = [];
  list.forEach((model) => {
    modelObj.push({
      kind: "EntitySet",
      name: model.ID,
      url: model.ID,
    });
  });
  return modelObj;
}

function getModelNameList() {
  const modelsList = Process("widget.models");
  const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  let modelObj = [];
  list.forEach((model) => {
    modelObj.push(model.ID);
  });
  return modelObj;
}

function getModelsEntityset2() {
  const modelsList = Process("widget.models");
  const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  let modelObj = [];
  list.forEach((model) => {
    modelObj.push(model.ID);
  });
  return {
    d: {
      EntitySets: modelObj,
    },
  };
}

function modelDefinitionList(modelData) {
  var list = [];

  if (modelData.children) {
    modelData.children.forEach((line) => {
      var subLine = modelDefinitionList(line);
      list = list.concat(subLine);
    });
  } else if (modelData.data) {
    if (modelData.data) {
      list.push(modelData.data);
    }
  } else if (Array.isArray(modelData)) {
    modelData.forEach((line) => {
      var subLine = modelDefinitionList(line);
      list = list.concat(subLine);
    });
  }
  return list;
}

function getModel(modelId) {
  if (!modelId) {
    return { columns: [] };
  }
  // 如果数据库里没有，从内存中加载定义
  // 只有加载到内存的才能获取的了
  const models = Process("widget.models");
  let model = findModelById(models, modelId);
  if (model) {
    //过滤隐藏的字段
    model.columns = model.columns.filter((column) => {
      if (model.option) {
        if (model.option.timestamps) {
          if (column.name == "updated_at" || column.name == "created_at") {
            return false;
          }
        }
        if (model.option.soft_deletes) {
          if (column.name == "deleted_at") {
            return false;
          }
        }
      }
      return true;
    });
    model.name = model.ID;
  }
  return model;
}
function findModelById(models, id) {
  if (typeof models !== "object" || models === null || models === undefined) {
    return null;
  }

  if (models.children) {
    for (const item of models.children) {
      var obj = findModelById(item, id);
      if (obj) {
        return obj;
      }
    }
  } else if (models.data) {
    if (models.data.ID == id) {
      return models.data;
    }
  } else if (Array.isArray(models)) {
    for (const item of models) {
      var obj = findModelById(item, id);
      if (obj) {
        return obj;
      }
    }
  }

  return null;
}
module.exports = {
  getModels,
  getModelsEntityset,
  getModel,
  getModelNameList,
};
