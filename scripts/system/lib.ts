export type MapStr = {
  [key: string]: string;
};
export type MapAny = {
  [key: string]: any;
};

import { Process } from '@yao/yao';

/**
 * 处理模型名称分隔符
 *
 * @param {string} pathname
 * @returns model name with dot
 */
export function DotName(pathname: string) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, '/');
  str = str.replace(/\/\//g, '/');
  str = str.replace(/\//g, '.');
  str = str.replace(/-/g, '.');
  str = str.replace(/_/g, '.');
  const newStr = str.replace(/^\.+|\.+$/g, '');
  return newStr;
}

/**
 * 处理数据库表名分隔符，把模型标识转换化成表名，在这里一般会有一个命名规范的约束
 *
 * @param {string} pathname
 * @returns pathname
 */
export function UnderscoreName(pathname: string) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, '/');
  str = str.replace(/\/\//g, '/');
  str = str.replace(/\//g, '_');
  str = str.replace(/-/g, '_');
  str = str.replace(/\./g, '_');
  const newStr = str.replace(/^_+|_+$/g, '');
  return newStr;
}

/**
 * 处理路径分隔符
 *
 * @param {string} pathname
 * @returns pathname
 */
export function SlashName(pathname: string) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, '/');
  // 不应把下划线作转换
  // str = str.replace(/_/g, "/");
  str = str.replace(/-/g, '/');
  str = str.replace(/\./g, '/');
  str = str.replace(/\/\//g, '/');
  const newStr = str.replace(/^\/+|\/+$/g, '');
  return newStr;
}

/**
 * 转换成有效的文件名称
 *
 * @param {string} filename
 * @returns new filename
 */
export function FileNameConvert(filename: string) {
  // 不应用把下划线作转换
  // const str = filename.replace(/[\\_]/g, "/");
  const str = filename;
  const arr = str.split('.');
  if (arr.length < 3) {
    return str;
  }
  const suffix = arr.slice(-2);
  const header = arr.slice(0, -2);
  const str1 = header.join('/') + '.' + suffix.join('.');
  return str1.replace(/\/\//g, '/');
}

/**
 * 获取yao配置的数据类型
 * @returns string
 */
function getDBType() {
  return Process('utils.env.Get', 'YAO_DB_DRIVER');
}
/**
 * 判断是否是mysql数据库
 * @returns boolean
 */
export function IsMysql() {
  return /mysql/i.test(getDBType());
}
/**
 * 判断是否是postgres数据库
 * @returns boolean
 */
export function IsPg() {
  return /postgres/i.test(getDBType());
}

export function IsSqlite() {
  return /sqlite/i.test(getDBType());
}
export function ClearFalsyKeys(target) {
  if (target === null || target === undefined || typeof target !== 'object') {
    return target;
  }
  const result = Array.isArray(target) ? [] : {}; // Fix 2: Create new object/array
  if (Object.keys(target).length == 0) {
    return result;
  }
  for (const key in target) {
    const value = target[key];
    if (value === undefined || value === null) {
      continue;
    }
    if (Array.isArray(value)) {
      const newArray = value.map((item) => ClearFalsyKeys(item));
      result[key] = newArray.filter(
        (item) => item !== undefined && item !== null
      ); // remove falsy values from array

      if (value.length == 0) {
        delete result[key];
      }
    } else if (typeof value === 'object') {
      const obj = ClearFalsyKeys(value); // Fix 4: Assign the returned value to result
      if (obj !== undefined && obj != null) {
        result[key] = obj;
        // 空对象不输出
        if (
          typeof result[key] === 'object' &&
          Object.keys(result[key]).length == 0
        ) {
          delete result[key];
        }
      }
    } else {
      result[key] = value;
    }
  }
  return result; // Fix 2: return new object/array
}

// 删除对象中的空节点
export function RemoveOjbectEmptyKey(obj: { [x: string]: any }) {
  for (const prop in obj) {
    if (obj[prop] === null || obj[prop] === undefined) {
      // null属性
      delete obj[prop];
    } else if (typeof obj[prop] === 'object') {
      // 递归处理
      RemoveOjbectEmptyKey(obj[prop]);
      if (Array.isArray(obj[prop]) && obj[prop].length === 0) {
        // 空数组
        delete obj[prop];
      } else if (Object.keys(obj[prop]).length === 0) {
        // 空对象
        delete obj[prop];
      }
    }
  }
  return obj;
}

/**
 * 合并两个js对象，并返回新对象。
 * @param target 目标对象
 * @param source 源对象
 * @returns
 */
export function MergeObject(target: MapAny, source: MapAny) {
  if (
    target === null ||
    target === undefined ||
    typeof target !== 'object' ||
    source === null || // mybe undefined
    source === undefined ||
    typeof source !== 'object'
  ) {
    return target;
  }

  for (const [key, value] of Object.entries(source)) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (
        target[key] &&
        typeof target[key] === 'object' &&
        typeof value === 'object' &&
        !Array.isArray(value)
      ) {
        MergeObject(target[key], value);
      } else if (Array.isArray(target[key]) && Array.isArray(value)) {
        target[key].push(...value);
      } else {
        target[key] = value;
      }
    } else {
      target[key] = value;
    }
  }

  return target;
}

/**
 * delete special key in object
 * @param obj object or arry
 * @param object_key key to be delete
 * @returns void
 */
export function deleteObjectKey(obj: any, object_key: string): void {
  if (!(obj instanceof Object) && !(obj instanceof Array)) {
    return;
  }
  if (obj instanceof Array) {
    for (let index = 0; index < obj.length; index++) {
      deleteObjectKey(obj[index], object_key);
    }
  } else {
    for (const key in obj) {
      if (obj[key] instanceof Object) {
        deleteObjectKey(obj[key], object_key);
      } else if (obj[key] instanceof Array) {
        deleteObjectKey(obj[key], object_key);
      }
      if (key == object_key) {
        delete obj[key];
      }
    }
  }
}

export function areObjectsEqual(
  obj1: object | Array<object>,
  obj2: object | Array<object>
) {
  // Check if both objects are of type object
  if (typeof obj1 !== 'object' || typeof obj2 !== 'object') {
    return false;
  }

  // Get the keys of the objects
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  // Check if the number of properties is the same
  if (keys1.length !== keys2.length) {
    return false;
  }

  // Iterate over the keys and compare the values
  for (const key of keys1) {
    // Check if the current key exists in both objects
    if (!obj2.hasOwnProperty(key)) {
      return false;
    }

    // Recursively compare nested objects
    if (typeof obj1[key] === 'object' && typeof obj2[key] === 'object') {
      if (!areObjectsEqual(obj1[key], obj2[key])) {
        return false;
      }
    } else {
      // Compare the values of non-nested properties
      if (obj1[key] !== obj2[key]) {
        return false;
      }
    }
  }

  // Objects are considered equal
  return true;
}

// module.exports = {
//   MergeObject,
//   deleteObjectKey,
//   areObjectsEqual
// }
