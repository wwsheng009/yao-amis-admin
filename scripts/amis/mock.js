//查找数据
function samples(page, pagesize, keywords) {
  let data = Process("yao.table.Search", "demo.table", null, page, pagesize);
  return Process("scripts.return.Success", {
    items: data.data,
    total: data.total,
  });
}
//表数据预览，可以用于amis curd控件的api接口测试
// yao scripts.amis.mock.tableData
function tableData(table) {
  let data = Process("yao.table.Get", table);

  return Process("scripts.return.Success", data);
}
//根据id获取记录
function getSample(id) {
  let data = Process("yao.table.Find", "demo.table", id);

  return Process("scripts.return.Success", data);
}
//保存记录
function saveSample(id, payload) {
  Process("yao.table.Save", "demo.table", payload);
}
//创建新记录
function newSample(payload) {
  Process("yao.table.Save", "demo.table", payload);
}
//删除记录，支持单条或是批量
function deleteSample(ids) {
  let myArray = ids.split(",");
  myArray &&
    myArray.forEach((id) => {
      Process("yao.table.Delete", "demo.table", id);
    });
}
//批量更新数据
function bulkUpdateSample(ids, payload) {
  let myArray = ids.split(",");
  myArray &&
    myArray.forEach((id) => {
      Process("yao.table.Update", "demo.table", id, payload);
    });
}
