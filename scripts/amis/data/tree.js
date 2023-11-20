// 复杂嵌套结构处理

/**
 * 读取并转换一个树结构模型
 * yao run scripts.amis.data.tree.GetNodes system.menu
 * yao run scripts.amis.data.tree.GetNodes system.menu '::{"__label":["title"]}'
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
//
// 删除根节点 yao run scripts.system.dept.DeleteDeptNode 3
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

// yao run scripts.system.dept.getItem 1
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
 * yao run scripts.system.dept.getSubNodeItems 1
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
    console.log("item id=======>", item.id);
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
 *
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
        fields.push(obj[field]);
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
};
