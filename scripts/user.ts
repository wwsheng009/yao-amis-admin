import { Authorized } from '@yao/runtime';
import { Exception, Process } from '@yaoapps/client';

/**
 * yao run scripts.user.findUserInfo
 */
export function findUserInfo(user_id?: string) {
  const user = findUser(user_id);
  if (!user) {
    throw new Exception('User not found', 404);
  }
  return {
    userId: user.user_id,
    userName: user.name,
    roles: [user.role_id || 'guest']
  };
}

/**
 * yao run scripts.user.findUser
 */
export function findUser(user_id) {
  if (!user_id) {
    user_id = Authorized().user_id;
  }
  if (!user_id) {
    return null;
  }

  const [user] = Process('models.admin.user.Get', {
    wheres: [{ column: 'user_id', value: user_id }]
  });
  return user;
}

// export function findUserRole(user_id?: string) {
//   const user = findUser(user_id);
//   return user.role_id || 'guest';
// }

// function finduser_old(user_id) {
//   if (!user_id) {
//     user_id = Process('session.get', 'user_id');
//   }
//   //   let user = Process('scripts.user.findUser');
//   if (!user_id) {
//     throw new Exception('用户未登录', 401);
//   }
//   const user = Process('models.admin.user.find', user_id, {});
//   if (user == null) {
//     throw new Exception('用户不存在', 500);
//   }
//   return user;
// }
