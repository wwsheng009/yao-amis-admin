const { PaginateArrayWithQuery } = Require("amis.data.lib");

const uploadDir = "/upload";

function writeLog(file_name, file_name2, operation) {
  let user_id = Process("session.get", "user_id");
  Process("models.system.log.file.save", {
    user_id,
    file_name,
    file_name2,
    operation,
  });
}
function UploadFile(type: string, file: YaoFile, folder: string) {
  const filePath = saveFile(type, file, folder);
  return {
    value: `/api/v1/fs/${type}/file/download?name=${filePath}`,
  };
}

function getFolder(type: string) {
  let filePath = `${uploadDir}/public`;
  switch (type) {
    case "user":
      let user_id = Process("session.get", "user_id");
      if (!user_id) {
        throw new Exception("用户未登录");
      }
      filePath = `${uploadDir}/${user_id}`;
      break;
    case "public":
      filePath = `${uploadDir}/public`;
    case "project":
      filePath = `${uploadDir}/project`;
      break;
    default:
      throw new Exception(`File Type ${type} is not support`, 500);
    // break;
  }

  if (!Process("fs.system.Exists", filePath)) {
    Process("fs.system.MkdirAll", filePath);
  }
  return filePath;
}
function deleteFile(type: string, name: string) {
  const fname = getFilePath(type, name);

  Process("fs.system.Remove", fname);
  writeLog(fname, "", "remove");

  return;
}
function queryEscape(str) {
  return encodeURIComponent(str).replace(/[!'()*]/g, function (c) {
    return "%" + c.charCodeAt(0).toString(16);
  });
}
function getBasename(filename: string, noEscape) {
  if (filename == null) {
    return "";
  }
  // Get the last index of the path separator '/'
  const lastIndex = filename.lastIndexOf("/");

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
  const filePath = `${getFolder(type)}/${name}`;
  return filePath;
}

function saveFile(type: string, file: YaoFile, folder: string) {
  if (folder == null || folder == "") {
    folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  } else {
    // folder = folder.replace(".", "/");
  }
  folder = normalizeFolder(folder);
  const uploadFolder = `${getFolder(type)}/${folder}`;
  const filePath = `/${uploadFolder}/${file.name}`;

  // 只返回用户的目录下的相对路径
  const filePath2 = `/${folder}/${file.name}`;

  let fs = new FS("system");
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
  fs.Move(file.tempFile, `${filePath}`);

  writeLog(filePath, "", "upload");

  return filePath2;
  // return fs.Abs(filePath2);
}

// yao run scripts.fs.file.getFolderList
function getFolderList(type: string, parent: string) {
  // parent = normalizeFolder(parent);

  // const parentDir = parent.replace(/\./g, "/");
  const parentDir = normalizeFolder(parent);

  const userDir = getFolder(type);

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
  const formattedDate = `${year}-${month.toString().padStart(2, "0")}-${day
    .toString()
    .padStart(2, "0")}`;
  const formattedTime = `${hour.toString().padStart(2, "0")}:${minute
    .toString()
    .padStart(2, "0")}:${second.toString().padStart(2, "0")}`;

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
  if (parentFolder == null) {
    parentFolder == "";
  }
  parentFolder = normalizeFolder(parentFolder);
  let userFolder = getFolder(type);
  const uploadFolder = `${userFolder}/${parentFolder}/`;
  let list = Process("fs.system.ReadDir", uploadFolder, true);
  list = list.map((l) => l.replace(/\\/g, "/"));

  const list2 = [] as FileList[];
  let idx = 0;
  list.forEach((f: string) => {
    const isFile = Process("fs.system.IsFile", f);
    if (isFile) {
      const fpath = f.replace(userFolder, "");
      const baseName = getBasename(f, true);
      // const fname = f.replace(uploadFolder, "");
      const mimeType = Process("fs.system.MimeType", f);
      const bytes = Process("fs.system.Size", f);
      const time = Process("fs.system.ModTime", f);
      const date = getTimeFormat(time);

      list2.push({
        index: ++idx,
        size: bytes,
        name: baseName,
        path: fpath,
        url: `/api/v1/fs/${type}/file/download?name=${fpath}`,
        mime: mimeType,
        type: getFileTypeFromMimeType(mimeType),
        time: date,
      } as FileList);
    }
  });

  delete querysIn.folder;
  const { items, total } = PaginateArrayWithQuery(list2, querysIn, payload, [
    "name",
    "time",
    "type",
  ]);

  items.forEach((item) => {
    item.size = convertFileSize(item.size);
  });

  return { items: items, total: total };
}
// yao run scripts.fs.file.getFileList '20231115'
function getFileList(type: string, folder: string, keywords) {
  if (folder == null) {
    folder == "";
  }
  folder = normalizeFolder(folder);
  let userFolder = getFolder(type);
  const uploadFolder = `${userFolder}/${folder}/`;

  let list = Process("fs.system.ReadDir", uploadFolder, true);
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
        url: `/api/v1/fs/${type}/file/download?name=${fpath}`,
        mime: mimeType,
        type: getFileTypeFromMimeType(mimeType),
      } as FileList);
    }
  });
  if (keywords != null && keywords != "") {
    return list2.filter((f) =>
      f.name.toLowerCase().includes(keywords.toLowerCase())
    );
  }
  return list2;
}

function getFileTypeFromMimeType(mimeType) {
  // Remove any additional information after the main MIME type
  const mainType = mimeType.split(";")[0];

  // Map MIME types to human-readable file types
  const typeMap = {
    "application/pdf": "PDF",
    "image/jpeg": "Image",
    "image/png": "Image",
    "image/gif": "Image",
    "video/mp4": "Video",
    "audio/aac": "audio",
    "audio/mpeg	": "audio",
    "text/plain": "Text Document",
    "application/msword": "MS WORD",
    "application/vnd.ms-excel": "MS EXCEL",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation":
      "MS PPT",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
      "MS Word",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
      "MS Excel",
    "application/x-ole-storage": "MS WORD",
    "application/zip": "Zip",
    // Add more MIME types and their corresponding file types as needed
  };

  // Check if the MIME type exists in the typeMap
  if (typeMap.hasOwnProperty(mainType)) {
    return typeMap[mainType];
  } else {
    const partType = mainType.split("/")[0];
    if (partType == "image") {
      return "Image";
    } else if (partType == "video") {
      return "Video";
    } else if (partType == "audio") {
      return "Audio";
    }
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
// yao run scripts.fs.file.normalizeFolder "../"
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
function createFolder(type: string, parent: string, folder: string) {
  if (parent == null || typeof parent != "string") {
    parent = "";
  }
  // parent = parent.replace(/\./g, "/");

  parent = normalizeFolder(parent);
  folder = normalizeFolder(folder);

  if (folder == "") {
    throw new Exception("目录名不能为空", 500);
  }
  const uploadFolder = `${getFolder(type)}/${parent}/${folder}`;
  let fs = new FS("system");
  if (!fs.Exists(uploadFolder)) {
    fs.MkdirAll(uploadFolder);
  }
}
function deleteFolder(type: string, folder: string) {
  if (folder == null || folder == "") {
    throw new Exception("目录不正确", 500);
  }
  folder = normalizeFolder(folder);

  const uploadFolder = `${getFolder(type)}/${folder}`;
  let fs = new FS("system");
  if (fs.Exists(uploadFolder)) {
    fs.RemoveAll(uploadFolder);
  }
  writeLog(uploadFolder, "", "delete_folder");
}
function moveFolder(type: string, source: string, target: string) {
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

  const sourceFolder = `${getFolder(type)}/${source}`;
  const targetFolder = `${getFolder(type)}/${target}`;

  let fs = new FS("system");

  let targetParent = targetFolder.split("/").slice(0, -1).join("/");
  if (!fs.Exists(targetParent)) {
    fs.MkdirAll(targetParent);
  }
  if (fs.Exists(sourceFolder) && !fs.Exists(targetFolder)) {
    fs.Move(sourceFolder, targetFolder);
  }
  writeLog(sourceFolder, targetFolder, "move_folder");
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
  index: number;
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
      "Content-Disposition": string[];
      "Content-Type": string[];
    };
  };
}
