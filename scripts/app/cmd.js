/**
 * yao run scripts.app.cmd.execute
 * @param {object} payload
 */
function execute(payload) {
  //   console.log("payload", payload);
  const hostId = payload.host;
  const hostInfo = Process("models.app.cmd.host.find", hostId, {});

  // save the script
  // Process("models.app.cmd.script.save", payload);
  //   console.log("hostInfo", hostInfo);

  if (!hostInfo.is_remote) {
    let script = payload.source.replace(/^\s*\r/gm, "");
    script = script.replace(/\r/g, ";");
    const result = Process(`plugins.command.${payload.cmd}`, script);
    // console.log("result", result);
    write_log({
      host: hostInfo.host,
      port: hostInfo.port,
      cmd: payload.cmd,
      script: payload.source,
      output: result.data?.output,
      msg: result.msg,
    });
    if (result.error) {
      throw new Exception(result.error, 503);
    }
    return result;
  } else {
    let script = payload.source.replace(/^\s*\r/gm, "");
    script = script.replace(/\r/g, ";");

    let result = null;

    if (hostInfo.ssh_key) {
      // 使用ssh_key使用也需要用户名
      // console.log("hostInfo.username", hostInfo.username);
      // console.log("hostInfo.ssh_key", hostInfo.ssh_key);
      result = Process(
        `plugins.command.remote_key`,
        hostInfo.host,
        hostInfo.port + "",
        hostInfo.username,
        hostInfo.ssh_key,
        script
      );
    } else {
      // console.log("script:", script);
      result = Process(
        `plugins.command.remote`,
        hostInfo.host,
        hostInfo.port + "",
        hostInfo.username,
        hostInfo.password,
        script
      );
    }

    // console.log("remote excute result", result);
    write_log({
      host: hostInfo.host,
      port: hostInfo.port,
      script: payload.source,
      output: result.data?.output,
      msg: result.msg,
    });
    if (result.error) {
      throw new Exception(result.error, 503);
    }
    return result;
  }
}

function write_log(data) {
  let user_id = Process("session.get", "user_id");
  let user = Process("session.get", "user");
  data.user_id = user_id;
  data.user_name = user.name;
  data.user_id = Process("models.app.cmd.log.save", data);
}
