const { FindCachedModelById, MomoryModelList, ModelIDList } =
  Require("system.model_lib");

const { PaginateArrayWithQuery } = Require("amis.data.lib");

/**
 * yao run scripts.system.table.TableListSearch  '1' '5' '::{"created":[false]}'
 * @param {number} page 当前分页
 * @param {number} pageSize 分页大小
 * @param {object} querysIn url 查询条件，支持get查询
 * @param {object} payload payload 查询条件，支持post查询
 * @returns
 */
function TableListSearch(page, pageSize, querysIn, payload) {
  let list = TableList();
  const { items, total } = PaginateArrayWithQuery(
    list,
    page,
    pageSize,
    querysIn,
    payload
  );

  return { items: items, total: total };
}

/**
 * 根据表名进行排重
 * yao run scripts.system.table.TableListUniq
 * @returns
 */
function TableListUniq(query) {
  const list = TableList();

  let result = Object.values(
    list.reduce((acc, curr) => {
      if (!acc[curr.name]) {
        acc[curr.name] = curr;
      }
      return acc;
    }, {})
  );

  if (query && query.name) {
    result = result.filter((item) => item.name.includes(query.name));
  }
  return result;
}
// yao run scripts.system.table.TableNameList
/**
 * 转换成options
 * @returns
 */
function TableNameList() {
  const list = TableListUniq();

  return list.map((item) => {
    return { value: item.name, label: item.label };
  });
}

/**
 * 获取数据库中所有表与表的相关状态
 * yao run scripts.system.table.TableList
 */
function TableList() {
  let dbTables = Process("schemas.default.Tables") || [];
  const cachedModels = MomoryModelList() || [];
  let SavedModels = Process("models.ddic.model.get", {}) || [];

  cachedModels.forEach((x) => x.table?.name && dbTables.push(x.table.name));
  SavedModels.forEach((x) => x.table_name && dbTables.push(x.table_name));

  // remove duplicate
  dbTables = [...new Set(dbTables)];

  let result = [];
  dbTables.forEach((tab) => {
    // 在缓存中找
    const cacheds = cachedModels.filter((m) => m.table?.name === tab);

    let cached = Array.isArray(cacheds) && cacheds.length;
    //在数据库中找
    const data = SavedModels.filter((model) => model.table_name == tab);

    let saved = data.length > 0 ? true : false;

    if (saved) {
      // 在数据库里有
      data.forEach((model) => {
        result.push({
          name: tab, //数据库表名
          model: model.identity, //表对应的模型
          model_name: model.name,
          label: model.table_comment || tab, //如果已经加载到模型中，从模型中获取表的描述
          saved: true, //是否加载到数据库
          cached: cached ? true : false, //是否已经加载到缓存
          created: true, //表已创建
        });
      });
    } else {
      if (cached) {
        cacheds.forEach((model) => {
          result.push({
            name: tab, //数据库表名
            model: model.ID, //表对应的模型
            model_name: model.name,
            label: model.table?.comment || tab, //如果已经加载到模型中，从模型中获取表的描述
            saved: false, //是否加保存数据库
            cached: true, //是否已经加载到缓存
            created: true, //表已创建
          });
        });
      } else {
        result.push({
          name: tab, //数据库表名
          label: tab,
          saved: false,
          cached: false,
          created: true, //表已创建
        });
      }
    }
  });
  return result;
}
/**
 * yao run scripts.system.table.tableNameOptions
 * @returns 返回数据库表列表
 */
function tableNameOptions() {
  const list = Process("schemas.default.Tables");
  const tables = list.map((table) => {
    return { label: table, value: table };
  });
  //不要直接返回数组，amis并不推荐直接返回数组
  // amis默认会使用items属性
  return { items: tables };
}
