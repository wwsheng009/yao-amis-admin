import { Process } from '@yaoapps/client';

/**
 * 在应用启动时自动加载模型，这个特性需要修改版的yao才支持，非官方功能
 *
 * 功能调整：
 * https://github.com/wwsheng009/yao/commit/52366051044c49fb39f58caccee6a09736870d30
 *
 * yao程序下载：https://github.com/wwsheng009/yao/releases/tag/yao-0.10.4
 *
 * action: 'developement' | 'production' | 'load' | 'reload'
 */
export function startup(config: object, action: string) {
  // 生产环境才自动加载，开发环境，开发人员手动处理
  console.log('startup action:' + action);
  if (action == 'production') {
    initCheck();
    // console.log('config', config);
    console.log('启动-加载所有数据库模型到缓存');

    Process('scripts.system.model.importDBModelsToCache');

    Process('scripts.app.email.client.checkEmailAccount');
  }
}
export function initCheck() {
  if (!Process('schemas.default.tableexists', 'ddic_model')) {
    console.log('初始化系统模型：ddic.model/ddic.model.column');
    Process('models.ddic.model.migrate');
    Process('models.ddic.model.column.migrate');
    // return;
  }
  //检查邮件配置
  if (!Process('schemas.default.tableexists', 'app_email_account')) {
    console.log('初始化邮件配置模型:app.email.client');
    Process('models.app.email.account.migrate');
  }
  if (!Process('schemas.default.tableexists', 'app_email_message')) {
    console.log('初始化邮件消息模型:app.email.message');
    Process('models.app.email.message.migrate');
  }

  if (!Process('schemas.default.tableexists', 'system_amis_page')) {
    console.log('初始化Amis页面配置表:system.amis.page');
    Process('models.system.amis.page.migrate');
  }
}

/**
 * only trigger when reloading,not trigger when first startup
 */
export function afterLoad(option: {
  action: string; //run | watch
  ignoredAfterLoad: boolean;
  reload: boolean;
}) {
  console.log('reloading:' + JSON.stringify(option));

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
  console.log('afterMigrate:' + JSON.stringify(option));
}
