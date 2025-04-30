import { deleteObjectKey } from '@scripts/system/lib';
import { ClearFalsyKeys } from '@scripts/system/lib';
import { updateSoyRouteComponent } from '@scripts/admin/menu_lib';
import { filterTreeDataWithFunc } from '@scripts/amis/data/tree';
import { getUserAuthMenuIds } from '@scripts/auth/lib';
import { Process } from '@yao/yao';
import { MenuSoybean } from '@scripts/amis/site';
import { getPagesFileList } from '@scripts/editor/localfile';

/**
 * 处理用户的菜单
 * 功能一，读取本地数据库中的菜单配置,转换成soy-admin菜单
 * 功能二，读取本地文件目录/data/pages,转换成soy-admin菜单
 * 功能三，读取本地文件目录/data/amis_editor,转换成soy-admin菜单
 *
 * */

// const PagesLocation = '/pages';
// const WorkingPagesLocation = '/amis_editor';

/**
 * get user auth menus
 * yao run scripts.admin.menu.getSoyAdminUserMenu
 */
export function getSoyAdminUserMenu() {
  const menusIds = getUserAuthMenuIds();
  if (menusIds.length) {
    // get menus
    let routes = getSoyRoutesFromDB();
    routes = Process(`utils.arr.Tree`, routes, { parent: 'parent', empty: 0 });
    routes = filterTreeDataWithFunc(routes, (item) => {
      return menusIds.includes(item.id) || !item.meta?.requiresAuth;
    });
    return cleanUpRouteMenu(routes);
  } else {
    const user = Process('session.get', 'user');
    if (user?.type === 'super') {
      return getSoySuperUserMenu();
    }
  }
  return [];
}

/**
 * yao run scripts.admin.menu.reLoadAndSaveMenus
 * 重新加载菜单列表
 */
export function reLoadAndSaveMenus() {
  saveSoyRoutesToDB();
  // 导入本地开发的页面
  saveLocalAmisSoyRoutesToDB();
}

export function cleanUpRouteMenu(routes) {
  routes.forEach((x) => updateSoyRouteComponent(x));

  deleteObjectKey(routes, 'parent');
  deleteObjectKey(routes, 'id');

  routes = ClearFalsyKeys(routes);

  let home = 'home';
  if (routes?.length > 0) {
    home = routes[0].name;
  }
  return { routes: routes, home: home };
}
/**
 * 转换SoyAdmin用户菜单
 * 超级管理员的菜单列表，如果数据库中没有，直接读取系统默认的设置
 * yao run scripts.admin.menu.getSoySuperUserMenu
 * @returns 用户菜单
 */
export function getSoySuperUserMenu() {
  // let routes = getSoyRoutesFromDB();
  // if (routes.length === 0) {
  const routesSoy = MenuSoybean().routes;
  const routesLocal = getAmisLocalPageAsSoyRoutes();
  const editor_routes = getAmisEditorSoyRoute(); //Process('scripts.admin.menu.getAmisEditorSoyRoute');

  const localRoutes = [...routesSoy, ...routesLocal, ...editor_routes];

  return cleanUpRouteMenu(localRoutes);
  // }
  // // 转换成树结构
  // routes = Process(`utils.arr.Tree`, routes, { parent: 'parent', empty: 0 });

  // // 导入正在编辑的页面
  // const editor_routes = getAmisEditorSoyRoute(); //Process('scripts.admin.menu.getAmisEditorSoyRoute');
  // routes = routes.concat(editor_routes);

  // return cleanUpRouteMenu(routes);
}

/**
 * 读取数据库中所有的菜单配置列表
 * @returns []Route
 */
export function getSoyRoutesFromDB() {
  // 优先从数据库读取菜单
  const menus: admin_menu[] = Process('models.admin.menu.get', {});

  const menus2: Route[] = menus.map((menu: admin_menu) => {
    const r: Route = {
      id: menu.id, // required
      parent: menu.parent, // required
      name: menu.name || 'amis_' + menu.id,
      path: menu.url || '',
      redirect: menu.redirect,
      component: menu.component ? menu.component : 'amis',
      meta: {
        title: menu.title || menu.name || '' + menu.id,
        icon: menu.icon,
        order: menu.rank,
        requiresAuth: menu.requires_auth,
        source: menu.source // 提供后续的导入支持
      },
      children: []
    };
    // 外链
    if (menu.url_type == 2) {
      r.meta.href = menu.url;
    } else if (menu.url_type == 3) {
      // amis组件
      r.component = 'amis';
      // 需要配置api
      r.meta.schemaApi = menu.schema_api;
    }
    if (!menu.visible) {
      r.meta.hide = true;
    }
    if (menu.single_layout) {
      r.meta.singleLayout = menu.single_layout;
    }
    if (menu.keep_alive != null) {
      r.meta.keepAlive = menu.keep_alive ? true : false;
    }
    if (!r.meta.icon) {
      r.meta.icon = 'icon-park-outline:workbench';
    }
    return r;
  });
  return menus2;
}

/**
 * 导出数据库中的菜单，由于导入本地菜单时的描述信息没有，可以编辑好菜单后导出成文件
 * yao run scripts.admin.menu.exportMenus
 */
export function exportMenus(pathIn: string | undefined) {
  const folder = new Date().toISOString().slice(0, 10).replace(/-/g, '');

  const path = pathIn || `/upload/public/system_menus_${folder}.json`;

  let routes = getSoyRoutesFromDB();
  routes = Process(`utils.arr.Tree`, routes, { parent: 'parent', empty: 0 });
  const json = JSON.stringify(routes, null, 2);
  Process('fs.system.writefile', path, json);

  return `Menu Saved to ${path}`;
}

/**
 * 导入菜单
 * yao run scripts.admin.menu.importMenus
 * @param pathIn import menu path
 */
export function importMenus(pathIn: string | undefined) {
  const folder = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const path = pathIn || `/upload/public/system_menus_${folder}.json`;
  const json = Process('fs.system.readfile', path);
  const routes = JSON.parse(json);
  saveTreeMenusToDB(routes, undefined, false);
}

/**
 * 保存本地的页面到数据库
 * yao run scripts.admin.menu.saveLocalAmisSoyRoutesToDB
 */
function saveLocalAmisSoyRoutesToDB() {
  const routes = getAmisLocalPageAsSoyRoutes();
  saveTreeMenusToDB(routes, 'amis', false);
}
/**
 * 将Soyadmin的系统菜单作转换并导入到数据库
 * yao run scripts.admin.menu.saveSoyRoutesToDB
 */
function saveSoyRoutesToDB() {
  // 导入前端本身的菜单
  const routes = Process('scripts.amis.site.MenuSoybean')['routes'];
  saveTreeMenusToDB(routes, 'soy', false);
}
/**
 * 获取文件系统中的页面，根据文件目录结构转换成Soy菜单结构
 * yao run scripts.admin.menu.getAmisLocalPageAsSoyRoutes
 * @returns []
 */
function getAmisLocalPageAsSoyRoutes() {
  const files = getPagesFileList();
  const routes = convertFileListToSoyRoute(files);

  updateSoyRoutePath('/api/v1/amis/pages/', routes, undefined);

  // 这里包装了一个顶层
  const rootRoutes = [
    {
      name: 'amis',
      path: '/amis',
      subPath: 'amis',
      component: 'layout.base',
      children: routes,
      meta: { order: 2001, requiresAuth: true, title: 'AMIS页面' }
    }
  ];
  updateSoyRouteComponent(rootRoutes);

  return rootRoutes;
}

/**
 *根据页面ID，获取Amis的页面源代码
 * yao run scripts.admin.menu.getAmisPageSchema
 * @param pageId
 * @returns
 */
export function getAmisPageSchema(pageId: string) {
  return Process('scripts.editor.localfile.getAmisPageSchema', pageId);
  // const page = pageId.replace('.', '/') + '.json';

  // const fpath = PagesLocation + '/' + page;
  // const isExist = Process('fs.system.Exists', fpath);
  // if (!isExist) {
  //   throw new Exception(`文件不存在：${fpath}`);
  // }

  // const str = Process('fs.system.ReadFile', fpath);
  // const source = JSON.parse(str);
  // if (source.type === 'app') {
  //   return {
  //     type: 'tpl',
  //     tpl: '不能显示类型为app的页面'
  //   };
  // }
  // return JSON.parse(str);
}

/**
 * yao run scripts.admin.menu.getAmisEditorPageSource
 * 读取当前用户下的编辑器页面的源代码
 * @param {*} pageId page id
 * @returns
 */
export function getAmisEditorPageSource(pageId: string) {
  return Process('scripts.editor.entry.getAmisEditorPageSource', pageId);
}

// yao run scripts.admin.menu.getAmisEditorSoyRoute
export function getAmisEditorSoyRoute() {
  const files = Process('scripts.editor.entry.getEditorPagesFileList');
  // 这里包装了一个顶层
  const rootRoutes = [
    {
      name: 'amis-editor',
      path: '/amis-editor',
      subPath: 'amis-editor',
      component: '',
      children: [] as Route[],
      meta: { order: 2001, requiresAuth: true, title: 'AMIS编辑器' }
    }
  ] as Route[];

  if (files.length) {
    const routes = convertFileListToSoyRoute(files);

    // 这里比较特殊，不要更新amis_editor节点
    updateSoyRoutePath('/api/v1/amis/edit_pages/', routes, undefined);
    rootRoutes[0].children = routes[0]?.children || [];
  }

  updateSoyRouteComponent(rootRoutes);
  return rootRoutes;
}

/**
 * 把文件名列表转换成嵌套关系的路由结构
 * @param {string[]} list 文件路径列表
 * @returns []Route
 */
export function convertAmisFileListToSoyRoute(
  list: string[],
  sep: string = '/'
): Route {
  let order = 1000;
  const result = {
    name: 'amis_editor',
    path: '/amis_editor',
    component: 'layout.base$view.404',
    subPath: 'amis_editor', // 单一层级的节点
    children: [],
    meta: { title: '', order: order, requiresAuth: true }
  };

  const getPath = (url: string) => {
    //remove file extension
    url = url.replace(/\\+/g, sep);
    url = url.replace(/\/+/g, sep);
    const dotIndex = url.lastIndexOf('.');
    url = dotIndex > -1 ? url.substring(0, dotIndex) : url;
    return url
      .split(sep)
      .filter((path) => path !== '')
      .map((path, index) => {
        if (index === 0 && path.startsWith('.')) {
          return path.substring(1);
        }
        return path;
        // const dotIndex = path.lastIndexOf('.');
        // return dotIndex > -1 ? path.substring(0, dotIndex) : path;
      })
      .join(sep);
  };

  //给路由对象增加子节点。
  const addSubPath = (obj: Route, subPathArr: string[]) => {
    let tempObj = obj as Route;
    for (let i = 0; i < subPathArr.length; i++) {
      const subPath = subPathArr[i];
      //检查是否已经存在
      const existingObj = tempObj.children.find(
        (child) => child.subPath === subPath
      );
      if (existingObj) {
        tempObj = existingObj;
      } else {
        const newChild = {
          name: '', // update later
          subPath: subPath,
          // fullpath: `${tempObj.fullpath}/${subPath}`,
          path: tempObj.subPath ? `${tempObj.subPath}.${subPath}` : subPath,
          children: [],
          meta: { requiresAuth: true, title: subPath }
        } as Route;
        tempObj.children.push(newChild);
        tempObj = newChild;
        tempObj.meta.order = order++;
      }
    }
  };

  list.forEach((url) => {
    const path = getPath(url);
    addSubPath(result, path.split(sep));
  });
  return result;
}

export function convertFileListToSoyRoute(list: string[]): Route[] {
  const result = convertAmisFileListToSoyRoute(list);
  //   小心处理层级
  removeEmptyChildren(result);
  return result.children || [];
}
export function removeEmptyChildren(node: Route) {
  if (node.children?.length === 0) {
    delete node.children;
    if (Object.keys(node.meta).length === 0) {
      delete node.meta;
    }
  } else {
    if (node.children) {
      for (const child of node.children) {
        removeEmptyChildren(child);
      }
    }
  }
}

/**
 * 更新路由中的api与路径
 * @param api api prefix
 * @param route 路由
 * @param parent 上级节点
 * @returns
 */
export function updateSoyRoutePath(
  api: string,
  route: Route | Route[],
  parent: Route | undefined
) {
  if (Array.isArray(route)) {
    route.forEach((n) => updateSoyRoutePath(api, n, parent));
    return;
  }

  route.meta.title = route.meta.title || route.subPath || route.name;
  if (!route.meta?.schemaApi?.startsWith(api)) {
    route.meta.schemaApi = api + route.path;
    route.meta.schemaApi = route.meta.schemaApi.replace(/\/\//g, '/');
  }

  if (parent == null) {
    route.path = '/' + route.subPath;
  } else {
    route.path = parent.path + '/' + route.subPath;
  }
  route.path = route.path.replace(/\/\//g, '/');

  route.name = route.path.replace(/[\\./]/g, '_');
  if (route.name.startsWith('_')) {
    route.name = route.name.substring(1);
  }

  if (route.children?.length > 0) {
    route.children.forEach((n) => updateSoyRoutePath(api, n, route));
    route.meta.schemaApi = undefined;
  }
}

/**
 * 保存菜单到数据库
 * @param menus 菜单，树形结构
 * @param source 来源 soy|amis
 * @param deleteFlag 是否删除
 */
function saveTreeMenusToDB(
  menus: Route[],
  source: 'amis' | 'soy' | undefined = 'amis',
  deleteFlag: boolean
) {
  function traverse(route: Route | Route[], parentId: number) {
    if (Array.isArray(route)) {
      route.forEach((r) => traverse(r, 0));
      return;
    }
    if (deleteFlag) {
      Process('models.admin.menu.deletewhere', {
        wheres: [
          {
            column: 'name',
            value: route.name
          }
        ]
      });
    }

    route.meta = route.meta || { title: '' };

    let menu: admin_menu = {
      name: route.name,
      title: '',
      source: route.meta.source || source
    };

    // 根据路由的名称进行判断，如果已经存在，进行更新
    if (route.name) {
      const [menudb] = Process('models.admin.menu.get', {
        wheres: [
          {
            column: 'name',
            value: route.name
          }
        ]
      });
      if (menudb != null) {
        menu = menudb;
      }
    }

    menu.name = menu.name || route.name || route.path || '__';
    menu.title = menu.title || route.meta?.title || menu.name;
    menu.url = menu.url || route.path;
    menu.component = menu.component || route.component;
    if (menu.component === 'amis') {
      menu.url_type = 3;
    }
    menu.schema_api = menu.schema_api || route.meta?.schemaApi;
    menu.icon = menu.icon || route.meta?.icon;
    menu.visible = menu.visible || !route.meta?.hide;
    menu.rank = menu.rank || route.meta?.order;
    menu.requires_auth =
      menu.requires_auth != null ? menu.requires_auth : route.meta.requiresAuth;

    menu.parent = parentId; // reset parent

    const id = Process('models.admin.menu.save', menu);
    // console.log("id==>", id, menu);
    if (Array.isArray(route.children)) {
      route.children.forEach((element) => {
        traverse(element, id);
      });
    }
  }
  traverse(menus, 0);
}

/**
 * 从数据库读取Amis app页面的菜单，不适用于soy管理页面
 * yao run scripts.admin.menu.getAmisRoutesFromDB
 * @returns
 */
function getAmisRoutesFromDB(): AmisAppPage[] {
  const menus: admin_menu[] = Process('models.admin.menu.get', {
    wheres: [{ column: 'source', value: 'amis' }]
  });

  const menus2: AmisAppPage[] = menus.map((menu: admin_menu) => {
    const route: AmisAppPage = {
      id: menu.id, // required
      parent: menu.parent, // required
      label: menu.title,
      url: menu.url_type === 3 ? menu.url : undefined, // amis menu type
      icon: menu.icon,
      schemaApi: menu.schema_api,
      schema: menu.schema,
      rewrite: menu.rewrite,
      visible: menu.visible,
      link: menu.url_type === 2 ? menu.url : undefined,
      children: []
    };
    route.url = route.url?.replace(/\/\//g, '/');
    route.schemaApi = route.schemaApi?.replace(/\/\//g, '/');
    return route;
  });
  return menus2;
}

/**
 * 从数据库中读取Aims App的用户菜单配置，超级管理员可以访问所有的菜单列表
 * yao run scripts.admin.menu.getAmisPageRoutesFromDB
 * @returns amis page
 */
export function getAmisPageRoutesFromDB(): AmisAppPage[] {
  let routes = getAmisRoutesFromDB();
  // 转换成树结构
  routes = Process(`utils.arr.Tree`, routes, { parent: 'parent', empty: 0 });
  const user = Process('session.get', 'user');
  if (user?.type !== 'super') {
    const menusIds = getUserAuthMenuIds();
    routes = filterTreeDataWithFunc(routes, (item) => {
      return menusIds.includes(item.id);
    });
  }

  deleteObjectKey(routes, 'parent');
  deleteObjectKey(routes, 'id');

  routes = ClearFalsyKeys(routes);
  return routes;
}

function convertSoyRoutesToAmisPages(routes: Route[]): AmisAppPage[] {
  const result = [] as AmisAppPage[]; // Fix 2: Create new object/array

  const travel = function (r: Route | Route[], parent: AmisAppPage[]) {
    if (Array.isArray(r)) {
      r.forEach((r) => travel(r, result));
      return;
    }

    const route: AmisAppPage = {
      label: r.meta?.title || r.name,
      url: r.path,
      icon: r.meta.icon,
      schemaApi: r.children?.length ? undefined : r.meta.schemaApi,
      // schema: menu.schema,
      // rewrite: menu.rewrite,
      visible: !r.meta.hide ? undefined : false,
      // link: menu.url_type === 2 ? menu.url : undefined,
      children: [] as AmisAppPage[]
    };
    route.url = route.url?.replace(/\/\//g, '/');
    route.schemaApi = route.schemaApi?.replace(/\/\//g, '/');

    if (Array.isArray(r.children)) {
      r.children.forEach((r) => travel(r, route.children));
    }
    parent.push(route);
  };
  travel(routes, result);

  return result;
}

// yao run scripts.admin.menu.getAmisEditorPages
export function getAmisEditorPages(): AmisAppPage[] {
  const routes = getAmisEditorSoyRoute();
  let amsiRoutes = convertSoyRoutesToAmisPages(routes);
  amsiRoutes = ClearFalsyKeys(amsiRoutes);
  return amsiRoutes;
}
// yao run scripts.admin.menu.getAmisPages
export function getAmisPages(): AmisAppPage[] {
  const routes = getAmisLocalPageAsSoyRoutes();
  let amsiRoutes = convertSoyRoutesToAmisPages(routes);
  amsiRoutes = ClearFalsyKeys(amsiRoutes);
  return amsiRoutes;
}

// amis 多页的菜单
interface SpinnerExtraProps {
  loadingConfig?: {
    root?: string;
    show?: boolean;
  };
}

type SchemaClassName =
  | string
  | {
      [propName: string]: boolean | undefined | null | string;
    };
// amis 多页的菜单配置
interface AmisAppPage extends SpinnerExtraProps {
  id?: number;
  parent?: number;
  /**
   * 菜单文字
   */
  label?: string;

  /**
   * 菜单图标，比如： fa fa-file
   */
  icon?: string;

  /**
   * 路由规则。比如：/banner/:id。当地址以 / 打头，则不继承上层的路径，否则将集成父级页面的路径。
   */
  url?: string;

  /**
   * 当match url 时跳转到目标地址.没有配置 schema 和 shcemaApi  时有效.
   */
  redirect?: string;

  /**
   * 当match url 转成渲染目标地址的页面.没有配置 schema 和 shcemaApi  时有效.
   */
  rewrite?: string;

  /**
   * 不要出现多个，如果出现多个只有第一个有用。在路由找不到的时候作为默认页面。
   */
  isDefaultPage?: boolean;

  /**
   * 二选一，如果配置了 url 一定要配置。否则不知道如何渲染。
   */
  schema?: object;
  schemaApi?: string;

  /**
   * 单纯的地址。可以设置外部链接。
   */
  link?: string;

  /**
   * 支持多层级。
   */
  children: Array<AmisAppPage>;

  /**
   * 菜单上的类名
   */
  className?: SchemaClassName;

  /**
   * 是否在导航中可见，适合于那种需要携带参数才显示的页面。比如具体某个数据的编辑页面。
   */
  visible?: boolean;

  /**
   * 默认是自动，即：自己选中或者有孩子节点选中则展开。
   * 如果配置成 always 或者配置成 true 则永远展开。
   * 如果配置成 false 则永远不展开。
   */
  // expanded?: 'auto' | 'always' | boolean;
}

type AllRouteKey = string;
type Route<K extends AllRouteKey = AllRouteKey> = K extends AllRouteKey
  ? {
      id?: number;
      parent?: number;

      /** 路由名称(路由唯一标识) */
      name: K;
      /** 子路径 */
      subPath?: string;
      /** 路由路径 */
      path: string;
      /** 路由重定向 */
      redirect?: string;
      /**
       * 路由组件
       * - basic: 基础布局，具有公共部分的布局
       * - blank: 空白布局
       * - multi: 多级路由布局(三级路由或三级以上时，除第一级路由和最后一级路由，其余的采用该布局)
       * - self: 作为子路由，使用自身的布局(作为最后一级路由，没有子路由)
       */
      component?: string;
      /** 子路由 */
      children: Route[];
      /** 路由描述 */
      meta: RouteMeta;
    }
  : never;

/** 前端导入的路由模块 */
// type RouteModule = Record<string, { default: Route }>;

/** 路由描述 */
interface RouteMeta {
  /** 路由标题(可用来作document.title或者菜单的名称) */
  title: string;
  /** 用来支持多国语言 如果i18nTitle和title同时存在优先使用i18nTitle */
  i18nTitle?: string;
  /** 路由的动态路径(需要动态路径的页面需要将path添加进范型参数) */
  dynamicPath?: string;
  /** 作为单级路由的父级路由布局组件 */
  singleLayout?: 'basic' | 'blank';
  /** 需要登录权限 */
  requiresAuth?: boolean;
  /**
   * 哪些类型的用户有权限才能访问的路由(空的话则表示不需要权限)
   * @description 后端动态路由数据不需要该属性，直接由后端根据用户角色返回对应权限的路由数据
   */
  permissions?: string[];
  /** 缓存页面 */
  keepAlive?: boolean;
  /** 菜单和面包屑对应的图标 */
  icon?: string;
  /** 使用本地svg作为的菜单和面包屑对应的图标(assets/svg-icon文件夹的的svg文件名) */
  localIcon?: string;
  /** 是否在菜单中隐藏(一些列表、表格的详情页面需要通过参数跳转，所以不能显示在菜单中) */
  hide?: boolean;
  /** 外链链接 */
  href?: string;
  /** 是否支持多个tab页签(默认一个，即相同name的路由会被替换) */
  multiTab?: boolean;
  /** 路由顺序，可用于菜单的排序 */
  order?: number;
  /** 当前路由需要选中的菜单项(用于跳转至不在左侧菜单显示的路由且需要高亮某个菜单的情况) */
  activeMenu?: string;
  /** 表示是否是多级路由的中间级路由(用于转换路由数据时筛选多级路由的标识，定义路由时不用填写) */
  multi?: boolean;
  /** 是否固定在tab卡不可关闭  */
  affix?: boolean;
  /** Schema Api */
  schemaApi?: string;
  /** source soy|amis */
  source?: string;
}

/**
 * Model=> admin.menu (菜单表)
 *
 * Table=> admin_menu (菜单表)
 */
interface admin_menu {
  /** ID */
  id?: number;
  /** 父级 */
  parent?: number;
  /** 菜单名称 */
  name: string;
  /** 标题 */
  title: string;
  /** 图标 */
  icon?: string;
  /** 路由 */
  url?: string;
  /** 路由类型 */
  url_type?: number;
  /** 组件 */
  component?: string;
  /** 作为单级路由的父级路由布局组件 */
  single_layout?: 'basic' | 'blank';
  /** 缓存页面 */
  keep_alive?: boolean;
  /** 重定位 */
  redirect?: string;
  /** 重渲染 */
  rewrite?: string;
  /** 默认页面 */
  is_default_page?: boolean;
  /** 页面的配置 */
  schema?: object;
  /** 配置接口 */
  schema_api?: string;
  /** 是否可见 */
  visible?: boolean;
  /** 排列 */
  rank?: number;
  /** 类名 */
  class_name?: string;
  /** 状态 */
  status?: string;

  /** 需要权限 */
  requires_auth?: boolean;
  /** 来源 */
  source: string;
  /** Relation: children=> admin.menu */
  children?: admin_menu[];
}
