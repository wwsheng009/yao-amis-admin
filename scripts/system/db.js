
/**
 * clean the table content directly,use it carefully
 * 
 * yao run scripts.system.db.cleanTable system.font
 * @param {string} tableName 
 * @returns 
 */
function cleanTable(tableName) {
  
  const query = new Query("default");
  //use statement
  const data = query.Run({
    sql: { stmt: `delete from ${tableName}` },
  });
  return data;
}
