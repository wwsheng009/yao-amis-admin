// 使用命令插件调用操作系统的功能，引功能需要command插件的支持
// 命令插件支持调用本地系统的命令，或是通过ssh在远程服务器上执行命令
// https://github.com/wwsheng009/yao-amis-admin
import { findUser } from '@scripts/user';
import { Process, Exception, Query } from '@yao/yao';

/**
 * yao run scripts.app.cmd.execute
 * @param {object} payload
 */
export function execute(payload) {
  //   console.log("payload", payload);
  const hostId = payload.host;
  const hostInfo = Process('models.app.cmd.host.find', hostId, {});

  if (!hostInfo.is_remote) {
    let script = payload.source.replace(/^\s*\r/gm, '');
    script = script.replace(/\r/g, ';');
    const result = Process(`plugins.command.${payload.cmd}`, script);
    // console.log("result", result);
    writeCommandlog({
      host: hostInfo.host,
      port: hostInfo.port,
      cmd: payload.cmd,
      script: payload.source,
      output: result.data?.output,
      msg: result.msg
    });
    if (result.error) {
      throw new Exception(result.error, 503);
    }
    if (result.status !== 0) {
      throw new Exception(result.msg, 503);
    }
    return result;
  } else {
    let script = payload.source.replace(/^\s*\r/gm, '');
    script = script.replace(/\r/g, ';');

    let result = null;

    if (hostInfo.ssh_key) {
      // 使用ssh_key使用也需要用户名
      result = Process(
        `plugins.command.remote_key`,
        hostInfo.host,
        hostInfo.port + '',
        hostInfo.username,
        hostInfo.ssh_key,
        script
      );
    } else {
      result = Process(
        `plugins.command.remote`,
        hostInfo.host,
        hostInfo.port + '',
        hostInfo.username,
        hostInfo.password,
        script
      );
    }

    writeCommandlog({
      host: hostInfo.host,
      port: hostInfo.port,
      script: payload.source,
      output: result.data?.output,
      msg: result.msg
    });
    if (result.error) {
      throw new Exception(result.error, 503);
    }
    if (result.status !== 0) {
      throw new Exception(result.msg, 503);
    }
    return result;
  }
}
/**
 * write the command excute log into database
 *
 * @param {object} data
 */
function writeCommandlog(data) {
  const user_id = findUser()?.user_id;
  // const user_id = Process('session.get', 'user_id');
  const user = findUser()?.user_id;
  if (!user_id) {
    throw new Exception('请登录系统', 401);
  }
  data.user_id = user_id;
  data.user_name = user.name;
  data.user_id = Process('models.app.cmd.log.save', data);
}
