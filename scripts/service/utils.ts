import { QueryObjectIn } from '@yao/request';

function toCamelCase(str: string) {
  if (!str || typeof str.replace !== 'function') {
    return str;
  }
  return str.replace(/_([a-z])/g, function (_match: any, letter: string) {
    return letter.toUpperCase();
  });
}

// 将 camelCase 转换为 snake_case
function toSnakeCase(str: string) {
  if (!str || typeof str.replace !== 'function') {
    return str;
  }
  return str.replace(/([A-Z])/g, function (match: string) {
    return '_' + match.toLowerCase();
  });
}

export function apiWrapper(params: any) {
  params = convertKeysToCamelCase(params);
  return adapterArrays(params);
}

export function adapterArrays(data: any[]) {
  // 如果是数组，则对数组中的每个元素进行处理
  if (Array.isArray(data)) {
    return data.map((item) => adapterArrays(item));
  }
  // 如果是对象，则对对象的键进行处理
  else if (typeof data === 'object' && data !== null) {
    const newObj = {};
    for (const key in data) {
      if (!data[key]) {
        continue;
      }
      if (Object.prototype.hasOwnProperty.call(data, key)) {
        if (key === 'createdAt') {
          const newKey = 'addTime';
          newObj[newKey] = convertTimestampToFormattedDate(data[key]);
        } else if (key === 'updatedAt') {
          const newKey = 'updateTime';
          newObj[newKey] = convertTimestampToFormattedDate(data[key]);
        } else if (key === 'deletedAt') {
          const newKey = 'deleted';
          if (data[key] != null) {
            newObj[newKey] = true;
          } else {
            newObj[newKey] = false;
          }
        } else {
          newObj[key] = adapterArrays(data[key]);
        }
      }
    }
    return newObj;
  }
  // 如果是其他类型，则直接返回
  return data;
}
function convertTimestampToFormattedDate(timestamp: string | number | Date) {
  // Create a Date object from the provided timestamp
  if (!timestamp) {
    return;
  }

  const originalDate = new Date(timestamp);

  // Format the date into "YYYY-MM-DD HH:mm:ss"
  const formattedDate =
    originalDate.getFullYear() +
    '-' +
    ('0' + (originalDate.getMonth() + 1)).slice(-2) +
    '-' +
    ('0' + originalDate.getDate()).slice(-2) +
    ' ' +
    ('0' + originalDate.getHours()).slice(-2) +
    ':' +
    ('0' + originalDate.getMinutes()).slice(-2) +
    ':' +
    ('0' + originalDate.getSeconds()).slice(-2);
  return formattedDate;
}

/**
 * 将对象的键从下划线命名法转换为驼峰命名法
 * 如果传入的是数组，则会递归地对数组中的每个对象进行转换
 * @param {Object|Array} data - 要转换的对象或数组
 * @returns {Object|Array} - 转换后的对象或数组
 */
export function convertKeysToCamelCase(data: any): object | Array<any> {
  // 如果是数组，则对数组中的每个元素进行处理
  if (Array.isArray(data)) {
    return data.map((item) => convertKeysToCamelCase(item));
  }
  // 如果是对象，则对对象的键进行处理
  else if (typeof data === 'object' && data !== null) {
    const newObj = {};
    for (const key in data) {
      if (Object.prototype.hasOwnProperty.call(data, key)) {
        const camelCaseKey = toCamelCase(key);
        // 递归处理嵌套对象或数组
        newObj[camelCaseKey] = convertKeysToCamelCase(data[key]);
      }
    }
    return newObj;
  }
  // 如果是其他类型，则直接返回
  return data;
}

/**
 * 将对象的键从驼峰命名法转换为下划线命名法
 * 如果传入的是数组，则会递归地对数组中的每个对象进行转换
 * @param {Object|Array} data - 要转换的对象或数组
 * @returns {Object|Array} - 转换后的对象或数组
 */
export function convertKeysToSnakeCase(
  data: any | QueryObjectIn
): object | Array<any> {
  if (Array.isArray(data)) {
    return data.map((item) => convertKeysToSnakeCase(item));
  } else if (typeof data === 'object' && data !== null) {
    const newObj = {};
    for (const key in data) {
      if (Object.prototype.hasOwnProperty.call(data, key)) {
        const snakeCaseKey = toSnakeCase(key);
        newObj[snakeCaseKey] = convertKeysToSnakeCase(data[key]);
      }
    }
    return newObj;
  }
  return data;
}
