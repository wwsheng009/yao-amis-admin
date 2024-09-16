import { PaginateArrayWithQuery } from "@scripts/amis/data/lib";

import { GetColumnTypeList } from "@scripts/system/col_type";

import { Process, Query } from "@yao/yao";

function GetColumnOptions2() {
  return GetColumnTypeList();
}

//scripts.system.meta.GetColumnOptions
function GetColumnOptions() {
  return [
    {
      children: [
        {
          label: "字符串",
          value: "string",
        },
        {
          label: "字符",
          value: "char",
        },
        {
          label: "文本",
          value: "text",
        },
        {
          label: "中文本",
          value: "mediumText",
        },
        {
          label: "长文本",
          value: "longText",
        },
        {
          label: "JSON文本",
          value: "json",
        },
        {
          label: "JSON二进制",
          value: "jsonb",
        },
        {
          label: "UUID",
          value: "格式字符串",
        },
        {
          label: "二进制数据",
          value: "binary",
        },
      ],
      label: "文本",
    },
    {
      children: [
        {
          label: "日期",
          value: "date",
        },
        {
          label: "日期时间",
          value: "datetime",
        },
        {
          label: "带时区的日期时间",
          value: "datetimeTz",
        },
        {
          label: "时间",
          value: "time",
        },
        {
          label: "带时区的时间",
          value: "timeTz",
        },
        {
          label: "时间戳",
          value: "timestamp",
        },
        {
          label: "带时区的时间戳",
          value: "timestampTz",
        },
      ],
      label: "日期时间",
    },
    {
      children: [
        {
          label: "长整型+自增",
          value: "id",
        },
        {
          label: "无符号微整型+自增",
          value: "tinyIncrements",
        },
        {
          label: "无符号小整型+自增",
          value: "smallIncrements",
        },
        {
          label: "无符号整型+自增",
          value: "increments",
        },
        {
          label: "无符号长整型+自增",
          value: "bigIncrements",
        },
      ],
      label: "自增",
    },
    {
      children: [
        {
          label: "微整型",
          value: "tinyInteger",
        },
        {
          label: "无符号微整型",
          value: "unsignedTinyInteger",
        },
        {
          label: "小整型",
          value: "smallInteger",
        },
        {
          label: "无符号小整型",
          value: "unsignedSmallInteger",
        },
        {
          label: "整型",
          value: "integer",
        },
        {
          label: "无符号整型",
          value: "unsignedInteger",
        },
        {
          label: "长整型",
          value: "bigInteger",
        },
        {
          label: "无符号长整型",
          value: "unsignedBigInteger",
        },
      ],
      label: "整型",
    },
    {
      children: [
        {
          label: "浮点数",
          value: "float",
        },
        {
          label: "无符号浮点数",
          value: "unsignedFloat",
        },
        {
          label: "双精度",
          value: "double",
        },
        {
          label: "无符号双精度",
          value: "unsignedDouble",
        },
        {
          label: "小数(一般用于存储货币)",
          value: "decimal",
        },
        {
          label: "无符号小数",
          value: "unsignedDecimal",
        },
      ],
      label: "小数",
    },
    {
      label: "布尔型",
      value: "boolean",
    },
    {
      label: "枚举型",
      value: "enum",
    },
    {
      label: "IP",
      value: "ipAddress",
    },
    {
      label: "网卡地址",
      value: "macAddress",
    },
    {
      label: "年份",
      value: "year",
    },
  ];
}

/**
 * 加载API到数据库中
 * yao run scripts.system.meta.saveApis
 * @returns
 */
function saveApis() {
  const list = allApi();

  const { columns, values } = Process("utils.arr.split", list);
  Process("flows.system.api_clean");
  Process("models.system.api.insert", columns, values);

  return { message: "保存成功" };
}

/**
 * 分页查询API列表，实时，不需要查询数据库，直接从缓存中读取
 * yao run scripts.system.meta.ApiListPaginate
 * @param {number} page page
 * @param {number} perPage page size
 * @param {object} querysIn query url
 * @param {object} payload query from payload
 * @returns
 */
function ApiListPaginate(querysIn, payload) {
  const list = allApi();
  const { items, total } = PaginateArrayWithQuery(list, querysIn, payload);

  return { items: items, total: total };
}

/**
 * get all the api from the yao internel apis
 * yao run scripts.system.meta.allApi
 * @returns
 */
function allApi() {
  const apisList = Process("widget.apis");
  let apis = apiDefinitionList(apisList);
  apis = apis.map((api) => {
    api.method = api.method.toLowerCase();
    return api;
  });
  return apis;
}

/**
 * get all the api list related to yao forms
 * yao run scripts.system.meta.formApis
 * @returns
 */
function formApis() {
  const apisList = Process("widget.apis");

  return apiDefinitionList(apisList.filter((x) => x.name == "forms"));
}
/**
 * get all the yao talbe api list
 * @returns 所有的自定义的API清单列表
 */
function customApis() {
  const apisList = Process("widget.apis");
  return apiDefinitionList(apisList.filter((x) => x.name == "apis"));
}
//yao run scripts.system.meta.tableApis
function tableApis() {
  const apisList = Process("widget.apis");
  return apiDefinitionList(apisList.filter((x) => x.name == "tables"));
}

/**
 * 从api接口中解析出table列表
 * yao run scripts.system.meta.getTableListFromApis
 * @returns
 */
function getTableListFromApis() {
  const apis = tableApis();

  const paths = {};

  const prefix = "/tables/";
  const suffix = ".tab.json";

  apis.forEach((api) => {
    if (!paths[api.dsl_path]) {
      const startIndex = api.dsl_path.indexOf(prefix) + prefix.length;
      const endIndex = api.dsl_path.lastIndexOf(suffix);

      paths[api.dsl_path] = api.dsl_path
        .substring(startIndex, endIndex)
        .replace(/\//g, ".");
    }
  });

  const api2s = Object.values(paths);
  return api2s;
}

/**
 * 从api接口中解析出form列表
 * yao run scripts.system.meta.getFormListFromApis
 * @returns
 */
function getFormListFromApis() {
  const apis = formApis();

  const paths = {};

  const prefix = "/forms/";
  const suffix = ".form.json";

  apis.forEach((api) => {
    if (!paths[api.dsl_path]) {
      const startIndex = api.dsl_path.indexOf(prefix) + prefix.length;
      const endIndex = api.dsl_path.lastIndexOf(suffix);

      paths[api.dsl_path] = api.dsl_path
        .substring(startIndex, endIndex)
        .replace(/\//g, ".");
    }
  });

  const api2s = Object.values(paths);
  return api2s;
}

/**
 * 解析原始的api对象定义并返回一维的api定义列表
 * yao run scripts.system.meta.apiDefinitionList
 * @param {object} api 原始的api定义列表
 * @returns 列表
 */
function apiDefinitionList(apisList) {
  // const apisList = Process("widget.apis");
  if (!apisList || !Array.isArray(apisList) || apisList.length == 0) {
    return [];
  }
  const list = [];

  const traverse = function (api) {
    if (api.children) {
      traverse(api.children);
      // api.children.forEach((line) => {
      //   var subLine = apiDefinitionList(line);
      //   list = list.concat(subLine);
      // });
    } else if (api.data) {
      if (api.data.paths) {
        api.data.paths.forEach((path) => {
          const newPath = {
            ...path,
            //   in: JSON.stringify(path.in),
            //   out: JSON.stringify(path.out),
            //   params: JSON.stringify(path.params),
            // params与amis的全局params冲突
            url_params: path.params,
            guard: path.guard || api.data.guard,
            group: api.group || api.data.group,
            dsl_path: "/" + api.data.DSL.replace(/\\/g, "/"),
            dsl_name: api.name,
            description: path.description || api.data.description,
            version: api.data.version,
          };
          newPath.group = cleanPath(newPath.group);
          newPath.fullpath = cleanPath(newPath.fullpath);
          newPath.router = cleanPath(newPath.router);
          delete newPath.params;
          list.push(newPath);
        });
      }
    } else if (Array.isArray(api)) {
      api.forEach((line) => {
        traverse(line);
        // var subLine = traverse(line);
        // list = list.concat(subLine);
      });
    }
  };
  traverse(apisList);

  return list;
}

/**
 * 清理下导出的数据
 * @param {string} path
 * @returns
 */
function cleanPath(path) {
  let newPath = path.replace(/\/\//g, "/");
  newPath = newPath.replace(/\\/g, "/");
  newPath = newPath.replace("/apis", "/api");
  return newPath;
}

/**
 * 根据model获取model相关的api列表
 * yao run scripts.system.meta.modelApiList admin.user
 * @param {string} model
 * @returns
 */
function modelApiList(model) {
  const allApi = Process("scripts.system.meta.allApi");
  const apilist = allApi.filter((api) => api.group == "/v1/system/model");
  apilist.forEach((api) => {
    api.fullpath = api.fullpath.replace(":model", model);
    api.router = api.router.replace(":model", model);
    api.path = api.path.replace(":model", model);
  });
  const tableApis = allApi.filter(
    (api) => api.group == "/__yao/table" && api.url_params?.id === model
  );
  const formApis = allApi.filter(
    (api) => api.group == "/__yao/form" && api.url_params?.id === model
  );

  return [...apilist, ...tableApis, ...formApis];
}
