import { Process } from '@yaoapps/client';
import { ModelPaginateResult, YaoQueryParam } from '@yaoapps/types';

// 代理调用YAO内部的处理器，主要是为了方便调用，避免每次都要写 Process('models.${modelID}.xxx', params)
// 同时也使用Typescript定义函数的参数类型定义，方便查阅。

export type ID = number | string;
export type YaoRecord = { [key: string]: any };
export type SelectOption = {
  name: string;
  id: string | number;
};

export interface UploadFile {
  name: string;
  tempFile: string;
  size: number;
  mimeType: YaoRecord;
}

export class ModelProxy<T> {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  /**
   * Find 根据主键与附加条件查询单条记录。
   * @param key 主键
   * @param query 筛选条件
   * @returns T
   */
  Find(key: ID, query: YaoQueryParam.QueryParam): T {
    return Process(`models.${this.name}.Find`, key, query);
  }
  /**
   * Paginate 按条件查询, 分页, 失败抛出异常
   * @param query
   * @param page
   * @param pagesize
   * @returns
   */
  Paginate(
    query: YaoQueryParam.QueryParam,
    page: number,
    pagesize: number
  ): ModelPaginateResult<T> {
    return Process(`models.${this.name}.Paginate`, query, page, pagesize);
  }
  /**
   * Get 按条件查询, 不分页, 失败抛出异常
   * @param query
   * @returns
   */
  Get(query: YaoQueryParam.QueryParam): Array<T> {
    return Process(`models.${this.name}.Get`, query);
  }
  /**
   * Create 创建单条数据, 返回新创建数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Create(record: T): number {
    return Process(`models.${this.name}.Create`, record);
  }

  /**
   * Update 更新单条数据, 失败抛出异常
   * @param key
   * @param record
   * @returns
   */
  Update(key: ID, record: T): null {
    return Process(`models.${this.name}.Update`, key, record);
  }
  /**
   * Save 保存单条数据, 返回数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Save(record: T): ID {
    return Process(`models.${this.name}.Save`, record);
  }
  /**
   * Delete 删除单条记录, 失败抛出异常
   * @param key
   * @returns
   */
  Delete(key: ID): null {
    return Process(`models.${this.name}.Delete`, key);
  }
  /**
   * Destroy 真删除单条记录, 失败抛出异常
   * @param key
   * @returns
   */
  Destroy(key: ID): null {
    return Process(`models.${this.name}.Destroy`, key);
  }
  /**
   * Insert 插入多条数据, 失败抛出异常
   * @param fields
   * @param records
   * @returns
   */
  Insert(fields: Array<string>, records: Array<Array<any>>): number {
    return Process(`models.${this.name}.Insert`, fields, records);
  }
  /**
   * UpdateWhere 按条件更新记录, 返回更新行数, 失败抛出异常
   * @param query
   * @param record
   * @returns
   */
  UpdateWhere(query: YaoQueryParam.QueryParam, record: YaoRecord): number {
    return Process(`models.${this.name}.UpdateWhere`, query, record);
  }

  /**
   * DeleteWhere 批量删除数据, 返回更新行数, 失败抛出异常
   * @param query
   * @returns
   */
  DeleteWhere(query: YaoQueryParam.QueryParam): number {
    return Process(`models.${this.name}.DeleteWhere`, query);
  }
  /**
   * DestroyWhere 批量真删除数据, 返回更新行数, 失败抛出异常
   * @param query
   * @returns
   */
  DestroyWhere(query: YaoQueryParam.QueryParam): number {
    return Process(`models.${this.name}.DestroyWhere`, query);
  }

  /**
   * EachSave 批量保存数据, 返回数据ID集合, 失败抛出异常
   * @param rows
   * @param eachRow 每行都相同的内容
   * @returns
   */
  EachSave(rows: Array<YaoRecord>, eachRow?: YaoRecord): Array<number> {
    return Process(`models.${this.name}.EachSave`, rows, eachRow);
  }
  /**
   * EachSaveAfterDelete 批量删除数据后，再批量保存数据, 返回数据ID集合, 失败抛出异常
   * @param keys 需要删除的数据主键集合
   * @param rows
   * @param eachRow
   * @returns
   */
  EachSaveAfterDelete(
    keys: Array<ID>,
    rows: Array<YaoRecord>,
    eachRow?: YaoRecord
  ): Array<ID> {
    return Process(
      `models.${this.name}.EachSaveAfterDelete`,
      keys,
      rows,
      eachRow
    );
  }

  /**
   *
   * @param keyword
   * @param name
   * @param value
   * @param limit
   * @returns
   */
  SelectOption(
    keyword?: string,
    name: string = 'name',
    value: string = 'id',
    limit: number = 20
  ): Array<SelectOption> {
    return Process(
      `models.${this.name}.SelectOption`,
      keyword,
      name,
      value,
      limit
    );
  }

  Migrate(force: boolean = false): Error {
    return Process(`models.${this.name}.Migrate`, force);
  }

  Load(file: string, source?: string): Error {
    return Process(`models.${this.name}.Load`, file, source);
  }
}

// Interface for Blueprint
export interface Blueprint {
  columns?: SchemaColumn[];
  indexes?: SchemaIndex[];
  option?: BlueprintOption;
}

export interface BlueprintDiff {
  Columns: {
    Add: SchemaColumn[];
    Del: SchemaColumn[];
    Alt: SchemaColumn[];
  };
  Indexes: {
    Add: SchemaIndex[];
    Del: SchemaIndex[];
    Alt: SchemaIndex[];
  };
  Option: { [key: string]: boolean };
}

// Interface for BlueprintOption
interface BlueprintOption {
  timestamps?: boolean; // + created_at, updated_at fields
  soft_deletes?: boolean; // + deleted_at field
  trackings?: boolean; // + created_by, updated_by, deleted_by fields
  constraints?: boolean; // + 约束定义
  permission?: boolean; // + __permission fields
  logging?: boolean; // + __logging_id fields
  read_only?: boolean; // + Ignore the migrate operation
}

// Interface for Column
interface SchemaColumn {
  name: string;
  label?: string;
  type?: string;
  title?: string;
  description?: string;
  comment?: string;
  length?: number;
  precision?: number;
  scale?: number;
  nullable?: boolean;
  option?: string[];
  default?: any; // `interface{}` in Go translates to `any` in TypeScript
  default_raw?: string;
  generate?: string; // Increment, UUID,...
  crypt?: string; // AES, PASSWORD, AES-256, AES-128, PASSWORD-HASH, ...
  index?: boolean;
  unique?: boolean;
  primary?: boolean;
  origin?: string;
}

// Interface for Index
export interface SchemaIndex {
  comment?: string;
  name?: string;
  columns?: string[];
  type?: string; // primary, unique, index, match
  origin?: string;
}

export class SchemaProxy {
  name: string;
  constructor(name: string) {
    this.name = name;
  }

  /**
   * Create a Schema
   * @param name
   * @returns
   */
  Create(name: string): void {
    return Process(`schemas.${this.name}.Create`, name);
  }

  /**
   * Delete a Schema
   * @param name
   * @returns
   */
  Drop(name: string): void {
    return Process(`schemas.${this.name}.Drop`, name);
  }

  /**
   * Read tables, return array of table names
   * @param preifx
   * @returns
   */
  Tables(preifx?: string): string[] {
    return Process(`schemas.${this.name}.Tables`, preifx);
  }

  /**
   * Read table structure, return table structure information
   * @param tableName
   * @returns
   */
  TableGet(tableName: string): Blueprint {
    return Process(`schemas.${this.name}.TableGet`, tableName);
  }

  /**
   * Create a table
   * @param tableName
   * @param structure
   * @returns
   */
  TableCreate(tableName: string, structure: Blueprint): void {
    return Process(`schemas.${this.name}.TableCreate`, tableName, structure);
  }

  /**
   * Save a table (create if not exists, update if exists)
   * @param tableName
   * @param structure
   * @returns
   */
  TableSave(tableName: string, structure: Blueprint): void {
    return Process(`schemas.${this.name}.TableSave`, tableName, structure);
  }

  /**
   * Delete a table
   * @param tableName
   * @returns
   */
  TableDrop(tableName: string): void {
    return Process(`schemas.${this.name}.TableDrop`, tableName);
  }

  /**
   *  Rename a table
   * @param tableName
   * @param newTableName
   * @returns
   */
  TableRename(tableName: string, newTableName: string): void {
    return Process(`schemas.${this.name}.TableRename`, tableName, newTableName);
  }

  /**
   * Compare two table structures, return differences
   * @param blueprint
   * @param anotherBlueprint
   * @returns
   */
  TableDiff(blueprint: Blueprint, anotherBlueprint: Blueprint): BlueprintDiff {
    return Process(
      `schemas.${this.name}.TableDiff`,
      blueprint,
      anotherBlueprint
    );
  }

  /**
   * Add a column to a table
   * @param tableName
   * @param columnStructure
   * @returns
   */
  ColumnAdd(tableName: string, columnStructure: SchemaColumn): void {
    return Process(
      `schemas.${this.name}.ColumnAdd`,
      tableName,
      columnStructure
    );
  }

  /**
   * Alter a column (add if not exists)
   * @param tableName
   * @param columnStructure
   * @returns
   */
  ColumnAlt(tableName: string, columnStructure: SchemaColumn): void {
    return Process(
      `schemas.${this.name}.ColumnAlt`,
      tableName,
      columnStructure
    );
  }

  /**
   * Delete a column
   * @param tableName
   * @param columnName
   * @returns
   */
  ColumnDel(tableName: string, columnName: string): void {
    return Process(`schemas.${this.name}.ColumnDel`, tableName, columnName);
  }

  /**
   * Add an index to a table
   * @param tableName
   * @param indexStructure
   * @returns
   */
  IndexAdd(tableName: string, indexStructure: SchemaIndex): void {
    return Process(`schemas.${this.name}.IndexAdd`, tableName, indexStructure);
  }

  /**
   * Delete an index
   * @param tableName
   * @param indexName
   * @returns
   */
  IndexDel(tableName: string, indexName: string): void {
    return Process(`schemas.${this.name}.IndexDel`, tableName, indexName);
  }
}

export default class TableProxy<T> {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  Setting(): YaoRecord {
    return Process(`yao.table.Setting`, this.name);
  }
  Xgen(): YaoRecord {
    return Process(`yao.table.Xgen`, this.name);
  }
  /**
   *
   * 获取table中配置的远程组件信息
   * @param xpath 组件的路径，fields.filter.状态.edit.props.xProps
   * @param method 组件的列表属性，比如下拉框的远程数据 remote
   * @param query 查询条件
   * @returns
   */
  Component(
    xpath: string,
    method: string,
    query?: YaoQueryParam.QueryParam
  ): Array<YaoRecord> {
    return Process(`yao.table.Component`, this.name, xpath, method, query);
  }
  /**
   * 下载表字段关联的文件
   * @param field 字段
   * @param file 文件名
   * @param tokenString
   * @returns
   */
  Download(field: string, file: string, tokenString: string): any {
    return Process(`yao.table.Download`, this.name, field, file, tokenString);
  }
  /**
   * 上传文件
   * @param xpath 组件的路径，fields.table.相关图片.edit.props
   * @param method 组件的列表属性，api
   * @param fileKey $file.file
   * @returns
   */
  Upload(xpath: string, method: string, tmpfile: UploadFile): string {
    return Process(`yao.table.Download`, this.name, xpath, method, tmpfile);
  }
  /**
   * Find 查询单条记录
   * @param id
   * @param query
   * @returns
   */
  Find(id: number, query: YaoQueryParam.QueryParam): T {
    return Process(`yao.table.Find`, this.name, id, query);
  }
  /**
   * Search 按条件查询, 分页, 失败抛出异常
   * @param query
   * @param page
   * @param pagesize
   * @returns
   */
  Search(
    query: YaoQueryParam.QueryParam,
    page: number,
    pagesize: number
  ): ModelPaginateResult<T> {
    return Process(`yao.table.Search`, this.name, query, page, pagesize);
  }
  /**
   * Get 按条件查询, 不分页, 失败抛出异常
   * @param query
   * @returns
   */
  Get(query: YaoQueryParam.QueryParam): Array<T> {
    return Process(`yao.table.Get`, this.name, query);
  }
  /**
   * Create 创建单条数据, 返回新创建数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Create(record: T): number {
    return Process(`yao.table.Create`, this.name, record);
  }

  /**
   * Update 更新单条数据, 失败抛出异常
   * @param key
   * @param record
   * @returns
   */
  Update(key: ID, record: T): null {
    return Process(`yao.table.Update`, this.name, key, record);
  }
  /**
   * Save 保存单条数据, 返回数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Save(record: T): ID {
    return Process(`yao.table.Save`, this.name, record);
  }
  /**
   * Delete 删除单条记录, 失败抛出异常
   * @param key
   * @returns
   */
  Delete(key: ID): null {
    return Process(`yao.table.Delete`, this.name, key);
  }

  /**
   * Insert 插入多条数据, 失败抛出异常
   * @param columns
   * @param records
   * @returns
   */
  Insert(columns: Array<string>, records: Array<Array<any>>): null {
    return Process(`yao.table.Insert`, this.name, columns, records);
  }

  /**
   * 按ID更新数据
   * @param keys ids seperate by ','
   * @param record
   * @returns
   */
  UpdateIn(keys: string, record: YaoRecord): number {
    return Process(`yao.table.UpdateIn`, this.name, keys, record);
  }

  /**
   * UpdateWhere 按条件更新记录, 返回更新行数, 失败抛出异常
   * @param query
   * @param record
   * @returns
   */
  UpdateWhere(query: YaoQueryParam.QueryParam, record: YaoRecord): number {
    return Process(`yao.table.UpdateWhere`, this.name, query, record);
  }

  /**
   * DeleteWhere 批量删除数据, 返回更新行数, 失败抛出异常
   * @param query
   * @returns
   */
  DeleteWhere(query: YaoQueryParam.QueryParam): number {
    return Process(`yao.table.DeleteWhere`, this.name, query);
  }
  /**
   * 批量删除表记录
   * @param keys id array join by ','
   * @returns
   */
  DeleteIn(keys: string): number {
    return Process(`yao.table.DeleteIn`, this.name, keys);
  }

  /**
   * Export Export query result to Excel
   * @param params 查询条件
   * @param pagesize 单次查询的页面大小
   * @returns
   */
  Export(params: YaoQueryParam.QueryParam, pagesize: number): string {
    return Process(`yao.table.Export`, this.name, params, pagesize);
  }

  /**
   *  加载表定义
   * @param file 表的文件名称
   * @param source 表的DSL定义
   * @returns
   */
  Load(file: string, source?: string): Error {
    return Process(`yao.table.Load`, this.name, file, source);
  }

  /**
   * 重新加载表
   * @returns
   */
  Reload() {
    return Process(`yao.table.Reload`, this.name);
  }

  /**
   * 卸载表
   * @returns
   */
  Unload() {
    return Process(`yao.table.Unload`, this.name);
  }

  /**
   * 读取源代码
   * @returns
   */
  Read(): YaoRecord {
    return Process(`yao.table.Read`, this.name);
  }

  /**
   * 检查表是否存在
   * @returns
   */
  Exists(): boolean {
    return Process(`yao.table.Exists`, this.name);
  }
}

export class FormProxy<T> {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
  Setting(): YaoRecord {
    return Process(`yao.form.Setting`, this.name);
  }
  Xgen(): YaoRecord {
    return Process(`yao.form.Xgen`, this.name);
  }
  /**
   *
   * 获取table中配置的远程组件信息
   * @param xpath 组件的路径，fields.filter.状态.edit.props.xProps
   * @param method 组件的列表属性，比如下拉框的远程数据 remote
   * @param query 查询条件
   * @returns
   */
  Component(
    xpath: string,
    method: string,
    query?: YaoQueryParam.QueryParam
  ): Array<YaoRecord> {
    return Process(`yao.form.Component`, this.name, xpath, method, query);
  }
  /**
   * 下载表字段关联的文件
   * @param field 字段
   * @param file 文件名
   * @param tokenString
   * @returns
   */
  Download(field: string, file: string, tokenString: string): any {
    return Process(`yao.form.Download`, this.name, field, file, tokenString);
  }
  /**
   * 上传文件
   * @param xpath 组件的路径，fields.table.相关图片.edit.props
   * @param method 组件的列表属性，api
   * @param fileKey $file.file
   * @returns
   */
  Upload(xpath: string, method: string, tmpfile: UploadFile): string {
    return Process(`yao.form.Download`, this.name, xpath, method, tmpfile);
  }
  /**
   * Find 查询单条记录
   * @param id
   * @param query
   * @returns
   */
  Find(id: number, query: YaoQueryParam.QueryParam): T {
    return Process(`yao.form.Find`, this.name, id, query);
  }

  /**
   * Create 创建单条数据, 返回新创建数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Create(record: T): number {
    return Process(`yao.form.Create`, this.name, record);
  }

  /**
   * Update 更新单条数据, 失败抛出异常
   * @param id
   * @param record
   * @returns
   */
  Update(id: ID, record: T): null {
    return Process(`yao.form.Update`, this.name, id, record);
  }
  /**
   * Save 保存单条数据, 返回数据ID, 失败抛出异常
   * @param record
   * @returns
   */
  Save(record: T): ID {
    return Process(`yao.form.Save`, this.name, record);
  }
  /**
   * Delete 删除单条记录, 失败抛出异常
   * @param id
   * @returns
   */
  Delete(id: ID): null {
    return Process(`yao.form.Delete`, this.name, id);
  }

  /**
   * 从文件或是源代码加载表单定义
   * @param file 表单的文件名称
   * @param source 表单的DSL定义
   * @returns
   */
  Load(file: string, source?: string): Error {
    return Process(`yao.form.Load`, this.name, file, source);
  }

  /**
   * 重新加载表单
   * @returns
   */
  Reload() {
    return Process(`yao.form.Reload`, this.name);
  }

  /**
   * 卸载表单
   * @returns
   */
  Unload() {
    return Process(`yao.form.Unload`, this.name);
  }

  /**
   * 读取表单源代码
   * @returns
   */
  Read(): YaoRecord {
    return Process(`yao.form.Read`, this.name);
  }

  /**
   * 检查表单是否存在
   * @returns
   */
  Exists(): boolean {
    return Process(`yao.form.Exists`, this.name);
  }
}

export class ArrayProxy {
  /**
   * ArrayPluck 将多个数据记录集合，合并为一个数据记录集合
   * @param columns
   * @param pluck
   * @returns
   */
  static Pluck(
    columns: string[],
    pluck: { [key: string]: any }
  ): Array<YaoRecord> {
    return Process(`utils.arr.Pluck`, columns, pluck);
  }

  /**
   * Split 将多条数记录集合，分解为一个 columns:[]string 和 values: [][]interface{}
   * 输入：
   * [ { name: "阿里云计算有限公司", short_name: "阿里云" },
   *   { name: "世纪互联蓝云", short_name: "上海蓝云" },
   * ]
   * 输出
   * [["name","short_name"],[["阿里云计算有限公司","阿里云"],["世纪互联蓝云","上海蓝云"]]]
   * @param records
   * @returns
   */
  static Split(records: { [key: string]: any }[]): [string[], any[][]] {
    return Process(`utils.arr.Split`, records);
  }
  /**
   * 转树形结构
   * @returns
   */
  static Tree(
    records: Array<YaoRecord>,
    setting?: YaoRecord
  ): Array<YaoRecord> {
    return Process(`utils.arr.Tree`, records, setting);
  }
  static Indexes(array: Array<any>) {
    return Process(`utils.arr.Indexes`, array);
  }

  static Get(array: Array<any>, index: number) {
    return Process(`utils.arr.Get`, array, index);
  }
  /**
   * 仅保留指定键名的数据
   * @param records
   * @param keeps
   * @returns
   */
  static Keep(records: Array<YaoRecord>, keeps: string[]): Array<YaoRecord> {
    return Process(`utils.arr.Keep`, records, keeps);
  }
  /**
   * 数组排除重复
   * @param records
   * @returns
   */
  static Unique(records: Array<YaoRecord>): Array<YaoRecord> {
    return Process(`utils.arr.Unique`, records);
  }

  /**
   * update all the mapset records with special key and value
   * @param records
   * @param key
   * @param value
   * @returns
   */
  static MapSet(
    records: Array<YaoRecord>,
    key: string,
    value: any
  ): Array<YaoRecord> {
    return Process(`utils.arr.MapSet`, records, key, value);
  }

  static Column(records: Array<YaoRecord>, name: string): Array<YaoRecord> {
    return Process(`utils.arr.Column`, records, name);
  }
}

export class SessionProxy {
  static ID(): string {
    return Process(`session.id`);
  }
  static Get(id: string, sesstionId?: string): string {
    return Process(`session.Get`, id, sesstionId);
  }
  static Del(id: string, sesstionId?: string): string {
    return Process(`session.Del`, id, sesstionId);
  }

  static Set(id: string, key: string, value: any, sesstionId?: string): string {
    return Process(`session.Set`, id, sesstionId, key, value);
  }
  static Dump(): YaoRecord {
    return Process(`session.Dump`);
  }
  static GetMany(ids: string[], sesstionId?: string): string {
    return Process(`session.GetMany`, ids, sesstionId);
  }
  static SetMany(obj: YaoRecord, timeout: number, sesstionId?: string): string {
    return Process(`session.SetMany`, obj, timeout, sesstionId);
  }
  static DelMany(ids: string[], sesstionId?: string): string {
    return Process(`session.DelMany`, ids, sesstionId);
  }
}

export class NowProxy {
  /**
   * get the timestamp in seconds in unix format
   * @returns
   */
  static Timestamp() {
    return Process(`utils.now.timestamp`);
  }
  /**
   * get the timestamp in micro seconds in unix format
   * @returns
   */
  static Timestampms() {
    return Process(`utils.now.timestampms`);
  }
  static Date() {
    return Process(`utils.now.Date`);
  }
  static DateTime() {
    return Process(`utils.now.DateTime`);
  }
  static Time() {
    return Process(`utils.now.Time`);
  }
}

export class MapProxy {
  static Get(record: YaoRecord, key: string): YaoRecord {
    return Process(`utils.map.get`, record, key);
  }

  static Set(record: YaoRecord, key: string, value: any): YaoRecord {
    return Process(`utils.map.Set`, record, key, value);
  }

  static Del(record: YaoRecord, key: string): YaoRecord {
    return Process(`utils.map.Del`, record, key);
  }
  static Delmany(record: YaoRecord, keys: string[]): YaoRecord {
    return Process(`utils.map.delmany`, record, keys);
  }

  static Keys(record: YaoRecord): string[] {
    return Process(`utils.map.Keys`, record);
  }

  static Values(record: YaoRecord): any[] {
    return Process(`utils.map.Values`, record);
  }

  static Merge(record: YaoRecord, record2: YaoRecord): YaoRecord {
    return Process(`utils.map.Merge`, record, record2);
  }

  /**
   * convert map object, extra the values to array
   * @param record
   * @returns
   */
  static Array(record: YaoRecord): any[] {
    return Process(`utils.map.Array`, record);
  }
}

export interface CaptchaOption {
  width?: string;
  height?: string;
  lenght?: string;
  type?: string;
  background?: string;
  lang?: string;
}

export interface CaptchaContent {
  id: number;
  content: string;
}
export class CaptchaProxy {
  /**
   * 创建一个认证码图片
   * @param option
   * @returns
   */
  static Make(
    option: CaptchaOption = {
      width: '240',
      height: '80',
      lenght: '6',
      type: 'math',
      background: '#FFFFFF',
      lang: 'zh'
    }
  ): CaptchaContent {
    return Process(`utils.captcha.Make`, option);
  }
  /**
   * 检查验证码图片是否正确
   * @param id
   * @param code
   * @returns
   */
  static Verify(id: string, code: string): boolean {
    return Process(`utils.captcha.Verify`, id, code);
  }
}

export class StrProxy {
  static Concat(str: string, str2: string): string {
    return Process(`utils.str.Concat`, str, str2);
  }

  static Join(strs: string[], sep: string): string {
    return Process(`utils.str.Join`, strs, sep);
  }

  static JoinPath(str: string, ...str2: string[]): string {
    return Process(`utils.str.JoinPath`, str, ...str2);
  }

  static UUID(): string {
    return Process(`utils.str.UUID`);
  }
}

export interface FlattenOption {
  primary?: string;
  children?: string;
  parent?: string;
}
export interface JwtToken {
  token: string;
  expires_at: number;
}
export interface JwtOption {
  subject?: string;
  audience?: string;
  issuer?: string;
  sid?: string;
  timeout?: number;
  expires_at?: number;
}
export interface JwtClaims {
  id: string;
  sid: string;
  data: YaoRecord;
  aud?: string;
  exp?: number;
  jti?: string;
  iat?: number;
  iss?: string;
  nbf?: number;
  sub?: string;
}

/**
 * 日志对象
 */
export class UtilsProxy {
  //   static with(c: YaoApplication) {
  //     Base.client = c;
  //     return this; // Return the class itself
  //   }
  //   static client: YaoApplication;

  static Now(): typeof NowProxy {
    return NowProxy;
  }
  static Arr(): typeof ArrayProxy {
    return ArrayProxy;
  }
  static Map(): typeof MapProxy {
    return MapProxy;
  }

  static Captcha(): typeof CaptchaProxy {
    return CaptchaProxy;
  }

  static Str(): typeof StrProxy {
    return StrProxy;
  }
  static Session(): typeof SessionProxy {
    return SessionProxy;
  }

  static FlattenTree(
    tree: Array<YaoRecord>,
    option: FlattenOption = {
      primary: 'id',
      children: 'children',
      parent: 'parent'
    }
  ): Array<YaoRecord> {
    return Process('utils.tree.Flatten', tree, option);
  }

  static PasswordValidate(password: string, passwordHash: string): boolean {
    return Process('utils.pwd.Verify', password, passwordHash);
  }

  /**
   * Make jwt Token
   * @param uid unique id
   * @param data user data
   * @param option jwt option
   * @returns
   */
  static JwtMake(uid: number, data: YaoRecord, option: JwtOption): JwtToken {
    return Process('utils.jwt.Make', uid, data, option);
  }
  /**
   * Vlidate the token string
   * @param tokenString jwt token
   * @param secret
   * @returns
   */
  static JwtValidate(tokenString: string, secret: ArrayBuffer): JwtClaims {
    return Process('utils.jwt.Verify', tokenString, secret);
  }

  static SSLSign(data: string, certName: string, algorithm: string): string {
    return Process('ssl.sign', data, certName, algorithm);
  }

  static SSLVerify(
    data: string,
    sign: string,
    certName: string,
    algorithm: string
  ): boolean {
    return Process('ssl.verify', data, sign, certName, algorithm);
  }
}

export interface UploadFile {
  name: string;
  tempFile: string;
  size: number;
  header: { [key: string]: string[] };
  error: string;
}

export class SystemFileProxy {
  /**
   * Reads a file from the filesystem.
   * @param {string} path - The path of the file to read.
   * @returns {string} - The file content as a string.
   */
  static readfile(path: string): string {
    return Process('fs.system.readfile', path);
  }

  /**
   * Reads a file and returns its content as a buffer.
   * @param {string} path - The path of the file to read.
   * @returns {Buffer} - The file content as a buffer.
   */
  static readfilebuffer(path: string): Buffer {
    return Process('fs.system.readfilebuffer', path);
  }

  /**
   * Writes content to a file.
   * @param {string} path - The path of the file to write.
   * @param {string} data - The content to write to the file.
   * @returns {number}
   */
  static writefile(path: string, data: string): number {
    return Process('fs.system.writefile', path, data);
  }

  /**
   * Writes a buffer to a file.
   * @param {string} path - The path of the file to write.
   * @param {Buffer} buffer - The buffer to write to the file.
   * @returns {number}
   */
  static writefilebuffer(path: string, buffer: Buffer): number {
    return Process('fs.system.writefilebuffer', path, buffer);
  }

  /**
   * Reads the contents of a directory.
   * @param {string} path - The path of the directory to read.
   * @returns {string[]} - An array of file and directory names.
   */
  static readdir(path: string): string[] {
    return Process('fs.system.readdir', path);
  }

  /**
   * Creates a new directory.
   * @param {string} path - The path of the directory to create.
   * @param {number} mode - The path of the directory to create.
   * @returns {void}
   */
  static mkdir(path: string, mode: number): void {
    return Process('fs.system.mkdir', path, mode);
  }

  /**
   * Creates a directory and any necessary subdirectories.
   * @param {string} path - The path of the directory to create.
   * @param {number} mode - The path of the directory to create.
   * @returns {void}
   */
  static mkdirall(path: string, mode: number): void {
    return Process('fs.system.mkdirall', path, mode);
  }

  /**
   * Creates a temporary directory.
   * @returns {string} - The path of the created temporary directory.
   * @param {string} dir - The directory to create the temporary directory in.
   * @param {string} pattern - The pattern to use for the temporary directory name.
   */
  static mkdirtemp(dir: string, pattern: string): string {
    return Process('fs.system.mkdirtemp', dir, pattern);
  }

  /**
   * Removes a file or directory.
   * @param {string} path - The path of the file or directory to remove.
   * @returns {void}
   */
  static remove(path: string): void {
    return Process('fs.system.remove', path);
  }

  /**
   * Removes a directory and all its contents.
   * @param {string} path - The path of the directory to remove.
   * @returns {void}
   */
  static removeall(path: string): void {
    return Process('fs.system.removeall', path);
  }

  /**
   * Checks if a file or directory exists.
   * @param {string} path - The path to check.
   * @returns {boolean} - True if the file or directory exists, false otherwise.
   */
  static exists(path: string): boolean {
    return Process('fs.system.exists', path);
  }

  /**
   * Checks if the path is a directory.
   * @param {string} path - The path to check.
   * @returns {boolean} - True if the path is a directory, false otherwise.
   */
  static isdir(path: string): boolean {
    return Process('fs.system.isdir', path);
  }

  /**
   * Checks if the path is a file.
   * @param {string} path - The path to check.
   * @returns {boolean} - True if the path is a file, false otherwise.
   */
  static isfile(path: string): boolean {
    return Process('fs.system.isfile', path);
  }

  /**
   * Checks if the path is a symbolic link.
   * @param {string} path - The path to check.
   * @returns {boolean} - True if the path is a symbolic link, false otherwise.
   */
  static islink(path: string): boolean {
    return Process('fs.system.islink', path);
  }

  /**
   * Changes the permissions of a file or directory.
   * @param {string} path - The path of the file or directory.
   * @param {number} mode - The new permissions.
   * @returns {void}
   */
  static chmod(path: string, mode: number): void {
    return Process('fs.system.chmod', path, mode);
  }

  /**
   * Gets the size of a file.
   * @param {string} path - The path of the file.
   * @returns {number} - The size of the file in bytes.
   */
  static size(path: string): number {
    return Process('fs.system.size', path);
  }

  /**
   * Gets the mode (permissions) of a file or directory.
   * @param {string} path - The path of the file or directory.
   * @returns {number} - The mode (permissions) of the file or directory.
   */
  static mode(path: string): number {
    return Process('fs.system.mode', path);
  }

  /**
   * Gets the modification time of a file.
   * @param {string} path - The path of the file.
   * @returns {number} - The modification time(unix) of the file.
   */
  static modtime(path: string): number {
    return Process('fs.system.modtime', path);
  }

  /**
   * Gets the base name of a file or directory.
   * @param {string} path - The path of the file or directory.
   * @returns {string} - The base name of the file or directory.
   */
  static basename(path: string): string {
    return Process('fs.system.basename', path);
  }

  /**
   * Gets the directory name of a file path.
   * @param {string} path - The path of the file or directory.
   * @returns {string} - The directory name.
   */
  static dirname(path: string): string {
    return Process('fs.system.dirname', path);
  }

  /**
   * Gets the extension name of a file.
   * @param {string} path - The path of the file.
   * @returns {string} - The extension name.
   */
  static extname(path: string): string {
    return Process('fs.system.extname', path);
  }

  /**
   * Gets the MIME type of a file.
   * @param {string} path - The path of the file.
   * @returns {string} - The MIME type.
   */
  static mimetype(path: string): string {
    return Process('fs.system.mimetype', path);
  }

  /**
   * Moves a file or directory.
   * @param {string} source - The source path.
   * @param {string} destination - The destination path.
   * @returns {void}
   */
  static move(source: string, destination: string): void {
    return Process('fs.system.move', source, destination);
  }

  /**
   * Copies a file or directory.
   * @param {string} source - The source path.
   * @param {string} destination - The destination path.
   * @returns {void}
   */
  static copy(source: string, destination: string): void {
    return Process('fs.system.copy', source, destination);
  }

  /**
   * 把文件从临时目录写入到应用目录下，并以当天的目录创建一个子目录，并返回文件名，
   * 这个文件名也是一个自动生成的唯一的文件名
   *
   * 它的主要作用是放在各种api接口配置中，接收http上传的文件内容。
   *
   * 如果需要定义文件保存的文件名跟路径，可以参考这个处理器，针对tempfile进行自定义处理。
   * @param {string} tmpfile - The path of the file to upload.
   * @returns {string} 返回的是应用目录下的文件名。
   */
  static upload(tmpfile: UploadFile): string {
    return Process('fs.system.upload', tmpfile);
  }

  /**
   * Downloads a file from a remote server.
   * @param {string} filename - The URL of the file to download.
   * @returns {data} - The downloaded file content as a number array and its MIME type.
   */
  static download(filename: string): { content: number[]; type: string } {
    return Process('fs.system.download', filename);
  }

  /**
   * Creates a ZIP archive of a directory or file.
   * @param {string} source - The source path.
   * @param {string} destination - The destination path for the ZIP file.
   * @returns {void}
   */
  static zip(source: string, destination: string): void {
    return Process('fs.system.zip', source, destination);
  }

  /**
   * Extracts a ZIP archive.
   * @param {string} source - The path of the ZIP file to extract.
   * @param {string} destination - The destination directory.
   * @returns {void}
   */
  static unzip(source: string, destination: string): void {
    return Process('fs.system.unzip', source, destination);
  }

  /**
   * Finds files matching a pattern.
   * @param {string} pattern - The pattern to match (e.g., '*.txt').
   * @returns {string[]} - An array of matching file paths.
   */
  static glob(pattern: string): string[] {
    return Process('fs.system.glob', pattern);
  }

  /**
   * Merges multiple source file into a target file.
   *
   * @param source - An array of source file to be merged.
   * @param target - The target file where the sources will be merged.
   * @returns {void} - This function does not return a value.
   */
  static merge(source: string[], target: string): void {
    return Process('fs.system.merge', source, target);
  }
}
