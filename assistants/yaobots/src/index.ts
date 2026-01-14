import { agent } from '@yao/runtime';

/**
 * Initialize the assistant session
 *
 * @param ctx Context
 */
function Create(
  ctx: agent.Context,
  messages: agent.Message[]
): agent.CreateHookResponse {
  return null;
}

/**
 * Next step
 *
 * @param ctx Context
 * @param payload Payload
 */
function Next(
  ctx: agent.Context,
  payload: agent.NextHookPayload
): agent.NextHookResponse {
  //返回null,不干预ai处理流程
  return null;
}
