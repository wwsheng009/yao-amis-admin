import { Exception, FS, Process } from '@yao/yao';

import { PaginateArrayWithQuery } from '@scripts/amis/data/lib';
import { getUserAuthFolderCache, isSuperUser } from '@scripts/auth/lib';
const uploadDir = '/upload';
const userDir = '/user';
const publicDir = '/public';

type Folder = {
  label: string;
  value: string;
  children: Folder[];
};

function buildTree(folders: string[]) {
  const root: Folder = { label: '', children: [], value: '' };

  for (const folder of folders) {
    let currentLevel = root;
    const path = folder.split('/').filter(Boolean);

    for (const folderName of path) {
      let existingFolder = currentLevel.children.find(
        (child) => child.label === folderName,
      );

      if (!existingFolder) {
        const folderPath = `${currentLevel.value}/${folderName}`;
        const newFolder = {
          label: folderName,
          value: folderPath,
          children: [],
        };
        currentLevel.children.push(newFolder);
        existingFolder = newFolder;
      }

      currentLevel = existingFolder;
    }
  }

  return root.children;
}

// function checkUserCanReadAuth(type: string) {
//   if (type === "user" || type === "public") {
//     return true;
//   }
//   // 超级用户没有限制
//   if (isSuperUser()) {
//     return true;
//   }
//   let authObjects = getUserAuthFolderCache();
//   const folder_method = authObjects.folder_method;

//   if (
//     folder_method == null ||
//     folder_method.length == 0 ||
//     folder_method.includes("READ")
//   ) {
//     return true;
//   }
//   return false;
// }

function filterUserAuthFolderList(type: string, folderList: string[]) {
  if (type === 'user' || type === 'public') {
    return folderList;
  }
  // 超级用户没有限制
  if (isSuperUser()) {
    return folderList;
  }

  const authObjects = getUserAuthFolderCache();
  const folder_method = authObjects.method_with_folder;
  console.log('folder_method', folder_method);
  // 未授权
  if (folder_method['ANY'].length == 0 && folder_method['READ'].length == 0) {
    return [];
  }

  const foldersAuth = folder_method['ANY'].concat(folder_method['READ']);
  // console.log("foldersAuth", folder_method);

  // 权限里没有配置前缀，传入的目录一般是全路径。
  const folders: string[] = foldersAuth.map((f: string) => `${uploadDir}${f}`);

  // 比如用户授权了/project/project1/project2,
  // 那么/project/project1/也是应该可以访问的
  // 目录/project/project1/project2/project3 也可以访问
  // 但是目录/project/project3/无法访问
  // console.log("folders>>>1", folders);

  // console.log("folderList>>>1", folderList);
  folderList = folderList.filter((f) =>
    folders.some((f1) => {
      // 权限目录长于需要检查的目录
      if (f1.length > f.length) {
        return f1.startsWith(f);
      } else {
        return f.startsWith(f1);
      }
    }),
  );
  // console.log("folderList>>>2", folderList);

  return folderList;
}
/**
 * 权限检查
 * @param target 需要操作的目录
 * @param operation 权限操作
 */
function targetOperationAuthCheck(
  type: string,
  targetIn: string,
  operation: 'CREATE' | 'DELETE' | 'READ' | 'UPDATE',
) {
  if (type === 'user' || type === 'public') {
    return;
  }
  // 超级用户没有限制
  if (isSuperUser()) {
    return;
  }
  const authObjects = getUserAuthFolderCache();
  // const folders: string[] = authObjects.folders;

  const foldersAuth = authObjects.method_with_folder['ANY'].concat(
    authObjects.method_with_folder[operation] || [],
  );

  const folders: string[] = foldersAuth.map((f: string) => `${uploadDir}${f}`);
  // const folder_method = authObjects.folder_method;

  // // console.log("folder_method", folder_method);
  // if (
  //   Array.isArray(folder_method) &&
  //   folder_method.length > 0 &&
  //   !folder_method.includes(operation)
  // ) {
  //   throw new Exception(`操作:${operation} 未授权`);
  // }
  const target = targetIn.replace(/[\\/]+/g, '/');

  // if (folders == null || folders.length == 0) {
  //   throw new Exception(
  //     `目录:${target.substring(uploadDir.length)} 操作:${operation} 未授权`
  //   );
  // }
  // 目标文件需要在授权的目录清单中
  // console.log("folders", folders);
  // console.log("target", target);
  let found = false;
  found = folders.some((f1) => {
    // 权限目录长于需要检查的目录,说明不是授权的子目录
    if (f1.length > target.length) {
      return false;
    } else {
      // 目标目录的路径包含的授权的目录
      return target.startsWith(f1);
    }
  });

  if (!found) {
    throw new Exception(
      `目录:${target.substring(uploadDir.length)} 操作:${operation} 未授权`, 403,
    );
  }
}
/**
 * 获取需要授权的目录的结构列表
 * yao run scripts.fs.file.getPermissionFolderTree
 */
function getPermissionFolderTree() {
  const rootFolder = uploadDir;

  let list: string[] = Process('fs.system.ReadDir', rootFolder);
  list = list.map((l) => l.replace(/[\\/]+/g, '/'));
  // ignore the list
  list = list.filter((d) => !d.startsWith(`${uploadDir}${userDir}`));
  list = list.filter((d) => !d.startsWith(`${uploadDir}${publicDir}`));

  let all = [] as string[];
  list.forEach((f) => {
    const sublist = Process('fs.system.ReadDir', f, true);
    all = all.concat(sublist);
  });
  // 避免过多的文件层次
  all = all.filter((f) => f.split('/').length <= 10);
  // only the folder
  all = all.filter((f) => Process('fs.system.IsDir', f));
  // remove the prefix
  all = all.map((f) => f.substring(rootFolder.length));
  // return all;
  return buildTree(all);
}
/**
 * write the file operation log
 * @param file_name source file
 * @param file_name2 dest file
 * @param operation
 */
function writeLog(
  file_name: string,
  file_name2: string,
  operation: 'remove' | 'upload' | 'delete_folder' | 'move_folder',
) {
  const user_id = Process('session.get', 'user_id');
  Process('models.system.log.file.save', {
    user_id,
    file_name,
    file_name2,
    operation,
  });
}
/**
 *
 * @param type 用户操作类型，'user'/'public'/'project'
 * @param file file meta info
 * @param folder target folder
 * @returns
 */
function UploadFile(type: string, file: YaoFile, folder: string) {
  const filePath = saveFile(type, file, folder);
  return {
    value: `/api/v1/fs/${type}/file/download?name=${filePath}`,
  };
}

/**
 * 根据操作获取不同的目录
 * @param type operation type
 * @returns
 */
function getFolder(type: string) {
  let filePath = `${uploadDir}/public`;
  switch (type) {
    case 'user':
      const user_id = Process('session.get', 'user_id');
      if (!user_id) {
        throw new Exception('用户未登录');
      }
      filePath = `${uploadDir}${userDir}/${user_id}`;
      break;
    case 'public':
      filePath = `${uploadDir}${publicDir}`;
      break;
    case 'project':
      filePath = `${uploadDir}/project`;
      break;
    default:
      throw new Exception(`文件类型：${type} 未支持`, 500);
    // break;
  }

  if (!Process('fs.system.Exists', filePath)) {
    Process('fs.system.MkdirAll', filePath);
  }
  return filePath;
}
function batchDeleteFile(type: string, payload) {
  const list = payload.items;
  if (!Array.isArray(list)) {
    throw new Exception('输入参数不正确');
  }
  list.forEach((item) => {
    deleteFile(type, item.path);
  });
}
function deleteFile(type: string, name: string) {
  const fname = getFilePath(type, name);

  targetOperationAuthCheck(type, fname, 'DELETE');
  const result = Process('fs.system.Remove', fname);
  writeLog(fname, '', 'remove');
}
function queryEscape(str: string) {
  return encodeURIComponent(str).replace(/[!'()*]/g, function (c) {
    return '%' + c.charCodeAt(0).toString(16);
  });
}

function getBasename(filename: string, noEscape) {
  if (filename == null) {
    return '';
  }
  // Get the last index of the path separator '/'
  const lastIndex = filename.lastIndexOf('/');

  // If the separator is found, return the substring after it
  if (lastIndex !== -1) {
    filename = filename.substring(lastIndex + 1);
  }
  if (noEscape) {
    return filename;
  }
  // If no separator found, return the filename as it is
  return queryEscape(filename);
}
// yao run scripts.fs.file.getFilePath
function getFilePath(type: string, name: string) {
  const filePath = `${getFolder(type)}/${decodeURIComponent(name)}`;
  return filePath;
}

function saveFile(type: string, file: YaoFile, folder: string) {
  if (folder == null || folder == '') {
    folder = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  } else {
    // folder = folder.replace(".", "/");
  }
  folder = normalizeFolder(folder);
  const uploadFolder = `${getFolder(type)}/${folder}`;
  const filePath = `/${uploadFolder}/${file.name}`;

  targetOperationAuthCheck(type, filePath, 'CREATE');
  // 只返回用户的目录下的相对路径
  const filePath2 = `/${folder}/${file.name}`;

  const fs = new FS('system');
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
  fs.Move(file.tempFile, `${filePath}`);

  writeLog(filePath, '', 'upload');

  return filePath2;
  // return fs.Abs(filePath2);
}

/**
 * 根据类型类型获取文件夹列表
 * yao run scripts.fs.file.getFolderList
 * @param type operation type
 * @param parent parent folder
 * @returns
 */
function getFolderList(type: string, parent: string) {
  // 没有读取授权
  // if (!checkUserCanReadAuth(type)) {
  //   return { items: [], total: 0 };
  // }
  const parentDir = normalizeFolder(parent);

  const userDir = getFolder(type);

  const uploadFolder
    = parentDir != '' ? `${userDir}/${parentDir}/` : `${userDir}/`;

  if (!Process('fs.system.Exists', uploadFolder)) {
    return [];
  }
  let list = Process('fs.system.ReadDir', uploadFolder);
  list = list.map((l: string) => l.replace(/[\\/]+/g, '/'));
  let list2 = list.filter((dir: string) => Process('fs.system.isDir', dir));

  list2 = filterUserAuthFolderList(type, list2);
  list2 = list2.map((dir: string) => {
    const d = dir.replace(uploadFolder, '');
    return {
      label: d,
      value: parent != '' ? parent + '/' + d : d,
      defer: true,
    };
  });

  return list2;
  // return convertToNestedArray(list2);
}

function getTimeFormat(unixTime) {
  const date = new Date(unixTime * 1000);

  // Extract the various date and time components
  const year = date.getFullYear();
  const month = date.getMonth() + 1; // Months are zero-based, so add 1
  const day = date.getDate();
  const hour = date.getHours();
  const minute = date.getMinutes();
  const second = date.getSeconds();

  // Format the date and time as a string
  const formattedDate = `${year}-${month.toString().padStart(2, '0')}-${day
    .toString()
    .padStart(2, '0')}`;
  const formattedTime = `${hour.toString().padStart(2, '0')}:${minute
    .toString()
    .padStart(2, '0')}:${second.toString().padStart(2, '0')}`;

  // Output the formatted date and time
  // console.log(`Formatted Date: ${formattedDate}`);
  // console.log(`Formatted Time: ${formattedTime}`);
  return `${formattedDate} ${formattedTime}`;
}

/**
 * 文件搜索，分页
 * yao run scripts.fs.file.fileSearch
 * @param type 类型，required
 * @param parentFolder 目录,parent folder
 * @param querysIn 查询条件
 * @param payload 查询条件
 * @returns
 */
function fileSearch(type: string, parentFolder: string, querysIn, payload) {
  // 没有读取授权
  // if (!checkUserCanReadAuth(type)) {
  //   return { items: [], total: 0 };
  // }
  if (parentFolder == null) {
    parentFolder == '';
  }

  parentFolder = normalizeFolder(parentFolder);
  const userFolder = getFolder(type);
  const uploadFolder = `${userFolder}/${parentFolder}/`;
  let list = Process('fs.system.ReadDir', uploadFolder, true);
  list = list.map((l: string) => l.replace(/[\\/]+/g, '/'));
  list = filterUserAuthFolderList(type, list);

  const list2 = [] as FileList[];
  let idx = 0;
  list.forEach((f: string) => {
    const isFile = Process('fs.system.IsFile', f);
    if (isFile) {
      const fpath = f.replace(userFolder, '');
      const baseName = getBasename(f, true);
      // const fname = f.replace(uploadFolder, "");
      const mimeType = Process('fs.system.MimeType', f);
      const bytes = Process('fs.system.Size', f);
      const time = Process('fs.system.ModTime', f);
      const date = getTimeFormat(time);

      list2.push({
        id: ++idx,
        size: bytes,
        name: baseName,
        path: fpath,
        url: `/api/v1/fs/${type}/file/download?name=${encodeURIComponent(
          fpath,
        )}`,
        mime: mimeType,
        type: getFileTypeFromMimeType(mimeType),
        time: date,
      } as FileList);
    }
  });

  delete querysIn.folder;
  const { items, total } = PaginateArrayWithQuery(list2, querysIn, payload, [
    'name',
    'time',
    'type',
  ]);

  items.forEach((item) => {
    item.size = convertFileSize(item.size);
  });

  return { items: items, total: total };
}
// yao run scripts.fs.file.getFileList '20231115'
function getFileList(type: string, folder: string, keywords) {
  if (folder == null) {
    folder == '';
  }
  folder = normalizeFolder(folder);
  const userFolder = getFolder(type);
  const uploadFolder = `${userFolder}/${folder}/`;

  let list = Process('fs.system.ReadDir', uploadFolder, true);
  list = list.map((l: string) => l.replace(/[\\/]+/g, '/'));

  const list2 = [] as FileList[];
  list.forEach((f: string) => {
    const isFile = Process('fs.system.IsFile', f);
    if (isFile) {
      const fpath = f.replace(userFolder, '');

      const fname = f.replace(uploadFolder, '');
      const mimeType = Process('fs.system.MimeType', f);
      const bytes = Process('fs.system.Size', f);
      list2.push({
        size: convertFileSize(bytes),
        name: fname,
        path: fpath,
        url: `/api/v1/fs/${type}/file/download?name=${fpath}`,
        mime: mimeType,
        type: getFileTypeFromMimeType(mimeType),
      } as FileList);
    }
  });
  if (keywords != null && keywords != '') {
    return list2.filter((f) =>
      f.name.toLowerCase().includes(keywords.toLowerCase()),
    );
  }
  return list2;
}

function getFileTypeFromMimeType(mimeType) {
  // Remove any additional information after the main MIME type
  const mainType = mimeType.split(';')[0];

  // Map MIME types to human-readable file types
  const typeMap = {
    'application/pdf': 'PDF',
    'image/jpeg': 'Image',
    'image/png': 'Image',
    'image/gif': 'Image',
    'video/mp4': 'Video',
    'audio/aac': 'Audio',
    'audio/mpeg	': 'Audio',
    'text/plain': 'Text Document',
    'application/msword': 'MS WORD',
    'application/vnd.ms-excel': 'MS EXCEL',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      'MS PPT',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      'MS Word',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      'MS Excel',
    'application/x-ole-storage': 'MS WORD',
    'application/zip': 'Zip',
    // Add more MIME types and their corresponding file types as needed
  };

  // Check if the MIME type exists in the typeMap
  if (typeMap.hasOwnProperty(mainType)) {
    return typeMap[mainType];
  } else {
    const partType = mainType.split('/')[0];
    if (partType == 'image') {
      return 'Image';
    } else if (partType == 'video') {
      return 'Video';
    } else if (partType == 'audio') {
      return 'Audio';
    }
    return mimeType;
  }
}
function convertFileSize(fileSizeInBytes: number) {
  const units = ['bytes', 'KB', 'MB', 'GB'];
  let unitIndex = 0;
  let fileSize = fileSizeInBytes;

  while (fileSize >= 1024 && unitIndex < units.length - 1) {
    fileSize /= 1024;
    unitIndex++;
  }

  return `${fileSize.toFixed(2)} ${units[unitIndex]}`;
}
// yao run scripts.fs.file.normalizeFolder "../"
function normalizeFolder(folder: string) {
  if (folder == null) {
    return '';
  }
  if (typeof folder != 'string' && typeof folder != 'number') {
    return '';
  }
  // 安全问题，可以通过../访问非应用目录
  folder = folder.replace(/\.\./g, '');
  folder = folder.replace(/\/+/g, '/');
  folder = folder.replace(/\\+/g, '/');

  return folder;
}
function createFolder(type: string, parent: string, folder: string) {
  if (parent == null || typeof parent != 'string') {
    parent = '';
  }
  // parent = parent.replace(/\./g, "/");

  parent = normalizeFolder(parent);
  folder = normalizeFolder(folder);

  if (folder == '') {
    throw new Exception('目录名不能为空', 500);
  }
  const uploadFolder = `${getFolder(type)}/${parent}/${folder}`;
  targetOperationAuthCheck(type, uploadFolder, 'CREATE');
  const fs = new FS('system');
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
}
function deleteFolder(type: string, folder: string) {
  if (folder == null || folder == '') {
    throw new Exception('目录不正确', 500);
  }
  folder = normalizeFolder(folder);

  const targetFolder = `${getFolder(type)}/${folder}`;

  targetOperationAuthCheck(type, targetFolder, 'DELETE');

  const fs = new FS('system');
  if (fs.Exists(targetFolder)) {
    fs.RemoveAll(targetFolder);
  }
  writeLog(targetFolder, '', 'delete_folder');
}
function moveFolder(type: string, source: string, target: string) {
  if (source == null || source == '') {
    throw new Exception('源目录不能为空');
  }
  if (target == null || target == '') {
    throw new Exception('目标目录不能为空');
  }

  source = normalizeFolder(source);
  target = normalizeFolder(target);

  // source = source.replace(".", "/");
  // target = target.replace(".", "/");

  const sourceFolder = `${getFolder(type)}/${source}`;
  const targetFolder = `${getFolder(type)}/${target}`;

  targetOperationAuthCheck(type, targetFolder, 'UPDATE');
  const fs = new FS('system');

  const targetParent = targetFolder.split('/').slice(0, -1).join('/');
  if (!fs.Exists(targetParent)) {
    fs.MkdirAll(targetParent);
  }
  if (fs.Exists(sourceFolder) && !fs.Exists(targetFolder)) {
    fs.Move(sourceFolder, targetFolder);
  }
  writeLog(sourceFolder, targetFolder, 'move_folder');
}

function convertToNestedArray(folderList: string[]): object[] {
  // Initialize the root object
  const root = {
    label: '',
    value: '',
    defer: true,
    children: [],
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
          defer: true,
          value: currentNode.value ? `${currentNode.value}/${part}` : part,
          children: [],
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

function removeEmptyChildren(node) {
  if (node.children.length === 0) {
    delete node.children;
  } else {
    for (const child of node.children) {
      removeEmptyChildren(child);
    }
  }
}

interface FileList {
  id: number;
  name: string;
  path: string;
  url: string;
  size: string;
  mime: string;
  type: string;
  time: string;
}

interface YaoFile {
  name: string;
  tempFile: string;
  size: number;
  header: {
    [key: string]: object;
    mimeType: {
      'Content-Disposition': string[];
      'Content-Type': string[];
    };
  };
}
