const { getUserAuthApiCache, isSuperUser } = Require("auth.lib");

/**
 * 检查api的访问权限，使用方法：在api guard中输入：scripts.auth.api.check
 * 用户的api权限需要通过分配权限，分配角色，在用户重新登录后就会生效
 * @param {string} path 
 * @param {object} params 
 * @param {object} queries
 * @param {object} payload 
 * @param {object} headers 
 * @returns 
 */
function check(path, params, queries, payload, headers) {
  // console.log("path", path);
  // console.log("params", params);
  // console.log("queries", queries);

  // console.log("payload", payload);

  // console.log("headers", headers);

  if (isSuperUser()) {
    return;
  }
  let authObjects = getUserAuthApiCache();
  if (
    authObjects.http_path == null ||
    authObjects.http_path.length == 0 ||
    !authObjects.http_path.includes(path)
  ) {
    throw new Exception(`api:${path} not authorized`);
  }
}
