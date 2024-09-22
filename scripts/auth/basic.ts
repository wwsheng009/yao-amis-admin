import { Process, Exception, Query } from '@yao/yao';

/**
 * 验证用户身份，使用Basic方法，即是用户名密码的登录方式
 *
 * use in api guard,scripts.auth.basic.Check
 * @param {string} path api path
 * @param {map} params api path params
 * @param {map} queries api queries in url query string
 * @param {object|string} payload json object or string
 * @param {map} headers request headers
 */
function Check(path, params, queries, payload, headers) {
  checkBasicAuth(headers);
}
/**
 * check user authorization using user password
 * @param {object} headers
 * @returns
 */
function checkBasicAuth(headers) {
  const auth = headers['Authorization']?.[0];

  if (auth && auth.startsWith('Basic ')) {
    const base64 = auth.substring('Basic '.length);
    const [userName, password] = Process(
      'encoding.base64.Decode',
      base64
    ).split(':');

    const result = Process('scripts.amis.user.userVerify', userName, password);

    if (result.code === 200) {
      return;
    }
  }
  throw new Exception('Not Authorized', 403);
}
