function test() {
  let tableName = "stockcode";
  const wheres = [];
  if (tableName) {
    wheres.push({ column: "table_name", value: tableName });
    wheres.push({ method: "orwhere", column: "name", value: tableName });
  } else {
    wheres.push({ method: "where", column: "name", value: tableName });
  }

  const [line] = Process("models.ddic.model.get", {
    wheres: wheres,
    with: {},
    limit: 1,
  });

  console.log("id:", line.id);
}
