/**
 * yao run scripts.app.cmd.execute
 * @param {object} payload
 */
function execute(payload) {
  //   console.log("payload", payload);
  const hostId = payload.host;
  const hostInfo = Process("models.app.cmd.host.find", hostId, {});
  //   console.log("hostInfo", hostInfo);

  if (!hostInfo.is_remote) {
    const result = Process(`plugins.command.${payload.cmd}`, payload.source);
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
    const result = Process(
      `plugins.command.remote`,
      hostInfo.host,
      hostInfo.port + "",
      hostInfo.username,
      hostInfo.password,
      payload.source
    );
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
