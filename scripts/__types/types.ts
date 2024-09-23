import { YaoField, YaoModel } from '@yaoapps/types';

export interface AmisModelColumn extends YaoModel.ModelColumn {
  /**可选项 */
  options?: {
    value: string | number | boolean;
    label: string;
  }[];
  /**元素模板 */
  element_id?: string;

  /**检查模型 */
  check_model?: string;

  check_model_label?: string;
  check_model_value?: string;
  id?: number;
  model_id?: string;
  model_identity?: string;
  check_model_multi?: boolean;
  language?: string;
  static?: boolean;
  format?: string;
}

/** 增强的Yao 模型定义 */
export interface YaoModelEx extends YaoModel.ModelDSL {
  /** 内部标识 */
  ID?: string;

  /** 编号，一般是数据库id */
  id?: number;

  children?: YaoModelEx[];
}

export interface AmisModelDBEx extends Omit<YaoModel.ModelDSL, 'columns'> {
  /** 内部标识 */
  ID?: string;

  /** 编号，一般是数据库id */
  id?: number;

  columns?: AmisModelColumn[];
  option?: YaoModel.ModelOption & {
    migrate_force?: boolean;
  };
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
  columns?: AmisModelColumn[];

  relations?: AmisRelation[];
}

export interface AmisRelation extends YaoModel.Relation {
  /** name config */
  name: string;
}

/**
 * UI column used in amis curd/table
 */
export interface AmisUIColumn {
  /**名称 */
  name?: string;
  /**标签 */
  label?: string;
  /**控件类型 */
  type?: string;
  /**长度 */
  length?: number;
  /**是否可搜索 */
  searchable?: boolean;
  /**是否排序 */
  sortable?: boolean;
  levelExpand: 0 | 1;
  format?: string;
  /**最小值 */
  min?: number;
  /**最大值 */
  big?: boolean;
  /**精确度 */
  precision?: number;
  /**步 */
  step?: number;
  /**true显示值 */
  trueValue: number | boolean;
  /**false显示值 */
  falseValue: number | boolean;
  href?: string;
  body?: string;
  toggled?: boolean;
  static?: boolean;
  displayOnly?: boolean;
  /**语言 */
  language?: string;
  multiple?: boolean;
  source?: object;
  required?: boolean;
  value?: object;
  maxLength?: number;
  isID?: boolean;
  options?: {
    value: string | number | boolean;
    label: string;
  }[];

  /**上传文件api接口 */
  receiver?: string;
  /**文件上传时使用块 */
  useChunk?: boolean;
  /**检验规则 */
  validations?: object;
  /**忽略 */
  __ignore?: boolean | undefined;
}

export interface YaoModelNode {
  children?: { data?: YaoModelEx }[];
  data?: YaoModelEx;
}

export interface AmisViewColumn extends YaoField.ColumnDSL {
  /**上传控件 */
  is_upload?: boolean;
  /**下拉控件 */
  is_select?: boolean;
}
