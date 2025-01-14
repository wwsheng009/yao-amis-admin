import { getAmisEditorPages } from '@scripts/admin/menu';
import { Process } from '@yao/yao';
// site.js
// scripts.amis.site.MenuSoybean
function MenuSoybean() {
  const menus = [
    {
      name: 'dashboard',
      path: '/dashboard',
      component: 'basic',
      children: [
        {
          name: 'dashboard_analysis',
          path: '/dashboard/analysis',
          component: 'self',
          meta: {
            title: '分析页',
            requiresAuth: true,
            icon: 'icon-park-outline:analysis',
            i18nTitle: 'routes.dashboard.analysis'
          }
        },
        {
          name: 'dashboard_workbench',
          path: '/dashboard/workbench',
          component: 'self',
          meta: {
            title: '工作台',
            requiresAuth: true,
            icon: 'icon-park-outline:workbench',
            i18nTitle: 'routes.dashboard.workbench'
          }
        }
      ],
      meta: {
        title: '仪表盘',
        icon: 'mdi:monitor-dashboard',
        order: 1,
        i18nTitle: 'routes.dashboard._value'
      }
    },
    {
      name: 'document',
      path: '/document',
      component: 'basic',
      children: [
        {
          name: 'document_vue',
          path: '/document/vue',
          component: 'self',
          meta: {
            title: 'vue文档',
            i18nTitle: 'routes.document.vue',
            requiresAuth: true,
            icon: 'logos:vue'
          }
        },
        {
          name: 'document_vite',
          path: '/document/vite',
          component: 'self',
          meta: {
            title: 'vite文档',
            i18nTitle: 'routes.document.vite',
            requiresAuth: true,
            icon: 'logos:vitejs'
          }
        },
        {
          name: 'document_naive',
          path: '/document/naive',
          component: 'self',
          meta: {
            title: 'naive文档',
            i18nTitle: 'routes.document.naive',
            requiresAuth: true,
            icon: 'logos:naiveui'
          }
        },
        {
          name: 'document_project',
          path: '/document/project',
          component: 'self',
          meta: {
            title: '项目文档',
            i18nTitle: 'routes.document.project',
            requiresAuth: true,
            localIcon: 'logo'
          }
        },
        {
          name: 'document_project-link',
          path: '/document/project-link',
          meta: {
            title: '项目文档(外链)',
            i18nTitle: 'routes.document.project-link',
            requiresAuth: true,
            localIcon: 'logo',
            href: 'https://admin-docs.soybeanjs.cn/'
          }
        }
      ],
      meta: {
        title: '文档',
        i18nTitle: 'routes.document._value',
        icon: 'mdi:file-document-multiple-outline',
        order: 2
      }
    },
    {
      name: 'component',
      path: '/component',
      component: 'basic',
      children: [
        {
          name: 'component_button',
          path: '/component/button',
          component: 'self',
          meta: {
            title: '按钮',
            i18nTitle: 'routes.component.button',
            requiresAuth: true,
            icon: 'mdi:button-cursor'
          }
        },
        {
          name: 'component_card',
          path: '/component/card',
          component: 'self',
          meta: {
            title: '卡片',
            i18nTitle: 'routes.component.card',
            requiresAuth: true,
            icon: 'mdi:card-outline'
          }
        },
        {
          name: 'component_table',
          path: '/component/table',
          component: 'self',
          meta: {
            title: '表格',
            i18nTitle: 'routes.component.table',
            requiresAuth: true,
            icon: 'mdi:table-large'
          }
        }
      ],
      meta: {
        title: '组件示例',
        i18nTitle: 'routes.component._value',
        icon: 'cib:app-store',
        order: 3
      }
    },
    {
      name: 'plugin',
      path: '/plugin',
      component: 'basic',
      children: [
        {
          name: 'plugin_charts',
          path: '/plugin/charts',
          component: 'multi',
          children: [
            {
              name: 'plugin_charts_echarts',
              path: '/plugin/charts/echarts',
              component: 'self',
              meta: {
                title: 'ECharts',
                i18nTitle: 'routes.plugin.charts.echarts',
                requiresAuth: true,
                icon: 'simple-icons:apacheecharts'
              }
            },
            {
              name: 'plugin_charts_antv',
              path: '/plugin/charts/antv',
              component: 'self',
              meta: {
                title: 'AntV',
                i18nTitle: 'routes.plugin.charts.antv',
                requiresAuth: true,
                icon: 'simple-icons:antdesign'
              }
            }
          ],
          meta: {
            title: '图表',
            i18nTitle: 'routes.plugin.charts._value',
            icon: 'mdi:chart-areaspline'
          }
        },
        {
          name: 'plugin_map',
          path: '/plugin/map',
          component: 'self',
          meta: {
            title: '地图',
            i18nTitle: 'routes.plugin.map',
            requiresAuth: true,
            icon: 'mdi:map'
          }
        },
        {
          name: 'plugin_video',
          path: '/plugin/video',
          component: 'self',
          meta: {
            title: '视频',
            i18nTitle: 'routes.plugin.video',
            requiresAuth: true,
            icon: 'mdi:video'
          }
        },
        {
          name: 'plugin_editor',
          path: '/plugin/editor',
          component: 'multi',
          children: [
            {
              name: 'plugin_editor_quill',
              path: '/plugin/editor/quill',
              component: 'self',
              meta: {
                title: '富文本编辑器',
                i18nTitle: 'routes.plugin.editor.quill',
                requiresAuth: true,
                icon: 'mdi:file-document-edit-outline'
              }
            },
            {
              name: 'plugin_editor_markdown',
              path: '/plugin/editor/markdown',
              component: 'self',
              meta: {
                title: 'markdown编辑器',
                i18nTitle: 'routes.plugin.editor.markdown',
                requiresAuth: true,
                icon: 'ri:markdown-line'
              }
            }
          ],
          meta: {
            title: '编辑器',
            i18nTitle: 'routes.plugin.editor._value',
            icon: 'icon-park-outline:editor'
          }
        },
        {
          name: 'plugin_swiper',
          path: '/plugin/swiper',
          component: 'self',
          meta: {
            title: 'Swiper插件',
            i18nTitle: 'routes.plugin.swiper',
            requiresAuth: true,
            icon: 'simple-icons:swiper'
          }
        },
        {
          name: 'plugin_copy',
          path: '/plugin/copy',
          component: 'self',
          meta: {
            title: '剪贴板',
            i18nTitle: 'routes.plugin.copy',
            requiresAuth: true,
            icon: 'mdi:clipboard-outline'
          }
        },
        {
          name: 'plugin_icon',
          path: '/plugin/icon',
          component: 'self',
          meta: {
            title: '图标',
            i18nTitle: 'routes.plugin.icon',
            requiresAuth: true,
            localIcon: 'custom-icon'
          }
        },
        {
          name: 'plugin_print',
          path: '/plugin/print',
          component: 'self',
          meta: {
            title: '打印',
            i18nTitle: 'routes.plugin.print',
            requiresAuth: true,
            icon: 'mdi:printer'
          }
        }
      ],
      meta: {
        title: '插件示例',
        i18nTitle: 'routes.plugin._value',
        icon: 'clarity:plugin-line',
        order: 4
      }
    },
    {
      name: 'auth-demo',
      path: '/auth-demo',
      component: 'basic',
      children: [
        {
          name: 'auth-demo_permission',
          path: '/auth-demo/permission',
          component: 'self',
          meta: {
            title: '权限切换',
            i18nTitle: 'routes.auth-demo.permission',
            requiresAuth: true,
            icon: 'ic:round-construction'
          }
        },
        {
          name: 'auth-demo_super',
          path: '/auth-demo/super',
          component: 'self',
          meta: {
            title: '超级管理员可见',
            i18nTitle: 'routes.auth-demo.super',
            requiresAuth: true,
            icon: 'ic:round-supervisor-account'
          }
        }
      ],
      meta: {
        title: '权限示例',
        i18nTitle: 'routes.auth-demo._value',
        icon: 'ic:baseline-security',
        order: 5
      }
    },
    {
      name: 'function',
      path: '/function',
      component: 'basic',
      children: [
        {
          name: 'function_tab',
          path: '/function/tab',
          component: 'self',
          meta: {
            title: 'Tab',
            i18nTitle: 'routes.function.tab',
            requiresAuth: true,
            icon: 'ic:round-tab'
          }
        },
        {
          name: 'function_tab-detail',
          path: '/function/tab-detail',
          component: 'self',
          meta: {
            title: 'Tab Detail',
            requiresAuth: true,
            hide: true,
            activeMenu: 'function_tab',
            icon: 'ic:round-tab'
          }
        },
        {
          name: 'function_tab-multi-detail',
          path: '/function/tab-multi-detail',
          component: 'self',
          meta: {
            title: 'Tab Multi Detail',
            requiresAuth: true,
            hide: true,
            multiTab: true,
            activeMenu: 'function_tab',
            icon: 'ic:round-tab'
          }
        }
      ],
      meta: {
        title: '功能',
        i18nTitle: 'routes.function._value',
        icon: 'icon-park-outline:all-application',
        order: 6
      }
    },
    {
      name: 'exception',
      path: '/exception',
      component: 'basic',
      children: [
        {
          name: 'exception_403',
          path: '/exception/403',
          component: 'self',
          meta: {
            title: '异常页403',
            i18nTitle: 'routes.exception.403',
            requiresAuth: true,
            icon: 'ic:baseline-block'
          }
        },
        {
          name: 'exception_404',
          path: '/exception/404',
          component: 'self',
          meta: {
            title: '异常页404',
            i18nTitle: 'routes.exception.404',
            requiresAuth: true,
            icon: 'ic:baseline-web-asset-off'
          }
        },
        {
          name: 'exception_500',
          path: '/exception/500',
          component: 'self',
          meta: {
            title: '异常页500',
            i18nTitle: 'routes.exception.500',
            requiresAuth: true,
            icon: 'ic:baseline-wifi-off'
          }
        }
      ],
      meta: {
        i18nTitle: 'routes.exception._value',
        title: '异常页',
        icon: 'ant-design:exception-outlined',
        order: 7
      }
    },
    {
      name: 'multi-menu',
      path: '/multi-menu',
      component: 'basic',
      children: [
        {
          name: 'multi-menu_first',
          path: '/multi-menu/first',
          component: 'multi',
          children: [
            {
              name: 'multi-menu_first_second',
              path: '/multi-menu/first/second',
              component: 'self',
              meta: {
                title: '二级菜单',
                i18nTitle: 'routes.multi-menu.first.second',
                requiresAuth: true,
                icon: 'mdi:menu'
              }
            },
            {
              name: 'multi-menu_first_second-new',
              path: '/multi-menu/first/second-new',
              component: 'multi',
              children: [
                {
                  name: 'multi-menu_first_second-new_third',
                  path: '/multi-menu/first/second-new/third',
                  component: 'self',
                  meta: {
                    title: '三级菜单',
                    i18nTitle: 'routes.multi-menu.first.second-new.third',
                    requiresAuth: true,
                    icon: 'mdi:menu'
                  }
                }
              ],
              meta: {
                title: '二级菜单(有子菜单)',
                i18nTitle: 'routes.multi-menu.first.second-new._value',
                icon: 'mdi:menu'
              }
            }
          ],
          meta: {
            title: '一级菜单',
            i18nTitle: 'routes.multi-menu.first._value',
            icon: 'mdi:menu'
          }
        }
      ],
      meta: {
        title: '多级菜单',
        i18nTitle: 'routes.multi-menu._value',
        icon: 'carbon:menu',
        order: 8
      }
    },
    {
      name: 'management',
      path: '/management',
      component: 'basic',
      children: [
        {
          name: 'management_auth',
          path: '/management/auth',
          component: 'self',
          meta: {
            title: '权限管理',
            i18nTitle: 'routes.management.auth',
            requiresAuth: true,
            icon: 'ic:baseline-security'
          }
        },
        {
          name: 'management_role',
          path: '/management/role',
          component: 'self',
          meta: {
            title: '角色管理',
            i18nTitle: 'routes.management.role',
            requiresAuth: true,
            icon: 'carbon:user-role'
          }
        },
        {
          name: 'management_user',
          path: '/management/user',
          component: 'self',
          meta: {
            title: '用户管理',
            i18nTitle: 'routes.management.user',
            requiresAuth: true,
            icon: 'ic:round-manage-accounts'
          }
        },
        {
          name: 'management_route',
          path: '/management/route',
          component: 'self',
          meta: {
            title: '路由管理',
            i18nTitle: 'routes.management.route',
            requiresAuth: true,
            icon: 'material-symbols:route'
          }
        }
      ],
      meta: {
        title: '系统管理',
        i18nTitle: 'routes.management._value',
        icon: 'carbon:cloud-service-management',
        order: 9
      }
    },
    {
      name: 'about',
      path: '/about',
      component: 'self',
      meta: {
        title: '关于',
        i18nTitle: 'routes.about',
        requiresAuth: true,
        keepAlive: true,
        singleLayout: 'basic',
        icon: 'fluent:book-information-24-regular',
        order: 10
      }
    },
    {
      name: 'amis-demo_form',
      path: '/amis_demo_form',
      component: 'amis',
      meta: {
        title: 'AMIS表单',
        requiresAuth: true,
        keepAlive: true,
        singleLayout: 'basic',
        icon: 'fluent:book-information-24-regular',
        order: 11
      }
    }
  ];

  return {
    routes: menus,
    home: 'dashboard_analysis'
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
          url: '/system',
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
              url: 'admin.permission'
            },
            {
              label: '角色管理',
              icon: 'fa fa-group',
              schemaApi: '/api/v1/amis/pages/admin.role',
              url: 'admin.role'
            },
            {
              label: '用户管理',
              icon: 'fa fa-user',
              schemaApi: '/api/v1/amis/pages/admin.user',
              url: 'admin.user'
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
              url: 'admin.file'
            },
            {
              label: 'ODATA管理',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/app.odata',
              url: 'odata.view'
            },
            {
              label: '分块上传演示',
              icon: 'fa fa-file',
              schemaApi: '/api/v1/amis/pages/demo.fileChunkUpload',
              url: 'admin.fileChunkUpload'
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
              label: 'AI聊天',
              icon: 'fas fa-robot',
              schemaApi: '/api/v1/amis/pages/admin.admin',
              url: 'robot'
            },
            {
              label: '模型列表',
              icon: 'fas fa-robot',
              schema: {
                type: 'iframe',
                src: '/admin/assistants?__hidemenu=1&assistant_id=model'
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
              url: 'model.create',
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
              url: '/model/create/:id/'
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
          rewrite: '/model/list',
          url: '/model'
        },
        {
          label: '表数据管理',
          icon: 'fa fa-book',
          schemaApi: '/api/v1/amis/pages/table.maintainer',
          url: '/table/maintainer'
        },
        {
          label: 'Studio',
          url: '/studio',
          rewrite: '/table/fields',
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
