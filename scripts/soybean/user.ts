import { Exception, Process } from '@yaoapps/client';

/**
 * 获取用户信息
 * // yao run scripts.soybean.user.userInfo
 * @returns 包含用户ID、用户名和用户角色的对象
 */
export function userInfo() {
  const user_id = Process('session.get', 'user_id');
  const user = Process('session.get', 'user');

  if (!user_id || !user) {
    throw new Exception('用户未登录', 401);
  }
  return {
    userId: user_id,
    userName: user.name,
    roels: [user.type || 'user'],
    buttons: []
  };
}
