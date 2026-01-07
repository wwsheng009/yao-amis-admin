import { findUser } from '@scripts/user';
import { Process, Exception, Query, FS } from '@yao/yao';

// 禁止使用
// yao run scripts.fs.file.Download '/20231115/微信图片_20220601141654.png'
function Download_abandan(name) {
  const user_id = findUser()?.user_id;
  // const user_id = Process('session.get', 'user_id');
  if (!user_id) {
    throw new Exception('请登录系统', 401);
  }
  name = normalizeFolder(name);
  const uploadDir = '/data/upload';
  const filePath = `${uploadDir}/${user_id}/${name}`;

  const fs = new FS('system');
  if (!fs.Exists(filePath)) {
    throw new Exception('文件不存在', 500);
  }
  // 这里会发生大量的字节数组转换，不要使用！！！！！！
  const buf = fs.ReadFileBuffer(filePath);

  const mimeType = Process('fs.system.MimeType', filePath);
  return {
    content: buf,
    type: mimeType
  };
}

function convertToNestedArray(folderList) {
  // Initialize the root object
  const root = {
    label: '',
    value: '',
    children: []
  };

  // Iterate through each folder path
  for (const folderPath of folderList) {
    // Split the folder path into individual parts
    const parts = folderPath.split('/').filter((part) => part !== '');

    // Initialize the current node as the root
    let currentNode = root;

    // Iterate through each part of the folder path
    for (const part of parts) {
      // Check if the current part already exists as a child
      let foundNode = currentNode.children.find((node) => node.label === part);

      // If the node does not exist, create a new one
      if (!foundNode) {
        foundNode = {
          label: part,
          value: currentNode.value ? `${currentNode.value}.${part}` : part,
          children: []
        };
        currentNode.children.push(foundNode);
      }

      // Update the current node to the found node
      currentNode = foundNode;
    }
  }
  removeEmptyChildren(root);
  return root.children;
}

// Usage example
const folderList = [
  '/pages/admin',
  '/pages/api',
  '/pages/api/crud',
  '/pages/api/demo',
  '/pages/model',
  '/pages/studio'
];

function removeEmptyChildren(node) {
  if (node.children.length === 0) {
    delete node.children;
  } else {
    for (const child of node.children) {
      removeEmptyChildren(child);
    }
  }
}

const nestedArray = convertToNestedArray(folderList);
// console.log(JSON.stringify(nestedArray, null, 2));

// yao run scripts.file.user.normalizeFolder "../"
function normalizeFolder(folder: string) {
  if (folder == null) {
    return '';
  }
  if (typeof folder != 'string' && typeof folder != 'number') {
    return '';
  }

  // Replace occurrences of "../" and "..\\" with an empty string
  // folder = folder.replace(/(\.\.\/|\.\.\\)/g, "");

  // // Replace occurrences of "./" and ".\\" with an empty string
  // folder = folder.replace(/(\.\/|\.\\)/g, "");

  // folder = folder.replace(/[^\w\s.-]/g, "");
  folder = folder.replace(/\.\./g, '');
  folder = folder.replace(/\/+/g, '/');
  folder = folder.replace(/\\+/g, '/');

  return folder;
}
// folder = normalizeFolder("//////");
// folder = normalizeFolder("//");

// folder = normalizeFolder("\\");
// folder = normalizeFolder("\\\\\\\\");

// folder = normalizeFolder("../");
// folder = normalizeFolder("./");
// folder = normalizeFolder("../../");
// folder = normalizeFolder("../");
// console.log(folder);
