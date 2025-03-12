import {
  getOdataViewList,
  getOdataModelsWithColMap,
  getOdataModel
} from '@scripts/app/odata/lib/model';
import { Metadata, getEdmType } from '@scripts/app/odata/lib/meta';
import { XmlWriter } from '@scripts/app/odata/lib/xml';
import { YaoModel } from '@yaoapps/types';

/**
 * 获取模型列表
 * @param {string} base
 * @returns
 */
export function getEntryMetaDataXml(base) {
  // https://services.odata.org/V2/OData/OData.svc/
  const viewList = getOdataViewList();

  const data = [];
  viewList.forEach((view) => {
    data.push(`<collection href="${view.name}">
        <atom:title>${view.label}</atom:title>
    </collection>`);
  });
  return `<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<service xmlns="http://www.w3.org/2007/app" xmlns:atom="http://www.w3.org/2005/Atom" xml:base="${base}">
    <workspace>
    <atom:title>Default</atom:title>
    ${data}
    </workspace>
</service>`;
}

/**
 * 获取所有模型的元数据信息
 * scripts.app.odata.lib.process.getMetaDataXml2
 * @returns
 */
export function getMetaDataXml2() {
  const models = getOdataModelsWithColMap();
  const meta = new Metadata(models);
  const data = meta.ctrl();
  // console.log("data=============>", data)
  const xml = new XmlWriter();
  const ret = xml.writeXml(data, 200);
  return ret;
}

/**
 * 转换json数据成xml定义
 * @param {object} json
 * @param {string} viewId
 * @param {string} sBaseUrl
 * @returns
 */
export function convertJsonToXml(
  json: { [key: string]: any }[],
  viewId: string,
  sBaseUrl: string
) {
  const entrys = convertEntrys(json, viewId, sBaseUrl);

  const xml = `<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<feed xml:base="${sBaseUrl}" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns="http://www.w3.org/2005/Atom">
    <title type="text">${viewId}</title>
    <id>${sBaseUrl}${viewId}</id>
    <updated>2023-09-07T04:58:35Z</updated>
    <link rel="self" title="${viewId}" href="${viewId}" />
    ${entrys.join('')}
</feed>`;
  return xml;
}
/**
 * 转换JSON数据，
 * @param {Array} json
 * @param {string} viewId
 * @param {string} sBaseUrl
 * @returns
 */
function convertEntrys(
  json: { [key: string]: any }[],
  viewId: string,
  sBaseUrl: string
) {
  const model = getOdataModel(viewId);

  const entrys = [];
  for (const item of json) {
    let colXmlstr = '';
    // 不要直接循环item对象，那个索引是随机的。
    const cols = model.columns as YaoModel.ModelColumn[];
    cols.forEach((col) => {
      const key = col.name;
      if (Object.hasOwnProperty.call(item, key)) {
        // column info
        let element = item[key];
        if (element != null) {
          const edmType = getEdmType(col.type);
          // edmType = "Edm.String";
          if (edmType == 'Edm.String') {
            element = escapedXmlString(element);
          }

          if (edmType == 'Edm.DateTime') {
            element = element.replace('/', '-');
            element = element.replace(' ', 'T');
            // element = '2001-12-21T12:00';
          }
          colXmlstr += `<d:${key} m:type="${edmType}">${element}</d:${key}>
              `;
        }
      }
    });
    // colXmlstr = colXmlstr.trimEnd(``);

    entrys.push(`<entry>
      <id>${sBaseUrl}${viewId}(${item.id})</id>
      <link rel="edit" title="${viewId}" href="${viewId}(${item.id})" />
      <category term="OdataService.${viewId}" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme" />
      <content type="application/xml">
          <m:properties>
              ${colXmlstr}
          </m:properties>
      </content>
    </entry>
`);
  }
  return entrys;
}
/**
 * escape xml string
 * @param {string} str text need to be escaped
 * @returns
 */
function escapedXmlString(str) {
  if (!str || typeof str.replace !== 'function') {
    return str;
  }
  const strXml = str.replace(/[&<>"']/g, (char) => {
    const entityMap = {
      // Object to map characters to their XML entities
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&apos;'
    };
    return entityMap[char] || char; // Return XML entity if exists, otherwise return original character
  });
  return strXml;
}
