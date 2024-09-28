import { Exception, FS, log, Process, Require } from '@yao/yao';

const convert = Require('app.blog.xml-js');

// 这里实现了metaweblog的api服务器，可以使用第三方的博客编辑工具把笔记内容推送到系统里。
// 实现的功能：
// 博客内容写表blog.post中
// 博客中的附件，图片自动保存到文件系统，同时返回访问地址，按metablog的协议，会自动的更新文章中的地址引用

// https://www.jsdelivr.com/package/npm/xml-js?path=dist
// https://rpc.cnblogs.com/metaweblog/xxxxxx#metaWeblog.newPost
// https://www.cnblogs.com/mq0036/p/12766789.html

/**
 * handler the blog request
 * scripts.app.blog.web.metaWeblogHandler
 * @param {string} blog blog name,you can create multi blog in the system.
 * @param {object} query
 * @param {object} body payload xmlrpc message
 * @returns xml message
 */
export function metaWeblogHandler(
  blog: string,
  query: { methodName: string | any[] },
  body: string
) {
  // http://localhost:5099/api/v1/blog/reuest
  // 接口协议可以参考cnblog的系统
  // https://rpc.cnblogs.com/metaweblog/wwsheng009
  let method = '';
  if (Array.isArray(query.methodName) && query.methodName.length) {
    method = query.methodName[0];
  }
  let bodyData = null;
  if (body) {
    // console.log('request body', body);
    body = body.replace(/^<\?xml[\s\S]*?\?>/, '');
    // if (body.startsWith('<?xml version="1.0"?>')) {
    //   body = body.slice('<?xml version="1.0"?>'.length);
    // }
    // if (body.startsWith('<?xml version="1.0" encoding="utf-8"?>')) {
    //   body = body.slice('<?xml version="1.0" encoding="utf-8"?>'.length);
    // }
    body = body.replace(/[\n\r]/g, '');

    // console.log('request body after', body);
    const options = { compact: true };
    const jsObject = convert.xml2js(body, options);
    bodyData = convertData(jsObject);
    method = bodyData.methodCall.methodName;
  }
  if (!method) {
    throw new Exception('错误的请求,缺少参数：methodCall');
  }

  const params = bodyData.methodCall.params;

  // console.log('method', method);
  // console.log('params', params);

  let userNamePos = 1;
  let passwordPos = 2;

  if (method === 'blogger.deletePost') {
    // 这个请求有点特殊
    // params[0] 是 appkey
    // params[1] 是post id
    userNamePos = 2;
    passwordPos = 3;
  }
  const userName = params[userNamePos];
  const password = params[passwordPos];

  const result = Process('scripts.amis.user.userVerify', userName, password);
  if (result.code != 200) {
    return getErrorMessage(result.message, result.code);
  }
  const user_id = result.user_id;
  // params[userNamePos] = result.user_id //更新成用户标识
  switch (method) {
    case 'metaWeblog.newMediaObject':
      return newMediaObject(params);
    case 'metaWeblog.newPost':
      return newPost(user_id, params);
    case 'metaWeblog.editPost':
      return editPost(user_id, params);
    case 'metaWeblog.getCategories':
      return getCategories();
    case 'metaWeblog.getRecentPosts':
      return getRecentPosts(user_id, params);
    case 'metaWeblog.getPost':
      return getPost(user_id, params);
    case 'blogger.getUsersBlogs':
      return getUsersBlogs(user_id, blog, params);
    case 'blogger.deletePost':
      return deletePost(user_id, params);
    case 'wp.newCategory':
      return newCategory(params);
    default:
      break;
  }
  return getErrorMessage('方法不支持:' + method);
}
/**
 * 创建新的分类
 * @returns new id
 */
export function newCategory(params: any[]) {
  const postId = params[0];
  if (postId == null || postId == '') {
    return getErrorMessage('更新时需要指定id');
  }
  // string	name
  // string	slug (optional)
  // integer	parent_id
  // string	description (optional)
  const category = params[3];
  const id = Process('models.app.blog.category.save', {
    name: category.name,
    description: category.description,
    parent: category.parent_id
  });

  return getRpcResponse(id);
}
/**
 * 获取用户博客列表
 *
 * yao run scripts.app.blog.webblog.getUsersBlogs 1 'myblog'
 * @returns Array
 */
export function getUsersBlogs(user_id: number, blog: string, params: any) {
  const list = Process('models.app.blog.site.get', {
    wheres: [
      {
        column: 'user_id',
        value: user_id
      },
      {
        column: 'name',
        value: blog
      }
    ]
  });
  if (list.length == 0) {
    list.push({
      id: 1,
      url: 'http://localhost',
      name: 'myblog'
    });
  }
  const bloglist = list.map((l: { id: number; url: string; name: string }) => {
    return {
      blogid: l.id,
      url: l.url,
      blogName: l.name
    };
  });
  return getRpcResponse(bloglist);
}
/**
 * 获取选定的博客文章
 *
 * yao run scripts.app.blog.webblog.getPost '::["1","13"]'
 * @param {object} params
 * @returns
 */
export function getPost(user_id: number, params: any[]) {
  const postId = params[0];
  const user_Id = user_id;
  if (postId == null || postId == '') {
    return getErrorMessage('更新时需要指定id');
  }
  try {
    const [b] = Process('models.app.blog.post.get', {
      wheres: [
        {
          column: 'id',
          value: postId
        },
        {
          column: 'user_id',
          value: user_Id
        }
      ]
    });
    const post = {
      dateCreated: b.created_at,
      description: encodeURIComponent(b.content),
      title: b.title,
      categories: b.category,
      enclosure: '',
      link: '',
      permalink: '',
      postid: b.id,
      source: b.source,
      userid: b.user_id,
      mt_allow_comments: '',
      mt_allow_pings: '',
      mt_convert_breaks: '',
      mt_text_more: '',
      mt_excerpt: '',
      mt_keywords: b.keywords,
      wp_slug: b.wp_slug
    };
    return getRpcResponse(post);
  } catch (error) {
    return getErrorMessage(`ID:${postId}不存在` + error.message);
  }
}

/**
 * 最近的文章列表
 *
 * yao run scripts.app.blog.webblog.getRecentPosts 1 '::[0,1,2,"1"]'
 * @param {object} params
 * @returns
 */
export function getRecentPosts(user_id: number, params: string[]) {
  const numberOfPosts = params[3] ? parseInt(params[3]) : 100; // numberOfPosts
  const blogs = Process('models.app.blog.post.get', {
    wheres: [{ column: 'user_id', value: user_id }],
    orders: [{ column: 'created_at', option: 'desc' }],
    limit: numberOfPosts
  });

  const blogs2 = blogs.map(
    (b: {
      created_at: string;
      content: string | number | boolean;
      title: string;
      category: string;
      id: number;
      source: string;
      user_id: number;
      keywords: string;
      wp_slug: string;
      type: string;
    }) => {
      return {
        dateCreated: b.created_at,
        description: encodeURIComponent(b.content),
        title: b.title,
        categories: b.category || [],
        enclosure: '',
        link: '',
        permalink: '',
        postid: b.id,
        source: b.source,
        userid: b.user_id,
        mt_allow_comments: '',
        mt_allow_pings: '',
        mt_convert_breaks: '',
        mt_text_more: '',
        mt_excerpt: '',
        mt_keywords: b.keywords,
        wp_slug: b.wp_slug,
        type: b.type
      };
    }
  );
  return getRpcResponse(blogs2);
}
//
/**
 * Get the blog category list
 *
 * yao run scripts.app.blog.webblog.getCategories
 * @returns
 */
export function getCategories() {
  const categories = Process('models.app.blog.category.get', {});
  const categories2 = categories.map(
    (c: { description: string; name: string; id: number }) => {
      return {
        description: c.description || c.name,
        categoryid: c.id,
        title: c.name
      };
    }
  );
  return getRpcResponse(categories2);
}
export function deletePost(user_id: number, params: any[]) {
  // console.log("deletePost>>>>>>>>>:", params)
  const postId = params[1];

  if (postId == null || postId == '') {
    return getErrorMessage('删除时需要指定id');
  }
  const count = Process('models.app.blog.post.DeleteWhere', {
    wheres: [
      {
        column: 'id',
        value: postId
      },
      {
        column: 'user_id',
        value: user_id
      }
    ]
  });
  if (count === 0) {
    return getErrorMessage(`ID:${postId}不存在`);
  }
  return getRpcResponse(true);
}

export function editPost(user_id: number, params: any[]) {
  let postId = params[0];
  if (postId == null || postId == '') {
    return getErrorMessage('更新时需要指定id');
  }

  const [postRow] = Process('models.app.blog.post.get', {
    wheres: [
      {
        column: 'id',
        value: postId
      },
      {
        column: 'user_id',
        value: user_id
      }
    ],
    limit: 1
  });

  if (!postRow) {
    return newPost(user_id, params);
    // return getErrorMessage(`ID:${postId}不存在`);
  }

  const post = params[3];
  const content = unicodeToUtf8(post.description);
  const newArticle = {
    id: postId,
    title: post.title,
    content: content,
    keywords: post.mt_keywords,
    wp_slug: post.wp_slug,
    post_type: post.post_type,
    updated_at: formatDate(post.dateCreated),
    source: post.source,
    type: post.type ? post.type : 'html',
    category: getCategoryIdsByName(post.categories),
    user_id: user_id
  };
  postId = Process('models.app.blog.post.save', newArticle);
  return getRpcResponse(postId + '');
  // return getPostNewEditMessage(postId)
}

/**
 * filter the categorys
 * @param categories the categories for the article
 * @returns
 */
function getCategoryIdsByName(categories: string[]): string[] {
  const newNames = [];
  if (!categories || !Array.isArray(categories) || !categories.length) {
    return newNames;
  }
  const categoriesDb = Process('models.app.blog.category.get', {});
  const map = {};
  categoriesDb.forEach((c: { name: string | number; id: number }) => {
    map[c.name] = c.name;
  });

  categories.forEach((n) => {
    if (map[n] != null) {
      newNames.push(map[n]);
    }
  });
  return newNames;
}
export function newPost(user_id: number, params: any[]) {
  const post = params[3];
  const content = unicodeToUtf8(post.description);
  const newArticle = {
    title: post.title,
    content: content,
    keywords: post.mt_keywords,
    wp_slug: post.wp_slug,
    post_type: post.post_type,
    created_at: formatDate(post.dateCreated),
    user_id: user_id,
    type: post.type ? post.type : 'html',
    category: getCategoryIdsByName(post.categories)
  };
  const postId = Process('models.app.blog.post.save', newArticle);
  return getRpcResponse(postId);
  // return getPostNewEditMessage(postId)
}

export function getNormorFileName(fname: string) {
  let filename = fname;
  const info = {
    fname: '',
    ext: ''
  };
  if (!fname) {
    info.fname = Process('utils.str.UUID').replaceAll('-', '');
  } else {
    filename = filename.replace(/\\/g, '/');
    filename = filename.split('/').pop();
    filename = filename.split('@')[0];
    info.ext = filename.split('.').pop();
    filename = filename.split('.').slice(0, -1).join('.');

    const specialChars = /[`~!@#$%^&*()|+\=?;:'",<>\{\}\[\]\\\/]/gi;
    // Remove special characters from the filename
    info.fname = filename.replace(specialChars, '');
  }
  return info.fname + '.' + info.ext;
}

export function newMediaObject(params: any[]) {
  const upLoadData = params[3];
  let filename = upLoadData.name;
  const type = upLoadData.type;
  const bits = upLoadData.bits;
  const fs = new FS('system');
  const folder = new Date().toISOString().slice(0, 10).replace(/-/g, '');

  filename = getNormorFileName(filename);

  const filePath = `${folder}/${filename}`;

  const newFileName = `/upload/public/${filePath}`;
  fs.WriteFileBase64(newFileName, bits);
  const fnameEncode = encodeURIComponent(filePath);
  const fileApi = `/api/v1/fs/public/file/download?name=${fnameEncode}`;

  return getRpcResponse({ url: fileApi });
  // return getUpdateFileMessage(fileApi)
}
export function formatDate(dateString: string | any[]) {
  if (dateString == null || dateString.length < 10) {
    return dateString;
  }
  const year = dateString.slice(0, 4);
  const month = dateString.slice(4, 6);
  const day = dateString.slice(6, 8);
  const time = dateString.slice(9);

  const formattedDate = `${year}-${month}-${day} ${time}`;
  return formattedDate;
}
export function unicodeToUtf8(unicodeString: string | number | boolean) {
  const encodedURI = encodeURIComponent(unicodeString);
  const utf8String = decodeURIComponent(encodedURI);

  return utf8String;
}

export function getErrorMessage(message: string, code = 500) {
  return {
    content: `<?xml version="1.0" encoding="utf-8"?>
            <methodResponse>
                <fault>
                    <value>
                        <struct>
                            <member>
                                <name>faultCode</name>
                                <value>
                                    <int>${code ? code : 500}</int>
                                </value>
                            </member>
                            <member>
                                <name>faultString</name>
                                <value>
                                    <string>${message}</string>
                                </value>
                            </member>
                        </struct>
                    </value>
                </fault>
            </methodResponse>`
  };
}

const convertData = (obj: any) => {
  if (typeof obj !== 'object' || obj === null) {
    return obj;
  }

  if (Array.isArray(obj)) {
    return obj.map((item) => convertData(item));
  }

  const keys = Object.keys(obj);
  if (keys.length === 1) {
    const key = keys[0];
    if (key === '_text') {
      return obj[key];
    }
    if (key === 'value') {
      return convertData(obj[key]);
    }
    const type = key;
    if (type === 'boolean') {
      return obj[key]?._text ? true : false;
    } else if (type === 'string') {
      return obj[key]?._text ? obj[key]?._text : undefined;
    } else if (Object.hasOwnProperty.call(obj[key], '_text')) {
      return obj[key]?._text;
    } else if (Array.isArray(obj[key])) {
      return convertData(obj[key]);
    } else if (type === 'array') {
      const obj1 = convertData(obj[key]['data']);
      if (Array.isArray(obj1)) {
        return obj1;
      }
      return obj1 ? [obj1] : [];
    } else if (type === 'struct') {
      const members = obj[key]['member'];
      const result = {};
      for (const member of members) {
        result[member.name._text] = convertData(
          member.value ? member.value : member
        );
      }
      return result;
    } else {
      obj[key] = convertData(obj[key]);
      return obj;
    }
  } else if (keys.length === 0) {
    return undefined;
  }

  const result = {};
  for (const key of keys) {
    result[key] = convertData(obj[key]);
  }
  return result;
};

export function convertJs2xml(data: any) {
  if (data == null) {
    return '';
  }
  if (Array.isArray(data)) {
    const str = `<value><array><data>${data.map((line) => convertJs2xml(line)).join('')}</data></array></value>`;
    return str;
  }
  // convert struct

  const type = getXmlType(data);

  if (type === 'struct') {
    let template = '';
    for (const key in data) {
      if (Object.hasOwnProperty.call(data, key)) {
        const element = data[key];
        if (element == null) {
          continue;
        }
        const valueStr = convertJs2xml(element);
        template += `<member><name>${key}</name>${valueStr}</member>`;
      }
    }
    return `<value><struct>${template}</struct></value>`;
  } else {
    if (type === 'datetime.iso8601') {
      data = formatDateIso(data);
    }
    return `<value><${type}>${data}</${type}></value>`;
  }
}
export function isDateTimeOrDate(value: string | number | Date) {
  const date = new Date(value);
  // Check if the date is valid
  if (isNaN(date.getTime())) {
    return false;
  }
  // Check if the date has valid time components
  if (
    date.getHours() !== 0 ||
    date.getMinutes() !== 0 ||
    date.getSeconds() !== 0 ||
    date.getMilliseconds() !== 0
  ) {
    return true; // Assuming a datetime
  }
  return false; // Assuming a date
}
export function formatDateIso(dateIn: string | number | Date) {
  const date = new Date(dateIn);
  try {
    const isoString = date.toISOString();
    const formattedDate = isoString.replace(/[:-]/g, '').replace('T', '');
    return formattedDate;
  } catch (error) {
    log.Error('format date error:', error.message);
    return dateIn;
  }
}

function isInteger(value: any): boolean {
  if (typeof value === 'number') {
    return Number.isInteger(value);
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    return !isNaN(parsed) && Number.isInteger(parsed);
  }
  return false;
}

function isFloat(value: any): boolean {
  if (typeof value === 'number') {
    return !Number.isInteger(value);
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    return !isNaN(parsed) && !Number.isInteger(parsed);
  }
  return false;
}

/**
 * get the xml type for the data
 * yao run scripts.app.blog.web.getXmlType
 * @param data any
 * @returns
 */
export function getXmlType(data: unknown) {
  if (data == null) {
    return 'string';
  }
  // if (isInteger(data)) {
  //   return 'int';
  // }
  // if (isFloat(data)) {
  //   return 'double';
  // }
  const type = typeof data;
  switch (type) {
    case 'bigint':
      return 'int';
    case 'boolean':
      return 'boolean';
    case 'function':
      break;
    case 'number':
      if (Number.isInteger(data)) {
        return 'int';
      } else {
        return 'double';
      }
    case 'object':
      return 'struct';
    case 'string':
      if (data.toLowerCase() == 'true' || data.toLowerCase() == 'false') {
        return 'boolean';
      }
      break;
    case 'undefined':
      return 'string';
  }
  if (isDateTimeOrDate(data)) {
    return 'datetime.iso8601';
  }
  return 'string';
}
// const t = getXmlType(1);
// console.log('t');
// yao run scripts.app.blog.web.convertJs2xml true
// yao run scripts.app.blog.web.convertJs2xml 1
// yao run scripts.app.blog.web.convertJs2xml '::{"name":"test"}'
export function getRpcResponse(data: any) {
  const xml = `<?xml version="1.0" encoding="utf-8"?><methodResponse><params><param>${convertJs2xml(data)}</param></params></methodResponse>`;
  // console.log("response:", xml)
  return {
    content: xml
  };
}
