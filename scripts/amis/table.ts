import { getCachedModelList } from '@scripts/system/model_lib';

import { PaginateArrayWithQuery } from '@scripts/amis/data/lib';
import { Process } from '@yao/yao';
import { QueryObjectIn } from '@yao/request';

/**
 * yao run scripts.amis.table.TableListSearch  '::{"created":[false]}'
 * @param {object} querysIn url 查询条件，支持get查询
 * @param {object} payload payload 查询条件，支持post查询
 * @returns
 */
export function TableListSearch(querysIn: QueryObjectIn, payload: object) {
  const list = TableList();
  const { items, total } = PaginateArrayWithQuery(list, querysIn, payload);

  return { items: items, total: total };
}

/**
 * 根据表名进行排重
 * yao run scripts.amis.table.TableListUniq
 * @returns
 */
export function TableListUniq(query?: { name: string }) {
  // const list = TableList();

  // 本身已经是排重过的。
  // let result = Object.values(
  //   list.reduce((acc, curr) => {
  //     if (!acc[curr.name]) {
  //       acc[curr.name] = curr;
  //     }
  //     return acc;
  //   }, {})
  // ) as { [k: string]: string }[];
  // console.log(result.length);
  let result = TableList();
  if (query?.name) {
    result = result.filter((item) => item?.name?.includes(query.name));
  }
  return result;
}
// yao run scripts.amis.table.TableNameList
/**
 * 转换成options
 * @returns
 */
export function TableNameList() {
  // const dbTables = Process('schemas.default.Tables') || [];
  // return dbTables.map((item) => {
  //   return { value: item, label: item };
  // });
  const list = TableList().filter((t) => !!t.created);

  return list.map((item) => {
    return { value: item.name, label: item.label };
  });
}

/**
 * 获取数据库中所有表与表的相关状态
 * yao run scripts.amis.table.TableList
 */
function TableList() {
  const dbTables = Process('schemas.default.Tables') || [];
  const cachedModelList = getCachedModelList() || [];
  const savedModelList =
    Process('models.ddic.model.get', { limit: 1000000 }) || [];

  const cachedModelMap = {};
  cachedModelList.reduce((prev, m) => {
    prev[m.table?.name] = m;
    return prev;
  }, cachedModelMap);

  const savedModelMap = {};
  savedModelList.reduce((prev, m) => {
    prev[m.table_name] = m;
    return prev;
  }, savedModelMap);

  // remove duplicate
  // eslint-disable-next-line prefer-const
  let tables = new Set([
    ...dbTables,
    ...Object.keys(cachedModelMap),
    ...Object.keys(savedModelMap)
  ]);
  // cachedModelList.forEach((x) => x.table?.name && tables.push(x.table.name));
  // savedModelList.forEach((x) => x.table_name && tables.push(x.table_name));

  // 一个数据库表可能被多个模型引用

  const result = [];
  tables.forEach((tab) => {
    // 在缓存中找
    const cacheds = cachedModelList.filter((m) => m.table?.name === tab) || [];
    // 在数据库中找
    const saveds =
      savedModelList.filter((model) => model.table_name === tab) || [];

    const cached = cacheds.length > 0 ? true : false;
    const saved = saveds.length > 0 ? true : false;

    if (saved) {
      // 在数据库里有
      saveds.forEach((model) => {
        result.push({
          name: tab, // 数据库表名
          model: model.identity, // 表对应的模型
          model_name: model.name,
          label: model.table_comment || tab, // 如果已经加载到模型中，从模型中获取表的描述
          saved: true, // 是否加载到数据库
          cached: cached, // 是否已经加载到缓存
          created: dbTables.includes(tab) //true // 表已创建
        });
      });
    } else {
      if (cached) {
        cacheds.forEach((model) => {
          result.push({
            name: tab, // 数据库表名
            model: model.ID, // 表对应的模型
            model_name: model.name,
            label: model.table?.comment || tab, // 如果已经加载到模型中，从模型中获取表的描述
            saved: saved, // 是否加保存数据库
            cached: true, // 是否已经加载到缓存
            created: dbTables.includes(tab) //true // 表已创建
          });
        });
      } else {
        result.push({
          name: tab, // 数据库表名
          label: tab,
          saved: false,
          cached: false,
          created: dbTables.includes(tab) // 表已创建
        });
      }
    }
  });
  return result;
}

/**
 * yao run scripts.amis.table.tableNameOptions
 * @returns 返回数据库表列表
 */
export function tableNameOptions() {
  const list = Process('schemas.default.Tables') as string[];
  const tables = list.map((table) => {
    return { label: table, value: table };
  });
  // 不要直接返回数组，amis并不推荐直接返回数组
  // amis默认会使用items属性
  return { items: tables };
}
