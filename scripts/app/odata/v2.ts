import {
  getEntryMetaDataXml,
  getMetaDataXml2,
  convertJsonToXml
} from '@scripts/app/odata/lib/process';

import { ConvertUrlToQsl } from '@scripts/app/odata/lib/queryparam';
import { decodePartsRequest } from '@scripts/app/odata/lib/decodebatch';
import { Process } from '@yao/yao';
import { QueryObjectIn } from '@yao/request';

export function postData(
  pathIn: string,
  queryIn: QueryObjectIn,
  headers: QueryObjectIn,
  host: string,
  path: string,
  schema: string,
  fullpath: string,
  payload,
  parts: string[]
) {
  console.log('headers:', headers);
  console.log('>>>>>>>>>>>>>>>>>>>>called post');
  console.log('post payload:', payload);
  console.log('parts:', parts.length, parts);

  const metaFullPath = getMetaFullPath(fullpath, schema, host);

  if (pathIn === '/$batch') {
    return processBatchPost(metaFullPath, headers, parts);
  }
}

export function processBatchPost(
  metaFullPath: string,
  headers: QueryObjectIn,
  parts: string[]
) {
  // parts
  const aRequest = decodePartsRequest(headers, parts);

  let sResponse = '';
  let iTotalLen = 0;
  aRequest.forEach((request) => {
    const oResponse = getDataFromRequest(request, metaFullPath);
    const data1 = JSON.stringify(oResponse.data);
    const len = data1.length;
    iTotalLen += len;
    const template = `--batch_foobarbaz
Content-Type: ${oResponse.type}
Content-ID: <response-item1:12930812@classroom.example.com>

HTTP/1.1 200 OK
Content-Type:${oResponse.type}
Content-Length: ${len}

${data1}`;
    sResponse += template;
  });

  let sResponseBody = `HTTP/1.1 200
Content-Length: ${iTotalLen}
Content-Type: multipart/mixed; boundary=batch_foobarbaz
HTTP/1.1 200 OK

${sResponse}
--batch_foobarbaz--`;

  sResponseBody = sResponseBody.replace(/\n/g, '\r\n');
  return sResponseBody;
}

export function getMetaFullPath(
  fullpath: string,
  schema: string,
  host: string
) {
  const rootpath = fullpath.split('/').slice(0, -1).join('/');
  const metapath = `${rootpath}/$metadata`;
  const metaFullPath = `${schema}://${host}${metapath}`;
  return metaFullPath;
}

/**
 * odata请求的形式一般是 /xx_table/$format=xx
 * @param {string} fullpath
 * @param {string} schema http| https
 * @param {string} host
 * @returns
 */
export function getBasePath(fullpath: string, schema: string, host: string) {
  const rootpath = fullpath.split('/').slice(0, -1).join('/');
  const fullPath = `${schema}://${host}${rootpath}/`;
  return fullPath;
}

/**
 * 转换查询参数
 * 注意：golang 不支持在query里带有符号;
 * @param {string} sPathIn url path
 * @param {string} path 原始请求的地址，不包含查询参数
 * @param {object} query 查询参数
 * @returns
 */
export function getData(
  sPathIn: string,
  oQueryIn: QueryObjectIn,
  headers: QueryObjectIn,
  host: string,
  path: string,
  schema: string,
  fullpath: string
) {
  // console.log('headers:', headers);
  // console.log('pathIn:', sPathIn);

  // console.log('oQueryIn:', oQueryIn);
  // console.log('path:', path);
  // console.log('fullpath', fullpath);

  const oQuery = oQueryIn || {};

  let pathParam = sPathIn;
  if (pathParam.startsWith('/')) {
    // check if string starts with "/"
    pathParam = pathParam.substring(1); // remove the first character
  }
  const basePath = getBasePath(fullpath, schema, host);

  // 不是请求元数据，而是/$，请求模型列表
  if (pathParam == '$' || pathParam == '') {
    return {
      // 获取模型列表
      data: getEntryMetaDataXml(basePath),
      type: 'application/xml;charset=utf-8',
      status: 200
    };
  }
  // 查询元数据的请求
  if (pathParam == '$metadata') {
    const data = getMetaDataXml2();
    return data;
  }

  const oRequest = { headers, URL: { path: sPathIn, query: oQuery } };
  // oRequest.headers = headers;
  // oRequest.URL = {};
  // oRequest.URL.path = sPathIn;
  // oRequest.URL.query = oQuery;
  try {
    return getDataFromRequest(oRequest, basePath);
  } catch (e) {
    console.log('error message', e.message);
    // 这里应该优化返回xml
    return {
      type: 'application/json;charset=utf-8',
      status: e.code,
      data: { message: e.message }
    };
  }
}

export function getDataFromRequest(
  oRequest: {
    headers: QueryObjectIn;
    URL: { path: string; query: QueryObjectIn };
  },
  basePath: string
) {
  const metaFullPath = basePath + '$metadata';
  const oQsl = ConvertUrlToQsl(oRequest);

  // 计算数量
  if (oQsl.isCount) {
    let total = 0;

    if (oQsl.model?.table_id) {
      total = Process('yao.table.search', oQsl.model.table_id, {}, 1, 1)?.total;
    } else if (oQsl.model?.model_id) {
      total = Process(
        `models.${oQsl.model.model_id}.Paginate`,
        {},
        1,
        1
      )?.total;
    }
    // let data = q.Get(oQsl.qsl)[0]["total"];
    return {
      type: 'application/json;charset=utf-8',
      status: 200,
      data: { total: total }
    };
  } else {
    if (!oQsl.qsl?.limit) {
      oQsl.qsl.limit = 100000;
    }
    oQsl.qsl.limit = Number(oQsl.qsl.limit);
    let data1 = null;
    if (oQsl.model?.table_id) {
      data1 = Process('yao.table.get', oQsl.model.table_id, oQsl.qsl);
    } else {
      // data1 = q.Get(oQsl.qsl);
      data1 = Process(`models.${oQsl.model.model_id}.get`, oQsl.qsl);
    }

    if (oQsl.format == 'json') {
      let data = {
        '@odata.context': `${metaFullPath}#${oQsl.entitySet}`,
        value: data1
      };
      // 单条
      if (oQsl.id != '') {
        if (data1 && data1.length) {
          data = data1[0];
          data['@odata.context'] = `${metaFullPath}#${oQsl.entitySet}/$entity`;
        }
      }

      return {
        type: 'application/json;charset=utf-8',
        status: 200,
        data: data
      };
    } else {
      const data = convertJsonToXml(data1, oQsl.entitySet, basePath);
      return {
        // type: "application/atom+xml;type=feed;charset=utf-8",
        type: 'application/atom+xml;charset=utf-8',
        status: 200,
        data: data
      };
    }
  }
}

/**
 * 查询服务的元数据。
 * @param {string} service 服务
 * @returns
 */
// export function getMetaData() {
//   return Process("scripts.main.test");
// }

// const query = {
//   $select: ["Rating,ReleaseDate"],
//   $orderby: ["engine asc, browser desc"],
//   // $count: true,
//   $filter: ["grade lt 10.00"],
// };
// getData("/table/", query);

// http://localhost:5099/api/v1/odata/service/Products?$select=Rating,ReleaseDate
// http://localhost:5099/api/v1/odata/service/Products?$select=*
// http://localhost:5099/api/v1/odata/service/Products?$select=DemoService.*
// http://localhost:5099/api/v1/odata/service/Employees(1)/Sales.Manager?$select=FirstName,LastName&$levels=4

// url中带有;会失败  golang.org/issue/25192
// http://localhost:5099/api/v1/odata/service/Employees(1)/Sales.Manager?$expand=DirectReports($select=FirstName,LastName;$levels=4)

// http://localhost:5099/api/v1/odata/service
// {"fullpath":"/api/v1/odata/data/*path","path":"/cc[x666666xx123]","query":{"b1":["123"]}}

// getData("/service");
// getData("/service(1)");

// http://localhost:5099/api/v1/odata/service/table?$orderby=browser asc, platform desc
// http://localhost:5099/api/v1/odata/service/table?$count=true
