const { PaginateArrayWithQuery } = Require("amis.data.lib");

function GetColumnOptions2() {
  return [
    {
      label: "字符串string",
      value: "string",
    },
    {
      label: "文本[text]",
      value: "text",
    },
    {
      label: "JSON",
      value: "json",
    },
    {
      label: "日期[date]",
      value: "date",
    },
    {
      label: "日期时间[datetime]",
      value: "datetime",
    },
    {
      label: "时间[time]",
      value: "time",
    },
    {
      label: "自增[id]",
      value: "id",
    },
    {
      label: "整型[integer]",
      value: "integer",
    },
    {
      label: "浮点数[float]",
      value: "float",
    },
    {
      label: "双精度[double]",
      value: "double",
    },
    {
      label: "小数[decimal]",
      value: "decimal",
    },
    {
      label: "布尔型[boolean]",
      value: "boolean",
    },
    {
      label: "枚举型[enum]",
      value: "enum",
    },
    {
      label: "图片[image]",
      value: "image",
    },
    {
      label: "图片集[images]",
      value: "images",
    },
    {
      label: "视频[video]",
      value: "video",
    },
    {
      label: "文件[file]",
      value: "file",
    },
  ];
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
function ApiListPaginate(page, perPage, querysIn, payload) {
  const list = allApi();
  const { items, total } = PaginateArrayWithQuery(
    list,
    page,
    perPage,
    querysIn,
    payload
  );

  return { items: items, total: total };
}

function allApi() {
  const apisList = Process("widget.apis");
  let apis = apiDefinitionList(apisList);
  apis = apis.map((api) => {
    api.method = api.method.toLowerCase();
    return api;
  });
  return apis;
}

function formApis() {
  const apisList = Process("widget.apis");

  return apiDefinitionList(apisList.filter((x) => x.name == "forms"));
}
/**
 *
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

//从api接口中解析出table列表
//yao run scripts.system.meta.getTableListFromApis
function getTableListFromApis() {
  const apis = tableApis();

  let paths = {};

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

  let api2s = Object.values(paths);
  return api2s;
}

//yao run scripts.system.meta.getFormListFromApis
function getFormListFromApis() {
  const apis = formApis();

  let paths = {};

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

  let api2s = Object.values(paths);
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
  var list = [];

  const traval = function (api) {
    if (api.children) {
      traval(api.children);
      // api.children.forEach((line) => {
      //   var subLine = apiDefinitionList(line);
      //   list = list.concat(subLine);
      // });
    } else if (api.data) {
      if (api.data.paths) {
        api.data.paths.forEach((path) => {
          let newPath = {
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
        traval(line);
        // var subLine = traval(line);
        // list = list.concat(subLine);
      });
    }
  };
  traval(apisList);

  return list;
}
//清理下导出的数据
function cleanPath(path) {
  let newPath = path.replace(/\/\//g, "/");
  newPath = newPath.replace(/\\/g, "/");
  newPath = newPath.replace("/apis", "/api");
  return newPath;
}

// yao run scripts.system.meta.modelApiList
function modelApiList(model) {
  let allApi = Process("scripts.system.meta.allApi");
  apilist = allApi.filter((api) => api.group == "/v1/system/model");
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
