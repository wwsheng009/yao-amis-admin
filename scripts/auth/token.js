/**
 * api guard,scripts.auth.token.Check，检查身份验证
 * @param {string} path api path
 * @param {map} params api path params
 * @param {map} queries api queries in url query string
 * @param {object|string} payload json object or string
 * @param {map} headers request headers
 */
function Check(path, params, queries, payload, headers) {
  const token = getToken(path, params, queries, payload, headers);
  if (!token) {
    error();
  }
  if (token == "" || token.length == 0) {
    error();
  }

  let data = Process("utils.jwt.Verify", token);
  return { __sid: data.sid, __global: data.data };
}
function error() {
  throw new Exception("Not Authorized", 403);
}

// yao run scripts.security.CheckToken
function CheckToken(path, params, queries, payload, headers) {
  let token = getToken(path, params, queries, payload, headers);
  if (!token) {
    return;
  }

  // try {
  let data = Process("utils.jwt.Verify", token);
  return { __sid: data.sid, __global: data.data };
  // } catch (error) {
  //   console.log("Error:", error);
  //   console.log("Invalid Token:", token);
  // }
}

function getToken(path, params, queries, payload, headers) {
  // 接受三种身份验证参数传入路径
  // 1 headers Authorization
  // 2 cookie token
  // 3 url查询参数中的token
  let token = null;
  let auth = headers["Authorization"];
  if (auth) {
    token = auth[0];
  } else {
    token = token || (queries["token"] && queries["token"][0]);
  }
  if (!auth) {
    let cookies = headers["Cookie"];
    cookies &&
      cookies.forEach((cookie) => {
        const cookies2 = cookie.split(";"); // split the cookies into an array
        cookies2.forEach((cookie) => {
          const [name, value] = cookie.trim().split("="); // split cookie name and value
          if (name === "token") {
            token = value; // assign cookie value to token variable
          }
        });
      });
  }
  if (token) {
    token = token.replace("Bearer ", "");
  }
  return token;
}
