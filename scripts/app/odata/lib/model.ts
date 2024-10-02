import { FindCachedModelById } from '@scripts/system/model_lib';
import { app_odata_view } from '@yao/odata';
import { CachedModel } from '@yao/types';
import { Process, Exception, log } from '@yao/yao';
import { YaoModel } from '@yaoapps/types';

export interface OdataModel extends Omit<CachedModel, 'columns'> {
  actions?: { [key: string]: any };
  model_id?: string;
  table_id?: string;
  odata_view_name: string;
  columns: YaoModel.ModelColumn[];
}

export interface OdataModelObj extends Omit<CachedModel, 'columns'> {
  actions?: { [key: string]: any };
  model_id?: string;
  table_id?: string;
  odata_view_name: string;
  columns: OdataModelColumnMap;
}
export type OdataModelColumnMap = { [key: string]: YaoModel.ModelColumn };

export type OdataModelMap = { [key: string]: OdataModelObj };

function getOdataModelList() {
  const viewList = Process('models.app.odata.view.get', {
    wheres: [{ column: 'disabled', value: false }],
    limit: 10000
  }) as app_odata_view[];
  // const modelsList = Process('widget.models');
  // 原始的模型列表
  // const model_list = getCachedModelList();
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
    const m = getOdataModelById(v);
    if (m != null) {
      arry.push(m);
    }
    return arry;
    // // const model = model_list.find((m) => m.ID === v.model_id);
    // const model = FindCachedModelById(v.model_id);
    // if (model) {
    //   const m = { ...model } as OdataModel; // copy object
    //   m.model_id = v.model_id;
    //   if (v.table_id) {
    //     m.table_id = v.table_id;
    //     const model_cols = getTableColumns(v.table_id);
    //     if (model_cols.length) {
    //       const cols = m.columns as YaoModel.ModelColumn[];
    //       m.columns = cols.filter((column) => {
    //         return model_cols.includes(column.name);
    //       });
    //     }
    //   }
    //   m.odata_view_name = v.name;
    //   arry.push(m);
    //   return arry;
    // }
  }, [] as OdataModel[]);

  return viewModelList;
}

// yao run scripts.app.odata.lib.model.getOdataModelsWithColMap
export function getOdataModelsWithColMap() {
  const list = getOdataModelList();
  // Process("models.system.api.eachsave", list);
  const modelObj = {} as OdataModelMap;
  list.forEach((model) => {
    const m = { ...model } as unknown as OdataModelObj;
    delete model.values;
    const colObj = {} as OdataModelColumnMap;
    //convert the list to the map object
    model.columns.forEach((col) => {
      colObj[col.name] = col;
    });
    m.columns = colObj;
    modelObj[model.odata_view_name] = m;
  });
  return modelObj;
}

export function getModelsEntityset() {
  const list = getOdataModelList();
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

export function getOdataModelNameList() {
  const list = getOdataModelList();
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
  const list = Process('models.app.odata.view.get', {
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

export function getOdataModelsEntityset2() {
  const list = getOdataModelList();
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
 * get the column ids from table setting
 * yao run scripts.app.odata.lib.model.getTableColumns 'admin.user'
 * @param {string} table_id
 * @returns array of model column_id
 */
function getTableColumns(table_id: string): string[] {
  if (!table_id) {
    return [];
  }
  if (!Process('yao.table.exists', table_id)) {
    log.Error(`Odata.View设置视图${table_id}不存在`);
    return [];
  }
  const setting = Process('yao.table.setting', table_id);
  // output columns
  const cols = setting?.table?.columns?.reduce((arr, col) => {
    arr.push(col.name);
    return arr;
  }, []);

  // model column id
  const col_ids = cols?.reduce((arry: string[], col: string) => {
    arry.push(setting.fields?.table[col]?.bind);
    return arry;
  }, []);
  return col_ids || [];
}
/**
 * 根据视图名称获取模型定义
 * @param {string} viewId
 * @returns
 */
export function getOdataModel(viewId: string): OdataModel {
  if (!viewId) {
    return { odata_view_name: viewId, columns: [] };
  }
  const [odataview] = Process('models.app.odata.view.get', {
    wheres: [
      {
        column: 'name',
        value: viewId
      }
    ],
    limit: 1
  });
  if (!odataview) {
    throw new Exception(`视图：${viewId}不存在！`);
  }
  if (odataview.disabled) {
    throw new Exception(`视图：${viewId}已被禁用！`);
  }

  const m = getOdataModelById(odataview);
  if (!m) {
    throw new Exception(`模型：${odataview.model_id}不存在`);
  }

  // const model_id = odataview.model_id;

  // const model_cols = getTableColumns(odataview.table_id);

  // // 如果数据库里没有，从内存中加载定义
  // // 只有加载到内存的才能获取的了
  // // const models = Process('widget.models');
  // // const model = findOdataModelById(models, model_id);
  // const model = FindCachedModelById(model_id) as OdataModel;
  // if (model) {
  //   model.model_id = model_id;
  //   if (model_cols.length) {
  //     model.table_id = odataview.table_id;
  //     model.columns = model.columns.filter((column) => {
  //       return model_cols.includes(column.name);
  //     });
  //   } else {
  //     // 过滤隐藏的字段
  //     model.columns = model.columns.filter((column) => {
  //       if (model.option != null) {
  //         if (model.option?.timestamps) {
  //           if (column.name == 'updated_at' || column.name == 'created_at') {
  //             return false;
  //           }
  //         }
  //         if (model.option?.soft_deletes) {
  //           if (column.name == 'deleted_at') {
  //             return false;
  //           }
  //         }
  //       }
  //       return true;
  //     });
  //   }

  //   model.name = model.ID;
  // } else {
  //   throw new Exception(`模型：${model_id}不存在`);
  // }
  return m;
}

function getOdataModelById(odataview: app_odata_view) {
  const model = FindCachedModelById(odataview.model_id);
  if (model) {
    const m = { ...model } as OdataModel; // copy object
    m.model_id = odataview.model_id;
    m.odata_view_name = odataview.name;
    if (odataview.table_id) {
      m.table_id = odataview.table_id;
      const model_cols = getTableColumns(odataview.table_id);
      if (model_cols.length) {
        const cols = m.columns as YaoModel.ModelColumn[];
        m.columns = cols.filter((column) => {
          return model_cols.includes(column.name);
        });
      } else {
        // 过滤隐藏的字段
        m.columns = model.columns.filter((column) => {
          if (model.option != null) {
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
    }
    return m;
  }
}

// module.exports = {
//   getOdataModelsWithColMap,
//   getModelsEntityset,
//   getModel,
//   getOdataModelNameList,
//   getOdataViewList
// };
