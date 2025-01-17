import { YaoField, YaoModel } from '@yaoapps/types';

/**在数据中保存的yao模型信息 */
export interface AmisModelDB extends Omit<YaoModel.ModelDSL, 'relations'> {
  /** 内部标识 */
  //   ID?: string;

  /** 编号，数据库id */
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

  /** 完全映射数据库字段*/
  columns?: AmisModelColumn[];

  relations?: AmisRelation[];
}

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
  /** 唯一标识 */
  id?: number;
  model_id?: string;
  model_identity?: string;
  check_model_multi?: boolean;
  language?: string;
  static?: boolean;
  format?: string;
  /** 是否上传公共文件夹 */
  is_public?: boolean;
}

/** 增强的Yao 模型定义 */
export interface AmisModel extends Omit<YaoModel.ModelDSL, 'columns'> {
  /** 内部标识 */
  ID?: string;

  /** 编号，数据库id */
  id?: number;

  /** 列信息 */
  columns?: AmisModelColumn[];

  /** 模型选项 */
  option?: YaoModel.ModelOption & {
    migrate_force?: boolean;
  };
  /** yao内部的yao 模型是嵌套的 */
  // children?: AmisModel[];
}

export interface AmisRelation extends YaoModel.Relation {
  /** name config */
  name: string;
}

/**Amis界面维护的模型定义 */
export interface AmisUIModel {
  header?: {
    id?: number;
    identity?: string;
    name?: string;
    comment?: string;
  };
  columns?: AmisUIColumn[];
  option?: {
    soft_deletes?: boolean;
    timestamps?: boolean;
    read_only?: boolean;
    migrate_force?: boolean;
  };
  table?: {
    name?: string;
    comment?: string;
  };
}

/**
 * amis 库本身的相关类型
 */
export interface AmisValidation {
  [key: string]: any;
  matchRegexp?: string; //正则
  isEmail?: boolean;
  isTelNumber?: boolean;
  maxLength?: number;
  minLength?: number;
}

/**
 * UI column used in amis curd/table
 */
export interface AmisUIColumn
  extends Omit<AmisModelColumn, 'index' | 'validations' | 'name'> {
  validationErrors?: object;

  checked?: boolean;
  /**快速编辑 */
  quickEdit?: boolean;
  /**名称 */
  name?: string;
  /**标签 */
  label: string;
  /**控件类型 */
  type: string;
  /**长度 */
  length?: number;
  /**是否可搜索 */
  searchable?: boolean;
  /**是否排序 */
  sortable?: boolean;
  levelExpand?: 0 | 1;
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
  trueValue?: number | boolean;
  /**false显示值 */
  falseValue?: number | boolean;
  href?: string;
  body?: string;
  toggled?: boolean;
  static?: boolean;
  displayOnly?: boolean;
  /**语言 */
  language?: string;
  multiple?: boolean;
  source?: object | string;
  required?: boolean;
  value?: object;
  maxLength?: number;
  /**标注是ID字段 */
  isID?: boolean;
  /**数据元素 */
  element_id?: string;
  options?: {
    value: string | number | boolean;
    label: string;
  }[];

  /**上传文件api接口 */
  receiver?: string;
  /**文件上传时使用块 */
  useChunk?: boolean;
  /**忽略 */
  __ignore?: boolean | undefined;

  /**在ui上index是索引编号 */
  index?: number;
  /**是否索引 */
  is_index?: boolean;

  /**临时的索引 */
  __index?: number;

  /**可见条件 */
  visibleOn?: string;

  validations?: AmisValidation;

  /**控件输入值是否可以清空 */
  clearable?: boolean;

  btnLabel?: string;
  /** 显示更多的提示信息 */
  labelRemark?: string;
  form?: { [key: string]: any };
}

export interface YaoModelNode {
  children?: { data?: AmisModel }[];
  data?: AmisModel;
}

/**
 * Yao缓存中的模型定义
 */
export interface CachedModel extends YaoModel.ModelDSL {
  ID?: string;
  DSL?: string;
}

export interface CachedModelTree {
  children?: { data?: CachedModel }[];
  data?: CachedModel;
}

export interface AmisViewComponent extends YaoField.ColumnDSL {
  /**上传控件 */
  is_upload?: boolean;
  /**下拉控件 */
  is_select?: boolean;
}

export type ModelId = number | string;

export interface PaginateSearchResult {
  /**数据记录集合 */
  data: { [key: string]: any }[];
  /**下一页，如没有下一页返回 `-1` */
  next: number;
  /**上一页，如没有上一页返回 `-1` */
  prev: number;
  /**当前页码 */
  page: number;
  /**每页记录数量 */
  pagesize: number;
  /**总页数 */
  pagecnt: number;
  /**总记录数 */
  total: number;
}

export interface SearchResult {
  /**数据记录集合 */
  list: { [key: string]: any }[];
  /**当前页码 */
  page: number;
  /**总页数 */
  pages: number;
  /**每页记录数量 */
  limit: number;
  /**总记录数 */
  total: number;
}
