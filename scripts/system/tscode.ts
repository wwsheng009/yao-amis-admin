import {
  getFieldsTemplate,
  getFieldTsType,
  toCamelCaseNameSpace
} from './tstype';
import { ModelId, AmisUIColumn } from '@yao/types';
import { getModelDslById } from './model';
import { amisUIModelToAmisModel } from './model_convert';
import { YaoModel } from '@yaoapps/types';

/**
 * yao run scripts.system.tscode.generateCodeTemplate admin.user
 * @param modelId
 * @returns
 */
export function generateCodeTemplate(
  modelId: string,
  columnsIn?: AmisUIColumn[]
) {
  const model = getModelDslById(modelId);

  if (columnsIn != null && Array.isArray(columnsIn) && columnsIn.length > 0) {
    const columns = columnsIn.filter((col) => col.checked === true);
    const model2 = amisUIModelToAmisModel({ columns });
    model.columns =
      model2.columns.length > 0 ? model2.columns : model.columns || [];
  } else {
    model.columns = model.columns || [];
  }
  return getModelServiceTemplate(modelId, model);
}

/**
 * yao run scripts.system.tscode.getModelServiceTemplate admin.user
 * @param modelId
 * @param modelDsl
 * @returns
 */
function getModelServiceTemplate(modelId: string, modelDsl: YaoModel.ModelDSL) {
  //fields
  const fieldsCode = getFieldsTemplate(modelId, modelDsl, 'I');

  const idCol = modelDsl.columns.find((col) => col.primary);
  const idColType = getFieldTsType(idCol);

  // const namespace = toCamelCaseNameSpace(modelId);
  // const modelInterface = 'I' + toCamelCaseNameSpace(modelId);

  //service template
  return `
${'import'} { Process, Query } from '@yaoapps/client';
${'import'} { ModelPaginateResult, YaoQueryParam } from '@yaoapps/types';

${fieldsCode}

  ${getFunctionsTemplate(modelId, idColType, modelDsl)}
 `;
}

function getFunctionsTemplate(
  modelID: ModelId,
  idFieldType: string,
  modelDsl: YaoModel.ModelDSL
) {
  const namespace = toCamelCaseNameSpace(modelID) + 'Service';
  const modelInterface = 'I' + toCamelCaseNameSpace(modelID);

  // const fieldsName = modelDsl.columns.reduce((pre, col) => {
  //   pre[col.name] = col.name;
  //   return pre;
  // }, {});

  let fieldsName = '';
  modelDsl.columns.forEach((c) => {
    fieldsName += `   /** ${c.label || c.comment || c.name} */
    ${c.name}: '${c.name}',
 `;
  });
  fieldsName += '\n';

  return `
${'export'} class ${namespace} {
    static FieldNames = {
${fieldsName}
  };
    static ModelID = '${modelID}';
    static TableName = '${modelDsl.table.name}';


    \/**
    * 根据主键与附加条件查询单条记录。
    * @param key 主键
    * @param query 筛选条件
    * @returns ${modelInterface}
    */
    static Find(key:${idFieldType},query:YaoQueryParam.QueryParam): ${modelInterface}{
        return Process(\`models.$\{${namespace}.ModelID}.find\`,key,query)
    }
    \/**
    * 根据条件查询数据记录, 返回符合条件的结果集。
    * @param query
    * @returns ${modelInterface}[]
    */
    static Get(query:YaoQueryParam.QueryParam): ${modelInterface}[]{
        return Process(\`models.$\{${namespace}.ModelID}.get\`,query)
    }
    \/**
    * 根据条件查询数据记录, 返回带有分页信息的数据对象。
    * @param query
    * @param page
    * @param perPage
    * @returns ModelPaginateResult<${modelInterface}>
    */
    static Paginate(query:YaoQueryParam.QueryParam,page:number,perPage:number): ModelPaginateResult<${modelInterface}>{
        return Process(\`models.$\{${namespace}.ModelID}.Paginate\`,query,page,perPage)
    }

    \/**
    * 创建单条记录, 返回新创建记录的主键
    * @param data
    * @returns
    */
    static Create(data:${modelInterface}): number {
        return Process(\`models.$\{${namespace}.ModelID}.create\`,data)
    }

    \/**
    * 根据字段与数据，一次性插入多条数据记录，返回插入行数
    * @param columns
    * @param values
    * @returns
    */
    static Insert(columns:string[],values:any[][]): number {
        return Process(\`models.$\{${namespace}.ModelID}.Insert\`,columns,values)
    }

    \/**
    * 一次性插入多条数据记录，返回插入行数
    * @param data
    * @returns
    */
    static InsertBatch(data:${modelInterface}[]): number {
        const { columns, values } = Process('utils.arr.split', data);
        return Process(\`models.$\{${namespace}.ModelID}.Insert\`,columns,values)
    }

    \/**
    * 创建或更新单条记录。如数据记录中包含 id 则更新，不包含 id 则创建记录；返回创建或更新的记录 ID。
    * @param data
    * @returns
    */
    static Save(data:Partial<${modelInterface}>): number {
        return Process(\`models.$\{${namespace}.ModelID}.Save\`,data)
    }

    \/**
    * 根据主键更新单条数据记录。
    * @param key
    * @param line
    * @returns
    */
    static Update(key:${idFieldType},line:Partial<${modelInterface}>) {
        return Process(\`models.$\{${namespace}.ModelID}.Update\`,key,line)
    }

    \/**
    * 根据条件更新数据记录, 返回更新行数。
    * @param query
    * @param line
    * @returns
    */
    static UpdateWhere(query:YaoQueryParam.QueryParam,line:Partial<${modelInterface}>) {
        return Process(\`models.$\{${namespace}.ModelID}.UpdateWhere\`,query,line)
    }

    \/**
    * 批量创建或是更新多条记录, 不包含主键字段则创建记录, 存在更新记录。
    * @param data
    * @param line
    * @returns
    */
    static EachSave(data:${modelInterface}[],line:Partial<${modelInterface}>) {
        return Process(\`models.$\{${namespace}.ModelID}.EachSave\`,data,line)
    }

    \/**
    * 删除并保存数据，删除给定 ID 的记录后，保存多条记录数据, 不包含主键字段则创建记录, 存在更新记录, 返回记录 ID 集合 ，返回创建或更新的记录 ID 集合。
    * @param keys
    * @param data
    * @param line
    * @returns
    */
    static EachSaveAfterDelete(keys:${idFieldType}[],data:${modelInterface}[],line:Partial<${modelInterface}>) {
        return Process(\`models.$\{${namespace}.ModelID}.EachSaveAfterDelete\`,keys,data,line)
    }

    \/**
    * 根据主键删除数据
    * @param key
    * @returns
    */
    static Delete(key:${idFieldType}){
        return Process(\`models.$\{${namespace}.ModelID}.Delete\`,key)
    }

    \/**
    * 删除所有数据
    * @returns
    */
    static DeleteAll(){
        // use statement
        return new Query('default').Run({
          sql: { stmt: \`delete from $\{${namespace}.TableName}\` }
        });
    }

    \/**
    * 根据条件删除数据
    * @param query
    * @returns
    */
    static DeleteWhere(query:YaoQueryParam.QueryParam){
        return Process(\`models.$\{${namespace}.ModelID}.DeleteWhere\`,query)
    }

    \/**
    * 根据主键真删除单条数据记录。
    * @param key
    * @returns
    */
    static Destroy(key:${idFieldType}){
        return Process(\`models.$\{${namespace}.ModelID}.Destroy\`,key)
    }

    \/**
    * 按条件硬删除
    * @param query
    * @returns
    */
    static DestroyWhere(query:YaoQueryParam.QueryParam){
        return Process(\`models.$\{${namespace}.ModelID}.DestroyWhere\`,query)
    }
}`;
}
