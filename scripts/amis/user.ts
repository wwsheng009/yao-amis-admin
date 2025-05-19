import { getUserAuthObjects } from '@scripts/auth/lib';

import { Process, Exception } from '@yao/yao';

function getUserInfo(type, value) {
  const supportTypes = {
    email: 'email',
    mobile: 'mobile'
  };
  if (!supportTypes[type]) {
    throw new Exception(`Login type :${type} is not support`);
  }

  const [user] = Process('models.admin.user.get', {
    select: [
      'id',
      'name',
      'password',
      'type',
      'email',
      'mobile',
      'extra',
      'status'
    ],
    wheres: [
      { column: supportTypes[type], value: value },
      { column: 'status', value: 'enabled' }
    ],
    limit: 1
  });
  return user;
}
/**
 * 自定义一个用户登录的处理器,使用用户名密码登录，不需要验证码
 *
 * yao run scripts.amis.user.Login
 *
 * @param {object} payload 用户登录信息
 * @returns 返回登录信息
 */
export function Login(payload: {
  email?: string;
  mobile?: string;
  userName?: string;
  password: string;
  captcha?: { id: string; code: string };
}) {
  if (payload.captcha && typeof payload.captcha === 'object') {
    const captchaValid = Process(
      'yao.utils.CaptchaValidate',
      payload.captcha.id,
      payload.captcha.code
    );
    if (captchaValid !== true) {
      throw new Exception('验证码不正确!', 401);
    }
  }
  const { password, email, mobile, userName } = payload;

  let user = null;
  if (email != null) {
    user = getUserInfo('email', email);
  } else if (mobile != null) {
    user = getUserInfo('mobile', mobile);
  } else if (userName != null) {
    user = getUserInfo('email', userName);
  }

  if (!user) {
    throw new Exception('用户不存在!', 401);
    // return Process('scripts.return.RError', '', 400, '用户不存在');
  }
  try {
    const passwordValid = Process('utils.pwd.Verify', password, user.password);
    if (passwordValid !== true) {
      throw new Exception('密码不正确!', 401);
      // return Process('scripts.return.RError', '', 400, '密码不正确');
    }
  } catch (error) {
    throw new Exception('密码不正确' + error.message, 401);

    // return Process(
    //   'scripts.return.RError',
    //   '',
    //   400,
    //   '密码不正确' + error.message
    // );
  }
  const TIMEOUT = 60 * 60 * 8;
  const sessionId = Process('utils.str.UUID');
  const userData = { ...user };
  delete userData.password;

  const jwtOptions = {
    timeout: TIMEOUT,
    sid: sessionId
  };

  const jwtClaims = { user_name: user.name };
  // 需要注意的是在这里无法生成studio的token,因为这个处理器只接受3个参数，
  // 而生成studio的token需要在第4个参数里传入secretkey
  const jwt = Process('utils.jwt.Make', user.id, jwtClaims, jwtOptions);

  Process('session.set', 'user', userData, TIMEOUT, sessionId);
  Process('session.set', 'token', jwt.token, TIMEOUT, sessionId);
  Process('session.set', 'user_id', user.id, TIMEOUT, sessionId);

  // 设置权限缓存
  const userAuthObject = getUserAuthObjects(user.id);
  Process(
    'session.set',
    'user_auth_objects',
    userAuthObject,
    TIMEOUT,
    sessionId
  );

  return {
    sid: sessionId,
    user: userData,
    menus: Process('scripts.admin.menu_node.xgenMenu'),
    token: jwt.token,
    expires_at: jwt.expires_at
  };
  // return Process('scripts.return.RSuccess', {
  //   sid: sessionId,
  //   user: userData,
  //   menus: Process('scripts.admin.menu_node.xgenMenu'),
  //   token: jwt.token,
  //   expires_at: jwt.expires_at
  // });
}

/**
 * 获取用户信息
 * // yao run scripts.amis.user.Info
 * @returns 包含用户ID、用户名和用户角色的对象
 */
export function Info() {
  const user_id = Process('session.get', 'user_id');
  const user = Process('session.get', 'user');

  return {
    userId: user_id,
    userName: user.name,
    userRole: user.type || 'user'
  };
}

/**
 * 这是一个用户验证函数。首先，根据用户名获取用户信息。如果用户不存在，返回错误消息和代码500。
 * 然后，尝试使用提供的密码进行验证。如果密码不正确，捕获错误并返回错误消息和代码500。
 * 如果一切正常，返回验证通过的消息、代码200和用户的id。
 *
 * yao run scripts.amis.user.userVerify
 *
 * @param {String} userName - 需要验证的用户名。
 * @param {String} password - 用户提供的密码。
 * @return {Object} 返回一个对象，包含消息（message）、代码（code）和用户id（user_id）。如果用户不存在或密码不正确，消息将描述错误，代码为500；如果验证通过，消息为"验证通过"，代码为200，并包含用户的id。
 */
export function userVerify(userName, password) {
  const user = getUserInfo('email', userName);

  if (!user) {
    return { message: '用户不存在', code: 500 };
  }
  try {
    Process('utils.pwd.Verify', password, user.password);
  } catch (error) {
    return { message: '密码不正确' + error.message, code: 500 };
  }
  return { message: '验证通过', code: 200, user_id: user.id };
}

/**
 * 刷新Token
 * yao run scripts.amis.user.TokenRefresh
 */
export function TokenRefresh() {
  const TIMEOUT = 60 * 60 * 8;

  const userData = Process('session.Get', 'user');
  delete userData.password;

  const jwtClaims = { user_name: userData.name };

  const id = userData.id;
  const sessionId = Process('session.ID');
  const jwt = Process('utils.jwt.Make', id, jwtClaims, {
    timeout: TIMEOUT,
    sid: sessionId
  });

  // 更新 Session
  Process('session.Set', 'user_id', id, TIMEOUT, sessionId);
  Process('session.Set', 'user', userData, TIMEOUT, sessionId);
  Process('session.set', 'token', jwt.token, TIMEOUT, sessionId);

  // 设置权限缓存
  const userAuthObject = getUserAuthObjects(userData.id);
  Process(
    'session.set',
    'user_auth_objects',
    userAuthObject,
    TIMEOUT,
    sessionId
  );

  return {
    sid: sessionId,
    user: userData,
    token: jwt.token,
    expires_at: jwt.expires_at
  };
}
