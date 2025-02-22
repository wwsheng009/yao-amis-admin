# 模型规则

这是一个关于模型的背景材料，你需要严格遵循这些规则。

## 结构

```TypeScript
/**
 * 数据模型定义
 */
interface DataModel {
  /** 模型中文名称 */
  name: string;
  /** 表定义 */
  table: TableDefinition;
  /** 列定义 */
  columns: ColumnDefinition[];
  /** 索引定义 */
  indexes?: IndexDefinition[];
  /** 关系映射 */
  relations?: { [key: string]: RelationDefinition };
  /** 默认值 */
  values?: any[];
  /** 模型选项 */
  option?: ModelOption;
}

/**
 * 表定义
 */
interface TableDefinition {
  /** 表名 */
  name: string;
  /** 表注释 */
  comment?: string;
}

/**
 * 列定义
 */
interface ColumnDefinition {
  /** 列显示标签 */
  label: string;
  /** 列名 */
  name: string;
  /** 列数据类型 */
  type: ColumnType;
  /** 列注释 */
  comment?: string;
  /** 列标题 */
  title?: string;
  /** 列描述 */
  description?: string;
  /** 字符串类型的长度 */
  length?: number;
  /** 浮点/小数类型的总位数（包含小数位） */
  precision?: number;
  /** 浮点/小数类型的小数位数 */
  scale?: number;
  /** 枚举类型的允许值 */
  option?: string[];
  /** 默认值 */
  default?: string | number | boolean;
  /** 使用数据库函数的默认值 */
  default_raw?: string;
  /** 加密方法（仅MySQL）。允许值：'AES', 'PASSWORD' */
  crypt?: 'AES' | 'PASSWORD';
  /** 是否允许为空 */
  nullable?: boolean;
  /** 是否创建索引 */
  index?: boolean;
  /** 是否创建唯一索引 */
  unique?: boolean;
  /** 是否为主键 */
  primary?: boolean;
  /** 验证规则 */
  validations?: ValidationRule[];
}

/**
 * 列类型
 */
type ColumnType =
  | 'ID'
  | 'string'
  | 'char'
  | 'text'
  | 'mediumText'
  | 'longText'
  | 'binary'
  | 'date'
  | 'datetime'
  | 'datetimeTz'
  | 'time'
  | 'timeTz'
  | 'timestamp'
  | 'timestampTz'
  | 'tinyInteger'
  | 'tinyIncrements'
  | 'unsignedTinyInteger'
  | 'smallInteger'
  | 'smallIncrements'
  | 'unsignedSmallInteger'
  | 'integer'
  | 'increments'
  | 'unsignedInteger'
  | 'bigInteger'
  | 'bigIncrements'
  | 'unsignedBigInteger'
  | 'decimal'
  | 'unsignedDecimal'
  | 'float'
  | 'unsignedFloat'
  | 'double'
  | 'unsignedDouble'
  | 'boolean'
  | 'enum'
  | 'json'
  | 'jsonb'
  | 'uuid'
  | 'ipAddress'
  | 'macAddress'
  | 'year';

/**
 * 验证规则
 */
interface ValidationRule {
  /** 验证方法 */
  method: ValidationMethod;
  /** 方法参数 */
  args?: (string | number)[];
  /** 错误信息 */
  message?: string;
}

/**
 * 验证方法
 */
type ValidationMethod =
  | 'typeof'
  | 'min'
  | 'max'
  | 'enum'
  | 'pattern'
  | 'minLength'
  | 'maxLength'
  | 'email'
  | 'mobile';

/**
 * 索引定义
 */
interface IndexDefinition {
  /** 索引名称 */
  name: string;
  /** 索引类型 */
  type: 'index' | 'unique' | 'primary' ;
  /** 要索引的列 */
  columns: string[];
  /** 索引注释 */
  comment?: string;
}

/**
 * 关系定义
 */
interface RelationDefinition {
  /** 关系类型 */
  type: 'hasOne' | 'hasMany' ;
  /** 关联的模型名称 */
  model?: string;
  /** 关联模型中的外键 */
  key?: string;
  /** 本地键 */
  foreign?: string;
  /** 默认查询参数 */
  query?: QueryParam;
  /** hasOneThrough/hasManyThrough的中间关系 */
  links?: RelationDefinition[];
}

/**
 * 模型选项
 */
interface ModelOption {
  /** 是否添加时间戳（created_at, updated_at） */
  timestamps?: boolean;
  /** 是否启用软删除 */
  soft_deletes?: boolean;
}
```

## 规则

1. 必须至少有一个列。
2. 必须有一个类型为`ID`的主键列。
   2.1 `ID`类型的列不允许有`nullable`、`index`、`unique`和`default`属性。
3. 只允许有一个主键列。
4. 必须定义ModelOption，并包含`timestamps`和`soft_deletes`。
5. 不允许在列中定义created_at、updated_at和deleted_at列。
