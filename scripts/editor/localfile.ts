import { FileNameConvert } from '@scripts/system/lib';
import { Process, FS, Exception } from '@yao/yao';

/**
 * 在amis-editor里创建或是修改页面配置后可以先保存成文件，在确定没有问题后再加载到数据库
 */

// 1 防止误操作，在特定的目录下使用editor的创建与编辑，创建好后再手动复制到正式的目录pages
// 2 编辑器的功能比较简单，目录结构不支持嵌套的目录结构
const WorkingPagesLocation = '/amis_editor';
const PagesLocation = '/pages';

function getUserDir() {
  let user_id = Process('session.get', 'user_id');
  if (!user_id) {
    user_id = '1';
  }
  let dir = `${WorkingPagesLocation}/${user_id}/`;
  dir = dir.replaceAll('//', '/');
  Mkdir(dir);
  return dir;
}
// 读取所有的page列表
function getPages(dirIn) {
  let dir = dirIn;
  if (dir == null) {
    dir = getUserDir();
  }
  const fs = new FS('system');
  let files = fs.ReadDir(dir, true); // recursive
  files = files
    .map((str) => {
      str = str.replaceAll('\\', '/');
      str = str.replaceAll('//', '/');
      // console.log("dir:", dir);
      if (str.endsWith('.json') && str.startsWith(dir)) {
        return str.substr(dir.length);
      }
    })
    .filter((x) => x);
  const result = {};

  files.forEach((file) => {
    const dataString = fs.ReadFile(dir + file);
    try {
      const page = JSON.parse(dataString);
      // 不处理多页应用
      if (page.type && page.type !== 'app') {
        const filename = file.replace(/\.json$/, '');
        result[filename] = page;
      } else {
        console.log(`invalid amis file format:${dir + file}`);
        throw new Exception(`invalid amis file format:${dir + file}`);
      }
    } catch (error) {
      console.log(`error when parse json:${dir + file}` + error.message);
    }
  });

  return result;
}

// yao studio run editor.saveFileRecord 1, "xxx/test.json"
function saveFileRecord(user_id, file_name) {
  console.log(`保存文件:${file_name},by userid:${user_id}`);

  if (!user_id || !file_name) {
    return;
  }
  const [record] = Process('models.system.file.get', {
    wheres: [
      { column: 'user_id', value: user_id },
      { column: 'file_name', value: file_name, method: 'where' }
    ],
    limit: 1
  });
  if (!record) {
    Process('models.system.file.save', { user_id, file_name });
  } else {
    // 更新时间
    // console.log(`更新时间${data[0].id}`);
    Process('models.system.file.save', { id: record.id });
  }
}
// yao studio run editor.deleteFileRecord 1, "/public/amis-admin/pages_working/1/测试.json"
function deleteFileRecord(user_id, file_name) {
  console.log(`删除文件:${file_name},by user_id:${user_id}`);
  if (!user_id || !file_name) {
    return;
  }
  Process('models.system.file.deletewhere', {
    wheres: [
      { column: 'user_id', value: user_id },
      { column: 'file_name', value: file_name, method: 'where' }
    ]
  });
}
// 保存数据
function savePage(file, payload) {
  if (!file || !payload) {
    return;
  }
  // 空数据
  if (!payload.body && !payload.type) {
    console.log(`空页面：${file}`);
    return;
  }
  let fname = file;
  if (!fname.toUpperCase().endsWith('.JSON')) {
    fname += '.json';
  }
  const userDir = getUserDir();
  const nfilename = userDir + fname;
  let user_id = Process('session.get', 'user_id');
  if (!user_id) {
    user_id = '1';
  }

  // 备份后再保存
  // 页面变更过于频繁，
  // MoveAndWrite(prefix, fname, payload);
  WriteFile(nfilename, payload);
  // fs.WriteFile(fname, JSON.stringify(payload), "0644");

  // console.log("nfilename", nfilename);
  saveFileRecord(user_id, nfilename);

  return { message: 'Page Saved' };
}
// 删除文件
function deletePage(file) {
  const dir = getUserDir();

  let user_id = Process('session.get', 'user_id');
  if (!user_id) {
    user_id = '1';
  }
  let nfilename = dir + file;
  if (!nfilename.toUpperCase().endsWith('.JSON')) {
    nfilename += '.json';
  }
  deleteFileRecord(user_id, nfilename);

  // 移动到临时目录，而不是真正删除
  return Move(dir, file);
  // fs.remove(fname);
}

// save single page to database
// yao  run scripts.editor.localfile.loadSinglePageToDB site.json
function loadSinglePageToDB(fname) {
  const dir = getUserDir();
  const fs = new FS('system');
  const dataString = fs.ReadFile(dir + fname);
  const page = JSON.parse(dataString);
  if (page.type && page.type !== 'app') {
    // let filename = fname.replace(/\.json$/, "");
    // 不能删除后缀
    Process('widget.save', 'amis', fname, page);
  }
}

// dump the pages form database to file
// yao studio run editor.dumpPagesFromDB
function dumpPagesFromDB() {
  const pages = Process('scripts.editor.getPages');
  for (const key in pages) {
    const page = pages[key];
    if (page.type && page.type !== 'app') {
      savePage(key, page);
    }
  }
}
// yao studio run editor.dumpSinglePageFromDB "tables.json"
function dumpSinglePageFromDB(fname) {
  const page = Process('scripts.editor.getPage', fname);
  if (page.type && page.type !== 'app') {
    savePage(fname, page);
  }
}

/**
 * 创建yao dsl 配置文件，如果已经存在，移动到.trash目录
 *
 * yao studio run model.file.MoveAndWrite
 * @param folder Yao应用目录，相对于Yao App根目录
 * @param file 文件名
 * @param dsl dsl定义对象，会自动的转换成json
 */
function MoveAndWrite(folder, file, dsl) {
  Move(folder, file);
  WriteFile(folder ? `/${folder}/` + file : file, dsl);
}
/**
 * write yao dsl json file
 *
 * yao studio run model.file.WriteFile fname data
 * @param {string} filename json file name
 * @param {object} data
 */
function WriteFile(filename, data) {
  const fs = new FS('system');
  const nfilename = FileNameConvert(filename);
  if (!fs.Exists(nfilename)) {
    const folder = nfilename.split('/').slice(0, -1).join('/');
    if (!fs.Exists(folder)) {
      fs.MkdirAll(folder);
    }
  }
  const res = fs.WriteFile(filename, JSON.stringify(data, null, 2));
  if (res?.code && res?.message) {
    console.log(`保存配置文件失败: ${filename},${res.message}`);
  } else {
    console.log(`保存配置文件成功：${filename}`);
  }
}

/**
 * yao studio run editor.Move
 * 文件复制移动逻辑
 */
function Move(dir, name) {
  let fname = name;
  if (!fname.toUpperCase().endsWith('.JSON')) {
    fname = fname + '.json';
  }
  const sourceFile = dir ? dir + '/' + fname : fname;

  const fs = new FS('system');
  const baseDir = '.trash';
  // 判断文件夹是否存在.不存在就创建

  const newDir = Math.floor(Date.now() / 1000);
  // models的文件移动到
  // 如果已经存在
  if (fs.Exists(sourceFile)) {
    Mkdir(baseDir + '/' + newDir);
    fs.Copy(sourceFile, `${baseDir}/${newDir}/${name}`);
    // 复制完成后,删除文件
    fs.Remove(sourceFile);
    return { message: `成功删除文件:${sourceFile}` };
  } else {
    return { message: `文件:${sourceFile}不存在` };
  }
}
function Mkdir(name) {
  const fs = new FS('system');
  const res = fs.Exists(name);
  if (res !== true) {
    // console.log("make dir:", name);
    fs.MkdirAll(name);
  }
}

//    yao studio run editor.createCurdPage admin.auth.role
//    curl -X POST http://127.0.0.1:5077/service/editor \
//    -H 'Content-Type: application/json' \
//    -H 'Authorization: Bearer <Studio JWT>' \
//    -d '{ "args":["admin.menu"],"method":"createCurdPage"}'
function createCurdPage(table) {
  const page = Process('scripts.amis.curd.curdTemplate', table);

  const fs = new FS('system');
  const fname = WorkingPagesLocation + table + '_amis_page.json';
  if (!page.type) {
    // empty page
    return;
  }
  // 备份后再保存
  fs.WriteFile(fname, JSON.stringify(page), '0644');
  // console.log("page saved:", fname);
}

/**
 * 保存并加载设计的页面到数据库中后，才能使用以下的请求
 * /api/__yao/widget/amis/crud-list/setting
 * yao studio run editor.loadPageToDB
 */
function loadPageToDB() {
  const pages = getPages(PagesLocation);
  for (const key in pages) {
    const page = pages[key];
    let fname = key;
    if (page.type && page.type !== 'app') {
      const compKey = key.toUpperCase();
      if (
        !compKey.endsWith('.JSON') &&
        !compKey.endsWith('.JSONC') &&
        !compKey.endsWith('.YAO') &&
        !compKey.endsWith('.YAM') &&
        !compKey.endsWith('.YAML')
      ) {
        fname += '.json';
      }
      // widget的保存需要文件后缀名。
      // 如果没有后缀名，无法区分文件类型。
      // fname是关键字段，并且有唯一性
      Process('widget.save', 'amis', fname, page);
    }
  }
}
