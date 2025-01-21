/**
 * Model=> admin.user (用户)
 *
 * Table=> admin_user (用户表)
 */
export interface IAdminUser {
  /**ID */
  id?: number;
  /**类型 */
  type?: 'super' | 'admin' | 'staff' | 'user' | 'robot';
  /**邮箱 */
  email?: string;
  /**手机号 */
  mobile?: string;
  /**登录密码 */
  password?: string;
  /**操作密码 */
  password2nd?: string;
  /**姓名 */
  name?: string;
  /**身份证号码 */
  idcard?: string;
  /**API Key */
  key?: string;
  /**API 密钥 */
  secret?: string;
  /**扩展信息 */
  extra?: any;
  /**地区 */
  location?: string;
  /**角色 */
  role?: any;
  /**状态 */
  status?: 'enabled' | 'disabled';
  /**删除时间 */
  deleted_at?: Date;
  /**创建时间 */
  created_at?: Date;
  /**更新时间 */
  updated_at?: Date;
}
