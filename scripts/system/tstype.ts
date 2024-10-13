import { DotName, SlashName } from '@scripts/system/lib';
import { getModelDslById } from './model';
import { AmisUIColumn, ModelId } from '@yao/types';
import { amisUIModelToAmisModel } from './model_convert';
import { YaoModel } from '@yaoapps/types';

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
    const model2 = amisUIModelToAmisModel({ columns });
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
function createTSTypes(modelsIn: YaoModel.ModelDSL[] | YaoModel.ModelDSL) {
  if (!modelsIn) {
    return '';
  }

  let models = [];
  if (Array.isArray(modelsIn)) {
    models = modelsIn;
  } else if (!Array.isArray(modelsIn) && typeof modelsIn == 'object') {
    models.push(modelsIn);
  }
  const codes = models.map(getCodeTemplate);
  return codes.join('\n');
}

function getCodeTemplate(model: YaoModel.ModelDSL) {
  const typeMapping = getTSTypeMapping();

  const tabName = model.table.name;
  const funtionName = SlashName(tabName);
  const dotName = DotName(tabName);
  const last = funtionName.replaceAll('/', '_');

  //handle the fields
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

  //handle the relations
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

  //return code template
  return `\/**
* Model=> ${dotName} ${model.name ? '(' + model.name + ')' : ''}
* 
* Table=> ${model.table.name} ${
    model.table.comment ? '(' + model.table.comment + ')' : ''
  }
*\/
export interface ${last} {
${fields}
${rels.join('\n')}
}`;
}

function isOption(column: YaoModel.ModelColumn) {
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

function getTsType(
  tableName: string,
  column: YaoModel.ModelColumn,
  typeMapping: {
    [x: string]: string;
  }
) {
  let type = 'any';
  const ctype = column.type.toLowerCase();
  if (ctype === 'enum') {
    if (!column.option) {
      console.log(
        `column: ${column.name} in ${tableName} type is enum,but no options, fallback to string`
      );
      type = 'string';
    } else {
      type = column.option?.map((item) => `"${item}"`).join(' | ');
    }
  } else if (ctype.includes('decimal')) {
    type = 'number';
  } else if (ctype.includes('float')) {
    type = 'number';
  } else if (ctype.includes('integer')) {
    type = 'number';
  } else if (ctype.includes('date')) {
    type = 'Date';
  } else if (ctype.includes('time')) {
    type = 'Date';
  } else if (ctype.includes('text')) {
    type = 'string';
  } else if (ctype in typeMapping) {
    type = typeMapping[ctype];
  }
  return type;
}
function getTSTypeMapping() {
  return {
    id: 'number',
    string: 'string',
    char: 'string',
    text: 'string',
    mediumtext: 'string',
    longtext: 'string',
    date: 'Date',
    datetime: 'Date',
    datetimetz: 'Date',
    time: 'Date',
    timetz: 'Date',
    timestamp: 'Date',
    timestamptz: 'Date',
    tinyinteger: 'number',
    tinyincrements: 'number',
    unsignedtinyinteger: 'number',
    smallinteger: 'number',
    unsignedsmallinteger: 'number',
    integer: 'number',
    biginteger: 'number',
    decimal: 'number',
    unsigneddecimal: 'number',
    float: 'number',
    boolean: 'boolean',
    enum: 'string',
    json: 'any'
  };
}
