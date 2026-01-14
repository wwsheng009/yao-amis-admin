
// TypeScript type definitions for the Golang code

export type QueryParam = {
  model?: string; // optional, the model to query
  table?: string; // optional, the table to query
  alias?: string; // optional, table alias
  export?: string; // optional, export prefix
  select?: (string | Raw)[]; // optional, select columns, can be strings or Raw
  wheres?: QueryWhere[]; // optional, array of where conditions
  orders?: QueryOrder[]; // optional, array of ordering conditions
  limit?: number; // optional, limit records
  page?: number; // optional, pagination page number
  pageSize?: number; // optional, number of records per page
  withs?: Record<string, With>; // optional, mapping of relations
}

export type Raw = any; // Placeholder for actually defining Raw type

export type QueryWhere = {
  rel?: string; // optional, relation name
  column?: string | Raw; // column to apply where on
  value?: any; // the value to compare with
  method?: string; // method for where clause such as 'where', 'orwhere'
  op?: string; // operator such as 'eq', 'gt'
  wheres?: QueryWhere[]; // nested wheres for grouped conditions
}

export type QueryOrder = {
  rel?: string; // optional, relation name
  column: string; // column to order by
  option?: string; // ordering option 'asc', 'desc'
}

export type With = {
  name: string; // the relation name
  query?: QueryParam; // query parameters for the relation
}

/**
 * Find a record by id
 * @param process models.**WidgetID**.Find
 * @param id string | number record id
 * @param query query parameters
 */
export declare function Process(
  process: `models.${string}.Find`,
  id: string | number,
  query: QueryParam
): Record<string, any>;

/**
 * Get records based on query parameters
 * @param process models.**WidgetID**.Get
 * @param query query parameters
 */
export declare function Process(
  process: `models.${string}.Get`,
  query: QueryParam
): Record<string, any>[];

/**
 * Paginate records based on query parameters
 * @param process models.**WidgetID**.Paginate
 * @param query query parameters
 * @param page number page number
 * @param pageSize number size of page
 */
export declare function Process(
  process: `models.${string}.Paginate`,
  query: QueryParam,
  page: number,
  pageSize: number
): Record<string, any>;

/**
 * Create a new record
 * @param process models.**WidgetID**.Create
 * @param row new record data
 */
export declare function Process(
  process: `models.${string}.Create`,
  row: Record<string, any>
): number;

/**
 * Update a record by id
 * @param process models.**WidgetID**.Update
 * @param id string | number record id
 * @param row data to update
 */
export declare function Process(
  process: `models.${string}.Update`,
  id: string | number,
  row: Record<string, any>
): void;

/**
 * Save a record (create or update)
 * @param process models.**WidgetID**.Save
 * @param row record data
 */
export declare function Process(
  process: `models.${string}.Save`,
  row: Record<string, any>
): number;

/**
 * Delete a record by id
 * @param process models.**WidgetID**.Delete
 * @param id string | number record id
 */
export declare function Process(
  process: `models.${string}.Delete`,
  id: string | number
): void;

/**
 * Destroy a record by id
 * @param process models.**WidgetID**.Destroy
 * @param id string | number record id
 */
export declare function Process(
  process: `models.${string}.Destroy`,
  id: string | number
): void;

/**
 * Insert multiple records
 * @param process models.**WidgetID**.Insert
 * @param columns column names
 * @param rows data rows to insert
 */
export declare function Process(
  process: `models.${string}.Insert`,
  columns: string[],
  rows: Array<Array<any>>
): void;

/**
 * Update records based on conditions
 * @param process models.**WidgetID**.UpdateWhere
 * @param query query parameters
 * @param row data to update
 */
export declare function Process(
  process: `models.${string}.UpdateWhere`,
  query: QueryParam,
  row: Record<string, any>
): number;

/**
 * Delete records based on conditions
 * @param process models.**WidgetID**.DeleteWhere
 * @param query query parameters
 */
export declare function Process(
  process: `models.${string}.DeleteWhere`,
  query: QueryParam
): number;

/**
 * Destroy records based on conditions
 * @param process models.**WidgetID**.DestroyWhere
 * @param query query parameters
 */
export declare function Process(
  process: `models.${string}.DestroyWhere`,
  query: QueryParam
): number;

/**
 * Save multiple records
 * @param process models.**WidgetID**.EachSave
 * @param records records data
 * @param eachRow additional data applied to each row
 */
export declare function Process(
  process: `models.${string}.EachSave`,
  records: Array<Record<string, any>>,
  eachRow?: Record<string, any>
): number[];

/**
 * Delete specified records and save new records
 * @param process models.**WidgetID**.EachSaveAfterDelete
 * @param ids record ids to delete
 * @param records new records data
 * @param eachRow additional data applied to each new row
 */
export declare function Process(
  process: `models.${string}.EachSaveAfterDelete`,
  ids: number[],
  records: Array<Record<string, any>>,
  eachRow?: Record<string, any>
): number[];

/**
 * Get select options
 * @param process models.**WidgetID**.SelectOption
 * @param keyword search keyword
 * @param name property to use as name, default 'name'
 * @param value property to use as value, default 'id'
 * @param limit max number of results, default 20
 */
export declare function Process(
  process: `models.${string}.SelectOption`,
  keyword?: string,
  name?: string,
  value?: string,
  limit?: number,
): Record<'name' | 'id', any>[];

/**
 * Migrate the model
 * @param process models.**WidgetID**.Migrate
 * @param force whether to force the migration
 */
export declare function Process(
  process: `models.${string}.Migrate`,
  force?: boolean,
): void;

/**
 * Load the model
 * @param process models.**WidgetID**.Load
 * @param file the file path
 * @param source optional source data
 */
export declare function Process(
  process: `models.${string}.Load`,
  file: string,
  source?: string
): void;

/**
 * Reload the model
 * @param process models.**WidgetID**.Reload
 */
export declare function Process(
  process: `models.${string}.Reload`,
): void;

/**
 * Read the model DSL
 * @param process models.**WidgetID**.Read
 */
export declare function Process(
  process: `models.${string}.Read`
): any;

/**
 * Check if the model is loaded
 * @param process models.**WidgetID**.Exists
 */
export declare function Process(
  process: `models.${string}.Exists`
): boolean;

