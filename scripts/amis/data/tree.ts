// 复杂嵌套结构处理

import { Process, Exception } from '@yao/yao';
import { YaoQuery } from '@yaoapps/types';


export interface TreeObj {
  [key: string]: string | number | TreeObj | TreeObj[] | string[] | any;
  children?: TreeObj[];
  id?: number;
}
export interface QueryObject {
  _label: string[];
  _value: string[];
  select: string[];
}
export interface NodeType {
  parent: string | number;
  id: number;
  children?: NodeType[];
}
/**
 * 读取并转换一个树结构模型
 * yao run scripts.amis.data.tree.GetNodes admin.menu
 * yao run scripts.amis.data.tree.GetNodes admin.menu '::{"_label":["title"]}'
 * @param {string} model 模型名称
 * @returns
 */
export function GetNodes(model: string, querys?: QueryObject): NodeType[] {
  let labelField = 'name';
  let valueField = 'id';

  let fields = ['id', 'parent'];

  if (querys != null) {
    if (Array.isArray(querys?._label) && querys._label[0].length) {
      labelField = querys._label[0];
      fields.push(labelField);
    }
    if (Array.isArray(querys?._value) && querys._value[0].length) {
      valueField = querys._value[0];
      fields.push(valueField);
    }
    if (Array.isArray(querys?.select) && querys.select[0].length) {
      const selectFields = querys.select[0];
      fields.push(...selectFields.split(','));
    }
  }

  fields = [...new Set(fields)];

  const config = {} as YaoQuery.QueryDSL;

  if (querys != null) {
    config.select = fields;
  }

  const data = Process(`models.${model}.get`, config);

  data.forEach((x) => {
    x.label = x[labelField] || x.label;
    x.value = x[valueField] || x.id;
  });

  return Process(`utils.arr.Tree`, data, { parent: 'parent', empty: 0 });
}
/**
 * amis input-tree增加一个节点
 * @param path 增加的节点路径
 * @param parent 父节点或是父节点ID
 * @param node 当前节点数据
 * @returns
 */
export function CreateNode(model: string, { parent, ...node }): number {
  const newNode = { ...node } as NodeType;
  if (parent && typeof parent === 'object' && parent.id) {
    newNode.parent = parent.id;
  } else {
    newNode.parent = parent; // 如果是ID
  }
  if (newNode.id && newNode.id == newNode.parent) {
    throw new Exception('上级节点不能选择自己', 400);
  }

  return Process(`models.${model}.save`, newNode);
}
/**
 * 编辑更新一个节点
 * @param {integer} id 节点ID
 * @param {*} newNode 节点，没有携带id信息
 * @returns
 */
export function UpdateNode(
  model: string,
  id: number,
  newNode: NodeType
): number {
  if (id && id == newNode.parent) {
    throw new Exception('上级节点不能选择自己', 400);
  }
  newNode.id = id;

  // 清空父节点
  if (newNode.parent == '' || !newNode.parent) {
    newNode.parent = 0;
  }
  // console.log("newNode", newNode);
  return Process(`models.${model}.save`, newNode);
}

/**
 * 删除节点与及所有的子节点
 * @param {string} modelId
 * @param {string} ids
 */
export function DeleteNode(modelId: string, ids: string) {
  // 需要处理子节点
  let subItems = [];
  const myArray = ids.split(',');
  myArray?.forEach((id) => {
    const item = Process(`models.${modelId}.find`, id, null);
    if (item && item.id) {
      subItems = subItems.concat(getSubNodeItems(modelId, item.id));
      subItems.push(item); // 删除自己
    }
  });

  subItems.forEach((item) => {
    Process(`models.${modelId}.delete`, item.id);
  });
}

/**
 * 根据特定的id获取树节点以及所有的子节点
 * yao run scripts.amis.data.tree.GetNodeItems admin.menu 1
 * @param {string} modelId
 * @param {string|number} id
 * @returns
 */
export function GetNodeItems(modelId: string, id: number): TreeObj {
  const item = Process(`models.${modelId}.find`, id, null);
  let items = [];
  if (item?.id) {
    const subItems = getSubNodeItems(modelId, item.id);

    subItems.push(item);
    items = items.concat(subItems);
  }
  return Process('utils.arr.Tree', items, {});
  // return items;
}
/**
 * 读取一个所有根节点
 * @param {integer} parentId,父节点部门id
 * @returns 所有的部门节点列表
 */
function getSubNodeItems(modelId: string, parentId: number): NodeType[] {
  const subNodes = Process(`models.${modelId}.get`, {
    wheres: [
      {
        column: 'parent',
        value: parentId
      }
    ]
  }) as NodeType[];
  let subItems = [];

  subNodes.map((node) => {
    subItems.push(node);
    subItems = subItems.concat(getSubNodeItems(modelId, node.id));
  });

  return subItems;
}

/**
 * filter the array with function
 * @param {Array} dataArray data array to filter
 * @param {function} func filter function return true
 * @returns Array
 */
export function filterTreeDataWithFunc<T extends { children?: T[] }>(
  dataArray: T[],
  func: (x: T) => boolean
): T[] {
  return dataArray.reduce((acc, item) => {
    // Check if the current node or its children match the filter condition
    // console.log("item id=======>", item.id);
    const includesFilter =
      func(item) ||
      (item.children && filterTreeDataWithFunc(item.children, func).length > 0);
    if (includesFilter) {
      if (func(item)) {
        // 直接包含所有的子节点
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
  }, [] as T[]);
}

/**
 * filter the tree nested object with ids
 * @param {Array} data Array of nested data
 * @param {Array} filterIds array of ids
 * @returns array
 */
export function filterTreeDataById(data: TreeObj[], filterIds: string[]) {
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
export function collectTreeFields(data: TreeObj[], field: string) {
  if (data == null) {
    return [];
  }
  const fields = [];

  // Recursive function to traverse the object
  function traverse(obj: TreeObj | TreeObj[]) {
    if (obj != null && typeof obj === 'object') {
      if (Object.prototype.hasOwnProperty.call(obj, field)) {
        if (obj[field] != null) {
          fields.push(obj[field]);
        }
      }
      if (Array.isArray(obj)) {
        obj.forEach((l) => traverse(l));
      } else {
        for (const key in obj) {
          traverse(obj[key] as TreeObj);
        }
      }
    }
  }

  traverse(data);

  const fieldsUniq = flatAndRemoveDuplicate(fields);

  return fieldsUniq;
}
/**
 * 将多维数组转换为一维数组，并删除重复项。
 * @param {Array} array
 * @returns
 */
function flatAndRemoveDuplicate(array: any[]) {
  // 将多维数组转换为一维数组
  const flatArray = array.flat();

  // 使用Set对象删除重复项
  const uniqueArray = [...new Set(flatArray)];
  return uniqueArray;
}

/**
 * traverse a tree object,combine the key2 of the object to key of the object
 *
 * @param {object} data
 * @param {string} key 作为key的字段名
 * @param {string} key2 作为组的字段名
 * @param {string} defaultKey the key2 may be empty,use the default key instead
 * @returns
 */
export function collectAndCombineData(
  data: TreeObj[],
  key: string,
  key2: string,
  defaultKey?: string
) {
  if (data == null) {
    return [];
  }
  const collectedData = {} as { [key: string]: string[] | number[] };

  function traverse(obj: TreeObj | TreeObj[]) {
    if (Array.isArray(obj)) {
      obj.forEach((l) => traverse(l));
      return;
    }

    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      if (Array.isArray(obj[key]) && obj[key].length > 0) {
        //循环数组
        for (const o of obj[key]) {
          // 使用数组中的行项目作key
          const old = collectedData[o as string];

          let arrOld = [];
          if (old != null) {
            arrOld = Array.isArray(old) ? old : [old];
          }
          if (obj[key2] != null) {
            const arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
            collectedData[o as string] = [
              ...new Set([...arrOld, ...arryNew].flat())
            ];
          }
        }
      } else {
        const o = obj[key];
        const old = collectedData[o as string];

        let arrOld = [];
        if (old != null) {
          arrOld = Array.isArray(old) ? old : [old];
        }
        if (obj[key2] != null) {
          const arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
          collectedData[o as string] = [
            ...new Set([...arrOld, ...arryNew].flat())
          ];
        }
      }
    } else if (defaultKey != null) {
      const old = collectedData[defaultKey];
      let arrOld = [];
      if (old != null) {
        arrOld = Array.isArray(old) ? old : [old];
      }
      if (obj[key2] != null) {
        const arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
        collectedData[defaultKey] = [
          ...new Set([...arrOld, ...arryNew].flat())
        ];
      }
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

// module.exports = {
//   GetNodeItems,
//   GetNodes,
//   UpdateNode,
//   DeleteNode,
//   CreateNode,
//   filterTreeDataWithFunc,
//   filterTreeDataById,
//   collectTreeFields,
//   flatAndRemoveDuplicate,
//   collectAndCombineData,
// };
