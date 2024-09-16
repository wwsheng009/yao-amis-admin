import { Process } from '@yao/yao';

// const window = {}
// const convert = Require("blog.xml-js")

// const convert = require('./xml-js')

// yao run scripts.blog.test.test

const originObject = {
  methodCall: {
    methodName: {
      _text: 'metaWeblog.newPost',
    },
    params: {
      param: [
        {
          value: {
            string: {},
          },
        },
        {
          value: {
            string: {
              _text: 'user',
            },
          },
        },
        {
          value: {
            string: {
              _text: 'password',
            },
          },
        },
        {
          value: {
            struct: {
              member: [
                {
                  name: {
                    _text: 'categories',
                  },
                  value: {
                    array: {
                      data: {},
                    },
                  },
                },
                {
                  name: {
                    _text: 'dateCreated',
                  },
                  value: {
                    'dateTime.iso8601': {
                      _text: '20150901T11:10:51',
                    },
                  },
                },
                {
                  name: {
                    _text: 'description',
                  },
                  value: {
                    string: {
                      _text: '\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003cdiv\u003e\u003cspan\u003e开发规范\u003c/span\u003e\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003cdiv\u003e开发包：ZEED\u003c/div\u003e\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003cdiv\u003e\u003cbr\u003e\u003c/div\u003e\u003c/div\u003e\u003cbr /\u003e\u003cbr /\u003e\u003cdiv\u003e\u003ca title="来自为知笔记(Wiz)" href="http://www.wiz.cn/i/2b7cb674"\u003e来自为知笔记(Wiz)\u003c/a\u003e\u003c/div\u003e\u003cbr /\u003e\u003cbr /\u003e',
                    },
                  },
                },
                {
                  name: {
                    _text: 'mt_keywords',
                  },
                  value: {
                    string: {},
                  },
                },
                {
                  name: {
                    _text: 'post_type',
                  },
                  value: {
                    string: {
                      _text: 'post',
                    },
                  },
                },
                {
                  name: {
                    _text: 'title',
                  },
                  value: {
                    string: {
                      _text: '开发规范',
                    },
                  },
                },
              ],
            },
          },
        },
        {
          value: {
            boolean: {
              _text: '1',
            },
          },
        },
      ],
    },
  },
};

const targetObj
= {
  _declaration: {
    _attributes: {
      version: '1.0',
    },
  },
  methodCall: {
    methodName: 'metaWeblog.newPost',
    params: [
      '',
      'user',
      'password',
      {
        categories: [],
        dateCreated: '20230212T10:25:48',
        description: '\u003cdiv\u003e递归删除目录与子目录下所有的node_modules目录\u003c/div\u003e\r\n\u003cdiv\u003e\u0026nbsp;\u003c/div\u003e\r\n\u003cdiv\u003enpx rimraf ./**/node_modules\u003c/div\u003e\r\n\u003cbr /\u003e\u003cbr /\u003e\u003cdiv\u003e\u003ca title="来自为知笔记(Wiz)" href="http://www.wiz.cn/i/2b7cb674"\u003e来自为知笔记(Wiz)\u003c/a\u003e\u003c/div\u003e\u003cbr /\u003e\u003cbr /\u003e',
        post_type: 'post',
        mt_keywords: '',
        title: '2023年2月12日 递归删除目录与子目录下所有的node',
        wp_slug: 'ef66d509a1fbf4f4ed40a17f2978d3f0',
      },
      1,
    ],
  },
};

const convertData = (obj) => {
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
    } if (key === 'value') {
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
          member.value ? member.value : member,
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
const objectSource1 = {
  methodCall: {
    methodName: {
      _text: 'metaWeblog.getRecentPosts',
    },
  },
};
// const targetObj2 = convertData(objectSource1);
// console.log(JSON.stringify(targetObj2, null, 2));
// const targetObj3 = convertData(originObject);
// console.log(JSON.stringify(targetObj3, null, 2));

function convertJs2xml(data) {
  if (Array.isArray(data)) {
    const str = `<value><array><data>${data.map((line) => convertJs2xml(line)).join('')}</data></array></value>`;
    return str;
  }
  // convert struct

  const type1 = getXmlType(data);

  if (type1 === 'struct') {
    let template = '';
    for (const key in data) {
      if (Object.hasOwnProperty.call(data, key)) {
        const element = data[key];
        const valueStr = convertJs2xml(element);
        template += `<member><name>${key}</name>${valueStr}</member>`;
      }
    }
    return `<value><struct>${template}</struct></value>`;
  } else {
    if (type1 === 'datetime.iso8601') {
      data = formatDateIso(data);
    }
    return `<value><${type1}>${data}</${type1}></value>`;
  }
}
function isDateTimeOrDate(value) {
  const date = new Date(value);
  // Check if the date is valid
  if (isNaN(date.getTime())) {
    return false;
  }
  // Check if the date has valid time components
  if (date.getHours() !== 0 || date.getMinutes() !== 0 || date.getSeconds() !== 0 || date.getMilliseconds() !== 0) {
    return true; // Assuming a datetime
  }
  return true; // Assuming a date
}
function formatDateIso(dateIn) {
  const date = new Date(dateIn);
  try {
    const isoString = date.toISOString();
    const formattedDate = isoString.replace(/[:-]/g, '').replace('T', '');
    return formattedDate;
  } catch (error) {
    console.log('format date error:', error.message);
    return dateIn;
  }
}
function getXmlType(data) {
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
    case 'undefined':
      return 'string';
  }
  if (isDateTimeOrDate(data)) {
    return 'datetime.iso8601';
  }
  return 'string';
}
function convertJson2RpcXml(data) {
  const xml = `<?xml version="1.0" encoding="utf-8"?><methodResponse><params><param>${convertJs2xml(data)}</param></params></methodResponse>`;
  console.log('response:', xml);
  return {
    content: xml,
  };
}

const obj1 = [{
  description: 'description',
  htmlUrl: 'http://google.com',
  rssUrl: 'rssUrl123',
  title: 'title',
  categoryid: 1,
}, {
  description: 'description',
  htmlUrl: 'http://baidu.com',
  rssUrl: 'rssUrl222',
  title: 'title222',
  categoryid: 2,
}];

const blogs2
    = [
      {
        categories: [
          '网络测速',
          '网络测速2',
        ],
        dateCreated: '2023-11-24T21:27:59+08:00',
        description: '\u003cp\u003esssssssssddd\u003c/p\u003e',
        enclosure: '',
        link: '',
        mt_allow_comments: '',
        mt_allow_pings: '',
        mt_convert_breaks: '',
        mt_excerpt: '',
        mt_keywords: null,
        mt_text_more: '',
        permalink: '',
        postid: 1,
        source: '',
        title: 'ssssssssssss',
        userid: 1,
        wp_slug: null,
      },
    ];
// const xml1 = convertJson2RpcXml(blogs2)
// console.log(xml1)

function getFileInfoFromName(fname?) {
  let filename = fname;
  const info = {
    fname: '',
    ext: '',
  };
  if (!fname) {
    info.fname = Process('utils.str.UUID').replaceAll('-', '');
  } else {
    filename = filename.replace(/\\/g, '/');
    filename = filename.split('/').pop();
    filename = filename.split('@')[0];
    info.ext = filename.split('.').pop();
    filename = filename.split('.').slice(0, -1).join('.');

    const specialChars = /[`~!@#$%^&*()_|+\-=?;:'",<>\{\}\[\]\\\/]/gi;
    // Remove special characters from the filename
    info.fname = filename.replace(specialChars, '');
  }
  return info.fname + '.' + info.ext;
}

// const fname = getFileInfoFromName("/Open-Live-Writer/5b8202f293a2_700A/01f5e555ed113532f875a1325fac0a.jpg@1280w_1l_2o_100sh_2.jpg")
// const fname2 = getFileInfoFromName("01f5e555ed113532f875a1325fac0a.jpg@1280w_1l_2o_100sh_2.jpg")
// const fname3 = getFileInfoFromName("01f5e555ed113532f875a1325fac0a")
// const fname4 = getFileInfoFromName()
