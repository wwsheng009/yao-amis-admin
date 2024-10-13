import { getFieldsTemplate, toCamelCaseNameSpace } from './tstype';
import { YaoModel } from '@yaoapps/types';
import { ModelId, AmisUIColumn } from '@yao/types';
import { getModelDslById } from './model';
import { amisUIModelToAmisModel } from './model_convert';

/**
 * yao run scripts.system.tscode.generateCodeTemplate admin.user
 * @param modelId
 * @returns
 */
export function generateCodeTemplate(
  modelId: ModelId,
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
  //fields
  const fieldsCode = getFieldsTemplate(model);

  const namespace = toCamelCaseNameSpace(modelId);
  //service template
  return `
${'import'} { Process } from '@yaoapps/client';
${'import'} { YaoQueryParam } from '@yaoapps/types';

${fieldsCode}

${'export'} interface ${namespace}Paginate {
  \/**数据记录集合 */
  data: ${namespace}[];
  \/**下一页，如没有下一页返回-1*/
  next: number;
  \/**上一页，如没有上一页返回-1*/
  prev: number;
  \/**当前页码 */
  page: number;
  \/**每页记录数量 */
  pagesize: number;
  \/**总页数 */
  pagecnt: number;
  \/**总记录数 */
  total: number;
}
  
  ${getFunctionsTemplate(modelId)}
 `;
}

function getFunctionsTemplate(modelID: ModelId) {
  const namespace = toCamelCaseNameSpace(modelID);

  return `
\/**
 * 根据主键 id 查询单条记录。
 * @param id
 * @param where
 * @returns
 */
function Find(id:number,where:YaoQueryParam.QueryParam): ${namespace}{
    return Process('models.${modelID}.find',id,where)
}
\/**
 * 根据条件查询数据记录, 返回符合条件的结果集。
 * @param where
 * @returns
 */
function Get(where:YaoQueryParam.QueryParam): ${namespace}[]{
    return Process('models.${modelID}.get',where)
}
\/**
 * 根据条件查询数据记录, 返回带有分页信息的数据对象。
 * @param where
 * @param page
 * @param perPage
 * @returns
 */
function Paginate(where:YaoQueryParam.QueryParam,page:number,perPage:number): ${namespace}Paginate[]{
    return Process('models.${modelID}.Paginate',where,page,perPage)
}

\/**
 * 创建单条记录, 返回新创建记录的主键
 * @param data
 * @returns
 */
function Create(data:${namespace}): number {
    return Process('models.${modelID}.create',data)
}

\/**
 * 一次性插入多条数据记录，返回插入行数
 * @param fields
 * @param data
 * @returns
 */
function Insert(fields:string[],data:any[][]): number {
    return Process('models.${modelID}.Insert',fields,data)
}

\/**
 * 创建或更新单条记录。如数据记录中包含 id 则更新，不包含 id 则创建记录；返回创建或更新的记录 ID。
 * @param data
 * @returns
 */
function Save(data:${namespace}): number {
    return Process('models.${modelID}.Save',data)
}

\/**
 * 根据主键 id 更新单条数据记录。
 * @param id
 * @param line
 * @returns
 */
function Update(id:number,line:${namespace}) {
    return Process('models.${modelID}.Update',id,line)
}

\/**
 * 根据条件更新数据记录, 返回更新行数。
 * @param where
 * @param line
 * @returns
 */
function UpdateWhere(where:YaoQueryParam.QueryParam,line:${namespace}) {
    return Process('models.${modelID}.UpdateWhere',where,line)
}

\/**
 * 批量创建或是更新多条记录, 不包含主键字段则创建记录, 存在更新记录。
 * @param data
 * @param line
 * @returns
 */
function EachSave(data:${namespace}[],line:${namespace}) {
    return Process('models.${modelID}.EachSave',data,line)
}

\/**
 * 删除并保存数据，删除给定 ID 的记录后，保存多条记录数据, 不包含主键字段则创建记录, 存在更新记录, 返回记录 ID 集合 ，返回创建或更新的记录 ID 集合。
 * @param ids
 * @param data
 * @param line
 * @returns
 */
function EachSaveAfterDelete(ids:number[],data:${namespace}[],line:${namespace}) {
    return Process('models.${modelID}.EachSaveAfterDelete',ids,data,line)
}

\/**
 * 根据 id 删除数据
 * @param id
 * @returns
 */
function Delete(id:number){
    return Process('models.${modelID}.Delete',id)
}

\/**
 * 根据条件删除数据
 * @param where
 * @returns
 */
function DeleteWhere(where:YaoQueryParam.QueryParam){
    return Process('models.${modelID}.DeleteWhere',where)
}

\/**
 * 根据主键 id 真删除单条数据记录。
 * @param id
 * @returns
 */
function Destroy(id:number){
    return Process('models.${modelID}.Destroy',id)
}

\/**
 * 根据主键 id 真删除单条数据记录。
 * @param where
 * @returns
 */
function DestroyWhere(where:YaoQueryParam.QueryParam){
    return Process('models.${modelID}.DestroyWhere',where)
}


${'export'} default {
  Find,
  Get,
  Paginate,
  Create,
  Insert,
  Save,
  Update,
  UpdateWhere,
  EachSave,
  EachSaveAfterDelete,
  Delete,
  DeleteWhere,
  Destroy,
  DestroyWhere
};`;
}
