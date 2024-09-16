import { IsMysql, IsPg } from "@scripts/amis/lib_tool";
import {Process,Query} from '@yao/yao'

/**
 * Run db transaction
 * 
 * support mysql/postgres/sqlite
 * @param {Function} fun 
 * @param  {...any} args 
 * @returns 
 */
export function RunTransaction(fun, ...args) {
  const t = new Query();
  const ismysql = IsMysql();
  const ispg = IsPg();
  if (ismysql) {
    t.Run({
      sql: {
        stmt: "START TRANSACTION;",
      },
    });
  } else if (ispg) {
    t.Run({
      sql: {
        stmt: "BEGIN;",
      },
    });
  }
  try {
    // var firstParam = Array.prototype.shift.call(arguments);
    const ret = fun(...args);

    if (ismysql || ispg) {
      t.Run({
        sql: {
          stmt: "COMMIT;",
        },
      });
    }
    return ret;
  } catch (error) {
    if (ismysql || ispg) {
      t.Run({
        sql: {
          stmt: "ROLLBACK;",
        },
      });
    }
    throw error;
  }
}
// module.exports = {
//   RunTransaction,
// };
