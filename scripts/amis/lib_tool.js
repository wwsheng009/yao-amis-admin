// Require("amis.lib_tool")

/**
 * 处理模型名称分隔符
 *
 * yao studio run model.file.DotName table_name
 * yao studio run model.file.DotName /file/name
 * @param {string} pathname
 * @returns model name with dot
 */
function DotName(pathname) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, "/");
  str = str.replace(/\/\//g, "/");
  str = str.replace(/\//g, ".");
  str = str.replace(/-/g, ".");
  str = str.replace(/_/g, ".");
  let newStr = str.replace(/^\.+|\.+$/g, "");
  return newStr;
}

/**
 * 处理数据库表名分隔符，把模型标识转换化成表名，在这里一般会有一个命名规范的约束
 *
 * yao studio run model.file.UnderscoreName crm.help
 * @param {string} pathname
 * @returns pathname
 */
function UnderscoreName(pathname) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, "/");
  str = str.replace(/\/\//g, "/");
  str = str.replace(/\//g, "_");
  str = str.replace(/-/g, "_");
  str = str.replace(/\./g, "_");
  let newStr = str.replace(/^_+|_+$/g, "");
  return newStr;
}

/**
 * 处理路径分隔符
 *
 * @param {string} pathname
 * @returns pathname
 */
function SlashName(pathname) {
  if (!pathname || !pathname.length) {
    return pathname;
  }
  let str = pathname;
  str = str.replace(/\\/g, "/");
  // 不应把下划线作转换
  // str = str.replace(/_/g, "/");
  str = str.replace(/-/g, "/");
  str = str.replace(/\./g, "/");
  str = str.replace(/\/\//g, "/");
  let newStr = str.replace(/^\/+|\/+$/g, "");
  return newStr;
}

/**
 * 转换成有效的文件名称
 *
 * @param {string} filename
 * @returns new filename
 */
function FileNameConvert(filename) {
  // 不应用把下划线作转换
  // const str = filename.replace(/[\\_]/g, "/");
  const str = filename;
  const arr = str.split(".");
  if (arr.length < 3) {
    return str;
  }
  const suffix = arr.slice(-2);
  const header = arr.slice(0, -2);
  const str1 = header.join("/") + "." + suffix.join(".");
  return str1.replace(/\/\//g, "/");
}

/**
 * 获取yao配置的数据类型
 * @returns string
 */
function getDBType() {
  return Process("utils.env.Get", "YAO_DB_DRIVER");
}
/**
 * 判断是否是mysql数据库
 * @returns boolean
 */
function IsMysql() {
  return /mysql/i.test(getDBType());
}
/**
 * 判断是否是postgres数据库
 * @returns boolean
 */
function IsPg() {
  return /postgres/i.test(getDBType());
}

function IsSqlite() {
  return /sqlite/i.test(getDBType());
}
function ClearFalsyKeys(target) {
  if (target === null || target === undefined || typeof target !== "object") {
    return target;
  }
  const result = Array.isArray(target) ? [] : {}; // Fix 2: Create new object/array
  if (Object.keys(target).length == 0) {
    return result;
  }
  for (let key in target) {
    const value = target[key];
    if (!value && value !== false) {
      // Fix 3: Check for all falsy values
      continue;
    }
    if (Array.isArray(value)) {
      const newArray = value.map((item) => ClearFalsyKeys(item));
      result[key] = newArray.filter((item) => Boolean(item)); // remove falsy values from array

      if (value.length == 0) {
        delete result[key];
      }
    } else if (typeof value === "object") {
      result[key] = ClearFalsyKeys(value); //Fix 4: Assign the returned value to result
      // 空对象不输出
      if (Object.keys(result[key]).length == 0) {
        delete result[key];
      }
    } else {
      result[key] = value;
    }
  }
  return result; //Fix 2: return new object/array
}

//删除对象中的空节点
function RemoveOjbectEmptyKey(obj) {
  for (var prop in obj) {
    if (obj[prop] === null || obj[prop] === undefined) {
      //null属性
      delete obj[prop];
    } else if (typeof obj[prop] === "object") {
      //递归处理
      RemoveOjbectEmptyKey(obj[prop]);
      if (Array.isArray(obj[prop]) && obj[prop].length === 0) {
        //空数组
        delete obj[prop];
      } else if (Object.keys(obj[prop]).length === 0) {
        //空对象
        delete obj[prop];
      }
    }
  }
  return obj;
}

module.exports = {
  DotName,
  UnderscoreName,
  SlashName,
  FileNameConvert,
  IsMysql,
  IsPg,
  IsSqlite,
  ClearFalsyKeys,
  RemoveOjbectEmptyKey,
};
