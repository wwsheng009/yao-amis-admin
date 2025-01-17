import { Exception, Process } from '@yaoapps/client';
import { parse } from 'node-html-parser';
function isHTML(text: string) {
  // 定义一个正则表达式，用于匹配HTML标签
  const htmlTagPattern = /<\/?[^>]+(>|$)/g;

  // 使用正则表达式测试文本内容
  return htmlTagPattern.test(text);
}

export function truncateText(text: string) {
  const lines = text.split('\n');
  const truncatedLines = lines.slice(0, 10); // Get the first 10 lines
  let truncatedText = truncatedLines.join('\n');
  if (truncatedText.length > 1000) {
    truncatedText = truncatedText.slice(0, 1000); // If the length exceeds 1000 characters, truncate it to 1000 characters
  }
  if (lines.length > 10 || text.length > 1000) {
    truncatedText += '...'; // Add ellipsis to indicate truncation
  }
  return truncatedText;
}

// yao run scripts.lib.web.getWebPageContent https://wwsheng009.github.io/yao-docs/YaoDSL/Model/%E5%AE%9A%E4%B9%89Yao%E6%A8%A1%E5%9E%8B.html

export function getWebPageContent(url: string) {
  const request = Process('http.get', url);
  const headers = request.headers;

  let isJson = false;
  if (
    headers['Content-Type'] &&
    headers['Content-Type'][0].includes('application/json')
  ) {
    isJson = true;
  }

  if (request.code !== 200) {
    console.log('Error: ', request);
    let message = request.message;
    if (message == '') {
      message = request.data;
      if (message && !isJson) {
        message = Process('encoding.base64.Decode', message);
      }
    }
    console.log('Error: ', message);
    throw new Exception('Error: ' + message);
  } else {
    let responseData = '';

    if (isJson) {
      // 如果Content-Type是application/json，则直接返回响应数据（可能是JSON对象）
      responseData = request.data;
    } else {
      responseData = Process('encoding.base64.Decode', request.data);
    }
    if (typeof responseData === 'object' && responseData != null) {
      responseData = JSON.stringify(responseData['data']);
    }
    const regex = /<html[^>]*>[\s\S]*?<\/html>/i;
    const match = responseData.match(regex);
    if (match) {
      responseData = match[0];
    } else {
      return responseData;
    }

    if (!isHTML(responseData)) {
      return responseData;
    }
    responseData = removeSpanInsideCode(responseData);

    const root = parse(responseData, {
      lowerCaseTagName: false, // convert tag name to lower case (hurts performance heavily)
      comment: false, // retrieve comments (hurts performance slightly)
      fixNestedATags: false, // fix invalid nested <a> HTML tags
      parseNoneClosedTags: false, // close none closed HTML tags instead of removing them
      voidTag: {
        tags: [
          'script',
          'style',
          'area',
          'base',
          'br',
          'col',
          'embed',
          'hr',
          'img',
          'input',
          'link',
          'meta',
          'param',
          'source',
          'track',
          'wbr'
        ], // optional and case insensitive, default value is ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'param', 'source', 'track', 'wbr']
        closingSlash: true // optional, default false. void tag serialisation, add a final slash <br/>
      },
      blockTextElements: {
        script: false, // keep text content when parsing
        noscript: false, // keep text content when parsing
        style: false, // keep text content when parsing
        pre: true // keep text content when parsing
      }
    });
    let text = root.innerText;

    const mainTag = root.querySelector('main');
    if (mainTag) {
      text = mainTag.innerText;
    } else if (root.querySelector('article')) {
      text = root.querySelector('article').innerText;
    }
    // root.querySelectorAll('script, style').forEach((node) => node.remove());
    // Remove empty lines and lines that only contain line indices
    text = text
      .split('\n')
      .filter((line) => {
        // Remove lines that are empty or contain only whitespace
        if (line.trim() === '') return false;

        // Remove lines that only contain a number (line index)
        const isLineIndex = /^\d+$/.test(line.trim());
        return !isLineIndex;
      })
      .join('\n');
    // console.log('html text:>>', text);

    return text;
  }
}

function removeSpanInsideCode(html: string): string {
  // 解析HTML内容
  const root = parse(html, {
    blockTextElements: {
      script: false, // keep text content when parsing
      noscript: false, // keep text content when parsing
      style: false, // keep text content when parsing
      pre: true // keep text content when parsing
    }
  });

  // 查找所有的<code>标签
  const codeElements = root.querySelectorAll('pre');

  // 遍历每个<code>标签
  codeElements.forEach((codeElement) => {
    // pre code will not be pasted, need to do it again here
    const preElement = parse(codeElement.text, {
      blockTextElements: {
        pre: true // keep text content when parsing
      }
    });
    codeElement.innerHTML = '<code>' + preElement.innerText + '</code>';
  });

  // 返回处理后的HTML内容
  return root.toString();
}

// let source = getWebPageContent(
//   'https://wwsheng009.github.io/yao-docs/YaoDSL/Model/%E5%AE%9A%E4%B9%89Yao%E6%A8%A1%E5%9E%8B.html'
// );
// console.log(source);

// let source = getWebPageContent(
//   'https://help.sap.com/http.svc/pagecontent?deliverableInfo=0&deliverable_id=20087850&file_path=31601f28442a40978d770783820aa234.html&buildNo=87'
// );
