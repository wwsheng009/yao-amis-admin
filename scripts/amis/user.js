/**
 * 自定义一个用户登录的处理器,使用用户名密码登录，不需要验证码
 * yao run scripts.amis.user.Login
 * @param {object} payload 用户登录信息
 * @returns 返回登录信息
 */
function Login(payload) {
  if (payload.captcha && typeof captcha === "object") {
    const captcha = Process(
      "yao.utils.CaptchaValidate",
      payload.captcha.id,
      payload.captcha.code
    );
    if (captcha !== true) {
      throw new Exception("验证码不正确!", 400);
    }
  }

  let { username, password, userName } = payload;

  username = username || userName;

  const q = new Query();
  const user = q.First({
    // debug: true,
    select: [
      "id",
      "name",
      "password",
      "type",
      "email",
      "mobile",
      "extra",
      "status",
    ],
    wheres: [
      {
        field: "name",
        value: username,
      },
      { or: true, field: "email", value: username },
    ],
    from: "$admin.user",
    limit: 1,
  });
  // 或是使用处理器
  // const [user] = Process("models.admin.user.get", {
  //   wheres: [
  //     { column: "mobile", value: account },
  //     { column: "status", value: "启用" },
  //     { method: "orwhere", column: "email", value: account },
  //   ],
  //   limit: 1,
  // });

  if (!user) {
    return Process("scripts.return.Error", "", "400", "用户不存在");
  }

  try {
    const password_validate = Process(
      "utils.pwd.Verify",
      password,
      user.password
    );
    if (password_validate !== true) {
      return Process("scripts.return.Error", "", "400", "密码不正确");
    }
  } catch (error) {
    return Process("scripts.return.Error", "", "400", "密码不正确");
  }
  const timeout = 60 * 60;
  const sessionId = Process("utils.str.UUID");
  let userPayload = { ...user };
  delete userPayload.password;
  const jwtOptions = {
    timeout: timeout,
    sid: sessionId,
  };
  const jwtClaims = { user_name: user.name };
  //需要注意的是在这里无法生成studio的token,因为这个处理器只接受3个参数，
  //而生成studio的token需要在第4个参数里传入secretkey
  const jwt = Process("utils.jwt.Make", user.id, jwtClaims, jwtOptions);
  Process("session.set", "user", userPayload, timeout, sessionId);
  Process("session.set", "token", jwt.token, timeout, sessionId);
  Process("session.set", "user_id", user.id, timeout, sessionId);

  return Process("scripts.return.Success", {
    sid: sessionId,
    user: userPayload,
    menus: Process("scripts.system.menu.xgenMenu"),
    token: jwt.token,
    expires_at: jwt.expires_at,
  });
}

// yao run scripts.amis.user.Info
function Info() {
  let user_id = Process("session.get", "user_id");
  let user = Process("session.get", "user");

  return {
    userId: user_id,
    userName: user.name,
    userRole: "admin",
  };
}
