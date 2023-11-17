// yao run scripts.system.model.testUndefined
function testUndefined() {
  let model = {};
  // 经过go转换的undefined会变成0。
  // 不要使用==null的判断，而且是使用===null and === undefined
  console.log("model is undefined", model.xxxx === undefined);
  console.log("model is null", model.xxxx === null);
  console.log("model is null or undefined", model.xxxx == null);
  console.log("model is 0", model.xxxx === 0);
  console.log("model.xxxx", model.xxx); //总是输出0
  return;
}

//yao run scripts.system.test.test
function test() {
  const tableName = "system_test";
  const data = Process(
    "models.ddic.model.Paginate",
    {
      wheres: [{ column: "table_name", value: tableName }],
      with: {},
    },
    1,
    1
  );
  console.log("data", data);
}

// yao run scripts.system.test.testGetModel 68
function testGetModel(modelId) {
  //根据id在数据库表中查找
  const [model] = Process("models.ddic.model.get", {
    wheres: [
      { column: "name", value: modelId },
      {
        method: "orwhere",
        column: "id",
        value: modelId,
      },
    ],
    withs: {
      columns: {},
    },
  });

  return model;
}

function getModelByidtest(id) {
  Process("scripts.system.model.getModelFromDB", id);
}
function anonymous(data, utils) {
  with (data) {
    console.log("data.type", this.type);
    return !!(data.type != `id`);
  }
}
// anonymous({ type: "id" });

function testModel(modelDsl) {
  modelDsl.table = modelDsl.table || {};
  modelDsl.option = modelDsl.option || {};
  modelDsl.columns = modelDsl.columns || [];
  modelDsl.relations = modelDsl.relations || {};
  console.log(modelDsl);
}
// testModel({});

//yao run scripts.system.test.testReplace
function testReplace() {
  let code = `
  // admin.users模型一定要有以下这此字段，可以根据自己的需求增加其它的字段
  // 没有这些字段会影响yao内置的登录处理器
  // "id", "password", "name", "type", "email", "mobile", "extra", "status"
  //
  // status = enabled/disabled
  // yao migrate -n admin.user --reset
  {
      
  }`;

  let newCode = code.replace(/\/\/.*\n/g, "");
  console.log(newCode);
}
// testReplace();

function testException() {
  throw new Error("hello", 403);
}
testException();
