// 参考：https://ui5.sap.com/resources/sap/ui/model/odata/v4/lib/_Batch-dbg.js

import { parseUrl } from '@scripts/odata/lib/url';
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
function getHeaderParameterValue(sHeaderValue, sParameterName) {
  const rHeaderParameter = /(\S*?)=(?:"(.+)"|(\S+))/;
  let iParamIndex,
    aHeaderParts = sHeaderValue.split(';'),
    aMatches;

  sParameterName = sParameterName.toLowerCase();
  for (iParamIndex = 1; iParamIndex < aHeaderParts.length; iParamIndex += 1) {
    // remove possible quotes via reg exp
    // RFC7231: parameter = token "=" ( token / quoted-string )
    aMatches = rHeaderParameter.exec(aHeaderParts[iParamIndex]);
    if (aMatches[1].toLowerCase() === sParameterName) {
      return aMatches[2] || aMatches[3];
    }
  }
}

// /**
//  * Create regular expression based on boundary parameter of the given "multipart/mixed"
//  * Content-Type header value.
//  * @param {string} sContentType
//  *   Value of the "multipart/mixed" Content-Type header value
//  * @returns {object} Regular expression which will be used to parse the $batch request body
//  * @throws {Error} If the specified Content-Type header value does not represent
//  *   "multipart/mixed" MIME type with "boundary" parameter.
//  */
// function getBoundaryRegExp(sContentType) {
//   var sBatchBoundary = getHeaderParameterValue(sContentType, "boundary"),
//     iMultiPartTypeIndex = sContentType.trim().indexOf("multipart/mixed");

//   if (iMultiPartTypeIndex !== 0 || !sBatchBoundary) {
//     throw new Exception(
//       'Invalid $batch response header "Content-Type": ' + sContentType
//     );
//   }

//   // escape RegExp-related characters
//   sBatchBoundary = escapeRegExp(sBatchBoundary);
//   return new RegExp("--" + sBatchBoundary + "(?:[ \t]*\r\n|--)");
// }
// /**
//  * Returns value of the header with the specified <code>sHeaderName</code> from
//  * the specified <code>sHeaders</code> section of MIME part.
//  *
//  * @param {string} sHeaders
//  *   Section of MIME part representing HTTP headers
//  * @param {string} sHeaderName
//  *   Name of HTTP header in lower case
//  * @returns {string} The HTTP header value
//  */
// function getHeaderValue(sHeaders, sHeaderName) {
//   var aHeaderParts,
//     aHeaders = sHeaders.split("\r\n"),
//     i;

//   for (i = 0; i < aHeaders.length; i += 1) {
//     aHeaderParts = aHeaders[i].split(":");

//     if (aHeaderParts[0].toLowerCase().trim() === sHeaderName) {
//       return aHeaderParts[1].trim();
//     }
//   }
// }

// /**
//  * Deserializes a batch response body using the batch boundary from the given value of
//  * the "Content-Type" header. See
//  * {@link sap.ui.model.odata.v4.ODataUtils.deserializeBatchResponse} for more details.
//  *
//  * @param {string} sContentType
//  *   The value of the "Content-Type" header from the batch response, for example
//  *  "multipart/mixed; boundary=batch_123456"
//  * @param {string} sResponseBody
//  *   A batch response body
//  * @returns {object[]}
//  *   An array containing responses from the batch response body, each with the following
//  *   structure:
//  *   <ul>
//  *     <li> <code>status</code>: {number} HTTP status code
//  *     <li> <code>statusText</code>: {string} (optional) HTTP status text
//  *     <li> <code>headers</code>: {object} Map of response headers
//  *     <li> <code>responseText</code>: {string} Response body
//  *   </ul>
//  *   If the specified <code>sResponseBody</code> contains responses for change sets, then
//  *   the corresponding response objects will be returned in a nested array.
//  * @throws {Error}
//  *   <ul>
//  *     <li> If the <code>sContentType</code> parameter does not represent a
//  *       "multipart/mixed" media type with "boundary" parameter
//  *     <li> If the "charset" parameter of the "Content-Type" header of a nested response has
//  *       a value other than "UTF-8"
//  *     <li> If there is no "Content-ID" header for a change set response or its value is not
//  *       a number
//  *   </ul>
//  */
// function deserializeBatchResponse(sContentType, sResponseBody) {
//   return _deserializeBatchResponse(sContentType, sResponseBody, false);
// }
// /**
//  * Extracts value of Content-Type header from the specified
//  * <code>sMimeTypeHeaders</code> if it is "multipart/mixed".
//  *
//  * @param {string} sMimeTypeHeaders
//  *   Section of MIME part representing HTTP headers
//  * @returns {string} Content-Type header value e.g.
//  *   "multipart/mixed; boundary=batch_id-0123456789012-345" or undefined
//  */
// function getChangeSetContentType(sMimeTypeHeaders) {
//   var sContentType = getHeaderValue(sMimeTypeHeaders, "content-type");
//   return sContentType.startsWith("multipart/mixed;") ? sContentType : undefined;
// }
// function _deserializeBatchResponse(sContentType, sResponseBody, bIsChangeSet) {
//   var aBatchParts = sResponseBody.split(getBoundaryRegExp(sContentType)),
//     aResponses = [];

//   // skip preamble and epilogue
//   aBatchParts = aBatchParts.slice(1, -1);

//   aBatchParts.forEach(function (sBatchPart) {
//     // a batch part contains 3 elements separated by a double "\r\n"
//     // 0: general batch part headers
//     // 1: HTTP response headers and status line
//     // 2: HTTP response body

//     var sChangeSetContentType,
//       sCharset,
//       iColonIndex,
//       sHeader,
//       sHeaderName,
//       sHeaderValue,
//       aHttpHeaders,
//       sHttpHeaders,
//       iHttpHeadersEnd,
//       aHttpStatusInfos,
//       sMimeHeaders,
//       iMimeHeadersEnd,
//       oRequest = {},
//       iResponseIndex,
//       i;

//     // iMimeHeadersEnd = sBatchPart.indexOf("\r\n\r\n");
//     // sMimeHeaders = sBatchPart.slice(0, iMimeHeadersEnd);
//     // iHttpHeadersEnd = sBatchPart.indexOf("\r\n\r\n", iMimeHeadersEnd + 4);
//     // sHttpHeaders = sBatchPart.slice(iMimeHeadersEnd + 4, iHttpHeadersEnd);

//     // sChangeSetContentType = getChangeSetContentType(sMimeHeaders);
//     // if (sChangeSetContentType) {
//     //   aResponses.push(
//     //     _deserializeBatchResponse(
//     //       sChangeSetContentType,
//     //       sBatchPart.slice(iMimeHeadersEnd + 4),
//     //       true
//     //     )
//     //   );
//     //   return;
//     // }
//     sHttpHeaders = sBatchPart;

//     aHttpHeaders = sHttpHeaders.split("\r\n");
//     // e.g. HTTP/1.1 200 OK
//     aHttpStatusInfos = aHttpHeaders[0].split(" ");

//     oRequest.url = aHttpStatusInfos[0];

//     // oRequest.status = parseInt(aHttpStatusInfos[1]);
//     // oRequest.statusText = aHttpStatusInfos.slice(2).join(" ");
//     oRequest.headers = {};

//     // start with index 1 to skip status line
//     for (i = 1; i < aHttpHeaders.length; i += 1) {
//       // e.g. Content-Type: application/json;odata.metadata=minimal
//       sHeader = aHttpHeaders[i];
//       iColonIndex = sHeader.indexOf(":");
//       sHeaderName = sHeader.slice(0, iColonIndex).trim();
//       sHeaderValue = sHeader.slice(iColonIndex + 1).trim();
//       oRequest.headers[sHeaderName] = sHeaderValue;

//       if (sHeaderName.toLowerCase() === "content-type") {
//         sCharset = getHeaderParameterValue(sHeaderValue, "charset");
//         if (sCharset && sCharset.toLowerCase() !== "utf-8") {
//           throw new Exception('Unsupported "Content-Type" charset: ' + sCharset);
//         }
//       }
//     }

//     // remove \r\n sequence from the end of the response body
//     oRequest.responseText = sBatchPart.slice(iHttpHeadersEnd + 4, -2);

//     if (bIsChangeSet) {
//       iResponseIndex = getChangeSetResponseIndex(sMimeHeaders);
//       aResponses[iResponseIndex] = oRequest;
//     } else {
//       aResponses.push(oRequest);
//     }
//   });

//   return aResponses;
// }

export function decodePartsRequest(headers, parts) {
  // let contentType = "";
  // if (headers["Content-Type"] && headers["Content-Type"].length) {
  //   contentType = headers["Content-Type"][0];
  // }

  const aRequest = [];
  parts.forEach((sBatchPart) => {
    const oRequest = {};

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
      if (oRequest.headers.hasOwnProperty(sHeaderName)) {
        if (Array.isArray(oRequest.headers[sHeaderName])) {
          oRequest.headers[sHeaderName].push(sHeaderValue);
        } else {
          oRequest.headers[sHeaderName] = [query[sHeaderName], sHeaderValue];
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

// const headers = {
//   Accept: ["multipart/mixed"],
//   "Accept-Encoding": ["gzip, deflate, br"],
//   "Accept-Language": ["zh-CN"],
//   Connection: ["close"],
//   "Content-Length": ["408"],
//   "Content-Type": ["multipart/mixed; boundary=batch_id-1693739362678-19"],
//   "Mime-Version": ["1.0"],
//   "Odata-Maxversion": ["4.0"],
//   "Odata-Version": ["4.0"],
//   Origin: ["http://localhost:8080"],
//   Referer: ["http://localhost:8080/index.html"],
//   "Sec-Ch-Ua": [
//     '"Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"',
//   ],
//   "Sec-Ch-Ua-Mobile": ["?0"],
//   "Sec-Ch-Ua-Platform": ['"Windows"'],
//   "Sec-Fetch-Dest": ["empty"],
//   "Sec-Fetch-Mode": ["cors"],
//   "Sec-Fetch-Site": ["same-origin"],
//   "User-Agent": [
//     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
//   ],
//   "X-Csrf-Token": ["123123"],
//   "X-Requested-With": ["XMLHttpRequest"],
// };

// const parts = [
//   'GET table?$select=browser,engine,id,platform,version\u0026$skip=0\u0026$top=10 HTTP/1.1\r\nAccept:application/json;odata.metadata=minimal;IEEE754Compatible=true\r\nAccept-Language:zh-CN\r\nX-CSRF-Token:123123\r\nContent-Type:application/json;charset=UTF-8;IEEE754Compatible=true\r\n\r\n{\r\n    "test":"test"\r\n}\r\n',
//   "GET table?$select=browser,engine,id,platform,version\u0026$skip=0\u0026$top=10 HTTP/1.1\r\nAccept:application/json;odata.metadata=minimal;IEEE754Compatible=true\r\nAccept-Language:zh-CN\r\nX-CSRF-Token:123123\r\nContent-Type:application/json;charset=UTF-8;IEEE754Compatible=true\r\n\r\n",
// ];
// decodePartsRequest(headers, parts);
// module.exports = { decodePartsRequest };
