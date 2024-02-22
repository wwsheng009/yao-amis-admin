const { getModelsEntityset } = Require("odata.lib.model");
const { getEntryMetaDataXml, getMetaDataXml2, convertJsonToXml } =
  Require("odata.lib.process");

const { decodePartsRequest } = Require("odata.lib.decodebatch");
const { ConvertUrlToQsl } = Require("odata.lib.queryparam");

// function head() { }

function postData(
  pathIn,
  queryIn,
  headers,
  host,
  path,
  schema,
  fullpath,
  payload,
  parts
) {
  console.log("headers:", headers);
  console.log(">>>>>>>>>>>>>>>>>>>>called post");
  console.log("post payload:", payload);
  console.log("parts:", parts.length, parts);

  let metaFullPath = getMetaFullPath(fullpath, schema, host);

  if (pathIn === "/$batch") {
    return processBatchPost(headers, parts);
  }
}

function processBatchPost(metaFullPath, headers, parts) {
  //parts
  aRequest = decodePartsRequest(metaFullPath, headers, parts);

  let sResponse = "";
  let iTotalLen = 0;
  aRequest.forEach((request) => {
    const oResponse = getDataFromRequest(request, metaFullPath);
    let data1 = JSON.stringify(oResponse.data);
    let len = data1.length;
    iTotalLen += len;
    let template = `--batch_foobarbaz
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

  sResponseBody = sResponseBody.replace(/\n/g, "\r\n");
  return sResponseBody;
}
function getBasePath(fullpath, schema, host) {
  let rootpath = fullpath.split("/").slice(0, -1).join("/");
  let fullPath = `${schema}://${host}${rootpath}/`;
  return fullPath;
}
function getMetaFullPath(fullpath, schema, host) {
  let rootpath = fullpath.split("/").slice(0, -1).join("/");
  let metapath = `${rootpath}/$metadata`;
  let metaFullPath = `${schema}://${host}${metapath}`;
  return metaFullPath;
}
/**
 * 转换查询参数
 * 注意：golang 不支持在query里带有符号;
 * @param {string} pathIn url path
 * @param {object} query 查询参数
 * @returns
 */
function getData(pathIn, queryIn, headers, host, path, schema, fullpath) {
  console.log("headers:", headers);

  let query = queryIn || {};
  console.log("pathIn:", pathIn);

  console.log("query:", query);
  console.log("path:", path);
  console.log("fullpath", fullpath);

  let metaFullPath = getMetaFullPath(fullpath, schema, host);

  let pathParam = pathIn;
  if (pathParam.startsWith("/")) {
    // check if string starts with "/"
    pathParam = pathParam.substring(1); // remove the first character
  }
  let basePath = getBasePath(fullpath, schema, host);

  //元数据
  if (pathParam == "$" || pathParam == "") {
    return {
      data: {
        "@odata.context": `${metaFullPath}`,
        value: getModelsEntityset(),
      },
      type: "application/json;charset=utf-8",
      status: 200,
    };
  }
  if (pathParam == "$metadata" || pathParam == "") {
    let data = getMetaData();
    return data;
  }

  let oRequest = {};
  oRequest.headers = headers;
  oRequest.URL = {};
  oRequest.URL.path = pathIn;
  oRequest.URL.query = query;
  return getDataFromRequest(oRequest, basePath);
}

function getDataFromRequest(oRequest, basePath) {
  const metaFullPath = basePath + "$metadata";
  const oQsl = ConvertUrlToQsl(oRequest);

  const q = new Query();

  // 计算数量
  if (oQsl.isCount) {
    let total = 0;
    // console.log("oQsl.model?.table_id",oQsl.model?.table_id)
    if (oQsl.model?.table_id) {
      total = Process("yao.table.search", oQsl.model.table_id, {}, 1, 1)?.total;
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
      type: "application/json;charset=utf-8",
      status: 200,
      data: { total: total },
    };
  } else {
    if (oQsl.qsl.limit) {
      oQsl.qsl.limit = 100000;
    }
    // const data1 = q.Get(oQsl.qsl);
    let data1 = null;
    if (oQsl.model?.table_id) {
      data1 = Process("yao.table.get", oQsl.model.table_id, oQsl.qsl);
    } else {
      data1 = q.Get(oQsl.qsl);
    }

    if (oQsl.format == "json") {
      let data = {
        "@odata.context": `${metaFullPath}#${oQsl.entitySet}`,
        value: data1,
      };
      // 单条
      if (oQsl.id != "") {
        if (data1 && data1.length) {
          data = data1[0];
          data["@odata.context"] = `${metaFullPath}#${oQsl.entitySet}/$entity`;
        } else {
          data = {};
        }
      }

      return {
        type: "application/json;charset=utf-8",
        status: 200,
        data: data,
      };
    } else {
      const data = convertJsonToXml(data1, oQsl.entitySet, basePath);
      return {
        // type: "application/atom+xml;type=feed;charset=utf-8",
        type: "application/atom+xml;charset=utf-8",
        status: 200,
        data: data,
      };
    }
  }
}

// /**
//  * 查询服务的元数据。
//  * @param {string} service 服务
//  * @returns
//  */
// function getMetaData() {
//     return Process("scripts.main.test");
// }

// const query = {
//     $select: ["Rating,ReleaseDate"],
//     $orderby: ["engine asc, browser desc"],
//     // $count: true,
//     $filter: ["grade lt 10.00"],
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
