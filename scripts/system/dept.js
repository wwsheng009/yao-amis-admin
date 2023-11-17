const { GetNodeItems, GetNodes, UpdateNode, DeleteNode, CreateNode } =
  Require("amis.data.tree");

// 部门处理
// 复杂嵌套结构处理
/**
 * yao run scripts.system.dept.GetDeptNodes
 * @returns
 */
function GetDeptNodes() {
  return GetNodes("system.dept");
}
/**
 * yao run scripts.system.dept.CreateDeptNode
 * amis input-tree增加一个节点
 * @param idx 增加的节点路径
 * @param parent 父节点
 * @param node 当前节点数据
 * @returns
 */
function CreateDeptNode({ idx, parent, ...node }) {
  return CreateNode("system.dept", { idx, parent, ...node });
}
/**
 * yao run scripts.system.dept.UpdateDeptNode
 * 编辑更新一个部门
 * @param {integer} id 部门节点ID
 * @param {*} newNode 部门节点，没有携带id信息
 * @returns
 */
function UpdateDeptNode(id, menuNode) {
  return UpdateNode("system.dept", id, menuNode);
}
//
// 删除根节点 yao run scripts.system.dept.DeleteDeptNode 3
// 删除节点与及所有的子节点
function DeleteDeptNode(ids) {
  return DeleteNode("system.dept", ids);
  // return { message: "删除成功" };
}

/**
 * 读取一个所有根节点
 * yao run scripts.system.dept.GetDeptNodeItems 1
 * @param {integer} parentId,父节点部门id
 * @returns 所有的部门节点列表
 */
function GetDeptNodeItems(id) {
  return GetNodeItems("system.dept", id);
}
