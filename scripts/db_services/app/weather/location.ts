import { Process, Query } from '@yaoapps/client';
import { ModelPaginateResult, YaoQueryParam } from '@yaoapps/types';

/**
 * Model=> app.weather.location (地区信息)
 *
 * Table=> app_weather_location (地区信息表)
 */
export interface IAppWeatherLocation {
  /**ID */
  id?: number;
  /**省份编码 */
  province_code: string;
  /**地区名称 */
  name: string;
  /**地区代码 */
  code: string;
  /**删除时间 */
  deleted_at?: Date;
  /**创建时间 */
  created_at?: Date;
  /**更新时间 */
  updated_at?: Date;
}

export class AppWeatherLocationService {
  static FieldNames = {
    /** ID */
    id: 'id',
    /** 省份编码 */
    province_code: 'province_code',
    /** 地区名称 */
    name: 'name',
    /** 地区代码 */
    code: 'code',
    /** 删除时间 */
    deleted_at: 'deleted_at',
    /** 创建时间 */
    created_at: 'created_at',
    /** 更新时间 */
    updated_at: 'updated_at'
  };
  static ModelID = 'app.weather.location';
  static TableName = 'app_weather_location';

  /**
   * 根据主键与附加条件查询单条记录。
   * @param key 主键
   * @param query 筛选条件
   * @returns IAppWeatherLocation
   */
  static Find(
    key: string,
    query: YaoQueryParam.QueryParam
  ): IAppWeatherLocation {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.find`,
      key,
      query
    );
  }
  /**
   * 根据条件查询数据记录, 返回符合条件的结果集。
   * @param query
   * @returns IAppWeatherLocation[]
   */
  static Get(query: YaoQueryParam.QueryParam): IAppWeatherLocation[] {
    return Process(`models.${AppWeatherLocationService.ModelID}.get`, query);
  }
  /**
   * 根据条件查询数据记录, 返回带有分页信息的数据对象。
   * @param query
   * @param page
   * @param perPage
   * @returns ModelPaginateResult<IAppWeatherLocation>
   */
  static Paginate(
    query: YaoQueryParam.QueryParam,
    page: number,
    perPage: number
  ): ModelPaginateResult<IAppWeatherLocation> {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.Paginate`,
      query,
      page,
      perPage
    );
  }

  /**
   * 创建单条记录, 返回新创建记录的主键
   * @param data
   * @returns
   */
  static Create(data: IAppWeatherLocation): number {
    return Process(`models.${AppWeatherLocationService.ModelID}.create`, data);
  }

  /**
   * 根据字段与数据，一次性插入多条数据记录，返回插入行数
   * @param columns
   * @param values
   * @returns
   */
  static Insert(columns: string[], values: any[][]): number {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.Insert`,
      columns,
      values
    );
  }

  /**
   * 一次性插入多条数据记录，返回插入行数
   * @param data
   * @returns
   */
  static InsertBatch(data: IAppWeatherLocation[]): number {
    const { columns, values } = Process('utils.arr.split', data);
    return Process(
      `models.${AppWeatherLocationService.ModelID}.Insert`,
      columns,
      values
    );
  }

  /**
   * 创建或更新单条记录。如数据记录中包含 id 则更新，不包含 id 则创建记录；返回创建或更新的记录 ID。
   * @param data
   * @returns
   */
  static Save(data: Partial<IAppWeatherLocation>): number {
    return Process(`models.${AppWeatherLocationService.ModelID}.Save`, data);
  }

  /**
   * 根据主键更新单条数据记录。
   * @param key
   * @param line
   * @returns
   */
  static Update(key: string, line: Partial<IAppWeatherLocation>) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.Update`,
      key,
      line
    );
  }

  /**
   * 根据条件更新数据记录, 返回更新行数。
   * @param query
   * @param line
   * @returns
   */
  static UpdateWhere(
    query: YaoQueryParam.QueryParam,
    line: Partial<IAppWeatherLocation>
  ) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.UpdateWhere`,
      query,
      line
    );
  }

  /**
   * 批量创建或是更新多条记录, 不包含主键字段则创建记录, 存在更新记录。
   * @param data
   * @param line
   * @returns
   */
  static EachSave(
    data: IAppWeatherLocation[],
    line: Partial<IAppWeatherLocation>
  ) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.EachSave`,
      data,
      line
    );
  }

  /**
   * 删除并保存数据，删除给定 ID 的记录后，保存多条记录数据, 不包含主键字段则创建记录, 存在更新记录, 返回记录 ID 集合 ，返回创建或更新的记录 ID 集合。
   * @param keys
   * @param data
   * @param line
   * @returns
   */
  static EachSaveAfterDelete(
    keys: string[],
    data: IAppWeatherLocation[],
    line: Partial<IAppWeatherLocation>
  ) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.EachSaveAfterDelete`,
      keys,
      data,
      line
    );
  }

  /**
   * 根据主键删除数据
   * @param key
   * @returns
   */
  static Delete(key: string) {
    return Process(`models.${AppWeatherLocationService.ModelID}.Delete`, key);
  }

  /**
   * 删除所有数据
   * @returns
   */
  static DeleteAll() {
    return new Query('default').Run({
      sql: { stmt: `delete from ${AppWeatherLocationService.TableName}` }
    });
  }

  /**
   * 根据条件删除数据
   * @param query
   * @returns
   */
  static DeleteWhere(query: YaoQueryParam.QueryParam) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.DeleteWhere`,
      query
    );
  }

  /**
   * 根据主键真删除单条数据记录。
   * @param key
   * @returns
   */
  static Destroy(key: string) {
    return Process(`models.${AppWeatherLocationService.ModelID}.Destroy`, key);
  }

  /**
   * 按条件硬删除
   * @param query
   * @returns
   */
  static DestroyWhere(query: YaoQueryParam.QueryParam) {
    return Process(
      `models.${AppWeatherLocationService.ModelID}.DestroyWhere`,
      query
    );
  }
}
