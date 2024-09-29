/**
 * Email Message for email plugin
 */
export interface EmailMessage {
  /** email server config */
  account: {
    server: string;
    /** email server port */
    port: number;
    username: string;
    password: string;
    /** stmp for send email,imap for receive email*/
    type: 'stmp' | 'imap';
  };
  /** messages for send */
  messages?: {
    from: string;
    to: {
      Name?: string;
      Address: string;
    }[];
    cc?: {
      Name?: string;
      Address: string;
    }[];
    subject: string;
    body: string;
    /** attachment file path */
    attachments?: string[];
  }[];
  folder?: string;
}

export interface app_email_message {
  /**ID */
  id?: number;
  /**发件人 */
  sender: string;
  /**收件人 */
  receiver: string;
  /**抄送者 */
  cc?: string;
  /**主题 */
  subject: string;
  /**内容 */
  content?: string;
  /**状态 */
  status?: 'sent' | 'received' | 'failed';
  /**发送时间 */
  sent_at?: Date;

  send_log?: string;
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
  date: Date; // Use JavaScript's Date object for timestamps
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
