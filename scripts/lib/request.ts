import { QueryObjectIn, HeaderObject } from '@yao/request';

/**
 * http请求的参数，比如header,或是query是可以包含多个参数，
 * 比如`/api/odata/v2/service/12?$count=true&$count=false`中，在yao的接收时会解析成{count:['true','false']}
 * 为了方便处理，把对象转换成{count:'true,false'}
 * @param inObj yao http query object
 * @returns
 */
export function convertUrlQueryObj(inObj: QueryObjectIn): HeaderObject {
  if (Object.keys(inObj).length == 0) {
    return {};
  }
  const outObj = {};

  for (const key in inObj) {
    if (Object.prototype.hasOwnProperty.call(inObj, key)) {
      const element = inObj[key];
      if (element != null) {
        if (Array.isArray(element) && element.length) {
          outObj[key] = element.join(',');
        } else {
          outObj[key] = element;
        }
      }
    }
  }

  return outObj;
}

/**
 * 检查对象是否包含相关配置项
 * @param query 查询对象
 * @param key 关键字
 * @returns 是否存在配置
 */
export function checkConfigHasKey(query: QueryObjectIn, key: string): boolean {
  const q1 = query[key];
  if (q1 != null && Array.isArray(q1) && q1.length) {
    return true;
  }
  return false;
}
/**
 * 根据key获取获取对象中的第一个配置项，如果需要解析多个配置项，不要使用。
 * @param query
 * @param key
 * @returns
 */
export function getFirstConfigByKey(query: QueryObjectIn, key: string): string {
  const q1 = query[key];
  if (q1 != null && Array.isArray(q1) && q1.length) {
    return q1[0].trim();
  }
  return '';
}

/**
 * convert the query object into query string
 * @param {object} oQuery query object
 * @returns string
 */
export function queryObjectToUrl(oQuery: QueryObjectIn) {
  let sParams = '';
  for (const key in oQuery) {
    if (Object.prototype.hasOwnProperty.call(oQuery, key)) {
      if (Array.isArray(oQuery[key])) {
        oQuery[key].forEach((l) => {
          sParams += `${key}=${l}&`;
        });
      } else {
        sParams += `${key}=${oQuery[key]}&`;
      }
      // sParams += `${decodeURIComponent(key)}=${decodeURIComponent(value)}&`;
    }
  }
  if (sParams.endsWith('&')) {
    sParams = sParams.slice(0, -1);
  }
  return sParams;
}
