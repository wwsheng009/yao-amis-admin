import { Exception, Process } from '@yao/yao';
import { YaoQueryParam } from '@yaoapps/types';

// yao run scripts.editor.database.getPages 1
export function getPages(userId?: number) {
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }

  const amisdsl = Process('models.system.amis.page.get', {
    wheres: [
      {
        column: 'user_id',
        value: userId
      }
    ]
  } as YaoQueryParam.QueryParam);
  const result = {};
  amisdsl.forEach((line) => {
    const page = line.source;
    if (page.type && page.type !== 'app') {
      const fname = removeFileExtension(line.file);
      result[fname] = page;
    }
  });
  return result;
}

function removeFileExtension(filename) {
  // Check if the filename contains a period (.)
  const lastDotIndex = filename.lastIndexOf('.');

  // If no dot is found, return the original filename
  if (lastDotIndex === -1) {
    return filename;
  }

  // Otherwise, remove the extension and return the result
  return filename.substring(0, lastDotIndex);
}
/**
 * yao run scripts.editor.database.getPage '404.json' 1
 * @param file
 * @param userId
 * @returns
 */
export function getPage(file: string, userId?: number) {
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }

  const [amisdsl] = Process('models.system.amis.page.get', {
    // https://wwsheng009.github.io/yao-docs/YaoDSL/Query/QueryDsl.html
    // 在flow Query或是js Query中才使用query qsl语法
    // wheres: [{ ":file": "文件", "=": file }],

    // https://wwsheng009.github.io/yao-docs/YaoDSL/Query/QueryParam%E8%AF%AD%E6%B3%95.html
    // 在models处理器传参数时需要使用queryParam语法
    wheres: [
      { column: 'file', value: file },
      {
        column: 'user_id',
        value: userId
      }
    ],
    limit: 1
  } as YaoQueryParam.QueryParam);
  if (!amisdsl) {
    throw new Exception(`页面${file}不存在`);
  }
  return amisdsl?.source || {};
}

/**
 * yao run scripts.editor.database.getPage '404.json' 1
 * @param file
 * @param payload
 * @param userId
 * @returns
 */
export function savePage(file: string, payload, userId?: number) {
  // if (!file.toLowerCase().endsWith('.json')) {
  //   file = file + '.json';
  // }
  if (!payload || !payload.type) {
    // empty page
    throw new Exception('Invalid page config');
    // return;
  }
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }
  const [row] = Process('models.system.amis.page.get', {
    select: ['id'],
    wheres: [
      { column: 'file', value: file },
      {
        column: 'user_id',
        value: userId
      }
    ]
  } as YaoQueryParam.QueryParam);

  const data = {
    id: row?.id,
    user_id: user_id,
    file: file,
    source: payload
  };
  Process('models.system.amis.page.save', data);

  // Process('widget.save', 'amis', file, payload);
}

/**
 * 删除页面
 *
 * yao run scripts.editor.database.deletePage '404.json' 1
 * @param file
 * @param userId
 */
export function deletePage(file: string, userId?: number) {
  // Process('widget.remove', 'amis', file);
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }
  Process('models.system.amis.page.deletewhere', {
    wheres: [
      { column: 'file', value: file },
      {
        column: 'user_id',
        value: userId
      }
    ]
  } as YaoQueryParam.QueryParam);
}

/**
 * yao run scripts.editor.localfile.getAmisEditorPageSource
 * 读取当前用户下的编辑器页面的源代码
 * @param {*} pageId page id
 * @returns
 */
export function getAmisEditorPageSource(pageId: string, userId?: number) {
  pageId = pageId.replace(/^amis_editor\./, '');
  //page的id转换成文件路径
  const pageFileName = pageId.replace('.', '/'); //+ '.json';
  return getPage(pageFileName, userId);
}

/**
 * yao run scripts.editor.database.getEditorPagesFileList
 * @returns
 */
export function getEditorPagesFileList(userId: string) {
  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    userId = user_id;
  }

  const amisdsl = Process('models.system.amis.page.get', {
    select: ['file'],
    wheres: [
      {
        column: 'user_id',
        value: userId
      }
    ]
  } as YaoQueryParam.QueryParam);

  const list = amisdsl.map((f) => {
    return '/amis_editor' + '/' + f.file;
  });
  return list;
}
