# readme

## models:

- admin.user, core module for user login

- ddic.model, ddic.model.column,ddic.model.element,core models for the amis module manager.

## application models

## mall

https://github.com/macrozheng/mall

cms: 内容管理 content manager system
oms: 订单管理 odrder manager system
pms: 产品管理 prodcut manager system
sms: 销售管理 sales manager system
ums: 用户管理 user manager system

| 分类 | 表名                                        | 描述                                                             |
| ---- | ------------------------------------------- | ---------------------------------------------------------------- |
| cms  | app_cms_help                                | 帮助表                                                           |
| cms  | app_cms_help_category                       | 帮助分类表                                                       |
| cms  | app_cms_member_report                       | 用户举报表                                                       |
| cms  | app_cms_prefrence_area                      | 优选专区                                                         |
| cms  | app_cms_prefrence_area_product_relation     | 优选专区和产品关系表                                             |
| cms  | app_cms_subject                             | 专题表                                                           |
| cms  | app_cms_subject_category                    | 专题分类表                                                       |
| cms  | app_cms_subject_comment                     | 专题评论表                                                       |
| cms  | app_cms_subject_product_relation            | 专题商品关系表                                                   |
| cms  | app_cms_topic                               | 话题表                                                           |
| cms  | app_cms_topic_category                      | 话题分类表                                                       |
| cms  | app_cms_topic_comment                       | 专题评论表                                                       |
| oms  | app_oms_cart_item                           | 购物车表                                                         |
| oms  | app_oms_company_address                     | 公司收发货地址表                                                 |
| oms  | app_oms_order                               | 订单表                                                           |
| oms  | app_oms_order_item                          | 订单中所包含的商品                                               |
| oms  | app_oms_order_operate_history               | 订单操作历史记录                                                 |
| oms  | app_oms_order_return_apply                  | 订单退货申请                                                     |
| oms  | app_oms_order_return_reason                 | 退货原因表                                                       |
| oms  | app_oms_order_setting                       | 订单设置表                                                       |
| pms  | app_pms_album                               | 相册表                                                           |
| pms  | app_pms_album_pic                           | 画册图片表                                                       |
| pms  | app_pms_brand                               | 品牌表                                                           |
| pms  | app_pms_comment                             | 商品评价表                                                       |
| pms  | app_pms_comment_replay                      | 产品评价回复表                                                   |
| pms  | app_pms_feight_template                     | 运费模版                                                         |
| pms  | app_pms_member_price                        | 商品会员价格表                                                   |
| pms  | app_pms_product                             | 商品信息                                                         |
| pms  | app_pms_product_attribute                   | 商品属性参数表                                                   |
| pms  | app_pms_product_attribute_category          | 产品属性分类表                                                   |
| pms  | app_pms_product_attribute_value             | 存储产品参数信息的表                                             |
| pms  | app_pms_product_category                    | 产品分类                                                         |
| pms  | app_pms_product_category_attribute_relation | 产品的分类和属性的关系表，用于设置分类筛选条件（只支持一级分类） |
| pms  | app_pms_product_full_reduction              | 产品满减表(只针对同商品)                                         |
| pms  | app_pms_product_ladder                      | 产品阶梯价格表(只针对同商品)                                     |
| pms  | app_pms_product_vertify_record              | 商品审核记录                                                     |
| pms  | app_pms_sku_stock                           | sku的库存                                                        |
| sms  | app_sms_coupon                              | 优惠券表                                                         |
| sms  | app_sms_coupon_history                      | 优惠券使用、领取历史表                                           |
| sms  | app_sms_coupon_product_category_relation    | 优惠券和产品分类关系表                                           |
| sms  | app_sms_coupon_product_relation             | 优惠券和产品的关系表                                             |
| sms  | app_sms_flash_promotion                     | 限时购表                                                         |
| sms  | app_sms_flash_promotion_log                 | 限时购通知记录                                                   |
| sms  | app_sms_flash_promotion_product_relation    | 商品限时购与商品关系表                                           |
| sms  | app_sms_flash_promotion_session             | 限时购场次表                                                     |
| sms  | app_sms_home_advertise                      | 首页轮播广告表                                                   |
| sms  | app_sms_home_brand                          | 首页推荐品牌表                                                   |
| sms  | app_sms_home_new_product                    | 新鲜好物表                                                       |
| sms  | app_sms_home_recommend_product              | 人气推荐商品表                                                   |
| sms  | app_sms_home_recommend_subject              | 首页推荐专题表                                                   |
| ums  | app_ums_admin                               | 后台用户表                                                       |
| ums  | app_ums_admin_login_log                     | 后台用户登录日志表                                               |
| ums  | app_ums_admin_permission_relation           | 后台用户和权限关系表(除角色中定义的权限以外的加减权限)           |
| ums  | app_ums_admin_role_relation                 | 后台用户和角色关系表                                             |
| ums  | app_ums_growth_change_history               | 成长值变化历史记录表                                             |
| ums  | app_ums_integration_change_history          | 积分变化历史记录表                                               |
| ums  | app_ums_integration_consume_setting         | 积分消费设置                                                     |
| ums  | app_ums_member                              | 会员表                                                           |
| ums  | app_ums_member_level                        | 会员等级表                                                       |
| ums  | app_ums_member_login_log                    | 会员登录记录                                                     |
| ums  | app_ums_member_member_tag_relation          | 用户和标签关系表                                                 |
| ums  | app_ums_member_product_category_relation    | 会员与产品分类关系表（用户喜欢的分类）                           |
| ums  | app_ums_member_receive_address              | 会员收货地址表                                                   |
| ums  | app_ums_member_rule_setting                 | 会员积分成长规则表                                               |
| ums  | app_ums_member_statistics_info              | 会员统计信息                                                     |
| ums  | app_ums_member_tag                          | 用户标签表                                                       |
| ums  | app_ums_member_task                         | 会员任务表                                                       |
| ums  | app_ums_menu                                | 后台菜单表                                                       |
| ums  | app_ums_permission                          | 后台用户权限表                                                   |
| ums  | app_ums_resource                            | 后台资源表                                                       |
| ums  | app_ums_resource_category                   | 资源分类表                                                       |
| ums  | app_ums_role                                | 后台用户角色表                                                   |
| ums  | app_ums_role_menu_relation                  | 后台角色菜单关系表                                               |
| ums  | app_ums_role_permission_relation            | 后台用户角色和权限关系表                                         |
| ums  | app_ums_role_resource_relation              | 后台角色资源关系表                                               |

## litemall

https://github.com/linlinjava/litemall/tree/master/litemall-db/sql

| 分类    | 表名                             | 描述               |
| ------- | -------------------------------- | ------------------ |
| litemal | app_litemall_ad                  | 广告表             |
| litemal | app_litemall_address             | 收货地址表         |
| litemal | app_litemall_admin               | 管理员表           |
| litemal | app_litemall_aftersale           | 售后表             |
| litemal | app_litemall_brand               | 品牌商表           |
| litemal | app_litemall_cart                | 购物车商品表       |
| litemal | app_litemall_category            | 类目表             |
| litemal | app_litemall_collect             | 收藏表             |
| litemal | app_litemall_comment             | 评论表             |
| litemal | app_litemall_coupon              | 优惠券信息及规则表 |
| litemal | app_litemall_coupon_user         | 优惠券用户使用表   |
| litemal | app_litemall_feedback            | 意见反馈表         |
| litemal | app_litemall_footprint           | 用户浏览足迹表     |
| litemal | app_litemall_goods               | 商品基本信息表     |
| litemal | app_litemall_goods_attribute     | 商品参数表         |
| litemal | app_litemall_goods_product       | 商品货品表         |
| litemal | app_litemall_goods_specification | 商品规格表         |
| litemal | app_litemall_groupon             | 团购活动表         |
| litemal | app_litemall_groupon_rules       | 团购规则表         |
| litemal | app_litemall_issue               | 常见问题表         |
| litemal | app_litemall_keyword             | 关键字表           |
| litemal | app_litemall_log                 | 操作日志表         |
| litemal | app_litemall_notice              | 通知表             |
| litemal | app_litemall_notice_admin        | 通知管理员表       |
| litemal | app_litemall_order               | 订单表             |
| litemal | app_litemall_order_goods         | 订单商品表         |
| litemal | app_litemall_permission          | 权限表             |
| litemal | app_litemall_region              | 行政区域表         |
| litemal | app_litemall_role                | 角色表             |
| litemal | app_litemall_search_history      | 搜索历史表         |
| litemal | app_litemall_storage             | 文件存储表         |
| litemal | app_litemall_system              | 系统配置表         |
| litemal | app_litemall_topic               | 专题表             |
| litemal | app_litemall_user                | 用户表             |

## jsh erp

https://github.com/jishenghua/jshERP/blob/master/jshERP-boot/docs/jsh_erp.sql

| 分类 | 表名                           | 描述                 |
| ---- | ------------------------------ | -------------------- |
| jsh  | app_jsh_account                | 账户信息             |
| jsh  | app_jsh_account_head           | 财务主表             |
| jsh  | app_jsh_account_item           | 财务子表             |
| jsh  | app_jsh_depot                  | 仓库表               |
| jsh  | app_jsh_depot_head             | 单据主表             |
| jsh  | app_jsh_depot_item             | 单据子表             |
| jsh  | app_jsh_function               | 功能模块表           |
| jsh  | app_jsh_in_out_item            | 收支项目             |
| jsh  | app_jsh_log                    | 操作日志             |
| jsh  | app_jsh_material               | 产品表               |
| jsh  | app_jsh_material_attribute     | 产品属性表           |
| jsh  | app_jsh_material_category      | 产品类型表           |
| jsh  | app_jsh_material_current_stock | 产品当前库存         |
| jsh  | app_jsh_material_extend        | 产品价格扩展         |
| jsh  | app_jsh_material_initial_stock | 产品初始库存         |
| jsh  | app_jsh_material_property      | 产品扩展字段表       |
| jsh  | app_jsh_msg                    | 消息表               |
| jsh  | app_jsh_organization           | 机构表               |
| jsh  | app_jsh_orga_user_rel          | 机构用户关系表       |
| jsh  | app_jsh_person                 | 经手人表             |
| jsh  | app_jsh_platform_config        | 平台参数             |
| jsh  | app_jsh_role                   | 角色表               |
| jsh  | app_jsh_sequence               | 单据编号表           |
| jsh  | app_jsh_serial_number          | 序列号表             |
| jsh  | app_jsh_supplier               | 供应商/客户信息表    |
| jsh  | app_jsh_system_config          | 系统参数             |
| jsh  | app_jsh_tenant                 | 租户                 |
| jsh  | app_jsh_unit                   | 多单位表             |
| jsh  | app_jsh_user                   | 用户表               |
| jsh  | app_jsh_user_business          | 用户/角色/模块关系表 |

## yshop

yshop: https://github.com/guchengwuyue

| 分类  | 表名                                  | 描述                 |
| ----- | ------------------------------------- | -------------------- |
| yshop | app_yshop_shipping_templates          | 运费模板表           |
| yshop | app_yshop_store_canvas                | 画布信息表           |
| yshop | app_yshop_store_cart                  | 购物车表             |
| yshop | app_yshop_store_category              | 商品分类表           |
| yshop | app_yshop_store_order                 | 订单表               |
| yshop | app_yshop_store_order_cart_info       | 订单购物详情表       |
| yshop | app_yshop_store_order_status          | 订单操作记录表       |
| yshop | app_yshop_store_product               | 商品表               |
| yshop | app_yshop_store_product_attr          | 商品属性表           |
| yshop | app_yshop_store_product_attr_result   | 商品属性详情表       |
| yshop | app_yshop_store_product_attr_value    | 商品属性值表         |
| yshop | app_yshop_store_product_relation      | 商品点赞和收藏表     |
| yshop | app_yshop_store_product_reply         | 评论表               |
| yshop | app_yshop_store_product_rule          | 商品规则值(规格)表   |
| yshop | app_yshop_system_city                 | 城市表               |
| yshop | app_yshop_user                        | 用户表               |
| yshop | app_yshop_user_address                | 用户地址表           |
| yshop | app_yshop_user_bill                   | 用户账单表           |
| yshop | app_yshop_user_extract                | 用户提现表           |
| yshop | app_yshop_wechat_article              | 文章管理表           |
| yshop | app_yshop_wechat_menu                 | 微信缓存表           |
| yshop | app_yshop_infra_api_access_log        | API 访问日志表       |
| yshop | app_yshop_infra_api_error_log         | 系统异常日志         |
| yshop | app_yshop_infra_codegen_column        | 代码生成表字段定义   |
| yshop | app_yshop_infra_codegen_table         | 代码生成表定义       |
| yshop | app_yshop_infra_config                | 参数配置表           |
| yshop | app_yshop_infra_data_source_config    | 数据源配置表         |
| yshop | app_yshop_infra_file                  | 文件表               |
| yshop | app_yshop_infra_file_config           | 文件配置表           |
| yshop | app_yshop_infra_job                   | 定时任务表           |
| yshop | app_yshop_infra_job_log               | 定时任务日志表       |
| yshop | app_yshop_merchant_details            | 支付服务商配置       |
| yshop | app_yshop_mp_account                  | 公众号账号表         |
| yshop | app_yshop_mp_auto_reply               | 公众号消息自动回复表 |
| yshop | app_yshop_mp_material                 | 公众号素材表         |
| yshop | app_yshop_mp_menu                     | 公众号菜单表         |
| yshop | app_yshop_mp_message                  | 公众号消息表         |
| yshop | app_yshop_mp_tag                      | 公众号标签表         |
| yshop | app_yshop_mp_user                     | 公众号粉丝表         |
| yshop | app_yshop_system_dept                 | 部门表               |
| yshop | app_yshop_system_dict_data            | 字典数据表           |
| yshop | app_yshop_system_dict_type            | 字典类型表           |
| yshop | app_yshop_system_error_code           | 错误码表             |
| yshop | app_yshop_system_login_log            | 系统访问记录         |
| yshop | app_yshop_system_mail_account         | 邮箱账号表           |
| yshop | app_yshop_system_mail_log             | 邮件日志表           |
| yshop | app_yshop_system_mail_template        | 邮件模版表           |
| yshop | app_yshop_system_menu                 | 菜单权限表           |
| yshop | app_yshop_system_notice               | 通知公告表           |
| yshop | app_yshop_system_notify_message       | 站内信消息表         |
| yshop | app_yshop_system_notify_template      | 站内信模板表         |
| yshop | app_yshop_system_oauth2_access_token  | OAuth2 访问令牌      |
| yshop | app_yshop_system_oauth2_approve       | OAuth2 批准表        |
| yshop | app_yshop_system_oauth2_client        | OAuth2 客户端表      |
| yshop | app_yshop_system_oauth2_code          | OAuth2 授权码表      |
| yshop | app_yshop_system_oauth2_refresh_token | OAuth2 刷新令牌      |
| yshop | app_yshop_system_operate_log          | 操作日志记录 V2 版本 |
| yshop | app_yshop_system_post                 | 岗位信息表           |
| yshop | app_yshop_system_role                 | 角色信息表           |
| yshop | app_yshop_system_role_menu            | 角色和菜单关联表     |
| yshop | app_yshop_system_sensitive_word       | 敏感词               |
| yshop | app_yshop_system_sms_channel          | 短信渠道             |
| yshop | app_yshop_system_sms_code             | 手机验证码           |
| yshop | app_yshop_system_sms_log              | 短信日志             |
| yshop | app_yshop_system_sms_template         | 短信模板             |
| yshop | app_yshop_system_social_user          | 社交用户表           |
| yshop | app_yshop_system_social_user_bind     | 社交绑定表           |
| yshop | app_yshop_system_tenant               | 租户表               |
| yshop | app_yshop_system_tenant_package       | 租户套餐表           |
| yshop | app_yshop_system_users                | 用户信息表           |
| yshop | app_yshop_system_user_post            | 用户岗位表           |
| yshop | app_yshop_system_user_role            | 用户和角色关联表     |
| yshop | app_yshop_coupon                      | 优惠券表             |
| yshop | app_yshop_coupon_user                 | 用户领的优惠券       |
| yshop | app_yshop_express                     | 快递公司表           |
| yshop | app_yshop_material                    | 素材库               |
| yshop | app_yshop_material_group              | 素材分组             |
| yshop | app_yshop_order_number                | 订单取餐号表         |
| yshop | app_yshop_service                     | 我的服务             |
| yshop | app_yshop_shipping_templates_free     | 运费包邮明细         |
| yshop | app_yshop_shipping_templates_region   | 运费区域明细         |
| yshop | app_yshop_shop_ads                    | 广告图管理           |
| yshop | app_yshop_store_product_brand         | 商品品牌             |
| yshop | app_yshop_store_shop                  | 门店管理             |
| yshop | app_yshop_wechat_template             | 微信模板             |
| yshop | app_yshop_crm_business                | 商机表               |
| yshop | app_yshop_crm_business_product        | 商机产品关联表       |
| yshop | app_yshop_crm_clues                   | 线索表               |
| yshop | app_yshop_crm_contract                | 合同表               |
| yshop | app_yshop_crm_contract_product        | 合同产品关系表       |
| yshop | app_yshop_crm_contract_receivables    | 回款表               |
| yshop | app_yshop_crm_customer                | 客户表               |
| yshop | app_yshop_crm_customer_contacts       | 联系人表             |
| yshop | app_yshop_crm_flow                    | 审批流程表           |
| yshop | app_yshop_crm_flow_log                | 审核日志表           |
| yshop | app_yshop_crm_flow_step               | 审批步骤表           |
| yshop | app_yshop_crm_invoice                 | 发票表               |
| yshop | app_yshop_crm_operatelog              | 操作日志表           |
| yshop | app_yshop_crm_record                  | 跟进记录             |
