export interface Node {
  label: string;
  value: string;
  children?: Node[];
}

/**
 * 构建层级结构
 * 该函数根据提供的节点数组构建一个层级结构，其中每个节点都包含一个标签和一个值，值表示节点在层级结构中的路径
 * @param {Node[]} items - 要构建层级结构的节点数组
 * @returns {Node[]} - 构建好的层级结构的根节点数组
 */
export function buildHierarchy(items: Node[]): Node[] {
  const root = [] as Node[];

  // 一个递归的辅助函数，根据路径逐层创建树形结构
  function insertNode(
    path: string[],
    label: string,
    value: string,
    parent: Node[]
  ) {
    const [current, ...rest] = path;

    let node = parent.find((item) => item.label === current);

    if (!node) {
      node = {
        label: current,
        value: value.substring(0, value.indexOf(current) + current.length)
      };
      parent.push(node);
    }

    if (rest.length > 0) {
      if (!node.children) {
        node.children = [];
      }
      insertNode(rest, label, value, node.children);
    } else {
      node.label = label;
      node.value = value;
      if (
        items.find((i) => i.value == value) &&
        items.find(
          (i) => i.value.includes(value) && i.value.length > value.length
        ) //存在子节点，并且子节点的value包含当前节点的value
      ) {
        if (!node.children) {
          node.children = [];
        }
        node.children.push({ label, value });
      }
    }
  }

  items.forEach((item) => {
    const path = item.value.split('.'); // 按点号拆分路径
    insertNode(path, item.label, item.value, root);
  });

  return root.map(cleanEmptyChildren); // 移除没有子节点的 children 字段
}

function cleanEmptyChildren(node: Node) {
  if (node.children && node.children.length === 0) {
    delete node.children;
  } else if (node.children) {
    node.children = node.children.map(cleanEmptyChildren);
  }
  return node;
}
