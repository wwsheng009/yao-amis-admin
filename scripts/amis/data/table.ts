// //这里使用table*处理器，table处理器的特点是可以使用table定义中的hook处理器
// const { queryToQueryParam, updateInputData, getArrayItem, mergeQueryObject } =
//   Require("amis.data.lib");

// //查找数据
// //yao run scripts.amis.data.table.Search
// function Search(table, pageIn, perPageIn, querysIn, queryParams, payload) {
//   let querys = mergeQueryObject(querysIn, payload);

//   let page = pageIn;
//   let perPage = perPageIn;
//   if (!page || page == null) {
//     page = getArrayItem(querys, "page") || 1;
//   }
//   if (!perPage || perPage == null) {
//     perPage = getArrayItem(querys, "perPage") || 10;
//   }
//   const queryParam = queryToQueryParam(table, querys, queryParams);

//   let data = Process("yao.table.Search", table, queryParam, page, perPage);
//   return {
//     items: data.data,
//     total: data.total,
//   };
//   // return Process("scripts.return.RSuccess", {
//   //   items: data.data,
//   //   total: data.total,
//   // });
// }
// //表数据预览，可以用于amis curd控件的api接口测试
// function tableData(table) {
//   let data = Process("yao.table.Get", table);
//   // let data = Process(`models.${table}.Get`);
//   return data;
//   // return Process("scripts.return.RSuccess", data);
// }
// //根据id获取记录
// function getData(table, id) {
//   let data = Process("yao.table.Find", table, id);
//   // let data = Process(`models.${table}.Find`, id, {});

//   return data;
//   // return Process("scripts.return.RSuccess", data);
// }

// //保存记录
// //yao run scripts.amis.data.model.saveData
// function saveData(table, payload) {
//   payload = updateInputData(table, payload);
//   Process("yao.table.Save", table, payload);
// }

// //保存记录
// function saveDataById(table, id, payload) {
//   payload.id = id;
//   return table(table, payload);
// }
// //创建新记录
// function saveData(table, payload) {
//   return saveData(table, payload);
// }
// //批量创建新记录
// function newBatchData(table, payload) {
//   payload.batch = updateInputData(table, payload.batch);
//   Process(`models.${table}.eachSave`, payload.batch);
// }

// //删除记录，支持单条或是批量
// function deleteData(table, ids) {
//   let myArray = ids.split(",");
//   myArray &&
//     myArray.forEach((id) => {
//       Process("yao.table.Delete", table, id);
//       // Process(`models.${table}.Delete`, id);
//     });
// }
// //批量更新数据
// function bulkUpdate(table, ids, payload) {
//   let myArray = ids.split(",");
//   myArray &&
//     myArray.forEach((id) => {
//       payload = updateInputData(table, payload);

//       Process("yao.table.Update", table, id, payload);
//       // Process(`models.${table}.Update`, id, payload);
//     });
// }
