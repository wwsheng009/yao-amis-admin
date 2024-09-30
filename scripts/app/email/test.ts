import { EmailMessage } from '@yao/email';
import { Process } from '@yao/yao';

//yao run scripts.app.email.test.send
function send(title: string) {
  const username = Process('utils.env.Get', 'EMAIL_SEND_USERNAME');
  const to = Process('utils.env.Get', 'EMAIL_TO');
  const password = Process('utils.env.Get', 'EMAIL_SEND_PASSWORD');

  const message = {
    account: {
      server: 'smtp.qq.com',
      port: 587,
      username: username,
      password: password,
      type: 'stmp'
    },
    messages: [
      {
        from: username,
        to: [{ Address: to }, { Name: 'vincent1', Address: to }],
        cc: [{ Address: username }],
        subject: title || '小佩奇',
        body: '<h1>新年快乐</h1>',
        attachments: [
          './data/upload/public/20240925/3351df068659b381b93403404e3f1b92.jpeg',
          './data/upload/public/20240928/d8e4992057f9.jpeg'
        ]
      }
    ]
  } as EmailMessage;
  const resp = Process('plugins.email.send', message);
  console.log(resp);
}

//yao run scripts.app.email.test.receive
function receive() {
  const username = Process('utils.env.Get', 'EMAIL_USERNAME');
  const to = Process('utils.env.Get', 'EMAIL_TO');
  const password = Process('utils.env.Get', 'EMAIL_PASSWORD');

  const message = {
    account: {
      server: 'imap.qq.com',
      port: 993,
      username: username,
      password: password,
      type: 'imap'
    }
  } as EmailMessage;
  const resp = Process('plugins.email.receive', message);
  console.log(resp);
}
