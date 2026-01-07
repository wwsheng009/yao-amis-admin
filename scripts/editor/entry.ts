import { Process } from '@yao/yao';

/**
 * 这个是一个通用的处理入口，编辑器的数据存储方式有多种，这里通过 mode 来区分
 * 目前支持的数据存储方式有：
 * database: 使用数据库存储
 * localfile: 使用本地文件系统存储
 * widget: 使用 widget 的方式来存储
 *
 * 选择database方式方便在线上布署处理，比如备份，加载
 *
 * 选择localfile的方式适合于本地开发与调试，方便查看文件
 *
 * 选择widget会利用yao本身的缓存功能，性能会更好
 */
// const supported = ['database', 'localfile', 'widget'];

const mode = `localfile`;
// 获取页面源代码列表
export function getPages() {
  return Process(`scripts.editor.${mode}.getPages`);
}
// 保存数据
export function savePage(file: string, payload) {
  return Process(`scripts.editor.${mode}.savePage`, file, payload);
}
// 删除页面
export function deletePage(file: string) {
  return Process(`scripts.editor.${mode}.deletePage`, file);
}

// 获取页面数据
export function getAmisEditorPageSource(pageId: string) {
  return Process(`scripts.editor.${mode}.getAmisEditorPageSource`, pageId);
}
// 获取页面文件名列表
export function getEditorPagesFileList() {
  return Process(`scripts.editor.${mode}.getEditorPagesFileList`);
}
