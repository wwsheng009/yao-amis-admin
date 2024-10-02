import { getOdataModel } from '@scripts/app/odata/lib/model';

import functions from '@scripts/app/odata/lib/operator';

import { Exception } from '@yao/yao';
import { QueryObjectIn } from '@yao/request';
import { convertUrlQueryObj, getFirstConfigByKey } from '@lib/request';
import { Qsl } from '@yao/odata';

const OPERATORS_KEYS = ['eq', 'ne', 'gt', 'ge', 'lt', 'le', 'has'];
const stringHelper = {
  has: (str: string, key: string) => str.indexOf(key) >= 0,

  isBeginWith: (str: string, key: string) => str.indexOf(key) === 0,

  isEndWith: (str: string, key: string) =>
    str.lastIndexOf(key) === str.length - key.length,

  removeEndOf: (str: string, key: string) => {
    if (stringHelper.isEndWith(str, key)) {
      return str.substr(0, str.length - key.length);
    }
    return str;
  }
};

const validator = {
  formatValue: (value: string) => {
    let val: boolean | number | string;
    if (value === 'true') {
      val = true;
    } else if (value === 'false') {
      val = false;
    } else if (!Number.isNaN(+value)) {
      val = +value;
    } else if (
      stringHelper.isBeginWith(value, "'") &&
      stringHelper.isEndWith(value, "'")
    ) {
      val = value.slice(1, -1);
    } else if (value === 'null') {
      val = value;
    } else {
      return { err: new Error(`Syntax error at '${value}'.`) };
    }
    return { val };
  }
};

export function ConvertUrlToQsl(oUrl: {
  headers: QueryObjectIn;
  URL: { path: string; query: QueryObjectIn };
}): Qsl {
  const headers = oUrl.headers;

  let pathParam = oUrl.URL.path;
  const query = convertUrlQueryObj(oUrl.URL.query);

  // let sRequestUrl = queryObjectToUrl(query);

  // if (sRequestUrl !== '') {
  //   sRequestUrl = `${pathParam}?${sRequestUrl}`;
  // } else {
  //   sRequestUrl = pathParam;
  // }
  // const q1 = sRequestUrl(sRequestUrl);

  // console.log("sRequestUrl:", sRequestUrl);
  // const odataRequest = odataParser.odataUri(sRequestUrl);
  // console.log("odataRequest:", odataRequest);

  if (pathParam.startsWith('/')) {
    // check if string starts with "/"
    pathParam = pathParam.substring(1); // remove the first character
  }

  const paths = pathParam.split('/');
  if (paths.length === 0) {
    throw new Exception('不正确的请求', 401);
  }
  let part1 = '';
  let part2 = '';
  // let part3 = '';
  if (paths.length > 2) {
    part1 = paths[0];
    part2 = paths[1];
    // part3 = paths[2];
  } else if (paths.length > 1) {
    part1 = paths[0];
    part2 = paths[1];
  } else if (paths.length > 0) {
    part1 = paths[0];
  }
  let count = false;
  const queryDsl = {} as { limit?: number };
  let entitySet = part1;
  // is an optional type-cast segment containing the qualified name of a derived or implemented type prefixed with a forward slash.
  // let typeName = '';
  if (part2 !== '') {
    // typeName = part2;
    // https://services.odata.org/V4/OData/OData.svc/Products/$count
    if (part2 === '$count') {
      count = true;
    }
  }
  // If a response or response part is a single entity of the declared type of an entity set, /$entity is appended to the context URL.
  // if (part3 == '$entity') {
  // }

  let format = 'json';
  if (getFirstConfigByKey(headers, 'Accept').includes('xml')) {
    format = 'xml';
  }
  if (query['$format']) {
    format = query['$format'];
  }

  // 默认json
  if (format != 'json' && format != 'xml') {
    format = 'json';
  }
  // http://host/service/Products?$count=true
  if (query['$count']) {
    if (query['$count'].toLowerCase() == 'true') {
      count = true;
    }
  }
  let viewName = entitySet;
  const modelDsl = getOdataModel(viewName);
  if (modelDsl.table?.name) {
    viewName = modelDsl.table?.name;
  }
  if (count) {
    // 不能直接使用count(*)
    // Unknown column '*' in 'field list'
    // queryParams["select"] = [":count(*) as count"];
    // todo 还需要根据模型获取表名

    return {
      isCount: true,
      entitySet,
      format,
      model: modelDsl,
      qsl: {
        // sql: {
        //   stmt: `select count(*) as total from ${viewName}`,
        // },
      }
    };
  }

  // check the id.
  const result = part1.match(/\((.*?)\)/);
  let id = '';
  if (result && result.length > 0) {
    id = result[1];
    entitySet = entitySet.substring(0, entitySet.indexOf('('));
  }

  // console.log(`service :${entitySet},id:${id}`); // Output: "some content"

  const selectstr = query['$select'];
  if (selectstr && selectstr !== '*') {
    queryDsl['select'] = selectstr.split(',').map((item) => item.trim());
  }

  const skip = query['$skip'];
  if (!isNaN(Number(skip))) {
    queryDsl['offset'] = skip;
  }

  const top = query['$top'];
  if (!isNaN(Number(top))) {
    queryDsl['limit'] = Number(top);
  }

  // http://host/service/Products?$orderby=ReleaseDate asc, Rating desc
  if (id == '') {
    const orderby = query['$orderby'];
    if (orderby) {
      queryDsl['orders'] = orderby.split(',').map((item) => {
        const data = item.trim().split(/\s+/);

        if (data.length > 1) {
          return {
            column: data[0],
            option: data[1]
          };
        } else if (data.length > 0) {
          return {
            column: data[0]
          };
        }
      });
    }

    // http://localhost:5099/api/v1/odata/service/table?$filter=grade lt 10.00
    // http://host/service/Categories?$filter=Products/$count lt 10

    if (query['$filter']) {
      const filter = query['$filter'];

      const condition = splitByKeys(filter, ['and', 'or']);
      // const condition = splitByKeys(filter, ["and", "or"]).filter(
      //   (item) => item !== "and" && item !== "or"
      // );
      const wheres = [];
      for (const item of condition) {
        if (item == 'and') {
          continue;
        }
        if (item == 'or') {
          if (wheres.length > 0) {
            wheres[wheres.length - 1].method = 'orwhere';
          }
        }
        // parse "indexof(title,'X1ML') gt 0"
        const conditionArr = splitByKeys(item, OPERATORS_KEYS);
        if (conditionArr.length === 0) {
          // parse "contains(title,'X1ML')"
          conditionArr.push(item);
        }
        if (conditionArr.length !== 3 && conditionArr.length !== 1) {
          throw new Exception(`语法错误 '${item}'.`, 404);
        }

        let key = conditionArr[0];
        const [, odataOperator, value] = conditionArr;

        if (key === 'id') key = 'id';

        let val = null;
        if (value !== undefined) {
          const result = validator.formatValue(value);
          if (result.err) {
            // return reject(result.err);
            throw new Exception(result.err.message, 404);
          }
          val = result.val;
        }

        // function query
        // const functionKey = key.substring(0, key.indexOf('('));
        // if (['indexof', 'year', 'contains'].indexOf(functionKey) > -1) {
        //   functions[functionKey](query, key, odataOperator, val);
        // } else {
        if (conditionArr.length === 1) {
          throw new Exception(`语法错误 '${item}'.`, 404);
        }
        if (value === 'null') {
          switch (odataOperator) {
            case 'eq':
              wheres.push({
                column: key,
                op: 'null'
              });
              break;
            // wheres.push({
            //   field: key,
            //   op: "is",
            //   value: "null",
            // });
            case 'ne': {
              wheres.push({
                column: key,
                op: 'notnull'
              });
              break;
            }
            // wheres.push({
            //   field: key,
            //   op: "is",
            //   value: "not null",
            // });
            default:
              break;
          }
        }
        // operator query
        switch (odataOperator) {
          case 'eq':
            wheres.push({
              column: key,
              op: 'eq',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: "=",
            //   value: val,
            // });
            break;
          case 'ne':
            wheres.push({
              column: key,
              op: 'ne',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: "<>",
            //   value: val,
            // });
            break;
          case 'gt':
            wheres.push({
              column: key,
              op: 'gt',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: ">",
            //   value: val,
            // });
            break;
          case 'ge':
            wheres.push({
              column: key,
              op: 'ge',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: ">=",
            //   value: val,
            // });
            break;
          case 'lt':
            wheres.push({
              column: key,
              op: 'lt',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: "<",
            //   value: val,
            // });
            break;
          case 'le':
            wheres.push({
              column: key,
              op: 'le',
              value: val
            });
            // wheres.push({
            //   field: key,
            //   op: "<=",
            //   value: val,
            // });
            break;
          default:
            throw new Exception(`Incorrect operator at '${item}'.`, 404);
        }
        // }
      }
      if (wheres.length) {
        queryDsl['wheres'] = wheres;
      }
    }
  } else {
    queryDsl['wheres'] = [
      {
        field: 'id',
        value: id
      }
    ];
  }

  queryDsl['from'] = viewName;
  if (!queryDsl['select']) {
    queryDsl['select'] = [];
  }
  return {
    qsl: queryDsl,
    format,
    entitySet,
    id,
    model: modelDsl
  };
}

// getData("/service/$metadata", query);
function mergeList(list: any[]) {
  return list.join(' ').trim();
}

function splitByKeys(sentence: string, keys = []) {
  let keysArray = keys;
  if (!(keysArray instanceof Array)) {
    keysArray = [keysArray];
  }
  const result = [];
  let tmp = [];
  const words = sentence.split(' ');
  words.forEach((word) => {
    if (keysArray.indexOf(word) > -1) {
      result.push(mergeList(tmp));
      result.push(word);
      tmp = [];
    } else {
      tmp.push(word);
    }
  });
  result.push(mergeList(tmp));
  return result;
}
// module.exports = { ConvertUrlToQsl };
