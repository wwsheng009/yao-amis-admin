const { filterTreeDataById, collectTreeFields } = Require("amis.data.tree");

/**
 * 获取用户的权限信息
 * @param {number} userId user id
 * @returns 
 */
function getUserPermission(userId) {
  let user_id = userId;
  if (!user_id) {
    user_id = Process("session.get", "user_id");
    if (!user_id) {
      // user_id = "5";
      throw new Exception("缺少用户ID", 500);
    }
  }

  // get user roles
  const user = Process("models.admin.user.find", user_id, {});
  if (user == null) {
    throw new Exception("用户不存在", 500);
  }
  if (user.role == null) {
    return;
    // throw new Exception("用户未配置角色", 500);
  }
  user.role = typeof user.role === "string" ? user.role.split(",") : user.role;

  if (!Array.isArray(user.role)) {
    // single role
    user.role = [user.role];
  }
  const rolePemissions = user.role.reduce((acc, item) => {
    const role = Process("models.system.auth.role.find", item, {});
    let perms = role.permission;
    if (role && role.status && perms != null) {
      perms = typeof perms === "string" ? perms.split(",") : perms;
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
  const permissions = Process("models.system.auth.permission.get", {});
  if (permissions.length == 0) {
    return;
    // throw new Exception(`系统未配置权限`, 500);
  }
  const permissionsTree = Process(`utils.arr.Tree`, permissions, {
    parent: "parent",
    empty: 0,
  });

  const permissionFilter = filterTreeDataById(permissionsTree, rolePemissions);
  //   if (permissionFilter.length == 0) {
  //     throw new Exception(`角色未关联任何权限`, 500);
  //   }
  return permissionFilter;
}
/**
 * 获取用户的授权菜单列表id
 * @returns []
 */
function getUserAuthObjectIds(objkey) {
  const permissions = getUserPermission();
  let objIds = collectTreeFields(permissions, objkey);
  return objIds;
}
// yao run scripts.auth.auth_lib.getUserAuthMenuIds
function getUserAuthMenuIds() {
  return getUserAuthObjectIds("menus");
}

function getUserAuthApiCache() {
  let authObjects = Process("session.get", "user_auth_objects");
  if (authObjects == null || !authObjects) {
    authObjects = getUserAuthApi();
  }
  return {
    http_path: authObjects.http_path,
    http_method: authObjects.http_method
  }
}

// yao run scripts.auth.lib.getUserAuthApi
function getUserAuthApi() {
  const permissions = getUserPermission();
  let auths = {};
  auths.http_path = collectTreeFields(permissions, "http_path");
  auths.http_method = collectTreeFields(permissions, "http_method");
  return auths;
}

function getUserAuthModelCache() {
  let authObjects = Process("session.get", "user_auth_objects");
  if (authObjects == null || !authObjects) {
    return getUserAuthModel();
  }
  // return getUserAuthFolder();
  return {
    models: authObjects.models,
    model_method: authObjects.model_method
  }

}
function getUserAuthModel() {
  const permissions = getUserPermission();
  let auths = {};
  auths.models = collectTreeFields(permissions, "models");
  auths.model_method = collectTreeFields(permissions, "http_method");
  return auths;
}

/**
 * 是否超级用户
 * @returns
 */
function isSuperUser() {
  let user = Process("session.get", "user");
  // 超级用户没有限制
  if (user?.type === "super") {
    return true;
  }
  return false
}
/**
 * 从缓存中读取用户的目录授权
 * @returns 
 */
function getUserAuthFolderCache() {
  let authObjects = Process("session.get", "user_auth_objects");
  if (authObjects == null || !authObjects) {
    return getUserAuthFolder();
  }
  // return getUserAuthFolder();
  return {
    folders: authObjects.folders,
    folder_method: authObjects.folder_method
  }
}
/**
 * 用户授权目录与操作
 * @returns 
 */
function getUserAuthFolder() {
  const permissions = getUserPermission();
  let auths = {};
  auths.folders = collectTreeFields(permissions, "folders");
  auths.folder_method = collectTreeFields(permissions, "folder_method");
  return auths;
}
/**
 * 根据用户ID获取用户的权限对象列表
 * 在用户登录时会把用户的权限对象列表加入缓存中。
 * @param {number} userId user id
 * @returns 
 */
function getUserAuthObjects(userId) {
  const permissions = getUserPermission(userId);
  let auths = {};
  auths.models = collectTreeFields(permissions, "models");
  auths.model_method = collectTreeFields(permissions, "http_method");
  auths.http_path = collectTreeFields(permissions, "http_path");
  auths.http_method = collectTreeFields(permissions, "http_method");
  auths.menus = collectTreeFields(permissions, "menus");
  auths.folders = collectTreeFields(permissions, "folders");
  auths.folder_method = collectTreeFields(permissions, "folder_method");
  return auths;
}

module.exports = {
  getUserAuthMenuIds,
  getUserAuthApi,
  getUserAuthModel,
  getUserAuthObjects,
  getUserAuthFolder,
  getUserAuthFolderCache,
  isSuperUser,
  getUserAuthModelCache,
  getUserAuthApiCache
};
