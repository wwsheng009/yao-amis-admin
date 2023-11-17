const { GetNodeItems, GetNodes, UpdateNode, DeleteNode, CreateNode } =
  Require("amis.data.tree");

/**
 * yao run scripts.system.tree.GetTreeNodes system.menu
 * @returns
 */
function GetTreeNodes(model, querys) {
  return GetNodes(model, querys);
}

/**
 * amis input-tree增加一个节点
 * yao run scripts.system.tree.CreateTreeNode
 * @param idx 增加的节点路径
 * @param parent 父节点
 * @param node 当前节点数据
 * @returns
 */
function CreateTreeNode(model, { idx, parent, ...node }) {
  return CreateNode(model, { idx, parent, ...node });
}
/**
 * 编辑更新一个菜单项
 * yao run scripts.system.tree.UpdateTreeNode system.menu '::{}'
 * @param {integer} id 菜单节点ID
 * @param {*} menuNode 菜单节点，没有携带id信息
 * @returns
 */
function UpdateTreeNode(model, menuNode) {
  return UpdateNode(model, id, menuNode);
}
//
// 删除根节点 yao run scripts.system.tree.DeleteTreeNode system.menu 3
// 删除节点与及所有的子节点
function DeleteTreeNode(model, ids) {
  return DeleteNode(model, ids);
}

// yao run scripts.system.tree.GetNodeItems system.menu 1
// 根据特定的id获取菜单节点以及所有的子节点
function GetTreeNodeItems(model, id) {
  return GetNodeItems(model, id);
}
