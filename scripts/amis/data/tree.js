// 复杂嵌套结构处理

/**
 * 读取并转换一个树结构模型
 * yao run scripts.amis.data.tree.GetNodes admin.menu
 * yao run scripts.amis.data.tree.GetNodes admin.menu '::{"__label":["title"]}'
 * @param {string} model 模型名称
 * @returns
 */
function GetNodes(model, querys) {
  let labelField = "name";
  let valueField = "id";

  let fields = ["id", "parent"];

  if (Array.isArray(querys?.__label) && querys.__label[0].length) {
    labelField = querys.__label[0];
    fields.push(labelField);
  }
  if (Array.isArray(querys?.__value) && querys.__value[0].length) {
    valueField = querys.__value[0];
    fields.push(valueField);
  }

  if (Array.isArray(querys?.select) && querys.select[0].length) {
    selectFields = querys.select[0];
    fields.push(...selectFields.split(","));
  }

  fields = [...new Set(fields)];

  let config = {};

  if (querys != null) {
    config.select = fields;
  }

  const data = Process(`models.${model}.get`, config);

  data.forEach((x) => {
    x.label = x[labelField] || x.label;
    x.value = x[valueField] || x.id;
  });

  return Process(`utils.arr.Tree`, data, { parent: "parent", empty: 0 });
}
/**
 * amis input-tree增加一个节点
 * @param path 增加的节点路径
 * @param parent 父节点或是父节点ID
 * @param node 当前节点数据
 * @returns
 */
function CreateNode(model, { path, parent, ...node }) {
  let newNode = { ...node };
  if (parent && typeof parent === "object" && parent.id) {
    newNode.parent = parent.id;
  } else {
    newNode.parent = parent; //如果是ID
  }
  if (newNode.id && newNode.id == newNode.parent) {
    throw new Exception("上级节点不能选择自己", 400);
  }

  return Process(`models.${model}.save`, newNode);
}
/**
 * 编辑更新一个节点
 * @param {integer} id 节点ID
 * @param {*} newNode 节点，没有携带id信息
 * @returns
 */
function UpdateNode(model, id, newNode) {
  if (id && id == newNode.parent) {
    throw new Exception("上级节点不能选择自己", 400);
  }
  newNode.id = id;

  // 清空父节点
  if (newNode.parent == "" || !newNode.parent) {
    newNode.parent = 0;
  }
  // console.log("newNode", newNode);
  return Process(`models.${model}.save`, newNode);
}

// 删除节点与及所有的子节点
function DeleteNode(model, ids) {
  // 需要处理子节点
  let subItems = [];
  let myArray = ids.split(",");
  myArray &&
    myArray.forEach((id) => {
      let item = Process(`models.${model}.find`, id, null);
      if (item && item.id) {
        subItems = subItems.concat(getSubNodeItems(model, item.id));
        subItems.push(item); //删除自己
      }
    });

  subItems.forEach((item) => {
    Process(`models.${model}.delete`, item.id);
  });
}

// 根据特定的id获取树节点以及所有的子节点
function GetNodeItems(model, id) {
  let item = Process(`models.${model}.find`, id, null);
  let items = [];
  if (item?.id) {
    let subItems = getSubNodeItems(model, item.id);

    subItems.push(item);
    items = items.concat(subItems);
  }
  return Process("utils.arr.Tree", items, {});
  // return items;
}

/**
 * 读取一个所有根节点
 * @param {integer} parentId,父节点部门id
 * @returns 所有的部门节点列表
 */
function getSubNodeItems(model, parentId) {
  let subNodes = Process(`models.${model}.get`, {
    wheres: [
      {
        column: "parent",
        value: parentId,
      },
    ],
  });
  let subItems = [];

  subNodes.map((node) => {
    subItems.push(node);
    subItems = subItems.concat(getSubNodeItems(model, node.id));
  });

  return subItems;
}

/**
 * filter the array with function
 * @param {Array} dataArray data array to filter
 * @param {function} func filter function return true
 * @returns Array
 */
function filterTreeDataWithFunc(dataArray, func) {
  return dataArray.reduce((acc, item) => {
    // Check if the current node or its children match the filter condition
    // console.log("item id=======>", item.id);
    const includesFilter =
      func(item) ||
      (item.children && filterTreeDataWithFunc(item.children, func).length > 0);
    if (includesFilter) {
      if (func(item)) {
        //直接包含所有的子节点
        acc.push({ ...item });
      } else {
        const filteredChildren = item.children
          ? filterTreeDataWithFunc(item.children, func)
          : undefined;
        if (filteredChildren !== undefined) {
          acc.push({ ...item, children: filteredChildren });
        } else {
          acc.push({ ...item });
        }
      }
    }
    return acc;
  }, []);
}

/**
 * filter the tree nested object with ids
 * @param {Array} data Array of nested data
 * @param {Array} filterIds array of ids
 * @returns array
 */
function filterTreeDataById(data, filterIds) {
  // convert to number and remove duplicate items
  let ids = filterIds.map((item) => Number(item));
  ids = [...new Set(ids)];

  return filterTreeDataWithFunc(data, (item) => ids.includes(item.id));
}

/**
 * 收集树结构对象中指定字段的的值。比如在权限对象中的菜单列表。
 * @param {object} data
 * @param {*} field
 * @returns
 */
function collectTreeFields(data, field) {
  if (data == null) {
    return [];
  }
  const fields = [];

  // Recursive function to traverse the object
  function traverse(obj) {
    if (obj != null && typeof obj === "object") {
      if (obj.hasOwnProperty(field)) {
        obj[field] != null && fields.push(obj[field]);
      }

      for (const key in obj) {
        traverse(obj[key]);
      }
    }
  }

  traverse(data);

  const fieldsUniq = flatAndRemoveDuplicate(fields);

  return fieldsUniq;
}

function flatAndRemoveDuplicate(array) {
  // 将多维数组转换为一维数组
  const flatArray = array.flat();

  // 使用Set对象删除重复项
  const uniqueArray = [...new Set(flatArray)];
  return uniqueArray;
}

/**
 * traverse a tree object,combine the key2 of the object to key1 of the object
 *
 * @param {object} data
 * @param {string} key
 * @param {string} key2
 * @param {string} defaultKey the key2 may be empty,use the default key instead
 * @returns
 */
function collectAndCombineData(data, key, key2, defaultKey) {
  if (data == null) {
    return [];
  }
  let collectedData = {};

  function traverse(obj) {
    if (Array.isArray(obj)) {
      obj.forEach((l) => traverse(l));
      return;
    }

    if (
      obj.hasOwnProperty(key) &&
      Array.isArray(obj[key]) &&
      obj[key].length > 0
    ) {
      for (const o of obj[key]) {
        // 使用数组中的行项目作key
        let old = collectedData[o];

        let arrOld = [];
        if (old != null) {
          arrOld = Array.isArray(old) ? old : [old];
        }
        let arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
        collectedData[o] = [...new Set([...arrOld, ...arryNew].flat())];
      }
    } else if (defaultKey) {
      let old = collectedData[defaultKey];
      let arrOld = [];
      if (old != null) {
        arrOld = Array.isArray(old) ? old : [old];
      }
      let arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
      collectedData[defaultKey] = [...new Set([...arrOld, ...arryNew].flat())];
    }

    // 子节点信息
    if (Array.isArray(obj.children)) {
      for (const iterator of obj.children) {
        traverse(iterator);
      }
    }
  }

  traverse(data);
  return collectedData;
}

module.exports = {
  GetNodeItems,
  GetNodes,
  UpdateNode,
  DeleteNode,
  CreateNode,
  filterTreeDataWithFunc,
  filterTreeDataById,
  collectTreeFields,
  flatAndRemoveDuplicate,
  collectAndCombineData,
};
