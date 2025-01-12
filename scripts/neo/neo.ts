import { io, neo } from '@yao/yao';

/**
 * Neo Prepare hook
 */
export function Prepare(
  ctx: neo.Context,
  messages: neo.Message[]
): neo.Message[] {
  //不再使用，使用assistant代替
  return messages;
}

export function Create(
  ctx: neo.Context,
  messages: neo.Message[],
  writer: io.ResponseWriter
) {
  //console.log('messages', messages);
  //check messages contains the item role = 'system'
  // let hasSystem = false;
  // for (const message of messages) {
  //   if (message.role === 'system') {
  //     hasSystem = true;
  //     break;
  //   }
  // }
  // if (!hasSystem || ctx.assistant_id === '') {
  //   ctx.assistant_id = 'model';
  // }
  //console.log('writer', writer);
  //update the ctx.assistant_id
  return { assistant_id: ctx.assistant_id, chat_id: ctx.chat_id };
}

/**
 * Neo Write hook
 */
export function Write(
  ctx: neo.Context,
  messages: neo.Message[],
  response: neo.Response,
  content?: string,
  writer?: io.ResponseWriter
): neo.Response[] {
  console.log('content', content);
  console.log('writer', writer);
  return [response];
}
