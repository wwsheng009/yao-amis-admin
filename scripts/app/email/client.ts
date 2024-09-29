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

  send_log?: string;
}

/**
 * trig by the table after:save hook
 * @param id message id
 * @returns
 */
export function afterSave(id: number) {
  const account = Process('models.app.email.account.find', 1, {});

  const message = Process(
    'models.app.email.message.find',
    id,
    {}
  ) as app_email_message;

  const res = send(message, account);
  if (res.code == 200) {
    Process('models.app.email.message.update', id, {
      status: 'sent',
      sent_at: CurrentTime(),
      send_log: res.message
    });
  } else {
    Process('models.app.email.message.update', id, {
      status: 'failed',
      send_log: res.message
    });
    console.log('res.message', res.message);
  }
  console.log('afterSave', id);
  return id;
}

function send(emailMessage: app_email_message, account: any) {
  const cc = emailMessage.cc.length
    ? emailMessage.cc.split(',')?.map((c) => {
        return { Name: '', Address: c };
      })
    : undefined;
  const to = emailMessage.receiver.split(',')?.map((c) => {
    return { Name: '', Address: c };
  });
  const message = {
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

/**
 * yao run scripts.app.email.client.receive
 */
function receive() {
  const account = Process('models.app.email.account.find', 2, {});
  console.log('account', account);
  const message = {
    account: {
      ...account
    }
  } as EmailMessage;
  const res = Process('plugins.email.receive', message) as EmailPluginResponse;
  console.log('email received', res);
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
