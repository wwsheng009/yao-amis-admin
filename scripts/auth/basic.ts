import { Process, Exception } from '@yao/yao';

/**
 * Verifies user identity using Basic Auth (username and password).
 *
 * Used in API guard, scripts.auth.basic.Check
 * @param {string} path - API path
 * @param {Record<string, any>} params - API path parameters
 * @param {Record<string, any>} queries - API query parameters
 * @param {object | string} payload - JSON object or string
 * @param {Record<string, string[]>} headers - Request headers
 */
export function Check(
  path: string,
  params: Record<string, string[]>,
  queries: Record<string, string[]>,
  payload: object | string,
  headers: Record<string, string[]>
) {
  checkBasicAuth(headers);
}
/**
 * Checks user authorization using Basic Auth (username and password).
 * @param {Record<string, string[]>} headers - Request headers containing the Authorization header.
 * @throws {Exception} Throws a 403 Exception if authorization fails.
 */

export function checkBasicAuth(headers: Record<string, string[]>): void {
  const authHeader = headers['Authorization']?.[0];

  if (!authHeader || !authHeader.startsWith('Basic ')) {
    throw new Exception('Not Authorized', 403);
  }

  const base64Credentials = authHeader.substring('Basic '.length);
  const decodedCredentials = Process(
    'encoding.base64.Decode',
    base64Credentials
  );
  const [userName, password] = decodedCredentials.split(':');

  if (!userName || !password) {
    throw new Exception('Invalid credentials format', 403);
  }

  const result = Process('scripts.amis.user.userVerify', userName, password);

  if (result.code !== 200) {
    throw new Exception('Not Authorized', 403);
  }
}
