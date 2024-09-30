import { YaoQueryParam } from '@yaoapps/types';
import { deleteMessageFolder, sendMessage } from './client';

export function beforeDelete(id: number | string) {
  // console.log('beforeDelete:' + id);
  deleteMessageFolder(id);
  return [id];
}
export function afterDelete(err: Error) {
  console.log('afterDelete:' + err?.message);
}

/**
 * hook for before the delete of the recoreds
 * @param qeury delete where/in query conditions
 * @returns
 */
export function beforeDeleteIn(qeury: YaoQueryParam.QueryParam) {
  const ids = qeury.wheres[0].value as string[];
  ids.forEach((id) => deleteMessageFolder(id));
  return [qeury];
}
/**
 * hook for the after delete in/where
 * @param affectNumber the delete number of the deleted records
 */
export function afterDeleteIn(affectNumber: number) {
  // console.log('afterDeleteIn:' + affectNumber);
}
/**
 * trigger by the table after:save hook
 * @param id message id
 * @returns
 */
export function afterSave(id: number) {
  sendMessage(id);
}
