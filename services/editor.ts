// 适配yao-amis-editor的页面处理接口
// 服务接口会把页面保存在数据库里，可以在生产环境里使用

import { Process } from '@yao/yao';

// 读取所有的page列表
//    curl -X POST http://127.0.0.1:5099/api/__yao/app/service/editor \
//    -H 'Content-Type: application/json' \
//    -H 'Authorization: Bearer <Studio JWT>' \
//    -d '{ "args":[],"method":"getPages"}'

// const mode = `widget`;

export function getPages() {
  return Process(`scripts.editor.entry.getPages`);
}
// 保存数据
//    curl -X POST http://127.0.0.1:5099/api/__yao/app/service/editor \
//    -H 'Content-Type: application/json' \
//    -H 'Authorization: Bearer <Studio JWT>' \
//    -d '{ "args":[file,payload],"method":"savePage"}'

export function savePage(file: string, payload) {
  // console.log('user_login', JSON.stringify(Authorized()));
  return Process(`scripts.editor.entry.savePage`, file, payload);
}
// 删除页面
//    curl -X POST http://127.0.0.1:5099/api/__yao/app/service/editor \
//    -H 'Content-Type: application/json' \
//    -H 'Authorization: Bearer <Studio JWT>' \
//    -d '{ "args":[file],"method":"deletePage"}'
export function deletePage(file: string) {
  return Process(`scripts.editor.entry.deletePage`, file);
}
