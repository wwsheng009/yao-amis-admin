const { deleteObjectKey } = Require("system.lib");
const { ClearFalsyKeys } = Require("amis.lib_tool");
const { updateSoyRouteComponent } = Require("admin.menu_lib");
const { filterTreeDataWithFunc } = Require("amis.data.tree");
const { getUserAuthMenuIds } = Require("auth.lib");
/**
 * 处理用户的菜单
 * 功能一，读取本地数据库中的菜单配置,转换成soy-admin菜单
 * 功能二，读取本地文件目录/data/pages,转换成soy-admin菜单
 * 功能三，读取本地文件目录/data/amis_editor,转换成soy-admin菜单
 *
 * */
const PagesLocation = "/pages";
const WorkingPagesLocation = "/amis_editor";
/**
 * get user auth menus
 * yao run scripts.admin.menu.getUserAuthMenu
 */
function getSoyAdminUserMenu() {
    let user = Process("session.get", "user");
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
 * yao run scripts.admin.menu.reLoadAndSaveMenus
 * 重新加载菜单列表
 */
function reLoadAndSaveMenus() {
    saveSoyRoutesToDB();
    // 导入本地开发的页面
    saveLocalAmisSoyRoutesToDB();
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
 * 超级管理员的菜单列表，如果数据库中没有，直接读取系统默认的设置
 * yao run scripts.admin.menu.getSoySuperUserMenu
 * @returns 用户菜单
 */
function getSoySuperUserMenu() {
    let routes = getSoyRoutesFromDB();
    if (routes.length === 0) {
        const routesSoy = Process("scripts.amis.site.MenuSoybean")["routes"];
        const routesLocal = getAmisLocalPageAsSoyRoutes();
        const localRoutes = [...routesSoy, ...routesLocal];
        return cleanUpRouteMenu(localRoutes);
    }
    // 转换成树结构
    routes = Process(`utils.arr.Tree`, routes, { parent: "parent", empty: 0 });
    // 导入正在编辑的页面
    const editor_routes = Process("scripts.admin.menu.getAmisEditorSoyRoute");
    routes = routes.concat(editor_routes);
    return cleanUpRouteMenu(routes);
}
/**
 * 读取数据库中所有的菜单配置列表
 * @returns []Route
 */
function getSoyRoutesFromDB() {
    // 优先从数据库读取菜单
    let menus = Process("models.admin.menu.get", {});
    let menus2 = menus.map((menu) => {
        let r = {
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
                source: menu.source, //提供后续的导入支持
            },
            children: [],
        };
        // 外链
        if (menu.url_type == 2) {
            r.meta.href = menu.url;
        }
        else if (menu.url_type == 3) {
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
 * 导出数据库中的菜单，由于导入本地菜单时的描述信息没有，可以编辑好菜单后导出成文件
 * yao run scripts.admin.menu.exportMenus
 */
function exportMenus(pathIn) {
    const folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    const path = pathIn || `/upload/public/system_menus_${folder}.json`;
    let routes = getSoyRoutesFromDB();
    routes = Process(`utils.arr.Tree`, routes, { parent: "parent", empty: 0 });
    const json = JSON.stringify(routes, null, 2);
    Process("fs.system.writefile", path, json);
    return `Menu Saved to ${path}`;
}
/**
 * 导入菜单
 * yao run scripts.admin.menu.importMenus
 * @param pathIn import menu path
 */
function importMenus(pathIn) {
    const folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    const path = pathIn || `/upload/public/system_menus_${folder}.json`;
    const json = Process("fs.system.readfile", path);
    const routes = JSON.parse(json);
    saveTreeMenusToDB(routes, undefined, false);
}
/**
 * 保存本地的页面到数据库
 * yao run scripts.admin.menu.saveLocalAmisSoyRoutesToDB
 */
function saveLocalAmisSoyRoutesToDB() {
    const routes = getAmisLocalPageAsSoyRoutes();
    saveTreeMenusToDB(routes, "amis", false);
}
/**
 * 将Soyadmin的系统菜单作转换并导入到数据库
 * yao run scripts.admin.menu.saveSoyRoutesToDB
 */
function saveSoyRoutesToDB() {
    // 导入前端本身的菜单
    const routes = Process("scripts.amis.site.MenuSoybean")["routes"];
    saveTreeMenusToDB(routes, "soy", false);
}
/**
 * 获取文件系统中的页面，根据文件目录结构转换成Soy菜单结构
 * yao run scripts.admin.menu.getAmisLocalPageAsSoyRoutes
 * @returns []
 */
function getAmisLocalPageAsSoyRoutes() {
    const fs = new FS("system");
    let files = fs.ReadDir(PagesLocation, true); // recursive
    files = files.filter((x) => x.length > 5 && x.endsWith(".json"));
    files = files.map((f) => {
        f = f.replace(/\\/g, "/");
        return f.substring(PagesLocation.length);
    });
    const routes = convertFileListToSoyRoute(files);
    updateSoyRoutePath("/api/v1/amis/pages/", routes, undefined);
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
    updateSoyRouteComponent(rootRoutes);
    return rootRoutes;
}
/**
 *根据页面ID，获取Amis的页面源代码
 * yao run scripts.admin.menu.getAmisPageSchema
 * @param pageId
 * @returns
 */
function getAmisPageSchema(pageId) {
    let page = pageId.replace(".", "/") + ".json";
    const fpath = PagesLocation + "/" + page;
    let isExist = Process("fs.system.Exists", fpath);
    if (!isExist) {
        throw new Exception(`文件不存在：${fpath}`);
    }
    let str = Process("fs.system.ReadFile", fpath);
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
function getAmisEditorPageSource(pageId) {
    let user_id = Process("session.get", "user_id");
    let dir = `${WorkingPagesLocation}/${user_id}/`;
    dir = dir.replace(/\\/g, "/");
    dir = dir.replace(/\/\//g, "/");
    pageId = pageId.replace(/^amis_editor\./, "");
    let page = pageId.replace(".", "/") + ".json";
    const fpath = dir + page;
    let isExist = Process("fs.system.Exists", fpath);
    if (!isExist) {
        throw new Exception(`文件不存在：${fpath}`);
    }
    let str = Process("fs.system.ReadFile", fpath);
    let source = JSON.parse(str);
    if (source.type === "app") {
        return {
            type: "tpl",
            tpl: "不能显示类型为app的页面",
        };
    }
    return JSON.parse(str);
}
// yao run scripts.admin.menu.getAmisEditorSoyRoute
function getAmisEditorSoyRoute() {
    let user_id = Process("session.get", "user_id");
    if (!user_id) {
        // return [];
        user_id = "1";
    }
    let dir = `${WorkingPagesLocation}/${user_id}/`;
    dir = dir.replace(/\\/g, "/");
    dir = dir.replace(/\/\//g, "/");
    const fs = new FS("system");
    let files = [];
    // 这里包装了一个顶层
    const rootRoutes = [
        {
            name: "amis_editor",
            path: "/amis_editor",
            subPath: "amis_editor",
            component: "basic",
            children: [],
            meta: { order: 2001, requiresAuth: true, title: "AMIS编辑器" },
        },
    ];
    if (fs.Exists(dir)) {
        files = fs.ReadDir(dir, true); // recursive
        files = files.filter((x) => x.length > 5 && x.endsWith(".json"));
        let regex = new RegExp(`^${dir}`, "i");
        files = files.map((f) => {
            f = f.replace(/\\/g, "/");
            return f.replace(regex, "/amis_editor/");
        });
        const routes = convertFileListToSoyRoute(files);
        // 这里比较特殊，不要更新amis_editor节点
        updateSoyRoutePath("/api/v1/amis/edit_pages/", routes, undefined);
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
function convertListToSoyRoute(list) {
    let order = 1000;
    const result = {
        name: "",
        path: "",
        component: "basic",
        subPath: "", //单一层级的节点
        children: [],
        meta: { title: "", order: order, requiresAuth: true },
    };
    const getPath = (url) => url
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
    const addSubPath = (obj, subPathArr) => {
        let tempObj = obj;
        for (let i = 0; i < subPathArr.length; i++) {
            const subPath = subPathArr[i];
            const existingObj = tempObj.children.find((child) => child.subPath === subPath);
            if (existingObj) {
                tempObj = existingObj;
            }
            else {
                const newChild = {
                    name: "", //update later
                    subPath: subPath,
                    // fullpath: `${tempObj.fullpath}/${subPath}`,
                    path: tempObj.subPath ? `${tempObj.subPath}.${subPath}` : subPath,
                    children: [],
                    meta: { requiresAuth: true, title: subPath },
                };
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
function convertFileListToSoyRoute(list) {
    const result = convertListToSoyRoute(list);
    //   小心处理层级
    removeEmptyChildren(result);
    return result.children || [];
}
function removeEmptyChildren(node) {
    if (node.children?.length === 0) {
        delete node.children;
        if (Object.keys(node.meta).length === 0) {
            delete node.meta;
        }
    }
    else {
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
function updateSoyRoutePath(api, route, parent) {
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
    }
    else {
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
 * @param menus 菜单，树形结构
 * @param source 来源 soy|amis
 * @param deleteFlag 是否删除
 */
function saveTreeMenusToDB(menus, source = "amis", deleteFlag) {
    function traverse(route, parentId) {
        if (Array.isArray(route)) {
            route.forEach((r) => traverse(r, 0));
            return;
        }
        if (deleteFlag) {
            Process("models.admin.menu.deletewhere", {
                wheres: [
                    {
                        column: "name",
                        value: route.name,
                    },
                ],
            });
        }
        route.meta = route.meta || {};
        let menu = {
            name: route.name,
            title: "",
            source: route.meta.source || source,
        };
        // 根据路由的名称进行判断，如果已经存在，进行更新
        if (route.name) {
            let [menudb] = Process("models.admin.menu.get", {
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
        let id = Process("models.admin.menu.save", menu);
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
function getAmisRoutesFromDB() {
    let menus = Process("models.admin.menu.get", {
        wheres: [{ column: "source", value: "amis" }],
    });
    let menus2 = menus.map((menu) => {
        let route = {
            id: menu.id, //required
            parent: menu.parent, //required
            label: menu.title,
            url: menu.url_type === 3 ? menu.url : undefined, //amis menu type
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
 * 从数据库中读取Aims App的用户菜单配置，超级管理员可以访问所有的菜单列表
 * yao run scripts.admin.menu.getAmisPageRoutesFromDB
 * @returns amis page
 */
function getAmisPageRoutesFromDB() {
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
function convertSoyRoutesToAmisPages(routes) {
    const result = []; // Fix 2: Create new object/array
    const travel = function (r, parent) {
        if (Array.isArray(r)) {
            r.forEach((r) => travel(r, result));
            return;
        }
        let route = {
            label: r.meta?.title || r.name,
            url: r.path,
            icon: r.meta.icon,
            schemaApi: r.children?.length ? undefined : r.meta.schemaApi,
            // schema: menu.schema,
            // rewrite: menu.rewrite,
            visible: !r.meta.hide ? undefined : false,
            // link: menu.url_type === 2 ? menu.url : undefined,
            children: [],
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
function getAmisEditorPages() {
    let routes = getAmisEditorSoyRoute();
    let amsiRoutes = convertSoyRoutesToAmisPages(routes);
    amsiRoutes = ClearFalsyKeys(amsiRoutes);
    return amsiRoutes;
}
// yao run scripts.admin.menu.getAmisPages
function getAmisPages() {
    let routes = getAmisLocalPageAsSoyRoutes();
    let amsiRoutes = convertSoyRoutesToAmisPages(routes);
    amsiRoutes = ClearFalsyKeys(amsiRoutes);
    return amsiRoutes;
}
//# sourceMappingURL=menu.js.map