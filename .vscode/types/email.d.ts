/**
 * Model=> app.email.account (邮件账号配置)
 *
 * Table=> app_email_account (邮件服务器账号配置表)
 */
export interface app_email_account {
  /**账户类型 */
  category?: 'receive' | 'send';
  /**服务器地址 */
  server?: string;
  /**端口 */
  port?: number;
  /**用户名 */
  username: string;
  /**协议类型 */
  type: 'smtp' | 'imap';
  /**密码 */
  password: string;
}

export interface EmailAddress {
  Name?: string;
  Address: string;
}
export interface EmailMessage {
  from: string;
  to: EmailAddress[];
  cc?: EmailAddress[];
  subject: string;
  body: string;
  /** attachment file path */
  attachments?: string[];
}
export interface EmailAccount {
  server: string;
  /** email server port */
  port: number;
  username: string;
  password: string;
  /** stmp for send email,imap for receive email*/
  type: 'stmp' | 'imap';
}
/**
 * Email Message for email plugin
 */
export interface EmailConfig {
  /** email server config */
  account: EmailAccount;
  /** messages for send */
  messages?: EmailMessage[];
  folder?: string;
}

/**
 * Model=> app.email.message (邮件信息)
 *
 * Table=> app_email_message (邮件发送与接收信息)
 */
export interface app_email_message {
  id: number;
  /**收发类型 */
  type?: string;
  /**发件人 */
  sender: string | object;
  /**收件人 */
  receiver: string | object;
  /**抄送者 */
  cc?: string | object;
  /**主题 */
  subject: string;
  /**内容 */
  content?: string;
  /**纯文本 */
  plain_text?: string;
  /**状态 */
  status?: 'sent' | 'received' | 'failed';
  /**发送时间 */
  send_at?: Date | string;
  /**接收时间 */
  received_at?: Date | string;
  /**邮件发出时间 */
  date?: string;
  /**邮件错误 */
  error?: string;
  /**邮件唯一ID */
  message_id?: string;
  /**用户唯一ID */
  uid?: number;
  /**发送日志 */
  message?: string;
  /**附件目录 */
  attachment_folder?: string;
  /**附件列表 */
  attachments?: string[];
  /**附件明细 */
  attachment_details?: AttachmentDetail[];
}
export interface AttachmentDetail {
  content_type: string;
  saved_file_name: string;
  category: string;
  filename: string;
  encoding: string;
  download_url: string;
}

interface BodyPart {
  content_type: string;
  content_type_value: { [key: string]: string };
  disposition: string;
  disposition_value: { [key: string]: string };
  charset: string;
  file_name: string;
  file_size: number;
  saved_file_name: string;
  saved_file_path: string;
  encoding: string;
  content_id: string;
  centent: string; // Assuming 'centent' is correct, as in Go code
  attachment: string;
}

interface MailAddress {
  Name: string;
  Address: string;
}

export interface MessageReceived {
  from: MailAddress[];
  to: MailAddress[];
  /**主题 */
  subject: string;
  body: BodyPart[];
  attachments?: string[]; // Optional field
  date: string; // Use JavaScript's Date object for timestamps
  error: string;
  message_id: string;
  folder: string;
  uid: number; // For unsigned 32-bit int, TypeScript's 'number' will suffice
}

export interface EmailPluginResponse {
  code: number;
  message?: string;
  emails?: MessageReceived[];
}
