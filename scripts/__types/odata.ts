import { OdataModel } from '@scripts/app/odata/lib/model';
import { YaoQuery } from '@yaoapps/types';

/**
 * odata query dsl
 */
export interface Qsl {
  /** yao query dsl */
  qsl: YaoQuery.QueryDSL;
  /** output format */
  format: string; //'json' | 'xml';
  /** odata entityset */
  entitySet: string;
  /**use the id get special record */
  id?: string;
  model: OdataModel;
  /** count the entity */
  isCount?: boolean;
}

/**
 * Model=> app.odata.view (Odata视图)
 *
 * Table=> app_odata_view
 */
export interface app_odata_view {
  /**名称 */
  name: string;
  /**描述 */
  label: string;
  /**长描述 */
  description?: string;
  /**关联模型 */
  model_id: string;
  /**关联表格 */
  table_id?: string;
  /**可创建 */
  creatable?: boolean;
  /**可更新 */
  updatable?: boolean;
  /**可删除 */
  deletable?: boolean;
  /**禁用 */
  disabled?: boolean;
}
