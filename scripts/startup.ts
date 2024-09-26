import { Process } from '@yao/yao';
import { importDBModelsToCache } from '@scripts/system/model';
/**
 * 在应用启动时自动加载模型，这个特性需要修改版的yao才支持，非官方功能
 *
 * 功能调整：
 * https://github.com/wwsheng009/yao/commit/52366051044c49fb39f58caccee6a09736870d30
 *
 * yao程序下载：https://github.com/wwsheng009/yao/releases/tag/yao-0.10.4
 * yao run scripts.startup.run
 */
export function start() {
  const yao_env = Process('utils.env.get', 'YAO_ENV');
  // 生产环境才自动加载，开发环境，开发人员手动处理
  if (yao_env !== 'development') {
    // Process('scripts.system.model.importDBModelsToCache');
    // importDBModelsToCache();
  }
  console.log('加载所有数据库模型到缓存');
  importDBModelsToCache();

  // const tabs = Process('scripts.system.meta.getTableListFromApis');
  // console.log('menu list', tabs);
}

/**
 * only trigger when reloading,not trigger when first startup
 */
export function afterLoad() {
  // console.log('reloading');
  // importDBModelsToCache();
}
