const {
  convertFileListToSoyRoute,
  // updateSoyRouteComponent,
  updateSoyRoutePath
} = require('./menu');

let fileList = [
  '/pages/404.json',
  '/pages/about.json',
  '/pages/admin',
  '/pages/admin/admin.json'
];

const fileList2 = [
  '/pages/404.json',
  '/pages/about.json',
  '/pages/admin',
  '/pages/admin/admin.json',
  '/pages/admin/dept.json',
  '/pages/admin/menu-1.json',
  '/pages/admin/menu.json',
  '/pages/admin/menu_tree.json',
  '/pages/admin/permission.json',
  '/pages/admin/redirect.json',
  '/pages/admin/toolbar-bak.json',
  '/pages/admin/toolbar.json',
  '/pages/api',
  '/pages/api/list.json',
  '/pages/api/test.json',
  '/pages/audio_captcha.json',
  '/pages/crud-edit.json',
  '/pages/crud-list.json',
  '/pages/crud-new.json',
  '/pages/crud-view.json',
  '/pages/editor.json',
  '/pages/header-toolbar.json',
  '/pages/input-excel.json',
  '/pages/model',
  '/pages/model/create.json',
  '/pages/model/import.json',
  '/pages/model/list.json',
  '/pages/studio',
  '/pages/studio/font.json',
  '/pages/studio/code.json',
  '/pages/system_role.json',
  '/pages/table',
  '/pages/table/fields.json',
  '/pages/table-maintain.json',
  '/pages/user',
  '/pages/user/info.json',
  '/pages/user/logout.json',
  '/pages/user/password_change.json'
];
fileList = fileList2.map((f) => f.substring(`/pages`.length));

const routes = convertFileListToSoyRoute(fileList);
updateSoyRoutePath('/api/v1/amis/edit_pages/', routes, null);

// 这里包装了一个顶层
const rootRoutes = [
  {
    name: 'amis_pages',
    path: '/amis_pages',
    component: 'basic',
    children: routes,
    meta: { order: 2001, requiresAuth: true, title: 'AMIS' }
  }
];
// rootRoutes.forEach((x) => updateSoyRouteComponent(x, null));
console.log(JSON.stringify(rootRoutes));
