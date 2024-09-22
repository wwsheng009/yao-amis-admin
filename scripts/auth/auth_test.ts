// const { getUserAuthObjects } = Require("auth.lib")

function testAuth() {
  // demo data for getUserPermission
  const permissions = [
    {
      children: [],
      created_at: '2023-11-29T14:41:41+08:00',
      desc: '文件管理',
      folder_method: ['READ'],
      folders: ['/project/project2', '/project/测试项目'],
      http_method: null,
      http_path: null,
      id: 1,
      menus: [],
      model_method: null,
      models: null,
      name: 'file_manager',
      order: 0,
      parent: 0,
      updated_at: '2023-11-29T19:00:00+08:00'
    },
    {
      children: [
        {
          children: [],
          created_at: '2023-11-29T19:12:56+08:00',
          desc: '子节点',
          folder_method: ['UPDATE', 'CREATE'],
          folders: ['/project/测试项目'],
          http_method: null,
          http_path: null,
          id: 10,
          menus: null,
          model_method: null,
          models: null,
          name: 'sub_file_manager',
          order: 0,
          parent: 2,
          updated_at: null
        }
      ],
      created_at: '2023-11-29T19:00:17+08:00',
      desc: '文件操作2',
      folder_method: ['DELETE'],
      folders: ['/project/project2', '/project/project4'],
      http_method: null,
      http_path: null,
      id: 2,
      menus: null,
      model_method: null,
      models: null,
      name: 'file_manager2',
      order: 0,
      parent: 0,
      updated_at: null
    }
  ];
  // 收集每一个对象都有哪些操作
  const xxx = collectAndCombineData(permissions, 'folders', 'folder_method');
  // const data = collectTreeFields(permissions, "folders");
  console.log('xxx', xxx);

  // demo data for getUserPermission
  const permissions2 = [
    {
      children: [],
      created_at: '2023-11-29T14:41:41+08:00',
      desc: '文件管理',
      folder_method: [],
      folders: ['/project/project2', '/project/测试项目'],
      http_method: null,
      http_path: null,
      id: 1,
      menus: [],
      model_method: null,
      models: null,
      name: 'file_manager',
      order: 0,
      parent: 0,
      updated_at: '2023-11-29T19:00:00+08:00'
    },
    {
      children: [
        {
          children: [],
          created_at: '2023-11-29T19:12:56+08:00',
          desc: '子节点',
          folder_method: [],
          folders: ['/project/测试项目'],
          http_method: null,
          http_path: null,
          id: 10,
          menus: null,
          model_method: null,
          models: null,
          name: 'sub_file_manager',
          order: 0,
          parent: 2,
          updated_at: null
        }
      ],
      created_at: '2023-11-29T19:00:17+08:00',
      desc: '文件操作2',
      folder_method: ['UPDATE'],
      folders: ['/project/project2'],
      http_method: null,
      http_path: null,
      id: 2,
      menus: null,
      model_method: null,
      models: null,
      name: 'file_manager2',
      order: 0,
      parent: 0,
      updated_at: null
    }
  ];
  // 反过来收集，操作都有哪些对象
  const xxx2 = collectAndCombineData(
    permissions2,
    'folder_method',
    'folders',
    'ALL'
  );
  console.log('xxx', xxx2);
}

/**
 * traverse a tree object,combine the key2 of the object to key1 of the object
 *
 * @param {object} data
 * @param {string} key
 * @param {string} key2
 * @param {string} defaultKey
 * @returns
 */
function collectAndCombineData(data, key, key2, defaultKey = '') {
  if (data == null) {
    return [];
  }
  const collectedData = {};

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
        const old = collectedData[o];

        let arrOld = [];
        if (old != null) {
          arrOld = Array.isArray(old) ? old : [old];
        }
        const arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
        collectedData[o] = [...new Set([...arrOld, ...arryNew].flat())];
      }
    } else if (defaultKey) {
      const old = collectedData[defaultKey];
      let arrOld = [];
      if (old != null) {
        arrOld = Array.isArray(old) ? old : [old];
      }
      const arryNew = Array.isArray(obj[key2]) ? obj[key2] : [obj[key2]];
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
    if (obj != null && typeof obj === 'object') {
      if (obj.hasOwnProperty(field) && obj[field] != null) {
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

// testAuth();
