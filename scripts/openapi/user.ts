import { xgenMenu } from '@scripts/admin/menu_node';
import { getUserAuthObjects } from '@scripts/auth/lib';
import { findUser } from '@scripts/user';

import { Process, Exception } from '@yao/yao';

//yao run scripts.openapi.user.getOpenapiUserInfo 'email' 'wwsheng@qq.com'
function getUserInfo(type: string, value: string) {
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
      'user_id',
      'name',
      'password_hash',
      'type',
      'email',
      'mobile',
      'extra',
      'status'
    ],
    wheres: [{ column: supportTypes[type], value: value }],
    limit: 1
  });
  return user;
}
export function CheckOpenApiAccessTokenEnabled() {
  const enabeld = Process('OpenApi.AccessToken.Enabled');
  if (!enabeld) {
    throw new Exception('OpenApi AccessToken is not enabled', 401);
  }
}
/**
 * 自定义一个用户登录的处理器,使用用户名密码登录，不需要验证码
 *
 * yao run scripts.openapi.user.OpenApiLogin
 *
 * @param {object} payload 用户登录信息
 * @returns 返回登录信息
 */
export function OpenApiLogin(payload: {
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

  console.log('payload', payload);

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
  }
  try {
    const passwordValid = Process(
      'utils.pwd.Verify',
      password,
      user.password_hash
    );
    if (passwordValid !== true) {
      throw new Exception('密码不正确!', 401);
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

  // const jwtOptions = {
  //   timeout: TIMEOUT,
  //   sid: sessionId
  // };

  const jwtClaims = { user_name: user.name };
  // 需要注意的是在这里无法生成studio的token,因为这个处理器只接受3个参数，
  // 而生成studio的token需要在第4个参数里传入secretkey
  // const jwt = Process('utils.jwt.Make', user.id, jwtClaims, jwtOptions);

  const accessToken = Process(
    'OpenApi.AccessToken.Make',
    user.user_id,
    TIMEOUT,
    [],
    jwtClaims
  );

  Process('session.set', 'user', userData, TIMEOUT, sessionId);
  Process('session.set', 'token', accessToken, TIMEOUT, sessionId);
  Process('session.set', 'user_id', user.id, TIMEOUT, sessionId);

  // 设置权限缓存
  const userAuthObject = getUserAuthObjects(user.user_id);
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
    menus: xgenMenu(),
    token: accessToken,
    expires_at: Date.now() + TIMEOUT * 1000
  };
}

/**
 * 获取用户信息
 * // yao run scripts.openapi.user.Info
 * @returns 包含用户ID、用户名和用户角色的对象
 */
export function Info() {
  const user = findUser();

  return {
    userId: user.id,
    userName: user.name,
    userRole: user.type || 'user'
  };
}

/**
 * 这是一个用户验证函数。首先，根据用户名获取用户信息。如果用户不存在，返回错误消息和代码500。
 * 然后，尝试使用提供的密码进行验证。如果密码不正确，捕获错误并返回错误消息和代码500。
 * 如果一切正常，返回验证通过的消息、代码200和用户的id。
 *
 * yao run scripts.openapi.user.OpenapiUserVerify
 *
 * @param {String} userName - 需要验证的用户名。
 * @param {String} password - 用户提供的密码。
 * @return {Object} 返回一个对象，包含消息（message）、代码（code）和用户id（user_id）。如果用户不存在或密码不正确，消息将描述错误，代码为500；如果验证通过，消息为"验证通过"，代码为200，并包含用户的id。
 */
export function UserVerify(userName, password) {
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
 * yao run scripts.openapi.user.TokenRefresh
 */
export function TokenRefresh() {
  const TIMEOUT = 60 * 60 * 8;

  const userData = Process('session.Get', 'user');
  delete userData.password_hash;

  const jwtClaims = { user_name: userData.name };

  const user_id = userData.user_id;
  const sessionId = Process('session.ID');
  // const jwt = Process('utils.jwt.Make', user_id, jwtClaims, {
  //   timeout: TIMEOUT,
  //   sid: sessionId
  // });
  const accessToken = Process(
    'OpenApi.AccessToken.Make',
    user_id,
    TIMEOUT,
    [],
    jwtClaims
  );

  // 更新 Session
  Process('session.Set', 'user_id', user_id, TIMEOUT, sessionId);
  Process('session.Set', 'user', userData, TIMEOUT, sessionId);
  Process('session.set', 'token', accessToken, TIMEOUT, sessionId);

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
    token: accessToken,
    expires_at: Date.now() + TIMEOUT * 1000
  };
}
