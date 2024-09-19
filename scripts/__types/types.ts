import { YaoModel } from '@yaoapps/types';

interface ModelColumnEx extends YaoModel.ModelColumn {
  /**可选项 */
  options?: { value: string; name: string }[];
  /**元素模板 */
  element_id?: string;
}

/** 增强的Yao 模型定义 */
export interface YaoModelEx extends YaoModel.ModelDSL {
  /** 内部标识 */
  ID?: string;

  /** 编号，一般是数据库id */
  id?: number;
}

export interface AmisModel extends Omit<YaoModel.ModelDSL, 'relations'> {
  /** 内部标识 */
  //   ID?: string;

  /** 编号，一般是数据库id */
  id?: number;

  /** 内部编号 */
  identity?: string;

  /**表名 */
  table_name?: string;

  /** 表注释 */
  table_comment?: string;

  soft_deletes?: boolean;

  timestamps?: boolean;

  read_only?: boolean;

  /** */
  columns?: ModelColumnEx[];

  relations?: AmisRelation[];
}

export interface AmisRelation extends YaoModel.Relation {
  /** name config */
  name: string;
}
