import { GetNodeItems, GetNodes, UpdateNode, DeleteNode, CreateNode } from "@scripts/amis/data/tree";

/**
 * yao run scripts.system.tree.GetTreeNodes admin.menu
 * @returns
 */
function GetTreeNodes(model, querys) {
  return GetNodes(model, querys);
}

/**
 * amis input-tree增加一个节点
 * 
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
 * 
 * yao run scripts.system.tree.UpdateTreeNode admin.menu '::{}'
 * @param {integer} id 菜单节点ID
 * @param {*} menuNode 菜单节点，没有携带id信息
 * @returns
 */
function UpdateTreeNode(model, id, menuNode) {
  return UpdateNode(model, id, menuNode);
}
//
// 删除根节点 yao run scripts.system.tree.DeleteTreeNode admin.menu 3
// 删除节点与及所有的子节点
/**
 * 
 * @param {*} model 
 * @param {*} ids 
 * @returns 
 */
function DeleteTreeNode(model, ids) {
  return DeleteNode(model, ids);
}

/**
 * 根据特定的id获取菜单节点以及所有的子节点
 * 
 * yao run scripts.system.tree.GetNodeItems admin.menu 1
 * @param {*} model 
 * @param {*} id 
 * @returns 
 */
function GetTreeNodeItems(model, id) {
  return GetNodeItems(model, id);
}
