"use strict";
//代理js api请求
Object.defineProperty(exports, "__esModule", { value: true });
exports.Server = Server;
const yao_1 = require("./__types/yao");
const yao_2 = require("./__types/yao");
const yao_3 = require("./__types/yao");
/**
 * api 代理服务，可以放在yao应用下
 * @param {object} payload
 * @returns
 */
function Server(payload) {
    // console.log("request received");
    // console.log(payload);
    // log.Info("debug served called");
    // log.Info(payload);
    // JSON.stringify({'a':null,'b':undefined})
    // '{"a":null}'
    let resp = {
        code: 200,
        message: "",
        // error: null as Error, //undefined不会出现在返回json key中
        data: null,
    };
    try {
        const type = payload.type;
        const method = payload.method;
        const args = payload.args;
        const space = payload.space; //"dsl","script","system"
        const engine = payload.engine;
        let localParams = [];
        if (Array.isArray(args)) {
            localParams = args;
        }
        else {
            localParams.push(args);
        }
        switch (type) {
            case "Process":
                resp.data = (0, yao_2.Process)(method, ...localParams);
                break;
            case "Studio":
                // @ts-ignore
                __YAO_SU_ROOT = true;
                resp.data = (0, yao_1.Studio)(method, ...localParams);
                break;
            case "Query":
                if (engine) {
                    const query = new yao_2.Query(engine);
                    //@ts-ignore
                    resp.data = query[method](args);
                }
                else {
                    const query = new yao_2.Query();
                    //@ts-ignore
                    resp.data = query[method](args);
                }
                break;
            case "FileSystem":
                const fs = new yao_3.FS(space);
                //@ts-ignore
                resp.data = fs[method](...args);
                break;
            case "Store":
                const cache = new yao_1.Store(space);
                if (method == "Set") {
                    resp.data = cache.Set(payload.key, payload.value);
                }
                else if (method == "Get") {
                    resp.data = cache.Get(payload.key);
                }
                break;
            case "Http":
                //@ts-ignore
                resp.data = yao_3.http[method](...args);
                break;
            case "Log":
                //@ts-ignore
                yao_3.log[method](...args);
                resp.data = {};
                break;
            case "WebSocket":
                //目前yao只是实现了push一个方法，也是ws服务连接后push一条信息
                const ws = new yao_1.WebSocket(payload.url, payload.protocols);
                if (method == "push") {
                    ws.push(payload.message);
                    resp.data = {};
                }
                break;
            case "Translate":
                resp.data = (0, yao_3.$L)(payload.message);
                break;
            default:
                resp.code = 500;
                resp.message = `不支持的方法调用${type}`;
        }
    }
    catch (error) {
        resp.code = error.code || 500;
        resp.message = error.message || "接口调用异常";
    }
    return resp;
}
//# sourceMappingURL=jsproxy.js.map