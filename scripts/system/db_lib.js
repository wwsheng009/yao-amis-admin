const { IsMysql } = Require("amis.lib_tool");

function RunTransaction(fun, ...args) {
  const t = new Query();
  const ismysql = IsMysql();
  if (ismysql) {
    t.Run({
      sql: {
        stmt: "START TRANSACTION;",
      },
    });
  }

  try {
    // var firstParam = Array.prototype.shift.call(arguments);
    const ret = fun(...args);

    if (ismysql) {
      t.Run({
        sql: {
          stmt: "COMMIT;",
        },
      });
    }
    return ret;
  } catch (error) {
    if (ismysql) {
      t.Run({
        sql: {
          stmt: "ROLLBACK;",
        },
      });
    }
    throw error;
  }
}
module.exports = {
  RunTransaction,
};
