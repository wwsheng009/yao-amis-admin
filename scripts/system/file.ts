/**
 * 文件管理
 */

/**
 * Upload and parse file
 * yao run scripts.system.file.Upload
 * @param {*} file
 * @param {*} folder folder to upload
 * @returns
 */
function Upload(file: YaoFile, folder: string) {
  const filePath = saveFile(file, folder);
  return {
    value: `/api/v1/file/download?name=${filePath}`,
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
function Delete(name: string) {
  const fname = getFilePath(name);

  return Process("fs.system.Remove", fname);
}

// yao run scripts.system.file.getFileName
function getFilePath(name: string) {
  // console.log("filename:", name);
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

function saveFile(file: YaoFile, folder: string) {
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
  const list = Process("fs.system.ReadDir", uploadFolder);

  let list2 = list.filter((dir: string) => Process("fs.system.isDir", dir));
  console.log("list2:", list2);
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

  const list = Process("fs.system.ReadDir", uploadFolder);

  const list2 = [] as FileList[];
  list.forEach((f: string) => {
    const isFile = Process("fs.system.IsFile", f);
    if (isFile) {
      const fpath = f.replace(userFolder, "");

      const fname = f.replace(uploadFolder, "");
      const mimeType = Process("fs.system.MimeType", f);

      list2.push({
        file_name: fname,
        file_path: fpath,
        file_url: `/api/v1/file/download?name=${fpath}`,
        mime_type: mimeType,
      } as FileList);
    }
  });
  return list2;
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
  file_name: string;
  file_path: string;
  file_url: string;
  mime_type: string;
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
