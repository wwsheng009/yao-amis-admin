/**
 * 转换图片显示格式
 *
 * scripts.file.upload.View
 * @param data 图片字段设置
 * @returns string[] 数组格式的图片地址
 */
function View(data) {
  if (!data || !data.length) {
    return null;
  }
  if (!Array.isArray(data)) {
    return data.split(",");
  }
  //   let isArray = true;
  //   try {
  //     isArray = Array.isArray(JSON.parse(data));
  //   } catch (error) {
  //     isArray = false;
  //   }
  //   let array = Array.isArray(data)
  //     ? data
  //     : isArray
  //     ? JSON.parse(data)
  //     : data.includes(",")
  //     ? data.split(",")
  //     : [data];
  //   if (!array || array.length == 0) {
  //     return null;
  //   }
  //   return array;
}
/**
 * scripts.file.upload.Edit
 *
 * 这里为什么不使用Compute Upload,Upload会把上传地址的前缀处理掉,只留下文件名.而这里是直接保留了文件的下载地址.
 * @param row 行数据
 * @param name 字段名称
 * @param model_name 模型名称
 * @returns 处理后的图片地址
 */
function Edit(row, name, model_name) {
  if (Array.isArray(row[name])) {
    return row[name].join(",");
  }
  //   const table = Process("schemas.default.TableGet", model_name);
  //   const column = table.columns.find((col) => col.name === name);
  //   if (!column || column.type === "json") {
  //     return row[name];
  //   }
  //   //非json的格式化成json
  //   return JSON.stringify(row[name]);
}
