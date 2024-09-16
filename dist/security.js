"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CheckAccessKey = CheckAccessKey;
const yao_1 = require("./__types/yao");
/**
 * api guard
 * @param {string} path api path
 * @param {map} params api path params
 * @param {map} queries api queries in url query string
 * @param {object|string} payload json object or string
 * @param {map} headers request headers
 */
function CheckAccessKey(path, params, queries, payload, headers) {
    var token;
    let auth = headers["Authorization"];
    if (auth) {
        token = auth[0].replace("Bearer ", "");
    }
    token = token || (queries["token"] && queries["token"][0]);
    if (!token) {
        error();
    }
    let access_key = (0, yao_1.Process)("yao.env.get", "YAO_API_ACCESS_KEY");
    if (!access_key) {
        throw new yao_1.Exception("YAO_API_ACCESS_KEY Not set", 403);
    }
    if (access_key !== token) {
        error();
    }
    // 如果需要测试会话信息，把YAO_API_ACCESS_KEY设置成用户的token,再反注释以下两行。
    // let data = Process('utils.jwt.Verify', token)
    // return { __sid: data.sid, __global: data.data }
}
function error() {
    throw new yao_1.Exception("Not Authorized", 403);
}
//# sourceMappingURL=security.js.map