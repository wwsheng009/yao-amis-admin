const convert = Require("blog.xml-js")
// https://www.jsdelivr.com/package/npm/xml-js?path=dist

// https://rpc.cnblogs.com/metaweblog/zhaoqingqing#metaWeblog.newPost

// POST /xmlrpc.php?methodName=metaWeblog.newPost HTTP/1.1

// https://www.cnblogs.com/mq0036/p/12766789.html
const convertData = (obj) => {
    if (typeof obj !== "object" || obj === null) {
        return obj;
    }

    if (Array.isArray(obj)) {
        return obj.map((item) => convertData(item));
    }

    const keys = Object.keys(obj);
    if (keys.length === 1) {
        const key = keys[0];
        if (key === "_text") {
            return obj[key];
        } if (key === "value") {
            return convertData(obj[key]);
        }
        const type = key;
        if (type === 'boolean') {
            return obj[key]?._text ? true : false;
        } else if (type === 'string') {
            return obj[key]?._text ? obj[key]?._text : undefined;
        } else if (Object.hasOwnProperty.call(obj[key], '_text')) {
            return obj[key]?._text
        } else if (Array.isArray(obj[key])) {
            return convertData(obj[key])
        } else if (type === "array") {
            const obj1 = convertData(obj[key]['data']);
            if (Array.isArray(obj1)) {
                return obj1
            }
            return obj1 ? [obj1] : [];
        } else if (type === "struct") {
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
            return obj

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

function metaWeblog(query, body) {

    // http://localhost:5099/api/v1/blog/reuest
    // https://rpc.cnblogs.com/metaweblog/nickchen121
    // https://rpc.cnblogs.com/metaweblog/wwsheng009


    let method = ""
    if (query.methodName && query.methodName[0]) {
        method = query.methodName[0]
    }
    let bodyData = null
    if (body) {
        const options = { compact: true, };
        const jsObject = convert.xml2js(body, options)
        // console.log('jsObject', jsObject)
        bodyData = convertData(jsObject)
        // console.log('bodyData', bodyData)
        method = bodyData.methodCall.methodName;
    }
    if (!method) {
        throw new Exception("错误的请求")
    }
    console.log(`接口请求方法：${method}`,)

    const params = bodyData.methodCall.params;
    const userName = params[1]
    const password = params[2]

    const result = Process("scripts.amis.user.userVerify", userName, password)
    if (result.code != 200) {
        return getErrorMessage(result.message, result.code)
    }
    params[1] = result.user_id //更新成用户标识
    switch (method) {
        case 'metaWeblog.newMediaObject':
            return newMediaObject(params)
        case 'metaWeblog.newPost':
            return newPost(params)
        case 'metaWeblog.editPost':
            return editPost(params)
        case 'metaWeblog.getCategories':
            return getCategories()
        case 'metaWeblog.getRecentPosts':
            return getRecentPosts(params)
        case 'metaWeblog.getPost':
            return getPost(params)
        case 'blogger.getUsersBlogs':
            return getUsersBlogs();
        case 'blogger.deletePost':
            return deletePost(params);
        case 'wp.newCategory':
            return newCategory(params);
        default:
            break;
    }


    console.log(query)
    console.log(body)
    console.log('bodyData:', bodyData)

    return getErrorMessage("方法不支持:" + method)
}
/**
 * 创建新的分类
 * @returns new id
 */
function newCategory() {
    let postId = params[0];
    if (postId == null || postId == "") {
        return getErrorMessage("更新时需要指定id")
    }
    // string	name
    // string	slug (optional)
    // integer	parent_id
    // string	description (optional)
    const category = params[3];
    const id = Process("models.blog.category.save", {
        name: category.name,
        description: category.description,
        parent: category.parent_id
    })

    return convertJson2RpcXml(id)

}
/**
 *  用户博客列表
 * @returns Array
 */
function getUsersBlogs() {
    return convertJson2RpcXml([{
        blogid: 1,
        "url": "http://localhost",
        blogName: "myblog"
    }])
}
/**
 * 获取选定的博客文章
 * yao run scripts.blog.webblog.getPost '::["1","13"]'
 * @param {object} params 
 * @returns 
 */
function getPost(params) {
    let postId = params[0];
    const user_Id = params[1]
    if (postId == null || postId == "") {
        return getErrorMessage("更新时需要指定id")
    }
    try {
        const [b] = Process("models.blog.post.get", {
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
        })
        const post = {
            dateCreated: b.created_at,
            description: encodeURIComponent(b.content),
            title: b.title,
            categories: b.category,
            enclosure: "",
            link: "",
            permalink: "",
            postid: b.id,
            source: b.source,
            userid: b.user_id,
            mt_allow_comments: "",
            mt_allow_pings: "",
            mt_convert_breaks: "",
            mt_text_more: "",
            mt_excerpt: "",
            mt_keywords: b.keywords,
            wp_slug: b.wp_slug,
        }
        return convertJson2RpcXml(post)
    } catch (error) {
        return getErrorMessage(`ID:${postId}不存在`)
    }
}

function getRecentPosts(params) {
    const blogs = Process("models.blog.post.get", {
        wheres: [
            { column: 'user_id', value: params[1] }
        ]
    })

    const blogs2 = blogs.map(b => {
        return {
            dateCreated: b.created_at,
            description: encodeURIComponent(b.content),
            title: b.title,
            categories: b.category || [],
            enclosure: "",
            link: "",
            permalink: "",
            postid: b.id,
            source: b.source,
            userid: b.user_id,
            mt_allow_comments: "",
            mt_allow_pings: "",
            mt_convert_breaks: "",
            mt_text_more: "",
            mt_excerpt: "",
            mt_keywords: b.keywords,
            wp_slug: b.wp_slug,
            type: b.type,
        }
    })
    return convertJson2RpcXml(blogs2)
}
// yao run scripts.blog.webblog.getCategories
function getCategories() {
    const categories = Process("models.blog.category.get", {})
    const categories2 = categories.map(c => { return { description: c.description || c.name, categoryid: c.id, title: c.name } })
    return convertJson2RpcXml(categories2)
}
function deletePost(params) {
    let postId = params[1];

    if (postId == null || postId == "") {
        return getErrorMessage("删除时需要指定id")
    }
    try {
        Process("models.blog.post.delete", postId)
    } catch (error) {
        return getErrorMessage(`ID:${postId}不存在`)
    }
    return convertJson2RpcXml(true);
}

function editPost(params) {
    let postId = params[0];
    if (postId == null || postId == "") {
        return getErrorMessage("更新时需要指定id")
    }
    try {
        Process("models.blog.post.find", postId, {})
    } catch (error) {
        return getErrorMessage(`ID:${postId}不存在`)
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
        type: post.type,
        categories: post.category || [],
        user_id: params[1]
    };
    postId = Process("models.blog.post.save", newArticle)
    return convertJson2RpcXml(postId + "")
    // return getPostNewEditMessage(postId)
}
function newPost(params) {
    const post = params[3];
    const content = unicodeToUtf8(post.description);
    const newArticle = {
        title: post.title,
        content: content,
        keywords: post.mt_keywords,
        wp_slug: post.wp_slug,
        post_type: post.post_type,
        created_at: formatDate(post.dateCreated),
        user_id: params[1],
        type: post.type,
    };
    const postId = Process("models.blog.post.save", newArticle)
    return convertJson2RpcXml(postId + "")
    // return getPostNewEditMessage(postId)
}
function newMediaObject(params) {
    const upLoadData = params[3]
    const fname = upLoadData.name;
    const type = upLoadData.type;
    const bits = upLoadData.bits;
    var fs = new FS("system")
    var folder = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    const filePath = `${folder}/${fname}`
    const newFileName = `/upload/public/${filePath}`
    fs.WriteFileBase64(newFileName, bits)
    const fnameEncode = encodeURIComponent(filePath)
    const fileApi = `/api/v1/fs/public/file/download?name=${fnameEncode}`
    return convertJson2RpcXml({ url: fileApi })
    // return getUpdateFileMessage(fileApi)
}
function formatDate(dateString) {

    if (dateString == null || dateString.length < 10) {
        return dateString
    }
    const year = dateString.slice(0, 4);
    const month = dateString.slice(4, 6);
    const day = dateString.slice(6, 8);
    const time = dateString.slice(9);

    const formattedDate = `${year}-${month}-${day} ${time}`;
    return formattedDate
}
function unicodeToUtf8(unicodeString) {
    const encodedURI = encodeURIComponent(unicodeString);
    const utf8String = decodeURIComponent(encodedURI);

    return utf8String;
}
// function getUpdateFileMessage(fileApi) {
//     return {
//         "content": `<?xml version="1.0"?>
//         <methodResponse>
//            <params>
//               <param>
//                  <value>
//                     <struct>
//                         <member>
//                             <name>url</name>
//                             <value>
//                                 <string>
//                                     ${fileApi}
//                                 </string>
//                             </value>
//                         </member>
//                     </struct>
//                 </value>
//               </param>
//            </params>
//         </methodResponse>`
//     }
// }

// function getPostNewEditMessage(postId) {
//     return {
//         "content": `<?xml version="1.0"?>
//             <methodResponse>
//                 <params>
//                     <param>
//                         <value>
//                             <string>
//                                 ${postId + ""}
//                             </string>
//                         </value>
//                     </param>
//                 </params>
//             </methodResponse>`
//     }
// }
function getErrorMessage(message, code) {

    return {
        "content": `<?xml version="1.0" encoding="utf-8"?>
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
    }
}

function convertJs2xml(data) {
    if (data == null) {
        return '';
    }
    if (Array.isArray(data)) {
        let str = `<value><array><data>${data.map(line => convertJs2xml(line)).join('')}</data></array></value>`
        return str
    }
    // convert struct

    const type = getXmlType(data)

    if (type === 'struct') {
        let template = ""
        for (const key in data) {
            if (Object.hasOwnProperty.call(data, key)) {
                const element = data[key];
                if (element == null) {
                    continue;
                }
                let valueStr = convertJs2xml(element)
                template += `<member><name>${key}</name>${valueStr}</member>`
            }
        }
        return `<value><struct>${template}</struct></value>`
    } else {
        if (type === '"datetime.iso8601"') {
            data = formatDateIso(data)
        }
        return `<value><${type}>${data}</${type}></value>`
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
        console.log("format date error:", error.message)
        return dateIn
    }

}
function getXmlType(data) {

    const type = typeof data;
    switch (type) {
        case 'bigint':
            return 'int'
        case 'boolean':
            return 'boolean'
        case 'function':
            break
        case 'number':
            if (Number.isInteger(data)) {
                return 'int'
            } else {
                return 'double'
            }
        case 'object':
            return 'struct'
        case 'string':
            if (data.toLowerCase() == 'true' || data.toLowerCase() == 'false') {
                return 'boolean'
            }
        case 'undefined':
            return 'string'
    }
    if (isDateTimeOrDate(data)) {
        return "datetime.iso8601"
    }
    return "string"
}

// yao run scripts.blog.webblog.convertJson2RpcXml true
// yao run scripts.blog.webblog.convertJson2RpcXml 1
// yao run scripts.blog.webblog.convertJson2RpcXml '::{"name":"test"}'
function convertJson2RpcXml(data) {
    const xml = `<?xml version="1.0" encoding="utf-8"?><methodResponse><params><param>${convertJs2xml(data)}</param></params></methodResponse>`;
    // console.log("response:", xml)
    return {
        "content": xml
    }
}