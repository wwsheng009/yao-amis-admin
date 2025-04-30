/**
 * 更新路由结构中的上下节点的层次关系，防止错误的设置导致无法显示菜单。
 * ！！一定要更新最顶层的节点
 * @param route 路由节点
 * @param parent 上级路由节点
 * @returns 路由表
 */
export function updateSoyRouteComponent(route, parent?) {
  // 没有子节点，可能是最后的节点或是第一个节点
  if (Array.isArray(route)) {
    route.forEach((n) => updateSoyRouteComponent(n, parent));
    return;
  }
  const hasParent = parent != null ? true : false;
  const hasChildren =
    Array.isArray(route.children) && route.children.length > 0 ? true : false;

  delete route.meta.singleLayout;

  //最上面一层
  if (!hasParent) {
    if (!hasChildren) {
      route.meta.singleLayout = 'basic';
      // 只有一层的菜单
      if (route.meta?.schemaApi) {
        route.component = 'layout.base$view.amis';
      } else if (!route.component.includes('$')) {
        route.component = 'layout.base$view.404';
      }
    } else {
      // 中间一层，一般使用redirect
      route.component = 'layout.base';
    }
  } else {
    //最底一层
    if (!hasChildren) {
      if (route.meta?.schemaApi) {
        route.component = 'view.amis';
      } else {
        route.component = 'view.' + route.component;
      }
    } else {
      // 中间一层，一般使用redirect
      route.component = 'layout.base';
    }
  }

  // 针对于文件系统路径，重新设置路径
  if (route.subPath) {
    if (hasParent) {
      route.path = parent.path + '/' + route.subPath;
    } else {
      route.path = '/' + route.subPath;
    }
    // 将路径中的点号、斜杠替换为下划线，用作路由名称
    route.name = route.path.replace(/[\\./]/g, '_');
    // 如果路由名称以下划线开头
    if (route.name.startsWith('_')) {
      route.name = route.name.substring(1);
    }
  }

  route.path = route.path.replace(/\/\//g, '/');

  if (Array.isArray(route.children) && route.children.length) {
    route.children.forEach((n) => updateSoyRouteComponent(n, route));
  }
}
