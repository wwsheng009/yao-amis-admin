// 参考：https://ui5.sap.com/resources/sap/ui/model/odata/v4/lib/_Batch-dbg.js

import { parseUrl, UrlObj } from '@scripts/app/odata/lib/url';
import { QueryObjectIn } from '@yao/request';
import { Exception } from '@yao/yao';
/**
 * Extracts value of the parameter with the specified <code>sParameterName</code>
 * from the specified <code>sHeaderValue</code>.
 *
 * @param {string} sHeaderValue
 *   HTTP header value e.g. "application/json;charset=utf-8"
 * @param {string} sParameterName
 *   Name of HTTP header parameter e.g. "charset"
 * @returns {string} The HTTP header parameter value
 */
function getHeaderParameterValue(sHeaderValue: string, sParameterName: string) {
  const rHeaderParameter = /(\S*?)=(?:"(.+)"|(\S+))/;
  const aHeaderParts = sHeaderValue.split(';');
  sParameterName = sParameterName.toLowerCase();
  for (
    let iParamIndex = 1;
    iParamIndex < aHeaderParts.length;
    iParamIndex += 1
  ) {
    // remove possible quotes via reg exp
    // RFC7231: parameter = token "=" ( token / quoted-string )
    const aMatches = rHeaderParameter.exec(aHeaderParts[iParamIndex]);
    if (aMatches[1].toLowerCase() === sParameterName) {
      return aMatches[2] || aMatches[3];
    }
  }
}

interface Request {
  version: string;
  headers: QueryObjectIn;
  body: string;
  URL: UrlObj;
  requstText: string;
  method: string;
  urlText: string;
}
export function decodePartsRequest(headers: QueryObjectIn, parts: string[]) {
  // let contentType = "";
  // if (headers["Content-Type"] && headers["Content-Type"].length) {
  //   contentType = headers["Content-Type"][0];
  // }

  const aRequest = [];
  parts.forEach((sBatchPart) => {
    const oRequest = {} as Request;

    // 包含两部分，一个是headers,另外是body
    // iMimeHeadersEnd = sBatchPart.indexOf("\r\n\r\n");
    // sMimeHeaders = sBatchPart.slice(0, iMimeHeadersEnd);
    const iHttpHeadersEnd = sBatchPart.indexOf('\r\n\r\n');
    const sHttpHeaders = sBatchPart.slice(0, iHttpHeadersEnd);

    oRequest.requstText = sBatchPart.slice(iHttpHeadersEnd + 4, -2);

    const aHttpHeaders = sHttpHeaders.split('\r\n');
    // e.g. HTTP/1.1 200 OK

    const aHttpStatusInfos = aHttpHeaders[0].split(' ');
    oRequest.method = aHttpStatusInfos[0];
    oRequest.urlText = aHttpStatusInfos[1];
    oRequest.version = aHttpStatusInfos[2];
    // oRequest.status = parseInt(aHttpStatusInfos[1]);
    // oRequest.statusText = aHttpStatusInfos.slice(2).join(" ");
    oRequest.headers = {};

    // start with index 1 to skip status line
    for (let i = 1; i < aHttpHeaders.length; i += 1) {
      // e.g. Content-Type: application/json;odata.metadata=minimal
      const sHeader = aHttpHeaders[i];
      const iColonIndex = sHeader.indexOf(':');
      const sHeaderName = sHeader.slice(0, iColonIndex).trim();
      const sHeaderValue = sHeader.slice(iColonIndex + 1).trim();

      // 解析成数组，与yao保持一致。
      if (Object.prototype.hasOwnProperty.call(oRequest.headers, sHeaderName)) {
        if (Array.isArray(oRequest.headers[sHeaderName])) {
          oRequest.headers[sHeaderName].push(sHeaderValue);
        } else {
          oRequest.headers[sHeaderName] = [
            oRequest.headers[sHeaderName],
            sHeaderValue
          ];
        }
      } else {
        // 总是设置成数组，与yao的解析保持一致。
        oRequest.headers[sHeaderName] = [sHeaderValue];
      }
      // oRequest.headers[sHeaderName] = [sHeaderValue];

      if (sHeaderName.toLowerCase() === 'content-type') {
        const sCharset = getHeaderParameterValue(sHeaderValue, 'charset');
        if (sCharset && sCharset.toLowerCase() !== 'utf-8') {
          throw new Exception(
            'Unsupported "Content-Type" charset: ' + sCharset
          );
        }
      }
    }
    for (const key in oRequest.headers) {
      if (Object.hasOwnProperty.call(oRequest.headers, key)) {
        const sType = oRequest.headers[key];
        if (key.toLowerCase() === 'content-type') {
          if (
            sType.includes('application/json') &&
            oRequest.requstText.trim() !== ''
          ) {
            oRequest.body = JSON.parse(oRequest.requstText);
          }
        }
      }
    }
    oRequest.URL = parseUrl(oRequest.urlText);
    aRequest.push(oRequest);
  });
  return aRequest;

  //   "multipart/mixed;boundary=batch_foobarbaz"
  //   deserializeBatchResponse(contentType, body);
}
