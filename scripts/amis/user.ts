import { getUserAuthObjects } from '@scripts/auth/lib';

import { Process, Exception } from '@yao/yao';

function getUserInfo(type, value) {
  const supportTypes = {
    email: 'email',
    mobile: 'mobile',
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
      'status',
    ],
    wheres: [
      { column: supportTypes[type], value: value },
      { Column: 'status', Value: 'enabled' },
    ],
    limit: 1,
  });
  return user;
}
/**
 * 自定义一个用户登录的处理器,使用用户名密码登录，不需要验证码
 * yao run scripts.amis.user.Login
 * @param {object} payload 用户登录信息
 * @returns 返回登录信息
 */
function Login(payload) {
  if (payload.captcha && typeof payload.captcha === 'object') {
    const captcha = Process(
      'yao.utils.CaptchaValidate',
      payload.captcha.id,
      payload.captcha.code,
    );
    if (captcha !== true) {
      throw new Exception('验证码不正确!', 400);
    }
  }

  const { password, email, mobile, userName } = payload;

  let user = null;
  if (email != null) {
    user = getUserInfo('email', email);
  } else if (mobile != null) {
    user = getUserInfo('mobile', email);
  } else if (userName != null) {
    user = getUserInfo('email', userName);
  }
  if (!user) {
    return Process('scripts.return.RError', '', 400, '用户不存在');
  }
  try {
    const password_validate = Process(
      'utils.pwd.Verify',
      password,
      user.password,
    );
    if (password_validate !== true) {
      return Process('scripts.return.RError', '', 400, '密码不正确');
    }
  } catch (error) {
    return Process('scripts.return.RError', '', 400, '密码不正确');
  }
  const timeout = 60 * 60 * 8;
  const sessionId = Process('utils.str.UUID');
  const userPayload = { ...user };
  delete userPayload.password;
  const jwtOptions = {
    timeout: timeout,
    sid: sessionId,
  };
  const jwtClaims = { user_name: user.name };
  // 需要注意的是在这里无法生成studio的token,因为这个处理器只接受3个参数，
  // 而生成studio的token需要在第4个参数里传入secretkey
  const jwt = Process('utils.jwt.Make', user.id, jwtClaims, jwtOptions);
  Process('session.set', 'user', userPayload, timeout, sessionId);
  Process('session.set', 'token', jwt.token, timeout, sessionId);
  Process('session.set', 'user_id', user.id, timeout, sessionId);

  // 设置权限缓存
  const userAuthObject = getUserAuthObjects(user.id);
  Process(
    'session.set',
    'user_auth_objects',
    userAuthObject,
    timeout,
    sessionId,
  );

  return Process('scripts.return.RSuccess', {
    sid: sessionId,
    user: userPayload,
    menus: Process('scripts.admin.menu_node.xgenMenu'),
    token: jwt.token,
    expires_at: jwt.expires_at,
  });
}

// yao run scripts.amis.user.Info
function Info() {
  const user_id = Process('session.get', 'user_id');
  const user = Process('session.get', 'user');

  return {
    userId: user_id,
    userName: user.name,
    userRole: user.type || 'user',
  };
}

// yao run scripts.amis.user.userVerify
function userVerify(userName, password) {
  const user = getUserInfo('email', userName);

  if (!user) {
    return { message: '用户不存在', code: 500 };
  }
  try {
    Process('utils.pwd.Verify', password, user.password);
  } catch (error) {
    return { message: '密码不正确', code: 500 };
  }
  return { message: '验证通过', code: 200, user_id: user.id };
}
