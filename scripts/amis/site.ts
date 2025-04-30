import { getAmisEditorPages } from '@scripts/admin/menu';
import { Process } from '@yao/yao';
// site.js
// scripts.amis.site.MenuSoybean
export function MenuSoybean() {
  const menus = [
    {
      name: 'home',
      path: '/home',
      component: 'layout.base$view.home',
      meta: {
        title: 'home',
        i18nKey: 'route.home',
        icon: 'mdi:monitor-dashboard',
        order: 1
      }
    }
  ];

  return {
    routes: menus,
    home: 'home'
  };
}

/**
 * 普通用户的菜单列表，根据会话中的用户信息进行过滤
 * yao run scripts.amis.site.Menu
 * @returns
 */
function Menu() {
  const user = Process('session.get', 'user');
  if (user?.type === 'super') {
    return getSuperUserMenu();
  }
  const pages = Process('scripts.admin.menu.getAmisPageRoutesFromDB');

  const siteMenu = {
    pages: [
      ...getHomeMenu(),
      {
        children: pages
      },
      {
        children: getSettingMenu()
      }
    ]
  };
  return siteMenu;
}

/**
 * 超级管理员的菜单列表，直接从文件系统读取，而不是数据库
 * @returns
 */
function getSuperUserMenu() {
  const editorPages = getAmisEditorPages(); //Process('scripts.admin.menu.getAmisEditorPages');

  const user = Process('session.get', 'user');
  let pages_in = [];
  if (user?.type === 'super') {
    pages_in = Process('scripts.admin.menu.getAmisPages');
  }
  // else {
  //   let pages = Process("scripts.admin.menu.getAmisPageRoutesFromDB");
  //   if (pages.length === 0) {
  //     pages = Process("scripts.admin.menu.getAmisPages");
  //   }
  // }

  const siteMenu = {
    pages: [
      ...getHomeMenu(),
      ...getModelMenu(),
      ...getSystemMenu(),
      ...getAiMenus(),
      {
        children: pages_in
      },
      {
        children: editorPages
      },
      {
        children: getSettingMenu()
      }
    ]
  };
  return siteMenu;
}
function getHomeMenu() {
  return [
    {
      url: '/',
      label: 'Home',
      schemaApi: '/api/v1/amis/pages/welcome'
    }
  ];
}
function getSystemMenu() {
  return [
    {
      children: [
        {
          label: '系统管理',
          url: '/amis/system',
          icon: 'fas fa-toolbox',
          children: [
            {
              label: '菜单管理',
              icon: 'fas fa-bars',
              schemaApi: '/api/v1/amis/pages/admin.menu',
              url: 'menu'
            },
            {
              label: '部门管理',
              icon: 'fab fa-dyalog',
              schemaApi: '/api/v1/amis/pages/admin.dept'
            },
            {
              label: '修改密码',
              icon: 'fab fa-app-store-ios',
              schemaApi: '/api/v1/amis/pages/user.password_change'
            },
            {
              label: '权限管理',
              icon: 'fa fa-group',
              schemaApi: '/api/v1/amis/pages/admin.permission',
              url: 'admin/permission'
            },
            {
              label: '角色管理',
              icon: 'fa fa-group',
              schemaApi: '/api/v1/amis/pages/admin.role',
              url: 'admin/role'
            },
            {
              label: '用户管理',
              icon: 'fa fa-user',
              schemaApi: '/api/v1/amis/pages/admin.user',
              url: 'admin/user'
            },
            {
              label: '文件管理',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/admin.file',
              url: '/admin/file/:category'
            },
            {
              label: '文件管理',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/admin.file2',
              url: 'admin/file'
            },
            {
              label: 'ODATA管理',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/app.odata',
              url: 'odata/view'
            },
            {
              label: '分块上传演示',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/demo.fileChunkUpload',
              url: 'admin/fileChunkUpload'
            }
          ]
        },
        {
          label: '博客管理',
          url: '/app/blog',
          icon: 'fas fa-blog',
          children: [
            {
              label: '博客管理',
              icon: 'fas fa-blog',
              schemaApi: '/api/v1/system/schema/app.blog.site/crud-all',
              url: 'site'
            },
            {
              label: '文章管理',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/app.blog.post',
              url: 'post'
            },
            {
              label: '标签管理',
              icon: 'fas fa-tag',
              schemaApi: '/api/v1/system/schema/app.blog.tag/crud-all',
              url: 'tag'
            },
            {
              label: '分类管理',
              icon: 'fa far fa-flag',
              schemaApi: '/api/v1/system/schema/app.blog.category/crud-all',
              url: 'category'
            }
          ]
        }
      ]
    }
  ];
}
function getSettingMenu() {
  return [
    {
      label: '设置',
      icon: 'fas fa-ellipsis-h',
      children: [
        {
          label: '个人信息',
          icon: 'fas fa-info',
          schemaApi: '/api/v1/amis/pages/user.info',
          url: 'user/info'
        },
        {
          label: '关于',
          icon: 'fa fa-info',
          schemaApi: '/api/v1/amis/pages/system.about',
          url: '/about'
        },
        {
          label: '退出',
          icon: 'fas fa-outdent',
          schemaApi: '/api/v1/amis/pages/user.logout',
          url: '/logout'
        },
        {
          label: '404',
          schemaApi: '/api/v1/amis/pages/system.404',
          isDefaultPage: true,
          visible: false
        }
      ]
    }
  ];
}
function getAiMenus() {
  return [
    {
      children: [
        {
          label: 'AI',
          icon: 'fas fa-robot ',
          rewrite: '/gpt/robot',
          url: '/ai',
          children: [
            {
              label: 'Xgen',
              icon: 'fas fa-book',
              schema: {
                type: 'iframe',
                src: '/admin/chat?__hidemenu=0'
              },
              url: 'xgen'
            },
            {
              label: 'AI聊天',
              icon: 'fas fa-robot',
              schemaApi: '/api/v1/amis/pages/admin.admin',
              url: 'robot'
            },
            {
              label: '助手列表',
              icon: 'fas fa-robot',
              schema: {
                type: 'iframe',
                src: '/admin/assistants'
              },
              url: 'assistants'
            },
            {
              label: '聊天助手',
              icon: 'fas fa-robot',
              schema: {
                type: 'iframe',
                src: '/admin/chat?__hidemenu=1&assistant_id=chat'
              },
              url: 'chat-chat'
            },
            {
              label: '模型对话',
              icon: 'fas fa-robot',
              schema: {
                type: 'iframe',
                src: '/admin/chat?__hidemenu=1&assistant_id=model'
              },
              url: 'chat-model'
            }
          ]
        }
      ]
    }
  ];
}
function getModelMenu() {
  return [
    {
      children: [
        {
          children: [
            {
              icon: 'fa fa-list',
              label: '列表',
              schemaApi: '/api/v1/amis/pages/model.list',
              url: 'list'
            },
            {
              label: '新增',
              schemaApi: '/api/v1/amis/pages/model.create',
              url: 'create',
              icon: 'fa fa-plus'
            },
            {
              label: '模型导入',
              icon: 'fas fa-file-import',
              schemaApi: '/api/v1/amis/pages/model.import',
              url: 'import'
            },
            {
              label: '修改',
              schemaApi: '/api/v1/amis/pages/model.create',
              url: 'create/:id/'
            },
            {
              label: '模型关联Api',
              icon: 'fas fa-location-arrow ',
              schemaApi: '/api/v1/amis/pages/api.model',
              url: 'apilist'
            },
            {
              label: '代码生成',
              icon: 'fas fa-code',
              schemaApi: '/api/v1/amis/pages/studio.code',
              url: 'code_generate'
            },
            {
              label: '搜索帮助维护',
              icon: 'fab fa-hire-a-helper',
              schemaApi: '/api/v1/system/schema/ddic.selectoption/crud-all',
              url: 'selectoption'
            }
          ],
          icon: 'fa fa-cube',
          label: '模型维护',
          rewrite: '/amis/model/list',
          url: '/amis/model'
        },
        {
          label: '表数据管理',
          icon: 'fa fa-book',
          schemaApi: '/api/v1/amis/pages/table.maintainer',
          url: '/amis/table/maintainer'
        },
        {
          label: 'Studio',
          url: '/amis/studio',
          rewrite: '/amis/table/fields',
          icon: 'fab fa-studiovinari',
          children: [
            {
              label: '表格字段',
              icon: 'fas fa-table',
              schemaApi: '/api/v1/amis/pages/table.fields',
              url: 'table/fields'
            },
            {
              label: '代码生成',
              icon: 'fas fa-code',
              schemaApi: '/api/v1/amis/pages/studio.code',
              url: 'code'
            },
            {
              label: 'API列表',
              icon: 'fas fa-list-ol',
              schemaApi: '/api/v1/amis/pages/api.list',
              url: 'api/list'
            },
            {
              label: 'API测试',
              icon: 'fas fa-location-arrow ',
              schemaApi: '/api/v1/amis/pages/api.test',
              url: 'api/test'
            },
            {
              label: '字体列表',
              icon: 'fab fa-font-awesome',
              schemaApi: '/api/v1/amis/pages/studio.font',
              url: 'font'
            },
            {
              schemaApi: '/api/v1/amis/pages/studio.chart',
              label: '图表编辑器',
              icon: 'fas fa-chart-line',
              url: 'chart'
            },
            {
              schemaApi: '/api/v1/amis/pages/studio.editor',
              label: 'Amis-编辑器',
              icon: 'far fa-file-code',
              url: 'editor'
            }
          ]
        }
      ]
    }
  ];
}
// 根据用户信息，返回菜单
