/**
 * api guard,scripts.auth.basic.Check，检查身份验证
 * @param {string} path api path
 * @param {map} params api path params
 * @param {map} queries api queries in url query string
 * @param {object|string} payload json object or string
 * @param {map} headers request headers
 */
function Check(path, params, queries, payload, headers) {
    checkAuth(headers)
}

function checkAuth(headers) {
    //   "Authorization": [
    //     "Basic dXNlcm5hbWU6cGFzc3dvcmQ="
    // ],
    let auth = headers["Authorization"]?.[0]
    if (auth) {
        if (auth.startsWith("Basic ")) {
            const base64 = auth.substring("Basic ".length)
            const key = Process("encoding.base64.Decode", base64);
            const keys = key.split(":")
            if (keys.length == 2) {
                const userName = keys[0]
                const password = keys[1]
                // console.log("userName", userName)
                // console.log("password", password)
                const result = Process("scripts.amis.user.userVerify", userName, password)
                if (result.code == 200) {
                    return
                }
            }
        }
    }
    throw new Exception("Not Authorized", 403)
}