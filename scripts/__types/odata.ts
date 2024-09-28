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
  model: {
    /** yao table id */
    table_id: string;
    /** yao model id */
    model_id: string;
  };
  /** count the entity */
  isCount?: boolean;
}
