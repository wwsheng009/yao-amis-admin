/**
 * 更新路由结构中的上下节点的层次关系，防止错误的设置导致无法显示菜单。
 * ！！一定要更新最顶层的节点
 * @param node 路由节点
 * @param parent 上级路由节点
 * @returns 路由表
 */
export function updateSoyRouteComponent(node, parent) {
  // 没有子节点，可能是最后的节点或是第一个节点
  if (Array.isArray(node)) {
    node.forEach((n) => updateSoyRouteComponent(n, parent));
    return;
  }
  const hasParent = parent != null ? true : false;
  const hasChildren
    = Array.isArray(node.children) && node.children.length > 0 ? true : false;

  delete node.meta.singleLayout;

  if (!hasParent) {
    if (!hasChildren) {
      node.meta.singleLayout = 'basic';
      node.component = 'self';
    } else {
      if (!node.component || node.component === 'self') {
        node.component = 'basic';
      }
    }
  } else {
    if (!hasChildren) {
      if (node.meta.schemaApi && node.meta.schemaApi != '') {
        node.component = 'amis';
      } else {
        node.component = 'self';
      }
    } else {
      node.component = 'multi';
    }
  }

  if (Array.isArray(node.children) && node.children.length) {
    node.children.forEach((n) => updateSoyRouteComponent(n, node));
  }
}
// module.exports = { updateSoyRouteComponent };
