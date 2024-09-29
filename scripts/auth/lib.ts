import {
  filterTreeDataById,
  collectTreeFields,
  collectAndCombineData
} from '@scripts/amis/data/tree';
import {
  AuthFolder,
  AuthModel,
  AuthObject,
  AuthRoute,
  PermissionFolder,
  PermissionModel,
  PermissionRoute
} from '@yao/auth';

import { Process, Exception } from '@yao/yao';

/**
 * 获取用户的权限信息
 *
 * yao run scripts.auth.lib.getUserPermission '5'
 * @param {number} userId user id
 * @returns
 */
function getUserPermission(userId?: number | string) {
  let user_id = userId;
  if (!user_id) {
    user_id = Process('session.get', 'user_id');
    if (!user_id) {
      // user_id = 1;
      throw new Exception('缺少用户ID', 500);
    }
  }

  // get user roles
  const user = Process('models.admin.user.find', user_id, {});
  if (user == null) {
    throw new Exception('用户不存在', 500);
  }
  if (user.role == null) {
    return;
    // throw new Exception("用户未配置角色", 500);
  }
  user.role = typeof user.role === 'string' ? user.role.split(',') : user.role;

  if (!Array.isArray(user.role)) {
    // single role
    user.role = [user.role];
  }
  const rolePemissions = user.role.reduce((acc, item) => {
    const role = Process('models.admin.auth.role.find', item, {});
    let perms = role.permission;
    if (role && role.status && perms != null) {
      perms = typeof perms === 'string' ? perms.split(',') : perms;
      if (!Array.isArray(perms)) {
        perms = [perms];
      }
      acc.push(...perms);
    }
    return acc;
  }, []);

  if (rolePemissions.length == 0) {
    return;
    // throw new Exception(`角色未配置权限`, 500);
  }
  const permissions = Process('models.admin.auth.permission.get', {});
  if (permissions.length == 0) {
    return;
    // throw new Exception(`系统未配置权限`, 500);
  }
  const permissionsTree = Process(`utils.arr.Tree`, permissions, {
    parent: 'parent',
    empty: 0
  });

  // 返回的结构是一个嵌套的树结构
  const permissionFilter = filterTreeDataById(permissionsTree, rolePemissions);
  return permissionFilter;
}
/**
 * 获取用户的授权菜单列表id
 * @returns []
 */
function getUserAuthObjectIds(objkey: string) {
  const permissions = getUserPermission();
  const objIds = collectTreeFields(permissions, objkey);
  return objIds;
}
// yao run scripts.auth.lib.getUserAuthMenuIds
export function getUserAuthMenuIds() {
  return getUserAuthObjectIds('menus');
}

/**
 * get the user auth objects from session
 *
 * the auth objects are set when use login
 * @returns
 */
export function getUserAuthApiCache() {
  const authObjects = Process('session.get', 'user_auth_objects') as AuthObject;
  if (authObjects == null || !authObjects) {
    return getUserAuthApi();
  }
  return authObjects.api;
}

/**
 * get user authorized api object from session
 *
 * yao run scripts.auth.lib.getUserAuthApi
 * @returns
 */
export function getUserAuthApi() {
  const permissions = getUserPermission();
  const api_auth = {} as AuthRoute;
  api_auth.api_list = collectTreeFields(
    permissions,
    'routes'
  ) as PermissionRoute[];
  // map objects => {'API1':['GET','POST']}
  api_auth.api_with_method = collectAndCombineData(
    api_auth.api_list,
    'route',
    'operation'
  );
  // // map objects = > {'GET':['API1','API2']}
  api_auth.method_with_api = collectAndCombineData(
    api_auth.api_list,
    'operation',
    'route',
    'ANY'
  );

  api_auth.method_with_api = fillApiOpertion(api_auth.method_with_api);
  return api_auth;
}
// getUserAuthApi();

function fillApiOpertion(methdMap) {
  if (typeof methdMap != 'object') {
    return methdMap;
  }
  methdMap['GET'] ||= [];
  methdMap['POST'] ||= [];
  methdMap['PUT'] ||= [];
  methdMap['DELETE'] ||= [];
  methdMap['PATCH'] ||= [];
  methdMap['OPTIONS'] ||= [];
  methdMap['HEAD'] ||= [];
  methdMap['ANY'] ||= [];
  return methdMap;
}

export function getUserAuthModelCache() {
  const authObjects = Process('session.get', 'user_auth_objects') as AuthObject;
  if (authObjects == null || !authObjects) {
    return getUserAuthModel();
  }
  return authObjects.model;
}
/**
 * yao run scripts.auth.lib.getUserAuthModel
 * @returns
 */
export function getUserAuthModel() {
  const permissions = getUserPermission();
  const model_auth = {} as AuthModel;

  model_auth.model_list = collectTreeFields(
    permissions,
    'models'
  ) as PermissionModel[];
  // console.log('model_auth.model_list', model_auth.model_list);
  // map objects => {'folder':['READ','UPDATE']}
  model_auth.model_with_method = collectAndCombineData(
    model_auth.model_list,
    'model',
    'operation'
  );
  // map objects = > {'READ':['fmod','folder1']}
  model_auth.method_with_model = collectAndCombineData(
    model_auth.model_list,
    'operation',
    'model',
    'ANY'
  );

  model_auth.method_with_model = fillModelOpertion(
    model_auth.method_with_model
  );
  return model_auth;
}

function fillModelOpertion(methdMap) {
  if (typeof methdMap != 'object') {
    return methdMap;
  }
  methdMap['ANY'] ||= [];
  methdMap['CREATE'] ||= [];
  methdMap['UPDATE'] ||= [];
  methdMap['DELETE'] ||= [];
  methdMap['READ'] ||= [];
  return methdMap;
}
/**
 * 是否超级用户
 * @returns
 */
export function isSuperUser() {
  const user = Process('session.get', 'user');
  // 超级用户没有限制
  if (user?.type === 'super') {
    return true;
  }
  return false;
}
/**
 * 从缓存中读取用户的目录授权
 * @returns
 */
export function getUserAuthFolderCache() {
  // return getUserAuthFolder();
  const authObjects = Process('session.get', 'user_auth_objects') as AuthObject;
  if (authObjects == null || !authObjects) {
    return getUserAuthFolder();
  }
  return authObjects.folder;
}

/**
 * 用户授权目录与操作
 * yao run scripts.auth.lib.getUserAuthFolder
 * @returns
 */
export function getUserAuthFolder() {
  const permissions = getUserPermission();
  const folder_auth = {} as AuthFolder;
  folder_auth.folder_list = collectTreeFields(
    permissions,
    'folders'
  ) as PermissionFolder[];
  // console.log('folder_auth.folder_list', folder_auth.folder_list);
  // adapter
  folder_auth.folder_list.forEach((f) => {
    f.folderValue = f.folder.value as string;
  });
  // map objects => {'folder':['READ','UPDATE']}
  folder_auth.folder_with_method = collectAndCombineData(
    folder_auth.folder_list,
    'folderValue',
    'operation'
  );
  // map objects = > {'READ':['folder','folder1']}
  folder_auth.method_with_folder = collectAndCombineData(
    folder_auth.folder_list,
    'operation',
    'folderValue',
    'ANY'
  );

  folder_auth.method_with_folder = fillFolderOpertion(
    folder_auth.method_with_folder
  );

  return folder_auth;
}
function fillFolderOpertion(methdMap) {
  if (typeof methdMap != 'object') {
    return methdMap;
  }
  methdMap['ANY'] ||= [];
  methdMap['CREATE'] ||= [];
  methdMap['UPDATE'] ||= [];
  methdMap['DELETE'] ||= [];
  methdMap['READ'] ||= [];
  return methdMap;
}
/**
 * 根据用户ID获取用户的权限对象列表
 * 在用户登录时会把用户的权限对象列表加入缓存中。
 * yao run scripts.auth.lib.getUserAuthObjects
 * @param {number} userId user id
 * @returns
 */
export function getUserAuthObjects(userId: number): AuthObject {
  const permissions = getUserPermission(userId);
  const model_auth = {} as AuthModel;

  model_auth.model_list = collectTreeFields(
    permissions,
    'models'
  ) as PermissionModel[];
  // map objects => {'MODEL':['READ','UPDATE']}
  model_auth.model_with_method = collectAndCombineData(
    model_auth.model_list,
    'model',
    'operation'
  );
  // map objects = > {'READ':['MODEL1','MODEL2']}
  model_auth.method_with_model = collectAndCombineData(
    model_auth.model_list,
    'operation',
    'model',
    'ANY'
  );
  fillModelOpertion(model_auth.method_with_model);

  const api_auth = {} as AuthRoute;
  api_auth.api_list = collectTreeFields(
    permissions,
    'routes'
  ) as PermissionRoute[];
  // map objects => {'API1':['GET','POST']}
  api_auth.api_with_method = collectAndCombineData(
    api_auth.api_list,
    'route',
    'operation'
  );
  // map objects = > {'GET':['API1','API2']}
  api_auth.method_with_api = collectAndCombineData(
    api_auth.api_list,
    'operation',
    'route',
    'ANY'
  );
  fillApiOpertion(api_auth.method_with_api);

  const folder_auth = {} as AuthFolder;
  folder_auth.folder_list = collectTreeFields(
    permissions,
    'folders'
  ) as PermissionFolder[];
  // map objects => {'folder':['READ','UPDATE']}
  folder_auth.folder_with_method = collectAndCombineData(
    folder_auth.folder_list,
    'folder',
    'operation'
  );
  // map objects = > {'READ':['folder','folder1']}
  folder_auth.method_with_folder = collectAndCombineData(
    folder_auth.folder_list,
    'operation',
    'folder',
    'ANY'
  );

  fillFolderOpertion(folder_auth.method_with_folder);

  const menus = collectTreeFields(permissions, 'menus') as number[];

  return { api: api_auth, model: model_auth, folder: folder_auth, menus };
}

// module.exports = {
//   getUserAuthMenuIds,
//   getUserAuthApi,
//   getUserAuthModel,
//   getUserAuthObjects,
//   getUserAuthFolder,
//   getUserAuthFolderCache,
//   isSuperUser,
//   getUserAuthModelCache,
//   getUserAuthApiCache,
// };
