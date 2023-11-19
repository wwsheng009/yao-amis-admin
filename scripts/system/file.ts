/**
 * 文件管理
 * 文件管理分两部分，一部分是公共资源，没有权限控制，比如在博客中使用的图片文件，就不需要进行登录访问。
 * 第二部分是用户的个人资源，api访问需要登录认证，放在用户id目录下面。
 */

/**
 * yao run scripts.system.file.UploadPublicFile
 * 这里的文件上传是保存在用户的id目录下
 * @param {*} file
 * @returns
 */
function UploadPublicFile(file: YaoFile) {
  const filePath = savePublicFile(file);
  return {
    value: `/api/v1/file/download?name=${filePath}`,
  };
}

function savePublicFile(file: YaoFile) {
  const ext = file.name.split(".").pop();
  // 使用时间戳，防止覆盖，但是同一个文件可能会上传多次
  const timestamp = Date.now();

  let folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  const filename = `/${folder}/${timestamp}.${ext}`;
  const uploadFolder = `/upload/public/${folder}`;

  const fileNameFull = `/upload/public/${filename}`;
  // 只返回目录下的相对路径

  let fs = new FS("system");
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
  fs.Move(file.tempFile, `${fileNameFull}`);

  return filename;
}

// yao run scripts.system.file.getPublicFilePath
function getPublicFilePath(name: string) {
  const filePath = `/upload/public/${name}`;
  return filePath;
}

/**
 * yao run scripts.system.file.Upload
 * 这里的文件上传是保存在用户的id目录下
 * @param {*} file
 * @param {*} folder folder to upload
 * @returns
 */
function UploadUserFile(file: YaoFile, folder: string) {
  const filePath = saveUserFile(file, folder);
  return {
    value: `/api/v1/file/user/file/download?name=${filePath}`,
  };
}

function getUserFolder() {
  let user_id = Process("session.get", "user_id");
  if (!user_id) {
    user_id = "1";
  }
  const filePath = `/upload/${user_id}`;
  if (!Process("fs.system.Exists", filePath)) {
    Process("fs.system.Mkdir", filePath);
  }
  return filePath;
}
function deleteFile(name: string) {
  const fname = getUserFilePath(name);

  return Process("fs.system.Remove", fname);
}
function queryEscape(str) {
  return encodeURIComponent(str).replace(/[!'()*]/g, function (c) {
    return "%" + c.charCodeAt(0).toString(16);
  });
}
function getBasename(filename: string) {
  console.log("getBasename1", filename);

  if (filename == null) {
    return "";
  }
  // Get the last index of the path separator '/'
  const lastIndex = filename.lastIndexOf("/");

  // If the separator is found, return the substring after it
  if (lastIndex !== -1) {
    filename = filename.substring(lastIndex + 1);
  }
  // If no separator found, return the filename as it is
  return queryEscape(filename);
}
// yao run scripts.system.file.getUserFilePath
function getUserFilePath(name: string) {
  const filePath = `${getUserFolder()}/${name}`;
  return filePath;
}

//禁止使用
// yao run scripts.system.file.Download '/20231115/微信图片_20220601141654.png'
function Download_abandan(name: string) {
  let user_id = Process("session.get", "user_id");
  if (!user_id) {
    user_id = "1";
  }
  name = normalizeFolder(name);
  const filePath = `/upload/${user_id}/${name}`;

  let fs = new FS("system");
  if (!fs.Exists(filePath)) {
    throw new Exception("文件不存在", 500);
  }
  // 这里会发生大量的字节数组转换，不要使用！！！！！！
  const buf = fs.ReadFileBuffer(filePath);

  const mimeType = Process("fs.system.MimeType", filePath);
  return {
    content: buf,
    type: mimeType,
  };
}

function saveUserFile(file: YaoFile, folder: string) {
  // const ext = name.split(".").pop();
  // const timestamp = Date.now();
  // const currentDate = new Date().toISOString().slice(0, 10).replace(/-/g, "");

  if (folder == null || folder == "") {
    folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  } else {
    // folder = folder.replace(".", "/");
  }
  folder = normalizeFolder(folder);
  const uploadFolder = `${getUserFolder()}/${folder}`;
  const filePath = `/${uploadFolder}/${file.name}`;

  // 只返回用户的目录下的相对路径
  const filePath2 = `/${folder}/${file.name}`;

  let fs = new FS("system");
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
  fs.Move(file.tempFile, `${filePath}`);

  return filePath2;
  // return fs.Abs(filePath2);
}

// yao run scripts.system.file.getFolderList
function getFolderList(parent: string) {
  // parent = normalizeFolder(parent);

  // const parentDir = parent.replace(/\./g, "/");
  const parentDir = normalizeFolder(parent);

  const userDir = getUserFolder();

  const uploadFolder =
    parentDir != "" ? `${userDir}/${parentDir}/` : `${userDir}/`;

  if (!Process("fs.system.Exists", uploadFolder)) {
    return [];
  }
  let list = Process("fs.system.ReadDir", uploadFolder);
  list = list.map((l) => l.replace(/\\/g, "/"));
  let list2 = list.filter((dir: string) => Process("fs.system.isDir", dir));
  // console.log("list2:", list2);
  list2 = list2.map((dir: string) => {
    const d = dir.replace(uploadFolder, "");

    return {
      label: d,
      value: parent != "" ? parent + "/" + d : d,
      defer: true,
    };
  });

  return list2;
  // return convertToNestedArray(list2);
}
// yao run scripts.system.file.getFileList '20231115'
function getFileList(folder: string) {
  if (folder == null || folder == "") {
    throw new Exception("目录不正确", 500);
    // folder = folder.replace(".", "/");
  }
  folder = normalizeFolder(folder);
  let userFolder = getUserFolder();
  const uploadFolder = `${userFolder}/${folder}/`;

  let list = Process("fs.system.ReadDir", uploadFolder);
  list = list.map((l) => l.replace(/\\/g, "/"));

  const list2 = [] as FileList[];
  list.forEach((f: string) => {
    const isFile = Process("fs.system.IsFile", f);
    if (isFile) {
      const fpath = f.replace(userFolder, "");

      const fname = f.replace(uploadFolder, "");
      const mimeType = Process("fs.system.MimeType", f);
      const bytes = Process("fs.system.Size", f);
      list2.push({
        size: convertFileSize(bytes),
        name: fname,
        path: fpath,
        url: `/api/v1/file/user/file/download?name=${fpath}`,
        mime: mimeType,
        type: getFileTypeFromMimeType(mimeType),
      } as FileList);
    }
  });
  return list2;
}

function getFileTypeFromMimeType(mimeType) {
  // Remove any additional information after the main MIME type
  const mainType = mimeType.split(";")[0];

  // Map MIME types to human-readable file types
  const typeMap = {
    "application/pdf": "PDF Document",
    "image/jpeg": "JPEG Image",
    "image/png": "PNG Image",
    "image/gif": "GIF Image",
    "text/plain": "Text Document",
    "application/msword": "MS Word Document",
    "application/vnd.ms-excel": "MS Excel Spreadsheet",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation":
      "MS PPT",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
      "MS WORD",
    // Add more MIME types and their corresponding file types as needed
  };

  // Check if the MIME type exists in the typeMap
  if (typeMap.hasOwnProperty(mainType)) {
    return typeMap[mainType];
  } else {
    return mimeType;
  }
}
function convertFileSize(fileSizeInBytes: number) {
  const units = ["bytes", "KB", "MB", "GB"];
  let unitIndex = 0;
  let fileSize = fileSizeInBytes;

  while (fileSize >= 1024 && unitIndex < units.length - 1) {
    fileSize /= 1024;
    unitIndex++;
  }

  return `${fileSize.toFixed(2)} ${units[unitIndex]}`;
}
// yao run scripts.system.file.normalizeFolder "../"
function normalizeFolder(folder: string) {
  if (folder == null) {
    return "";
  }
  if (typeof folder != "string" && typeof folder != "number") {
    return "";
  }
  // 安全问题，可以通过../访问非应用目录
  folder = folder.replace(/\.\./g, "");
  folder = folder.replace(/\/+/g, "/");
  folder = folder.replace(/\\+/g, "/");

  return folder;
}
function createFolder(parent: string, folder: string) {
  if (parent == null || typeof parent != "string") {
    parent = "";
  }
  // parent = parent.replace(/\./g, "/");

  parent = normalizeFolder(parent);
  folder = normalizeFolder(folder);

  if (folder == "") {
    throw new Exception("目录名不能为空", 500);
  }
  const uploadFolder = `${getUserFolder()}/${parent}/${folder}`;
  let fs = new FS("system");
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
}
function deleteFolder(folder: string) {
  if (folder == null || folder == "") {
    throw new Exception("目录不正确", 500);
    // folder = folder.replace(/\./g, "/");
  }
  folder = normalizeFolder(folder);

  const uploadFolder = `${getUserFolder()}/${folder}`;
  let fs = new FS("system");
  if (fs.Exists(uploadFolder)) {
    fs.RemoveAll(uploadFolder);
  }
}
function moveFolder(source: string, target: string) {
  if (source == null || source == "") {
    throw new Exception("源目录不能为空");
  }
  if (target == null || target == "") {
    throw new Exception("目标目录不能为空");
  }

  source = normalizeFolder(source);
  target = normalizeFolder(target);

  // source = source.replace(".", "/");
  // target = target.replace(".", "/");

  const sourceFolder = `${getUserFolder()}/${source}`;
  const targetFolder = `${getUserFolder()}/${target}`;

  let fs = new FS("system");

  let targetParent = targetFolder.split("/").slice(0, -1).join("/");
  if (!fs.Exists(targetParent)) {
    fs.MkdirAll(targetParent);
  }
  if (fs.Exists(sourceFolder) && !fs.Exists(targetFolder)) {
    fs.Move(sourceFolder, targetFolder);
  }
}

function convertToNestedArray(folderList: string[]): object[] {
  // Initialize the root object
  const root = {
    label: "",
    value: "",
    defer: true,
    children: [],
  };

  // Iterate through each folder path
  for (const folderPath of folderList) {
    // Split the folder path into individual parts
    const parts = folderPath.split("/").filter((part) => part !== "");

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
  name: string;
  path: string;
  url: string;
  size: string;
  mime: string;
  type: string;
}

interface YaoFile {
  name: string;
  tempFile: string;
  size: number;
  header: {
    [key: string]: object;
    mimeType: {
      "Content-Disposition": string[];
      "Content-Type": string[];
    };
  };
}
