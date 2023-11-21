const { getUserAuthApi } = Require("auth.lib");
// yao run scripts.auth.api.getList

// scripts.auth.api.check
function check(path, params, queries, payload, headers) {
  // console.log("path", path);
  // console.log("params", params);
  // console.log("queries", queries);

  // console.log("payload", payload);

  // console.log("headers", headers);

  let user = Process("session.get", "user");
  if (user?.type === "super") {
    return;
  }
  let authObjects = Process("session.get", "user_auth_objects");
  if (authObjects == null || !authObjects) {
    authObjects = getUserAuthApi();
  }
  if (
    authObjects.http_path == null ||
    authObjects.http_path.length == 0 ||
    !authObjects.http_path.includes(path)
  ) {
    throw new Exception(`api:${path} not authorized`);
  }
}
