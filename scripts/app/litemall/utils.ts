function toCamelCase(str) {
  return str.replace(/_([a-z])/g, function (match, letter) {
    return letter.toUpperCase();
  });
}

// 将 camelCase 转换为 snake_case
function toSnakeCase(str) {
  return str.replace(/([A-Z])/g, function (match) {
    return '_' + match.toLowerCase();
  });
}

/**
 * 将对象的键从下划线命名法转换为驼峰命名法
 * 如果传入的是数组，则会递归地对数组中的每个对象进行转换
 * @param {Object|Array} data - 要转换的对象或数组
 * @returns {Object|Array} - 转换后的对象或数组
 */
export function convertKeysToCamelCase(data) {
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
export function convertKeysToSnakeCase(data) {
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
