
/**
 * 在应用启动时自动加载模型，这个特性需要修改版的yao才支持，非官方功能
 * 
 * 功能调整：
 * https://github.com/wwsheng009/yao/commit/52366051044c49fb39f58caccee6a09736870d30
 * 
 * yao程序下载：https://github.com/wwsheng009/yao/releases/tag/yao-0.10.4
 */
function run() {
    console.log("加载所有数据库模型到缓存")
    Process("scripts.system.model.importDBModelsToCache")
}