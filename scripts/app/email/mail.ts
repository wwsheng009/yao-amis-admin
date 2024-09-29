import { EmailMessage, EmailPluginResponse } from '@yao/email';
import { Process } from '@yao/yao';

interface app_email_message {
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
}

/**
 * trig by the table after:save hook
 * @param id message id
 * @returns
 */
export function afterSave(id: number) {
  const account = Process('models.app.email.server.find', 1, {});

  const message = Process(
    'models.app.email.message.find',
    id,
    {}
  ) as app_email_message;

  const res = send(message, account);
  if (res.code == 200) {
    Process('models.app.email.message.update', id, {
      status: 'sent',
      sent_at: CurrentTime()
    });
  } else {
    Process('models.app.email.message.update', id, {
      status: 'failed'
    });
  }
  console.log('afterSave', id);
  return id;
}

function send(emailMessage: app_email_message, account: any) {
  // const username =
  //   account.username || Process('utils.env.Get', 'EMAIL_USERNAME');
  // const password =
  //   account.password || Process('utils.env.Get', 'EMAIL_PASSWORD');

  // const to = Process('utils.env.Get', 'EMAIL_TO');
  const cc = emailMessage.cc.split(',')?.map((c) => {
    return { name: '', address: c };
  });

  const to = emailMessage.receiver.split(',')?.map((c) => {
    return { name: '', address: c };
  });
  const message = {
    // account: {
    //   server: 'smtp.qq.com',
    //   port: 587,
    //   username: username,
    //   password: password,
    //   type: 'stmp'
    // },
    account: {
      ...account
    },
    messages: [
      {
        from: emailMessage.sender,
        to: to, //[{ address: to }, { name: 'vincent1', address: to }],
        cc: cc, //[{ address: username }],
        subject: emailMessage.subject,
        body: emailMessage.content,
        attachments: []
      }
    ]
  } as EmailMessage;
  return Process('plugins.email.send', message) as EmailPluginResponse;
}

function CurrentTime() {
  const date = new Date();
  // utc时间整时区
  const newDate = new Date(
    date.getTime() + date.getTimezoneOffset() * 60 * 1000
  );
  const offset = date.getTimezoneOffset() / 60;
  const hours = date.getHours();
  newDate.setHours(hours - offset);
  return newDate.toISOString().slice(0, 19).replace('T', ' ');
  // return dateObj.toISOString().slice(0, 19).replace(/-/g, "/").replace("T", " ");
}
