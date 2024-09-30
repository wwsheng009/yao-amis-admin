import {
  app_email_account,
  app_email_message,
  EmailMessage,
  EmailPluginResponse,
  MessageReceived
} from '@yao/email';
import { Exception, FS, Process } from '@yao/yao';
import { YaoQueryParam } from '@yaoapps/types';

const uploadFolder = 'data/upload/emails';

export function getSendAccount(): app_email_account {
  let [account] = Process('models.app.email.account.get', {
    wheres: [
      {
        column: 'category',
        value: 'send'
      }
    ],
    limit: 1
  } as YaoQueryParam.QueryParam) as app_email_account[];

  if (!account) {
    const envs = Process(
      'utils.env.GetMany',
      'EMAIL_SEND_SERVER',
      'EMAIL_SEND_PORT',
      'EMAIL_SEND_USERNAME',
      'EMAIL_SEND_PROTOCAL',
      'EMAIL_SEND_PASSWORD'
    );
    if (Object.values(envs).every((x) => x == '')) {
      return null;
    }
    account = {
      server: envs['EMAIL_SEND_SERVER'],
      port: Number(envs['EMAIL_SEND_PORT']) || 587,
      username: envs['EMAIL_SEND_USERNAME'],
      type: envs['EMAIL_SEND_PROTOCAL'] || 'smtp',
      password: envs['EMAIL_SEND_PASSWORD']
    };
  }
  return account;
}

export function getReceiveAccount(): app_email_account {
  let [account] = Process('models.app.email.account.get', {
    wheres: [
      {
        column: 'category',
        value: 'receive'
      }
    ],
    limit: 1
  } as YaoQueryParam.QueryParam) as app_email_account[];

  if (!account) {
    const envs = Process(
      'utils.env.GetMany',
      'EMAIL_RECEIVE_SERVER',
      'EMAIL_RECEIVE_PORT',
      'EMAIL_RECEIVE_USERNAME',
      'EMAIL_RECEIVE_PROTOCAL',
      'EMAIL_RECEIVE_PASSWORD'
    );
    if (Object.values(envs).every((x) => x == '')) {
      return null;
    }
    account = {
      server: envs['EMAIL_RECEIVE_SERVER'],
      port: Number(envs['EMAIL_RECEIVE_PORT']) || 993,
      username: envs['EMAIL_RECEIVE_USERNAME'],
      type: envs['EMAIL_RECEIVE_PROTOCAL'] || 'imap',
      password: envs['EMAIL_RECEIVE_PASSWORD']
    };
  }
  return account;
}
/**
 * yao run scripts.app.email.client.checkEmailAccount
 */
export function checkEmailAccount() {
  const accounts = [getSendAccount(), getReceiveAccount()].filter((c) => !!c);
  if (accounts.length <= 1) {
    Process('schedules.email.stop');
    console.log(`邮件账户未配置,请配置发送与接收邮件的账号`);
    return false;
  }
  return true;
}
/**
 * yao run scripts.app.email.client.deleteMessageFolder
 * @param id message id
 * @returns
 */
export function deleteMessageFolder(id: number | string) {
  const message = Process(
    'models.app.email.message.find',
    Number(id),
    {}
  ) as app_email_message;

  if (message == null || !message.attachment_folder) {
    console.log('消息不存在', message);
    return;
  }
  const folder = message.attachment_folder.replace('data', '');
  const fs = new FS('system');
  const exist = fs.Exists(folder);
  if (exist) {
    fs.RemoveAll(folder);
  }
}

export function sendEmail(emailMessage: app_email_message, account: any) {
  console.log('开始发送邮件');

  const cc =
    Array.isArray(emailMessage.cc) && emailMessage.cc?.length
      ? emailMessage.cc.split(',')?.map((c) => {
          return { Name: '', Address: c };
        })
      : undefined;
  const to =
    Array.isArray(emailMessage.receiver) &&
    emailMessage.receiver?.split(',')?.map((c) => {
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
  const resp = Process('plugins.email.send', message) as EmailPluginResponse;
  if (resp.code !== 200) {
    console.log(`邮件发送失败` + resp.message);
  } else {
    console.log(`邮件发送成功` + resp.message);
  }
  return { code: resp.code, message: resp.message };
}
export function sendMessage(id: number) {
  const account = getSendAccount();
  if (!account) {
    throw new Exception(`发送邮件的账户未配置`);
  }
  const message = Process(
    'models.app.email.message.find',
    id,
    {}
  ) as app_email_message;
  const sender = message?.sender as unknown as {
    Name?: string;
    Address: string;
  };
  if (typeof sender != 'object' || !sender?.Address) {
    console.log('发送者信息不正确');
    return;
  }
  const res = sendEmail(message, account);
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
  }
  return id;
}
/**
 * yao run scripts.app.email.client.receiveEmail
 *
 * yao run schedules.mail.start
 *
 * yao run tasks.email.add()
 *
 * yao run tasks.email.get(1)
 */
export function receiveEmail() {
  console.log('开始接收邮件');
  const account = getReceiveAccount();
  if (!account) {
    throw new Exception(`接收邮件的账户未配置`);
  }
  const message = {
    account: {
      ...account
    },
    folder: uploadFolder
  } as EmailMessage;
  const res = Process('plugins.email.receive', message) as EmailPluginResponse;
  if (res.code == 200) {
    saveReceivedEmails(res.emails);
  } else {
    throw new Exception(`邮件收取失败${res.message}`);
    // console.log(`邮件收取失败` + res.message);
  }
  return { code: res.code, message: res.message };
}
/**
 * yao run scripts.app.email.client.saveReceivedEmails
 * @param emails
 */
function saveReceivedEmails(emails: MessageReceived[]) {
  if (!emails) {
    console.log('邮件还没收到');
    return;
    // const fs = new FS('system');
    // const data = fs.ReadFile('/upload/email.json');
    // const res = JSON.parse(data);
    // emails = res.emails;
  }
  if (!Array.isArray(emails) || !emails.length) {
    console.log('邮件还没收到');
    return;
  }
  emails.forEach((mail) => {
    const record = decodeMessage(mail);
    if (record) {
      record.status = 'received';
      record.received_at = CurrentTime();
      const [item] = Process('models.app.email.message.get', {
        limit: 1,
        wheres: [{ column: 'message_id', value: record.message_id }]
      } as YaoQueryParam.QueryParam);
      if (!item) {
        const id = Process('models.app.email.message.create', record);
        if (!id) {
          console.log('保存邮件失败！');
        }
      } else {
        record.id = item.id;
        Process('models.app.email.message.save', record);
      }
      console.log('邮件保存成功:' + record.subject);
    }
  });
}
/**
 * yao run scripts.app.email.client.decodeMessage
 * @param emails
 * @returns
 */
function decodeMessage(email: MessageReceived) {
  if (!email) {
    return null;
  }
  // console.log('email', email);
  const message = {} as any;
  message.type = 'in';
  message.sender = email.from; //发件人
  message.receiver = email.to; //
  message.subject = email.subject; //主题

  message.date = email.date;
  message.message_id = email.message_id;
  message.uid = email.uid;

  message.error = email.error;
  if (message.error) {
    return message;
  }

  const text = email.body?.find((b) => b.content_type == 'text/plain');
  message.plain_text = text?.centent;
  // if (text?.content_type_value['charset'].toLowerCase() != 'utf-8') {
  // }
  const html = email.body?.find((b) => b.content_type == 'text/html');
  message.content = html?.centent;
  // if (html?.content_type_value['charset'].toLowerCase() != 'utf-8') {
  // }
  if (message.plain_text == message.content) {
    message.plain_text = '';
  }

  const attachments = email.body?.filter((b) => !!b.saved_file_name) || [];
  const attachmentList = [];

  attachments.forEach((a) => {
    const attachment = {} as any;
    // attachment.content_id = a.content_id;
    attachment.content_type = a.content_type;
    attachment.saved_file_name = a.saved_file_name;
    // attachment.saved_file_path = a.saved_file_path;
    attachment.category = a.disposition; //inline嵌入或是附件
    attachment.filename = a.disposition_value['filename'] || a.attachment;
    attachment.encoding = a.encoding;
    const filePath = a.saved_file_path.replace(uploadFolder, '');
    attachment.download_url = `/api/v1/fs/email/file/download?name=${filePath}`;
    if (a.disposition == 'inline') {
      //replace the cid in html and text
      if (message.content) {
        message.content = message.content.replace(
          `cid:${a.content_id}`,
          attachment.download_url
        );
      }
    }
    attachmentList.push(attachment);
  });
  if (attachmentList.length) {
    // 附件列表
    message.attachments = email.attachments;
    message.attachment_folder = email.folder;
    // 附件清细
    message.attachment_details = attachmentList;
  }

  return message;
}
// decodeMessage();
export function CurrentTime() {
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
