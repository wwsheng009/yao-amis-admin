import { curdTemplate } from '@scripts/amis/curd';
import { FileNameConvert } from '@scripts/system/lib';
import { Process, FS, Exception } from '@yao/yao';

/**
 * 在amis-editor里创建或是修改页面配置后可以先保存成文件，在确定没有问题后再加载到数据库
 */

// 1 防止误操作，在特定的目录下使用editor的创建与编辑，创建好后再手动复制到正式的目录pages
// 2 编辑器的功能比较简单，目录结构不支持嵌套的目录结构
const WorkingPagesLocation = '/amis_editor';
const PagesLocation = '/pages';

export function getUserDir() {
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
export function getPages(dirIn: string) {
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

export function saveFileRecord(user_id: number, file_name: string) {
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
// yao run scripts.editor.localfile.deleteFileRecord 1, "/public/amis-admin/pages_working/1/测试.json"
export function deleteFileRecord(user_id: number, file_name: string) {
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
export function savePage(file: string, payload: { body: any; type: string }) {
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
export function deletePage(file: string) {
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
export function loadSinglePageToDB(fname: string) {
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
// yao run scripts.editor.localfil.edumpPagesFromDB
export function dumpPagesFromDB() {
  const pages = Process('scripts.editor.getPages');
  for (const key in pages) {
    const page = pages[key];
    if (page.type && page.type !== 'app') {
      savePage(key, page);
    }
  }
}
// yao run scripts.editor.localfile.dumpSinglePageFromDB "tables.json"
export function dumpSinglePageFromDB(fname: string) {
  const page = Process('scripts.editor.getPage', fname);
  if (page.type && page.type !== 'app') {
    savePage(fname, page);
  }
}

/**
 * 创建yao dsl 配置文件，如果已经存在，移动到.trash目录
 *
 * yao run scripts.editor.localfile.MoveAndWrite
 * @param folder Yao应用目录，相对于Yao App根目录
 * @param file 文件名
 * @param dsl dsl定义对象，会自动的转换成json
 */
export function MoveAndWrite(folder: string, file: string, dsl: any) {
  Move(folder, file);
  WriteFile(folder ? `/${folder}/` + file : file, dsl);
}
/**
 * write yao dsl json file
 *
 * yao run scripts.editor.localfile.WriteFile fname data
 * @param {string} filename json file name
 * @param {object} data
 */
export function WriteFile(filename: string, data: any) {
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
 * yao run scripts.editor.localfile.Move
 * 文件复制移动逻辑
 */
export function Move(dir: string, name: string) {
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
export function Mkdir(name: string) {
  const fs = new FS('system');
  const res = fs.Exists(name);
  if (res !== true) {
    // console.log("make dir:", name);
    fs.MkdirAll(name);
  }
}

//    yao run scripts.editor.localfilecreateCurdPage admin.auth.role
//    curl -X POST http://127.0.0.1:5077/service/editor \
//    -H 'Content-Type: application/json' \
//    -H 'Authorization: Bearer <Studio JWT>' \
//    -d '{ "args":["admin.menu"],"method":"createCurdPage"}'
export function createCurdPage(modelId: string) {
  const page = curdTemplate(modelId, null); //Process('scripts.amis.curd.curdTemplate', table);

  const fs = new FS('system');
  const fname = WorkingPagesLocation + '/' + modelId + '_amis_page.json';
  if (!page.type) {
    // empty page
    return;
  }
  // 备份后再保存
  fs.WriteFile(fname, JSON.stringify(page), '0644');
  // console.log("page saved:", fname);
}

/**
 *根据页面ID，获取Amis的页面源代码
 * yao run scripts.editor.localfile.getAmisPageSchema
 * @param pageId
 * @returns
 */
export function getAmisPageSchema(pageId: string, theme: string) {
  const page = pageId.replaceAll('.', '/') + '.json';

  const fpath = PagesLocation + '/' + page;
  const isExist = Process('fs.system.Exists', fpath);
  if (!isExist) {
    throw new Exception(`文件不存在：${fpath}`);
  }

  let str = Process('fs.system.ReadFile', fpath);
  if (theme === 'dark') {
    str = str.replaceAll('${__editor__theme}', 'vs-dark');
  } else {
    str = str.replaceAll('${__editor__theme}', 'vs');
  }
  const source = JSON.parse(str);
  if (source.type === 'app') {
    return {
      type: 'tpl',
      tpl: '不能显示类型为app的页面'
    };
  }
  return JSON.parse(str);
}

/**
 * yao run scripts.editor.localfile.getAmisEditorPageSource
 * 读取当前用户下的编辑器页面的源代码
 * @param {*} pageId page id
 * @returns
 */
export function getAmisEditorPageSource(pageId: string, userId?: number) {
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }
  let dir = `${WorkingPagesLocation}/${userId}/`;
  dir = dir.replace(/\\/g, '/');
  dir = dir.replace(/\/\//g, '/');

  pageId = pageId.replace(/^amis_editor\./, '');
  //page的id转换成文件路径
  const page = pageId.replaceAll('.', '/') + '.json';

  const fpath = dir + page;
  const isExist = Process('fs.system.Exists', fpath);
  if (!isExist) {
    throw new Exception(`文件不存在：${fpath}`);
  }
  const str = Process('fs.system.ReadFile', fpath);
  const source = JSON.parse(str);
  if (source.type === 'app') {
    return {
      type: 'tpl',
      tpl: '不能显示类型为app的页面'
    };
  }
  return JSON.parse(str);
}

/**
 * yao run scripts.editor.localfile.getPagesFileList
 * @returns
 */
export function getPagesFileList() {
  const fs = new FS('system');
  let files: string[] = fs.ReadDir(PagesLocation, true); // recursive
  files = files.filter((x) => x.length > 5 && x.endsWith('.json'));
  files = files.map((f) => {
    f = f.replace(/\\/g, '/');
    return f.substring(PagesLocation.length);
  });
  return files;
}

/**
 * yao run scripts.editor.localfile.getEditorPagesFileList
 * @returns
 */
export function getEditorPagesFileList(userId: string) {
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    // return [];
    userId = user_id;
  }
  let dir = `${WorkingPagesLocation}/${userId}/`;
  dir = dir.replace(/\\/g, '/');
  dir = dir.replace(/\/\//g, '/');

  const fs = new FS('system');
  let files = [] as string[];

  if (fs.Exists(dir)) {
    files = fs.ReadDir(dir, true); // recursive
    files = files.filter((x) => x.length > 5 && x.endsWith('.json'));
    const regex = new RegExp(`^${dir}`, 'i');
    files = files.map((f) => {
      f = f.replace(/\\/g, '/');
      // return f;
      return f.replace(regex, `${WorkingPagesLocation}/`);
    });
  }
  return files;
}
/**
 * 保存并加载设计的页面到数据库中后，才能使用以下的请求
 * /api/__yao/widget/amis/crud-list/setting
 */
export function loadPageToDB() {
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
