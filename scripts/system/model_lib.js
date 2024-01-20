const { getModelFromDB, loadModeltoMemory } = Require("system.model_db");



//读取所有的模型id的列表
//缺少一个name属性，所有只能读取到id列表
//yao run scripts.system.model.ModelIDList
//["admin.user","demo.table"]
function ModelIDList() {
  return MomoryModelList("ID").map((item) => item.ID);
}

/**
 * 返回所以模型列表
 * @returns []object
 */
function CachedModelList() {
  const models = Process("widget.models");
  return FlatModelList(models);
}
/**
 * 解析内存中的模型数据,可以使用路径表达式
 * yao run scripts.system.model_lib.MomoryModelList
 * yao run scripts.system.model_lib.MomoryModelList name
 * yao run scripts.system.model_lib.MomoryModelList name,ID
 * @param {*} modelData
 * @returns
 */
function MomoryModelList(attr) {
  const models = Process("widget.models");
  return FlatModelList(models, attr);
}
/**
 * 扁平化模型列表
 * @param {object} models yao 模型 嵌套的数据结构
 * @param {string} attr,使用路径表达式抽取子对象
 * @returns
 */
function FlatModelList(models, attr) {
  const list = [];

  const getProperty = (object, path) => {
    const properties = path.split(".");
    let currentObject = object;

    for (let i = 0; i < properties.length; i++) {
      currentObject = currentObject[properties[i]];
    }
    return currentObject;
  };

  const setProperty = (object, path, value) => {
    const properties = path.split(".");
    let currentObject = object;

    for (let i = 0; i < properties.length - 1; i++) {
      if (currentObject === undefined) {
        throw new Error(
          `Property '${properties[i]}' does not exist in path '${path}'`
        );
      }
      //   注意，不支持生成数组
      if (!currentObject.hasOwnProperty(properties[i])) {
        currentObject[properties[i]] = {};
      }
      currentObject = currentObject[properties[i]];
    }

    currentObject[properties[properties.length - 1]] = value;
  };
  let attr2 = [];
  if (typeof attr === "string") {
    // 单个属性
    attr2 = attr.split(",");
  } else if (Array.isArray(attr)) {
    attr2 = attr;
  }
  const traverse = (node) => {
    if (node.children) {
      traverse(node.children);
    } else if (node.data) {
      if (attr != null) {
        const o = {};
        attr2.forEach((a) => {
          const p = getProperty(node.data, a);
          if (p != null) {
            // o[a] = p;
            setProperty(o, a, p);
          }
        });
        list.push(o);
      } else {
        list.push(node.data);
      }
    } else if (Array.isArray(node)) {
      node.forEach((line) => {
        traverse(line);
      });
    }
  };
  traverse(models);
  return list;
}

/**
 * 根据模型ID在缓存中查找模型定义
 * yao run scripts.system.model_lib.FindCachedModelById
 * @param {Array} models 模型缓存，保存了所有的模型定义
 * @param {number/string} id 模型标识
 * @returns object | null
 */
function FindCachedModelById(modelId) {
  const models = Process("widget.models");

  const traverse = (node, id) => {
    if (node.children) {
      return traverse(node.children, id);
    } else if (node.data) {
      if (node.data.ID == id) {
        return node.data;
      }
    } else if (Array.isArray(node)) {
      for (const item of node) {
        var obj = traverse(item, id);
        if (obj) {
          return obj;
        }
      }
    }
  };

  return traverse(models, modelId);
}

/**
 * 优先从缓存中加载模型，如果不存在，从数据库中加载并转换成yao模型
 * @param {string} modelId 
 */
function FindAndLoadYaoModelById(modelId) {
  let modelDsl = FindCachedModelById(modelId)
  if (modelDsl == null) {
    let modelDsl = getModelFromDB(modelId);

    if (modelDsl != null) {
      // 加载到内存中。
      let err = loadModeltoMemory(modelDsl, false);
      if (err?.code && err?.Message) {
        throw Error(err?.Message + err?.code);
      }
      modelDsl = FindCachedModelById(modelId)
    }
  }

  if (!modelDsl) {
    throw new Exception(`模型${modelId}定义不存在，未加载？`, 500);
  }
  return modelDsl
}


/**
 * 加载模型标识，优先从数据库中加载，找不到再在缓存中加载
 * 数据库的模型信息会更多
 * 
 * yao run scripts.system.model.getDBModelById
 * @param {string} modelId 模型标识
 * @returns
 */
function FindAndLoadDBModelById(modelId) {
  if (!modelId) {
    throw new Exception(`缺少模型标识`)
  }
  let modelDsl = getModelFromDB(modelId);
  let modelDsl2 = FindCachedModelById(modelId);

  if (modelDsl != null && modelDsl2 == null) {
    loadModeltoMemory(modelDsl, false);
  }
  if (modelDsl == null && modelDsl2 != null) {
    modelDsl = modelDsl2
  }
  if (modelDsl == null) {
    throw new Exception(`模型：${modelId}不存在`)
  }
  return modelDsl;
}



/**
 * 解析内存中的模型数据
 * @param {*} modelData
 * @returns
 */
function modelIdListFromMemory(modelData) {
  var idList = [];
  if (modelData.children) {
    modelData.children.forEach((line) => {
      var subLine = modelIdListFromMemory(line);
      idList = idList.concat(subLine);
    });
  } else if (modelData.data) {
    if (modelData.data) {
      idList.push(modelData.data.ID);
    }
  } else if (Array.isArray(modelData)) {
    modelData.forEach((line) => {
      var subLine = modelIdListFromMemory(line);
      idList = idList.concat(subLine);
    });
  }
  return idList;
}


//yao run调试前先注释
module.exports = {
  FlatModelList,
  FindCachedModelById,
  FindAndLoadYaoModelById,
  CachedModelList,
  MomoryModelList,
  ModelIDList,
  FindAndLoadDBModelById
};
