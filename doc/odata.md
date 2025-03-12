# OData 服务文档

## 概述

OData（Open Data Protocol）是一种基于HTTP的数据访问协议，用于查询和更新数据。本项目实现了OData V2和V4两个版本的服务，允许客户端通过标准的OData协议访问后端数据模型。

## 支持的OData版本

- **OData V2**: 兼容SAP等传统系统，支持XML和JSON格式
- **OData V4**: 最新标准，提供更丰富的查询能力，主要支持JSON格式

## 服务访问地址

### OData V2 服务

```
http://localhost:5099/api/odata/v2/service/
```

### OData V4 服务

```
http://localhost:5099/api/odata/v4/service/
```

## 元数据访问

### 获取服务实体集列表

```
http://localhost:5099/api/odata/v2/service/$
```

### 获取元数据定义

```
http://localhost:5099/api/odata/v2/service/$metadata
```

## 实体集访问

实体集是通过OData视图配置的，每个视图关联一个模型或表格。例如：

```
http://localhost:5099/api/odata/v2/service/admin.user
```

## 支持的查询参数

### 基本查询参数

- **$select**: 选择特定字段
  ```
  ?$select=id,name,email
  ```

- **$filter**: 过滤数据
  ```
  ?$filter=age gt 18
  ```

- **$orderby**: 排序
  ```
  ?$orderby=name asc,age desc
  ```

- **$top**: 限制返回记录数
  ```
  ?$top=10
  ```

- **$skip**: 跳过指定数量的记录
  ```
  ?$skip=10
  ```

- **$count**: 获取记录总数
  ```
  ?$count=true
  ```
  或
  ```
  /admin.user/$count
  ```

- **$format**: 指定返回格式(json或xml)
  ```
  ?$format=json
  ```

### 支持的过滤操作符

- **eq**: 等于
- **ne**: 不等于
- **gt**: 大于
- **ge**: 大于等于
- **lt**: 小于
- **le**: 小于等于
- **has**: 包含

## 批处理操作

操作目前是试验性。

支持OData批处理操作，可以在一个HTTP请求中包含多个操作。

```
POST http://localhost:5099/api/odata/v2/service/$batch
Content-Type: multipart/mixed; boundary=batch_foobarbaz

--batch_foobarbaz
Content-Type: application/http

GET admin.user?$top=5 HTTP/1.1

--batch_foobarbaz--
```

## 数据类型映射

Yao模型字段类型到OData EDM类型的映射：

| Yao类型 | OData EDM类型 |
|---------|---------------|
| STRING, CHAR | Edm.String |
| TEXT, MEDIUMTEXT, LONGTEXT | Edm.String |
| JSON, JSONB | Edm.String |
| DATE, DATETIME, DATETIMETZ | Edm.DateTime |
| TIME, TIMETZ | Edm.Time |
| TIMESTAMP, TIMESTAMPTZ | Edm.DateTime |
| INTEGER类型 | Edm.Int32 |
| BIGINTEGER类型 | Edm.Int64 |
| FLOAT, DOUBLE | Edm.Double |
| DECIMAL | Edm.Decimal |
| BOOLEAN | Edm.Boolean |
| UUID | Edm.Guid |

## 配置OData视图

在系统中，OData视图通过`app.odata.view`模型进行配置，每个视图可以关联到一个模型或表格。

视图配置字段：
- **name**: 视图名称，用于OData实体集访问
- **label**: 显示名称
- **description**: 描述信息
- **model_id**: 关联的模型ID，必要的，一定要选择关联哪个模型
- **table_id**: 关联的表格ID（可选）
- **creatable**: 是否可创建
- **updatable**: 是否可更新
- **deletable**: 是否可删除
- **disabled**: 是否禁用


## Excel

在Excel中进行数据处理或是分析有以下的优点：

1. **强大的数据处理能力**：Excel提供了丰富的数据处理和分析功能，包括筛选、排序、透视表等

2. **直观的可视化**：可以快速创建各种图表和数据可视化效果，帮助更好地理解数据

3. **熟悉的操作界面**：大多数用户都熟悉Excel的操作方式，无需额外学习

4. **灵活的数据导出**：可以方便地将数据导出为多种格式，便于共享和进一步处理

5. **实时数据连接**：通过OData连接，可以实现与后端数据的实时同步，确保数据的及时性

6. **离线工作能力**：数据下载后可以离线处理，不依赖网络连接

7. **协同办公支持**：支持多人同时编辑和共享数据分析结果


在Excel中有两种支持odata有两种方式：
- Microsoft.Data.DataFeedClient/2.0 (PowerPivotExcel15)
- Microsoft.Data.Mashup (https://go.microsoft.com/fwlink/?LinkID=304225)

第一种方式的配置方式：Excel菜单入口: 数据->自其它来源->来自Odata数据馈送，不支持用户名登录验证。

第二种方式的配置方式：Excel菜单入口：数据->新建查询->从其他源->从Odata源，第二种方式支持用户名密码登录验证。输入Odata数据源地址：http://localhost:5099/api/odata/v2/service/，这个地址是一个服务入口。

在第一次登录时会自动的弹出用户名密码输入的对话框。

在管理后台配置所有的odata数据源都会自动列出来。


## 使用示例

### 获取用户列表，只返回id、name和email字段

```
GET http://localhost:5099/api/odata/v2/service/admin.user?$select=id,name,email
```

### 获取年龄大于18岁的用户，按名称升序排序

```
GET http://localhost:5099/api/odata/v2/service/admin.user?$filter=age gt 18&$orderby=name asc
```

### 分页获取用户列表

```
GET http://localhost:5099/api/odata/v2/service/admin.user?$top=10&$skip=20
```

### 获取用户总数

```
GET http://localhost:5099/api/odata/v2/service/admin.user/$count
```

### 获取单个用户

```
GET http://localhost:5099/api/odata/v2/service/admin.user(1)
```