import { Process, Exception } from '@yao/yao';

function getModelList() {
  const viewList = Process('models.odata.view.get', {
    wheres: [{ column: 'disabled', value: false }],
    limit: 10000
  });
  const modelsList = Process('widget.models');
  // 原始的模型列表
  const model_list = modelDefinitionList(modelsList);
  // model_list = model_list.filter((model) => viewList.find((v) => v.model_id == model.ID));

  // // 设置table关联的模型列表
  // const tables_list = viewList.filter((v) => !!v.table_id);

  // // 更新模型信息
  // tables_list.forEach((view) => {
  //   const model = model_list.find((m) => m.ID == view.model_id);
  //   if (model) {
  //     const model_cols = getTableColumns(view.table_id);
  //     model.columns = model.columns.filter((column) => {
  //       return model_cols.includes(column.name);
  //     });
  //   }
  // });

  const viewModelList = viewList.reduce((arry, v) => {
    const model = model_list.find((m) => m.ID === v.model_id);
    if (model) {
      model.model_id = v.model_id;
      const m = { ...model }; // copy object
      if (v.table_id) {
        model.table_id = v.table_id;
        const model_cols = getTableColumns(v.table_id);
        m.columns = m.columns.filter((column) => {
          return model_cols.includes(column.name);
        });
      }
      m.odata_view_name = v.name;
      arry.push(m);
      return arry;
    }
  }, []);

  return viewModelList;
}

// yao run scripts.odata.lib.model.getModels
export function getModels() {
  const list = getModelList();
  // Process("models.system.api.eachsave", list);
  const modelObj = {};
  list.forEach((model) => {
    delete model.values;
    const colObj = {};
    model.columns.forEach((col) => {
      colObj[col.name] = col;
    });
    model.columns = colObj;
    modelObj[model.odata_view_name] = model;
  });
  return modelObj;
}

export function getModelsEntityset() {
  const list = getModelList();
  // Process("models.system.api.eachsave", list);
  const modelObj = [];
  list.forEach((model) => {
    modelObj.push({
      kind: 'EntitySet',
      name: model.odata_view_name,
      url: model.odata_view_name
    });
  });
  return modelObj;
}

export function getModelNameList() {
  const list = getModelList();
  // const modelsList = Process("widget.models");
  // const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  const modelObj = [];
  list.forEach((model) => {
    modelObj.push(model.odata_view_name);
  });
  return modelObj;
}

/**
 * get the odata view list
 *
 * @returns odata view list
 */
export function getOdataViewList() {
  const list = Process('models.odata.view.get', {
    wheres: [
      {
        column: 'disabled',
        value: false
      }
    ],
    limit: 10000
  });
  return list;
}

function getModelsEntityset2() {
  const list = getModelList();
  // const modelsList = Process("widget.models");
  // const list = modelDefinitionList(modelsList);
  // Process("models.system.api.eachsave", list);
  const modelObj = [];
  list.forEach((model) => {
    modelObj.push(model.odata_view_name);
  });
  return {
    d: {
      EntitySets: modelObj
    }
  };
}

/**
 * 转换嵌套的对象结构成扁平的列表结构
 * @param {object} modelData
 * @returns
 */
function modelDefinitionList(modelData) {
  let list = [];

  if (modelData.children) {
    modelData.children.forEach((line) => {
      const subLine = modelDefinitionList(line);
      list = list.concat(subLine);
    });
  } else if (modelData.data) {
    if (modelData.data) {
      list.push(modelData.data);
    }
  } else if (Array.isArray(modelData)) {
    modelData.forEach((line) => {
      const subLine = modelDefinitionList(line);
      list = list.concat(subLine);
    });
  }
  return list;
}
/**
 * get the column ids from table setting
 * yao run scripts.odata.lib.model.getTableColumns 'admin.user'
 * @param {string} table_id
 * @returns array of model column_id
 */
function getTableColumns(table_id) {
  if (!table_id) {
    return [];
  }
  const setting = Process('yao.table.setting', table_id);
  // output columns
  const cols = setting.table.columns.reduce((arr, col) => {
    arr.push(col.name);
    return arr;
  }, []);

  // model column id
  const col_ids = cols.reduce((arry, col) => {
    arry.push(setting.fields.table[col].bind);
    return arry;
  }, []);
  return col_ids;
}
/**
 * 根据视图名称获取模型定义
 * @param {string} viewId
 * @returns
 */
export function getModel(viewId) {
  if (!viewId) {
    return { columns: [] };
  }
  const [odataview] = Process('models.odata.view.get', {
    wheres: [
      {
        column: 'name',
        value: viewId
      }
    ],
    limit: 1
  });
  if (!odataview) {
    throw new Exception(`视图：${viewId}不存在`);
  }
  const model_id = odataview.model_id;

  const model_cols = getTableColumns(odataview.table_id);

  // 如果数据库里没有，从内存中加载定义
  // 只有加载到内存的才能获取的了
  const models = Process('widget.models');
  const model = findModelById(models, model_id);
  if (model) {
    model.model_id = model_id;
    if (model_cols.length) {
      model.table_id = odataview.table_id;
      model.columns = model.columns.filter((column) => {
        return model_cols.includes(column.name);
      });
    } else {
      // 过滤隐藏的字段
      model.columns = model.columns.filter((column) => {
        if (model.optionb != null) {
          if (model.option?.timestamps) {
            if (column.name == 'updated_at' || column.name == 'created_at') {
              return false;
            }
          }
          if (model.option?.soft_deletes) {
            if (column.name == 'deleted_at') {
              return false;
            }
          }
        }
        return true;
      });
    }

    model.name = model.ID;
  } else {
    throw new Exception(`模型：${model_id}不存在`);
  }
  return model;
}
function findModelById(models, id) {
  if (typeof models !== 'object' || models === null || models === undefined) {
    return null;
  }

  if (models.children) {
    for (const item of models.children) {
      const obj = findModelById(item, id);
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
      const obj = findModelById(item, id);
      if (obj) {
        return obj;
      }
    }
  }

  return null;
}
// module.exports = {
//   getModels,
//   getModelsEntityset,
//   getModel,
//   getModelNameList,
//   getOdataViewList
// };
