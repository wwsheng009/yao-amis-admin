const { deleteObjectKey } = Require("system.lib");
const { ClearFalsyKeys } = Require("amis.lib_tool");
const { updateSoyRouteComponent } = Require("admin.menu_lib");
const { filterTreeDataWithFunc, filterTreeDataById, collectTreeFields } =
  Require("amis.data.tree");
/**
 * 处理用户的菜单
 * 功能一，读取本地数据库中的菜单配置,转换成soy-admin菜单
 * 功能二，读取本地文件目录/data/pages,转换成soy-admin菜单
 * 功能三，读取本地文件目录/data/amis_editor,转换成soy-admin菜单
 *
 * */

/**
 * 获取用户的授权菜单列表id
 * @returns []
 */
function getUserAuthMenuIds() {
  let user_id = Process("session.get", "user_id");
  if (!user_id) {
    user_id = "1";
  }
  // get user roles
  const user = Process("models.admin.user.find", user_id, {});
  if (user == null) {
    throw new Exception("用户不存在", 500);
  }
  if (user.role == null) {
    throw new Exception("用户未配置角色", 500);
  }
  user.role = typeof user.role === "string" ? user.role.split(",") : user.role;

  if (!Array.isArray(user.role)) {
    // single role
    user.role = [user.role];
  }
  // console.log("user.role", user.role);
  const rolePemissions = user.role.reduce((acc, item) => {
    const role = Process("models.system.auth.role.find", item, {});
    let perms = role.permission;
    if (role && role.status && perms != null) {
      perms = typeof perms === "string" ? perms.split(",") : perms;
      if (!Array.isArray(perms)) {
        perms = [perms];
      }
      acc.push(...perms);
    }
    return acc;
  }, []);

  if (rolePemissions.length == 0) {
    throw new Exception(`角色未配置权限`, 500);
  }
  // console.log("rolePemissions", rolePemissions);

  // get user permissions

  const permissions = Process("models.system.auth.permission.get", {});
  if (permissions.length == 0) {
    throw new Exception(`系统未配置权限`, 500);
  }
  const permissionsTree = Process(`utils.arr.Tree`, permissions, {
    parent: "parent",
    empty: 0,
  });

  const permissionFilter = filterTreeDataById(permissionsTree, rolePemissions);
  // console.log("permissionFilter", permissionFilter);
  if (permissionFilter.length == 0) {
    throw new Exception(`角色未关联任何权限`, 500);
  }
  let menusIds = collectTreeFields(permissionFilter, "menus");

  if (menusIds.length == 0) {
    throw new Exception(`权限未配置菜单`, 500);
  }

  return menusIds;
}
/**
 * get user auth menus
 * yao run scripts.admin.menu.getUserAuthMenu
 */
function getSoyAdminUserMenu() {
  let user = Process("session.get", "user");
  // console.log("user>>>>>>>>>>", user);
  if (user?.type === "super") {
    return getSoySuperUserMenu();
  }

  const menusIds = getUserAuthMenuIds();
  if (menusIds.length) {
    // get menus
    let routes = getSoyRoutesFromDB();
    routes = Process(`utils.arr.Tree`, routes, { parent: "parent", empty: 0 });
    routes = filterTreeDataWithFunc(routes, (item) => {
      return menusIds.includes(item.id) || !item.meta?.requiresAuth;
    });
    return cleanUpRouteMenu(routes);
  }
  return [];
}

/**
 * yao run scripts.admin.menu.saveLoadAndSaveMenus
 */
function saveLoadAndSaveMenus() {
  saveSoyRoutesToDB();
  // 导入本地开发的页面
  saveLocalAmisPagesToDB();
}

function cleanUpRouteMenu(routes) {
  routes.forEach((x) => updateSoyRouteComponent(x));

  deleteObjectKey(routes, "parent");
  deleteObjectKey(routes, "id");

  routes = ClearFalsyKeys(routes);

  let home = "dashboard_analysis";
  if (routes?.length > 0) {
    home = routes[0].name;
  }
  return { routes: routes, home: home };
}
/**
 * 转换SoyAdmin用户菜单
 * yao run scripts.admin.menu.getSoyAdminUserMenu
 * @returns 用户菜单
 */
function getSoySuperUserMenu() {
  let routes = getSoyRoutesFromDB();
  if (routes.length === 0) {
    const routesSoy = Process("scripts.amis.site.MenuSoybean")["routes"];
    const routesLocal = getAmisPagesAsRoute();
    const localRoutes = [...routesSoy, ...routesLocal];

    return cleanUpRouteMenu(localRoutes);
    // saveSoyRoutesToDB();
    // // 导入本地开发的页面
    // saveLocalAmisPagesToDB();
    // routes = getSoyRoutesFromDB();
  }
  // 转换成树结构
  routes = Process(`utils.arr.Tree`, routes, { parent: "parent", empty: 0 });

  // 导入正在编辑的页面
  const editor_routes = Process("scripts.admin.menu.getAmisEditorPagesAsRoute");
  routes = routes.concat(editor_routes);

  return cleanUpRouteMenu(routes);
}

function getSoyRoutesFromDB() {
  // 优先从数据库读取菜单
  let menus: system_menu[] = Process("models.system.menu.get", {});

  let menus2: Route[] = menus.map((menu: system_menu) => {
    let r: Route = {
      id: menu.id, //required
      parent: menu.parent, //required
      name: menu.name || "amis_" + menu.id,
      path: menu.url || "",
      redirect: menu.redirect,

      component: menu.component ? menu.component : "amis",
      meta: {
        title: menu.title || menu.name || "" + menu.id,
        icon: menu.icon,
        order: menu.rank,
        requiresAuth: menu.requires_auth,
      },
      children: [],
    };
    // 外链
    if (menu.url_type == 2) {
      r.meta.href = menu.url;
    } else if (menu.url_type == 3) {
      //amis组件
      r.component = "amis";
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
      r.meta.icon = "icon-park-outline:workbench";
    }
    return r;
  });
  return menus2;
}

/**
 * 保存本地的页面到数据库
 * yao run scripts.admin.menu.saveLocalAmisPagesToDB
 */
function saveLocalAmisPagesToDB() {
  const routes = getAmisPagesAsRoute();
  saveSoyMenusToDB(routes, "amis", false);
}
/**
 * yao run scripts.admin.menu.saveSoyRoutesToDB
 * 将Soyadmin的系统菜单作转换并导入到数据库
 */
function saveSoyRoutesToDB() {
  // 导入前端本身的菜单
  const menus = Process("scripts.amis.site.MenuSoybean")["routes"];
  saveSoyMenusToDB(menus, "soy", true);
}
/**
 * 导入本地正在使用页面
 * yao run scripts.admin.menu.getAmisPagesAsRoute
 * @returns []
 */
function getAmisPagesAsRoute() {
  const fs = new FS("system");
  let files: string[] = fs.ReadDir("/pages", true); // recursive
  files = files.filter((x) => x.length > 5 && x.endsWith(".json"));
  files = files.map((f) => {
    f = f.replace(/\\/g, "/");
    console.log(f);
    return f.substring(`/pages`.length);
  });
  const routes = convertFileListToSoyRoute(files);

  // 这里包装了一个顶层
  const rootRoutes = [
    {
      name: "amis",
      path: "/amis",
      subPath: "amis",
      component: "basic",
      children: routes,
      meta: { order: 2001, requiresAuth: true, title: "AMIS页面" },
    },
  ];
  updateSoyRoutePath("/api/v1/amis/pages/", rootRoutes, undefined);
  updateSoyRouteComponent(rootRoutes);

  return rootRoutes;
}

// yao run scripts.admin.menu.getAmisPage
function getAmisPage(pageId: string) {
  let page = pageId.replace(".", "/") + ".json";
  let str = Process("fs.system.ReadFile", "pages/" + page);
  let source = JSON.parse(str);
  if (source.type === "app") {
    return {
      type: "tpl",
      tpl: "不能显示类型为app的页面",
    };
  }
  return JSON.parse(str);
}

/**
 * yao run scripts.admin.menu.getAmisEditorPageSource
 * 读取当前用户下的编辑器页面的源代码
 * @param {*} pageId page id
 * @returns
 */
function getAmisEditorPageSource(pageId: string) {
  const pagesWorking = "/amis_editor/";

  let user_id = Process("session.get", "user_id");
  let dir = `${pagesWorking}/${user_id}/`;
  dir = dir.replace(/\\/g, "/");
  dir = dir.replace(/\/\//g, "/");

  pageId = pageId.replace(/^amis_editor\./, "");
  let page = pageId.replace(".", "/") + ".json";
  let str = Process("fs.system.ReadFile", dir + page);
  let source = JSON.parse(str);
  if (source.type === "app") {
    return {
      type: "tpl",
      tpl: "不能显示类型为app的页面",
    };
  }
  return JSON.parse(str);
}

// yao run scripts.admin.menu.getAmisEditorPagesAsRoute
function getAmisEditorPagesAsRoute() {
  const pagesWorking = "/amis_editor/";
  let user_id = Process("session.get", "user_id");
  if (!user_id) {
    // return [];
    user_id = "1";
  }
  let dir = `${pagesWorking}/${user_id}/`;
  dir = dir.replace(/\\/g, "/");
  dir = dir.replace(/\/\//g, "/");

  const fs = new FS("system");
  let files = [] as string[];

  // 这里包装了一个顶层
  const rootRoutes = [
    {
      name: "amis_editor",
      path: "/amis_editor",
      subPath: "amis_editor",
      component: "basic",
      children: [] as Route[],
      meta: { order: 2001, requiresAuth: true, title: "AMIS编辑器" },
    },
  ] as Route[];

  if (fs.Exists(dir)) {
    files = fs.ReadDir(dir, true); // recursive
    files = files.filter((x) => x.length > 5 && x.endsWith(".json"));
    let regex = new RegExp(`^${dir}`, "i");
    files = files.map((f) => {
      f = f.replace(/\\/g, "/");
      return f.replace(regex, "/amis_editor/");
    });
    const routes = convertFileListToSoyRoute(files);

    rootRoutes[0].children = routes[0]?.children || [];
  }
  updateSoyRoutePath("/api/v1/amis/edit_pages/", rootRoutes, undefined);
  updateSoyRouteComponent(rootRoutes);
  return rootRoutes;
}

/**
 * 把文件名列表转换成嵌套关系的路由结构
 * @param {string[]} list 文件路径列表
 * @returns []Route
 */
function convertListToSoyRoute(list: string[]): Route {
  let order = 1000;
  const result = {
    name: "",
    path: "",
    component: "basic",
    subPath: "", //单一层级的节点
    children: [],
    meta: { title: "", order: order, requiresAuth: true },
  };

  const getPath = (url: string) =>
    url
      .split("/")
      .filter((path) => path !== "")
      .map((path, index) => {
        if (index === 0 && path.startsWith(".")) {
          return path.substring(1);
        }
        const dotIndex = path.lastIndexOf(".");
        return dotIndex > -1 ? path.substring(0, dotIndex) : path;
      })
      .join("/");

  const addSubPath = (obj: Route, subPathArr: string[]) => {
    let tempObj = obj as Route;
    for (let i = 0; i < subPathArr.length; i++) {
      const subPath = subPathArr[i];
      const existingObj = tempObj.children.find(
        (child) => child.subPath === subPath
      );
      if (existingObj) {
        tempObj = existingObj;
      } else {
        const newChild = {
          name: "", //update later
          subPath: subPath,
          // fullpath: `${tempObj.fullpath}/${subPath}`,
          path: tempObj.subPath ? `${tempObj.subPath}.${subPath}` : subPath,
          children: [],
          meta: { requiresAuth: true, title: subPath },
        } as Route;
        tempObj.children.push(newChild);
        tempObj = newChild;
        tempObj.meta.order = order++;
      }
    }
  };

  list.forEach((url) => {
    const path = getPath(url);
    addSubPath(result, path.split("/"));
  });
  return result;
}

function convertFileListToSoyRoute(list: string[]): Route[] {
  const result = convertListToSoyRoute(list);
  //   小心处理层级
  removeEmptyChildren(result);
  return result.children || [];
}
function removeEmptyChildren(node: Route) {
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
 * @param {string} api api prefix
 * @param {object|[]object} route 路由
 * @param {object|undefined} parent 上级节点
 * @returns
 */
function updateSoyRoutePath(
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
    route.meta.schemaApi = route.meta.schemaApi.replace(/\/\//g, "/");
  }

  if (parent == null) {
    route.path = "/" + route.subPath;
  } else {
    route.path = parent.path + "/" + route.subPath;
  }
  route.path = route.path.replace(/\/\//g, "/");

  route.name = route.path.replace(/[\./-]/g, "_");
  if (route.name.startsWith("_")) {
    route.name = route.name.substring(1);
  }

  if (route.children?.length > 0) {
    route.children.forEach((n) => updateSoyRoutePath(api, n, route));
    route.meta.schemaApi = undefined;
  }
}

/**
 * 保存菜单到数据库
 * @param {[]Route|[]Route} menus 菜单
 * @param {string} source 来源 soy|amis
 * @param {boolean} deleteFlag 是否删除
 */
function saveSoyMenusToDB(
  menus: Route[],
  source: "amis" | "soy",
  deleteFlag: boolean
) {
  function traval(route: Route | Route[], parentId: number) {
    if (Array.isArray(route)) {
      route.forEach((r) => traval(r, 0));
      return;
    }
    if (deleteFlag) {
      Process("models.system.menu.deletewhere", {
        wheres: [
          {
            column: "name",
            value: route.name,
          },
        ],
      });
    }

    route.meta = route.meta || {};

    let menu: system_menu = { name: route.name, title: "", source: source };

    if (route.name) {
      let [menudb] = Process("models.system.menu.get", {
        wheres: [
          {
            column: "name",
            value: route.name,
          },
        ],
      });
      if (menudb != null) {
        menu = menudb;
      }
    }

    menu.name = menu.name || route.name || route.path || "__";
    menu.title = menu.title || route.meta?.title || menu.name;
    menu.url = menu.url || route.path;
    menu.component = menu.component || route.component;
    if (menu.component === "amis") {
      menu.url_type = 3;
    }
    menu.schema_api = menu.schema_api || route.meta?.schemaApi;
    menu.icon = menu.icon || route.meta?.icon;
    menu.visible = menu.visible || !route.meta?.hide;
    menu.rank = menu.rank || route.meta?.order;
    menu.requires_auth =
      menu.requires_auth != null ? menu.requires_auth : route.meta.requiresAuth;

    menu.parent = parentId; //reset parent

    let id = Process("models.system.menu.save", menu);
    // console.log("id==>", id, menu);
    if (Array.isArray(route.children)) {
      route.children.forEach((element) => {
        traval(element, id);
      });
    }
  }
  traval(menus, 0);
}

/**
 * yao run scripts.admin.menu.getAmisRoutesFromDB
 * @returns
 */
function getAmisRoutesFromDB(): AmisAppPage[] {
  // 优先从数据库读取菜单
  let menus: system_menu[] = Process("models.system.menu.get", {
    wheres: [{ column: "source", value: "amis" }],
  });

  let menus2: AmisAppPage[] = menus.map((menu: system_menu) => {
    let route: AmisAppPage = {
      id: menu.id, //required
      parent: menu.parent, //required
      label: menu.title,
      url: menu.url_type === 1 ? menu.url : undefined,
      icon: menu.icon,
      schemaApi: menu.schema_api,
      schema: menu.schema,
      rewrite: menu.rewrite,
      visible: menu.visible,
      link: menu.url_type === 2 ? menu.url : undefined,
      children: [],
    };
    route.url = route.url?.replace(/\/\//g, "/");
    route.schemaApi = route.schemaApi?.replace(/\/\//g, "/");
    return route;
  });
  return menus2;
}

/**
 * yao run scripts.admin.menu.getAmisPagesFromDB
 * @returns amis page
 */
function getAmisPagesFromDB(): AmisAppPage[] {
  let routes = getAmisRoutesFromDB();
  // 转换成树结构
  routes = Process(`utils.arr.Tree`, routes, { parent: "parent", empty: 0 });
  let user = Process("session.get", "user");
  if (user?.type !== "super") {
    const menusIds = getUserAuthMenuIds();
    routes = filterTreeDataWithFunc(routes, (item) => {
      return menusIds.includes(item.id);
    });
  }

  deleteObjectKey(routes, "parent");
  deleteObjectKey(routes, "id");

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

    let route: AmisAppPage = {
      label: r.meta?.title || r.name,
      url: r.path,
      icon: r.meta.icon,
      schemaApi: r.children?.length ? undefined : r.meta.schemaApi,
      // schema: menu.schema,
      // rewrite: menu.rewrite,
      visible: !r.meta.hide ? undefined : false,
      // link: menu.url_type === 2 ? menu.url : undefined,
      children: [] as AmisAppPage[],
    };
    route.url = route.url?.replace(/\/\//g, "/");
    route.schemaApi = route.schemaApi?.replace(/\/\//g, "/");

    if (Array.isArray(r.children)) {
      r.children.forEach((r) => travel(r, route.children));
    }
    parent.push(route);
  };
  travel(routes, result);

  return result;
}

// yao run scripts.admin.menu.getAmisEditorPages
function getAmisEditorPages(): AmisAppPage[] {
  let routes = getAmisEditorPagesAsRoute();
  let amsiRoutes = convertSoyRoutesToAmisPages(routes);
  amsiRoutes = ClearFalsyKeys(amsiRoutes);
  return amsiRoutes;
}
// yao run scripts.admin.menu.getAmisPages
function getAmisPages(): AmisAppPage[] {
  let routes = getAmisPagesAsRoute();
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
  schema?: any;
  schemaApi?: any;

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
      /**子路径 */
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
type RouteModule = Record<string, { default: Route }>;

/** 路由描述 */
interface RouteMeta {
  /** 路由标题(可用来作document.title或者菜单的名称) */
  title: string;
  /** 用来支持多国语言 如果i18nTitle和title同时存在优先使用i18nTitle */
  i18nTitle?: string;
  /** 路由的动态路径(需要动态路径的页面需要将path添加进范型参数) */
  dynamicPath?: string;
  /** 作为单级路由的父级路由布局组件 */
  singleLayout?: "basic" | "blank";
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
}

/**
 * Model=> system.menu (菜单表)
 *
 * Table=> system_menu (菜单表)
 */
interface system_menu {
  /**ID */
  id?: number;
  /**父级 */
  parent?: number;
  /**菜单名称 */
  name: string;
  /**标题 */
  title: string;
  /**图标 */
  icon?: string;
  /**路由 */
  url?: string;
  /**路由类型 */
  url_type?: number;
  /**组件 */
  component?: string;
  /**作为单级路由的父级路由布局组件 */
  single_layout?: "basic" | "blank";
  /**缓存页面 */
  keep_alive?: boolean;
  /**重定位 */
  redirect?: string;
  /**重渲染 */
  rewrite?: string;
  /**默认页面 */
  is_default_page?: boolean;
  /**页面的配置 */
  schema?: any;
  /**配置接口 */
  schema_api?: string;
  /**是否可见 */
  visible?: boolean;
  /**排列 */
  rank?: number;
  /**类名 */
  class_name?: string;
  /**状态 */
  status?: string;

  /** 需要权限 */
  requires_auth?: boolean;
  /**来源 */
  source: string;
  /** Relation: children=> system.menu */
  children?: system_menu[];
}
