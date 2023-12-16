const { GetNodeItems, GetNodes, UpdateNode, DeleteNode, CreateNode } =
  Require("amis.data.tree");

// 菜单处理
/**
 * yao run scripts.system.menu.GetMenuNodes
 * @returns
 */
function GetMenuNodes() {
  return GetNodes("system.menu");
}

/**
 * amis input-tree增加一个节点
 * yao run scripts.system.menu.CreateMenuNode
 * @param idx 增加的节点路径
 * @param parent 父节点
 * @param node 当前节点数据
 * @returns
 */
function CreateMenuNode({ idx, parent, ...node }) {
  return CreateNode("system.menu", { idx, parent, ...node });
}
/**
 * 编辑更新一个菜单项
 * yao run scripts.system.menu.UpdateMenuNode
 * @param {integer} id 菜单节点ID
 * @param {*} menuNode 菜单节点，没有携带id信息
 * @returns
 */
function UpdateMenuNode(id, menuNode) {
  return UpdateNode("system.menu", id, menuNode);
}
//
// 删除根节点 yao run scripts.system.menu.DeleteMenuNode 3
// 删除节点与及所有的子节点
function DeleteMenuNode(ids) {
  return DeleteNode("system.menu", ids);
}

// yao run scripts.system.menu.GetMenuNodeItems 1
// 根据特定的id获取菜单节点以及所有的子节点
function GetMenuNodeItems(id) {
  return GetNodeItems("system.menu", id);
}

/**
 * 生成xgen的菜单
 * yao run scripts.system.menu.xgenMenu
 */
function xgenMenu() {
  const tabs = Process("scripts.system.meta.getTableListFromApis");
  const menuTab = tabs.map((name, idx) => {
    let setting = Process("yao.table.setting", name);
    let label = setting.name || name;
    return {
      path: `/x/Table/${name}`,
      icon: "icon-activity",
      id: idx + 1000,
      name: label,
      parent: 1000,
    };
  });
  let nodes = [];
  if (menuTab.length) {
    let node = {
      parent: null,
      visible_menu: 0,
      blocks: 1,
      path: `/x/Table/${menuTab[0].name}`,
      icon: "icon-activity",
      id: 1000,
      name: "表数据",
      children: menuTab,
    };
    nodes.push(node);
  }

  const menu = {
    items: [
      {
        parent: null,
        path: "/iframe?src=/amis-admin",
        visible_menu: 0,
        blocks: 0,
        icon: "icon-activity",
        id: 1,
        name: "AMIS管理",
      },
      {
        parent: null,
        path: "/iframe?src=/yao/builder/?page=blog/website/index",
        visible_menu: 0,
        blocks: 0,
        icon: "icon-activity",
        id: 1,
        name: "builder",
      },
      ...nodes,
    ],
    setting: [
      {
        path: "/setting",
        children: [
          {
            id: 10002,
            name: "系统设置",
            path: "/setting",
          },
        ],
        icon: "icon-settings",
        id: 999999,
        name: "设置",
      },
    ],
  };
  return menu;
}
