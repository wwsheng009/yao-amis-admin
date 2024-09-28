import { DotName, SlashName } from '@scripts/system/lib';
import { ConvertAmisUIModelToModel, getModelDslById } from './model';
import { AmisUIColumn, ModelId } from '@yao/types';

// 创建模型对象的ts类型定义。

/**
 * 生成模型对应的ts类型定义。
 *
 * yao run scripts.system.tstype.createModelType admin.user
 * @param {string} modelId 模型id
 */
export function createModelType(modelId: ModelId, columnsIn?: AmisUIColumn[]) {
  const model = getModelDslById(modelId); //Process('scripts.system.model.getModelDslById', modelId);

  if (columnsIn != null && Array.isArray(columnsIn) && columnsIn.length > 0) {
    const columns = columnsIn.filter((col) => col.checked === true);
    const model2 = ConvertAmisUIModelToModel({ columns });
    model.columns =
      model2.columns.length > 0 ? model2.columns : model.columns || [];
  } else {
    model.columns = model.columns || [];
  }

  return createTSTypes(model);
}
/**
 * 生成模型对应的ts类型定义
 *
 * yao run scripts.system.tstype.createTSTypes admin.user
 * @param {object|Array} modelsIn 模型对象或是列表
 * @returns string
 */
function createTSTypes(modelsIn) {
  if (!modelsIn) {
    return '';
  }
  const typeMapping = getTSTypeMapping();

  let models = [];
  if (Array.isArray(modelsIn)) {
    models = modelsIn;
  } else if (!Array.isArray(modelsIn) && typeof modelsIn == 'object') {
    models.push(modelsIn);
  }
  const codes = models.map((model) => {
    const tabName = model.table.name;
    const funtionName = SlashName(tabName);
    const dotName = DotName(tabName);
    const last = funtionName.replaceAll('/', '_');
    const fields = model.columns
      .map((item) => {
        return `  /**${item.label || item.comment} */
  ${item.name}${isOption(item) ? '?' : ''}: ${getTsType(
    tabName,
    item,
    typeMapping
  )};`;
      }, [])
      .join('\n');

    const rels = [];
    for (const key in model.relations) {
      const element = model.relations[key];
      let sign = '';
      if (element.type === 'hasMany') {
        sign = '[]';
      }
      rels.push(`  /** Relation: ${key}=> ${element.model} */
  ${key}?: ${element.model.replaceAll('.', '_')}${sign}`);
    }
    return `
/**
 * Model=> ${dotName} ${model.name ? '(' + model.name + ')' : ''}
 * 
 * Table=> ${model.table.name} ${
   model.table.comment ? '(' + model.table.comment + ')' : ''
 }
*/
interface ${last} {
${fields}
${rels.join('\n')}
}`;
  });
  return codes.join('\n');
}

function isOption(column) {
  const { unique, nullable, default: columnDefault, type } = column;

  if (/^id$/i.test(type)) {
    // id一般是数据创建
    return true;
  } else if (unique || (columnDefault == null && !nullable)) {
    // 这里不要判断同时 == null || == undefined
    return false;
  }
  return true;
}

function getTsType(tabName, column, typeMapping) {
  let type = 'any';
  if (column.type === 'enum') {
    if (!column.option) {
      console.log(
        `column: ${column.name} in ${tabName} type is enum,but no options, fallback to string`
      );
      type = 'string';
    } else {
      type = column.option?.map((item) => `"${item}"`).join(' | ');
    }
  } else if (column.type in typeMapping) {
    type = typeMapping[column.type];
  }
  return type;
}
function getTSTypeMapping() {
  return {
    ID: 'number',
    string: 'string',
    char: 'string',
    text: 'string',
    mediumText: 'string',
    longText: 'string',
    date: 'date',
    datetime: 'date',
    datetimeTz: 'date',
    time: 'date',
    timeTz: 'date',
    timestamp: 'date',
    timestampTz: 'date',
    tinyInteger: 'number',
    tinyIncrements: 'number',
    unsignedTinyInteger: 'number',
    smallInteger: 'number',
    unsignedSmallInteger: 'number',
    integer: 'number',
    bigInteger: 'number',
    decimal: 'number',
    unsignedDecimal: 'number',
    float: 'number',
    boolean: 'boolean',
    enum: 'Select',
    json: 'any',
    JSON: 'any' // 使用大写的JSON区分小写的json
  };
}
