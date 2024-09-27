// 使用models*类型的处理，这类处理器是直接对表数据的操作，相对tables*处理器，性能会更好
import { ClearFalsyKeys, DotName } from '@scripts/system/lib';
import { FindAndLoadYaoModelById } from '@scripts/system/model_lib';
import {
  queryToQueryParam,
  updateInputData,
  updateOutputData,
  getArrayItem,
  mergeQueryObject
} from '@scripts/amis/data/lib';

import { RunTransaction } from '@scripts/system/db';

import { Process, Exception } from '@yao/yao';
import { ModelId } from '@yao/types';

/**
 * 查找数据
 * yao run scripts.amis.data.model.dataSearch
 * Model Data Search
 * @param {string} modelId model id
 * @param {number} pageIn page
 * @param {number} perPageIn numbers per page
 * @param {object} querysIn querys
 * @param {object} queryParams queryparams
 * @param {object} payload request payload
 * @returns
 */
export function dataSearch(
  modelId: ModelId,
  pageIn: number,
  perPageIn: number,
  querysIn,
  queryParams,
  payload
) {
  const querys = mergeQueryObject(querysIn, payload);

  let page = pageIn;
  let perPage = perPageIn;
  if (!page || page == null) {
    page = getArrayItem(querys, 'page') || 1;
  }
  if (!perPage || perPage == null) {
    perPage = getArrayItem(querys, 'perPage') || 10;
  }

  const modelDsl = FindAndLoadYaoModelById(modelId);

  // 当是post请求是，payload生效
  const queryParam = queryToQueryParam(modelDsl, querys, queryParams) as any;
  const withs2 = {};
  if (!modelDsl.relations || Object.keys(modelDsl.relations).length == 0) {
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
  const data = Process(`models.${modelId}.Paginate`, queryParam, page, perPage);
  if (Array.isArray(data.data) && data.data.length) {
    data.data = updateOutputData(modelId, data.data);

    if (Object.keys(withs2).length > 0) {
      data.data.forEach((line) => {
        for (const key in withs2) {
          const element = withs2[key];
          let query = {} as any;
          if (element.query) {
            query = { ...element.query };
          }
          query.wheres = query.wheres || [];
          query.wheres.push({
            column: element.key,
            value: line[element.foreign]
          });
          if (element.type === 'hasMany') {
            line[key] = Process(`models.${element.model}.Get`, query);
          } else if (element.type === 'hasOne') {
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
    items: ClearFalsyKeys(data.data),
    total: data.total
  };
}
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
function makeFake(modelId) {
  const modelDsl = FindAndLoadYaoModelById(modelId);

  const fakeData = {};
  modelDsl.columns.forEach((column) => {
    const columnType = column.type.toUpperCase();
    const key = column.name;
    switch (columnType) {
      case 'STRING':
      case 'CHAR':
        fakeData[key] = 'dummy fake data';
        break;
      case 'TEXT':
      case 'MEDIUMTEXT':
      case 'LONGTEXT':
        fakeData[key] = 'dummy fake data';
        break;
      case 'JSON':
      case 'JSONB':
        fakeData[key] = {
          dummy: 'dummy'
        };
        break;
      case 'DATE':
        fakeData[key] = '2023-11-24';
        break;
      case 'DATETIME':
        fakeData[key] = '2023-11-24 08:01:00';
        break;
      case 'DATETIMETZ':
        fakeData[key] = '2023-11-24T08:01:00Z';
        break;
      case 'TIME':
        fakeData[key] = '08:01:00';
        break;
      case 'TIMETZ':
        fakeData[key] = '08:01:00Z';
        break;
      case 'TIMESTAMP':
      case 'TIMESTAMPTZ':
        fakeData[key] = Date.now();
        break;
      case 'TINYINTEGER':
      case 'SMALLINTEGER':
      case 'INTEGER':
      case 'BIGINTEGE':
        fakeData[key] = 12331;
        break;
      case 'UNSIGNEDTINYINTEGER':
      case 'UNSIGNEDSMALLINTEGER':
      case 'UNSIGNEDINTEGER':
        fakeData[key] = 12331;
        break;
      case 'UNSIGNEDBIGINTEGER':
        fakeData[key] = 12331;
        break;
      case 'ID':
      case 'TINYINCREMENTS':
      case 'SMALLINCREMENTS':
      case 'INCREMENTS':
        fakeData[key] = 1;
        break;
      case 'BIGINCREMENTS':
        fakeData[key] = 1;
        break;
      case 'FLOAT':
      case 'DOUBLE':
      case 'DEMICAL':
        fakeData[key] = 1.1;
        break;
      case 'UNSIGNEDFLOAT':
      case 'UNSIGNEDDOUBLE':
      case 'UNSIGNEDDECIMAL':
        fakeData[key] = 1.1;
        break;
      case 'BOOLEAN':
        fakeData[key] = true;
        break;
      case 'UUID':
        fakeData[key] = generateUUID();
        break;
      case 'ENUM':
        fakeData[key] = 'enum';
        break;
      case 'FILE':
        fakeData[key] =
          'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png';
        break;
      case 'IMAGE':
        fakeData[key] =
          'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png';
        break;
      case 'IMAGES':
        fakeData[key] =
          'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png,https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png';
        break;
      case 'VIDEO':
        fakeData[key] =
          'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png';
        break;
      case 'RICHTEXT':
        fakeData[key] = '<p></p>';
        break;
      default:
        break;
    }
  });
  return [fakeData];
}
// 表数据预览，可以用于amis curd控件的api接口测试
export function PreViewtableData(modelId: string) {
  const model_name = DotName(modelId);
  const data = Process(`models.${model_name}.Get`, { limit: 10 });
  if (data.length === 0) {
    return makeFake(modelId);
  }
  return data;
}
// 根据id获取记录
export function getData(modelId: string, id: number) {
  const data = Process(`models.${DotName(modelId)}.Find`, id, {});
  return data;
}

// 保存记录
// yao run scripts.amis.data.model.saveData
function saveData(modelId, payload) {
  const modelDsl = FindAndLoadYaoModelById(modelId);

  payload = updateInputData(modelDsl, payload);

  const hasOnes = {};
  const hasManys = {};
  if (modelDsl.relations) {
    for (const key in modelDsl.relations) {
      if (Object.hasOwnProperty.call(payload, key) && payload[key] != null) {
        const element = modelDsl.relations[key];
        if (element.type === 'hasOne') {
          hasOnes[key] = element;
        } else if (element.type === 'hasMany') {
          hasManys[key] = element;
        }
      }
    }
  }

  const saveFun = function () {
    const id = Process(`models.${modelId}.Save`, payload);
    if (id) {
      payload.id = id;
      for (const key in hasOnes) {
        // it maybe not a object
        if (payload[key] !== null && typeof payload[key] === 'object') {
          const w = hasOnes[key];
          // 设置外键
          payload[key][w.key] = payload[w.foreign];
          Process(`models.${w.model}.Save`, payload[key]);
        }
      }
      for (const key in hasManys) {
        const w = hasManys[key];
        const lines = Array.isArray(payload[key])
          ? payload[key]
          : [payload[key]];
        // lines.forEach((line) => {
        //   line[w.key] = payload[w.foreign];
        // });
        // 有删除？
        const exist = Process(`models.${w.model}.Get`, {
          select: ['id'],
          wheres: [{ column: w.key, value: payload[w.foreign] }]
        });
        const idsNew = lines.map((l) => l.id);
        const idsOld = exist.map((l) => l.id);
        const idsDeleted = idsOld.filter((id) => !idsNew.includes(id));
        // console.log(`idsnew`, idsNew);
        // console.log(`idsOld`, idsOld);
        // console.log(`idsDeleted`, idsDeleted);

        const share = {
          [w.key]: payload[w.foreign]
        };
        // console.log(`share`, share);

        Process(
          `models.${w.model}.EachSaveAfterDelete`,
          idsDeleted,
          lines,
          share
        );
      }
      return { id: id, message: `记录${id}保存成功` };
    } else {
      return { message: `记录保存失败` };
    }
  };
  return RunTransaction(saveFun);
}

// 保存记录
// yao run scripts.amis.data.model.saveDataById
export function saveDataById(model, id, payload) {
  payload.id = id;
  return saveData(model, payload);
}
// 创建新记录
export function newData(model, payload) {
  return saveData(model, payload);
}

// 批量创建新记录
export function newBatchData(model, payload) {
  payload.batch = updateInputData(model, payload.batch);
  Process(`models.${model}.eachSave`, payload.batch);
}

// 删除记录，支持单条或是批量
export function deleteData(model, ids) {
  const myArray = ids.split(',');

  myArray.forEach((id) => {
    // Process("yao.model.Delete", model, id);
    Process(`models.${model}.Delete`, id);
  });
}
// 批量更新数据
export function bulkUpdate(model, ids, payload) {
  const myArray = ids.split(',');
  myArray.forEach((id) => {
    // Process("yao.model.Update", model, id, payload);
    payload = updateInputData(model, payload);
    Process(`models.${model}.Update`, id, payload);
  });
}

// scripts.amis.data.model.dummy
export function dummy() {
  return { message: '请传入ID' };
}

/**
 * 可以直接读取表，也可以读取在模型model.selectOptions中定义的条件，如果没有表中没有定义，使用模型读取。
 *
 * yao run scripts.amis.data.model.selectOptions ddic.model
 *
 * yao run scripts.amis.data.model.selectOptions model_list
 * @param {string} modelId model id
 * @param {object} querys querys
 */
export function selectOptions(modelId: ModelId, querysIn, payload) {
  if (!modelId) {
    throw new Exception('需要指定模型');
  }
  const querys = mergeQueryObject(querysIn, payload);
  const [row] = Process('models.ddic.selectoption.get', {
    wheres: [{ column: 'name', value: modelId }],
    limit: 1
  });

  const query = { model: modelId } as any;
  let wheres = undefined;
  let join = false;
  if (row != null) {
    query.model = row.model_id;
    query.value = row.value_field;
    query.label = row.label_field;
    if (row.wheres) {
      query.wheres = JSON.parse(row.wheres);
    }
    join = row.join;
  }

  if (querys['_value']) {
    query.value = querys['_value'][0];
  }
  if (querys['_label']) {
    query.label = querys['_label'][0];
  }

  const queryParam = queryToQueryParam(query.model, querys) as any;
  wheres = queryParam?.wheres;
  if (wheres != null) {
    query.wheres = wheres;
  }
  // 传入原始搜索
  if (querys['__wheres']) {
    query.wheres = querys['__wheres'][0];
  }

  const data = Process('yao.component.SelectOptions', query);
  data.forEach((x) => {
    const isNull = x.label == null;
    x.label = x.label || x.value;
    if (join && !isNull) {
      x.label = `${x.value}[${x.label}]`;
    }
  });

  return data;
}
