import { PaginateArrayWithQuery } from '@scripts/amis/data/lib';

import { Process } from '@yao/yao';

/**
 * 加载API到数据库中
 * yao run scripts.system.meta.saveApis
 * @returns
 */
export function saveApis() {
  const list = allApi();

  const { columns, values } = Process('utils.arr.split', list);
  Process('flows.system.api_clean');
  Process('models.system.api.insert', columns, values);

  return { message: '保存成功' };
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
export function ApiListPaginate(querysIn, payload) {
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
  const apisList = Process('widget.apis');
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
  const apisList = Process('widget.apis');

  return apiDefinitionList(apisList.filter((x) => x.name == 'forms'));
}
/**
 * get all the yao talbe api list
 * @returns 所有的自定义的API清单列表
 */
export function customApis() {
  const apisList = Process('widget.apis');
  return apiDefinitionList(apisList.filter((x) => x.name == 'apis'));
}
// yao run scripts.system.meta.tableApis
function tableApis() {
  const apisList = Process('widget.apis');
  return apiDefinitionList(apisList.filter((x) => x.name == 'tables'));
}

/**
 * 从api接口中解析出table列表
 * yao run scripts.system.meta.getTableListFromApis
 * @returns
 */
export function getTableListFromApis(): string[] {
  const apis = tableApis();

  const paths = {};

  const prefix = '/tables/';
  const suffix = '.tab.json';

  apis.forEach((api) => {
    if (!paths[api.dsl_path]) {
      const startIndex = api.dsl_path.indexOf(prefix) + prefix.length;
      const endIndex = api.dsl_path.lastIndexOf(suffix);

      paths[api.dsl_path] = api.dsl_path
        .substring(startIndex, endIndex)
        .replace(/\//g, '.');
    }
  });

  const api2s = Object.values(paths) as string[];
  return api2s;
}

/**
 * 从api接口中解析出form列表
 * yao run scripts.system.meta.getFormListFromApis
 * @returns
 */
export function getFormListFromApis(): string[] {
  const apis = formApis();

  const paths = {};

  const prefix = '/forms/';
  const suffix = '.form.json';

  apis.forEach((api) => {
    if (!paths[api.dsl_path]) {
      const startIndex = api.dsl_path.indexOf(prefix) + prefix.length;
      const endIndex = api.dsl_path.lastIndexOf(suffix);

      paths[api.dsl_path] = api.dsl_path
        .substring(startIndex, endIndex)
        .replace(/\//g, '.');
    }
  });

  const api2s = Object.values(paths) as string[];
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
            dsl_path: '/' + api.data.DSL.replace(/\\/g, '/'),
            dsl_name: api.name,
            description: path.description || api.data.description,
            version: api.data.version
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
function cleanPath(path: string): string {
  let newPath = path.replace(/\/\//g, '/');
  newPath = newPath.replace(/\\/g, '/');
  newPath = newPath.replace('/apis', '/api');
  return newPath;
}

/**
 * 根据model获取model相关的api列表
 * yao run scripts.system.meta.modelApiList admin.user
 * @param {string} modelId
 * @returns
 */
export function modelApiList(modelId: string) {
  const apiList = allApi();
  const apilist = apiList.filter((api) => api.group == '/v1/system/model');
  apilist.forEach((api) => {
    api.fullpath = api.fullpath.replace(':model', modelId);
    api.router = api.router.replace(':model', modelId);
    api.path = api.path.replace(':model', modelId);
  });
  const tableApis = apiList.filter(
    (api) => api.group == '/__yao/table' && api.url_params?.id === modelId
  );
  const formApis = apiList.filter(
    (api) => api.group == '/__yao/form' && api.url_params?.id === modelId
  );

  return [...apilist, ...tableApis, ...formApis];
}
