# Yao 模型定义指南

## 概述

Yao 模型是 Yao 框架中用于定义业务数据结构的基础组件。通过模型定义，您可以：

1. 描述数据结构（字段类型、关系等）
2. 定义数据验证规则
3. 配置数据库表结构
4. 建立模型间的关系
5. 设置默认值和业务规则

## 文件结构

在 Yao 中，模型配置文件需要保存在应用目录的子目录 `models` 下，如果不存在此目录，需要手工创建。文件命名通常遵循 `modelname.yao` 的格式。如果模型的名称为 `user`，则文件名为 `user.yao`。

模型文件的名称建议使用小写，如果存在下划线或是驼峰的名称，建议使用创建多层目录。比如 `my_name` 模型建议的文件名是 `my/name.yao`，`autoCar` 模型建议的文件名为 `auto/car.yao`。

每一个模型文件在 yao 框架加载后会以文件路径与文件组成一个唯一的标识符，在程序中可以通过这个唯一标识符来引用模型。例如：

- `models/user.yao` 这个文件的模型标识为 `user`。
- `models/my/name.yao` 这个文件的模型标识为 `my.name`。
- `models/auto/car.yao` 这个文件的模型标识为 `auto.car`。

## 文件格式

Yao 中模型定义总是以 `json` 格式编写，如果文件的后缀名是`.jsonc`或是`.yao`，则可以在文件中使用注释。

以下是系统内置模型的示例：

```json
{
  "name": "用户",
  "table": {
    "name": "admin_user",
    "comment": "用户表",
    "engine": "InnoDB"
  },
  "columns": [
    {
      "label": "ID",
      "name": "id",
      "type": "ID"
    },
    {
      "label": "类型",
      "name": "type",
      "type": "enum",
      "option": ["super", "admin", "staff", "user", "robot"],
      "comment": "账号类型 super 超级管理员,admin 管理员, staff 员工, user 用户, robot 机器人",
      "default": "user",
      "validations": [
        {
          "method": "typeof",
          "args": ["string"],
          "message": "{{input}}类型错误, {{label}}应该为字符串"
        },
        {
          "method": "enum",
          "args": ["super", "admin", "staff", "user", "robot"],
          "message": "{{input}}不在许可范围, {{label}}应该为 super/admin/staff/user/robot"
        }
      ]
    }
    // 更多字段...
  ],
  "relations": {},
  "values": [
    {
      "name": "管理员",
      "type": "super",
      "email": "xiang@iqka.com",
      "mobile": null,
      "password": "A123456p+",
      "status": "enabled",
      "extra": {
        "sex": "男"
      }
    }
  ],
  "option": {
    "timestamps": true,
    "soft_deletes": true
  }
}
```

## 在 yao 中定义业务模型

在 Yao 中，定义一个业务模型涉及以下几个关键部分：

1. **模型元数据 (`ModelDSL`)**

   - 包括模型的基本信息，如模型名称、描述、数据表选项等。
   - 例如，模型名称 (`name`)、数据表定义 (`table`) 等。

2. **字段定义 (`columns`)**

   - 这些是模型中的具体字段，每个字段包含类型、长度、是否可为空、默认值、校验规则等。
   - 字段类型可以是 `string`, `integer`, `float`, `enum`, `json` 等。

3. **索引定义 (`indexes`)**

   - 定义数据表中的索引，提高查询效率。

4. **映射关系定义 (`relations`)**

   - 定义模型与其他模型之间的关系，如 `hasOne`, `hasMany`, `hasOneThrough` 等。

5. **默认数据 (`values`)**

   - 定义模型的默认数据记录。

6. **配置选项 (`option`)**
   - 包括是否启用时间戳 (`timestamps`)、软删除 (`soft_deletes`) 等配置项。

这个定义包括了模型的名称、数据表信息、字段定义（包括类型、验证规则等）、默认数据以及配置选项。

## Yao 模型字段定义

在 yao 中编写模型配置文件时，列的配置类型可以使用以下的类型设置，这些类型一般会直接翻译成数据库类型。

### Yao 模型定义中的可使用字段：

| 字段名      | 类型                           | 是否必填项 | 说明                     | 示例                                    |
| ----------- | ------------------------------ | ---------- | ------------------------ | --------------------------------------- |
| name        | string                         | 是         | 字段名称，用于数据库列名 | `"name": "username"`                    |
| label       | string                         | 是         | 字段显示名称             | `"label": "用户名"`                     |
| type        | string                         | 是         | 字段类型                 | `"type": "string"`                      |
| title       | string                         | 否         | 字段标题，用于显示       | `"title": "用户登录名"`                 |
| description | string                         | 否         | 字段描述                 | `"description": "用于系统登录的用户名"` |
| comment     | string                         | 否         | 数据库表字段注释         | `"comment": "用户名，唯一标识"`         |
| length      | number                         | 否         | 字段长度                 | `"length": 255`                         |
| precision   | number                         | 否         | 数字字段精度             | `"precision": 10`                       |
| scale       | number                         | 否         | 数字字段小数位数         | `"scale": 2`                            |
| nullable    | boolean                        | 否         | 是否允许为空             | `"nullable": true`                      |
| option      | list                           | 否         | 枚举类型选项             | `"option": ["A", "B", "C"]`             |
| default     | String&#124;Integer&#124;Float | 否         | 字段默认值               | `"default": "guest"`                    |
| default_raw | string                         | 否         | 数据库函数默认值         | `"default_raw": "NOW()"`                |
| generate    | string                         | 否         | 自动生成值类型           | `"generate": "UUID"`                    |
| crypt       | string                         | 否         | 加密存储方式             | `"crypt": "AES"`                        |
| index       | boolean                        | 否         | 是否创建索引             | `"index": true`                         |
| unique      | boolean                        | 否         | 是否唯一约束             | `"unique": true`                        |
| primary     | boolean                        | 否         | 是否主键                 | `"primary": true`                       |
| origin      | any                            | 否         | 保留字段                 | 未使用                                  |

### 字符串类型

1. **string**

   - 描述：可变长度字符串
   - 默认长度：200
   - 示例：
     ```json
     {
       "name": "username",
       "type": "string",
       "length": 100,
       "comment": "用户登录名"
     }
     ```

2. **char**
   - 描述：固定长度字符串
   - 必须指定长度
   - 示例：
     ```json
     {
       "name": "status_code",
       "type": "char",
       "length": 2,
       "comment": "状态代码"
     }
     ```

### 长文本类型

1. **text**

   - 描述：普通文本，最大长度约 65,535 字符
   - 示例：
     ```json
     {
       "name": "description",
       "type": "text",
       "comment": "产品描述"
     }
     ```

2. **mediumText**

   - 描述：中等长度文本，最大长度约 16,777,215 字符
   - 示例：
     ```json
     {
       "name": "content",
       "type": "mediumText",
       "comment": "文章内容"
     }
     ```

3. **longText**
   - 描述：长文本，最大长度约 4,294,967,295 字符
   - 示例：
     ```json
     {
       "name": "log_data",
       "type": "longText",
       "comment": "系统日志"
     }
     ```

### 二进制类型

1. **binary**
   - 描述：二进制数据
   - 必须指定长度
   - 示例：
     ```json
     {
       "name": "file_data",
       "type": "binary",
       "length": 1024,
       "comment": "文件数据"
     }
     ```

### 日期与时间类型

1. **date**

   - 描述：日期（YYYY-MM-DD）
   - 示例：
     ```json
     {
       "name": "birthday",
       "type": "date",
       "comment": "出生日期"
     }
     ```

2. **datetime**

   - 描述：日期时间（YYYY-MM-DD HH:MM:SS）
   - 示例：
     ```json
     {
       "name": "created_at",
       "type": "datetime",
       "comment": "创建时间"
     }
     ```

3. **datetimeTz**

   - 描述：带时区的日期时间
   - 示例：
     ```json
     {
       "name": "updated_at",
       "type": "datetimeTz",
       "comment": "更新时间（带时区）"
     }
     ```

4. **time**

   - 描述：时间（HH:MM:SS）
   - 示例：
     ```json
     {
       "name": "start_time",
       "type": "time",
       "comment": "开始时间"
     }
     ```

5. **timestamp**
   - 描述：时间戳
   - 示例：
     ```json
     {
       "name": "last_login",
       "type": "timestamp",
       "comment": "最后登录时间"
     }
     ```

### 数字类型

1. **有符号整数**

   - tinyInteger：-128 到 127
   - smallInteger：-32,768 到 32,767
   - integer：-2,147,483,648 到 2,147,483,647
   - bigInteger：-9,223,372,036,854,775,808 到 9,223,372,036,854,775,807
   - 示例：
     ```json
     {
       "name": "age",
       "type": "tinyInteger",
       "comment": "用户年龄"
     }
     ```

2. **无符号整数**

   - unsignedTinyInteger：0 到 255
   - unsignedSmallInteger：0 到 65,535
   - unsignedInteger：0 到 4,294,967,295
   - unsignedBigInteger：0 到 18,446,744,073,709,551,615
   - 示例：
     ```json
     {
       "name": "views",
       "type": "unsignedInteger",
       "comment": "浏览次数"
     }
     ```

3. **浮点数**
   - float：单精度浮点数
   - double：双精度浮点数
   - decimal：高精度小数
   - 示例：
     ```json
     {
       "name": "price",
       "type": "decimal",
       "precision": 10,
       "scale": 2,
       "comment": "商品价格"
     }
     ```

### 布尔类型

- 描述：true/false 值
- 示例：
  ```json
  {
    "name": "is_active",
    "type": "boolean",
    "default": true,
    "comment": "是否激活"
  }
  ```

### 特殊类型

1. **json**

   - 描述：JSON 格式数据
   - 示例：
     ```json
     {
       "name": "preferences",
       "type": "json",
       "comment": "用户偏好设置"
     }
     ```

2. **uuid**

   - 描述：通用唯一标识符
   - 示例：
     ```json
     {
       "name": "user_uuid",
       "type": "uuid",
       "comment": "用户唯一标识"
     }
     ```

3. **enum**
   - 描述：枚举类型
   - 需要指定 option 列表
   - 示例：
     ```json
     {
       "name": "status",
       "type": "enum",
       "option": ["pending", "approved", "rejected"],
       "comment": "审批状态"
     }
     ```

## 高级字段配置

### 1. 字段默认值

Yao 支持多种默认值设置方式：

1. **静态默认值**

   ```json
   {
     "name": "status",
     "type": "string",
     "default": "active"
   }
   ```

2. **数据库函数默认值**

   ```json
   {
     "name": "created_at",
     "type": "datetime",
     "default_raw": "NOW()"
   }
   ```

3. **自动生成值**
   ```json
   {
     "name": "uuid",
     "type": "string",
     "generate": "UUID"
   }
   ```

### 2. 字段加密

对于密码字段，可以使用内置的加密方式来存储敏感信息，例如：

```json
{
  "name": "password",
  "type": "string",
  "crypt": "AES",
  "comment": "加密存储的密码"
}
```

支持的加密方式：

- AES：高级加密标准,只适用于`mysql`数据库
- PASSWORD：单向哈希加密

### 3. 字段索引

1. **普通索引**

   ```json
   {
     "name": "email",
     "type": "string",
     "index": true
   }
   ```

2. **唯一索引**

   ```json
   {
     "name": "username",
     "type": "string",
     "unique": true
   }
   ```

3. **复合索引**
   在模型配置的 `indexes` 部分定义：
   ```json
   {
     "indexes": [
       {
         "name": "idx_user_status",
         "columns": ["user_id", "status"],
         "unique": false
       }
     ]
   }
   ```

### 4. 字段验证

Yao 提供了强大的字段验证功能：

1. **基本验证**

   ```json
   {
     "name": "age",
     "type": "integer",
     "validations": [
       {
         "method": "min",
         "args": [18],
         "message": "年龄必须大于18岁"
       }
     ]
   }
   ```

2. **复杂验证**
   ```json
   {
     "name": "password",
     "type": "string",
     "validations": [
       {
         "method": "minLength",
         "args": [8],
         "message": "密码至少8个字符"
       },
       {
         "method": "pattern",
         "args": ["[A-Z]+"],
         "message": "密码必须包含大写字母"
       }
     ]
   }
   ```

## Yao 模型字段校验

有以下的校验方法列表：
yao/yao-app-sources/gou/validation.go

```go
	"typeof":     // 校验数值类型 string, integer, float, number, datetime, timestamp,bool
	"min":        // 最小值
	"max":        // 最大值
	"enum":       // 枚举型
	"pattern":    // 正则匹配
	"minLength":  // 最小长度
	"maxLength":  // 最大长度
	"email":      // 邮箱地址
	"mobile":     // 手机号
```

### 类型判断，参数是允许的数据类型：string, integer, float, number, datetime, timestamp

```json
{
  "validations": [
    {
      "method": "typeof",
      "args": ["string"],
      "message": "::{{input}} Error, {{label}} should be string"
    }
  ]
}
```

### 枚举判断，参数是可能的枚举列表

```json
{
  "validations": [
    {
      "method": "enum",
      "args": ["enabled", "disabled"],
      "message": "::{{input}} Error, {{label}} should be enabled/disabled"
    }
  ]
}
```

### 邮箱地址/电话号码，不需要参数

```json
{
  "validations": [
    {
      "method": "email",
      "args": [],
      "message": "{{input}} should be email"
    },
    {
      "method": "mobile",
      "args": [],
      "message": "{{input}} should be mobile"
    }
  ]
}
```

### 最小值，最大值判断

```json
{
  "validations": [
    {
      "method": "min",
      "args": [0],
      "message": "{{label}}应大于等于0"
    },
    {
      "method": "max",
      "args": [10],
      "message": "{{label}}应小于等于10"
    }
  ]
}
```

### 最小长度，最大长度判断

```json
{
  "validations": [
    {
      "method": "minLength",
      "args": [6],
      "message": "{{label}} Error"
    },
    {
      "method": "maxLength",
      "args": [18],
      "message": "{{label}} Error"
    }
  ]
}
```

### 正则判断，参数是正则表达式，可以替代邮件地址，电话号码的校验

```json
[
  {
    "method": "pattern",
    "args": ["[0-9]+"],
    "message": "{{label}}应该至少包含一个数字"
  },
  {
    "method": "pattern",
    "args": ["[A-Z]+"],
    "message": "{{label}}应该至少包含一个大写字母"
  },
  {
    "method": "pattern",
    "args": ["[a-z]+"],
    "message": "{{label}}应该至少包含一个小写字母"
  },
  {
    "method": "pattern",
    "args": ["[@#$&*]+"],
    "message": "{{label}}应该至少包含一个符号"
  },
  {
    "method": "pattern",
    "args": ["^(\\d{18})|(\\d{14}X)$"],
    "message": "{{label}}身份证格式错误"
  },
  {
    "method": "pattern",
    "args": ["^[0-9A-Za-z@#$&*]{8}$"],
    "message": " {{label}}应该由8位，大小写字母、数字和符号构成"
  },
  {
    "method": "pattern",
    "args": ["^[0-9A-Za-z@#$&*]{32}$"],
    "message": "{{label}}应该由32位，大小写字母、数字和符号构成"
  }
]
```

### 用户名检验

```json
{
  "label": "姓名",
  "name": "name",
  "type": "string",
  "length": 80,
  "comment": "姓名",
  "index": true,
  "validations": [
    {
      "method": "typeof",
      "args": ["string"],
      "message": "{{input}}类型错误, {{label}}应该为字符串"
    },
    {
      "method": "minLength",
      "args": [2],
      "message": "{{label}}至少需要2个字"
    },
    {
      "method": "maxLength",
      "args": [40],
      "message": "{{label}}不能超过20个字"
    }
  ]
}
```

### 密码检验

```json
{
  "label": "登录密码",
  "name": "password",
  "type": "string",
  "length": 256,
  "comment": "登录密码",
  "crypt": "PASSWORD",
  "index": true,
  "validations": [
    {
      "method": "typeof",
      "args": ["string"],
      "message": "{{input}}类型错误, {{label}}应该为字符串"
    },
    {
      "method": "minLength",
      "args": [6],
      "message": "{{label}}应该由6-18位，大小写字母、数字和符号构成"
    },
    {
      "method": "maxLength",
      "args": [18],
      "message": "{{label}}应该由6-18位，大小写字母、数字和符号构成"
    },
    {
      "method": "pattern",
      "args": ["[0-9]+"],
      "message": "{{label}}应该至少包含一个数字"
    },
    {
      "method": "pattern",
      "args": ["[A-Z]+"],
      "message": "{{label}}应该至少包含一个大写字母"
    },
    {
      "method": "pattern",
      "args": ["[a-z]+"],
      "message": "{{label}}应该至少包含一个小写字母"
    },
    {
      "method": "pattern",
      "args": ["[@#$&*]+"],
      "message": "{{label}}应该至少包含一个符号"
    }
  ]
}
```

## Yao 模型中的关联关系

先看看文档说明：[数据模型关联](https://yaoapps.com/doc/%E8%BF%9B%E9%98%B6/%E6%95%B0%E6%8D%AE%E6%A8%A1%E5%9E%8B%E5%85%B3%E8%81%94)

理解两个模型之间的关联关系的关键点在于理解模型中的`relations`定义。特别是这两个字段：

- `key` 用于关联映射 (关联数据模型.key = 当前数据模型.foreign)
- `foreign` 用于关联映射 (关联数据模型.key = 当前数据模型.foreign)

定义两个测试模型：

- user model:

```json
{
  "name": "用户",
  "table": { "name": "user", "comment": "用户表" },
  "columns": [
    { "label": "ID", "name": "id", "type": "ID", "comment": "ID" },
    {
      "label": "供应商",
      "name": "supplier_id",
      "type": "bigInteger",
      "index": true,
      "comment": "供应商ID"
    },
    {
      "label": "姓名",
      "name": "name",
      "type": "string",
      "index": true,
      "comment": "用户姓名"
    },
    {
      "label": "APPID",
      "name": "app_id",
      "type": "string",
      "length": 10,
      "index": true,
      "comment": "用户姓名"
    }
  ],
  "relations": {
    "one_supplier": {
      "key": "id",
      "foreign": "supplier_id",
      "model": "supplier",
      "type": "hasOne"
    },
    "many_suppliers": {
      "key": "user_id",
      "foreign": "id",
      "model": "supplier",
      "type": "hasMany"
    },
    "apps": {
      "key": "app_id",
      "foreign": "app_id",
      "model": "supplier",
      "type": "hasMany"
    }
  },
  "values": [
    { "id": 1, "supplier_id": 1, "name": "张无忌", "app_id": "123" },
    { "id": 2, "supplier_id": 1, "name": "李光富", "app_id": "456" },
    { "id": 3, "supplier_id": 2, "name": "李木婷", "app_id": "789" },
    { "id": 4, "supplier_id": 2, "name": "赵长青", "app_id": "012" }
  ]
}
```

- supplier model:

```json
{
  "name": "供应商",
  "table": { "name": "supplier", "comment": "供应商表" },
  "columns": [
    {
      "label": "ID",
      "name": "id",
      "type": "ID",
      "comment": "ID"
    },
    {
      "label": "名称",
      "name": "name",
      "type": "string",
      "index": true,
      "comment": "供应商名称"
    },
    {
      "label": "APPID",
      "name": "app_id",
      "type": "string",
      "length": 10,
      "index": true,
      "comment": "应用标识"
    },
    {
      "label": "USERID",
      "name": "user_id",
      "type": "bigInteger",
      "length": 10,
      "index": true,
      "comment": "用户姓名"
    }
  ],
  "relations": {
    "users": {
      "key": "supplier_id",
      "foreign": "id",
      "model": "user",
      "type": "hasMany"
    }
  },
  "values": [
    { "id": 1, "name": "象传智慧", "app_id": "456", "user_id": 1 },
    { "id": 2, "name": "Yao App Engine", "app_id": "456", "user_id": 1 }
  ]
}
```

下面从`user`模型看关联关系的定义：

### 一个用户对应多个供应商

```sh
yao run models.user.Find 1 '::{"withs":{"many_suppliers":{}}}'
```

`user.mod.json`关联关系定义：

```json
{
  "many_suppliers": {
    "key": "user_id",
    "foreign": "id",
    "model": "supplier",
    "type": "hasMany"
  }
}
```

等于筛选条件：`user.id == suppliers.user_id`，`suppliers.user_id`保存了对模型`user.id`的引用。按这个条件可以找到用户对应的多个供应商。使用`hasMany`比较合适

```sh
yao run models.user.Find 1 '::{"withs":{"one_supplier":{}}}'
```

返回结果是数组。

```json
{
  "app_id": "123",
  "id": 1,
  "many_suppliers": [
    {
      "app_id": "456",
      "id": 1,
      "name": "象传智慧",
      "user_id": 1
    },
    {
      "app_id": "456",
      "id": 2,
      "name": "Yao App Engine",
      "user_id": 1
    }
  ],
  "name": "张无忌",
  "supplier_id": 1
}
```

### 一个用户对应一个供应商

```sh
yao run models.user.Find 1 '::{"withs":{"one_supplier":{}}}'
```

`user.mod.json`关联关系定义：

```json
{
  "one_supplier": {
    "key": "id",
    "foreign": "supplier_id",
    "model": "supplier",
    "type": "hasOne"
  }
}
```

等于筛选条件：`user.supplier_id == supplier.id`。由于 supplier.id 是主键，只可能会有一条记录存在，所有使用 hasOne 比较合适。

结果：只会返回一个供应商。

```json
{
  "app_id": "123",
  "id": 1,
  "name": "张无忌",
  "one_supplier": {
    "app_id": "456",
    "id": 1,
    "name": "象传智慧",
    "user_id": 1
  },
  "supplier_id": 1
}
```

### 非主键关连关系。

除了使用两个模型的主键来定义模型的关联关系外，还可以使用模型中的非关键字段来定义关系。

模型`user`与`supplier`中都定义了一个`app_id`的字段。

```sh
yao run models.user.Find 2 '::{"withs":{"apps":{}}}'

```

关联关系定义。等于筛选条件：`user.app_id == supplier.app_id`。

```json
{
  "apps": {
    "key": "app_id",
    "foreign": "app_id",
    "model": "supplier",
    "type": "hasMany"
  }
}
```

等于筛选条件`user.app_id == supplier.app_id`,非主键关联，设置类型为`hasMany`。

output:

```sh
{
    "app_id": "456",
    "id": 2,
    "name": "李光富",
    "supplier_id": 1,
    "suppliers": [
        {
            "app_id": "456",
            "id": 1,
            "name": "象传智慧"
        },
        {
            "app_id": "456",
            "id": 2,
            "name": "Yao App Engine"
        }
    ]
}
```

### 关联关系总结

通过对比一对一与一对多关系的定义发现，灵活的使用`relations.key`与`relations.foreign`。可以达到不同的效果。

如何实现一个供应商对应多个用户呢？在模型`supplier`中定义关联关系即可。

## 最佳实践

1. **命名规范**

   - 使用小写字母和下划线命名表和字段
   - 保持命名一致性（如 created_at 而不是 create_time）
   - 避免使用保留字作为字段名

2. **字段设计**

   - 为每个字段添加注释（comment）
   - 合理设置字段长度（length）
   - 使用合适的字段类型（如 enum 代替字符串表示固定值）
   - 为常用查询字段添加索引

3. **关系设计**

   - 明确关系类型（hasOne/hasMany）
   - 添加外键约束
   - 考虑级联操作（cascade）

4. **性能优化**

   - 避免过度索引
   - 合理使用默认值
   - 考虑数据分区（partitioning）

5. **安全性**

   - 对敏感字段加密（crypt）
   - 使用强验证规则
   - 限制字段长度防止溢出

6. **可维护性**
   - 保持模型文件简洁
   - 使用合理的默认值
   - 添加必要的验证规则

## 常见问题与解决方案

1. **字段类型不匹配**

   - 症状：数据插入失败或查询结果异常
   - 解决方案：检查字段类型定义，确保与数据库类型一致

2. **关系查询失败**

   - 症状：关联查询返回空或错误
   - 解决方案：检查 relations 配置，确保 key 和 foreign 正确

3. **验证规则不生效**

   - 症状：无效数据被插入
   - 解决方案：检查 validations 配置，确保规则正确

4. **性能问题**
   - 症状：查询缓慢
   - 解决方案：添加适当索引，优化查询条件

## 快速参考指南

### 常用字段类型速查表

| 类型     | 说明      | 示例                                        |
| -------- | --------- | ------------------------------------------- |
| string   | 字符串    | `"type": "string", "length": 255`           |
| integer  | 整数      | `"type": "integer"`                         |
| float    | 浮点数    | `"type": "float"`                           |
| boolean  | 布尔值    | `"type": "boolean"`                         |
| date     | 日期      | `"type": "date"`                            |
| datetime | 日期时间  | `"type": "datetime"`                        |
| json     | JSON 数据 | `"type": "json"`                            |
| enum     | 枚举值    | `"type": "enum", "option": ["A", "B", "C"]` |

### 常用验证规则速查表

| 规则    | 说明       | 示例                                        |
| ------- | ---------- | ------------------------------------------- |
| typeof  | 类型验证   | `"method": "typeof", "args": ["string"]`    |
| min     | 最小值     | `"method": "min", "args": [0]`              |
| max     | 最大值     | `"method": "max", "args": [100]`            |
| enum    | 枚举验证   | `"method": "enum", "args": ["A", "B"]`      |
| pattern | 正则表达式 | `"method": "pattern", "args": ["^[A-Z]+$"]` |
| email   | 邮箱格式   | `"method": "email"`                         |
| mobile  | 手机号格式 | `"method": "mobile"`                        |

### 常用关系类型速查表

| 类型          | 说明               | 示例                      |
| ------------- | ------------------ | ------------------------- |
| hasOne        | 一对一             | `"type": "hasOne"`        |
| hasMany       | 一对多             | `"type": "hasMany"`       |
| belongsTo     | 属于               | `"type": "belongsTo"`     |
| hasOneThrough | 通过中间表的一对一 | `"type": "hasOneThrough"` |

### 常用配置选项

| 选项         | 说明       | 示例                   |
| ------------ | ---------- | ---------------------- |
| timestamps   | 自动时间戳 | `"timestamps": true`   |
| soft_deletes | 软删除     | `"soft_deletes": true` |
| engine       | 数据库引擎 | `"engine": "InnoDB"`   |
| charset      | 字符集     | `"charset": "utf8mb4"` |

## 模型迁移

Yao 提供了强大的模型迁移功能，可以自动同步模型定义到数据库结构。以下是迁移相关的重要概念和操作：

### 迁移命令

| 命令                           | 说明                     |
| ------------------------------ | ------------------------ |
| `yao migrate`                  | 执行所有未应用的迁移     |
| `yao migrate --reset`          | 重置，删帖所有表后再执行 |
| `yao migrate -n model --reset` | 指定模型进行表应用变更   |

## 模型对应的处理器

当一个模型被定义后，Yao 会自动为其生成一系列处理器（Process），用于执行 CRUD 操作。这些处理器的命名规则遵循一定的模式：`models.<模型ID>.<方法名>`。 例如，对于名为 `category` 的模型，其创建记录的处理器为 `models.category.create`。

下面是一些常见的处理器及其参数表：

备注：**`<ID>` 为 `Model Widget ID`**

| 处理器                           | 参数表                                      | 返回值                     | 说明                                                                                                    |
| -------------------------------- | ------------------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------- |
| models.<ID\>.Find                | `<主键值>,<查询条件>`                       | 单条记录                   | 查询单条记录 [示例](#find)                                                                              |
| models.<ID\>.Get                 | `<主键值>,<查询条件>`                       | 记录数组                   | 根据条件查询, 不分页 [示例](#get)                                                                       |
| models.<ID\>.Paginate            | `<查询条件>,<当前页码>, <每页显示记录数>`   | 分页信息和记录数组         | 根据条件查询, 分页 [示例](#paginate)                                                                    |
| models.<ID\>.Create              | `<记录>`                                    | 新记录主键值               | 创建单条记录, 返回新创建记录 ID [示例](#create)                                                         |
| models.<ID\>.Update              | `<主键值>,<记录>`                           | null                       | 更新单条记录 [示例](#update)                                                                            |
| models.<ID\>.Save                | `<记录>`                                    | 记录主键值                 | 保存单条记录, 不存在创建记录, 存在更新记录, 返回记录 ID [示例](#save)                                   |
| models.<ID\>.Delete              | `<主键值>`                                  | null                       | 删除单条记录(标记删除) [示例](#delete)                                                                  |
| models.<ID\>.Destroy             | `<主键值>`                                  | null                       | 删除单条记录(真删除) [示例](#destroy)                                                                   |
| models.<ID\>.Insert              | `<字段名称数组>, <二维记录值数组>`          | 成功插入行数               | 插入多条记录, 返回插入行数 [示例](#insert)                                                              |
| models.<ID\>.UpdateWhere         | `<查询条件>,<记录>`                         | 成功更新行数               | 根据条件更新记录, 返回更新行数 [示例](#updatewhere)                                                     |
| models.<ID\>.DeleteWhere         | `<查询条件>`                                | 成功删除行数               | 根据条件删除数据, 返回删除行数(标记删除) [示例](#deletewhere)                                           |
| models.<ID\>.DestroyWhere        | `<查询条件>`                                | 成功删除行数               | 根据条件删除数据, 返回删除行数(真删除) [示例](#destroywhere)                                            |
| models.<ID\>.EachSave            | `<记录数组>, <记录(共有字段)>`              | 创建或更新的记录主键值数组 | 保存多条记录, 不存在创建记录, 存在更新记录, 返回记录 ID 集合 [示例](#eachsave)                          |
| models.<ID\>.EachSaveAfterDelete | `<主键值数组>,<记录数组>, <记录(共有字段)>` | 创建或更新的记录主键值数组 | 删除一组给定 ID 的记录后，保存多条记录, 不存在创建, 存在更新, 返回 ID 集合 [示例](#eachsaveafterdelete) |

## 创建数据

### Create 创建数据记录

创建单条记录, 返回新创建记录的主键。

处理器：`models.模型标识.Create`。

- 参数 1：数据记录，示例：`{"name": "用户创建","manu_id": 2,"type": "user"}`

返回新创建的记录 ID。

示例：

```js
const id = Process('models.category.create', {
  parent_id: 1,
  name: '英语',
});
return id;
```

### Insert 插入数据记录

一次性插入多条数据记录，返回插入行数。如果单纯是插入数据，方法 Insert 会比 EachSave 快。

处理器：`models.模型标识.Insert`。

- 参数 1：字段清单集合，一维数组。
- 参数 2：数据记录集合，二维数组。

返回插入行数。

示例：

```javascript
function Insert() {
  return Process(
    'models.category.insert',
    ['parent_id', 'name'],
    [
      [1, '语文'],
      [1, '地理'],
    ],
  );
}
```

通常需要配合处理器`utils.arr.split`进行处理。

```js
const data = [
  { parent_id: 1, name: '语文' },
  { parent_id: 1, name: '地理' },
];

// 把对象数组拆分为列数组与值数组
const { columns, values } = Process('utils.arr.split', data);

return Process('models.category.insert', columns, values);
```

## 更新数据

### Update

根据主键 id 更新单条数据记录。

处理器：`models.模型标识.Update`。

- 参数 1：模型主键 id。
- 参数 2：数据记录, 示例：`{"balance": 200}`。

成功返回`null`。

示例：

```javascript
function Update() {
  return Process('models.category.update', 9, {
    parent_id: 1,
    name: '英语',
  });
}
```

### UpdateWhere

根据条件更新数据记录, 返回更新行数。

处理器：`models.模型标识.UpdateWhere`。

- 参数 1：查询条件。
- 参数 2：数据记录。

返回更新行数。

示例：

```javascript
function UpdateWhere() {
  return Process(
    'models.category.updatewhere',
    {
      wheres: [{ column: 'parent_id', value: 1 }],
    },
    {
      name: '数学',
    },
  );
}
```

### Save

创建或更新单条记录。如数据记录中包含 id 则更新，不包含 id 则创建记录；返回创建或更新的记录 ID。

处理器：`models.模型标识.Save`。

- 参数 1：数据记录，示例：`{"name": "用户创建","manu_id": 2,"type": "user"}`。

返回创建或更新的记录 ID。

示例：

```javascript
function Save() {
  return Process('models.category.save', {
    parent_id: 1,
    name: '语文',
  });
}
```

### EachSave

批量创建或是更新多条记录, 不包含主键字段则创建记录, 存在更新记录。

处理器：`models.模型标识.EachSave`。

- 参数 1：必填项，待保存数据记录集合。
- 参数 2：可选项，共有字段，写入时合并到到每条数据记录；若字段数值为 `$index` 将替换为数据记录集合的 index。

返回创建或更新的记录 ID 集合。

示例：

```js
const ids = Process(
  'models.user.EachSave',
  [{ id: 101, name: '张三' }, { name: '李四' }],
  { manu_id: 2, balance: '$index' },
);
//[101, 107]
return ids;
```

注：每次保存都会调用一次数据库操作。

### EachSaveAfterDelete

删除并保存数据，删除给定 ID 的记录后，保存多条记录数据, 不包含主键字段则创建记录, 存在更新记录, 返回记录 ID 集合 ，返回创建或更新的记录 ID 集合。

处理器：`models.模型标识.EachSaveAfterDelete`。

- 参数 1：必填项，删除的记录 ID 集合。
- 参数 2：必填项，待保存数据记录集合。
- 参数 3：可选项，共有字段，写入时合并到到每条数据记录；若字段数值为 `$index` 将替换为数据记录集合的 index。

返回创建或更新的记录 ID 集合。

示例：

```js
const ids = Process(
  'models.user.EachSaveAfterDelete',
  [1, 2, 3],
  [{ id: 101, name: '张三' }, { name: '李四' }],
  { manu_id: 2, balance: '$index' },
);
//[101, 107]
return ids;
```

## 删除数据

### Delete

根据 id 删除数据，如模型定义时未开启 `soft_deletes` 则真删除数据记录。

处理器：`models.模型标识.Delete`。

- 参数 1：数据记录 id。

成功返回`null`。

示例：

```javascript
function deletes() {
  return Process('models.category.delete', 10);
}
```

### DeleteWhere

根据条件删除数据。

如模型定义时未开启 `soft_deletes` 则真删除数据记录。

处理器：`models.模型标识.DeleteWhere`。

- 参数 1：查询条件, 示例：`{"wheres":[{"column":"name", "value":"张三"}]}`。

返回删除行数。

```javascript
function Deletewhere() {
  return Process('models.category.deletewhere', {
    wheres: [{ column: 'parent_id', value: 4 }],
  });
}
```

### Destroy

根据主键 id 真删除单条数据记录。

处理器：`models.模型标识.Destroy`。

- 参数 1：模型主键 id。

成功返回`null`。

示例：

```javascript
function Destroy() {
  return Process('models.category.destroy', 9);
}
```

### DestroyWhere

根据条件真删除数据。

处理器：`models.模型标识.DestroyWhere`。

- 参数 1：查询条件，示例：`{"wheres":[{"column":"name", "value":"张三"}]}`。

返回删除行数。

示例：

```javascript
function Destroywhere() {
  return Process('models.category.destroywhere', {
    wheres: [{ column: 'parent_id', value: 4 }],
  });
}
```

## 查找数据

### find

根据主键 id 查询单条记录。

处理器：`models.模型标识.Find`。

- 参数 1：模型主键。
- 参数 2：查询条件。

返回数据记录对象。

AES 字段自动解密。 关联模型作为一个独立字段，字段名称为关联关系名称； hasOne 关联为数据记录 Object , hasMany 关联为数据记录数组 Array\<Object\>,如果存在多个 hasMany 有会异常。

示例：

```javascript
function Find() {
  return Process('models.user.find', 1, {
    withs: { manu: {}, mother: {}, addresses: {} },
  });
}
```

### get

根据条件查询数据记录, 返回符合条件的结果集。相关于 SQL 中的 select,使用比较频繁的处理器。

处理器：`models.模型标识.Get`。

- 参数 1，查询条件, 示例：`{"wheres":[{"column":"name", "value":"张三"}],"withs":{"manu":{}}}`，查询条件使用是 [QueryParam](../Query/QueryParam%E8%AF%AD%E6%B3%95.md) 结构。

返回符合条件的的数据记录（Key-Value 结构 Object)集合。AES 字段自动解密。 关联模型作为一个独立字段，字段名称为关联关系名称； hasOne 关联为数据记录 Object , hasMany 关联为数据记录数组 Array\<Object\>。

需要注意：如果存在多个 hasMany 有会异常。

示例：

```javascript
function Get() {
  return Process('models.category.get', {
    wheres: [{ column: 'parent_id', value: null }],
  });
}
```

这个处理器返回的结果类型是数组，所以只搜索每一条数据时可以这样使用

```js
//直接返回[0],而不会报错
return Process('models.ai.setting.Get', {
  wheres: [
    {
      Column: 'default',
      Value: true,
    },
    {
      Column: 'deleted_at',
      Value: null,
    },
  ],
})[0];

//使用解构的方法
const [user] = Process('models.admin.user.get', {
  wheres: [
    { column: 'mobile', value: account },
    { column: 'status', value: '启用' },
    { method: 'orwhere', column: 'email', value: account },
  ],
  limit: 1,
});
```

### Paginate

根据条件查询数据记录, 返回带有分页信息的数据对象。

处理器：`models.模型标识.Paginate`。

- 参数 1：查询条件。
- 参数 2：当前页码。
- 参数 3：每页记录数量。

返回带有分页信息的数据对象，**Object Paginate 数据结构**：

| 字段     | 类型                | 说明                          |
| -------- | ------------------- | ----------------------------- |
| data     | Array\<Object Row\> | 数据记录集合                  |
| next     | Integer             | 下一页，如没有下一页返回 `-1` |
| prev     | Integer             | 上一页，如没有上一页返回 `-1` |
| page     | Integer             | 当前页码                      |
| pagesize | Integer             | 每页记录数量                  |
| pagecnt  | Integer             | 总页数                        |
| total    | Integer             | 总记录数                      |

示例：

```javascript
function Paginate() {
  return Process(
    'models.user.Paginate',
    {
      select: ['id', 'name', 'mobile', 'status', 'extra'],
      withs: { manu: {}, mother: {}, addresses: {} },
      wheres: [{ column: 'status', value: 'enabled' }],
      limit: 2,
    },
    1,
    2,
  );
}
```

## 总结

此文档介绍了 Yao 模型的定义，还有模型数据操作的处理器。目前大多数的 ai 模型并不了解 yao 的模型定义，可以在使用这些 ai 模型时，引用此文档来作为一个参考。