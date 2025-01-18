/**
 * 系统设置初始化
 * yao run scripts.studio.setup.run
 */
function run() {
  // 加载页面数据到数据库

  // 加载字段列表
  try {
    // Process("scripts.system.font.loadfont");
  } catch (error) {
    console.log('无法加载在线字体信息');
  }
  // 加载API列表
  // Process("scripts.system.meta.saveApis");
  // 加载模型到数据库
  // Process("scripts.system.model.ImportCachedToDBBatch");
}
