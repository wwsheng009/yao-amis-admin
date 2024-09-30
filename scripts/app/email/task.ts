import { Process } from '@yao/yao';

/**
 * OnAdd add event
 * @param {number} id 任务id
 */
export function OnAdd(id: number) {
  console.log(`OnAdd: #${id}`);
}

/**
 * OnProgress
 * @param {number} id task id,任务ID
 * @param {number} current
 * @param {number} total
 * @param {string} message
 */
export function OnProgress(
  id: number,
  current: number,
  total: number,
  message: string
) {
  console.log(`OnProgress: #${id} ${message} ${current}/${total} `);
}
/**
 * OnSuccess
 * @param {number} id task id,任务ID
 * @param {any} res
 */
export function OnSuccess(id: number, res: any) {
  console.log(`OnSuccess: #${id} ${JSON.stringify(res)}`);
}
/**
 * OnError
 * @param {number} id task id,任务ID
 * @param {Error} err
 */
export function OnError(id: number, err: Error) {
  console.log(`OnError: #${id} ${err}`);
  Process('schedules.email.stop');
}
