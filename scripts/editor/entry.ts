import { Process } from '@yao/yao';

// const supported = ['database', 'localfile', 'widget'];

const mode = `database`;
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

export function getAmisEditorPageSource(pageId: string) {
  return Process(`scripts.editor.${mode}.getAmisEditorPageSource`, pageId);
}

export function getEditorPagesFileList() {
  return Process(`scripts.editor.${mode}.getEditorPagesFileList`);
}
