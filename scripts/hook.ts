import { importDBModelsToCache } from '@scripts/system/model';
/**
 * 在应用启动时自动加载模型，这个特性需要修改版的yao才支持，非官方功能
 *
 * 功能调整：
 * https://github.com/wwsheng009/yao/commit/52366051044c49fb39f58caccee6a09736870d30
 *
 * yao程序下载：https://github.com/wwsheng009/yao/releases/tag/yao-0.10.4
 */
export function startup(config: object, reload: boolean) {
  // const yao_env = Process('utils.env.get', 'YAO_ENV');
  // 生产环境才自动加载，开发环境，开发人员手动处理
  // if (yao_env !== 'development') {
  // }
  if (!reload) {
    console.log('config', config);
    //first startup
    console.log('启动-加载所有数据库模型到缓存');
    importDBModelsToCache();
  }
}

/**
 * only trigger when reloading,not trigger when first startup
 */
export function afterLoad(option: {
  action: string;
  ignoredAfterLoad: boolean;
  reload: boolean;
}) {
  console.log('reloading', option);

  // importDBModelsToCache();
}

/**
 * trigger by yao migrate command
 * @param option
 */
export function afterMigrate(option: {
  force: boolean;
  reset: boolean;
  /**production | development */
  mode: string;
}) {
  console.log('afterMigrate', option);
}
