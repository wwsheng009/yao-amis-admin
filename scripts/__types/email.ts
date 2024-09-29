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
}

export interface EmailPluginResponse {
  code: number;
  message: string;
}
