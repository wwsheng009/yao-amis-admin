export type MapStr = {
  [key: string]: string;
};
export type MapAny = {
  [key: string]: any;
};

/**
 * 合并两个js对象，并返回新对象。
 * yao studio run model.utils.MergeObject
 * @param target 目标对象
 * @param source 源对象
 * @returns
 */
export function MergeObject(target: MapAny, source: MapAny) {
  if (
    target === null ||
    target === undefined ||
    typeof target !== "object" ||
    source === null || //mybe undefined
    source === undefined ||
    typeof source !== "object"
  ) {
    return target;
  }

  for (const [key, value] of Object.entries(source)) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (
        target[key] &&
        typeof target[key] === "object" &&
        typeof value === "object" &&
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
  if (typeof obj1 !== "object" || typeof obj2 !== "object") {
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
  for (let key of keys1) {
    // Check if the current key exists in both objects
    if (!obj2.hasOwnProperty(key)) {
      return false;
    }

    // Recursively compare nested objects
    if (typeof obj1[key] === "object" && typeof obj2[key] === "object") {
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

module.exports = {
  MergeObject,
  deleteObjectKey,
  areObjectsEqual
}