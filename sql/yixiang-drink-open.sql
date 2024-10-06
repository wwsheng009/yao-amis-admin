/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : localhost:3306
 Source Schema         : yixiang-drink-open

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 14/06/2024 14:24:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for infra_api_access_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_access_log`;
CREATE TABLE `infra_api_access_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT '0' COMMENT '用户类型',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求地址',
  `request_params` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求参数',
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `operate_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作模块',
  `operate_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作名',
  `operate_type` tinyint(1) DEFAULT '0' COMMENT '操作分类',
  `begin_time` datetime NOT NULL COMMENT '开始请求时间',
  `end_time` datetime NOT NULL COMMENT '结束请求时间',
  `duration` int NOT NULL COMMENT '执行时长',
  `result_code` int NOT NULL DEFAULT '0' COMMENT '结果码',
  `result_msg` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '结果提示',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39086 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='API 访问日志表';

-- ----------------------------
-- Records of infra_api_access_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_api_error_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_error_log`;
CREATE TABLE `infra_api_error_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链路追踪编号\n     *\n     * 一般来说，通过链路追踪编号，可以将访问日志，错误日志，链路追踪日志，logger 打印日志等，结合在一起，从而进行排错。',
  `user_id` int NOT NULL DEFAULT '0' COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT '0' COMMENT '用户类型',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名\n     *\n     * 目前读取 spring.application.name',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求地址',
  `request_params` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求参数',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `exception_time` datetime NOT NULL COMMENT '异常发生时间',
  `exception_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '异常名\n     *\n     * {@link Throwable#getClass()} 的类全名',
  `exception_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常导致的消息\n     *\n     * {@link cn.iocoder.common.framework.util.ExceptionUtil#getMessage(Throwable)}',
  `exception_root_cause_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常导致的根消息\n     *\n     * {@link cn.iocoder.common.framework.util.ExceptionUtil#getRootCauseMessage(Throwable)}',
  `exception_stack_trace` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常的栈轨迹\n     *\n     * {@link cn.iocoder.common.framework.util.ExceptionUtil#getServiceException(Exception)}',
  `exception_class_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的类全名\n     *\n     * {@link StackTraceElement#getClassName()}',
  `exception_file_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的类文件\n     *\n     * {@link StackTraceElement#getFileName()}',
  `exception_method_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异常发生的方法名\n     *\n     * {@link StackTraceElement#getMethodName()}',
  `exception_line_number` int NOT NULL COMMENT '异常发生的方法所在行\n     *\n     * {@link StackTraceElement#getLineNumber()}',
  `process_status` tinyint NOT NULL COMMENT '处理状态',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  `process_user_id` int DEFAULT '0' COMMENT '处理用户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1570 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统异常日志';

-- ----------------------------
-- Records of infra_api_error_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_codegen_column
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_column`;
CREATE TABLE `infra_codegen_column` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NOT NULL COMMENT '表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段名',
  `data_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段类型',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段描述',
  `nullable` bit(1) NOT NULL COMMENT '是否允许为空',
  `primary_key` bit(1) NOT NULL COMMENT '是否主键',
  `auto_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否自增',
  `ordinal_position` int NOT NULL COMMENT '排序',
  `java_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java 属性类型',
  `java_field` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java 属性名',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `example` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '数据示例',
  `create_operation` bit(1) NOT NULL COMMENT '是否为 Create 创建操作的字段',
  `update_operation` bit(1) NOT NULL COMMENT '是否为 Update 更新操作的字段',
  `list_operation` bit(1) NOT NULL COMMENT '是否为 List 查询操作的字段',
  `list_operation_condition` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '=' COMMENT 'List 查询操作的条件类型',
  `list_operation_result` bit(1) NOT NULL COMMENT '是否为 List 查询操作的返回字段',
  `html_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '显示类型',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2426 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表字段定义';

-- ----------------------------
-- Table structure for infra_codegen_table
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_table`;
CREATE TABLE `infra_codegen_table` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `data_source_config_id` bigint NOT NULL COMMENT '数据源配置的编号',
  `scene` tinyint NOT NULL DEFAULT '1' COMMENT '生成场景',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '表描述',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类名称',
  `class_comment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类描述',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `template_type` tinyint NOT NULL DEFAULT '1' COMMENT '模板类型',
  `front_type` tinyint NOT NULL COMMENT '前端类型',
  `parent_menu_id` bigint DEFAULT NULL COMMENT '父菜单编号',
  `master_table_id` bigint DEFAULT NULL COMMENT '主表的编号',
  `sub_join_column_id` bigint DEFAULT NULL COMMENT '子表关联主表的字段编号',
  `sub_join_many` bit(1) DEFAULT NULL COMMENT '主表与子表是否一对多',
  `tree_parent_column_id` bigint DEFAULT NULL COMMENT '树表的父字段编号',
  `tree_name_column_id` bigint DEFAULT NULL COMMENT '树表的名字字段编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表定义';

-- ----------------------------
-- Records of infra_codegen_table
-- ----------------------------
BEGIN;
INSERT INTO `infra_codegen_table` VALUES (131, 0, 1, 'yshop_material', '素材库', NULL, 'product', 'material', 'Material', '素材库', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-10 15:20:54', '1', '2023-05-22 15:04:44', b'0');
INSERT INTO `infra_codegen_table` VALUES (132, 0, 1, 'yshop_material_group', '素材分组', NULL, 'shop', 'materialgroup', 'MaterialGroup', '素材分组', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-10 15:20:54', '1', '2023-05-10 16:26:44', b'0');
INSERT INTO `infra_codegen_table` VALUES (133, 0, 1, 'yshop_store_product_rule', '商品规则值(规格)表', NULL, 'shop', 'storeproductrule', 'StoreProductRule', '商品规则值(规格)', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-17 10:40:31', '1', '2023-05-17 10:47:51', b'0');
INSERT INTO `infra_codegen_table` VALUES (134, 0, 2, 'yshop_store_product', '商品表', NULL, 'product', 'storeproduct', 'StoreProduct', '商品', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-22 13:29:08', '1', '2023-06-12 10:27:01', b'0');
INSERT INTO `infra_codegen_table` VALUES (135, 0, 1, 'yshop_store_product_attr', '商品属性表', NULL, 'product', 'storeproductattr', 'StoreProductAttr', '商品属性', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-27 09:40:31', '1', '2023-05-27 09:43:50', b'0');
INSERT INTO `infra_codegen_table` VALUES (136, 0, 1, 'yshop_store_product_attr_result', '商品属性详情表', NULL, 'product', 'storeproductattrresult', 'StoreProductAttrResult', '商品属性详情', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-27 09:40:31', '1', '2023-05-27 09:44:07', b'0');
INSERT INTO `infra_codegen_table` VALUES (137, 0, 1, 'yshop_store_product_attr_value', '商品属性值表', NULL, 'product', 'storeproductattrvalue', 'StoreProductAttrValue', '商品属性值', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-05-27 09:40:31', '1', '2023-05-27 09:44:22', b'0');
INSERT INTO `infra_codegen_table` VALUES (139, 0, 1, 'yshop_shipping_templates', '运费模板表', NULL, 'product', 'shippingtemplates', 'ShippingTemplates', '运费模板', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-02 14:35:42', '1', '2023-06-02 14:39:25', b'0');
INSERT INTO `infra_codegen_table` VALUES (140, 0, 1, 'yshop_shipping_templates_free', '运费包邮明细', NULL, 'product', 'shippingtemplatesfree', 'ShippingTemplatesFree', '运费包邮明细', 'yshop', 1, 10, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-02 14:35:42', '1', '2023-06-02 14:48:50', b'0');
INSERT INTO `infra_codegen_table` VALUES (141, 0, 1, 'yshop_shipping_templates_region', '运费区域明细', NULL, 'product', 'shippingtemplatesregion', 'ShippingTemplatesRegion', '运费区域明细', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-02 14:35:42', '1', '2023-06-02 14:49:08', b'0');
INSERT INTO `infra_codegen_table` VALUES (142, 0, 1, 'yshop_user', '用户表', NULL, 'member', 'user', 'User', '用户', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 14:49:08', '1', '2023-06-09 14:59:21', b'0');
INSERT INTO `infra_codegen_table` VALUES (151, 0, 1, 'yshop_store_after_sales', '售后记录表', NULL, 'order', 'storeaftersales', 'StoreAfterSales', '售后记录', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 20:45:36', b'0');
INSERT INTO `infra_codegen_table` VALUES (152, 0, 1, 'yshop_store_after_sales_item', '售后子表', NULL, 'order', 'storeaftersalesitem', 'StoreAfterSalesItem', '售后子', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 20:54:31', b'0');
INSERT INTO `infra_codegen_table` VALUES (153, 0, 1, 'yshop_store_after_sales_status', '售后订单操作详情表', NULL, 'order', 'storeaftersalesstatus', 'StoreAfterSalesStatus', '售后订单操作详情', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 21:00:27', b'0');
INSERT INTO `infra_codegen_table` VALUES (154, 0, 1, 'yshop_store_cart', '购物车表', NULL, 'cart', 'storecart', 'StoreCart', '购物车', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-15 17:43:18', b'0');
INSERT INTO `infra_codegen_table` VALUES (155, 0, 1, 'yshop_store_order', '订单表', NULL, 'order', 'storeorder', 'StoreOrder', '订单', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-17 21:53:37', b'0');
INSERT INTO `infra_codegen_table` VALUES (156, 0, 1, 'yshop_store_order_cart_info', '订单购物详情表', NULL, 'order', 'storeordercartinfo', 'StoreOrderCartInfo', '订单购物详情', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 18:04:17', b'0');
INSERT INTO `infra_codegen_table` VALUES (157, 0, 1, 'yshop_store_order_status', '订单操作记录表', NULL, 'order', 'storeorderstatus', 'StoreOrderStatus', '订单操作记录', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 18:04:51', b'0');
INSERT INTO `infra_codegen_table` VALUES (158, 0, 1, 'yshop_user_address', '用户地址表', NULL, 'member', 'useraddress', 'UserAddress', '用户地址', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 16:24:37', b'0');
INSERT INTO `infra_codegen_table` VALUES (159, 0, 1, 'yshop_user_bill', '用户账单表', NULL, 'member', 'userbill', 'UserBill', '用户账单', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-18 20:33:14', b'0');
INSERT INTO `infra_codegen_table` VALUES (160, 0, 1, 'yshop_store_product_reply', '评论表', NULL, 'product', 'storeproductreply', 'StoreProductReply', '评论', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-13 09:40:14', b'0');
INSERT INTO `infra_codegen_table` VALUES (161, 0, 1, 'yshop_store_product_relation', '商品点赞和收藏表', NULL, 'product', 'storeproductrelation', 'StoreProductRelation', '商品点赞和收藏', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-09 19:07:42', '1', '2023-06-13 09:39:36', b'0');
INSERT INTO `infra_codegen_table` VALUES (162, 0, 1, 'yshop_express', '快递公司表', NULL, 'order', 'express', 'Express', '快递公司', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-07-02 10:10:18', '1', '2023-07-02 10:11:22', b'0');
INSERT INTO `infra_codegen_table` VALUES (163, 0, 1, 'yshop_merchant_details', '支付服务商配置', NULL, 'pay', 'merchantdetails', 'MerchantDetails', '支付服务商配置', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-07-14 14:30:07', '1', '2023-07-14 14:33:17', b'0');
INSERT INTO `infra_codegen_table` VALUES (164, 0, 1, 'yshop_electronics_order', '电子面单', NULL, 'express', 'electronicsorder', 'ElectronicsOrder', '电子面单', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-07-20 17:46:33', '1', '2023-07-20 17:47:48', b'0');
INSERT INTO `infra_codegen_table` VALUES (165, 0, 1, 'yshop_store_order_electronics', '订单电子面单记录', NULL, 'order', 'storeorderelectronics', 'StoreOrderElectronics', '订单电子面单记录', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-07-22 16:42:14', '1', '2023-07-22 17:29:35', b'0');
INSERT INTO `infra_codegen_table` VALUES (166, 0, 1, 'yshop_wechat_template', '微信模板', NULL, 'message', 'wechattemplate', 'WechatTemplate', '微信模板', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-07-25 09:37:06', '1', '2023-07-25 09:43:28', b'0');
INSERT INTO `infra_codegen_table` VALUES (167, 0, 1, 'yshop_store_shop', '门店管理', NULL, 'store', 'storeshop', 'StoreShop', '门店管理', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-03 14:35:03', '1', '2023-08-03 14:41:11', b'0');
INSERT INTO `infra_codegen_table` VALUES (168, 0, 1, 'yshop_shop_ads', '广告图管理', NULL, 'shop', 'shopads', 'ShopAds', '广告图管理', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-06 16:37:45', '1', '2023-08-06 16:51:14', b'0');
INSERT INTO `infra_codegen_table` VALUES (169, 0, 1, 'yshop_service', '我的服务', NULL, 'shop', 'service', 'Service', '我的服务', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-06 17:03:51', '1', '2023-08-06 17:04:15', b'0');
INSERT INTO `infra_codegen_table` VALUES (170, 0, 1, 'yshop_recharge', '充值金额管理', NULL, 'shop', 'recharge', 'Recharge', '充值金额管理', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-06 17:13:12', '1', '2023-08-06 17:13:38', b'0');
INSERT INTO `infra_codegen_table` VALUES (172, 0, 1, 'yshop_coupon', '优惠券表', NULL, 'coupon', 'coupon', 'Coupon', '优惠券', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-08 15:18:05', '1', '2023-08-08 15:19:38', b'0');
INSERT INTO `infra_codegen_table` VALUES (173, 0, 1, 'yshop_coupon_user', '用户领的优惠券', NULL, 'coupon', 'couponuser', 'CouponUser', '用户领的优惠券', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-08 15:18:06', '1', '2023-08-08 15:22:16', b'0');
INSERT INTO `infra_codegen_table` VALUES (174, 0, 1, 'yshop_score_order', '积分商城订单表', NULL, 'score', 'scoreorder', 'ScoreOrder', '积分商城订单', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-09 15:38:45', '1', '2023-08-09 16:07:04', b'0');
INSERT INTO `infra_codegen_table` VALUES (175, 0, 1, 'yshop_score_product', '积分产品表', NULL, 'score', 'scoreproduct', 'ScoreProduct', '积分产品', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-08-09 15:38:45', '1', '2023-08-09 16:06:52', b'0');
INSERT INTO `infra_codegen_table` VALUES (176, 0, 1, 'yshop_web_print', '易联云打印机', NULL, 'store', 'webprint', 'WebPrint', '易联云打印机', 'yshop', 1, 20, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-09-06 10:03:12', '1', '2023-09-06 10:07:45', b'0');
COMMIT;

-- ----------------------------
-- Table structure for infra_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_config`;
CREATE TABLE `infra_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数分组',
  `type` tinyint NOT NULL COMMENT '参数类型',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键名',
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键值',
  `visible` bit(1) NOT NULL COMMENT '是否可见',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';

-- ----------------------------
-- Records of infra_config
-- ----------------------------
BEGIN;
INSERT INTO `infra_config` VALUES (2, 'biz', 1, '用户管理-账号初始密码', 'sys.user.init-password', '123456', b'0', '初始化密码 123456', 'admin', '2021-01-05 17:03:48', '1', '2022-03-20 02:25:51', b'0');
INSERT INTO `infra_config` VALUES (7, 'url', 2, 'MySQL 监控的地址', 'url.druid', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:33:38', b'0');
INSERT INTO `infra_config` VALUES (8, 'url', 2, 'SkyWalking 监控的地址', 'url.skywalking', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:57:03', b'0');
INSERT INTO `infra_config` VALUES (9, 'url', 2, 'Spring Boot Admin 监控的地址', 'url.spring-boot-admin', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:52:07', b'0');
INSERT INTO `infra_config` VALUES (10, 'url', 2, 'Swagger 接口文档的地址', 'url.swagger', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:59:00', b'0');
COMMIT;

-- ----------------------------
-- Table structure for infra_data_source_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_data_source_config`;
CREATE TABLE `infra_data_source_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数名称',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据源连接',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据源配置表';

-- ----------------------------
-- Records of infra_data_source_config
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_file
-- ----------------------------
DROP TABLE IF EXISTS `infra_file`;
CREATE TABLE `infra_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件编号',
  `config_id` bigint DEFAULT NULL COMMENT '配置编号',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件 URL',
  `type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `size` int NOT NULL COMMENT '文件大小',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=979 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件表';

-- ----------------------------
-- Records of infra_file
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_file_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_config`;
CREATE TABLE `infra_file_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名',
  `storage` tinyint NOT NULL COMMENT '存储器',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `master` bit(1) NOT NULL COMMENT '是否为主配置',
  `config` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储配置',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件配置表';

-- ----------------------------
-- Records of infra_file_config
-- ----------------------------
BEGIN;
INSERT INTO `infra_file_config` VALUES (4, '数据库', 1, '我是数据库', b'1', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.db.DBFileClientConfig\",\"domain\":\" http://localhost:48081\"}', '1', '2022-03-15 23:56:24', '1', '2023-11-30 15:57:20', b'0');
INSERT INTO `infra_file_config` VALUES (5, '本地磁盘', 10, '测试下本地存储', b'0', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.local.LocalFileClientConfig\",\"basePath\":\"/Users/yshop/file_test\",\"domain\":\"http://127.0.0.1:48080\"}', '1', '2022-03-15 23:57:00', '1', '2023-07-19 15:46:06', b'0');
INSERT INTO `infra_file_config` VALUES (11, 'S3 - 七牛云', 20, NULL, b'0', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3-cn-south-1.qiniucs.com\",\"domain\":\"http://img.yixiang.co\",\"bucket\":\"yshop-pro\",\"accessKey\":\"b7yvuhBSAGjmtPhMFcn9iMOxUOY_I06cA_p0ZUx8\",\"accessSecret\":\"kXM1l5ia1RvSX3QaOEcwI3RLz3Y2rmNszWonKZtP\"}', '1', '2022-03-19 18:00:03', '1', '2023-07-31 09:37:45', b'0');
INSERT INTO `infra_file_config` VALUES (15, 'S3 - 七牛云', 20, '', b'0', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3-cn-south-1.qiniucs.com\",\"domain\":\"http://img.yixiang.co\",\"bucket\":\"yshop-pro\",\"accessKey\":\"b7yvuhBSAGjmtPhMFcn9iMOxUOY_I06cA_p0ZUx8\",\"accessSecret\":\"kXM1l5ia1RvSX3QaOEcwI3RLz3Y2rmNszWonKZtP\"}', '1', '2022-06-10 20:50:41', '1', '2023-07-31 09:38:31', b'0');
INSERT INTO `infra_file_config` VALUES (16, 'S3 - 七牛云', 20, '', b'0', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3-cn-south-1.qiniucs.com\",\"domain\":\"http://img.yixiang.co\",\"bucket\":\"yshop-pro\",\"accessKey\":\"b7yvuhBSAGjmtPhMFcn9iMOxUOY_I06cA_p0ZUx8\",\"accessSecret\":\"kXM1l5ia1RvSX3QaOEcwI3RLz3Y2rmNszWonKZtP\"}', '1', '2022-06-11 20:32:08', '1', '2023-07-31 09:38:53', b'0');
INSERT INTO `infra_file_config` VALUES (17, 'S3 - 七牛云', 20, '', b'0', '{\"@class\":\"co.yixiang.yshop.framework.file.core.client.s3.S3FileClientConfig\",\"endpoint\":\"s3-cn-south-1.qiniucs.com\",\"domain\":\"http://img.yixiang.co\",\"bucket\":\"yshop-pro\",\"accessKey\":\"b7yvuhBSAGjmtPhMFcn9iMOxUOY_I06cA_p0ZUx8\",\"accessSecret\":\"kXM1l5ia1RvSX3QaOEcwI3RLz3Y2rmNszWonKZtP\"}', '1', '2022-06-11 20:32:47', '1', '2023-07-31 09:38:14', b'0');
COMMIT;

-- ----------------------------
-- Table structure for infra_file_content
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_content`;
CREATE TABLE `infra_file_content` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `config_id` bigint NOT NULL COMMENT '配置编号',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `content` mediumblob NOT NULL COMMENT '文件内容',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件表';

-- ----------------------------
-- Records of infra_file_content
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_job
-- ----------------------------
DROP TABLE IF EXISTS `infra_job`;
CREATE TABLE `infra_job` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理器的参数',
  `cron_expression` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CRON 表达式',
  `retry_count` int NOT NULL DEFAULT '0' COMMENT '重试次数',
  `retry_interval` int NOT NULL DEFAULT '0' COMMENT '重试间隔',
  `monitor_timeout` int NOT NULL DEFAULT '0' COMMENT '监控超时时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务表';

-- ----------------------------
-- Records of infra_job
-- ----------------------------
BEGIN;
INSERT INTO `infra_job` VALUES (5, '支付通知 Job', 2, 'payNotifyJob', NULL, '* * * * * ?', 0, 0, 0, '1', '2021-10-27 08:34:42', '1', '2023-07-27 18:45:48', b'1');
INSERT INTO `infra_job` VALUES (16, 'Job 示例', 2, 'demoJob', NULL, '* * * L * ?', 1, 1, 0, '1', '2022-09-24 22:31:41', '1', '2023-06-29 13:35:02', b'0');
COMMIT;

-- ----------------------------
-- Table structure for infra_job_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_job_log`;
CREATE TABLE `infra_job_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `job_id` bigint NOT NULL COMMENT '任务编号',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '处理器的名字',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理器的参数',
  `execute_index` tinyint NOT NULL DEFAULT '1' COMMENT '第几次执行',
  `begin_time` datetime NOT NULL COMMENT '开始执行时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束执行时间',
  `duration` int DEFAULT NULL COMMENT '执行时长',
  `status` tinyint NOT NULL COMMENT '任务状态',
  `result` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '结果数据',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=168767 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务日志表';

-- ----------------------------
-- Records of infra_job_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for infra_test_demo
-- ----------------------------
DROP TABLE IF EXISTS `infra_test_demo`;
CREATE TABLE `infra_test_demo` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '名字',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `type` tinyint NOT NULL COMMENT '类型',
  `category` tinyint NOT NULL COMMENT '分类',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

-- ----------------------------
-- Records of infra_test_demo
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for merchant_details
-- ----------------------------
DROP TABLE IF EXISTS `merchant_details`;
CREATE TABLE `merchant_details` (
  `details_id` char(32) NOT NULL COMMENT '列表id',
  `pay_type` varchar(60) NOT NULL COMMENT '支付类型(支付渠道) 详情查看com.egzosn.pay.spring.boot.core.merchant.PaymentPlatform对应子类，aliPay 支付宝， wxPay微信..等等',
  `appid` varchar(32) DEFAULT NULL COMMENT '应用id',
  `mch_id` varchar(32) DEFAULT NULL COMMENT '商户id，商户号，合作伙伴id等等',
  `cert_store_type` varchar(16) DEFAULT NULL COMMENT '当前面私钥公钥为证书类型的时候，这里必填，可选值:PATH,STR,INPUT_STREAM,CLASS_PATH,URL',
  `key_private` mediumtext COMMENT '私钥或私钥证书',
  `key_public` mediumtext COMMENT '公钥或公钥证书',
  `key_cert` varchar(20480) DEFAULT NULL COMMENT 'key证书,附加证书使用，如SSL证书，或者银联根级证书方面',
  `key_cert_pwd` varchar(32) DEFAULT NULL COMMENT '私钥证书或key证书的密码',
  `notify_url` varchar(256) DEFAULT NULL COMMENT '异步回调',
  `return_url` varchar(256) DEFAULT NULL COMMENT '同步回调地址，大部分用于付款成功后页面转跳',
  `sign_type` varchar(16) NOT NULL COMMENT '签名方式,目前已实现多种签名方式详情查看com.egzosn.pay.common.util.sign.encrypt。MD5,RSA等等',
  `seller` varchar(32) DEFAULT NULL COMMENT '收款账号，暂时只有支付宝部分使用，可根据开发者自行使用',
  `sub_app_id` varchar(32) DEFAULT NULL COMMENT '子appid',
  `sub_mch_id` varchar(32) DEFAULT NULL COMMENT '子商户id',
  `input_charset` varchar(16) NOT NULL DEFAULT 'utf-8' COMMENT '编码类型，大部分为utf-8',
  `is_test` tinyint(1) NOT NULL COMMENT '是否为测试环境: 0 否，1 测试环境',
  `updater` varchar(60) DEFAULT NULL COMMENT '更新者',
  `creator` varchar(60) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT b'0',
  PRIMARY KEY (`details_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='支付服务商配置';

-- ----------------------------
-- Records of merchant_details
-- ----------------------------
BEGIN;
INSERT INTO `merchant_details` VALUES ('ali_app', 'aliPay', '2021001187645179', ' 2088821836348568', NULL, 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNAg588CxTezsPtMT4WcLXUyzyf0qBnzSACek820D4RLdJ0KiOfQzAe3MK1rEaywwWNMJbwrKoEp/bA6DNTRsXvzZ8tF1F5MXi6GdETn3ItHGdwasJM28hvZX2plYY5aQYEpqGZJBlgfQRkeYSe1pwq4JzAELXNzVbtuokssVq3WKVVIIFXEuHxrsC1SGssn0enFd7Q6kUq1O1JLcAQWAHjf9gdVFfzXex0yN6EYGRqWlr8AC5lIr0STKmNIZeCV4WlsEah9askpAyNrlKBGy0lwdfeMQVtJo3WucM9DE2dqePN5RZIECvvYWdMjmAilomx+7di72PnmAGkkHbmosDAgMBAAECggEAMisaJn949daxQ7xIHCgrd1rDch+xzX5sOmXMUvebHPmt0JhpcBCzucPyQVfzORom2bu5rtYNpFjEATNAQer+CavhYer2CIkFkt6m5xmaDQ+OINen16UyE+oU8eVqWn9Rq7LqwYgEC+l5gcrL9aVnnxCWX/4mydV9qXzhv17PeF5yqEIjrAbhQMQbVrPLQTwi3wbC7sm6Z29A5idhld4AsXjlWPXnFzkeZFl8Qc/g5QOHFjs8uIcz+K7uE3H9Gs2LSz07bh0m9jloy/90Q0OzZbPI1NIU3oDTV7/eaRldXw3o9+8uz58MDWhYoWTLLjlkWJZJcJrfnW+P7tDEWpjv2QKBgQDyCZ0dzcz9w4IN5ujOWdplNv3M/MwSb0mGCnHv3tfnvJj4GnTmeIIWic8RhSlyN12Ph+wYaBHTEc+zaXKq5FmnEtKMPXzVci9RbCECTt5M8eYEA4wuYKnAGqPsyzvnffxGAUdvalVmkyRidI/cj+ACDmWjqnsalF9Hd2mMcrhqtQKBgQCVJHL1nJKSjgFqwN80tqlz862rsFaHOsSDT89nPHgTsmr30QFk6FL+BU/wrPsXCg5pMVZtUmw3c8X1TXd9YCnu7wg2+obIUbbXBxQTdhJMq/DUL6hGsfBLkzLzs9moyL76c4gZFqXr/d/POevzIlnATFolnoDOzoEvp7YsMyBZ1wKBgHVJb1eX+PQnn4g5EyuboxdVFJwXDJUKVKiduySv6hQj8kSYHXnpf7CIS02EJ9dvOOlqxl/1Xl3Xzbx1JtnlGgS6PEk1Kp8MXB2qtjw2F8dVmU7soSuAMAIlZrZCrd650FvkFsfI0WWJfCIxtdz942FbtKkg3dK9f4ZUOVOT7AXZAoGAQbsyv3UmVFkp3rbqqPzoaiY3oLezKx6HhagjLMjF00iLRHVlO+f4y+Pje5uBfoH8H/iSstPkxfvMf3SI+UTstlW7NR/tT1RUVSjVfE5Jemk9Vwc6Dw5VbbmOd0II6A6xvQg2L3h/4CagAWDx0NKO4+XCxVm6Q2tYHHy6GXjfBTkCgYEA2x+2PAq8iqX80cLqvh7vSoCh5m6H3aSGM8h+ZgF0lkijavQyIXE0oJxuJUpqgzv/XKqUCVQbaEHuNqKczLr0+QEE+vmexaRqKiUAL4/5xLEjfKk96QE7WbjXypJVBT5KeFPc5JDkNZN/R6d8q2/o4hiNdCyg+S4l/YOOev6YWDY=', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj4e+D+2LfhldbNImCtjGbsxNQiQe6zp0SwS0iywib4pEqwS0gVDUi11uaG4R78cm7kV0GwWuYbeyl3wLmsr9269HJ/FjwWrNJLLwCLqJzNSkBssW7TXge++X3uHK93VeYmu7lRxdk5G/CqOdp5IhqveQOLxHURm+AC9iLtdtxnaCXFxcb54O63mfuZ5/9XJfBRt0boTe8vWTnr8w95PG5XlCBK0lmfZvtUazn/RYBIeCV28bwusQURvAg0Kc/gBoa3wIWiZhzaAiklUaXWoqR+yuoBwzKht8TLkXaOVxswphSoxsddrsn28Fw6rDfRiMKk3S6JcwY58P1n2By+LUPQIDAQAB', NULL, NULL, 'http://localhost:48081/app-api/order/payBack6.json', 'http://localhost:8080/#/pages/mine/mine', 'RSA2', ' 2088821836348568', NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2023-11-09 16:22:23', b'1');
INSERT INTO `merchant_details` VALUES ('ali_h5', 'aliPay', '2021001187645179', ' 2088821836348568', NULL, 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNAg588CxTezsPtMT4WcLXUyzyf0qBnzSACek820D4RLdJ0KiOfQzAe3MK1rEaywwWNMJbwrKoEp/bA6DNTRsXvzZ8tF1F5MXi6GdETn3ItHGdwasJM28hvZX2plYY5aQYEpqGZJBlgfQRkeYSe1pwq4JzAELXNzVbtuokssVq3WKVVIIFXEuHxrsC1SGssn0enFd7Q6kUq1O1JLcAQWAHjf9gdVFfzXex0yN6EYGRqWlr8AC5lIr0STKmNIZeCV4WlsEah9askpAyNrlKBGy0lwdfeMQVtJo3WucM9DE2dqePN5RZIECvvYWdMjmAilomx+7di72PnmAGkkHbmosDAgMBAAECggEAMisaJn949daxQ7xIHCgrd1rDch+xzX5sOmXMUvebHPmt0JhpcBCzucPyQVfzORom2bu5rtYNpFjEATNAQer+CavhYer2CIkFkt6m5xmaDQ+OINen16UyE+oU8eVqWn9Rq7LqwYgEC+l5gcrL9aVnnxCWX/4mydV9qXzhv17PeF5yqEIjrAbhQMQbVrPLQTwi3wbC7sm6Z29A5idhld4AsXjlWPXnFzkeZFl8Qc/g5QOHFjs8uIcz+K7uE3H9Gs2LSz07bh0m9jloy/90Q0OzZbPI1NIU3oDTV7/eaRldXw3o9+8uz58MDWhYoWTLLjlkWJZJcJrfnW+P7tDEWpjv2QKBgQDyCZ0dzcz9w4IN5ujOWdplNv3M/MwSb0mGCnHv3tfnvJj4GnTmeIIWic8RhSlyN12Ph+wYaBHTEc+zaXKq5FmnEtKMPXzVci9RbCECTt5M8eYEA4wuYKnAGqPsyzvnffxGAUdvalVmkyRidI/cj+ACDmWjqnsalF9Hd2mMcrhqtQKBgQCVJHL1nJKSjgFqwN80tqlz862rsFaHOsSDT89nPHgTsmr30QFk6FL+BU/wrPsXCg5pMVZtUmw3c8X1TXd9YCnu7wg2+obIUbbXBxQTdhJMq/DUL6hGsfBLkzLzs9moyL76c4gZFqXr/d/POevzIlnATFolnoDOzoEvp7YsMyBZ1wKBgHVJb1eX+PQnn4g5EyuboxdVFJwXDJUKVKiduySv6hQj8kSYHXnpf7CIS02EJ9dvOOlqxl/1Xl3Xzbx1JtnlGgS6PEk1Kp8MXB2qtjw2F8dVmU7soSuAMAIlZrZCrd650FvkFsfI0WWJfCIxtdz942FbtKkg3dK9f4ZUOVOT7AXZAoGAQbsyv3UmVFkp3rbqqPzoaiY3oLezKx6HhagjLMjF00iLRHVlO+f4y+Pje5uBfoH8H/iSstPkxfvMf3SI+UTstlW7NR/tT1RUVSjVfE5Jemk9Vwc6Dw5VbbmOd0II6A6xvQg2L3h/4CagAWDx0NKO4+XCxVm6Q2tYHHy6GXjfBTkCgYEA2x+2PAq8iqX80cLqvh7vSoCh5m6H3aSGM8h+ZgF0lkijavQyIXE0oJxuJUpqgzv/XKqUCVQbaEHuNqKczLr0+QEE+vmexaRqKiUAL4/5xLEjfKk96QE7WbjXypJVBT5KeFPc5JDkNZN/R6d8q2/o4hiNdCyg+S4l/YOOev6YWDY=', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj4e+D+2LfhldbNImCtjGbsxNQiQe6zp0SwS0iywib4pEqwS0gVDUi11uaG4R78cm7kV0GwWuYbeyl3wLmsr9269HJ/FjwWrNJLLwCLqJzNSkBssW7TXge++X3uHK93VeYmu7lRxdk5G/CqOdp5IhqveQOLxHURm+AC9iLtdtxnaCXFxcb54O63mfuZ5/9XJfBRt0boTe8vWTnr8w95PG5XlCBK0lmfZvtUazn/RYBIeCV28bwusQURvAg0Kc/gBoa3wIWiZhzaAiklUaXWoqR+yuoBwzKht8TLkXaOVxswphSoxsddrsn28Fw6rDfRiMKk3S6JcwY58P1n2By+LUPQIDAQAB', NULL, NULL, 'http://localhost:48081/app-api/order/payBackli_h5.json', 'http://localhost:8080/#/pages/take-foods/take-foods', 'RSA2', ' 2088821836348568', NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2024-06-01 16:16:45', b'0');
INSERT INTO `merchant_details` VALUES ('wx_h5', 'wxPay', 'wxc061dee8806ff712', '1493624002', 'STR', 'dayouqiantuhupeng8638004yixiangt', NULL, NULL, NULL, 'https://apidc.yixiang.co/app-api/order/payBackwx_h5.json', 'https://dc.yixiang.co/h5/#/pages/mine/mine', 'MD5', NULL, NULL, NULL, 'utf-8', 0, '1', '1', '2023-09-18 17:56:33', '2024-06-01 16:16:39', b'0');
INSERT INTO `merchant_details` VALUES ('wx_miniapp', 'wxPay', 'wx001e2dc50bf532df', '1493624002', 'PATH', 'dayouqiantuhupeng8638004yixiangt', NULL, '/Users/hupeng/cert/1493624002_20231121_cert/apiclient_cert.p12', '1493624002', 'http://yx.l2.ttut.cc/app-api/order/notify/payBackwx_miniapp.json', '', 'MD5', NULL, NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2024-06-01 16:16:25', b'0');
INSERT INTO `merchant_details` VALUES ('wx_wechat', 'wxPay', 'wxc061dee8806ff712', '1493624002', 'STR', 'dayouqiantuhupeng8638004yixiangt', NULL, NULL, NULL, 'https://apidc.yixiang.co/app-api/order/payBackwx_wechat.json', 'https://dc.yixiang.co/h5/#/pages/take-foods/take-foods', 'MD5', NULL, NULL, NULL, 'utf-8', 0, '1', '1', '2023-09-18 17:56:33', '2024-06-01 16:16:32', b'0');
COMMIT;

-- ----------------------------
-- Table structure for mp_account
-- ----------------------------
DROP TABLE IF EXISTS `mp_account`;
CREATE TABLE `mp_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号名称',
  `account` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号账号',
  `app_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号appid',
  `app_secret` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号密钥',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号url',
  `token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公众号token',
  `aes_key` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '加密密钥',
  `qr_code_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '二维码图片URL',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号账号表';

-- ----------------------------
-- Records of mp_account
-- ----------------------------
BEGIN;
INSERT INTO `mp_account` VALUES (2, '1', '2', '3', '4', NULL, '5', NULL, NULL, NULL, '1', '2023-01-07 17:30:30', '1', '2023-01-07 10:05:49', b'1', 1);
INSERT INTO `mp_account` VALUES (3, '1', '2', '3', '4', NULL, '5', NULL, NULL, NULL, '1', '2023-01-08 00:34:35', '1', '2023-01-14 01:15:56', b'1', 1);
INSERT INTO `mp_account` VALUES (5, 'yshop_pro', ' gh_370eafba1888 ', 'wxdbdbc123c8c30b45', '3312eb2026a006bd0cc39af3021ef9c5', NULL, 'yshop_pro', '', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQFv8TwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyWVFZbzlITmRha1UxMDAwMGcwNzkAAgTeHZ1kAwQAAAAA', '', '1', '2023-06-29 13:58:21', '1', '2024-06-01 14:26:58', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for mp_auto_reply
-- ----------------------------
DROP TABLE IF EXISTS `mp_auto_reply`;
CREATE TABLE `mp_auto_reply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NOT NULL COMMENT '公众号账号的编号',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公众号 appId',
  `type` tinyint NOT NULL COMMENT '回复类型',
  `request_keyword` varchar(255) DEFAULT NULL COMMENT '请求的关键字',
  `request_match` tinyint DEFAULT NULL COMMENT '请求的关键字的匹配',
  `request_message_type` varchar(32) DEFAULT NULL COMMENT '请求的消息类型',
  `response_message_type` varchar(32) NOT NULL COMMENT '回复的消息类型',
  `response_content` varchar(1024) DEFAULT NULL COMMENT '回复的消息内容',
  `response_media_id` varchar(128) DEFAULT NULL COMMENT '回复的媒体文件 id',
  `response_media_url` varchar(1024) DEFAULT NULL COMMENT '回复的媒体文件 URL',
  `response_title` varchar(128) DEFAULT NULL COMMENT '回复的标题',
  `response_description` varchar(256) DEFAULT NULL COMMENT '回复的描述',
  `response_thumb_media_id` varchar(128) DEFAULT NULL COMMENT '回复的缩略图的媒体 id',
  `response_thumb_media_url` varchar(1024) DEFAULT NULL COMMENT '回复的缩略图的媒体 URL',
  `response_articles` varchar(1024) DEFAULT NULL COMMENT '回复的图文消息数组',
  `response_music_url` varchar(1024) DEFAULT NULL COMMENT '回复的音乐链接',
  `response_hq_music_url` varchar(1024) DEFAULT NULL COMMENT '回复的高质量音乐链接',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3 COMMENT='公众号消息自动回复表';

-- ----------------------------
-- Records of mp_auto_reply
-- ----------------------------
BEGIN;
INSERT INTO `mp_auto_reply` VALUES (44, 1, 'wx5b23ba7a5589ecbb', 3, '你猜', 1, 'text', 'voice', '', 't1E3ss-niBf29tpzShjljxwaiBoXV_61ln2hzZGDlvAcT3hqLbC9dvl39YwiBWg9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '2023-01-04 04:40:55', '', '2023-01-16 16:55:48', b'1', 1);
INSERT INTO `mp_auto_reply` VALUES (53, 5, 'wxdbdbc123c8c30b45', 3, 'yshop', 1, NULL, 'text', 'haha', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:25:06', '1', '2023-06-29 16:25:06', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for mp_material
-- ----------------------------
DROP TABLE IF EXISTS `mp_material`;
CREATE TABLE `mp_material` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NOT NULL COMMENT '公众号账号的编号',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公众号 appId',
  `media_id` varchar(128) NOT NULL COMMENT '公众号素材 id',
  `type` varchar(32) NOT NULL COMMENT '文件类型',
  `permanent` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否永久',
  `url` varchar(1024) DEFAULT NULL COMMENT '文件服务器的 URL',
  `name` varchar(255) DEFAULT NULL COMMENT '名字',
  `mp_url` varchar(1024) DEFAULT NULL COMMENT '公众号文件 URL',
  `title` varchar(255) DEFAULT NULL COMMENT '视频素材的标题',
  `introduction` varchar(255) DEFAULT NULL COMMENT '视频素材的描述',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb3 COMMENT='公众号素材表';

-- ----------------------------
-- Records of mp_material
-- ----------------------------
BEGIN;
INSERT INTO `mp_material` VALUES (80, 1, 'wx5b23ba7a5589ecbb', 'r6ryvl6LrxBU0miaST4Y-tlQmcl3RdC-Jcgns6IQtf7zenGy3b86WLT7GzUcrb1T', 'image', b'1', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-tlQmcl3RdC-Jcgns6IQtf7zenGy3b86WLT7GzUcrb1T.png', 'file', 'http://mmbiz.qpic.cn/mmbiz_png/btUmCVHwbJUoicwBiacjVeQbu6QxgBVrukfSJXz509boa21SpH8OVHAqXCJiaiaAaHQJNxwwsa0gHRXVr0G5EZYamw/0?wx_fmt=png', '', '', '1', '2023-01-14 00:56:06', '1', '2023-01-14 07:45:41', b'1', 1);
INSERT INTO `mp_material` VALUES (81, 1, 'wx5b23ba7a5589ecbb', 'r6ryvl6LrxBU0miaST4Y-pWqXoCgpdNp1fvSv7c6zoTnCsW6BGAVFNJ-E9hkAIXO', 'image', b'1', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pWqXoCgpdNp1fvSv7c6zoTnCsW6BGAVFNJ-E9hkAIXO.jpg', 'file', 'http://mmbiz.qpic.cn/mmbiz_jpg/btUmCVHwbJUoicwBiacjVeQbu6QxgBVrukzCJPJRkia5cQviaDTbLMc614uobiblN4Au4UApLYOShXNDNjdndjPVswg/0?wx_fmt=jpeg', '', '', '1', '2023-01-14 01:30:49', '1', '2023-01-14 07:31:02', b'1', 1);
INSERT INTO `mp_material` VALUES (82, 1, 'wx5b23ba7a5589ecbb', 'r6ryvl6LrxBU0miaST4Y-vNzhGc_1b37nxAvj0Zt8iuGACe-mC9_a5OhVFIzt0DX', 'image', b'1', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-vNzhGc_1b37nxAvj0Zt8iuGACe-mC9_a5OhVFIzt0DX.png', 'file', 'http://mmbiz.qpic.cn/mmbiz_png/btUmCVHwbJVkZaoiatUmOpaGalzHIVxhUNOGPaZfZUSfKzpS8bPShaicSyErHn2mEzthXochM7GE3tIDAt5FNrUg/0?wx_fmt=png', NULL, NULL, '1', '2023-01-14 08:20:53', '1', '2023-01-14 07:30:59', b'1', 1);
INSERT INTO `mp_material` VALUES (88, 4, 'wx01b971b269525c69', 'rdp2FpJLZJb_Z771EZCE0sdggkEkJ9BXy1wIiory8puv2L0sRYeBBVztrxmjjT_P', 'voice', b'1', 'http://test.yshop.iocoder.cn/rdp2FpJLZJb_Z771EZCE0sdggkEkJ9BXy1wIiory8puv2L0sRYeBBVztrxmjjT_P.amr', 'file', NULL, '', '', '1', '2023-01-14 16:28:53', '1', '2023-01-14 08:29:36', b'1', 1);
INSERT INTO `mp_material` VALUES (89, 4, 'wx01b971b269525c69', 'rdp2FpJLZJb_Z771EZCE0jlwnElym7bDUZUQI6t36O9xlh-wQWZpdDEVNHj_-Zo3', 'video', b'1', 'http://test.yshop.iocoder.cn/rdp2FpJLZJb_Z771EZCE0jlwnElym7bDUZUQI6t36O9xlh-wQWZpdDEVNHj_-Zo3.mp4', 'file', NULL, '1', '2', '1', '2023-01-14 16:53:53', '1', '2023-01-14 08:54:45', b'1', 1);
INSERT INTO `mp_material` VALUES (90, 4, 'wx01b971b269525c69', 'rdp2FpJLZJb_Z771EZCE0nKJFlsOPjLkDApXEgRjaGydiFVTsC0zMq8-x5V6-rG4', 'video', b'1', 'http://test.yshop.iocoder.cn/rdp2FpJLZJb_Z771EZCE0nKJFlsOPjLkDApXEgRjaGydiFVTsC0zMq8-x5V6-rG4.mp4', 'file', NULL, '12', '34', '1', '2023-01-14 16:55:02', '1', '2023-01-14 08:55:06', b'1', 1);
COMMIT;

-- ----------------------------
-- Table structure for mp_menu
-- ----------------------------
DROP TABLE IF EXISTS `mp_menu`;
CREATE TABLE `mp_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NOT NULL COMMENT '微信公众号ID',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信公众号 appid',
  `name` varchar(255) DEFAULT NULL COMMENT '菜单名称',
  `menu_key` varchar(255) DEFAULT NULL COMMENT '菜单标识',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父ID',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '按钮类型',
  `url` varchar(500) DEFAULT NULL COMMENT '网页链接',
  `mini_program_app_id` varchar(32) DEFAULT NULL COMMENT '小程序appid',
  `mini_program_page_path` varchar(200) DEFAULT NULL COMMENT '小程序页面路径',
  `article_id` varchar(200) DEFAULT NULL COMMENT '跳转图文的媒体编号',
  `reply_message_type` varchar(32) DEFAULT NULL COMMENT '消息类型',
  `reply_content` varchar(1024) DEFAULT NULL COMMENT '回复的消息内容',
  `reply_media_id` varchar(128) DEFAULT NULL COMMENT '回复的媒体文件 id',
  `reply_media_url` varchar(1024) DEFAULT NULL COMMENT '回复的媒体文件 URL',
  `reply_title` varchar(128) DEFAULT NULL COMMENT '回复的标题',
  `reply_description` varchar(256) DEFAULT NULL COMMENT '回复的描述',
  `reply_thumb_media_id` varchar(128) DEFAULT NULL COMMENT '回复的缩略图的媒体 id',
  `reply_thumb_media_url` varchar(1024) DEFAULT NULL COMMENT '回复的缩略图的媒体 URL',
  `reply_articles` varchar(1024) DEFAULT NULL COMMENT '回复的图文消息数组',
  `reply_music_url` varchar(1024) DEFAULT NULL COMMENT '回复的音乐链接',
  `reply_hq_music_url` varchar(1024) DEFAULT NULL COMMENT '回复的高质量音乐链接',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT='公众号菜单表';

-- ----------------------------
-- Records of mp_menu
-- ----------------------------
BEGIN;
INSERT INTO `mp_menu` VALUES (1, 1, 'wx5b23ba7a5589ecbb', '今日歌曲', 'V1001_TODAY_MUSIC', '0', 'click', NULL, NULL, NULL, NULL, 'text', '幸会幸会', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '2023-01-07 02:51:58', '', '2023-01-14 15:44:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (2, 1, 'wx5b23ba7a5589ecbb', '搜索', '', '0', 'view', 'http://www.soso.com/', NULL, NULL, NULL, 'text', '幸会幸会', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '2023-01-07 02:51:58', '', '2023-01-14 13:22:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (3, 1, 'wx5b23ba7a5589ecbb', '父按钮', '', '0', '', '', NULL, NULL, NULL, 'text', '幸会幸会', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '2023-01-07 02:51:58', '', '2023-01-14 15:44:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (4, 1, 'wx5b23ba7a5589ecbb', '归去来兮', 'MUSIC', '3', 'click', NULL, NULL, NULL, NULL, 'text', '幸会幸会', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '2023-01-07 02:51:58', '', '2023-01-14 15:44:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (5, 1, 'wx5b23ba7a5589ecbb', '不说', '', '3', 'view', 'http://www.soso.com/', NULL, NULL, NULL, 'text', '幸会幸会', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '2023-01-07 02:51:58', '', '2023-01-14 15:44:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (26, 1, 'wx5b23ba7a5589ecbb', '今日歌曲', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-14 23:44:50', '1', '2023-01-14 16:35:05', b'1', 1);
INSERT INTO `mp_menu` VALUES (27, 1, 'wx5b23ba7a5589ecbb', '搜索', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-14 23:44:50', '1', '2023-01-14 16:35:05', b'1', 1);
INSERT INTO `mp_menu` VALUES (28, 1, 'wx5b23ba7a5589ecbb', '父按钮', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-14 23:44:50', '1', '2023-01-14 16:35:05', b'1', 1);
INSERT INTO `mp_menu` VALUES (29, 1, 'wx5b23ba7a5589ecbb', '归去来兮', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-14 23:44:50', '1', '2023-01-14 16:35:05', b'1', 1);
INSERT INTO `mp_menu` VALUES (30, 1, 'wx5b23ba7a5589ecbb', '不说', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-14 23:44:50', '1', '2023-01-14 16:35:05', b'1', 1);
INSERT INTO `mp_menu` VALUES (31, 1, 'wx5b23ba7a5589ecbb', '123', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:35:05', '1', '2023-01-14 16:35:43', b'1', 1);
INSERT INTO `mp_menu` VALUES (32, 1, 'wx5b23ba7a5589ecbb', '123', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:35:43', '1', '2023-01-14 16:39:10', b'1', 1);
INSERT INTO `mp_menu` VALUES (33, 1, 'wx5b23ba7a5589ecbb', '嘿嘿', NULL, '0', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:39:10', '1', '2023-01-14 16:40:09', b'1', 1);
INSERT INTO `mp_menu` VALUES (38, 1, 'wx5b23ba7a5589ecbb', '顶级1', NULL, '0', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:42:54', '1', '2023-01-14 16:51:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (39, 1, 'wx5b23ba7a5589ecbb', '明星', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:42:54', '1', '2023-01-14 16:51:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (40, 1, 'wx5b23ba7a5589ecbb', '喊个', NULL, '39', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:42:54', '1', '2023-01-14 16:51:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (41, 1, 'wx5b23ba7a5589ecbb', 'haha', NULL, '39', 'view', 'http://soso.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:42:54', '1', '2023-01-14 16:51:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (42, 1, 'wx5b23ba7a5589ecbb', '顶级1', NULL, '0', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:51:35', '1', '2023-01-14 16:51:53', b'1', 1);
INSERT INTO `mp_menu` VALUES (43, 1, 'wx5b23ba7a5589ecbb', '明星', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:51:35', '1', '2023-01-14 16:51:53', b'1', 1);
INSERT INTO `mp_menu` VALUES (44, 1, 'wx5b23ba7a5589ecbb', '喊个', NULL, '43', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:51:35', '1', '2023-01-14 16:51:53', b'1', 1);
INSERT INTO `mp_menu` VALUES (45, 1, 'wx5b23ba7a5589ecbb', 'haha', NULL, '43', 'view', 'http://soso.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 00:51:35', '1', '2023-01-14 16:51:53', b'1', 1);
INSERT INTO `mp_menu` VALUES (46, 1, 'wx5b23ba7a5589ecbb', '测试菜单', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 11:32:17', '1', '2023-01-15 04:39:11', b'1', 1);
INSERT INTO `mp_menu` VALUES (47, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '46', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 11:32:17', '1', '2023-01-15 04:39:11', b'1', 1);
INSERT INTO `mp_menu` VALUES (48, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '1', '2023-01-15 12:39:12', '1', '2023-01-15 09:19:01', b'1', 1);
INSERT INTO `mp_menu` VALUES (49, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:19:02', '1', '2023-01-15 09:26:50', b'1', 1);
INSERT INTO `mp_menu` VALUES (50, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:26:51', '1', '2023-01-15 09:27:39', b'1', 1);
INSERT INTO `mp_menu` VALUES (51, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT', 'http://test.yshop.iocoder.cn/XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT.mp4', '奥特曼', '奥特快', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:27:40', '1', '2023-01-15 09:28:20', b'1', 1);
INSERT INTO `mp_menu` VALUES (52, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT', 'http://test.yshop.iocoder.cn/XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT.mp4', NULL, '奥特快', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:28:21', '1', '2023-01-15 09:29:21', b'1', 1);
INSERT INTO `mp_menu` VALUES (53, 1, 'wx5b23ba7a5589ecbb', '点击回复', '123', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT', 'http://test.yshop.iocoder.cn/XQockIDz-7p8wHuI0wxzd2dZvhKWrQnxM5pPXvaW8Qsid2hLjVxk90wM47ZsYERT.mp4', NULL, '奥特快', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:29:22', '1', '2023-01-15 09:32:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (54, 1, 'wx5b23ba7a5589ecbb', '回复图片', '01', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:29:22', '1', '2023-01-15 09:32:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (55, 1, 'wx5b23ba7a5589ecbb', '回复图片', 'image', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8.jpg', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:33:06', '1', '2023-01-15 09:33:45', b'1', 1);
INSERT INTO `mp_menu` VALUES (56, 1, 'wx5b23ba7a5589ecbb', '回复图片', 'image', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8.jpg', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:33:45', '1', '2023-01-15 09:33:55', b'1', 1);
INSERT INTO `mp_menu` VALUES (57, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:33:45', '1', '2023-01-15 09:33:55', b'1', 1);
INSERT INTO `mp_menu` VALUES (58, 1, 'wx5b23ba7a5589ecbb', '回复图片', 'image', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8.jpg', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:33:56', '1', '2023-01-15 09:34:02', b'1', 1);
INSERT INTO `mp_menu` VALUES (59, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:33:56', '1', '2023-01-15 09:34:02', b'1', 1);
INSERT INTO `mp_menu` VALUES (60, 1, 'wx5b23ba7a5589ecbb', '回复图片', 'image', '0', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-jVixJGgnBnkBPRbuVptOW0CHYuQFyiOVNtamctS8xU8.jpg', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:34:02', '1', '2023-01-15 09:34:44', b'1', 1);
INSERT INTO `mp_menu` VALUES (61, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:34:02', '1', '2023-01-15 09:34:44', b'1', 1);
INSERT INTO `mp_menu` VALUES (62, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:34:45', '1', '2023-01-15 09:36:27', b'1', 1);
INSERT INTO `mp_menu` VALUES (63, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:36:28', '1', '2023-01-15 09:37:20', b'1', 1);
INSERT INTO `mp_menu` VALUES (64, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:37:21', '1', '2023-01-15 09:40:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (65, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:40:14', '1', '2023-01-15 09:40:24', b'1', 1);
INSERT INTO `mp_menu` VALUES (66, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:40:24', '1', '2023-01-15 09:41:12', b'1', 1);
INSERT INTO `mp_menu` VALUES (67, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', '', '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:41:13', '1', '2023-01-15 09:43:32', b'1', 1);
INSERT INTO `mp_menu` VALUES (68, 1, 'wx5b23ba7a5589ecbb', '回复视频', '123', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:41:13', '1', '2023-01-15 09:43:32', b'1', 1);
INSERT INTO `mp_menu` VALUES (69, 1, 'wx5b23ba7a5589ecbb', '回复语音', 'aoteman', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_Gz-Yg8hVk5OgQ6iWZU_KSOEhpQ31JmkGh0JYPKgi9ebKPthnsckQbQVWfiN58VLrfg.mp3', NULL, '', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:43:33', '1', '2023-01-15 10:06:28', b'1', 1);
INSERT INTO `mp_menu` VALUES (70, 1, 'wx5b23ba7a5589ecbb', '回复视频', '123', '0', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', NULL, '我真的是视频', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:43:33', '1', '2023-01-15 10:06:28', b'1', 1);
INSERT INTO `mp_menu` VALUES (71, 1, 'wx5b23ba7a5589ecbb', '回复音乐', 'ao11', '0', 'click', NULL, NULL, NULL, NULL, 'music', '', NULL, NULL, '1', '2', NULL, NULL, NULL, '', '', '1', '2023-01-15 17:43:33', '1', '2023-01-15 10:06:28', b'1', 1);
INSERT INTO `mp_menu` VALUES (72, 1, 'wx5b23ba7a5589ecbb', '回复音乐', '01', '0', 'click', NULL, NULL, NULL, NULL, 'music', '', NULL, NULL, '1', '2', 'wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl', 'http://test.yshop.iocoder.cn/wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl.png', NULL, 'https://www.iocoder.cn/1.mp3', 'https://www.iocoder.cn/2.mp3', '1', '2023-01-15 18:16:12', '1', '2023-01-15 10:21:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (73, 1, 'wx5b23ba7a5589ecbb', '回复音乐', '01', '0', 'click', NULL, NULL, NULL, NULL, 'music', '', NULL, NULL, '1', '2', 'wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl', 'http://test.yshop.iocoder.cn/wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl.png', NULL, 'https://www.iocoder.cn/1.mp3', 'https://www.iocoder.cn/2.mp3', '1', '2023-01-15 18:21:14', '1', '2023-01-15 10:21:36', b'1', 1);
INSERT INTO `mp_menu` VALUES (74, 1, 'wx5b23ba7a5589ecbb', '回复音乐', '01', '0', 'click', NULL, NULL, NULL, NULL, 'music', '', NULL, NULL, '1', '2', 'wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl', 'http://test.yshop.iocoder.cn/wBnOlFbeYaWXb7AVX5Ha_Uy373JHA2EoS0FUziAhkwP0r6Hv43PeQHXKY4GADfbl.png', NULL, 'https://www.iocoder.cn/1.mp3', 'https://www.iocoder.cn/2.mp3', '1', '2023-01-15 18:21:36', '1', '2023-01-15 10:21:59', b'1', 1);
INSERT INTO `mp_menu` VALUES (75, 1, 'wx5b23ba7a5589ecbb', '回复图文', 'music', '0', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 18:23:23', '1', '2023-01-15 10:23:53', b'1', 1);
INSERT INTO `mp_menu` VALUES (76, 1, 'wx5b23ba7a5589ecbb', '回复图文', 'music', '0', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 18:23:54', '1', '2023-01-15 11:13:21', b'1', 1);
INSERT INTO `mp_menu` VALUES (77, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:21', '1', '2023-01-15 11:13:36', b'1', 1);
INSERT INTO `mp_menu` VALUES (78, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '77', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:21', '1', '2023-01-15 11:13:36', b'1', 1);
INSERT INTO `mp_menu` VALUES (79, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:36', '1', '2023-01-15 11:13:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (80, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '79', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:36', '1', '2023-01-15 11:13:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (81, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '79', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:36', '1', '2023-01-15 11:13:49', b'1', 1);
INSERT INTO `mp_menu` VALUES (82, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:49', '1', '2023-01-15 11:14:06', b'1', 1);
INSERT INTO `mp_menu` VALUES (83, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '82', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:49', '1', '2023-01-15 11:14:06', b'1', 1);
INSERT INTO `mp_menu` VALUES (84, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '82', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:49', '1', '2023-01-15 11:14:06', b'1', 1);
INSERT INTO `mp_menu` VALUES (85, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '82', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:13:49', '1', '2023-01-15 11:14:06', b'1', 1);
INSERT INTO `mp_menu` VALUES (86, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:07', '1', '2023-01-15 11:14:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (87, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '86', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:07', '1', '2023-01-15 11:14:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (88, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '86', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:07', '1', '2023-01-15 11:14:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (89, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '86', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:07', '1', '2023-01-15 11:14:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (90, 1, 'wx5b23ba7a5589ecbb', '子菜单名称', 'o', '86', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:07', '1', '2023-01-15 11:14:35', b'1', 1);
INSERT INTO `mp_menu` VALUES (91, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (92, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '91', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (93, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '91', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (94, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '91', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (95, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '91', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (96, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '91', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:14:35', '1', '2023-01-15 11:18:13', b'1', 1);
INSERT INTO `mp_menu` VALUES (97, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (98, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '97', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (99, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '97', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (100, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '97', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (101, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '97', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (102, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '97', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (103, 1, 'wx5b23ba7a5589ecbb', '测试', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (104, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '103', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:18:14', '1', '2023-01-15 11:26:07', b'1', 1);
INSERT INTO `mp_menu` VALUES (105, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (106, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '105', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (107, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '105', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (108, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '105', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (109, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '105', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (110, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '105', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (111, 1, 'wx5b23ba7a5589ecbb', '测试', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (112, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '111', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (113, 1, 'wx5b23ba7a5589ecbb', '扫码回复', 'test_02', '111', 'scancode_waitmsg', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:26:08', '1', '2023-01-15 11:33:57', b'1', 1);
INSERT INTO `mp_menu` VALUES (114, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (115, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '114', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (116, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '114', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (117, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '114', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (118, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '114', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (119, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '114', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (120, 1, 'wx5b23ba7a5589ecbb', '测试', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (121, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '120', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (122, 1, 'wx5b23ba7a5589ecbb', '扫码回复', 'test_02', '120', 'scancode_waitmsg', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (123, 1, 'wx5b23ba7a5589ecbb', '扫码直接回结果', '2344455', '120', 'scancode_push', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:33:58', '1', '2023-01-15 11:44:54', b'1', 1);
INSERT INTO `mp_menu` VALUES (124, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (125, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '124', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (126, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '124', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (127, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '124', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (128, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '124', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (129, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '124', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (130, 1, 'wx5b23ba7a5589ecbb', '测试', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (131, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '130', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (132, 1, 'wx5b23ba7a5589ecbb', '扫码回复', 'test_02', '130', 'scancode_waitmsg', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (133, 1, 'wx5b23ba7a5589ecbb', '扫码直接回结果', '2344455', '130', 'scancode_push', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (134, 1, 'wx5b23ba7a5589ecbb', '系统拍照', '0x0', '130', 'pic_sysphoto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (135, 1, 'wx5b23ba7a5589ecbb', '拍照或相册', '0x3', '130', 'pic_photo_or_album', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (136, 1, 'wx5b23ba7a5589ecbb', '测试2', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (137, 1, 'wx5b23ba7a5589ecbb', '微信相册', 'ppp2222', '136', 'pic_weixin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:44:55', '1', '2023-01-15 11:52:04', b'1', 1);
INSERT INTO `mp_menu` VALUES (138, 1, 'wx5b23ba7a5589ecbb', '回复图文', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (139, 1, 'wx5b23ba7a5589ecbb', '文本', 't1', '138', 'click', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (140, 1, 'wx5b23ba7a5589ecbb', '图片', 'pic', '138', 'click', NULL, NULL, NULL, NULL, 'image', '', 'r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pgFtUNLu1foMSAMkoOsrQrTZ8EtTMssBLfTtzP0dfjG.png', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (141, 1, 'wx5b23ba7a5589ecbb', '语音', 'v3', '138', 'click', NULL, NULL, NULL, NULL, 'voice', '', 'a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA', 'http://test.yshop.iocoder.cn/a6kOoewXIbX57gB0kCb_G0h41eeCLWXi-DiMGrPG1iQwjuxGoAoDZCqt6J7IrUrjYwTfa9dGyTJ7qbQ-8TlNrA.mp3', '', '', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (142, 1, 'wx5b23ba7a5589ecbb', '视频', 'o', '138', 'click', NULL, NULL, NULL, NULL, 'video', '', 'r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU', 'http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-v2-X9sD87sdZ8qoWWgu9QgP2NEjlTvDJ47KfF2xhyiU.mp4', '我是视频', '我真的是视频', NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (143, 1, 'wx5b23ba7a5589ecbb', '图文', 'wx', '138', 'click', NULL, NULL, NULL, NULL, 'news', '', NULL, NULL, '', '', NULL, NULL, '[{\"title\":\"我是标题\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=1&sn=dadf5d7e9aa594b58666fb2013fdf215&chksm=9f6354aea814ddb8fde13b17a34acbe86987b5c3403c6bd47e1e94977f6988b62653f6ab55e6#rd\"},{\"title\":\"我是标题 2\",\"description\":null,\"picUrl\":\"http://test.yshop.iocoder.cn/r6ryvl6LrxBU0miaST4Y-pIcmK-zAAId-9TGgy-DrSLhjVuWbuT3ZBjk9K1yQ0Dn.png\",\"url\":\"http://mp.weixin.qq.com/s?__biz=MzA3NjM4MzQzOQ==&mid=2247483662&idx=2&sn=c8041e2fc639c07d73bbbb6f80cf1784&chksm=9f6354aea814ddb8f48d7b330252c0374878014feb45a8fd4c22aaa0483c062f20ba15463368#rd\"}]', NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (144, 1, 'wx5b23ba7a5589ecbb', '测试', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (145, 1, 'wx5b23ba7a5589ecbb', '跳转网页', NULL, '144', 'view', 'https://www.iocoder.cn', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (146, 1, 'wx5b23ba7a5589ecbb', '扫码回复', 'test_02', '144', 'scancode_waitmsg', NULL, NULL, NULL, NULL, 'text', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (147, 1, 'wx5b23ba7a5589ecbb', '扫码直接回结果', '2344455', '144', 'scancode_push', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (148, 1, 'wx5b23ba7a5589ecbb', '系统拍照', '0x0', '144', 'pic_sysphoto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (149, 1, 'wx5b23ba7a5589ecbb', '拍照或相册', '0x3', '144', 'pic_photo_or_album', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (150, 1, 'wx5b23ba7a5589ecbb', '测试2', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (151, 1, 'wx5b23ba7a5589ecbb', '微信相册', 'ppp2222', '150', 'pic_weixin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (152, 1, 'wx5b23ba7a5589ecbb', '选择地理位置', 'lll2', '150', 'location_select', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-01-15 19:52:04', '1', '2023-01-15 13:20:22', b'1', 1);
INSERT INTO `mp_menu` VALUES (169, 5, 'wxdbdbc123c8c30b45', '单商户', NULL, '0', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:24:37', '1', '2023-06-29 16:24:37', b'0', 0);
INSERT INTO `mp_menu` VALUES (170, 5, 'wxdbdbc123c8c30b45', '小程序', 'miniapp', '169', 'view', 'https://www.yixiang.co', NULL, NULL, NULL, 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:24:37', '1', '2023-06-29 16:24:37', b'0', 0);
INSERT INTO `mp_menu` VALUES (171, 5, 'wxdbdbc123c8c30b45', '多商户', 'two', '0', 'view', 'https://www.yixiang.co', NULL, NULL, NULL, 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:24:37', '1', '2023-06-29 16:24:37', b'0', 0);
INSERT INTO `mp_menu` VALUES (172, 5, 'wxdbdbc123c8c30b45', '官网', 'gw', '0', 'view', 'https://www.yixiang.co', NULL, NULL, NULL, 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:24:37', '1', '2023-06-29 16:24:37', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for mp_message
-- ----------------------------
DROP TABLE IF EXISTS `mp_message`;
CREATE TABLE `mp_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msg_id` bigint DEFAULT NULL COMMENT '微信公众号的消息编号',
  `account_id` bigint NOT NULL COMMENT '公众号账号的编号',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公众号 appId',
  `user_id` bigint NOT NULL COMMENT '公众号粉丝的编号',
  `openid` varchar(100) NOT NULL COMMENT '公众号粉丝标志',
  `type` varchar(32) NOT NULL COMMENT '消息类型',
  `send_from` tinyint NOT NULL COMMENT '消息来源',
  `content` varchar(1024) DEFAULT NULL COMMENT '消息内容',
  `media_id` varchar(128) DEFAULT NULL COMMENT '媒体文件 id',
  `media_url` varchar(1024) DEFAULT NULL COMMENT '媒体文件 URL',
  `recognition` varchar(1024) DEFAULT NULL COMMENT '语音识别后文本',
  `format` varchar(16) DEFAULT NULL COMMENT '语音格式',
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `description` varchar(256) DEFAULT NULL COMMENT '描述',
  `thumb_media_id` varchar(128) DEFAULT NULL COMMENT '缩略图的媒体 id',
  `thumb_media_url` varchar(1024) DEFAULT NULL COMMENT '缩略图的媒体 URL',
  `url` varchar(500) DEFAULT NULL COMMENT '点击图文消息跳转链接',
  `location_x` double DEFAULT NULL COMMENT '地理位置维度',
  `location_y` double DEFAULT NULL COMMENT '地理位置经度',
  `scale` double DEFAULT NULL COMMENT '地图缩放大小',
  `label` varchar(128) DEFAULT NULL COMMENT '详细地址',
  `articles` varchar(1024) DEFAULT NULL COMMENT '图文消息数组',
  `music_url` varchar(1024) DEFAULT NULL COMMENT '音乐链接',
  `hq_music_url` varchar(1024) DEFAULT NULL COMMENT '高质量音乐链接',
  `event` varchar(64) DEFAULT NULL COMMENT '事件类型',
  `event_key` varchar(64) DEFAULT NULL COMMENT '事件 Key',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=417 DEFAULT CHARSET=utf8mb3 COMMENT='公众号消息表 ';

-- ----------------------------
-- Records of mp_message
-- ----------------------------
BEGIN;
INSERT INTO `mp_message` VALUES (407, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 2, '感谢关注', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 14:01:01', NULL, '2023-06-29 14:01:01', b'0', 0);
INSERT INTO `mp_message` VALUES (408, 24166734583332250, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 1, '1111', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:21:08', NULL, '2023-06-29 16:21:08', b'0', 0);
INSERT INTO `mp_message` VALUES (409, 24166740720537081, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 1, 'yshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:25:19', NULL, '2023-06-29 16:25:19', b'0', 0);
INSERT INTO `mp_message` VALUES (410, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 2, 'haha', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:25:19', NULL, '2023-06-29 16:25:19', b'0', 0);
INSERT INTO `mp_message` VALUES (411, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'event', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'unsubscribe', '', NULL, '2023-06-29 16:25:53', NULL, '2023-06-29 16:25:53', b'0', 0);
INSERT INTO `mp_message` VALUES (412, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'event', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'subscribe', '', NULL, '2023-06-29 16:26:01', NULL, '2023-06-29 16:26:01', b'0', 0);
INSERT INTO `mp_message` VALUES (413, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 2, '感谢关注', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:26:01', NULL, '2023-06-29 16:26:01', b'0', 0);
INSERT INTO `mp_message` VALUES (414, 24166739116227564, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 1, 'yshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:26:11', NULL, '2023-06-29 16:26:11', b'0', 0);
INSERT INTO `mp_message` VALUES (415, NULL, 5, 'wxdbdbc123c8c30b45', 6, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 2, 'haha', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-06-29 16:26:11', NULL, '2023-06-29 16:26:11', b'0', 0);
INSERT INTO `mp_message` VALUES (416, NULL, 5, 'wxdbdbc123c8c30b45', 7, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 'text', 2, '感谢关注', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-07-24 17:19:40', NULL, '2023-07-24 17:19:40', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for mp_tag
-- ----------------------------
DROP TABLE IF EXISTS `mp_tag`;
CREATE TABLE `mp_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_id` bigint DEFAULT NULL COMMENT '公众号标签 id',
  `name` varchar(32) DEFAULT NULL COMMENT '标签名称',
  `count` int DEFAULT '0' COMMENT '粉丝数量',
  `account_id` bigint NOT NULL COMMENT '公众号账号的编号',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公众号 appId',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COMMENT='公众号标签表';

-- ----------------------------
-- Records of mp_tag
-- ----------------------------
BEGIN;
INSERT INTO `mp_tag` VALUES (3, 100, '测试标签啦', 0, 1, 'wx5b23ba7a5589ecbb', '1', '2023-01-01 20:33:28', '1', '2023-01-08 03:23:53', b'1', 1);
INSERT INTO `mp_tag` VALUES (4, 101, '测试', 0, 1, 'wx5b23ba7a5589ecbb', '1', '2023-01-01 20:33:28', '1', '2023-01-08 03:21:00', b'1', 1);
INSERT INTO `mp_tag` VALUES (7, 102, '搞起来', 0, 1, 'wx5b23ba7a5589ecbb', '1', '2023-01-01 20:33:28', '1', '2023-01-08 04:03:00', b'1', 1);
COMMIT;

-- ----------------------------
-- Table structure for mp_user
-- ----------------------------
DROP TABLE IF EXISTS `mp_user`;
CREATE TABLE `mp_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户标识',
  `subscribe_status` tinyint NOT NULL COMMENT '关注状态',
  `subscribe_time` datetime NOT NULL COMMENT '关注时间',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `head_image_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像地址',
  `unsubscribe_time` datetime DEFAULT NULL COMMENT '取消关注时间',
  `language` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `country` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '国家',
  `province` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '城市',
  `remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `tag_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签编号数组',
  `union_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'unionId',
  `account_id` bigint NOT NULL COMMENT '微信公众号ID',
  `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信公众号 appid',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号粉丝表';

-- ----------------------------
-- Records of mp_user
-- ----------------------------
BEGIN;
INSERT INTO `mp_user` VALUES (7, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 0, '2023-07-24 17:19:37', '', '', NULL, 'zh_CN', NULL, NULL, NULL, '', '', '', 5, 'wxdbdbc123c8c30b45', NULL, '2023-07-24 17:19:40', NULL, '2023-07-24 17:19:40', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`) USING BTREE,
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`) USING BTREE,
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`) USING BTREE,
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`) USING BTREE,
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------
BEGIN;
INSERT INTO `QRTZ_LOCKS` VALUES ('schedulerName', 'STATE_ACCESS');
INSERT INTO `QRTZ_LOCKS` VALUES ('schedulerName', 'TRIGGER_ACCESS');
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------
BEGIN;
INSERT INTO `QRTZ_SCHEDULER_STATE` VALUES ('schedulerName', 'VM-4-9-centos1695033394264', 1695087442542, 15000);
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INT_PROP_1` int DEFAULT NULL,
  `INT_PROP_2` int DEFAULT NULL,
  `LONG_PROP_1` bigint DEFAULT NULL,
  `LONG_PROP_2` bigint DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS` (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint DEFAULT NULL,
  `PREV_FIRE_TIME` bigint DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint DEFAULT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MISFIRE_INSTR` smallint DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`) USING BTREE,
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`) USING BTREE,
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`) USING BTREE,
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`) USING BTREE,
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`) USING BTREE,
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`) USING BTREE,
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`) USING BTREE,
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`) USING BTREE,
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`) USING BTREE,
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_dept
-- ----------------------------
DROP TABLE IF EXISTS `system_dept`;
CREATE TABLE `system_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门名称',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父部门id',
  `sort` int NOT NULL DEFAULT '0' COMMENT '显示顺序',
  `leader_user_id` bigint DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` tinyint NOT NULL COMMENT '部门状态（0正常 1停用）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

-- ----------------------------
-- Records of system_dept
-- ----------------------------
BEGIN;
INSERT INTO `system_dept` VALUES (100, 'yshop公司', 0, 0, 1, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2023-09-05 10:22:19', b'0', 1);
INSERT INTO `system_dept` VALUES (101, '深圳总公司', 100, 1, 104, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-05-16 20:25:23', b'0', 1);
INSERT INTO `system_dept` VALUES (102, '长沙分公司', 100, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:40', b'0', 1);
INSERT INTO `system_dept` VALUES (103, '研发部门', 101, 1, 104, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '103', '2022-01-14 01:04:14', b'0', 1);
INSERT INTO `system_dept` VALUES (104, '市场部门', 101, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:38', b'0', 1);
INSERT INTO `system_dept` VALUES (105, '测试部门', 101, 3, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-05-16 20:25:15', b'0', 1);
INSERT INTO `system_dept` VALUES (106, '财务部门', 101, 4, 103, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '103', '2022-01-15 21:32:22', b'0', 1);
INSERT INTO `system_dept` VALUES (107, '运维部门', 101, 5, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:33', b'0', 1);
INSERT INTO `system_dept` VALUES (108, '市场部门', 102, 1, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-02-16 08:35:45', b'0', 1);
INSERT INTO `system_dept` VALUES (109, '财务部门', 102, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:29', b'0', 1);
INSERT INTO `system_dept` VALUES (110, '新部门', 0, 1, NULL, NULL, NULL, 0, '110', '2022-02-23 20:46:30', '110', '2022-02-23 20:46:30', b'0', 121);
INSERT INTO `system_dept` VALUES (111, '顶级部门', 0, 1, NULL, NULL, NULL, 0, '113', '2022-03-07 21:44:50', '113', '2022-03-07 21:44:50', b'0', 122);
COMMIT;

-- ----------------------------
-- Table structure for system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_data`;
CREATE TABLE `system_dict_data` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `sort` int NOT NULL DEFAULT '0' COMMENT '字典排序',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典标签',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `color_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '颜色类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'css 样式',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';

-- ----------------------------
-- Records of system_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `system_dict_data` VALUES (1, 1, '男', '1', 'system_user_sex', 0, 'default', 'A', '性别男', 'admin', '2021-01-05 17:03:48', '1', '2022-03-29 00:14:39', b'0');
INSERT INTO `system_dict_data` VALUES (2, 2, '女', '2', 'system_user_sex', 1, 'success', '', '性别女', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 01:30:51', b'0');
INSERT INTO `system_dict_data` VALUES (8, 1, '正常', '1', 'infra_job_status', 0, 'success', '', '正常状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:38', b'0');
INSERT INTO `system_dict_data` VALUES (9, 2, '暂停', '2', 'infra_job_status', 0, 'danger', '', '停用状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:45', b'0');
INSERT INTO `system_dict_data` VALUES (12, 1, '系统内置', '1', 'infra_config_type', 0, 'danger', '', '参数类型 - 系统内置', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:02', b'0');
INSERT INTO `system_dict_data` VALUES (13, 2, '自定义', '2', 'infra_config_type', 0, 'primary', '', '参数类型 - 自定义', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:07', b'0');
INSERT INTO `system_dict_data` VALUES (14, 1, '通知', '1', 'system_notice_type', 0, 'success', '', '通知', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:05:57', b'0');
INSERT INTO `system_dict_data` VALUES (15, 2, '公告', '2', 'system_notice_type', 0, 'info', '', '公告', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:06:01', b'0');
INSERT INTO `system_dict_data` VALUES (16, 0, '其它', '0', 'system_operate_type', 0, 'default', '', '其它操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:32:46', b'0');
INSERT INTO `system_dict_data` VALUES (17, 1, '查询', '1', 'system_operate_type', 0, 'info', '', '查询操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:16', b'0');
INSERT INTO `system_dict_data` VALUES (18, 2, '新增', '2', 'system_operate_type', 0, 'primary', '', '新增操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:13', b'0');
INSERT INTO `system_dict_data` VALUES (19, 3, '修改', '3', 'system_operate_type', 0, 'warning', '', '修改操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:22', b'0');
INSERT INTO `system_dict_data` VALUES (20, 4, '删除', '4', 'system_operate_type', 0, 'danger', '', '删除操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:27', b'0');
INSERT INTO `system_dict_data` VALUES (22, 5, '导出', '5', 'system_operate_type', 0, 'default', '', '导出操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:32', b'0');
INSERT INTO `system_dict_data` VALUES (23, 6, '导入', '6', 'system_operate_type', 0, 'default', '', '导入操作', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:33:35', b'0');
INSERT INTO `system_dict_data` VALUES (27, 1, '开启', '0', 'common_status', 0, 'primary', '', '开启状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:39', b'0');
INSERT INTO `system_dict_data` VALUES (28, 2, '关闭', '1', 'common_status', 0, 'info', '', '关闭状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:44', b'0');
INSERT INTO `system_dict_data` VALUES (29, 1, '目录', '1', 'system_menu_type', 0, '', '', '目录', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:45', b'0');
INSERT INTO `system_dict_data` VALUES (30, 2, '菜单', '2', 'system_menu_type', 0, '', '', '菜单', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:41', b'0');
INSERT INTO `system_dict_data` VALUES (31, 3, '按钮', '3', 'system_menu_type', 0, '', '', '按钮', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:39', b'0');
INSERT INTO `system_dict_data` VALUES (32, 1, '内置', '1', 'system_role_type', 0, 'danger', '', '内置角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:08', b'0');
INSERT INTO `system_dict_data` VALUES (33, 2, '自定义', '2', 'system_role_type', 0, 'primary', '', '自定义角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:12', b'0');
INSERT INTO `system_dict_data` VALUES (34, 1, '全部数据权限', '1', 'system_data_scope', 0, '', '', '全部数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:17', b'0');
INSERT INTO `system_dict_data` VALUES (35, 2, '指定部门数据权限', '2', 'system_data_scope', 0, '', '', '指定部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:18', b'0');
INSERT INTO `system_dict_data` VALUES (36, 3, '本部门数据权限', '3', 'system_data_scope', 0, '', '', '本部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:16', b'0');
INSERT INTO `system_dict_data` VALUES (37, 4, '本部门及以下数据权限', '4', 'system_data_scope', 0, '', '', '本部门及以下数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:21', b'0');
INSERT INTO `system_dict_data` VALUES (38, 5, '仅本人数据权限', '5', 'system_data_scope', 0, '', '', '仅本人数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:23', b'0');
INSERT INTO `system_dict_data` VALUES (39, 0, '成功', '0', 'system_login_result', 0, 'success', '', '登陆结果 - 成功', '', '2021-01-18 06:17:36', '1', '2022-02-16 13:23:49', b'0');
INSERT INTO `system_dict_data` VALUES (40, 10, '账号或密码不正确', '10', 'system_login_result', 0, 'primary', '', '登陆结果 - 账号或密码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:27', b'0');
INSERT INTO `system_dict_data` VALUES (41, 20, '用户被禁用', '20', 'system_login_result', 0, 'warning', '', '登陆结果 - 用户被禁用', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:23:57', b'0');
INSERT INTO `system_dict_data` VALUES (42, 30, '验证码不存在', '30', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不存在', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:07', b'0');
INSERT INTO `system_dict_data` VALUES (43, 31, '验证码不正确', '31', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:11', b'0');
INSERT INTO `system_dict_data` VALUES (44, 100, '未知异常', '100', 'system_login_result', 0, 'danger', '', '登陆结果 - 未知异常', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:23', b'0');
INSERT INTO `system_dict_data` VALUES (45, 1, '是', 'true', 'infra_boolean_string', 0, 'danger', '', 'Boolean 是否类型 - 是', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:01:45', b'0');
INSERT INTO `system_dict_data` VALUES (46, 1, '否', 'false', 'infra_boolean_string', 0, 'info', '', 'Boolean 是否类型 - 否', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:09:45', b'0');
INSERT INTO `system_dict_data` VALUES (47, 1, '永不超时', '1', 'infra_redis_timeout_type', 0, 'primary', '', 'Redis 未设置超时的情况', '', '2021-01-26 00:53:17', '1', '2022-02-16 19:03:35', b'0');
INSERT INTO `system_dict_data` VALUES (48, 1, '动态超时', '2', 'infra_redis_timeout_type', 0, 'info', '', '程序里动态传入超时时间，无法固定', '', '2021-01-26 00:55:00', '1', '2022-02-16 19:03:41', b'0');
INSERT INTO `system_dict_data` VALUES (49, 3, '固定超时', '3', 'infra_redis_timeout_type', 0, 'success', '', 'Redis 设置了过期时间', '', '2021-01-26 00:55:26', '1', '2022-02-16 19:03:45', b'0');
INSERT INTO `system_dict_data` VALUES (50, 1, '单表（增删改查）', '1', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:09:06', '', '2022-03-10 16:33:15', b'0');
INSERT INTO `system_dict_data` VALUES (51, 2, '树表（增删改查）', '2', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:14:46', '', '2022-03-10 16:33:19', b'0');
INSERT INTO `system_dict_data` VALUES (53, 0, '初始化中', '0', 'infra_job_status', 0, 'primary', '', NULL, '', '2021-02-07 07:46:49', '1', '2022-02-16 19:33:29', b'0');
INSERT INTO `system_dict_data` VALUES (57, 0, '运行中', '0', 'infra_job_log_status', 0, 'primary', '', 'RUNNING', '', '2021-02-08 10:04:24', '1', '2022-02-16 19:07:48', b'0');
INSERT INTO `system_dict_data` VALUES (58, 1, '成功', '1', 'infra_job_log_status', 0, 'success', '', NULL, '', '2021-02-08 10:06:57', '1', '2022-02-16 19:07:52', b'0');
INSERT INTO `system_dict_data` VALUES (59, 2, '失败', '2', 'infra_job_log_status', 0, 'warning', '', '失败', '', '2021-02-08 10:07:38', '1', '2022-02-16 19:07:56', b'0');
INSERT INTO `system_dict_data` VALUES (60, 1, '会员', '1', 'user_type', 0, 'primary', '', NULL, '', '2021-02-26 00:16:27', '1', '2022-02-16 10:22:19', b'0');
INSERT INTO `system_dict_data` VALUES (61, 2, '管理员', '2', 'user_type', 0, 'success', '', NULL, '', '2021-02-26 00:16:34', '1', '2022-02-16 10:22:22', b'0');
INSERT INTO `system_dict_data` VALUES (62, 0, '未处理', '0', 'infra_api_error_log_process_status', 0, 'primary', '', NULL, '', '2021-02-26 07:07:19', '1', '2022-02-16 20:14:17', b'0');
INSERT INTO `system_dict_data` VALUES (63, 1, '已处理', '1', 'infra_api_error_log_process_status', 0, 'success', '', NULL, '', '2021-02-26 07:07:26', '1', '2022-02-16 20:14:08', b'0');
INSERT INTO `system_dict_data` VALUES (64, 2, '已忽略', '2', 'infra_api_error_log_process_status', 0, 'danger', '', NULL, '', '2021-02-26 07:07:34', '1', '2022-02-16 20:14:14', b'0');
INSERT INTO `system_dict_data` VALUES (66, 2, '阿里云', 'ALIYUN', 'system_sms_channel_code', 0, 'primary', '', NULL, '1', '2021-04-05 01:05:26', '1', '2022-02-16 10:09:52', b'0');
INSERT INTO `system_dict_data` VALUES (67, 1, '验证码', '1', 'system_sms_template_type', 0, 'warning', '', NULL, '1', '2021-04-05 21:50:57', '1', '2022-02-16 12:48:30', b'0');
INSERT INTO `system_dict_data` VALUES (68, 2, '通知', '2', 'system_sms_template_type', 0, 'primary', '', NULL, '1', '2021-04-05 21:51:08', '1', '2022-02-16 12:48:27', b'0');
INSERT INTO `system_dict_data` VALUES (69, 0, '营销', '3', 'system_sms_template_type', 0, 'danger', '', NULL, '1', '2021-04-05 21:51:15', '1', '2022-02-16 12:48:22', b'0');
INSERT INTO `system_dict_data` VALUES (70, 0, '初始化', '0', 'system_sms_send_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:18:33', '1', '2022-02-16 10:26:07', b'0');
INSERT INTO `system_dict_data` VALUES (71, 1, '发送成功', '10', 'system_sms_send_status', 0, 'success', '', NULL, '1', '2021-04-11 20:18:43', '1', '2022-02-16 10:25:56', b'0');
INSERT INTO `system_dict_data` VALUES (72, 2, '发送失败', '20', 'system_sms_send_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:18:49', '1', '2022-02-16 10:26:03', b'0');
INSERT INTO `system_dict_data` VALUES (73, 3, '不发送', '30', 'system_sms_send_status', 0, 'info', '', NULL, '1', '2021-04-11 20:19:44', '1', '2022-02-16 10:26:10', b'0');
INSERT INTO `system_dict_data` VALUES (74, 0, '等待结果', '0', 'system_sms_receive_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:27:43', '1', '2022-02-16 10:28:24', b'0');
INSERT INTO `system_dict_data` VALUES (75, 1, '接收成功', '10', 'system_sms_receive_status', 0, 'success', '', NULL, '1', '2021-04-11 20:29:25', '1', '2022-02-16 10:28:28', b'0');
INSERT INTO `system_dict_data` VALUES (76, 2, '接收失败', '20', 'system_sms_receive_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:29:31', '1', '2022-02-16 10:28:32', b'0');
INSERT INTO `system_dict_data` VALUES (77, 0, '调试(钉钉)', 'DEBUG_DING_TALK', 'system_sms_channel_code', 0, 'info', '', NULL, '1', '2021-04-13 00:20:37', '1', '2022-02-16 10:10:00', b'0');
INSERT INTO `system_dict_data` VALUES (78, 1, '自动生成', '1', 'system_error_code_type', 0, 'warning', '', NULL, '1', '2021-04-21 00:06:48', '1', '2022-02-16 13:57:20', b'0');
INSERT INTO `system_dict_data` VALUES (79, 2, '手动编辑', '2', 'system_error_code_type', 0, 'primary', '', NULL, '1', '2021-04-21 00:07:14', '1', '2022-02-16 13:57:24', b'0');
INSERT INTO `system_dict_data` VALUES (80, 100, '账号登录', '100', 'system_login_type', 0, 'primary', '', '账号登录', '1', '2021-10-06 00:52:02', '1', '2022-02-16 13:11:34', b'0');
INSERT INTO `system_dict_data` VALUES (81, 101, '社交登录', '101', 'system_login_type', 0, 'info', '', '社交登录', '1', '2021-10-06 00:52:17', '1', '2022-02-16 13:11:40', b'0');
INSERT INTO `system_dict_data` VALUES (83, 200, '主动登出', '200', 'system_login_type', 0, 'primary', '', '主动登出', '1', '2021-10-06 00:52:58', '1', '2022-02-16 13:11:49', b'0');
INSERT INTO `system_dict_data` VALUES (85, 202, '强制登出', '202', 'system_login_type', 0, 'danger', '', '强制退出', '1', '2021-10-06 00:53:41', '1', '2022-02-16 13:11:57', b'0');
INSERT INTO `system_dict_data` VALUES (86, 0, '病假', '1', 'bpm_oa_leave_type', 0, 'primary', '', NULL, '1', '2021-09-21 22:35:28', '1', '2022-02-16 10:00:41', b'0');
INSERT INTO `system_dict_data` VALUES (87, 1, '事假', '2', 'bpm_oa_leave_type', 0, 'info', '', NULL, '1', '2021-09-21 22:36:11', '1', '2022-02-16 10:00:49', b'0');
INSERT INTO `system_dict_data` VALUES (88, 2, '婚假', '3', 'bpm_oa_leave_type', 0, 'warning', '', NULL, '1', '2021-09-21 22:36:38', '1', '2022-02-16 10:00:53', b'0');
INSERT INTO `system_dict_data` VALUES (98, 1, 'v2', 'v2', 'pay_channel_wechat_version', 0, '', '', 'v2版本', '1', '2021-11-08 17:00:58', '1', '2021-11-08 17:00:58', b'0');
INSERT INTO `system_dict_data` VALUES (99, 2, 'v3', 'v3', 'pay_channel_wechat_version', 0, '', '', 'v3版本', '1', '2021-11-08 17:01:07', '1', '2021-11-08 17:01:07', b'0');
INSERT INTO `system_dict_data` VALUES (108, 1, 'RSA2', 'RSA2', 'pay_channel_alipay_sign_type', 0, '', '', 'RSA2', '1', '2021-11-18 15:39:29', '1', '2021-11-18 15:39:29', b'0');
INSERT INTO `system_dict_data` VALUES (109, 1, '公钥模式', '1', 'pay_channel_alipay_mode', 0, '', '', '公钥模式：privateKey + alipayPublicKey', '1', '2021-11-18 15:45:23', '1', '2021-11-18 15:45:23', b'0');
INSERT INTO `system_dict_data` VALUES (110, 2, '证书模式', '2', 'pay_channel_alipay_mode', 0, '', '', '证书模式：appCertContent + alipayPublicCertContent + rootCertContent', '1', '2021-11-18 15:45:40', '1', '2021-11-18 15:45:40', b'0');
INSERT INTO `system_dict_data` VALUES (111, 1, '线上', 'https://openapi.alipay.com/gateway.do', 'pay_channel_alipay_server_type', 0, '', '', '网关地址 - 线上', '1', '2021-11-18 16:59:32', '1', '2021-11-21 17:37:29', b'0');
INSERT INTO `system_dict_data` VALUES (112, 2, '沙箱', 'https://openapi.alipaydev.com/gateway.do', 'pay_channel_alipay_server_type', 0, '', '', '网关地址 - 沙箱', '1', '2021-11-18 16:59:48', '1', '2021-11-21 17:37:39', b'0');
INSERT INTO `system_dict_data` VALUES (113, 1, '微信 JSAPI 支付', 'wx_pub', 'pay_channel_code_type', 0, '', '', '微信 JSAPI（公众号） 支付', '1', '2021-12-03 10:40:24', '1', '2021-12-04 16:41:00', b'0');
INSERT INTO `system_dict_data` VALUES (114, 2, '微信小程序支付', 'wx_lite', 'pay_channel_code_type', 0, '', '', '微信小程序支付', '1', '2021-12-03 10:41:06', '1', '2021-12-03 10:41:06', b'0');
INSERT INTO `system_dict_data` VALUES (115, 3, '微信 App 支付', 'wx_app', 'pay_channel_code_type', 0, '', '', '微信 App 支付', '1', '2021-12-03 10:41:20', '1', '2021-12-03 10:41:20', b'0');
INSERT INTO `system_dict_data` VALUES (116, 4, '支付宝 PC 网站支付', 'alipay_pc', 'pay_channel_code_type', 0, '', '', '支付宝 PC 网站支付', '1', '2021-12-03 10:42:09', '1', '2021-12-03 10:42:09', b'0');
INSERT INTO `system_dict_data` VALUES (117, 5, '支付宝 Wap 网站支付', 'alipay_wap', 'pay_channel_code_type', 0, '', '', '支付宝 Wap 网站支付', '1', '2021-12-03 10:42:26', '1', '2021-12-03 10:42:26', b'0');
INSERT INTO `system_dict_data` VALUES (118, 6, '支付宝App 支付', 'alipay_app', 'pay_channel_code_type', 0, '', '', '支付宝App 支付', '1', '2021-12-03 10:42:55', '1', '2021-12-03 10:42:55', b'0');
INSERT INTO `system_dict_data` VALUES (119, 7, '支付宝扫码支付', 'alipay_qr', 'pay_channel_code_type', 0, '', '', '支付宝扫码支付', '1', '2021-12-03 10:43:10', '1', '2021-12-03 10:43:10', b'0');
INSERT INTO `system_dict_data` VALUES (120, 1, '通知成功', '10', 'pay_order_notify_status', 0, 'success', '', '通知成功', '1', '2021-12-03 11:02:41', '1', '2022-02-16 13:59:13', b'0');
INSERT INTO `system_dict_data` VALUES (121, 2, '通知失败', '20', 'pay_order_notify_status', 0, 'danger', '', '通知失败', '1', '2021-12-03 11:02:59', '1', '2022-02-16 13:59:17', b'0');
INSERT INTO `system_dict_data` VALUES (122, 3, '未通知', '0', 'pay_order_notify_status', 0, 'info', '', '未通知', '1', '2021-12-03 11:03:10', '1', '2022-02-16 13:59:23', b'0');
INSERT INTO `system_dict_data` VALUES (123, 1, '支付成功', '10', 'pay_order_status', 0, 'success', '', '支付成功', '1', '2021-12-03 11:18:29', '1', '2022-02-16 15:24:25', b'0');
INSERT INTO `system_dict_data` VALUES (124, 2, '支付关闭', '20', 'pay_order_status', 0, 'danger', '', '支付关闭', '1', '2021-12-03 11:18:42', '1', '2022-02-16 15:24:31', b'0');
INSERT INTO `system_dict_data` VALUES (125, 3, '未支付', '0', 'pay_order_status', 0, 'info', '', '未支付', '1', '2021-12-03 11:18:18', '1', '2022-02-16 15:24:35', b'0');
INSERT INTO `system_dict_data` VALUES (126, 1, '未退款', '0', 'pay_order_refund_status', 0, '', '', '未退款', '1', '2021-12-03 11:30:35', '1', '2021-12-03 11:34:05', b'0');
INSERT INTO `system_dict_data` VALUES (127, 2, '部分退款', '10', 'pay_order_refund_status', 0, '', '', '部分退款', '1', '2021-12-03 11:30:44', '1', '2021-12-03 11:34:10', b'0');
INSERT INTO `system_dict_data` VALUES (128, 3, '全部退款', '20', 'pay_order_refund_status', 0, '', '', '全部退款', '1', '2021-12-03 11:30:52', '1', '2021-12-03 11:34:14', b'0');
INSERT INTO `system_dict_data` VALUES (1117, 1, '退款订单生成', '0', 'pay_refund_order_status', 0, 'primary', '', '退款订单生成', '1', '2021-12-10 16:44:44', '1', '2022-02-16 14:05:24', b'0');
INSERT INTO `system_dict_data` VALUES (1118, 2, '退款成功', '1', 'pay_refund_order_status', 0, 'success', '', '退款成功', '1', '2021-12-10 16:44:59', '1', '2022-02-16 14:05:28', b'0');
INSERT INTO `system_dict_data` VALUES (1119, 3, '退款失败', '2', 'pay_refund_order_status', 0, 'danger', '', '退款失败', '1', '2021-12-10 16:45:10', '1', '2022-02-16 14:05:34', b'0');
INSERT INTO `system_dict_data` VALUES (1124, 8, '退款关闭', '99', 'pay_refund_order_status', 0, 'info', '', '退款关闭', '1', '2021-12-10 16:46:26', '1', '2022-02-16 14:05:40', b'0');
INSERT INTO `system_dict_data` VALUES (1125, 0, '默认', '1', 'bpm_model_category', 0, 'primary', '', '流程分类 - 默认', '1', '2022-01-02 08:41:11', '1', '2022-02-16 20:01:42', b'0');
INSERT INTO `system_dict_data` VALUES (1126, 0, 'OA', '2', 'bpm_model_category', 0, 'success', '', '流程分类 - OA', '1', '2022-01-02 08:41:22', '1', '2022-02-16 20:01:50', b'0');
INSERT INTO `system_dict_data` VALUES (1127, 0, '进行中', '1', 'bpm_process_instance_status', 0, 'primary', '', '流程实例的状态 - 进行中', '1', '2022-01-07 23:47:22', '1', '2022-02-16 20:07:49', b'0');
INSERT INTO `system_dict_data` VALUES (1128, 2, '已完成', '2', 'bpm_process_instance_status', 0, 'success', '', '流程实例的状态 - 已完成', '1', '2022-01-07 23:47:49', '1', '2022-02-16 20:07:54', b'0');
INSERT INTO `system_dict_data` VALUES (1129, 1, '处理中', '1', 'bpm_process_instance_result', 0, 'primary', '', '流程实例的结果 - 处理中', '1', '2022-01-07 23:48:32', '1', '2022-02-16 09:53:26', b'0');
INSERT INTO `system_dict_data` VALUES (1130, 2, '通过', '2', 'bpm_process_instance_result', 0, 'success', '', '流程实例的结果 - 通过', '1', '2022-01-07 23:48:45', '1', '2022-02-16 09:53:31', b'0');
INSERT INTO `system_dict_data` VALUES (1131, 3, '不通过', '3', 'bpm_process_instance_result', 0, 'danger', '', '流程实例的结果 - 不通过', '1', '2022-01-07 23:48:55', '1', '2022-02-16 09:53:38', b'0');
INSERT INTO `system_dict_data` VALUES (1132, 4, '已取消', '4', 'bpm_process_instance_result', 0, 'info', '', '流程实例的结果 - 撤销', '1', '2022-01-07 23:49:06', '1', '2022-02-16 09:53:42', b'0');
INSERT INTO `system_dict_data` VALUES (1133, 10, '流程表单', '10', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 流程表单', '103', '2022-01-11 23:51:30', '103', '2022-01-11 23:51:30', b'0');
INSERT INTO `system_dict_data` VALUES (1134, 20, '业务表单', '20', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 业务表单', '103', '2022-01-11 23:51:47', '103', '2022-01-11 23:51:47', b'0');
INSERT INTO `system_dict_data` VALUES (1135, 10, '角色', '10', 'bpm_task_assign_rule_type', 0, 'info', '', '任务分配规则的类型 - 角色', '103', '2022-01-12 23:21:22', '1', '2022-02-16 20:06:14', b'0');
INSERT INTO `system_dict_data` VALUES (1136, 20, '部门的成员', '20', 'bpm_task_assign_rule_type', 0, 'primary', '', '任务分配规则的类型 - 部门的成员', '103', '2022-01-12 23:21:47', '1', '2022-02-16 20:05:28', b'0');
INSERT INTO `system_dict_data` VALUES (1137, 21, '部门的负责人', '21', 'bpm_task_assign_rule_type', 0, 'primary', '', '任务分配规则的类型 - 部门的负责人', '103', '2022-01-12 23:33:36', '1', '2022-02-16 20:05:31', b'0');
INSERT INTO `system_dict_data` VALUES (1138, 30, '用户', '30', 'bpm_task_assign_rule_type', 0, 'info', '', '任务分配规则的类型 - 用户', '103', '2022-01-12 23:34:02', '1', '2022-02-16 20:05:50', b'0');
INSERT INTO `system_dict_data` VALUES (1139, 40, '用户组', '40', 'bpm_task_assign_rule_type', 0, 'warning', '', '任务分配规则的类型 - 用户组', '103', '2022-01-12 23:34:21', '1', '2022-02-16 20:05:57', b'0');
INSERT INTO `system_dict_data` VALUES (1140, 50, '自定义脚本', '50', 'bpm_task_assign_rule_type', 0, 'danger', '', '任务分配规则的类型 - 自定义脚本', '103', '2022-01-12 23:34:43', '1', '2022-02-16 20:06:01', b'0');
INSERT INTO `system_dict_data` VALUES (1141, 22, '岗位', '22', 'bpm_task_assign_rule_type', 0, 'success', '', '任务分配规则的类型 - 岗位', '103', '2022-01-14 18:41:55', '1', '2022-02-16 20:05:39', b'0');
INSERT INTO `system_dict_data` VALUES (1142, 10, '流程发起人', '10', 'bpm_task_assign_script', 0, '', '', '任务分配自定义脚本 - 流程发起人', '103', '2022-01-15 00:10:57', '103', '2022-01-15 21:24:10', b'0');
INSERT INTO `system_dict_data` VALUES (1143, 20, '流程发起人的一级领导', '20', 'bpm_task_assign_script', 0, '', '', '任务分配自定义脚本 - 流程发起人的一级领导', '103', '2022-01-15 21:24:31', '103', '2022-01-15 21:24:31', b'0');
INSERT INTO `system_dict_data` VALUES (1144, 21, '流程发起人的二级领导', '21', 'bpm_task_assign_script', 0, '', '', '任务分配自定义脚本 - 流程发起人的二级领导', '103', '2022-01-15 21:24:46', '103', '2022-01-15 21:24:57', b'0');
INSERT INTO `system_dict_data` VALUES (1145, 1, '管理后台', '1', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 管理后台', '1', '2022-02-02 13:15:06', '1', '2022-03-10 16:32:59', b'0');
INSERT INTO `system_dict_data` VALUES (1146, 2, '用户 APP', '2', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 用户 APP', '1', '2022-02-02 13:15:19', '1', '2022-03-10 16:33:03', b'0');
INSERT INTO `system_dict_data` VALUES (1147, 0, '未退款', '0', 'pay_refund_order_type', 0, 'info', '', '退款类型 - 未退款', '1', '2022-02-16 14:09:01', '1', '2022-02-16 14:09:01', b'0');
INSERT INTO `system_dict_data` VALUES (1148, 10, '部分退款', '10', 'pay_refund_order_type', 0, 'success', '', '退款类型 - 部分退款', '1', '2022-02-16 14:09:25', '1', '2022-02-16 14:11:38', b'0');
INSERT INTO `system_dict_data` VALUES (1149, 20, '全部退款', '20', 'pay_refund_order_type', 0, 'warning', '', '退款类型 - 全部退款', '1', '2022-02-16 14:11:33', '1', '2022-02-16 14:11:33', b'0');
INSERT INTO `system_dict_data` VALUES (1150, 1, '数据库', '1', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:28', '1', '2022-03-15 00:25:28', b'0');
INSERT INTO `system_dict_data` VALUES (1151, 10, '本地磁盘', '10', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:41', '1', '2022-03-15 00:25:56', b'0');
INSERT INTO `system_dict_data` VALUES (1152, 11, 'FTP 服务器', '11', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:06', '1', '2022-03-15 00:26:10', b'0');
INSERT INTO `system_dict_data` VALUES (1153, 12, 'SFTP 服务器', '12', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:22', '1', '2022-03-15 00:26:22', b'0');
INSERT INTO `system_dict_data` VALUES (1154, 20, 'S3 对象存储', '20', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:31', '1', '2022-03-15 00:26:45', b'0');
INSERT INTO `system_dict_data` VALUES (1155, 103, '短信登录', '103', 'system_login_type', 0, 'default', '', NULL, '1', '2022-05-09 23:57:58', '1', '2022-05-09 23:58:09', b'0');
INSERT INTO `system_dict_data` VALUES (1156, 1, 'password', 'password', 'system_oauth2_grant_type', 0, 'default', '', '密码模式', '1', '2022-05-12 00:22:05', '1', '2022-05-11 16:26:01', b'0');
INSERT INTO `system_dict_data` VALUES (1157, 2, 'authorization_code', 'authorization_code', 'system_oauth2_grant_type', 0, 'primary', '', '授权码模式', '1', '2022-05-12 00:22:59', '1', '2022-05-11 16:26:02', b'0');
INSERT INTO `system_dict_data` VALUES (1158, 3, 'implicit', 'implicit', 'system_oauth2_grant_type', 0, 'success', '', '简化模式', '1', '2022-05-12 00:23:40', '1', '2022-05-11 16:26:05', b'0');
INSERT INTO `system_dict_data` VALUES (1159, 4, 'client_credentials', 'client_credentials', 'system_oauth2_grant_type', 0, 'default', '', '客户端模式', '1', '2022-05-12 00:23:51', '1', '2022-05-11 16:26:08', b'0');
INSERT INTO `system_dict_data` VALUES (1160, 5, 'refresh_token', 'refresh_token', 'system_oauth2_grant_type', 0, 'info', '', '刷新模式', '1', '2022-05-12 00:24:02', '1', '2022-05-11 16:26:11', b'0');
INSERT INTO `system_dict_data` VALUES (1162, 1, '销售中', '1', 'product_spu_status', 0, 'success', '', '商品 SPU 状态 - 销售中', '1', '2022-10-24 21:19:47', '1', '2022-10-24 21:20:38', b'0');
INSERT INTO `system_dict_data` VALUES (1163, 0, '仓库中', '0', 'product_spu_status', 0, 'info', '', '商品 SPU 状态 - 仓库中', '1', '2022-10-24 21:20:54', '1', '2022-10-24 21:21:22', b'0');
INSERT INTO `system_dict_data` VALUES (1164, 0, '回收站', '-1', 'product_spu_status', 0, 'default', '', '商品 SPU 状态 - 回收站', '1', '2022-10-24 21:21:11', '1', '2022-10-24 21:21:11', b'0');
INSERT INTO `system_dict_data` VALUES (1165, 1, '满减', '1', 'promotion_discount_type', 0, 'success', '', '优惠类型 - 满减', '1', '2022-11-01 12:46:41', '1', '2022-11-01 12:50:11', b'0');
INSERT INTO `system_dict_data` VALUES (1166, 2, '折扣', '2', 'promotion_discount_type', 0, 'primary', '', '优惠类型 - 折扣', '1', '2022-11-01 12:46:51', '1', '2022-11-01 12:50:08', b'0');
INSERT INTO `system_dict_data` VALUES (1167, 1, '固定日期', '1', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 固定日期', '1', '2022-11-02 00:07:34', '1', '2022-11-04 00:07:49', b'0');
INSERT INTO `system_dict_data` VALUES (1168, 2, '领取之后', '2', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 领取之后', '1', '2022-11-02 00:07:54', '1', '2022-11-04 00:07:52', b'0');
INSERT INTO `system_dict_data` VALUES (1169, 1, '全部商品参与', '1', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 全部商品参与', '1', '2022-11-02 00:28:22', '1', '2022-11-02 00:28:22', b'0');
INSERT INTO `system_dict_data` VALUES (1170, 2, '指定商品参与', '2', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 指定商品参与', '1', '2022-11-02 00:28:34', '1', '2022-11-02 00:28:40', b'0');
INSERT INTO `system_dict_data` VALUES (1171, 1, '已领取', '1', 'promotion_coupon_status', 0, 'primary', '', '优惠劵的状态 - 已领取', '1', '2022-11-04 00:15:08', '1', '2022-11-04 19:16:04', b'0');
INSERT INTO `system_dict_data` VALUES (1172, 2, '已使用', '2', 'promotion_coupon_status', 0, 'success', '', '优惠劵的状态 - 已使用', '1', '2022-11-04 00:15:21', '1', '2022-11-04 19:16:08', b'0');
INSERT INTO `system_dict_data` VALUES (1173, 3, '已过期', '3', 'promotion_coupon_status', 0, 'info', '', '优惠劵的状态 - 已过期', '1', '2022-11-04 00:15:43', '1', '2022-11-04 19:16:12', b'0');
INSERT INTO `system_dict_data` VALUES (1174, 1, '直接领取', '1', 'promotion_coupon_take_type', 0, 'primary', '', '优惠劵的领取方式 - 直接领取', '1', '2022-11-04 19:13:00', '1', '2022-11-04 19:13:25', b'0');
INSERT INTO `system_dict_data` VALUES (1175, 2, '指定发放', '2', 'promotion_coupon_take_type', 0, 'success', '', '优惠劵的领取方式 - 指定发放', '1', '2022-11-04 19:13:13', '1', '2022-11-04 19:14:48', b'0');
INSERT INTO `system_dict_data` VALUES (1176, 10, '未开始', '10', 'promotion_activity_status', 0, 'primary', '', '促销活动的状态枚举 - 未开始', '1', '2022-11-04 22:54:49', '1', '2022-11-04 22:55:53', b'0');
INSERT INTO `system_dict_data` VALUES (1177, 20, '进行中', '20', 'promotion_activity_status', 0, 'success', '', '促销活动的状态枚举 - 进行中', '1', '2022-11-04 22:55:06', '1', '2022-11-04 22:55:20', b'0');
INSERT INTO `system_dict_data` VALUES (1178, 30, '已结束', '30', 'promotion_activity_status', 0, 'info', '', '促销活动的状态枚举 - 已结束', '1', '2022-11-04 22:55:41', '1', '2022-11-04 22:55:41', b'0');
INSERT INTO `system_dict_data` VALUES (1179, 40, '已关闭', '40', 'promotion_activity_status', 0, 'warning', '', '促销活动的状态枚举 - 已关闭', '1', '2022-11-04 22:56:10', '1', '2022-11-04 22:56:18', b'0');
INSERT INTO `system_dict_data` VALUES (1180, 10, '满 N 元', '10', 'promotion_condition_type', 0, 'primary', '', '营销的条件类型 - 满 N 元', '1', '2022-11-04 22:59:45', '1', '2022-11-04 22:59:45', b'0');
INSERT INTO `system_dict_data` VALUES (1181, 20, '满 N 件', '20', 'promotion_condition_type', 0, 'success', '', '营销的条件类型 - 满 N 件', '1', '2022-11-04 23:00:02', '1', '2022-11-04 23:00:02', b'0');
INSERT INTO `system_dict_data` VALUES (1182, 10, '申请售后', '10', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 申请售后', '1', '2022-11-19 20:53:33', '1', '2022-11-19 20:54:42', b'0');
INSERT INTO `system_dict_data` VALUES (1183, 20, '商品待退货', '20', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商品待退货', '1', '2022-11-19 20:54:36', '1', '2022-11-19 20:58:58', b'0');
INSERT INTO `system_dict_data` VALUES (1184, 30, '商家待收货', '30', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商家待收货', '1', '2022-11-19 20:56:56', '1', '2022-11-19 20:59:20', b'0');
INSERT INTO `system_dict_data` VALUES (1185, 40, '等待退款', '40', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 等待退款', '1', '2022-11-19 20:59:54', '1', '2022-11-19 21:00:01', b'0');
INSERT INTO `system_dict_data` VALUES (1186, 50, '退款成功', '50', 'trade_after_sale_status', 0, 'default', '', '交易售后状态 - 退款成功', '1', '2022-11-19 21:00:33', '1', '2022-11-19 21:00:33', b'0');
INSERT INTO `system_dict_data` VALUES (1187, 61, '买家取消', '61', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 买家取消', '1', '2022-11-19 21:01:29', '1', '2022-11-19 21:01:29', b'0');
INSERT INTO `system_dict_data` VALUES (1188, 62, '商家拒绝', '62', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒绝', '1', '2022-11-19 21:02:17', '1', '2022-11-19 21:02:17', b'0');
INSERT INTO `system_dict_data` VALUES (1189, 63, '商家拒收货', '63', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒收货', '1', '2022-11-19 21:02:37', '1', '2022-11-19 21:03:07', b'0');
INSERT INTO `system_dict_data` VALUES (1190, 10, '售中退款', '10', 'trade_after_sale_type', 0, 'success', '', '交易售后的类型 - 售中退款', '1', '2022-11-19 21:05:05', '1', '2022-11-19 21:38:23', b'0');
INSERT INTO `system_dict_data` VALUES (1191, 20, '售后退款', '20', 'trade_after_sale_type', 0, 'primary', '', '交易售后的类型 - 售后退款', '1', '2022-11-19 21:05:32', '1', '2022-11-19 21:38:32', b'0');
INSERT INTO `system_dict_data` VALUES (1192, 10, '仅退款', '10', 'trade_after_sale_way', 0, 'primary', '', '交易售后的方式 - 仅退款', '1', '2022-11-19 21:39:19', '1', '2022-11-19 21:39:19', b'0');
INSERT INTO `system_dict_data` VALUES (1193, 20, '退货退款', '20', 'trade_after_sale_way', 0, 'success', '', '交易售后的方式 - 退货退款', '1', '2022-11-19 21:39:38', '1', '2022-11-19 21:39:49', b'0');
INSERT INTO `system_dict_data` VALUES (1194, 10, '微信小程序', '10', 'terminal', 0, 'default', '', '终端 - 微信小程序', '1', '2022-12-10 10:51:11', '1', '2022-12-10 10:51:57', b'0');
INSERT INTO `system_dict_data` VALUES (1195, 20, 'H5 网页', '20', 'terminal', 0, 'default', '', '终端 - H5 网页', '1', '2022-12-10 10:51:30', '1', '2022-12-10 10:51:59', b'0');
INSERT INTO `system_dict_data` VALUES (1196, 11, '微信公众号', '11', 'terminal', 0, 'default', '', '终端 - 微信公众号', '1', '2022-12-10 10:54:16', '1', '2022-12-10 10:52:01', b'0');
INSERT INTO `system_dict_data` VALUES (1197, 31, '苹果 App', '31', 'terminal', 0, 'default', '', '终端 - 苹果 App', '1', '2022-12-10 10:54:42', '1', '2022-12-10 10:52:18', b'0');
INSERT INTO `system_dict_data` VALUES (1198, 32, '安卓 App', '32', 'terminal', 0, 'default', '', '终端 - 安卓 App', '1', '2022-12-10 10:55:02', '1', '2022-12-10 10:59:17', b'0');
INSERT INTO `system_dict_data` VALUES (1199, 0, '普通订单', '0', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 普通订单', '1', '2022-12-10 16:34:14', '1', '2022-12-10 16:34:14', b'0');
INSERT INTO `system_dict_data` VALUES (1200, 1, '秒杀订单', '1', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 秒杀订单', '1', '2022-12-10 16:34:26', '1', '2022-12-10 16:34:26', b'0');
INSERT INTO `system_dict_data` VALUES (1201, 2, '拼团订单', '2', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 拼团订单', '1', '2022-12-10 16:34:36', '1', '2022-12-10 16:34:36', b'0');
INSERT INTO `system_dict_data` VALUES (1202, 3, '砍价订单', '3', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 砍价订单', '1', '2022-12-10 16:34:48', '1', '2022-12-10 16:34:48', b'0');
INSERT INTO `system_dict_data` VALUES (1203, 0, '待支付', '0', 'trade_order_status', 0, 'default', '', '交易订单状态 - 待支付', '1', '2022-12-10 16:49:29', '1', '2022-12-10 16:49:29', b'0');
INSERT INTO `system_dict_data` VALUES (1204, 10, '待发货', '10', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 待发货', '1', '2022-12-10 16:49:53', '1', '2022-12-10 16:51:17', b'0');
INSERT INTO `system_dict_data` VALUES (1205, 20, '已发货', '20', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 已发货', '1', '2022-12-10 16:50:13', '1', '2022-12-10 16:51:31', b'0');
INSERT INTO `system_dict_data` VALUES (1206, 30, '已完成', '30', 'trade_order_status', 0, 'success', '', '交易订单状态 - 已完成', '1', '2022-12-10 16:50:30', '1', '2022-12-10 16:51:06', b'0');
INSERT INTO `system_dict_data` VALUES (1207, 40, '已取消', '40', 'trade_order_status', 0, 'danger', '', '交易订单状态 - 已取消', '1', '2022-12-10 16:50:50', '1', '2022-12-10 16:51:00', b'0');
INSERT INTO `system_dict_data` VALUES (1208, 0, '未售后', '0', 'trade_order_item_after_sale_status', 0, 'info', '', '交易订单项的售后状态 - 未售后', '1', '2022-12-10 20:58:42', '1', '2022-12-10 20:59:29', b'0');
INSERT INTO `system_dict_data` VALUES (1209, 1, '售后中', '1', 'trade_order_item_after_sale_status', 0, 'primary', '', '交易订单项的售后状态 - 售后中', '1', '2022-12-10 20:59:21', '1', '2022-12-10 20:59:21', b'0');
INSERT INTO `system_dict_data` VALUES (1210, 2, '已退款', '2', 'trade_order_item_after_sale_status', 0, 'success', '', '交易订单项的售后状态 - 已退款', '1', '2022-12-10 20:59:46', '1', '2022-12-10 20:59:46', b'0');
INSERT INTO `system_dict_data` VALUES (1211, 1, '完全匹配', '1', 'mp_auto_reply_request_match', 0, 'primary', '', '公众号自动回复的请求关键字匹配模式 - 完全匹配', '1', '2023-01-16 23:30:39', '1', '2023-01-16 23:31:00', b'0');
INSERT INTO `system_dict_data` VALUES (1212, 2, '半匹配', '2', 'mp_auto_reply_request_match', 0, 'success', '', '公众号自动回复的请求关键字匹配模式 - 半匹配', '1', '2023-01-16 23:30:55', '1', '2023-01-16 23:31:10', b'0');
INSERT INTO `system_dict_data` VALUES (1213, 1, '文本', 'text', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 文本', '1', '2023-01-17 22:17:32', '1', '2023-01-17 22:17:39', b'0');
INSERT INTO `system_dict_data` VALUES (1214, 2, '图片', 'image', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图片', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:47', b'0');
INSERT INTO `system_dict_data` VALUES (1215, 3, '语音', 'voice', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 语音', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:20:08', b'0');
INSERT INTO `system_dict_data` VALUES (1216, 4, '视频', 'video', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:21:08', b'0');
INSERT INTO `system_dict_data` VALUES (1217, 5, '小视频', 'shortvideo', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 小视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:59', b'0');
INSERT INTO `system_dict_data` VALUES (1218, 6, '图文', 'news', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图文', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', b'0');
INSERT INTO `system_dict_data` VALUES (1219, 7, '音乐', 'music', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 音乐', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', b'0');
INSERT INTO `system_dict_data` VALUES (1220, 8, '地理位置', 'location', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 地理位置', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:23:51', b'0');
INSERT INTO `system_dict_data` VALUES (1221, 9, '链接', 'link', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 链接', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', b'0');
INSERT INTO `system_dict_data` VALUES (1222, 10, '事件', 'event', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 事件', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', b'0');
INSERT INTO `system_dict_data` VALUES (1223, 0, '初始化', '0', 'system_mail_send_status', 0, 'primary', '', '邮件发送状态 - 初始化\n', '1', '2023-01-26 09:53:49', '1', '2023-01-26 16:36:14', b'0');
INSERT INTO `system_dict_data` VALUES (1224, 10, '发送成功', '10', 'system_mail_send_status', 0, 'success', '', '邮件发送状态 - 发送成功', '1', '2023-01-26 09:54:28', '1', '2023-01-26 16:36:22', b'0');
INSERT INTO `system_dict_data` VALUES (1225, 20, '发送失败', '20', 'system_mail_send_status', 0, 'danger', '', '邮件发送状态 - 发送失败', '1', '2023-01-26 09:54:50', '1', '2023-01-26 16:36:26', b'0');
INSERT INTO `system_dict_data` VALUES (1226, 30, '不发送', '30', 'system_mail_send_status', 0, 'info', '', '邮件发送状态 -  不发送', '1', '2023-01-26 09:55:06', '1', '2023-01-26 16:36:36', b'0');
INSERT INTO `system_dict_data` VALUES (1227, 1, '通知公告', '1', 'system_notify_template_type', 0, 'primary', '', '站内信模版的类型 - 通知公告', '1', '2023-01-28 10:35:59', '1', '2023-01-28 10:35:59', b'0');
INSERT INTO `system_dict_data` VALUES (1228, 2, '系统消息', '2', 'system_notify_template_type', 0, 'success', '', '站内信模版的类型 - 系统消息', '1', '2023-01-28 10:36:20', '1', '2023-01-28 10:36:25', b'0');
INSERT INTO `system_dict_data` VALUES (1229, 0, '模拟支付', 'mock', 'pay_channel_code_type', 0, 'default', '', NULL, '1', '2023-02-12 21:50:22', '1', '2023-02-12 21:50:22', b'0');
INSERT INTO `system_dict_data` VALUES (1230, 8, '支付宝条码支付', 'alipay_bar', 'pay_channel_code_type', 0, 'default', '', NULL, '1', '2023-02-18 23:32:24', '1', '2023-02-18 23:32:32', b'0');
INSERT INTO `system_dict_data` VALUES (1231, 10, 'Vue2 Element UI 标准模版', '10', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:03:55', '1', '2023-07-31 09:28:36', b'1');
INSERT INTO `system_dict_data` VALUES (1232, 20, 'Vue3 Element Plus 标准模版', '20', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:08', '1', '2023-04-13 00:04:08', b'0');
INSERT INTO `system_dict_data` VALUES (1233, 21, 'Vue3 Element Plus Schema 模版', '21', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1', '2023-07-31 09:29:37', b'1');
INSERT INTO `system_dict_data` VALUES (1234, 30, 'Vue3 vben 模版', '30', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1', '2023-07-31 09:28:26', b'1');
COMMIT;

-- ----------------------------
-- Table structure for system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_type`;
CREATE TABLE `system_dict_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典名称',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `deleted_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `dict_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

-- ----------------------------
-- Records of system_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `system_dict_type` VALUES (1, '用户性别', 'system_user_sex', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2022-05-16 20:29:32', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (6, '参数类型', 'infra_config_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:36:54', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (7, '通知类型', 'system_notice_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:35:26', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (9, '操作类型', 'system_operate_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:32:21', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (10, '系统状态', 'common_status', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:21:28', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (11, 'Boolean 是否类型', 'infra_boolean_string', 0, 'boolean 转是否', '', '2021-01-19 03:20:08', '', '2022-02-01 16:37:10', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (104, '登陆结果', 'system_login_result', 0, '登陆结果', '', '2021-01-18 06:17:11', '', '2022-02-01 16:36:00', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (105, 'Redis 超时类型', 'infra_redis_timeout_type', 0, 'RedisKeyDefine.TimeoutTypeEnum', '', '2021-01-26 00:52:50', '', '2022-02-01 16:50:29', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (106, '代码生成模板类型', 'infra_codegen_template_type', 0, NULL, '', '2021-02-05 07:08:06', '1', '2022-05-16 20:26:50', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (107, '定时任务状态', 'infra_job_status', 0, NULL, '', '2021-02-07 07:44:16', '', '2022-02-01 16:51:11', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (108, '定时任务日志状态', 'infra_job_log_status', 0, NULL, '', '2021-02-08 10:03:51', '', '2022-02-01 16:50:43', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (109, '用户类型', 'user_type', 0, NULL, '', '2021-02-26 00:15:51', '', '2021-02-26 00:15:51', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (110, 'API 异常数据的处理状态', 'infra_api_error_log_process_status', 0, NULL, '', '2021-02-26 07:07:01', '', '2022-02-01 16:50:53', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (111, '短信渠道编码', 'system_sms_channel_code', 0, NULL, '1', '2021-04-05 01:04:50', '1', '2022-02-16 02:09:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (112, '短信模板的类型', 'system_sms_template_type', 0, NULL, '1', '2021-04-05 21:50:43', '1', '2022-02-01 16:35:06', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (113, '短信发送状态', 'system_sms_send_status', 0, NULL, '1', '2021-04-11 20:18:03', '1', '2022-02-01 16:35:09', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (114, '短信接收状态', 'system_sms_receive_status', 0, NULL, '1', '2021-04-11 20:27:14', '1', '2022-02-01 16:35:14', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (115, '错误码的类型', 'system_error_code_type', 0, NULL, '1', '2021-04-21 00:06:30', '1', '2022-02-01 16:36:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (116, '登陆日志的类型', 'system_login_type', 0, '登陆日志的类型', '1', '2021-10-06 00:50:46', '1', '2022-02-01 16:35:56', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (117, 'OA 请假类型', 'bpm_oa_leave_type', 0, NULL, '1', '2021-09-21 22:34:33', '1', '2022-01-22 10:41:37', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (122, '支付渠道微信版本', 'pay_channel_wechat_version', 0, '支付渠道微信版本', '1', '2021-11-08 17:00:26', '1', '2021-11-08 17:00:26', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (127, '支付渠道支付宝算法类型', 'pay_channel_alipay_sign_type', 0, '支付渠道支付宝算法类型', '1', '2021-11-18 15:39:09', '1', '2021-11-18 15:39:09', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (128, '支付渠道支付宝公钥类型', 'pay_channel_alipay_mode', 0, '支付渠道支付宝公钥类型', '1', '2021-11-18 15:44:28', '1', '2021-11-18 15:44:28', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (129, '支付宝网关地址', 'pay_channel_alipay_server_type', 0, '支付宝网关地址', '1', '2021-11-18 16:58:55', '1', '2021-11-18 17:01:34', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (130, '支付渠道编码类型', 'pay_channel_code_type', 0, '支付渠道的编码', '1', '2021-12-03 10:35:08', '1', '2021-12-03 10:35:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (131, '支付订单回调状态', 'pay_order_notify_status', 0, '支付订单回调状态', '1', '2021-12-03 10:53:29', '1', '2021-12-03 10:53:29', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (132, '支付订单状态', 'pay_order_status', 0, '支付订单状态', '1', '2021-12-03 11:17:50', '1', '2021-12-03 11:17:50', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (133, '支付订单退款状态', 'pay_order_refund_status', 0, '支付订单退款状态', '1', '2021-12-03 11:27:31', '1', '2021-12-03 11:27:31', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (134, '退款订单状态', 'pay_refund_order_status', 0, '退款订单状态', '1', '2021-12-10 16:42:50', '1', '2021-12-10 16:42:50', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (135, '退款订单类别', 'pay_refund_order_type', 0, '退款订单类别', '1', '2021-12-10 17:14:53', '1', '2021-12-10 17:14:53', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (138, '流程分类', 'bpm_model_category', 0, '流程分类', '1', '2022-01-02 08:40:45', '1', '2022-01-02 08:40:45', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (139, '流程实例的状态', 'bpm_process_instance_status', 0, '流程实例的状态', '1', '2022-01-07 23:46:42', '1', '2022-01-07 23:46:42', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (140, '流程实例的结果', 'bpm_process_instance_result', 0, '流程实例的结果', '1', '2022-01-07 23:48:10', '1', '2022-01-07 23:48:10', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (141, '流程的表单类型', 'bpm_model_form_type', 0, '流程的表单类型', '103', '2022-01-11 23:50:45', '103', '2022-01-11 23:50:45', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (142, '任务分配规则的类型', 'bpm_task_assign_rule_type', 0, '任务分配规则的类型', '103', '2022-01-12 23:21:04', '103', '2022-01-12 15:46:10', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (143, '任务分配自定义脚本', 'bpm_task_assign_script', 0, '任务分配自定义脚本', '103', '2022-01-15 00:10:35', '103', '2022-01-15 00:10:35', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (144, '代码生成的场景枚举', 'infra_codegen_scene', 0, '代码生成的场景枚举', '1', '2022-02-02 13:14:45', '1', '2022-03-10 16:33:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (145, '角色类型', 'system_role_type', 0, '角色类型', '1', '2022-02-16 13:01:46', '1', '2022-02-16 13:01:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (146, '文件存储器', 'infra_file_storage', 0, '文件存储器', '1', '2022-03-15 00:24:38', '1', '2022-03-15 00:24:38', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (147, 'OAuth 2.0 授权类型', 'system_oauth2_grant_type', 0, 'OAuth 2.0 授权类型（模式）', '1', '2022-05-12 00:20:52', '1', '2022-05-11 16:25:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (149, '商品 SPU 状态', 'product_spu_status', 0, '商品 SPU 状态', '1', '2022-10-24 21:19:04', '1', '2022-10-24 21:19:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (150, '优惠类型', 'promotion_discount_type', 0, '优惠类型', '1', '2022-11-01 12:46:06', '1', '2022-11-01 12:46:06', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (151, '优惠劵模板的有限期类型', 'promotion_coupon_template_validity_type', 0, '优惠劵模板的有限期类型', '1', '2022-11-02 00:06:20', '1', '2022-11-04 00:08:26', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (152, '营销的商品范围', 'promotion_product_scope', 0, '营销的商品范围', '1', '2022-11-02 00:28:01', '1', '2022-11-02 00:28:01', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (153, '优惠劵的状态', 'promotion_coupon_status', 0, '优惠劵的状态', '1', '2022-11-04 00:14:49', '1', '2022-11-04 00:14:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (154, '优惠劵的领取方式', 'promotion_coupon_take_type', 0, '优惠劵的领取方式', '1', '2022-11-04 19:12:27', '1', '2022-11-04 19:12:27', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (155, '促销活动的状态', 'promotion_activity_status', 0, '促销活动的状态', '1', '2022-11-04 22:54:23', '1', '2022-11-04 22:54:23', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (156, '营销的条件类型', 'promotion_condition_type', 0, '营销的条件类型', '1', '2022-11-04 22:59:23', '1', '2022-11-04 22:59:23', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (157, '交易售后状态', 'trade_after_sale_status', 0, '交易售后状态', '1', '2022-11-19 20:52:56', '1', '2022-11-19 20:52:56', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (158, '交易售后的类型', 'trade_after_sale_type', 0, '交易售后的类型', '1', '2022-11-19 21:04:09', '1', '2022-11-19 21:04:09', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (159, '交易售后的方式', 'trade_after_sale_way', 0, '交易售后的方式', '1', '2022-11-19 21:39:04', '1', '2022-11-19 21:39:04', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (160, '终端', 'terminal', 0, '终端', '1', '2022-12-10 10:50:50', '1', '2022-12-10 10:53:11', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (161, '交易订单的类型', 'trade_order_type', 0, '交易订单的类型', '1', '2022-12-10 16:33:54', '1', '2022-12-10 16:33:54', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (162, '交易订单的状态', 'trade_order_status', 0, '交易订单的状态', '1', '2022-12-10 16:48:44', '1', '2022-12-10 16:48:44', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (163, '交易订单项的售后状态', 'trade_order_item_after_sale_status', 0, '交易订单项的售后状态', '1', '2022-12-10 20:58:08', '1', '2022-12-10 20:58:08', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (164, '公众号自动回复的请求关键字匹配模式', 'mp_auto_reply_request_match', 0, '公众号自动回复的请求关键字匹配模式', '1', '2023-01-16 23:29:56', '1', '2023-01-16 23:29:56', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (165, '公众号的消息类型', 'mp_message_type', 0, '公众号的消息类型', '1', '2023-01-17 22:17:09', '1', '2023-01-17 22:17:09', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (166, '邮件发送状态', 'system_mail_send_status', 0, '邮件发送状态', '1', '2023-01-26 09:53:13', '1', '2023-01-26 09:53:13', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (167, '站内信模版的类型', 'system_notify_template_type', 0, '站内信模版的类型', '1', '2023-01-28 10:35:10', '1', '2023-01-28 10:35:10', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (168, '代码生成的前端类型', 'infra_codegen_front_type', 0, '', '1', '2023-04-12 23:57:52', '1', '2023-04-12 23:57:52', b'0', '1970-01-01 00:00:00');
COMMIT;

-- ----------------------------
-- Table structure for system_error_code
-- ----------------------------
DROP TABLE IF EXISTS `system_error_code`;
CREATE TABLE `system_error_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '错误码编号',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '错误码类型',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `code` int NOT NULL DEFAULT '0' COMMENT '错误码编码',
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '错误码错误提示',
  `memo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='错误码表';

-- ----------------------------
-- Records of system_error_code
-- ----------------------------
BEGIN;
INSERT INTO `system_error_code` VALUES (5832, 1, 'yshop-server', 1001000001, '参数配置不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5833, 1, 'yshop-server', 1001000002, '参数配置 key 重复', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5834, 1, 'yshop-server', 1001000003, '不能删除类型为系统内置的参数配置', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5835, 1, 'yshop-server', 1001000004, '获取参数配置失败，原因：不允许获取不可见配置', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5836, 1, 'yshop-server', 1001001000, '定时任务不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5837, 1, 'yshop-server', 1001001001, '定时任务的处理器已经存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5838, 1, 'yshop-server', 1001001002, '只允许修改为开启或者关闭状态', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5839, 1, 'yshop-server', 1001001003, '定时任务已经处于该状态，无需修改', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5840, 1, 'yshop-server', 1001001004, '只有开启状态的任务，才可以修改', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5841, 1, 'yshop-server', 1001001005, 'CRON 表达式不正确', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5842, 1, 'yshop-server', 1001002000, 'API 错误日志不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5843, 1, 'yshop-server', 1001002001, 'API 错误日志已处理', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5844, 1, 'yshop-server', 1001003000, '文件路径已存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5845, 1, 'yshop-server', 1001003001, '文件不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5846, 1, 'yshop-server', 1001003002, '文件为空', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5847, 1, 'yshop-server', 1003001000, '表定义已经存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5848, 1, 'yshop-server', 1003001001, '导入的表不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5849, 1, 'yshop-server', 1003001002, '导入的字段不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5850, 1, 'yshop-server', 1003001004, '表定义不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5851, 1, 'yshop-server', 1003001005, '字段义不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5852, 1, 'yshop-server', 1003001006, '同步的字段不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5853, 1, 'yshop-server', 1003001007, '同步失败，不存在改变', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5854, 1, 'yshop-server', 1003001008, '数据库的表注释未填写', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5855, 1, 'yshop-server', 1003001009, '数据库的表字段({})注释未填写', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5856, 1, 'yshop-server', 1001005000, '测试示例不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5857, 1, 'yshop-server', 1001006000, '文件配置不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5858, 1, 'yshop-server', 1001006001, '该文件配置不允许删除，原因：它是主配置，删除会导致无法上传文件', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5859, 1, 'yshop-server', 1001007000, '数据源配置不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5860, 1, 'yshop-server', 1001007001, '数据源配置不正确，无法进行连接', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5861, 1, 'yshop-server', 1004001000, '用户不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5862, 1, 'yshop-server', 1004001001, '密码校验失败', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5863, 1, 'yshop-server', 1004003000, '登录失败，账号密码不正确', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5864, 1, 'yshop-server', 1004003001, '登录失败，账号被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5865, 1, 'yshop-server', 1004003004, 'Token 已经过期', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5866, 1, 'yshop-server', 1004003005, '未绑定账号，需要进行绑定', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5867, 1, 'yshop-server', 1004003006, '获得手机号失败', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5868, 1, 'yshop-server', 1004004000, '用户收件地址不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5869, 1, 'yshop-server', 1004004001, '用户收件地址参数错误', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5870, 1, 'yshop-server', 1004004001, '用户账单不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5871, 1, 'yshop-server', 1004004002, '登录失败，请联系管理员', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5872, 1, 'yshop-server', 1004004003, '此优惠券不满足使用提交', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5873, 1, 'yshop-server', 1008009000, '支付服务商配置不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5874, 1, 'yshop-server', 1002000000, '登录失败，账号密码不正确', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5875, 1, 'yshop-server', 1002000001, '登录失败，账号被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5876, 1, 'yshop-server', 1002000004, '验证码不正确，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5877, 1, 'yshop-server', 1002000005, '未绑定账号，需要进行绑定', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5878, 1, 'yshop-server', 1002000006, 'Token 已经过期', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5879, 1, 'yshop-server', 1002000007, '手机号不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5880, 1, 'yshop-server', 1002001000, '已经存在该名字的菜单', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5881, 1, 'yshop-server', 1002001001, '父菜单不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5882, 1, 'yshop-server', 1002001002, '不能设置自己为父菜单', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5883, 1, 'yshop-server', 1002001003, '菜单不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5884, 1, 'yshop-server', 1002001004, '存在子菜单，无法删除', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5885, 1, 'yshop-server', 1002001005, '父菜单的类型必须是目录或者菜单', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5886, 1, 'yshop-server', 1002002000, '角色不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5887, 1, 'yshop-server', 1002002001, '已经存在名为【{}】的角色', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5888, 1, 'yshop-server', 1002002002, '已经存在编码为【{}】的角色', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5889, 1, 'yshop-server', 1002002003, '不能操作类型为系统内置的角色', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5890, 1, 'yshop-server', 1002002004, '名字为【{}】的角色已被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5891, 1, 'yshop-server', 1002002005, '编码【{}】不能使用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5892, 1, 'yshop-server', 1002003000, '用户账号已经存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5893, 1, 'yshop-server', 1002003001, '手机号已经存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5894, 1, 'yshop-server', 1002003002, '邮箱已经存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5895, 1, 'yshop-server', 1002003003, '用户不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5896, 1, 'yshop-server', 1002003004, '导入用户数据不能为空！', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5897, 1, 'yshop-server', 1002003005, '用户密码校验失败', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5898, 1, 'yshop-server', 1002003006, '名字为【{}】的用户已被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5899, 1, 'yshop-server', 1002003008, '创建用户失败，原因：超过租户最大租户配额({})！', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5900, 1, 'yshop-server', 1002004000, '已经存在该名字的部门', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5901, 1, 'yshop-server', 1002004001, '父级部门不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5902, 1, 'yshop-server', 1002004002, '当前部门不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5903, 1, 'yshop-server', 1002004003, '存在子部门，无法删除', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5904, 1, 'yshop-server', 1002004004, '不能设置自己为父部门', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5905, 1, 'yshop-server', 1002004005, '部门中存在员工，无法删除', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5906, 1, 'yshop-server', 1002004006, '部门({})不处于开启状态，不允许选择', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5907, 1, 'yshop-server', 1002004007, '不能设置自己的子部门为父部门', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5908, 1, 'yshop-server', 1002005000, '当前岗位不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5909, 1, 'yshop-server', 1002005001, '岗位({}) 不处于开启状态，不允许选择', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5910, 1, 'yshop-server', 1002005002, '已经存在该名字的岗位', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5911, 1, 'yshop-server', 1002005003, '已经存在该标识的岗位', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5912, 1, 'yshop-server', 1002006001, '当前字典类型不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5913, 1, 'yshop-server', 1002006002, '字典类型不处于开启状态，不允许选择', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5914, 1, 'yshop-server', 1002006003, '已经存在该名字的字典类型', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5915, 1, 'yshop-server', 1002006004, '已经存在该类型的字典类型', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5916, 1, 'yshop-server', 1002006005, '无法删除，该字典类型还有字典数据', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5917, 1, 'yshop-server', 1002007001, '当前字典数据不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5918, 1, 'yshop-server', 1002007002, '字典数据({})不处于开启状态，不允许选择', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5919, 1, 'yshop-server', 1002007003, '已经存在该值的字典数据', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5920, 1, 'yshop-server', 1002008001, '当前通知公告不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5921, 1, 'yshop-server', 1002011000, '短信渠道不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5922, 1, 'yshop-server', 1002011001, '短信渠道不处于开启状态，不允许选择', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5923, 1, 'yshop-server', 1002011002, '无法删除，该短信渠道还有短信模板', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5924, 1, 'yshop-server', 1002012000, '短信模板不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5925, 1, 'yshop-server', 1002012001, '已经存在编码为【{}】的短信模板', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5926, 1, 'yshop-server', 1002013000, '手机号不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5927, 1, 'yshop-server', 1002013001, '模板参数({})缺失', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5928, 1, 'yshop-server', 1002013002, '短信模板不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5929, 1, 'yshop-server', 1002014000, '验证码不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5930, 1, 'yshop-server', 1002014001, '验证码已过期', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5931, 1, 'yshop-server', 1002014002, '验证码已使用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5932, 1, 'yshop-server', 1002014003, '验证码不正确', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5933, 1, 'yshop-server', 1002014004, '超过每日短信发送数量', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5934, 1, 'yshop-server', 1002014005, '短信发送过于频率', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5935, 1, 'yshop-server', 1002014006, '手机号已被使用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5936, 1, 'yshop-server', 1002014007, '验证码未被使用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5937, 1, 'yshop-server', 1002015000, '租户不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5938, 1, 'yshop-server', 1002015001, '名字为【{}】的租户已被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5939, 1, 'yshop-server', 1002015002, '名字为【{}】的租户已过期', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5940, 1, 'yshop-server', 1002015003, '系统租户不能进行修改、删除等操作！', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5941, 1, 'yshop-server', 1002015004, '名字为【{}】的租户已存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5942, 1, 'yshop-server', 1002016000, '租户套餐不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5943, 1, 'yshop-server', 1002016001, '租户正在使用该套餐，请给租户重新设置套餐后再尝试删除', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5944, 1, 'yshop-server', 1002016002, '名字为【{}】的租户套餐已被禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5945, 1, 'yshop-server', 1002017000, '错误码不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5946, 1, 'yshop-server', 1002017001, '已经存在编码为【{}】的错误码', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5947, 1, 'yshop-server', 1002018000, '社交授权失败，原因是：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5948, 1, 'yshop-server', 1002018001, '社交解绑失败，非当前用户绑定', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5949, 1, 'yshop-server', 1002018002, '社交授权失败，找不到对应的用户', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5950, 1, 'yshop-server', 1002019000, '系统敏感词在所有标签中都不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5951, 1, 'yshop-server', 1002019001, '系统敏感词已在标签中存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5952, 1, 'yshop-server', 1002020000, 'OAuth2 客户端不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5953, 1, 'yshop-server', 1002020001, 'OAuth2 客户端编号已存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5954, 1, 'yshop-server', 1002020002, 'OAuth2 客户端已禁用', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5955, 1, 'yshop-server', 1002020003, '不支持该授权类型', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5956, 1, 'yshop-server', 1002020004, '授权范围过大', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5957, 1, 'yshop-server', 1002020005, '无效 redirect_uri: {}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5958, 1, 'yshop-server', 1002020006, '无效 client_secret: {}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5959, 1, 'yshop-server', 1002021000, 'client_id 不匹配', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5960, 1, 'yshop-server', 1002021001, 'redirect_uri 不匹配', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5961, 1, 'yshop-server', 1002021002, 'state 不匹配', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5962, 1, 'yshop-server', 1002021003, 'code 不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5963, 1, 'yshop-server', 1002022000, 'code 不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5964, 1, 'yshop-server', 1002022001, 'code 已过期', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5965, 1, 'yshop-server', 1002023000, '邮箱账号不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5966, 1, 'yshop-server', 1002023001, '无法删除，该邮箱账号还有邮件模板', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5967, 1, 'yshop-server', 1002024000, '邮件模版不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5968, 1, 'yshop-server', 1002024001, '邮件模版 code({}) 已存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5969, 1, 'yshop-server', 1002025000, '模板参数({})缺失', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5970, 1, 'yshop-server', 1002025000, '邮箱不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5971, 1, 'yshop-server', 1002026000, '站内信模版不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5972, 1, 'yshop-server', 1002026001, '已经存在编码为【{}】的站内信模板', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5973, 1, 'yshop-server', 1002025000, '模板参数({})缺失', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5974, 1, 'yshop-server', 1006000000, '公众号账号不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5975, 1, 'yshop-server', 1006000001, '生成公众号二维码失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5976, 1, 'yshop-server', 1006000001, '清空公众号的 API 配额失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5977, 1, 'yshop-server', 1006001000, '获取粉丝增减数据失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5978, 1, 'yshop-server', 1006001001, '获得粉丝累计数据失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5979, 1, 'yshop-server', 1006001002, '获得消息发送概况数据失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5980, 1, 'yshop-server', 1006001003, '获得接口分析数据失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5981, 1, 'yshop-server', 1006002000, '标签不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5982, 1, 'yshop-server', 1006002001, '删除标签失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5983, 1, 'yshop-server', 1006002001, '更新标签失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5984, 1, 'yshop-server', 1006002001, '删除标签失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5985, 1, 'yshop-server', 1006002001, '获得标签失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5986, 1, 'yshop-server', 1006003000, '粉丝不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5987, 1, 'yshop-server', 1006003001, '更新粉丝标签失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5988, 1, 'yshop-server', 1006004000, '素材不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5989, 1, 'yshop-server', 1006004001, '上传素材失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5990, 1, 'yshop-server', 1006004002, '上传图片失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5991, 1, 'yshop-server', 1006004003, '删除素材失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5992, 1, 'yshop-server', 1006005000, '发送消息失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5993, 1, 'yshop-server', 1006006000, '获得已成功发布列表失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5994, 1, 'yshop-server', 1006006001, '提交发布失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5995, 1, 'yshop-server', 1006006001, '删除发布失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5996, 1, 'yshop-server', 1006007000, '获得草稿列表失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5997, 1, 'yshop-server', 1006007001, '创建草稿失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (5998, 1, 'yshop-server', 1006007002, '更新草稿失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-18 18:36:50', b'0');
INSERT INTO `system_error_code` VALUES (5999, 1, 'yshop-server', 1006007002, '删除草稿失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6000, 1, 'yshop-server', 1006008000, '创建菜单失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6001, 1, 'yshop-server', 1006008001, '删除菜单失败，原因：{}', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6002, 1, 'yshop-server', 1006009000, '自动回复不存在', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6003, 1, 'yshop-server', 1006009001, '操作失败，原因：已存在关注时的回复', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6004, 1, 'yshop-server', 1006009002, '操作失败，原因：已存在该消息类型的回复', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
INSERT INTO `system_error_code` VALUES (6005, 1, 'yshop-server', 1006009003, '操作失败，原因：已关在该关键字的回复', '', NULL, '2023-09-13 11:18:15', NULL, '2023-09-13 11:18:15', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_login_log
-- ----------------------------
DROP TABLE IF EXISTS `system_login_log`;
CREATE TABLE `system_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `log_type` bigint NOT NULL COMMENT '日志类型',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT '0' COMMENT '用户类型',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户账号',
  `result` tinyint NOT NULL COMMENT '登陆结果',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户 IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';

-- ----------------------------
-- Records of system_login_log
-- ----------------------------
BEGIN;
INSERT INTO `system_login_log` VALUES (2163, 100, '', 1, 2, 'admin', 0, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-07 16:51:51', NULL, '2023-05-07 16:51:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2164, 100, '', 1, 2, 'admin', 0, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-08 16:54:46', NULL, '2023-05-08 16:54:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2165, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-08 18:31:31', NULL, '2023-05-08 18:31:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2166, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-08 18:32:25', '1', '2023-05-08 18:32:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2167, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-08 18:32:29', NULL, '2023-05-08 18:32:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2168, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:26:28', NULL, '2023-05-09 10:26:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2169, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-09 10:26:58', '1', '2023-05-09 10:26:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2170, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:37:58', NULL, '2023-05-09 10:37:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2171, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:38:40', NULL, '2023-05-09 10:38:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2172, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:40:40', NULL, '2023-05-09 10:40:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2173, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:48:22', NULL, '2023-05-09 10:48:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2174, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-09 10:48:34', '1', '2023-05-09 10:48:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2175, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-09 10:48:37', NULL, '2023-05-09 10:48:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2176, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-10 09:29:09', NULL, '2023-05-10 09:29:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2177, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-10 09:45:47', '1', '2023-05-10 09:45:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2178, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-10 10:00:49', '1', '2023-05-10 10:00:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2179, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-10 10:00:53', NULL, '2023-05-10 10:00:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2180, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-10 10:35:31', '1', '2023-05-10 10:35:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2181, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-10 10:35:33', NULL, '2023-05-10 10:35:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2182, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', '1', '2023-05-10 15:19:12', '1', '2023-05-10 15:19:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2183, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-10 15:19:17', NULL, '2023-05-10 15:19:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2184, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', NULL, '2023-05-12 12:45:18', NULL, '2023-05-12 12:45:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2185, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-15 16:47:03', NULL, '2023-05-15 16:47:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2186, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-16 10:50:23', NULL, '2023-05-16 10:50:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2187, 100, '', 1, 2, 'admin', 0, '127.0.0.1', 'Apifox/1.0.0 (https://www.apifox.cn)', NULL, '2023-05-16 10:51:52', NULL, '2023-05-16 10:51:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2188, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-17 09:43:18', NULL, '2023-05-17 09:43:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2189, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-17 10:36:16', '1', '2023-05-17 10:36:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2190, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-17 10:36:24', NULL, '2023-05-17 10:36:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2191, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-17 15:32:29', '1', '2023-05-17 15:32:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2192, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-17 15:32:36', NULL, '2023-05-17 15:32:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2193, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-18 10:08:43', NULL, '2023-05-18 10:08:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2194, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-19 11:15:16', NULL, '2023-05-19 11:15:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2195, 100, '', 1, 2, 'admin', 0, '125.33.246.74', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-20 21:06:58', NULL, '2023-05-20 21:06:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2196, 100, '', 1, 2, 'admin', 0, '125.33.246.74', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-21 21:38:22', NULL, '2023-05-21 21:38:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2197, 100, '', 1, 2, 'admin', 0, '129.232.133.46', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-21 23:02:11', NULL, '2023-05-21 23:02:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2198, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-22 12:03:17', NULL, '2023-05-22 12:03:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2199, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-22 15:27:51', '1', '2023-05-22 15:27:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2200, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-22 15:27:57', NULL, '2023-05-22 15:27:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2201, 100, '', 1, 2, 'admin', 0, '154.53.59.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-22 22:56:45', NULL, '2023-05-22 22:56:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2202, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-23 09:21:05', NULL, '2023-05-23 09:21:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2203, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-23 09:21:27', NULL, '2023-05-23 09:21:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2204, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-24 09:27:39', NULL, '2023-05-24 09:27:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2205, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-24 09:27:45', '1', '2023-05-24 09:27:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2206, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-25 11:35:10', NULL, '2023-05-25 11:35:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2207, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-25 20:21:00', NULL, '2023-05-25 20:21:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2208, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-25 21:08:53', '1', '2023-05-25 21:08:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2209, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-25 21:08:59', NULL, '2023-05-25 21:08:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2210, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-26 13:42:20', NULL, '2023-05-26 13:42:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2211, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-26 14:24:04', '1', '2023-05-26 14:24:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2212, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-26 14:24:11', NULL, '2023-05-26 14:24:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2213, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-27 09:22:40', NULL, '2023-05-27 09:22:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2214, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-29 11:00:51', NULL, '2023-05-29 11:00:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2215, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-05-29 11:01:05', '1', '2023-05-29 11:01:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2216, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-29 11:01:10', NULL, '2023-05-29 11:01:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2217, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-30 09:49:00', NULL, '2023-05-30 09:49:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2218, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-05-30 11:39:51', NULL, '2023-05-30 11:39:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2219, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-01 10:55:15', NULL, '2023-06-01 10:55:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2220, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-01 10:55:35', '1', '2023-06-01 10:55:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2221, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-01 11:04:43', NULL, '2023-06-01 11:04:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2222, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-01 11:04:58', '1', '2023-06-01 11:04:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2223, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-02 09:33:19', NULL, '2023-06-02 09:33:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2224, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-02 09:33:26', '1', '2023-06-02 09:33:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2225, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-02 09:49:02', NULL, '2023-06-02 09:49:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2226, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-02 18:37:26', '1', '2023-06-02 18:37:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2227, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-02 18:37:30', NULL, '2023-06-02 18:37:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2228, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-03 12:00:22', NULL, '2023-06-03 12:00:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2229, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-05 11:11:45', NULL, '2023-06-05 11:11:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2230, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-06 10:03:24', NULL, '2023-06-06 10:03:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2231, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-06 11:03:43', NULL, '2023-06-06 11:03:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2232, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-08 09:54:26', NULL, '2023-06-08 09:54:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2233, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-08 09:56:11', NULL, '2023-06-08 09:56:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2234, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-09 14:48:41', NULL, '2023-06-09 14:48:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2235, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-09 17:25:44', '1', '2023-06-09 17:25:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2236, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-09 17:25:59', NULL, '2023-06-09 17:25:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2237, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-09 17:26:11', '1', '2023-06-09 17:26:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2238, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-09 17:36:20', NULL, '2023-06-09 17:36:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2239, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-09 17:36:59', '1', '2023-06-09 17:36:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2240, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-09 17:43:49', '1', '2023-06-09 17:43:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2241, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-09 17:44:00', NULL, '2023-06-09 17:44:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2242, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-10 09:45:55', NULL, '2023-06-10 09:45:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2243, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-10 11:14:53', NULL, '2023-06-10 11:14:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2244, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-10 11:16:28', NULL, '2023-06-10 11:16:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2245, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-10 12:00:29', '1', '2023-06-10 12:00:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2246, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-10 15:10:04', NULL, '2023-06-10 15:10:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2247, 104, '', 2, 1, '15136175246', 0, '127.0.0.1', 'Apifox/1.0.0 (https://www.apifox.cn)', NULL, '2023-06-10 15:45:43', NULL, '2023-06-10 15:45:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2248, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-12 09:56:23', NULL, '2023-06-12 09:56:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2249, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-12 15:07:00', NULL, '2023-06-12 15:07:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2250, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-13 10:21:25', '1', '2023-06-13 10:21:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2251, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-13 10:21:29', NULL, '2023-06-13 10:21:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2252, 104, '', 2, 1, '15136175246', 0, '127.0.0.1', 'Apifox/1.0.0 (https://www.apifox.cn)', NULL, '2023-06-15 11:28:34', NULL, '2023-06-15 11:28:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2253, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-15 17:55:50', '1', '2023-06-15 17:55:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2254, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-15 17:55:57', NULL, '2023-06-15 17:55:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2255, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', '1', '2023-06-15 23:27:32', '1', '2023-06-15 23:27:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2256, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, '2023-06-15 23:27:37', NULL, '2023-06-15 23:27:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2257, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-17 22:15:18', '1', '2023-06-17 22:15:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2258, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-17 22:15:40', NULL, '2023-06-17 22:15:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2259, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-17 22:16:53', '1', '2023-06-17 22:16:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2260, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-17 22:16:55', NULL, '2023-06-17 22:16:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2261, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-17 22:19:48', NULL, '2023-06-17 22:19:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2262, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-18 18:02:15', '1', '2023-06-18 18:02:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2263, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-18 18:02:20', NULL, '2023-06-18 18:02:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2264, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-18 20:41:56', '1', '2023-06-18 20:41:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2265, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-18 20:42:01', NULL, '2023-06-18 20:42:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2266, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-18 20:53:32', '1', '2023-06-18 20:53:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2267, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-18 20:53:37', NULL, '2023-06-18 20:53:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2268, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-06-29 13:40:26', '1', '2023-06-29 13:40:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2269, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-06-29 13:40:37', NULL, '2023-06-29 13:40:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2270, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-02 10:19:15', '1', '2023-07-02 10:19:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2271, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-02 10:19:22', NULL, '2023-07-02 10:19:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2272, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-02 10:38:53', '1', '2023-07-02 10:38:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2273, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-02 10:38:56', NULL, '2023-07-02 10:38:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2274, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-09 09:48:15', '1', '2023-07-09 09:48:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2275, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-09 09:48:21', NULL, '2023-07-09 09:48:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2276, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-10 22:30:41', '1', '2023-07-10 22:30:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2277, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-10 22:30:43', NULL, '2023-07-10 22:30:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2278, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-14 16:26:07', '1', '2023-07-14 16:26:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2279, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-14 16:26:13', NULL, '2023-07-14 16:26:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2280, 104, '', 2, 1, '15136175246', 0, '127.0.0.1', 'Apifox/1.0.0 (https://www.apifox.cn)', NULL, '2023-07-15 18:54:40', NULL, '2023-07-15 18:54:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2281, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-19 15:39:52', '1', '2023-07-19 15:39:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2282, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-19 15:39:58', NULL, '2023-07-19 15:39:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2283, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-20 18:27:36', '1', '2023-07-20 18:27:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2284, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-20 18:27:39', NULL, '2023-07-20 18:27:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2285, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-24 11:33:59', NULL, '2023-07-24 11:33:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2286, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-25 10:07:12', '1', '2023-07-25 10:07:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2287, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-25 10:07:18', NULL, '2023-07-25 10:07:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2288, 104, '', 2, 1, '15136175246', 0, '127.0.0.1', 'Apifox/1.0.0 (https://www.apifox.cn)', NULL, '2023-07-25 16:08:03', NULL, '2023-07-25 16:08:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2289, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-27 18:50:21', '1', '2023-07-27 18:50:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2290, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-27 18:58:39', NULL, '2023-07-27 18:58:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2291, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-28 10:26:49', '1', '2023-07-28 10:26:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2292, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-28 10:38:16', NULL, '2023-07-28 10:38:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2293, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-28 10:40:20', NULL, '2023-07-28 10:40:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2294, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-28 10:41:30', NULL, '2023-07-28 10:41:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2295, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', '1', '2023-07-28 10:42:58', '1', '2023-07-28 10:42:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2296, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36', NULL, '2023-07-29 17:32:36', NULL, '2023-07-29 17:32:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2297, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', '1', '2023-08-03 16:24:17', '1', '2023-08-03 16:24:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2298, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, '2023-08-03 16:24:29', NULL, '2023-08-03 16:24:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2299, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', '1', '2023-08-06 18:07:59', '1', '2023-08-06 18:07:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2300, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, '2023-08-06 18:08:12', NULL, '2023-08-06 18:08:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2301, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', '1', '2023-08-08 16:47:00', '1', '2023-08-08 16:47:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2302, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, '2023-08-08 16:47:12', NULL, '2023-08-08 16:47:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2303, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', '1', '2023-08-09 16:57:54', '1', '2023-08-09 16:57:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2304, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, '2023-08-09 16:58:07', NULL, '2023-08-09 16:58:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2305, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', NULL, '2023-08-12 09:57:05', NULL, '2023-08-12 09:57:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2306, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', NULL, '2023-08-12 10:18:07', NULL, '2023-08-12 10:18:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2307, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', NULL, '2023-08-12 11:39:26', NULL, '2023-08-12 11:39:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2308, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:44:07', '4', '2023-08-12 11:44:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2309, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:46:12', '4', '2023-08-12 11:46:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2310, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:46:40', '4', '2023-08-12 11:46:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2311, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:48:36', '4', '2023-08-12 11:48:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2312, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:49:10', '4', '2023-08-12 11:49:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2313, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.03.2006090 MicroMessenger/7.0.4 Language/zh_CN webview/', '4', '2023-08-12 11:53:12', '4', '2023-08-12 11:53:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2314, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 11:57:41', NULL, '2023-08-12 11:57:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2315, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:06:34', '4', '2023-08-12 12:06:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2316, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:07:29', '4', '2023-08-12 12:07:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2317, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:43:10', '4', '2023-08-12 12:43:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2318, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:46:54', '4', '2023-08-12 12:46:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2319, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:48:00', '4', '2023-08-12 12:48:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2320, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:48:52', '4', '2023-08-12 12:48:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2321, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 12:51:38', '4', '2023-08-12 12:51:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2322, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 13:03:39', '4', '2023-08-12 13:03:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2323, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '4', '2023-08-12 13:07:28', '4', '2023-08-12 13:07:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2324, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:10:12', NULL, '2023-08-12 13:10:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2325, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:10:17', NULL, '2023-08-12 13:10:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2326, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:12:56', NULL, '2023-08-12 13:12:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2327, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:14:01', NULL, '2023-08-12 13:14:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2328, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:18:24', NULL, '2023-08-12 13:18:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2329, 101, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:27:46', NULL, '2023-08-12 13:27:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2330, 101, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:28:06', NULL, '2023-08-12 13:28:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2331, 101, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:30:16', NULL, '2023-08-12 13:30:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2332, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:31:59', NULL, '2023-08-12 13:31:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2333, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:32:43', NULL, '2023-08-12 13:32:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2334, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:32:59', NULL, '2023-08-12 13:32:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2335, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 13:37:13', NULL, '2023-08-12 13:37:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2336, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 15:47:13', NULL, '2023-08-12 15:47:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2337, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 16:08:19', NULL, '2023-08-12 16:08:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2338, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 16:17:09', NULL, '2023-08-12 16:17:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2339, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 16:53:38', NULL, '2023-08-12 16:53:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2340, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 16:58:05', NULL, '2023-08-12 16:58:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2341, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 16:58:51', NULL, '2023-08-12 16:58:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2342, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 17:01:27', NULL, '2023-08-12 17:01:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2343, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-12 17:03:12', NULL, '2023-08-12 17:03:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2344, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 16:28:41', NULL, '2023-08-14 16:28:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2345, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 16:29:08', NULL, '2023-08-14 16:29:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2346, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 16:55:19', NULL, '2023-08-14 16:55:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2347, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 16:57:21', NULL, '2023-08-14 16:57:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2348, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 16:57:25', NULL, '2023-08-14 16:57:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2349, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:03:43', NULL, '2023-08-14 17:03:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2350, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:05:08', NULL, '2023-08-14 17:05:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2351, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:07:46', NULL, '2023-08-14 17:07:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2352, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:16:57', NULL, '2023-08-14 17:16:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2353, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:17:53', NULL, '2023-08-14 17:17:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2354, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-14 17:29:57', NULL, '2023-08-14 17:29:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2355, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, '2023-08-15 10:23:58', NULL, '2023-08-15 10:23:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2356, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 10:46:28', NULL, '2023-08-16 10:46:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2357, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 16:39:44', NULL, '2023-08-16 16:39:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2358, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 16:41:49', NULL, '2023-08-16 16:41:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2359, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 16:52:24', NULL, '2023-08-16 16:52:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2360, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 17:08:32', NULL, '2023-08-16 17:08:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2361, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 17:10:14', NULL, '2023-08-16 17:10:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2362, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 17:13:51', NULL, '2023-08-16 17:13:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2363, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 17:40:29', NULL, '2023-08-16 17:40:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2364, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:13:47', NULL, '2023-08-16 18:13:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2365, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:21:38', NULL, '2023-08-16 18:21:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2366, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:23:31', NULL, '2023-08-16 18:23:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2367, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:24:37', NULL, '2023-08-16 18:24:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2368, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:29:57', NULL, '2023-08-16 18:29:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2369, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-16 18:31:04', NULL, '2023-08-16 18:31:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2370, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 10:48:10', NULL, '2023-08-17 10:48:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2371, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 10:55:42', NULL, '2023-08-17 10:55:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2372, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 10:58:17', NULL, '2023-08-17 10:58:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2373, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 11:01:20', NULL, '2023-08-17 11:01:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2374, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:15:07', NULL, '2023-08-17 16:15:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2375, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:25:04', NULL, '2023-08-17 16:25:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2376, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:26:47', NULL, '2023-08-17 16:26:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2377, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:33:43', NULL, '2023-08-17 16:33:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2378, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:49:04', NULL, '2023-08-17 16:49:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2379, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:52:42', NULL, '2023-08-17 16:52:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2380, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 16:57:37', NULL, '2023-08-17 16:57:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2381, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 17:01:17', NULL, '2023-08-17 17:01:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2382, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 17:04:39', NULL, '2023-08-17 17:04:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2383, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-17 17:08:50', NULL, '2023-08-17 17:08:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2384, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:35:35', NULL, '2023-08-19 09:35:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2385, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:36:15', NULL, '2023-08-19 09:36:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2386, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:38:03', NULL, '2023-08-19 09:38:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2387, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:51:19', NULL, '2023-08-19 09:51:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2388, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:52:37', NULL, '2023-08-19 09:52:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2389, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:53:36', NULL, '2023-08-19 09:53:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2390, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:54:31', NULL, '2023-08-19 09:54:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2391, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:54:59', NULL, '2023-08-19 09:54:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2392, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:58:50', NULL, '2023-08-19 09:58:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2393, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:59:54', NULL, '2023-08-19 09:59:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2394, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 09:59:55', NULL, '2023-08-19 09:59:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2395, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-19 10:00:09', '6', '2023-08-19 10:00:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2396, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 10:04:24', NULL, '2023-08-19 10:04:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2397, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-19 10:05:21', '6', '2023-08-19 10:05:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2398, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 10:52:37', NULL, '2023-08-19 10:52:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2399, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-19 10:53:06', NULL, '2023-08-19 10:53:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2400, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-19 10:53:37', '6', '2023-08-19 10:53:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2401, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 10:51:45', NULL, '2023-08-20 10:51:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2402, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-20 10:52:26', '6', '2023-08-20 10:52:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2403, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 10:53:55', NULL, '2023-08-20 10:53:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2404, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-20 10:54:19', '6', '2023-08-20 10:54:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2405, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 10:54:56', NULL, '2023-08-20 10:54:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2406, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-20 10:55:16', '6', '2023-08-20 10:55:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2407, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 11:42:34', NULL, '2023-08-20 11:42:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2408, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 16:18:20', NULL, '2023-08-20 16:18:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2409, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 16:18:24', NULL, '2023-08-20 16:18:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2410, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-20 16:21:10', '6', '2023-08-20 16:21:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2411, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 16:28:28', NULL, '2023-08-20 16:28:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2412, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-20 16:39:39', NULL, '2023-08-20 16:39:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2413, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 09:57:33', NULL, '2023-08-21 09:57:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2414, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:00:43', NULL, '2023-08-21 10:00:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2415, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:02:31', NULL, '2023-08-21 10:02:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2416, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:34:18', NULL, '2023-08-21 10:34:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2417, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:44:34', NULL, '2023-08-21 10:44:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2418, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:46:19', NULL, '2023-08-21 10:46:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2419, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:46:22', NULL, '2023-08-21 10:46:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2420, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:46:27', NULL, '2023-08-21 10:46:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2421, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:47:59', NULL, '2023-08-21 10:47:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2422, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:48:05', NULL, '2023-08-21 10:48:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2423, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:49:59', NULL, '2023-08-21 10:49:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2424, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:53:00', NULL, '2023-08-21 10:53:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2425, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:53:46', NULL, '2023-08-21 10:53:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2426, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:55:11', NULL, '2023-08-21 10:55:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2427, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-21 10:56:36', NULL, '2023-08-21 10:56:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2428, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-22 11:00:56', NULL, '2023-08-22 11:00:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2429, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-22 11:14:08', NULL, '2023-08-22 11:14:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2430, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-22 11:23:11', NULL, '2023-08-22 11:23:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2431, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-22 11:53:51', NULL, '2023-08-22 11:53:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2432, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:23:55', NULL, '2023-08-24 11:23:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2433, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:24:52', NULL, '2023-08-24 11:24:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2434, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:30:46', NULL, '2023-08-24 11:30:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2435, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:31:45', NULL, '2023-08-24 11:31:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2436, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:31:51', NULL, '2023-08-24 11:31:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2437, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 11:46:50', NULL, '2023-08-24 11:46:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2438, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 17:01:48', NULL, '2023-08-24 17:01:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2439, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 17:05:15', NULL, '2023-08-24 17:05:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2440, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 18:07:26', NULL, '2023-08-24 18:07:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2441, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-24 18:11:17', NULL, '2023-08-24 18:11:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2442, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-25 18:42:44', NULL, '2023-08-25 18:42:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2443, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 09:45:46', NULL, '2023-08-26 09:45:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2444, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 11:07:15', NULL, '2023-08-26 11:07:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2445, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 11:14:54', NULL, '2023-08-26 11:14:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2446, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 11:16:52', NULL, '2023-08-26 11:16:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2447, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 11:44:25', NULL, '2023-08-26 11:44:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2448, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 11:48:41', NULL, '2023-08-26 11:48:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2449, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 16:18:00', NULL, '2023-08-26 16:18:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2450, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 16:27:09', NULL, '2023-08-26 16:27:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2451, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 16:27:39', NULL, '2023-08-26 16:27:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2452, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-26 16:28:24', '6', '2023-08-26 16:28:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2453, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-08-26 16:28:29', '6', '2023-08-26 16:28:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2454, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 16:59:54', NULL, '2023-08-26 16:59:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2455, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 17:08:45', NULL, '2023-08-26 17:08:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2456, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 17:28:43', NULL, '2023-08-26 17:28:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2457, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-26 17:29:20', NULL, '2023-08-26 17:29:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2458, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-28 16:48:58', NULL, '2023-08-28 16:48:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2459, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-28 17:23:21', NULL, '2023-08-28 17:23:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2460, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-30 17:12:11', NULL, '2023-08-30 17:12:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2461, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-30 17:18:27', NULL, '2023-08-30 17:18:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2462, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-30 17:19:21', NULL, '2023-08-30 17:19:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2463, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-30 17:56:15', NULL, '2023-08-30 17:56:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2464, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-30 18:52:17', NULL, '2023-08-30 18:52:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2465, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 09:29:04', NULL, '2023-08-31 09:29:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2466, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 09:30:11', NULL, '2023-08-31 09:30:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2467, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 11:44:35', NULL, '2023-08-31 11:44:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2468, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 11:49:38', NULL, '2023-08-31 11:49:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2469, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 11:53:04', NULL, '2023-08-31 11:53:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2470, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-08-31 11:58:07', NULL, '2023-08-31 11:58:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2471, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 09:29:05', NULL, '2023-09-01 09:29:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2472, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 09:29:37', NULL, '2023-09-01 09:29:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2473, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 09:42:34', NULL, '2023-09-01 09:42:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2474, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 09:48:37', NULL, '2023-09-01 09:48:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2475, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:24:15', NULL, '2023-09-01 17:24:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2476, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:36:30', NULL, '2023-09-01 17:36:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2477, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:38:18', NULL, '2023-09-01 17:38:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2478, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:40:56', NULL, '2023-09-01 17:40:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2479, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:43:33', NULL, '2023-09-01 17:43:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2480, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 17:44:23', NULL, '2023-09-01 17:44:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2481, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:18:28', NULL, '2023-09-01 18:18:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2482, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:18:55', NULL, '2023-09-01 18:18:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2483, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:22:52', NULL, '2023-09-01 18:22:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2484, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:28:07', NULL, '2023-09-01 18:28:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2485, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:35:45', NULL, '2023-09-01 18:35:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2486, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:39:02', NULL, '2023-09-01 18:39:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2487, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:39:23', NULL, '2023-09-01 18:39:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2488, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:39:50', NULL, '2023-09-01 18:39:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2489, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:41:12', NULL, '2023-09-01 18:41:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2490, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:41:17', NULL, '2023-09-01 18:41:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2491, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:45:26', NULL, '2023-09-01 18:45:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2492, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:45:35', NULL, '2023-09-01 18:45:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2493, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:48:25', NULL, '2023-09-01 18:48:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2494, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:50:54', NULL, '2023-09-01 18:50:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2495, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:51:16', NULL, '2023-09-01 18:51:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2496, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:51:33', NULL, '2023-09-01 18:51:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2497, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:52:44', NULL, '2023-09-01 18:52:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2498, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-01 18:56:35', NULL, '2023-09-01 18:56:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2499, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:05:13', NULL, '2023-09-03 16:05:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2500, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:09:16', NULL, '2023-09-03 16:09:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2501, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:11:02', NULL, '2023-09-03 16:11:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2502, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:11:47', NULL, '2023-09-03 16:11:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2503, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:13:24', NULL, '2023-09-03 16:13:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2504, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:14:27', NULL, '2023-09-03 16:14:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2505, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:15:45', NULL, '2023-09-03 16:15:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2506, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:16:17', NULL, '2023-09-03 16:16:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2507, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:16:56', NULL, '2023-09-03 16:16:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2508, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:17:33', NULL, '2023-09-03 16:17:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2509, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:17:57', NULL, '2023-09-03 16:17:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2510, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:18:14', NULL, '2023-09-03 16:18:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2511, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:18:36', NULL, '2023-09-03 16:18:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2512, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:21:35', NULL, '2023-09-03 16:21:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2513, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:22:10', NULL, '2023-09-03 16:22:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2514, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:22:40', NULL, '2023-09-03 16:22:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2515, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:25:17', NULL, '2023-09-03 16:25:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2516, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:29:14', NULL, '2023-09-03 16:29:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2517, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:29:29', NULL, '2023-09-03 16:29:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2518, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:33:23', NULL, '2023-09-03 16:33:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2519, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:37:48', NULL, '2023-09-03 16:37:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2520, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:38:17', NULL, '2023-09-03 16:38:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2521, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:40:50', NULL, '2023-09-03 16:40:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2522, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:41:35', NULL, '2023-09-03 16:41:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2523, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-09-03 16:48:32', '6', '2023-09-03 16:48:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2524, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 16:50:36', NULL, '2023-09-03 16:50:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2525, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:14:23', NULL, '2023-09-03 17:14:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2526, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:19:03', NULL, '2023-09-03 17:19:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2527, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:25:25', NULL, '2023-09-03 17:25:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2528, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:26:14', NULL, '2023-09-03 17:26:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2529, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:26:55', NULL, '2023-09-03 17:26:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2530, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:30:27', NULL, '2023-09-03 17:30:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2531, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:35:06', NULL, '2023-09-03 17:35:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2532, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:36:20', NULL, '2023-09-03 17:36:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2533, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:37:22', NULL, '2023-09-03 17:37:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2534, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:47:02', NULL, '2023-09-03 17:47:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2535, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 17:48:54', NULL, '2023-09-03 17:48:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2536, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-03 18:17:55', NULL, '2023-09-03 18:17:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2537, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 09:55:30', NULL, '2023-09-04 09:55:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2538, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:15:17', NULL, '2023-09-04 10:15:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2539, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:17:29', NULL, '2023-09-04 10:17:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2540, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:37:46', NULL, '2023-09-04 10:37:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2541, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:45:08', NULL, '2023-09-04 10:45:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2542, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:46:30', NULL, '2023-09-04 10:46:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2543, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:48:22', NULL, '2023-09-04 10:48:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2544, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:51:10', NULL, '2023-09-04 10:51:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2545, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:52:24', NULL, '2023-09-04 10:52:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2546, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 10:54:11', NULL, '2023-09-04 10:54:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2547, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 11:53:57', NULL, '2023-09-04 11:53:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2548, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 11:54:37', NULL, '2023-09-04 11:54:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2549, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 11:56:53', NULL, '2023-09-04 11:56:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2550, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 14:14:53', NULL, '2023-09-04 14:14:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2551, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 14:17:32', NULL, '2023-09-04 14:17:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2552, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 14:18:23', NULL, '2023-09-04 14:18:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2553, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 14:19:25', NULL, '2023-09-04 14:19:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2554, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 14:20:38', NULL, '2023-09-04 14:20:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2555, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-04 17:03:41', '1', '2023-09-04 17:03:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2556, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-04 17:03:51', NULL, '2023-09-04 17:03:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2557, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 17:12:14', NULL, '2023-09-04 17:12:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2558, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-04 18:33:24', '1', '2023-09-04 18:33:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2559, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-04 18:35:51', NULL, '2023-09-04 18:35:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2560, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:40:58', NULL, '2023-09-04 18:40:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2561, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:43:23', NULL, '2023-09-04 18:43:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2562, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:43:45', NULL, '2023-09-04 18:43:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2563, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:44:50', NULL, '2023-09-04 18:44:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2564, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:45:00', NULL, '2023-09-04 18:45:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2565, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:45:41', NULL, '2023-09-04 18:45:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2566, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:46:12', NULL, '2023-09-04 18:46:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2567, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:47:14', NULL, '2023-09-04 18:47:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2568, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:49:08', NULL, '2023-09-04 18:49:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2569, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-04 18:51:37', NULL, '2023-09-04 18:51:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2570, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:21:22', NULL, '2023-09-05 09:21:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2571, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:21:58', NULL, '2023-09-05 09:21:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2572, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:25:19', NULL, '2023-09-05 09:25:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2573, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:26:22', NULL, '2023-09-05 09:26:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2574, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:31:33', NULL, '2023-09-05 09:31:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2575, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:36:28', NULL, '2023-09-05 09:36:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2576, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 09:57:55', NULL, '2023-09-05 09:57:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2577, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-05 10:06:37', NULL, '2023-09-05 10:06:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2578, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 10:07:41', NULL, '2023-09-05 10:07:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2579, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 10:41:39', '1', '2023-09-05 10:41:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2580, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 11:05:37', NULL, '2023-09-05 11:05:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2581, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 14:37:52', '1', '2023-09-05 14:37:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2582, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:38:30', NULL, '2023-09-05 14:38:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2583, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:39:15', NULL, '2023-09-05 14:39:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2584, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:40:56', NULL, '2023-09-05 14:40:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2585, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 14:43:10', '1', '2023-09-05 14:43:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2586, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:43:25', NULL, '2023-09-05 14:43:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2587, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:45:16', NULL, '2023-09-05 14:45:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2588, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:46:18', NULL, '2023-09-05 14:46:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2589, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 14:48:17', '1', '2023-09-05 14:48:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2590, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:48:33', NULL, '2023-09-05 14:48:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2591, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:51:11', NULL, '2023-09-05 14:51:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2592, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 14:56:30', '1', '2023-09-05 14:56:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2593, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 14:57:33', NULL, '2023-09-05 14:57:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2594, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:12:16', NULL, '2023-09-05 16:12:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2595, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 16:19:29', '1', '2023-09-05 16:19:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2596, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:19:45', NULL, '2023-09-05 16:19:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2597, 200, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-09-05 16:29:22', '126', '2023-09-05 16:29:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2598, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:29:27', NULL, '2023-09-05 16:29:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2599, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-05 16:30:41', '1', '2023-09-05 16:30:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2600, 100, '', 0, 2, 'yxiang001', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:30:56', NULL, '2023-09-05 16:30:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2601, 100, '', 0, 2, 'yxiang001', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:31:09', NULL, '2023-09-05 16:31:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2602, 100, '', 0, 2, 'yixiang01', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:31:32', NULL, '2023-09-05 16:31:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2603, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:32:47', NULL, '2023-09-05 16:32:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2604, 200, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-09-05 16:49:46', '126', '2023-09-05 16:49:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2605, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 16:50:26', NULL, '2023-09-05 16:50:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2606, 200, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-09-05 17:05:44', '126', '2023-09-05 17:05:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2607, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 17:06:10', NULL, '2023-09-05 17:06:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2608, 200, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-09-05 17:38:00', '126', '2023-09-05 17:38:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2609, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-05 17:40:45', NULL, '2023-09-05 17:40:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2610, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-06 10:36:11', '1', '2023-09-06 10:36:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2611, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-06 10:36:19', NULL, '2023-09-06 10:36:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2612, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 10:05:31', NULL, '2023-09-07 10:05:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2613, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 10:58:57', NULL, '2023-09-07 10:58:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2614, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 11:03:52', NULL, '2023-09-07 11:03:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2615, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 11:08:52', NULL, '2023-09-07 11:08:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2616, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 11:17:42', NULL, '2023-09-07 11:17:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2617, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 11:20:42', NULL, '2023-09-07 11:20:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2618, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 11:21:52', NULL, '2023-09-07 11:21:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2619, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 13:59:33', NULL, '2023-09-07 13:59:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2620, 104, '', 7, 1, '15136175247', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 14:45:11', NULL, '2023-09-07 14:45:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2621, 104, '', 7, 1, '15136175247', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 14:51:35', NULL, '2023-09-07 14:51:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2622, 104, '', 8, 1, '15136175244', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 14:53:47', NULL, '2023-09-07 14:53:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2623, 104, '', 9, 1, '15136175221', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 15:02:48', NULL, '2023-09-07 15:02:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2624, 104, '', 2, 1, '15136175245', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 15:09:38', NULL, '2023-09-07 15:09:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2625, 104, '', 2, 1, '15136175245', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', '2', '2023-09-07 15:11:38', '2', '2023-09-07 15:11:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2626, 104, '', 2, 1, '15136175245', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 15:14:32', NULL, '2023-09-07 15:14:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2627, 104, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 15:18:47', NULL, '2023-09-07 15:18:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2628, 104, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 16:44:47', NULL, '2023-09-07 16:44:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2629, 104, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 16:48:02', NULL, '2023-09-07 16:48:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2630, 104, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 16:52:55', NULL, '2023-09-07 16:52:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2631, 104, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 17:45:26', NULL, '2023-09-07 17:45:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2632, 104, '', 7, 1, '15136175247', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 17:46:05', NULL, '2023-09-07 17:46:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2633, 104, '', 2, 1, '15136175245', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 17:47:00', NULL, '2023-09-07 17:47:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2634, 104, '', 10, 1, '15136175242', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 17:47:33', NULL, '2023-09-07 17:47:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2635, 104, '', 11, 1, '15136175243', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-07 17:54:25', NULL, '2023-09-07 17:54:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2636, 104, '', 12, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-07 17:57:39', NULL, '2023-09-07 17:57:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2637, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-07 18:21:24', NULL, '2023-09-07 18:21:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2638, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 09:56:08', NULL, '2023-09-09 09:56:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2639, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '6', '2023-09-09 17:15:37', '6', '2023-09-09 17:15:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2640, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 17:20:45', NULL, '2023-09-09 17:20:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2641, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 17:23:41', NULL, '2023-09-09 17:23:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2642, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 17:28:09', NULL, '2023-09-09 17:28:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2643, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 17:30:29', NULL, '2023-09-09 17:30:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2644, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-09 17:33:01', NULL, '2023-09-09 17:33:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2645, 101, '', 6, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-11 16:25:10', NULL, '2023-09-11 16:25:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2646, 101, '', 13, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-11 16:28:11', NULL, '2023-09-11 16:28:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2647, 101, '', 13, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-12 18:10:48', NULL, '2023-09-12 18:10:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2648, 101, '', 13, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-12 18:24:10', NULL, '2023-09-12 18:24:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2649, 100, '', 1, 2, 'admin', 0, '223.91.183.56', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-13 19:18:33', NULL, '2023-09-13 19:18:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2650, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 08:53:18', NULL, '2023-09-14 08:53:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2651, 100, '', 1, 2, 'admin', 0, '223.91.183.56', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-14 09:39:04', NULL, '2023-09-14 09:39:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2652, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 10:25:52', NULL, '2023-09-14 10:25:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2653, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 10:30:11', NULL, '2023-09-14 10:30:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2654, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 16:39:22', NULL, '2023-09-14 16:39:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2655, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 16:39:53', NULL, '2023-09-14 16:39:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2656, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 17:28:45', NULL, '2023-09-14 17:28:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2657, 200, '', 1, 2, 'admin', 0, '223.91.183.56', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-14 17:35:31', '1', '2023-09-14 17:35:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2658, 100, '', 1, 2, 'admin', 0, '223.91.183.56', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-14 17:35:54', NULL, '2023-09-14 17:35:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2659, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 18:02:42', NULL, '2023-09-14 18:02:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2660, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-14 18:23:24', NULL, '2023-09-14 18:23:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2661, 101, '', 13, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', NULL, '2023-09-15 10:23:55', NULL, '2023-09-15 10:23:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2662, 101, '', 14, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', NULL, '2023-09-15 16:48:16', NULL, '2023-09-15 16:48:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2663, 101, '', 14, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', '14', '2023-09-15 16:52:16', '14', '2023-09-15 16:52:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2664, 101, '', 1, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', NULL, '2023-09-15 16:54:16', NULL, '2023-09-15 16:54:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2665, 101, '', 2, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', NULL, '2023-09-15 17:01:37', NULL, '2023-09-15 17:01:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2666, 101, '', 2, 1, '15136175246', 0, '223.91.183.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292e) NetType/WIFI Language/zh_CN', '2', '2023-09-15 17:03:14', '2', '2023-09-15 17:03:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2667, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 11:25:58', NULL, '2023-09-18 11:25:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2668, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:26:35', '2', '2023-09-18 11:26:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2669, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:27:49', '2', '2023-09-18 11:27:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2670, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:30:02', '2', '2023-09-18 11:30:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2671, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:36:08', '2', '2023-09-18 11:36:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2672, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:41:03', '2', '2023-09-18 11:41:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2673, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:42:16', '2', '2023-09-18 11:42:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2674, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:44:42', '2', '2023-09-18 11:44:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2675, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:45:32', '2', '2023-09-18 11:45:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2676, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 11:46:37', NULL, '2023-09-18 11:46:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2677, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 11:48:16', NULL, '2023-09-18 11:48:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2678, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:50:58', '2', '2023-09-18 11:50:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2679, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 11:57:20', '2', '2023-09-18 11:57:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2680, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 11:57:40', NULL, '2023-09-18 11:57:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2681, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 11:58:23', NULL, '2023-09-18 11:58:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2682, 101, '', 2, 1, '15136175246', 0, '223.91.183.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 11:59:11', NULL, '2023-09-18 11:59:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2683, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 15:41:55', NULL, '2023-09-18 15:41:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2684, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 15:49:14', '2', '2023-09-18 15:49:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2685, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 15:49:15', '2', '2023-09-18 15:49:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2686, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 15:52:11', '2', '2023-09-18 15:52:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2687, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:14:17', '2', '2023-09-18 16:14:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2688, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:15:31', '2', '2023-09-18 16:15:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2689, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:22:22', '2', '2023-09-18 16:22:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2690, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:24:58', '2', '2023-09-18 16:24:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2691, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:25:02', '2', '2023-09-18 16:25:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2692, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:25:10', '2', '2023-09-18 16:25:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2693, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 16:25:16', NULL, '2023-09-18 16:25:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2694, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:27:00', '2', '2023-09-18 16:27:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2695, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:28:19', NULL, '2023-09-18 16:28:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2696, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:30:03', NULL, '2023-09-18 16:30:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2697, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:30:50', NULL, '2023-09-18 16:30:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2698, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:31:07', NULL, '2023-09-18 16:31:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2699, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:31:28', NULL, '2023-09-18 16:31:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2700, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:32:27', NULL, '2023-09-18 16:32:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2701, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:32:44', NULL, '2023-09-18 16:32:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2702, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:33:00', NULL, '2023-09-18 16:33:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2703, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:33:19', NULL, '2023-09-18 16:33:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2704, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:33:33', NULL, '2023-09-18 16:33:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2705, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:33:50', NULL, '2023-09-18 16:33:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2706, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:34:05', NULL, '2023-09-18 16:34:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2707, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:34:43', NULL, '2023-09-18 16:34:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2708, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:35:17', NULL, '2023-09-18 16:35:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (2709, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 16:35:52', NULL, '2023-09-18 16:35:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2710, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:45:41', '2', '2023-09-18 16:45:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2711, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:48:01', NULL, '2023-09-18 16:48:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2712, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 16:48:31', NULL, '2023-09-18 16:48:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2713, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 16:56:41', '2', '2023-09-18 16:56:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2714, 104, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 16:58:51', NULL, '2023-09-18 16:58:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2715, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 17:02:02', NULL, '2023-09-18 17:02:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2716, 104, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-18 17:02:37', NULL, '2023-09-18 17:02:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2717, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 17:04:20', NULL, '2023-09-18 17:04:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2718, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 17:04:28', NULL, '2023-09-18 17:04:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2719, 104, '', 3, 1, '15136176246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-18 17:07:29', NULL, '2023-09-18 17:07:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2720, 104, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-18 17:08:04', NULL, '2023-09-18 17:08:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2721, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 17:27:43', NULL, '2023-09-18 17:27:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2722, 101, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-18 17:28:13', NULL, '2023-09-18 17:28:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2723, 104, '', 2, 1, '15136175246', 0, '223.91.183.134', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 18:03:00', NULL, '2023-09-18 18:03:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2724, 104, '', 2, 1, '15136175246', 0, '223.91.183.37', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 18:16:14', NULL, '2023-09-18 18:16:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2725, 104, '', 2, 1, '15136175246', 0, '223.91.183.37', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.3 Mobile/15E148 Safari/604.1', NULL, '2023-09-18 18:19:44', NULL, '2023-09-18 18:19:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2726, 104, '', 2, 1, '15136175246', 0, '223.91.183.37', 'Mozilla/5.0 (Linux; U; Android 10; zh-CN; MI 9 SE Build/QKQ1.190828.002) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/100.0.4896.58 UCBrowser/16.0.8.1259 Mobile Safari/537.36', NULL, '2023-09-18 18:30:58', NULL, '2023-09-18 18:30:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2727, 200, '', 1, 2, 'admin', 0, '223.91.183.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-18 22:19:09', '1', '2023-09-18 22:19:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2728, 100, '', 126, 2, 'yixiang001', 10, '223.91.183.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-18 22:19:22', NULL, '2023-09-18 22:19:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2729, 100, '', 126, 2, 'yixiang001', 10, '223.91.183.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-18 22:19:49', NULL, '2023-09-18 22:19:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2730, 100, '', 126, 2, 'yixiang001', 0, '223.91.183.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-18 22:20:01', NULL, '2023-09-18 22:20:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2731, 200, '', 126, 2, 'yixiang001', 0, '223.91.183.95', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-09-18 22:20:13', '126', '2023-09-18 22:20:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2732, 101, '', 2, 1, '15136175246', 0, '223.91.183.95', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', NULL, '2023-09-18 22:31:31', NULL, '2023-09-18 22:31:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2733, 101, '', 2, 1, '15136175246', 0, '223.91.183.95', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 22:34:08', '2', '2023-09-18 22:34:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2734, 101, '', 2, 1, '15136175246', 0, '223.91.183.95', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.41(0x1800292f) NetType/WIFI Language/zh_CN', '2', '2023-09-18 22:34:22', '2', '2023-09-18 22:34:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2735, 100, '', 1, 2, 'admin', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-19 09:50:20', NULL, '2023-09-19 09:50:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2736, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-19 09:51:37', NULL, '2023-09-19 09:51:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2737, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-19 13:02:04', NULL, '2023-09-19 13:02:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2738, 104, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36', NULL, '2023-09-21 23:25:36', NULL, '2023-09-21 23:25:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2739, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-09-22 18:15:28', '1', '2023-09-22 18:15:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2740, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-22 18:15:41', NULL, '2023-09-22 18:15:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2741, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-09-25 18:16:52', NULL, '2023-09-25 18:16:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2742, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-09-25 18:23:31', NULL, '2023-09-25 18:23:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2743, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-07 10:59:49', '2', '2023-10-07 10:59:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2744, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:00:44', NULL, '2023-10-07 11:00:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2745, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-10-07 11:04:30', '1', '2023-10-07 11:04:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2746, 100, '', 0, 2, 'yixiaing001', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:04:45', NULL, '2023-10-07 11:04:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2747, 100, '', 0, 2, 'yixiang01', 10, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:05:12', NULL, '2023-10-07 11:05:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2748, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:05:26', NULL, '2023-10-07 11:05:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2749, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '1', '2023-10-07 11:05:42', '1', '2023-10-07 11:05:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2750, 100, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:05:53', NULL, '2023-10-07 11:05:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2751, 200, '', 126, 2, 'yixiang001', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', '126', '2023-10-07 11:08:15', '126', '2023-10-07 11:08:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2752, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', NULL, '2023-10-07 11:08:21', NULL, '2023-10-07 11:08:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2753, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-11 09:40:28', NULL, '2023-10-11 09:40:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2754, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 09:48:37', '2', '2023-10-11 09:48:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2755, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 09:54:22', '2', '2023-10-11 09:54:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2756, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 09:54:29', '2', '2023-10-11 09:54:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2757, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 09:55:21', '2', '2023-10-11 09:55:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2758, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 09:57:00', '2', '2023-10-11 09:57:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2759, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 10:00:15', '2', '2023-10-11 10:00:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2760, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 10:01:23', '2', '2023-10-11 10:01:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2761, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 10:01:34', '2', '2023-10-11 10:01:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2762, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:01:26', '2', '2023-10-11 14:01:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2763, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:01:52', '2', '2023-10-11 14:01:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2764, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:13:38', '2', '2023-10-11 14:13:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2765, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:18:24', '2', '2023-10-11 14:18:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2766, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:19:27', '2', '2023-10-11 14:19:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2767, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:21:30', '2', '2023-10-11 14:21:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2768, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:21:43', '2', '2023-10-11 14:21:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2769, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:24:06', '2', '2023-10-11 14:24:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2770, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:24:22', '2', '2023-10-11 14:24:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2771, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:24:42', '2', '2023-10-11 14:24:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2772, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-11 14:24:59', '2', '2023-10-11 14:24:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2773, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-11 17:02:08', NULL, '2023-10-11 17:02:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2774, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-13 16:14:24', NULL, '2023-10-13 16:14:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2775, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:27:16', '2', '2023-10-13 16:27:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2776, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:28:20', '2', '2023-10-13 16:28:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2777, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:29:41', '2', '2023-10-13 16:29:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2778, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:31:08', '2', '2023-10-13 16:31:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2779, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:31:29', '2', '2023-10-13 16:31:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2780, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:31:54', '2', '2023-10-13 16:31:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2781, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:33:40', '2', '2023-10-13 16:33:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2782, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:34:43', '2', '2023-10-13 16:34:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2783, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:37:13', '2', '2023-10-13 16:37:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2784, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:37:48', '2', '2023-10-13 16:37:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2785, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:42:19', '2', '2023-10-13 16:42:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2786, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:46:07', '2', '2023-10-13 16:46:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2787, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:48:12', '2', '2023-10-13 16:48:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2788, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:49:40', '2', '2023-10-13 16:49:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2789, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:51:21', '2', '2023-10-13 16:51:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2790, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:51:55', '2', '2023-10-13 16:51:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2791, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:53:33', '2', '2023-10-13 16:53:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2792, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:55:08', '2', '2023-10-13 16:55:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2793, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:55:36', '2', '2023-10-13 16:55:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (2794, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:58:14', '2', '2023-10-13 16:58:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2795, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:58:26', '2', '2023-10-13 16:58:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2796, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:59:11', '2', '2023-10-13 16:59:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2797, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 16:59:32', '2', '2023-10-13 16:59:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (2798, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:04:51', '2', '2023-10-13 17:04:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2799, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:05:16', '2', '2023-10-13 17:05:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2800, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:12:21', '2', '2023-10-13 17:12:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2801, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:13:08', '2', '2023-10-13 17:13:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2802, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:15:37', '2', '2023-10-13 17:15:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2803, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:16:03', '2', '2023-10-13 17:16:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2804, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:16:53', '2', '2023-10-13 17:16:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2805, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:18:16', '2', '2023-10-13 17:18:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2806, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:18:55', '2', '2023-10-13 17:18:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2807, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:19:14', '2', '2023-10-13 17:19:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2808, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:19:47', '2', '2023-10-13 17:19:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2809, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:20:09', '2', '2023-10-13 17:20:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2810, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:20:52', '2', '2023-10-13 17:20:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2811, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:21:16', '2', '2023-10-13 17:21:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2812, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:21:53', '2', '2023-10-13 17:21:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2813, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:25:57', '2', '2023-10-13 17:25:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2814, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:25:59', '2', '2023-10-13 17:25:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2815, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:26:03', '2', '2023-10-13 17:26:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2816, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:27:02', '2', '2023-10-13 17:27:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2817, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:28:12', '2', '2023-10-13 17:28:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2818, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:28:38', '2', '2023-10-13 17:28:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2819, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:29:29', '2', '2023-10-13 17:29:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2820, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:34:10', '2', '2023-10-13 17:34:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2821, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:35:12', '2', '2023-10-13 17:35:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2822, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:46:45', '2', '2023-10-13 17:46:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2823, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:49:42', '2', '2023-10-13 17:49:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2824, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:53:37', '2', '2023-10-13 17:53:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2825, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:53:48', '2', '2023-10-13 17:53:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2826, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:55:26', '2', '2023-10-13 17:55:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2827, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:56:27', '2', '2023-10-13 17:56:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2828, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:57:21', '2', '2023-10-13 17:57:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2829, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:58:15', '2', '2023-10-13 17:58:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2830, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 17:59:44', '2', '2023-10-13 17:59:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2831, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:00:45', '2', '2023-10-13 18:00:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2832, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:01:25', '2', '2023-10-13 18:01:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2833, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:02:35', '2', '2023-10-13 18:02:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2834, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:03:15', '2', '2023-10-13 18:03:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2835, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:07:00', '2', '2023-10-13 18:07:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2836, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:07:26', '2', '2023-10-13 18:07:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2837, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:07:50', '2', '2023-10-13 18:07:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2838, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:08:19', '2', '2023-10-13 18:08:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (2839, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:09:11', '2', '2023-10-13 18:09:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2840, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:10:00', '2', '2023-10-13 18:10:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2841, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:10:51', '2', '2023-10-13 18:10:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2842, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:11:12', '2', '2023-10-13 18:11:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2843, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:11:50', '2', '2023-10-13 18:11:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2844, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:12:54', '2', '2023-10-13 18:12:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2845, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:13:37', '2', '2023-10-13 18:13:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2846, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:14:16', '2', '2023-10-13 18:14:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2847, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:14:39', '2', '2023-10-13 18:14:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2848, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:15:45', '2', '2023-10-13 18:15:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2849, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:16:58', '2', '2023-10-13 18:16:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2850, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:17:22', '2', '2023-10-13 18:17:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2851, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:17:49', '2', '2023-10-13 18:17:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2852, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:18:58', '2', '2023-10-13 18:18:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2853, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-13 18:21:44', '2', '2023-10-13 18:21:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2854, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-16 09:46:09', NULL, '2023-10-16 09:46:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2855, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:48:23', '2', '2023-10-16 09:48:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2856, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:49:03', '2', '2023-10-16 09:49:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2857, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:49:54', '2', '2023-10-16 09:49:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2858, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:55:24', '2', '2023-10-16 09:55:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (2859, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:56:22', '2', '2023-10-16 09:56:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2860, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 09:58:27', '2', '2023-10-16 09:58:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2861, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:00:53', '2', '2023-10-16 10:00:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2862, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:01:27', '2', '2023-10-16 10:01:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2863, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:25:27', '2', '2023-10-16 10:25:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2864, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:28:53', '2', '2023-10-16 10:28:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2865, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:29:49', '2', '2023-10-16 10:29:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2866, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:33:08', '2', '2023-10-16 10:33:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2867, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:38:50', '2', '2023-10-16 10:38:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2868, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:40:15', '2', '2023-10-16 10:40:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2869, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:41:54', '2', '2023-10-16 10:41:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2870, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:51:58', '2', '2023-10-16 10:51:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2871, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-10-16 10:53:48', '2', '2023-10-16 10:53:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2872, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-16 10:55:06', NULL, '2023-10-16 10:55:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2873, 104, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-19 10:02:47', NULL, '2023-10-19 10:02:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2874, 101, '', 4, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-19 11:11:57', NULL, '2023-10-19 11:11:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2875, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-19 11:13:23', NULL, '2023-10-19 11:13:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (2876, 101, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-19 16:56:35', NULL, '2023-10-19 16:56:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2877, 101, '', 7, 1, '会敲代码的喵', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-20 16:39:01', NULL, '2023-10-20 16:39:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2878, 101, '', 7, 1, '会敲代码的喵', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-21 10:10:31', NULL, '2023-10-21 10:10:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (2879, 101, '', 7, 1, '会敲代码的喵', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-21 10:13:08', NULL, '2023-10-21 10:13:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2880, 101, '', 7, 1, '会敲代码的喵', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-21 11:33:54', NULL, '2023-10-21 11:33:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2881, 104, '', 8, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-21 11:35:08', NULL, '2023-10-21 11:35:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2882, 101, '', 7, 1, '会敲代码的喵', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 09:47:53', NULL, '2023-10-23 09:47:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2883, 104, '', 7, 1, '15136175523', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 09:48:21', NULL, '2023-10-23 09:48:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2884, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 09:53:34', NULL, '2023-10-23 09:53:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2885, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 10:12:14', NULL, '2023-10-23 10:12:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2886, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 10:19:16', NULL, '2023-10-23 10:19:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (2887, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 10:21:40', NULL, '2023-10-23 10:21:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (2888, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 10:25:09', NULL, '2023-10-23 10:25:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2889, 104, '', 7, 1, '15136175234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16977058259582767 webdebugger port/59094 token/694db8a96907a1c2011f59f06dc8d70b', NULL, '2023-10-23 10:33:28', NULL, '2023-10-23 10:33:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2890, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-27 17:20:47', NULL, '2023-10-27 17:20:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2891, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-27 17:23:30', NULL, '2023-10-27 17:23:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2892, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-27 17:38:02', NULL, '2023-10-27 17:38:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2893, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-27 17:40:44', NULL, '2023-10-27 17:40:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2894, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-28 16:37:01', NULL, '2023-10-28 16:37:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2895, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-31 11:35:39', NULL, '2023-10-31 11:35:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2896, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-31 11:44:06', NULL, '2023-10-31 11:44:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (2897, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-31 11:45:58', NULL, '2023-10-31 11:45:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2898, 104, '', 5, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-31 11:53:04', NULL, '2023-10-31 11:53:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2899, 104, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-10-31 12:02:55', NULL, '2023-10-31 12:02:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2900, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 16:53:10', '2', '2023-11-07 16:53:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2901, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 16:55:01', '2', '2023-11-07 16:55:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2902, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 16:55:41', '2', '2023-11-07 16:55:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (2903, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 16:56:13', '2', '2023-11-07 16:56:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2904, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 16:58:14', '2', '2023-11-07 16:58:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2905, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 17:01:50', '2', '2023-11-07 17:01:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2906, 101, '', 2, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '2', '2023-11-07 17:02:45', '2', '2023-11-07 17:02:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2907, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-11-07 17:17:45', NULL, '2023-11-07 17:17:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2908, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-07 17:30:05', '9', '2023-11-07 17:30:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2909, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-08 18:09:01', '9', '2023-11-08 18:09:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (2910, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-08 18:36:14', '9', '2023-11-08 18:36:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2911, 104, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/16994398210778007 webdebugger port/42562 token/2f58b55d41700b3c86e5c57f195a9804', NULL, '2023-11-08 18:43:37', NULL, '2023-11-08 18:43:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2912, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 11:55:58', '9', '2023-11-09 11:55:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2913, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 11:57:21', '9', '2023-11-09 11:57:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2914, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 11:58:28', '9', '2023-11-09 11:58:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (2915, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 12:00:21', '9', '2023-11-09 12:00:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (2916, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 12:01:58', '9', '2023-11-09 12:01:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (2917, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 12:14:45', '9', '2023-11-09 12:14:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2918, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 12:22:11', '9', '2023-11-09 12:22:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2919, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 15:01:56', '9', '2023-11-09 15:01:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (2920, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-09 15:02:10', '9', '2023-11-09 15:02:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2921, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 10:26:07', '9', '2023-11-10 10:26:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (2922, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 10:28:52', '9', '2023-11-10 10:28:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2923, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 10:29:43', '9', '2023-11-10 10:29:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2924, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 10:30:54', '9', '2023-11-10 10:30:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2925, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 16:21:26', '9', '2023-11-10 16:21:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2926, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 16:43:02', '9', '2023-11-10 16:43:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2927, 101, '', 9, 1, '15136175246', 0, '223.91.183.200', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-10 16:43:52', '9', '2023-11-10 16:43:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2928, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-11-16 11:58:49', NULL, '2023-11-16 11:58:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (2929, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 12:08:27', '9', '2023-11-16 12:08:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2930, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 12:10:15', '9', '2023-11-16 12:10:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (2931, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 12:10:30', '9', '2023-11-16 12:10:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2932, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 12:10:48', '9', '2023-11-16 12:10:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2933, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 14:08:26', '9', '2023-11-16 14:08:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (2934, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 14:58:29', '9', '2023-11-16 14:58:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2935, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 15:00:03', '9', '2023-11-16 15:00:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (2936, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 15:00:42', '9', '2023-11-16 15:00:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (2937, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 15:02:00', '9', '2023-11-16 15:02:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (2938, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 15:15:27', '9', '2023-11-16 15:15:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2939, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:23:18', '9', '2023-11-16 17:23:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2940, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:36:35', '9', '2023-11-16 17:36:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2941, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:45:10', '9', '2023-11-16 17:45:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2942, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:46:45', '9', '2023-11-16 17:46:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (2943, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:47:37', '9', '2023-11-16 17:47:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2944, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:47:52', '9', '2023-11-16 17:47:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2945, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:48:33', '9', '2023-11-16 17:48:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2946, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 17:53:39', '9', '2023-11-16 17:53:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (2947, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:08:13', '9', '2023-11-16 18:08:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2948, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:08:43', '9', '2023-11-16 18:08:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (2949, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:09:34', '9', '2023-11-16 18:09:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2950, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:11:37', '9', '2023-11-16 18:11:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (2951, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:12:54', '9', '2023-11-16 18:12:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (2952, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:15:22', '9', '2023-11-16 18:15:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (2953, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:21:09', '9', '2023-11-16 18:21:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (2954, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:22:59', '9', '2023-11-16 18:22:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (2955, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:23:33', '9', '2023-11-16 18:23:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2956, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:30:10', '9', '2023-11-16 18:30:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2957, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:33:46', '9', '2023-11-16 18:33:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2958, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:41:34', '9', '2023-11-16 18:41:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (2959, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:43:52', '9', '2023-11-16 18:43:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2960, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:45:10', '9', '2023-11-16 18:45:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2961, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:46:04', '9', '2023-11-16 18:46:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2962, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-16 18:46:33', '9', '2023-11-16 18:46:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2963, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 09:40:05', '9', '2023-11-17 09:40:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2964, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 09:46:18', '9', '2023-11-17 09:46:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2965, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:05:33', '9', '2023-11-17 10:05:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2966, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:08:27', '9', '2023-11-17 10:08:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (2967, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:13:33', '9', '2023-11-17 10:13:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (2968, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:17:20', '9', '2023-11-17 10:17:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2969, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:20:29', '9', '2023-11-17 10:20:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (2970, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:21:08', '9', '2023-11-17 10:21:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2971, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:21:51', '9', '2023-11-17 10:21:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (2972, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:31:18', '9', '2023-11-17 10:31:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (2973, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:35:11', '9', '2023-11-17 10:35:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (2974, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:48:35', '9', '2023-11-17 10:48:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (2975, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:51:05', '9', '2023-11-17 10:51:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (2976, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:54:48', '9', '2023-11-17 10:54:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (2977, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 10:55:10', '9', '2023-11-17 10:55:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (2978, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:16:25', '9', '2023-11-17 11:16:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (2979, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:17:20', '9', '2023-11-17 11:17:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (2980, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:25:04', '9', '2023-11-17 11:25:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (2981, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:27:47', '9', '2023-11-17 11:27:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2982, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:46:02', '9', '2023-11-17 11:46:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (2983, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:46:47', '9', '2023-11-17 11:46:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2984, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:48:46', '9', '2023-11-17 11:48:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2985, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-17 11:57:14', '9', '2023-11-17 11:57:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (2986, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-21 09:50:38', '9', '2023-11-21 09:50:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (2987, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-11-21 09:52:46', NULL, '2023-11-21 09:52:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (2988, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-21 10:00:53', '9', '2023-11-21 10:00:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (2989, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-21 10:04:30', '9', '2023-11-21 10:04:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (2990, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-21 16:44:47', '9', '2023-11-21 16:44:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (2991, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 09:48:52', '9', '2023-11-22 09:48:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (2992, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:21:55', '9', '2023-11-22 10:21:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (2993, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:23:12', '9', '2023-11-22 10:23:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (2994, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:29:13', '9', '2023-11-22 10:29:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (2995, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:30:57', '9', '2023-11-22 10:30:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (2996, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:38:44', '9', '2023-11-22 10:38:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (2997, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:44:08', '9', '2023-11-22 10:44:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (2998, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:52:50', '9', '2023-11-22 10:52:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (2999, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 10:59:18', '9', '2023-11-22 10:59:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (3000, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 11:13:53', '9', '2023-11-22 11:13:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (3001, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 11:17:00', '9', '2023-11-22 11:17:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (3002, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 11:17:26', '9', '2023-11-22 11:17:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (3003, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 11:17:45', '9', '2023-11-22 11:17:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (3004, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 11:18:08', '9', '2023-11-22 11:18:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (3005, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:06:24', '9', '2023-11-22 15:06:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3006, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:08:53', '9', '2023-11-22 15:08:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (3007, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:09:14', '9', '2023-11-22 15:09:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (3008, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:09:33', '9', '2023-11-22 15:09:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (3009, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:09:46', '9', '2023-11-22 15:09:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (3010, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:10:05', '9', '2023-11-22 15:10:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (3011, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:10:56', '9', '2023-11-22 15:10:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (3012, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:11:02', '9', '2023-11-22 15:11:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (3013, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:11:11', '9', '2023-11-22 15:11:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (3014, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:11:29', '9', '2023-11-22 15:11:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (3015, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:11:43', '9', '2023-11-22 15:11:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (3016, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:11:54', '9', '2023-11-22 15:11:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (3017, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:12:11', '9', '2023-11-22 15:12:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (3018, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:12:18', '9', '2023-11-22 15:12:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (3019, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:16:10', '9', '2023-11-22 15:16:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (3020, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:19:59', '9', '2023-11-22 15:19:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (3021, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-22 15:20:31', '9', '2023-11-22 15:20:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (3022, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-23 09:18:38', '9', '2023-11-23 09:18:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (3023, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-11-26 10:00:08', NULL, '2023-11-26 10:00:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (3024, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:04:56', '9', '2023-11-26 11:04:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (3025, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:07:44', '9', '2023-11-26 11:07:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (3026, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:12:27', '9', '2023-11-26 11:12:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (3027, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:12:43', '9', '2023-11-26 11:12:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (3028, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:18:01', '9', '2023-11-26 11:18:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (3029, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:18:38', '9', '2023-11-26 11:18:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (3030, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:19:56', '9', '2023-11-26 11:19:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (3031, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:22:28', '9', '2023-11-26 11:22:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (3032, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:31:27', '9', '2023-11-26 11:31:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (3033, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:31:42', '9', '2023-11-26 11:31:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (3034, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:31:51', '9', '2023-11-26 11:31:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (3035, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:32:02', '9', '2023-11-26 11:32:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (3036, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:32:10', '9', '2023-11-26 11:32:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (3037, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:33:54', '9', '2023-11-26 11:33:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (3038, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:34:07', '9', '2023-11-26 11:34:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (3039, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:34:15', '9', '2023-11-26 11:34:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3040, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:39:42', '9', '2023-11-26 11:39:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (3041, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:39:52', '9', '2023-11-26 11:39:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (3042, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 11:47:22', '9', '2023-11-26 11:47:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (3043, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:01:54', '9', '2023-11-26 12:01:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (3044, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:05:27', '9', '2023-11-26 12:05:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (3045, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:05:56', '9', '2023-11-26 12:05:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (3046, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:14:18', '9', '2023-11-26 12:14:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (3047, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:14:26', '9', '2023-11-26 12:14:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (3048, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:15:04', '9', '2023-11-26 12:15:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (3049, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:16:47', '9', '2023-11-26 12:16:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (3050, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 12:25:03', '9', '2023-11-26 12:25:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (3051, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 12:26:19', '9', '2023-11-26 12:26:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (3052, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 15:58:43', '9', '2023-11-26 15:58:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (3053, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 16:46:58', '9', '2023-11-26 16:46:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (3054, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 20:57:30', '9', '2023-11-26 20:57:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (3055, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:07:22', '9', '2023-11-26 21:07:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (3056, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:08:17', '9', '2023-11-26 21:08:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (3057, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:08:30', '9', '2023-11-26 21:08:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (3058, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:08:40', '9', '2023-11-26 21:08:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (3059, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:08:50', '9', '2023-11-26 21:08:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (3060, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:12:23', '9', '2023-11-26 21:12:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (3061, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:12:35', '9', '2023-11-26 21:12:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (3062, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:12:45', '9', '2023-11-26 21:12:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (3063, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:13:07', '9', '2023-11-26 21:13:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (3064, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:17:55', '9', '2023-11-26 21:17:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (3065, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:21:15', '9', '2023-11-26 21:21:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3066, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:23:11', '9', '2023-11-26 21:23:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (3067, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:23:37', '9', '2023-11-26 21:23:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (3068, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:23:50', '9', '2023-11-26 21:23:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (3069, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:24:06', '9', '2023-11-26 21:24:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3070, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:24:13', '9', '2023-11-26 21:24:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (3071, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:25:17', '9', '2023-11-26 21:25:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (3072, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:25:29', '9', '2023-11-26 21:25:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (3073, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:25:41', '9', '2023-11-26 21:25:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (3074, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:30:51', '9', '2023-11-26 21:30:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (3075, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:31:57', '9', '2023-11-26 21:31:57', b'0', 0);
INSERT INTO `system_login_log` VALUES (3076, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:33:54', '9', '2023-11-26 21:33:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (3077, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:34:15', '9', '2023-11-26 21:34:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3078, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:36:01', '9', '2023-11-26 21:36:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (3079, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:36:11', '9', '2023-11-26 21:36:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (3080, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:36:33', '9', '2023-11-26 21:36:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (3081, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-26 21:36:49', '9', '2023-11-26 21:36:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (3082, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:36:58', '9', '2023-11-26 21:36:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (3083, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:41:30', '9', '2023-11-26 21:41:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (3084, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:43:43', '9', '2023-11-26 21:43:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (3085, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-26 21:45:14', '9', '2023-11-26 21:45:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (3086, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-28 10:54:51', '9', '2023-11-28 10:54:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (3087, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 10:55:04', '9', '2023-11-28 10:55:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (3088, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:01:41', '9', '2023-11-28 11:01:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (3089, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:05:08', '9', '2023-11-28 11:05:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (3090, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:07:50', '9', '2023-11-28 11:07:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (3091, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:10:27', '9', '2023-11-28 11:10:27', b'0', 0);
INSERT INTO `system_login_log` VALUES (3092, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:15:59', '9', '2023-11-28 11:15:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (3093, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:46:08', '9', '2023-11-28 11:46:08', b'0', 0);
INSERT INTO `system_login_log` VALUES (3094, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 11:59:35', '9', '2023-11-28 11:59:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (3095, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-28 12:01:22', '9', '2023-11-28 12:01:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (3096, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-29 14:05:20', '9', '2023-11-29 14:05:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (3097, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-29 14:05:51', '9', '2023-11-29 14:05:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (3098, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-29 14:06:55', '9', '2023-11-29 14:06:55', b'0', 0);
INSERT INTO `system_login_log` VALUES (3099, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 webview/', '9', '2023-11-29 14:08:02', '9', '2023-11-29 14:08:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (3100, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:10:49', '9', '2023-11-29 14:10:49', b'0', 0);
INSERT INTO `system_login_log` VALUES (3101, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:21:32', '9', '2023-11-29 14:21:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3102, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:24:30', '9', '2023-11-29 14:24:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (3103, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:35:06', '9', '2023-11-29 14:35:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3104, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:48:04', '9', '2023-11-29 14:48:04', b'0', 0);
INSERT INTO `system_login_log` VALUES (3105, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:49:36', '9', '2023-11-29 14:49:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (3106, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:50:17', '9', '2023-11-29 14:50:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (3107, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 14:50:24', '9', '2023-11-29 14:50:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3108, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:00:13', '9', '2023-11-29 15:00:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (3109, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:11:21', '9', '2023-11-29 15:11:21', b'0', 0);
INSERT INTO `system_login_log` VALUES (3110, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:15:16', '9', '2023-11-29 15:15:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (3111, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:20:24', '9', '2023-11-29 15:20:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3112, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:21:40', '9', '2023-11-29 15:21:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (3113, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:38:15', '9', '2023-11-29 15:38:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3114, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:39:06', '9', '2023-11-29 15:39:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3115, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:43:54', '9', '2023-11-29 15:43:54', b'0', 0);
INSERT INTO `system_login_log` VALUES (3116, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:45:45', '9', '2023-11-29 15:45:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (3117, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 15:57:40', '9', '2023-11-29 15:57:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (3118, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 16:00:59', '9', '2023-11-29 16:00:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (3119, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 16:11:30', '9', '2023-11-29 16:11:30', b'0', 0);
INSERT INTO `system_login_log` VALUES (3120, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-29 16:16:52', '9', '2023-11-29 16:16:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (3121, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 14:22:32', '9', '2023-11-30 14:22:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3122, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 14:28:46', '9', '2023-11-30 14:28:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (3123, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 15:49:52', '9', '2023-11-30 15:49:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (3124, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 15:50:05', '9', '2023-11-30 15:50:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (3125, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 16:00:15', '9', '2023-11-30 16:00:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3126, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 16:04:06', '9', '2023-11-30 16:04:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3127, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 16:50:28', '9', '2023-11-30 16:50:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (3128, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 17:08:52', '9', '2023-11-30 17:08:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (3129, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-11-30 17:13:37', '9', '2023-11-30 17:13:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (3130, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-01 10:00:51', '9', '2023-12-01 10:00:51', b'0', 0);
INSERT INTO `system_login_log` VALUES (3131, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-01 10:27:56', '9', '2023-12-01 10:27:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (3132, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-02 09:50:15', NULL, '2023-12-02 09:50:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (3133, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', '1', '2023-12-02 09:52:32', '1', '2023-12-02 09:52:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3134, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-02 09:52:45', NULL, '2023-12-02 09:52:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (3135, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-02 15:13:01', '9', '2023-12-02 15:13:01', b'0', 0);
INSERT INTO `system_login_log` VALUES (3136, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-02 15:37:34', '9', '2023-12-02 15:37:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (3137, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-02 16:33:00', '9', '2023-12-02 16:33:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (3138, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-02 16:45:44', '9', '2023-12-02 16:45:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (3139, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-02 16:46:17', '9', '2023-12-02 16:46:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (3140, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-03 17:15:39', NULL, '2023-12-03 17:15:39', b'0', 0);
INSERT INTO `system_login_log` VALUES (3141, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-04 09:39:35', '9', '2023-12-04 09:39:35', b'0', 0);
INSERT INTO `system_login_log` VALUES (3142, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-04 10:37:02', '9', '2023-12-04 10:37:02', b'0', 0);
INSERT INTO `system_login_log` VALUES (3143, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-04 10:52:06', '9', '2023-12-04 10:52:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3144, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-04 11:01:41', '9', '2023-12-04 11:01:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (3145, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-04 15:05:31', '9', '2023-12-04 15:05:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (3146, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', '1', '2023-12-08 09:43:10', '1', '2023-12-08 09:43:10', b'0', 0);
INSERT INTO `system_login_log` VALUES (3147, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-08 09:43:16', NULL, '2023-12-08 09:43:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (3148, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2023-12-08 10:07:32', NULL, '2023-12-08 10:07:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3149, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-08 10:10:18', '9', '2023-12-08 10:10:18', b'0', 0);
INSERT INTO `system_login_log` VALUES (3150, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', '1', '2023-12-08 10:11:20', '1', '2023-12-08 10:11:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (3151, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-08 10:11:29', NULL, '2023-12-08 10:11:29', b'0', 0);
INSERT INTO `system_login_log` VALUES (3152, 200, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', '1', '2023-12-08 10:25:44', '1', '2023-12-08 10:25:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (3153, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, '2023-12-08 10:25:52', NULL, '2023-12-08 10:25:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (3154, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-08 10:28:07', '9', '2023-12-08 10:28:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (3155, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-08 10:29:12', '9', '2023-12-08 10:29:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (3156, 104, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/17020043012858970 webdebugger port/41859 token/4a7d768a357b224d2a3f481558985ab3', NULL, '2023-12-08 11:05:24', NULL, '2023-12-08 11:05:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3157, 104, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/17020043012858970 webdebugger port/41859 token/4a7d768a357b224d2a3f481558985ab3', '9', '2023-12-08 11:16:20', '9', '2023-12-08 11:16:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (3158, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2023-12-08 11:18:50', '9', '2023-12-08 11:18:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (3159, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', NULL, '2024-02-24 10:17:45', NULL, '2024-02-24 10:17:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (3160, 101, '', 9, 1, '15136175246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', NULL, '2024-02-24 10:28:40', NULL, '2024-02-24 10:28:40', b'0', 0);
INSERT INTO `system_login_log` VALUES (3161, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', NULL, '2024-03-26 15:21:16', NULL, '2024-03-26 15:21:16', b'0', 0);
INSERT INTO `system_login_log` VALUES (3162, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', NULL, '2024-04-03 14:23:22', NULL, '2024-04-03 14:23:22', b'0', 0);
INSERT INTO `system_login_log` VALUES (3163, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', NULL, '2024-05-08 15:11:20', NULL, '2024-05-08 15:11:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (3164, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-05-08 15:11:41', '9', '2024-05-08 15:11:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (3165, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-05-08 15:16:50', '9', '2024-05-08 15:16:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (3166, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-05-08 15:21:47', '9', '2024-05-08 15:21:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (3167, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-05-08 15:26:06', '9', '2024-05-08 15:26:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (3168, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', NULL, '2024-05-21 10:26:32', NULL, '2024-05-21 10:26:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3169, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', NULL, '2024-05-29 16:20:12', NULL, '2024-05-29 16:20:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (3170, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL, '2024-06-01 13:15:23', NULL, '2024-06-01 13:15:23', b'0', 0);
INSERT INTO `system_login_log` VALUES (3171, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL, '2024-06-01 13:24:32', NULL, '2024-06-01 13:24:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (3172, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-06-01 14:57:12', '9', '2024-06-01 14:57:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (3173, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-06-01 16:21:19', '9', '2024-06-01 16:21:19', b'0', 0);
INSERT INTO `system_login_log` VALUES (3174, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-06-01 16:21:24', '9', '2024-06-01 16:21:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3175, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-06-01 16:21:24', '9', '2024-06-01 16:21:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (3176, 101, '', 9, 1, '151****5246', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1 wechatdevtools/1.06.2307260 MicroMessenger/8.0.5 Language/zh_CN webview/', '9', '2024-06-01 16:21:37', '9', '2024-06-01 16:21:37', b'0', 0);
INSERT INTO `system_login_log` VALUES (3177, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', NULL, '2024-06-14 13:58:03', NULL, '2024-06-14 13:58:03', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for system_mail_account
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_account`;
CREATE TABLE `system_mail_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SMTP 服务器域名',
  `port` int NOT NULL COMMENT 'SMTP 服务器端口',
  `ssl_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启 SSL',
  `starttls_enable` bit(1) DEFAULT b'0' COMMENT '是否开启 STARTTLS',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮箱账号表';

-- ----------------------------
-- Records of system_mail_account
-- ----------------------------
BEGIN;
INSERT INTO `system_mail_account` VALUES (1, '7684413@qq.com', '7684413@qq.com', '123457', '127.0.0.1', 8080, b'0', b'0', '1', '2023-01-25 17:39:52', '1', '2023-04-12 23:04:49', b'0');
INSERT INTO `system_mail_account` VALUES (2, 'ydym_test@163.com', 'ydym_test@163.com', 'WBZTEINMIFVRYSOE', 'smtp.163.com', 465, b'1', b'0', '1', '2023-01-26 01:26:03', '1', '2023-04-12 22:39:38', b'0');
INSERT INTO `system_mail_account` VALUES (3, '76854114@qq.com', '3335', '11234', 'yunai1.cn', 466, b'0', b'0', '1', '2023-01-27 15:06:38', '1', '2023-01-27 07:08:36', b'1');
INSERT INTO `system_mail_account` VALUES (4, '7685413x@qq.com', '2', '3', '4', 5, b'1', b'0', '1', '2023-04-12 23:05:06', '1', '2023-04-12 15:05:11', b'1');
COMMIT;

-- ----------------------------
-- Table structure for system_mail_log
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_log`;
CREATE TABLE `system_mail_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint DEFAULT NULL COMMENT '用户类型',
  `to_mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收邮箱地址',
  `account_id` bigint NOT NULL COMMENT '邮箱账号编号',
  `from_mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送邮箱地址',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '模版发送人名称',
  `template_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件标题',
  `template_content` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件内容',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件参数',
  `send_status` tinyint NOT NULL DEFAULT '0' COMMENT '发送状态',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `send_message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发送返回的消息 ID',
  `send_exception` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发送异常',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件日志表';

-- ----------------------------
-- Records of system_mail_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_mail_template
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_template`;
CREATE TABLE `system_mail_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `account_id` bigint NOT NULL COMMENT '发送的邮箱账号编号',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发送人名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板标题',
  `content` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板内容',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件模版表';

-- ----------------------------
-- Records of system_mail_template
-- ----------------------------
BEGIN;
INSERT INTO `system_mail_template` VALUES (13, '后台用户短信登录', 'admin-sms-login', 1, '奥特曼', '你猜我猜', '<p>您的验证码是{code}，名字是{name}</p>', '[\"code\",\"name\"]', 0, '3', '1', '2021-10-11 08:10:00', '1', '2023-01-26 23:22:05', b'0');
INSERT INTO `system_mail_template` VALUES (14, '测试模版', 'test_01', 2, '芋艿', '一个标题', '<p>你是 {key01} 吗？</p><p><br></p><p>是的话，赶紧 {key02} 一下！</p>', '[\"key01\",\"key02\"]', 0, NULL, '1', '2023-01-26 01:27:40', '1', '2023-01-27 10:32:16', b'0');
INSERT INTO `system_mail_template` VALUES (15, '3', '2', 2, '7', '4', '<p>45</p>', '[]', 1, '80', '1', '2023-01-27 15:50:35', '1', '2023-01-27 16:34:49', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限标识',
  `type` tinyint NOT NULL COMMENT '菜单类型',
  `sort` int NOT NULL DEFAULT '0' COMMENT '显示顺序',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父菜单ID',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由地址',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '#' COMMENT '菜单图标',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件路径',
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件名',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '菜单状态',
  `visible` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可见',
  `keep_alive` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否缓存',
  `always_show` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否总是显示',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2314 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

-- ----------------------------
-- Records of system_menu
-- ----------------------------
BEGIN;
INSERT INTO `system_menu` VALUES (1, '系统管理', '', 1, 300, 0, '/system', 'system', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-05-17 10:32:57', b'0');
INSERT INTO `system_menu` VALUES (2, '基础设施', '', 1, 200, 0, '/infra', 'monitor', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-05-17 10:33:07', b'0');
INSERT INTO `system_menu` VALUES (5, 'OA 示例', '', 1, 40, 1185, 'oa', 'people', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-09-20 16:26:19', '1', '2023-05-10 09:47:14', b'1');
INSERT INTO `system_menu` VALUES (100, '用户管理', 'system:user:list', 2, 1, 1, 'user', 'user', 'system/user/index', 'SystemUser', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:31:59', b'0');
INSERT INTO `system_menu` VALUES (101, '角色管理', '', 2, 2, 1, 'role', 'peoples', 'system/role/index', 'SystemRole', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:33:59', b'0');
INSERT INTO `system_menu` VALUES (102, '菜单管理', '', 2, 3, 1, 'menu', 'tree-table', 'system/menu/index', 'SystemMenu', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:34:32', b'0');
INSERT INTO `system_menu` VALUES (103, '部门管理', '', 2, 4, 1, 'dept', 'tree', 'system/dept/index', 'SystemDept', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:35:32', b'0');
INSERT INTO `system_menu` VALUES (104, '岗位管理', '', 2, 5, 1, 'post', 'post', 'system/post/index', 'SystemPost', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:36:21', b'0');
INSERT INTO `system_menu` VALUES (105, '字典管理', '', 2, 6, 1, 'dict', 'dict', 'system/dict/index', 'SystemDictType', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:36:45', b'0');
INSERT INTO `system_menu` VALUES (106, '配置管理', '', 2, 6, 2, 'config', 'edit', 'infra/config/index', 'InfraConfig', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:31:17', b'0');
INSERT INTO `system_menu` VALUES (107, '通知公告', '', 2, 8, 1, 'notice', 'message', 'system/notice/index', 'SystemNotice', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:45:06', b'0');
INSERT INTO `system_menu` VALUES (108, '审计日志', '', 1, 9, 1, 'log', 'log', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (109, '令牌管理', '', 2, 2, 1261, 'token', 'online', 'system/oauth2/token/index', 'SystemTokenClient', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:47:41', b'0');
INSERT INTO `system_menu` VALUES (110, '定时任务', '', 2, 12, 2, 'job', 'job', 'infra/job/index', 'InfraJob', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:36:49', b'0');
INSERT INTO `system_menu` VALUES (111, 'MySQL 监控', '', 2, 9, 2, 'druid', 'druid', 'infra/druid/index', 'InfraDruid', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:09:30', b'0');
INSERT INTO `system_menu` VALUES (112, 'Java 监控', '', 2, 11, 2, 'admin-server', 'server', 'infra/server/index', 'InfraAdminServer', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:34:08', b'0');
INSERT INTO `system_menu` VALUES (113, 'Redis 监控', '', 2, 10, 2, 'redis', 'redis', 'infra/redis/index', 'InfraRedis', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:33:30', b'0');
INSERT INTO `system_menu` VALUES (114, '表单构建', 'infra:build:list', 2, 2, 2, 'build', 'build', 'infra/build/index', 'InfraBuild', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:06:12', b'0');
INSERT INTO `system_menu` VALUES (115, '代码生成', 'infra:codegen:query', 2, 1, 2, 'codegen', 'code', 'infra/codegen/index', 'InfraCodegen', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:02:24', b'0');
INSERT INTO `system_menu` VALUES (116, '系统接口', 'infra:swagger:list', 2, 3, 2, 'swagger', 'swagger', 'infra/swagger/index', 'InfraSwagger', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:11:28', b'0');
INSERT INTO `system_menu` VALUES (500, '操作日志', '', 2, 1, 108, 'operate-log', 'form', 'system/operatelog/index', 'SystemOperateLog', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:47:00', b'0');
INSERT INTO `system_menu` VALUES (501, '登录日志', '', 2, 2, 108, 'login-log', 'logininfor', 'system/loginlog/index', 'SystemLoginLog', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:46:18', b'0');
INSERT INTO `system_menu` VALUES (1001, '用户查询', 'system:user:query', 3, 1, 100, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1002, '用户新增', 'system:user:create', 3, 2, 100, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1003, '用户修改', 'system:user:update', 3, 3, 100, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1004, '用户删除', 'system:user:delete', 3, 4, 100, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1005, '用户导出', 'system:user:export', 3, 5, 100, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1006, '用户导入', 'system:user:import', 3, 6, 100, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1007, '重置密码', 'system:user:update-password', 3, 7, 100, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1008, '角色查询', 'system:role:query', 3, 1, 101, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1009, '角色新增', 'system:role:create', 3, 2, 101, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1010, '角色修改', 'system:role:update', 3, 3, 101, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1011, '角色删除', 'system:role:delete', 3, 4, 101, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1012, '角色导出', 'system:role:export', 3, 5, 101, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1013, '菜单查询', 'system:menu:query', 3, 1, 102, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1014, '菜单新增', 'system:menu:create', 3, 2, 102, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1015, '菜单修改', 'system:menu:update', 3, 3, 102, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1016, '菜单删除', 'system:menu:delete', 3, 4, 102, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1017, '部门查询', 'system:dept:query', 3, 1, 103, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1018, '部门新增', 'system:dept:create', 3, 2, 103, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1019, '部门修改', 'system:dept:update', 3, 3, 103, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1020, '部门删除', 'system:dept:delete', 3, 4, 103, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1021, '岗位查询', 'system:post:query', 3, 1, 104, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1022, '岗位新增', 'system:post:create', 3, 2, 104, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1023, '岗位修改', 'system:post:update', 3, 3, 104, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1024, '岗位删除', 'system:post:delete', 3, 4, 104, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1025, '岗位导出', 'system:post:export', 3, 5, 104, '', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1026, '字典查询', 'system:dict:query', 3, 1, 105, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1027, '字典新增', 'system:dict:create', 3, 2, 105, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1028, '字典修改', 'system:dict:update', 3, 3, 105, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1029, '字典删除', 'system:dict:delete', 3, 4, 105, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1030, '字典导出', 'system:dict:export', 3, 5, 105, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1031, '配置查询', 'infra:config:query', 3, 1, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1032, '配置新增', 'infra:config:create', 3, 2, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1033, '配置修改', 'infra:config:update', 3, 3, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1034, '配置删除', 'infra:config:delete', 3, 4, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1035, '配置导出', 'infra:config:export', 3, 5, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1036, '公告查询', 'system:notice:query', 3, 1, 107, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1037, '公告新增', 'system:notice:create', 3, 2, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1038, '公告修改', 'system:notice:update', 3, 3, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1039, '公告删除', 'system:notice:delete', 3, 4, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1040, '操作查询', 'system:operate-log:query', 3, 1, 500, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1042, '日志导出', 'system:operate-log:export', 3, 2, 500, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1043, '登录查询', 'system:login-log:query', 3, 1, 501, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1045, '日志导出', 'system:login-log:export', 3, 3, 501, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1046, '令牌列表', 'system:oauth2-token:page', 3, 1, 109, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-05-09 23:54:42', b'0');
INSERT INTO `system_menu` VALUES (1048, '令牌删除', 'system:oauth2-token:delete', 3, 2, 109, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-05-09 23:54:53', b'0');
INSERT INTO `system_menu` VALUES (1050, '任务新增', 'infra:job:create', 3, 2, 110, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1051, '任务修改', 'infra:job:update', 3, 3, 110, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1052, '任务删除', 'infra:job:delete', 3, 4, 110, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1053, '状态修改', 'infra:job:update', 3, 5, 110, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1054, '任务导出', 'infra:job:export', 3, 7, 110, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1056, '生成修改', 'infra:codegen:update', 3, 2, 115, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1057, '生成删除', 'infra:codegen:delete', 3, 3, 115, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1058, '导入代码', 'infra:codegen:create', 3, 2, 115, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1059, '预览代码', 'infra:codegen:preview', 3, 4, 115, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1060, '生成代码', 'infra:codegen:download', 3, 5, 115, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1063, '设置角色菜单权限', 'system:permission:assign-role-menu', 3, 6, 101, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-01-06 17:53:44', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1064, '设置角色数据权限', 'system:permission:assign-role-data-scope', 3, 7, 101, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-01-06 17:56:31', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1065, '设置用户角色', 'system:permission:assign-user-role', 3, 8, 101, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-01-07 10:23:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1066, '获得 Redis 监控信息', 'infra:redis:get-monitor-info', 3, 1, 113, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-01-26 01:02:31', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1067, '获得 Redis Key 列表', 'infra:redis:get-key-list', 3, 2, 113, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-01-26 01:02:52', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1070, '代码生成示例', 'infra:test-demo:query', 2, 1, 2, 'test-demo', 'validCode', 'infra/testDemo/index', NULL, 0, b'1', b'1', b'1', '', '2021-02-06 12:42:49', '1', '2023-05-17 10:35:45', b'1');
INSERT INTO `system_menu` VALUES (1071, '测试示例表创建', 'infra:test-demo:create', 3, 1, 1070, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-06 12:42:49', '1', '2023-05-17 10:35:27', b'1');
INSERT INTO `system_menu` VALUES (1072, '测试示例表更新', 'infra:test-demo:update', 3, 2, 1070, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-06 12:42:49', '1', '2023-05-17 10:35:32', b'1');
INSERT INTO `system_menu` VALUES (1073, '测试示例表删除', 'infra:test-demo:delete', 3, 3, 1070, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-06 12:42:49', '1', '2023-05-17 10:35:37', b'1');
INSERT INTO `system_menu` VALUES (1074, '测试示例表导出', 'infra:test-demo:export', 3, 4, 1070, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-06 12:42:49', '1', '2023-05-17 10:35:40', b'1');
INSERT INTO `system_menu` VALUES (1075, '任务触发', 'infra:job:trigger', 3, 8, 110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-07 13:03:10', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1076, '数据库文档', '', 2, 4, 2, 'db-doc', 'table', 'infra/dbDoc/index', 'InfraDBDoc', 0, b'1', b'1', b'1', '', '2021-02-08 01:41:47', '1', '2024-06-01 14:26:46', b'1');
INSERT INTO `system_menu` VALUES (1077, '监控平台', '', 2, 13, 2, 'skywalking', 'eye-open', 'infra/skywalking/index', 'InfraSkyWalking', 0, b'1', b'1', b'1', '', '2021-02-08 20:41:31', '1', '2023-06-29 13:39:57', b'1');
INSERT INTO `system_menu` VALUES (1078, '访问日志', '', 2, 1, 1083, 'api-access-log', 'log', 'infra/apiAccessLog/index', 'InfraApiAccessLog', 0, b'1', b'1', b'1', '', '2021-02-26 01:32:59', '1', '2023-04-08 10:31:34', b'0');
INSERT INTO `system_menu` VALUES (1082, '日志导出', 'infra:api-access-log:export', 3, 2, 1078, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 01:32:59', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1083, 'API 日志', '', 2, 8, 2, 'log', 'log', NULL, NULL, 0, b'1', b'1', b'1', '', '2021-02-26 02:18:24', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1084, '错误日志', 'infra:api-error-log:query', 2, 2, 1083, 'api-error-log', 'log', 'infra/apiErrorLog/index', 'InfraApiErrorLog', 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2023-04-08 10:32:25', b'0');
INSERT INTO `system_menu` VALUES (1085, '日志处理', 'infra:api-error-log:update-status', 3, 2, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1086, '日志导出', 'infra:api-error-log:export', 3, 3, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1087, '任务查询', 'infra:job:query', 3, 1, 110, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:26:19', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1088, '日志查询', 'infra:api-access-log:query', 3, 1, 1078, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:28:04', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1089, '日志查询', 'infra:api-error-log:query', 3, 1, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:29:09', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1090, '文件列表', '', 2, 5, 1243, 'file', 'upload', 'infra/file/index', 'InfraFile', 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '1', '2023-04-08 09:21:31', b'0');
INSERT INTO `system_menu` VALUES (1091, '文件查询', 'infra:file:query', 3, 1, 1090, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1092, '文件删除', 'infra:file:delete', 3, 4, 1090, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1093, '短信管理', '', 1, 11, 1, 'sms', 'validCode', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-04-05 01:10:16', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1094, '短信渠道', '', 2, 0, 1093, 'sms-channel', 'phone', 'system/sms/channel/index', 'SystemSmsChannel', 0, b'1', b'1', b'1', '', '2021-04-01 11:07:15', '1', '2023-04-08 08:50:41', b'0');
INSERT INTO `system_menu` VALUES (1095, '短信渠道查询', 'system:sms-channel:query', 3, 1, 1094, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1096, '短信渠道创建', 'system:sms-channel:create', 3, 2, 1094, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1097, '短信渠道更新', 'system:sms-channel:update', 3, 3, 1094, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1098, '短信渠道删除', 'system:sms-channel:delete', 3, 4, 1094, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1100, '短信模板', '', 2, 1, 1093, 'sms-template', 'phone', 'system/sms/template/index', 'SystemSmsTemplate', 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '1', '2023-04-08 08:50:50', b'0');
INSERT INTO `system_menu` VALUES (1101, '短信模板查询', 'system:sms-template:query', 3, 1, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1102, '短信模板创建', 'system:sms-template:create', 3, 2, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1103, '短信模板更新', 'system:sms-template:update', 3, 3, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1104, '短信模板删除', 'system:sms-template:delete', 3, 4, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1105, '短信模板导出', 'system:sms-template:export', 3, 5, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1106, '发送测试短信', 'system:sms-template:send-sms', 3, 6, 1100, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-04-11 00:26:40', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1107, '短信日志', '', 2, 2, 1093, 'sms-log', 'phone', 'system/sms/log/index', 'SystemSmsLog', 0, b'1', b'1', b'1', '', '2021-04-11 08:37:05', '1', '2023-04-08 08:50:58', b'0');
INSERT INTO `system_menu` VALUES (1108, '短信日志查询', 'system:sms-log:query', 3, 1, 1107, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1109, '短信日志导出', 'system:sms-log:export', 3, 5, 1107, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1110, '错误码管理', '', 2, 12, 1, 'error-code', 'code', 'system/errorCode/index', 'SystemErrorCode', 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '1', '2024-06-14 14:20:05', b'1');
INSERT INTO `system_menu` VALUES (1111, '错误码查询', 'system:error-code:query', 3, 1, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-06-14 14:19:46', b'1');
INSERT INTO `system_menu` VALUES (1112, '错误码创建', 'system:error-code:create', 3, 2, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-06-14 14:19:49', b'1');
INSERT INTO `system_menu` VALUES (1113, '错误码更新', 'system:error-code:update', 3, 3, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-06-14 14:19:52', b'1');
INSERT INTO `system_menu` VALUES (1114, '错误码删除', 'system:error-code:delete', 3, 4, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-06-14 14:19:59', b'1');
INSERT INTO `system_menu` VALUES (1115, '错误码导出', 'system:error-code:export', 3, 5, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-06-14 14:20:02', b'1');
INSERT INTO `system_menu` VALUES (1117, '支付管理', '', 1, 90, 0, '/pay', 'money', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-12-25 16:43:41', '1', '2023-05-17 10:33:35', b'0');
INSERT INTO `system_menu` VALUES (1118, '请假查询', '', 2, 0, 5, 'leave', 'user', 'bpm/oa/leave/index', 'BpmOALeave', 0, b'1', b'1', b'1', '', '2021-09-20 08:51:03', '1', '2023-05-10 09:47:07', b'1');
INSERT INTO `system_menu` VALUES (1119, '请假申请查询', 'bpm:oa-leave:query', 3, 1, 1118, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-09-20 08:51:03', '1', '2023-05-10 09:46:52', b'1');
INSERT INTO `system_menu` VALUES (1120, '请假申请创建', 'bpm:oa-leave:create', 3, 2, 1118, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-09-20 08:51:03', '1', '2023-05-10 09:46:58', b'1');
INSERT INTO `system_menu` VALUES (1126, '应用信息', '', 2, 1, 1117, 'app', 'table', 'pay/app/index', 'PayMerchant', 0, b'1', b'1', b'1', '', '2021-11-10 01:13:30', '1', '2023-07-14 15:12:54', b'1');
INSERT INTO `system_menu` VALUES (1127, '支付应用信息查询', 'pay:app:query', 3, 1, 1126, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:31', '', '2023-07-14 15:10:58', b'1');
INSERT INTO `system_menu` VALUES (1128, '支付应用信息创建', 'pay:app:create', 3, 2, 1126, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:31', '', '2023-07-14 15:11:02', b'1');
INSERT INTO `system_menu` VALUES (1129, '支付应用信息更新', 'pay:app:update', 3, 3, 1126, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:31', '', '2023-07-14 15:12:39', b'1');
INSERT INTO `system_menu` VALUES (1130, '支付应用信息删除', 'pay:app:delete', 3, 4, 1126, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:31', '', '2023-07-14 15:12:44', b'1');
INSERT INTO `system_menu` VALUES (1131, '支付应用信息导出', 'pay:app:export', 3, 5, 1126, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:31', '', '2023-07-14 15:12:48', b'1');
INSERT INTO `system_menu` VALUES (1132, '秘钥解析', 'pay:channel:parsing', 3, 6, 1129, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-11-08 15:15:47', '1', '2023-07-14 15:11:37', b'1');
INSERT INTO `system_menu` VALUES (1133, '支付商户信息查询', 'pay:merchant:query', 3, 1, 1132, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:41', '', '2023-07-14 15:11:17', b'1');
INSERT INTO `system_menu` VALUES (1134, '支付商户信息创建', 'pay:merchant:create', 3, 2, 1132, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:41', '', '2023-07-14 15:11:21', b'1');
INSERT INTO `system_menu` VALUES (1135, '支付商户信息更新', 'pay:merchant:update', 3, 3, 1132, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:41', '', '2023-07-14 15:11:24', b'1');
INSERT INTO `system_menu` VALUES (1136, '支付商户信息删除', 'pay:merchant:delete', 3, 4, 1132, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:41', '', '2023-07-14 15:11:28', b'1');
INSERT INTO `system_menu` VALUES (1137, '支付商户信息导出', 'pay:merchant:export', 3, 5, 1132, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-11-10 01:13:41', '', '2023-07-14 15:11:32', b'1');
INSERT INTO `system_menu` VALUES (1138, '租户列表', '', 2, 0, 1224, 'list', 'peoples', 'system/tenant/index', 'SystemTenant', 0, b'1', b'1', b'1', '', '2021-12-14 12:31:43', '1', '2023-05-17 10:46:14', b'1');
INSERT INTO `system_menu` VALUES (1139, '租户查询', 'system:tenant:query', 3, 1, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2023-05-17 10:44:58', b'1');
INSERT INTO `system_menu` VALUES (1140, '租户创建', 'system:tenant:create', 3, 2, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2023-05-17 10:45:08', b'1');
INSERT INTO `system_menu` VALUES (1141, '租户更新', 'system:tenant:update', 3, 3, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2023-05-17 10:46:02', b'1');
INSERT INTO `system_menu` VALUES (1142, '租户删除', 'system:tenant:delete', 3, 4, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2023-05-17 10:46:05', b'1');
INSERT INTO `system_menu` VALUES (1143, '租户导出', 'system:tenant:export', 3, 5, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2023-05-17 10:46:09', b'1');
INSERT INTO `system_menu` VALUES (1150, '秘钥解析', '', 3, 6, 1129, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-11-08 15:15:47', '1', '2023-07-14 15:11:42', b'1');
INSERT INTO `system_menu` VALUES (1161, '退款订单', '', 2, 3, 1117, 'refund', 'order', 'pay/refund/index', 'PayRefund', 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '1', '2023-07-14 15:13:55', b'1');
INSERT INTO `system_menu` VALUES (1162, '退款订单查询', 'pay:refund:query', 3, 1, 1161, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '', '2023-07-14 15:13:31', b'1');
INSERT INTO `system_menu` VALUES (1163, '退款订单创建', 'pay:refund:create', 3, 2, 1161, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '', '2023-07-14 15:13:35', b'1');
INSERT INTO `system_menu` VALUES (1164, '退款订单更新', 'pay:refund:update', 3, 3, 1161, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '', '2023-07-14 15:13:40', b'1');
INSERT INTO `system_menu` VALUES (1165, '退款订单删除', 'pay:refund:delete', 3, 4, 1161, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '', '2023-07-14 15:13:44', b'1');
INSERT INTO `system_menu` VALUES (1166, '退款订单导出', 'pay:refund:export', 3, 5, 1161, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:29:07', '', '2023-07-14 15:13:50', b'1');
INSERT INTO `system_menu` VALUES (1173, '支付订单', '', 2, 2, 1117, 'order', 'pay', 'pay/order/index', 'PayOrder', 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '1', '2023-07-14 15:13:22', b'1');
INSERT INTO `system_menu` VALUES (1174, '支付订单查询', 'pay:order:query', 3, 1, 1173, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '', '2023-07-14 15:13:00', b'1');
INSERT INTO `system_menu` VALUES (1175, '支付订单创建', 'pay:order:create', 3, 2, 1173, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '', '2023-07-14 15:13:05', b'1');
INSERT INTO `system_menu` VALUES (1176, '支付订单更新', 'pay:order:update', 3, 3, 1173, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '', '2023-07-14 15:13:10', b'1');
INSERT INTO `system_menu` VALUES (1177, '支付订单删除', 'pay:order:delete', 3, 4, 1173, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '', '2023-07-14 15:13:13', b'1');
INSERT INTO `system_menu` VALUES (1178, '支付订单导出', 'pay:order:export', 3, 5, 1173, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 08:49:43', '', '2023-07-14 15:13:18', b'1');
INSERT INTO `system_menu` VALUES (1179, '商户信息', '', 2, 0, 1117, 'merchant', 'merchant', 'pay/merchant/index', 'PayApp', 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '1', '2023-07-14 15:10:51', b'1');
INSERT INTO `system_menu` VALUES (1180, '支付商户信息查询', 'pay:merchant:query', 3, 1, 1179, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '', '2023-07-14 15:10:19', b'1');
INSERT INTO `system_menu` VALUES (1181, '支付商户信息创建', 'pay:merchant:create', 3, 2, 1179, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '', '2023-07-14 15:10:29', b'1');
INSERT INTO `system_menu` VALUES (1182, '支付商户信息更新', 'pay:merchant:update', 3, 3, 1179, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '', '2023-07-14 15:10:36', b'1');
INSERT INTO `system_menu` VALUES (1183, '支付商户信息删除', '', 3, 4, 1179, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '', '2023-07-14 15:10:41', b'1');
INSERT INTO `system_menu` VALUES (1184, '支付商户信息导出', 'pay:merchant:export', 3, 5, 1179, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '', '2023-07-14 15:10:46', b'1');
INSERT INTO `system_menu` VALUES (1185, '工作流程', '', 1, 50, 0, '/bpm', 'tool', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-12-30 20:26:36', '103', '2023-05-10 10:00:17', b'1');
INSERT INTO `system_menu` VALUES (1186, '流程管理', '', 1, 10, 1185, 'manager', 'nested', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-12-30 20:28:30', '1', '2023-05-10 10:00:13', b'1');
INSERT INTO `system_menu` VALUES (1187, '流程表单', '', 2, 0, 1186, 'form', 'form', 'bpm/form/index', 'BpmForm', 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 10:00:08', b'1');
INSERT INTO `system_menu` VALUES (1188, '表单查询', 'bpm:form:query', 3, 1, 1187, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 09:59:50', b'1');
INSERT INTO `system_menu` VALUES (1189, '表单创建', 'bpm:form:create', 3, 2, 1187, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 09:59:53', b'1');
INSERT INTO `system_menu` VALUES (1190, '表单更新', 'bpm:form:update', 3, 3, 1187, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 09:59:57', b'1');
INSERT INTO `system_menu` VALUES (1191, '表单删除', 'bpm:form:delete', 3, 4, 1187, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 10:00:00', b'1');
INSERT INTO `system_menu` VALUES (1192, '表单导出', 'bpm:form:export', 3, 5, 1187, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-30 12:38:22', '1', '2023-05-10 10:00:04', b'1');
INSERT INTO `system_menu` VALUES (1193, '流程模型', '', 2, 5, 1186, 'model', 'guide', 'bpm/model/index', 'BpmModel', 0, b'1', b'1', b'1', '1', '2021-12-31 23:24:58', '1', '2023-05-10 09:59:10', b'1');
INSERT INTO `system_menu` VALUES (1194, '模型查询', 'bpm:model:query', 3, 1, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:01:10', '1', '2023-05-10 09:48:26', b'1');
INSERT INTO `system_menu` VALUES (1195, '模型创建', 'bpm:model:create', 3, 2, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:01:24', '1', '2023-05-10 09:48:22', b'1');
INSERT INTO `system_menu` VALUES (1196, '模型导入', 'bpm:model:import', 3, 3, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:01:35', '1', '2023-05-10 09:48:59', b'1');
INSERT INTO `system_menu` VALUES (1197, '模型更新', 'bpm:model:update', 3, 4, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:02:28', '1', '2023-05-10 09:54:34', b'1');
INSERT INTO `system_menu` VALUES (1198, '模型删除', 'bpm:model:delete', 3, 5, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:02:43', '1', '2023-05-10 09:58:36', b'1');
INSERT INTO `system_menu` VALUES (1199, '模型发布', 'bpm:model:deploy', 3, 6, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-03 19:03:24', '1', '2023-05-10 09:58:46', b'1');
INSERT INTO `system_menu` VALUES (1200, '任务管理', '', 1, 20, 1185, 'task', 'cascader', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-01-07 23:51:48', '1', '2023-05-10 09:48:09', b'1');
INSERT INTO `system_menu` VALUES (1201, '我的流程', '', 2, 0, 1200, 'my', 'people', 'bpm/processInstance/index', 'BpmProcessInstance', 0, b'1', b'1', b'1', '', '2022-01-07 15:53:44', '1', '2023-05-10 09:48:04', b'1');
INSERT INTO `system_menu` VALUES (1202, '流程实例的查询', 'bpm:process-instance:query', 3, 1, 1201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-01-07 15:53:44', '1', '2023-05-10 09:47:53', b'1');
INSERT INTO `system_menu` VALUES (1207, '待办任务', '', 2, 10, 1200, 'todo', 'eye-open', 'bpm/task/todo/index', 'BpmTodoTask', 0, b'1', b'1', b'1', '1', '2022-01-08 10:33:37', '1', '2023-05-10 09:47:47', b'1');
INSERT INTO `system_menu` VALUES (1208, '已办任务', '', 2, 20, 1200, 'done', 'eye', 'bpm/task/done/index', 'BpmDoneTask', 0, b'1', b'1', b'1', '1', '2022-01-08 10:34:13', '1', '2023-05-10 09:47:25', b'1');
INSERT INTO `system_menu` VALUES (1209, '用户分组', '', 2, 2, 1186, 'user-group', 'people', 'bpm/group/index', 'BpmUserGroup', 0, b'1', b'1', b'1', '', '2022-01-14 02:14:20', '1', '2023-05-10 09:59:44', b'1');
INSERT INTO `system_menu` VALUES (1210, '用户组查询', 'bpm:user-group:query', 3, 1, 1209, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-01-14 02:14:20', '', '2023-05-10 09:59:18', b'1');
INSERT INTO `system_menu` VALUES (1211, '用户组创建', 'bpm:user-group:create', 3, 2, 1209, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-01-14 02:14:20', '', '2023-05-10 09:59:23', b'1');
INSERT INTO `system_menu` VALUES (1212, '用户组更新', 'bpm:user-group:update', 3, 3, 1209, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-01-14 02:14:20', '', '2023-05-10 09:59:26', b'1');
INSERT INTO `system_menu` VALUES (1213, '用户组删除', 'bpm:user-group:delete', 3, 4, 1209, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-01-14 02:14:20', '', '2023-05-10 09:59:31', b'1');
INSERT INTO `system_menu` VALUES (1215, '流程定义查询', 'bpm:process-definition:query', 3, 10, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:21:43', '1', '2023-05-10 09:58:51', b'1');
INSERT INTO `system_menu` VALUES (1216, '流程任务分配规则查询', 'bpm:task-assign-rule:query', 3, 20, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:26:53', '1', '2023-05-10 09:58:55', b'1');
INSERT INTO `system_menu` VALUES (1217, '流程任务分配规则创建', 'bpm:task-assign-rule:create', 3, 21, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:28:15', '1', '2023-05-10 09:58:59', b'1');
INSERT INTO `system_menu` VALUES (1218, '流程任务分配规则更新', 'bpm:task-assign-rule:update', 3, 22, 1193, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:28:41', '1', '2023-05-10 09:59:04', b'1');
INSERT INTO `system_menu` VALUES (1219, '流程实例的创建', 'bpm:process-instance:create', 3, 2, 1201, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:36:15', '1', '2023-05-10 09:47:56', b'1');
INSERT INTO `system_menu` VALUES (1220, '流程实例的取消', 'bpm:process-instance:cancel', 3, 3, 1201, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:36:33', '1', '2023-05-10 09:48:00', b'1');
INSERT INTO `system_menu` VALUES (1221, '流程任务的查询', 'bpm:task:query', 3, 1, 1207, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:38:52', '1', '2023-05-10 09:47:32', b'1');
INSERT INTO `system_menu` VALUES (1222, '流程任务的更新', 'bpm:task:update', 3, 2, 1207, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-01-23 00:39:24', '1', '2023-05-10 09:47:41', b'1');
INSERT INTO `system_menu` VALUES (1224, '租户管理', '', 2, 0, 1, 'tenant', 'peoples', NULL, NULL, 1, b'0', b'1', b'0', '1', '2022-02-20 01:41:13', '1', '2023-05-17 10:46:42', b'1');
INSERT INTO `system_menu` VALUES (1225, '租户套餐', '', 2, 0, 1224, 'package', 'eye', 'system/tenantPackage/index', 'SystemTenantPackage', 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '1', '2023-05-17 10:46:38', b'1');
INSERT INTO `system_menu` VALUES (1226, '租户套餐查询', 'system:tenant-package:query', 3, 1, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2023-05-17 10:46:21', b'1');
INSERT INTO `system_menu` VALUES (1227, '租户套餐创建', 'system:tenant-package:create', 3, 2, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2023-05-17 10:46:24', b'1');
INSERT INTO `system_menu` VALUES (1228, '租户套餐更新', 'system:tenant-package:update', 3, 3, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2023-05-17 10:46:28', b'1');
INSERT INTO `system_menu` VALUES (1229, '租户套餐删除', 'system:tenant-package:delete', 3, 4, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2023-05-17 10:46:34', b'1');
INSERT INTO `system_menu` VALUES (1237, '文件配置', '', 2, 0, 1243, 'file-config', 'config', 'infra/fileConfig/index', 'InfraFileConfig', 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '1', '2023-04-08 09:16:05', b'0');
INSERT INTO `system_menu` VALUES (1238, '文件配置查询', 'infra:file-config:query', 3, 1, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1239, '文件配置创建', 'infra:file-config:create', 3, 2, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1240, '文件配置更新', 'infra:file-config:update', 3, 3, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1241, '文件配置删除', 'infra:file-config:delete', 3, 4, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1242, '文件配置导出', 'infra:file-config:export', 3, 5, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1243, '文件管理', '', 2, 5, 2, 'file', 'download', NULL, '', 0, b'1', b'1', b'1', '1', '2022-03-16 23:47:40', '1', '2023-02-10 13:47:46', b'0');
INSERT INTO `system_menu` VALUES (1247, '敏感词管理', '', 2, 13, 1, 'sensitive-word', 'education', 'system/sensitiveWord/index', 'SystemSensitiveWord', 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '1', '2024-06-14 14:19:39', b'1');
INSERT INTO `system_menu` VALUES (1248, '敏感词查询', 'system:sensitive-word:query', 3, 1, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-06-14 14:19:17', b'1');
INSERT INTO `system_menu` VALUES (1249, '敏感词创建', 'system:sensitive-word:create', 3, 2, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-06-14 14:19:20', b'1');
INSERT INTO `system_menu` VALUES (1250, '敏感词更新', 'system:sensitive-word:update', 3, 3, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-06-14 14:19:23', b'1');
INSERT INTO `system_menu` VALUES (1251, '敏感词删除', 'system:sensitive-word:delete', 3, 4, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-06-14 14:19:27', b'1');
INSERT INTO `system_menu` VALUES (1252, '敏感词导出', 'system:sensitive-word:export', 3, 5, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-06-14 14:19:36', b'1');
INSERT INTO `system_menu` VALUES (1255, '数据源配置', '', 2, 1, 2, 'data-source-config', 'rate', 'infra/dataSourceConfig/index', 'InfraDataSourceConfig', 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '1', '2023-04-08 09:05:21', b'0');
INSERT INTO `system_menu` VALUES (1256, '数据源配置查询', 'infra:data-source-config:query', 3, 1, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', b'0');
INSERT INTO `system_menu` VALUES (1257, '数据源配置创建', 'infra:data-source-config:create', 3, 2, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', b'0');
INSERT INTO `system_menu` VALUES (1258, '数据源配置更新', 'infra:data-source-config:update', 3, 3, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', b'0');
INSERT INTO `system_menu` VALUES (1259, '数据源配置删除', 'infra:data-source-config:delete', 3, 4, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', b'0');
INSERT INTO `system_menu` VALUES (1260, '数据源配置导出', 'infra:data-source-config:export', 3, 5, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', b'0');
INSERT INTO `system_menu` VALUES (1261, 'OAuth 2.0', '', 1, 10, 1, 'oauth2', 'people', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-05-09 23:38:17', '1', '2022-05-11 23:51:46', b'0');
INSERT INTO `system_menu` VALUES (1263, '应用管理', '', 2, 0, 1261, 'oauth2/application', 'tool', 'system/oauth2/client/index', 'SystemOAuth2Client', 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2023-04-08 08:47:31', b'0');
INSERT INTO `system_menu` VALUES (1264, '客户端查询', 'system:oauth2-client:query', 3, 1, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:06', b'0');
INSERT INTO `system_menu` VALUES (1265, '客户端创建', 'system:oauth2-client:create', 3, 2, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:23', b'0');
INSERT INTO `system_menu` VALUES (1266, '客户端更新', 'system:oauth2-client:update', 3, 3, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:28', b'0');
INSERT INTO `system_menu` VALUES (1267, '客户端删除', 'system:oauth2-client:delete', 3, 4, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:33', b'0');
INSERT INTO `system_menu` VALUES (1281, '报表管理', '', 1, 40, 0, '/report', 'chart', NULL, NULL, 1, b'0', b'1', b'1', '1', '2022-07-10 20:22:15', '1', '2023-05-10 10:35:17', b'1');
INSERT INTO `system_menu` VALUES (1282, '报表设计器', '', 2, 1, 1281, 'jimu-report', 'example', 'report/jmreport/index', 'GoView', 0, b'1', b'1', b'1', '1', '2022-07-10 20:26:36', '1', '2023-05-10 10:34:51', b'1');
INSERT INTO `system_menu` VALUES (2000, '商城中心', '', 1, 60, 0, '/mall', 'merchant', NULL, NULL, 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '1', '2023-06-02 11:29:46', b'0');
INSERT INTO `system_menu` VALUES (2002, '商品分类', '', 2, 2, 2174, 'category', 'ep:chat-dot-round', 'mall/product/category/index', 'ProductCategory', 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '1', '2023-06-08 09:57:25', b'0');
INSERT INTO `system_menu` VALUES (2003, '分类查询', 'product:category:query', 3, 1, 2002, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', b'0');
INSERT INTO `system_menu` VALUES (2004, '分类创建', 'product:category:create', 3, 2, 2002, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', b'0');
INSERT INTO `system_menu` VALUES (2005, '分类更新', 'product:category:update', 3, 3, 2002, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', b'0');
INSERT INTO `system_menu` VALUES (2006, '分类删除', 'product:category:delete', 3, 4, 2002, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', b'0');
INSERT INTO `system_menu` VALUES (2008, '商品品牌', '', 2, 1, 2174, 'brand', 'ep:brush', 'mall/product/brand/index', 'ProductBrand', 0, b'1', b'1', b'1', '', '2022-07-30 13:52:44', '1', '2023-09-04 18:31:05', b'1');
INSERT INTO `system_menu` VALUES (2009, '品牌查询', 'product:brand:query', 3, 1, 2008, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 13:52:44', '', '2023-09-04 18:30:46', b'1');
INSERT INTO `system_menu` VALUES (2010, '品牌创建', 'product:brand:create', 3, 2, 2008, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 13:52:44', '', '2023-09-04 18:30:51', b'1');
INSERT INTO `system_menu` VALUES (2011, '品牌更新', 'product:brand:update', 3, 3, 2008, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 13:52:44', '', '2023-09-04 18:30:56', b'1');
INSERT INTO `system_menu` VALUES (2012, '品牌删除', 'product:brand:delete', 3, 4, 2008, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 13:52:44', '', '2023-09-04 18:31:00', b'1');
INSERT INTO `system_menu` VALUES (2014, '商品列表', '', 2, 3, 2000, 'spu', 'list', 'mall/product/spu/index', 'ProductSpu', 0, b'1', b'1', b'1', '', '2022-07-30 14:22:58', '1', '2023-06-02 11:27:04', b'1');
INSERT INTO `system_menu` VALUES (2015, '商品查询', 'product:spu:query', 3, 1, 2014, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 14:22:58', '', '2023-06-02 11:26:45', b'1');
INSERT INTO `system_menu` VALUES (2016, '商品创建', 'product:spu:create', 3, 2, 2014, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 14:22:58', '', '2023-06-02 11:26:49', b'1');
INSERT INTO `system_menu` VALUES (2017, '商品更新', 'product:spu:update', 3, 3, 2014, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 14:22:58', '', '2023-06-02 11:26:54', b'1');
INSERT INTO `system_menu` VALUES (2018, '商品删除', 'product:spu:delete', 3, 4, 2014, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-07-30 14:22:58', '', '2023-06-02 11:26:59', b'1');
INSERT INTO `system_menu` VALUES (2019, '商品属性', '', 2, 3, 2000, 'property', 'eye', 'mall/product/property/index', 'ProductProperty', 0, b'1', b'1', b'1', '', '2022-08-01 14:55:35', '1', '2023-06-02 11:27:25', b'1');
INSERT INTO `system_menu` VALUES (2020, '规格查询', 'product:property:query', 3, 1, 2019, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:55:35', '', '2023-06-02 11:27:11', b'1');
INSERT INTO `system_menu` VALUES (2021, '规格创建', 'product:property:create', 3, 2, 2019, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:55:35', '', '2023-06-02 11:27:15', b'1');
INSERT INTO `system_menu` VALUES (2022, '规格更新', 'product:property:update', 3, 3, 2019, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:55:35', '', '2023-06-02 11:27:18', b'1');
INSERT INTO `system_menu` VALUES (2023, '规格删除', 'product:property:delete', 3, 4, 2019, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:55:35', '', '2023-06-02 11:27:21', b'1');
INSERT INTO `system_menu` VALUES (2025, 'Banner管理', '', 2, 100, 2000, 'banner', '', 'mall/market/banner/index', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:56:14', '1', '2023-05-17 10:05:22', b'1');
INSERT INTO `system_menu` VALUES (2026, 'Banner查询', 'market:banner:query', 3, 1, 2025, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:56:14', '', '2023-05-17 10:05:03', b'1');
INSERT INTO `system_menu` VALUES (2027, 'Banner创建', 'market:banner:create', 3, 2, 2025, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:56:14', '', '2023-05-17 10:05:07', b'1');
INSERT INTO `system_menu` VALUES (2028, 'Banner更新', 'market:banner:update', 3, 3, 2025, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:56:14', '', '2023-05-17 10:05:12', b'1');
INSERT INTO `system_menu` VALUES (2029, 'Banner删除', 'market:banner:delete', 3, 4, 2025, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-08-01 14:56:14', '', '2023-05-17 10:05:18', b'1');
INSERT INTO `system_menu` VALUES (2030, '营销中心', '', 1, 70, 0, '/promotion', 'rate', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-10-31 21:25:09', '1', '2023-05-10 10:32:42', b'1');
INSERT INTO `system_menu` VALUES (2032, '优惠劵', '', 2, 2, 2030, 'coupon-template', 'textarea', 'mall/promotion/couponTemplate/index', 'PromotionCouponTemplate', 0, b'1', b'1', b'1', '', '2022-10-31 22:27:14', '1', '2023-05-10 10:31:51', b'1');
INSERT INTO `system_menu` VALUES (2033, '优惠劵模板查询', 'promotion:coupon-template:query', 3, 1, 2032, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-10-31 22:27:14', '', '2023-05-10 10:31:36', b'1');
INSERT INTO `system_menu` VALUES (2034, '优惠劵模板创建', 'promotion:coupon-template:create', 3, 2, 2032, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-10-31 22:27:14', '', '2023-05-10 10:31:39', b'1');
INSERT INTO `system_menu` VALUES (2035, '优惠劵模板更新', 'promotion:coupon-template:update', 3, 3, 2032, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-10-31 22:27:14', '', '2023-05-10 10:31:42', b'1');
INSERT INTO `system_menu` VALUES (2036, '优惠劵模板删除', 'promotion:coupon-template:delete', 3, 4, 2032, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-10-31 22:27:14', '', '2023-05-10 10:31:48', b'1');
INSERT INTO `system_menu` VALUES (2038, '会员优惠劵', '', 2, 2, 2030, 'coupon', '', 'mall/promotion/coupon/index', 'PromotionCoupon', 0, b'0', b'1', b'1', '', '2022-11-03 23:21:31', '1', '2023-05-10 10:31:31', b'1');
INSERT INTO `system_menu` VALUES (2039, '优惠劵查询', 'promotion:coupon:query', 3, 1, 2038, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-03 23:21:31', '', '2023-05-10 10:31:24', b'1');
INSERT INTO `system_menu` VALUES (2040, '优惠劵删除', 'promotion:coupon:delete', 3, 4, 2038, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-03 23:21:31', '', '2023-05-10 10:31:27', b'1');
INSERT INTO `system_menu` VALUES (2041, '满减送活动', '', 2, 10, 2030, 'reward-activity', 'radio', 'mall/promotion/rewardActivity/index', 'PromotionRewardActivity', 0, b'1', b'1', b'1', '', '2022-11-04 23:47:49', '1', '2023-05-10 10:30:46', b'1');
INSERT INTO `system_menu` VALUES (2042, '满减送活动查询', 'promotion:reward-activity:query', 3, 1, 2041, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-04 23:47:49', '', '2023-05-10 10:30:32', b'1');
INSERT INTO `system_menu` VALUES (2043, '满减送活动创建', 'promotion:reward-activity:create', 3, 2, 2041, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-04 23:47:49', '', '2023-05-10 10:30:36', b'1');
INSERT INTO `system_menu` VALUES (2044, '满减送活动更新', 'promotion:reward-activity:update', 3, 3, 2041, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-04 23:47:50', '', '2023-05-10 10:30:39', b'1');
INSERT INTO `system_menu` VALUES (2045, '满减送活动删除', 'promotion:reward-activity:delete', 3, 4, 2041, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-04 23:47:50', '', '2023-05-10 10:30:43', b'1');
INSERT INTO `system_menu` VALUES (2046, '满减送活动关闭', 'promotion:reward-activity:close', 3, 5, 2041, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-11-05 10:42:53', '1', '2023-05-10 10:30:29', b'1');
INSERT INTO `system_menu` VALUES (2047, '限时折扣活动', '', 2, 7, 2030, 'discount-activity', 'time', 'mall/promotion/discountActivity/index', 'PromotionDiscountActivity', 0, b'1', b'1', b'1', '', '2022-11-05 17:12:15', '1', '2023-05-10 10:31:19', b'1');
INSERT INTO `system_menu` VALUES (2048, '限时折扣活动查询', 'promotion:discount-activity:query', 3, 1, 2047, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-05 17:12:15', '', '2023-05-10 10:31:02', b'1');
INSERT INTO `system_menu` VALUES (2049, '限时折扣活动创建', 'promotion:discount-activity:create', 3, 2, 2047, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-05 17:12:15', '', '2023-05-10 10:31:05', b'1');
INSERT INTO `system_menu` VALUES (2050, '限时折扣活动更新', 'promotion:discount-activity:update', 3, 3, 2047, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-05 17:12:16', '', '2023-05-10 10:31:08', b'1');
INSERT INTO `system_menu` VALUES (2051, '限时折扣活动删除', 'promotion:discount-activity:delete', 3, 4, 2047, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-05 17:12:16', '', '2023-05-10 10:31:12', b'1');
INSERT INTO `system_menu` VALUES (2052, '限时折扣活动关闭', 'promotion:discount-activity:close', 3, 5, 2047, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-05 17:12:16', '', '2023-05-10 10:31:15', b'1');
INSERT INTO `system_menu` VALUES (2059, '秒杀活动管理', '', 2, 0, 2030, 'seckill-activity', 'time-range', 'mall/promotion/seckill/seckillActivity/index', 'PromotionSeckillActivity', 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '1', '2023-05-10 10:32:38', b'1');
INSERT INTO `system_menu` VALUES (2060, '秒杀活动查询', 'promotion:seckill-activity:query', 3, 1, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '', '2023-05-10 10:32:20', b'1');
INSERT INTO `system_menu` VALUES (2061, '秒杀活动创建', 'promotion:seckill-activity:create', 3, 2, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '', '2023-05-10 10:32:23', b'1');
INSERT INTO `system_menu` VALUES (2062, '秒杀活动更新', 'promotion:seckill-activity:update', 3, 3, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '', '2023-05-10 10:32:26', b'1');
INSERT INTO `system_menu` VALUES (2063, '秒杀活动删除', 'promotion:seckill-activity:delete', 3, 4, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '', '2023-05-10 10:32:29', b'1');
INSERT INTO `system_menu` VALUES (2064, '秒杀活动导出', 'promotion:seckill-activity:export', 3, 5, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-06 22:24:49', '', '2023-05-10 10:32:32', b'1');
INSERT INTO `system_menu` VALUES (2066, '秒杀时段管理', '', 2, 0, 2030, 'seckill-time', '', 'mall/promotion/seckill/seckillTime/index', 'PromotionSeckillTime', 0, b'0', b'1', b'1', '', '2022-11-15 19:46:50', '1', '2023-05-10 10:32:14', b'1');
INSERT INTO `system_menu` VALUES (2067, '秒杀时段查询', 'promotion:seckill-time:query', 3, 1, 2066, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-15 19:46:51', '', '2023-05-10 10:31:57', b'1');
INSERT INTO `system_menu` VALUES (2068, '秒杀时段创建', 'promotion:seckill-time:create', 3, 2, 2066, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-15 19:46:51', '', '2023-05-10 10:32:00', b'1');
INSERT INTO `system_menu` VALUES (2069, '秒杀时段更新', 'promotion:seckill-time:update', 3, 3, 2066, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-15 19:46:51', '', '2023-05-10 10:32:03', b'1');
INSERT INTO `system_menu` VALUES (2070, '秒杀时段删除', 'promotion:seckill-time:delete', 3, 4, 2066, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-15 19:46:51', '', '2023-05-10 10:32:06', b'1');
INSERT INTO `system_menu` VALUES (2071, '秒杀时段导出', 'promotion:seckill-time:export', 3, 5, 2066, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-15 19:46:51', '', '2023-05-10 10:32:09', b'1');
INSERT INTO `system_menu` VALUES (2072, '订单中心', '', 1, 65, 0, '/trade', 'order', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-11-19 18:57:19', '1', '2023-05-10 10:30:11', b'1');
INSERT INTO `system_menu` VALUES (2073, '售后退款', '', 2, 1, 2072, 'trade/after-sale', 'education', 'mall/trade/afterSale/index', 'TradeAfterSale', 0, b'1', b'1', b'1', '', '2022-11-19 20:15:32', '1', '2023-05-10 10:30:03', b'1');
INSERT INTO `system_menu` VALUES (2074, '售后查询', 'trade:after-sale:query', 3, 1, 2073, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-11-19 20:15:33', '1', '2023-05-10 10:30:00', b'1');
INSERT INTO `system_menu` VALUES (2075, '秒杀活动关闭', 'promotion:sekill-activity:close', 3, 6, 2059, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2022-11-28 20:20:15', '1', '2023-05-10 10:32:35', b'1');
INSERT INTO `system_menu` VALUES (2076, '订单列表', '', 2, 0, 2072, 'trade/order', 'list', 'mall/trade/order/index', 'TradeOrder', 0, b'1', b'1', b'1', '1', '2022-12-10 21:05:44', '1', '2023-05-10 10:25:23', b'1');
INSERT INTO `system_menu` VALUES (2077, '物流公司管理管理', '', 2, 0, 2072, 'express-company', '', 'mall/trade/expressCompany/index', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '1', '2023-05-10 10:29:49', b'1');
INSERT INTO `system_menu` VALUES (2078, '物流公司管理查询', 'trade:express-company:query', 3, 1, 2077, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '', '2023-05-10 10:25:31', b'1');
INSERT INTO `system_menu` VALUES (2079, '物流公司管理创建', 'trade:express-company:create', 3, 2, 2077, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '', '2023-05-10 10:25:35', b'1');
INSERT INTO `system_menu` VALUES (2080, '物流公司管理更新', 'trade:express-company:update', 3, 3, 2077, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '', '2023-05-10 10:26:01', b'1');
INSERT INTO `system_menu` VALUES (2081, '物流公司管理删除', 'trade:express-company:delete', 3, 4, 2077, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '', '2023-05-10 10:26:06', b'1');
INSERT INTO `system_menu` VALUES (2082, '物流公司管理导出', 'trade:express-company:export', 3, 5, 2077, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-12-20 23:27:55', '', '2023-05-10 10:26:10', b'1');
INSERT INTO `system_menu` VALUES (2083, '地区管理', '', 2, 14, 1, 'area', 'row', 'system/area/index', 'SystemArea', 0, b'1', b'1', b'1', '1', '2022-12-23 17:35:05', '1', '2023-04-08 09:01:37', b'0');
INSERT INTO `system_menu` VALUES (2084, '公众号管理', '', 1, 100, 0, '/mp', 'wechat', NULL, NULL, 0, b'1', b'1', b'1', '1', '2023-01-01 20:11:04', '1', '2023-01-15 11:28:57', b'0');
INSERT INTO `system_menu` VALUES (2085, '账号管理', '', 2, 1, 2084, 'account', 'phone', 'mp/account/index', 'MpAccount', 0, b'1', b'1', b'1', '1', '2023-01-01 20:13:31', '1', '2023-02-09 23:56:39', b'0');
INSERT INTO `system_menu` VALUES (2086, '新增账号', 'mp:account:create', 3, 1, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-01 20:21:40', '1', '2023-01-07 17:32:53', b'0');
INSERT INTO `system_menu` VALUES (2087, '修改账号', 'mp:account:update', 3, 2, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:32:46', '1', '2023-01-07 17:32:46', b'0');
INSERT INTO `system_menu` VALUES (2088, '查询账号', 'mp:account:query', 3, 0, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:07', '1', '2023-01-07 17:33:07', b'0');
INSERT INTO `system_menu` VALUES (2089, '删除账号', 'mp:account:delete', 3, 3, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:21', '1', '2023-01-07 17:33:21', b'0');
INSERT INTO `system_menu` VALUES (2090, '生成二维码', 'mp:account:qr-code', 3, 4, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:58', '1', '2023-01-07 17:33:58', b'0');
INSERT INTO `system_menu` VALUES (2091, '清空 API 配额', 'mp:account:clear-quota', 3, 5, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 18:20:32', '1', '2023-01-07 18:20:59', b'0');
INSERT INTO `system_menu` VALUES (2092, '数据统计', 'mp:statistics:query', 2, 2, 2084, 'statistics', 'chart', 'mp/statistics/index', 'MpStatistics', 0, b'1', b'1', b'0', '1', '2023-01-07 20:17:36', '1', '2023-05-10 10:07:14', b'0');
INSERT INTO `system_menu` VALUES (2093, '标签管理', '', 2, 3, 2084, 'tag', 'rate', 'mp/tag/index', 'MpTag', 0, b'1', b'1', b'1', '1', '2023-01-08 11:37:32', '1', '2023-02-09 23:58:47', b'0');
INSERT INTO `system_menu` VALUES (2094, '查询标签', 'mp:tag:query', 3, 0, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:03', '1', '2023-01-08 11:59:03', b'0');
INSERT INTO `system_menu` VALUES (2095, '新增标签', 'mp:tag:create', 3, 1, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:23', '1', '2023-01-08 11:59:23', b'0');
INSERT INTO `system_menu` VALUES (2096, '修改标签', 'mp:tag:update', 3, 2, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:41', '1', '2023-01-08 11:59:41', b'0');
INSERT INTO `system_menu` VALUES (2097, '删除标签', 'mp:tag:delete', 3, 3, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 12:00:04', '1', '2023-01-08 12:00:13', b'0');
INSERT INTO `system_menu` VALUES (2098, '同步标签', 'mp:tag:sync', 3, 4, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 12:00:29', '1', '2023-01-08 12:00:29', b'0');
INSERT INTO `system_menu` VALUES (2099, '粉丝管理', '', 2, 4, 2084, 'user', 'people', 'mp/user/index', 'MpUser', 0, b'1', b'1', b'1', '1', '2023-01-08 16:51:20', '1', '2023-02-09 23:58:21', b'0');
INSERT INTO `system_menu` VALUES (2100, '查询粉丝', 'mp:user:query', 3, 0, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:16:59', '1', '2023-01-08 17:17:23', b'0');
INSERT INTO `system_menu` VALUES (2101, '修改粉丝', 'mp:user:update', 3, 1, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:17:11', '1', '2023-01-08 17:17:11', b'0');
INSERT INTO `system_menu` VALUES (2102, '同步粉丝', 'mp:user:sync', 3, 2, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:17:40', '1', '2023-01-08 17:17:40', b'0');
INSERT INTO `system_menu` VALUES (2103, '消息管理', '', 2, 5, 2084, 'message', 'email', 'mp/message/index', 'MpMessage', 0, b'1', b'1', b'1', '1', '2023-01-08 18:44:19', '1', '2023-02-09 23:58:02', b'0');
INSERT INTO `system_menu` VALUES (2104, '图文发表记录', '', 2, 10, 2084, 'free-publish', 'education', 'mp/freePublish/index', 'MpFreePublish', 0, b'1', b'1', b'1', '1', '2023-01-13 00:30:50', '1', '2023-02-09 23:57:22', b'0');
INSERT INTO `system_menu` VALUES (2105, '查询发布列表', 'mp:free-publish:query', 3, 1, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:19:17', '1', '2023-01-13 07:19:17', b'0');
INSERT INTO `system_menu` VALUES (2106, '发布草稿', 'mp:free-publish:submit', 3, 2, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:19:46', '1', '2023-01-13 07:19:46', b'0');
INSERT INTO `system_menu` VALUES (2107, '删除发布记录', 'mp:free-publish:delete', 3, 3, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:20:01', '1', '2023-01-13 07:20:01', b'0');
INSERT INTO `system_menu` VALUES (2108, '图文草稿箱', '', 2, 9, 2084, 'draft', 'edit', 'mp/draft/index', 'MpDraft', 0, b'1', b'1', b'0', '1', '2023-01-13 07:40:21', '1', '2023-05-10 10:07:04', b'0');
INSERT INTO `system_menu` VALUES (2109, '新建草稿', 'mp:draft:create', 3, 1, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 23:15:30', '1', '2023-01-13 23:15:44', b'0');
INSERT INTO `system_menu` VALUES (2110, '修改草稿', 'mp:draft:update', 3, 2, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:08:47', '1', '2023-01-14 10:08:47', b'0');
INSERT INTO `system_menu` VALUES (2111, '查询草稿', 'mp:draft:query', 3, 0, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:09:01', '1', '2023-01-14 10:09:01', b'0');
INSERT INTO `system_menu` VALUES (2112, '删除草稿', 'mp:draft:delete', 3, 3, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:09:19', '1', '2023-01-14 10:09:19', b'0');
INSERT INTO `system_menu` VALUES (2113, '素材管理', '', 2, 8, 2084, 'material', 'skill', 'mp/material/index', 'MpMaterial', 0, b'1', b'1', b'0', '1', '2023-01-14 14:12:07', '1', '2023-05-10 10:06:57', b'0');
INSERT INTO `system_menu` VALUES (2114, '上传临时素材', 'mp:material:upload-temporary', 3, 1, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:33:55', '1', '2023-01-14 15:33:55', b'0');
INSERT INTO `system_menu` VALUES (2115, '上传永久素材', 'mp:material:upload-permanent', 3, 2, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:34:14', '1', '2023-01-14 15:34:14', b'0');
INSERT INTO `system_menu` VALUES (2116, '删除素材', 'mp:material:delete', 3, 3, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:35:37', '1', '2023-01-14 15:35:37', b'0');
INSERT INTO `system_menu` VALUES (2117, '上传图文图片', 'mp:material:upload-news-image', 3, 4, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:36:31', '1', '2023-01-14 15:36:31', b'0');
INSERT INTO `system_menu` VALUES (2118, '查询素材', 'mp:material:query', 3, 5, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:39:22', '1', '2023-01-14 15:39:22', b'0');
INSERT INTO `system_menu` VALUES (2119, '菜单管理', '', 2, 6, 2084, 'menu', 'button', 'mp/menu/index', 'MpMenu', 0, b'1', b'1', b'0', '1', '2023-01-14 17:43:54', '1', '2023-05-10 10:06:06', b'0');
INSERT INTO `system_menu` VALUES (2120, '自动回复', '', 2, 7, 2084, 'auto-reply', 'eye', 'mp/autoReply/index', 'MpAutoReply', 0, b'1', b'1', b'0', '1', '2023-01-15 22:13:09', '1', '2023-05-10 10:06:49', b'0');
INSERT INTO `system_menu` VALUES (2121, '查询回复', 'mp:auto-reply:query', 3, 0, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:28:41', '1', '2023-01-16 22:28:41', b'0');
INSERT INTO `system_menu` VALUES (2122, '新增回复', 'mp:auto-reply:create', 3, 1, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:28:54', '1', '2023-01-16 22:28:54', b'0');
INSERT INTO `system_menu` VALUES (2123, '修改回复', 'mp:auto-reply:update', 3, 2, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:29:05', '1', '2023-01-16 22:29:05', b'0');
INSERT INTO `system_menu` VALUES (2124, '删除回复', 'mp:auto-reply:delete', 3, 3, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:29:34', '1', '2023-01-16 22:29:34', b'0');
INSERT INTO `system_menu` VALUES (2125, '查询菜单', 'mp:menu:query', 3, 0, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:05:41', '1', '2023-01-17 23:05:41', b'0');
INSERT INTO `system_menu` VALUES (2126, '保存菜单', 'mp:menu:save', 3, 1, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:06:01', '1', '2023-01-17 23:06:01', b'0');
INSERT INTO `system_menu` VALUES (2127, '删除菜单', 'mp:menu:delete', 3, 2, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:06:16', '1', '2023-01-17 23:06:16', b'0');
INSERT INTO `system_menu` VALUES (2128, '查询消息', 'mp:message:query', 3, 0, 2103, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:07:14', '1', '2023-01-17 23:07:14', b'0');
INSERT INTO `system_menu` VALUES (2129, '发送消息', 'mp:message:send', 3, 1, 2103, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:07:26', '1', '2023-01-17 23:07:26', b'0');
INSERT INTO `system_menu` VALUES (2130, '邮箱管理', '', 2, 11, 1, 'mail', 'email', NULL, NULL, 0, b'1', b'1', b'1', '1', '2023-01-25 17:27:44', '1', '2023-01-25 17:27:44', b'0');
INSERT INTO `system_menu` VALUES (2131, '邮箱账号', '', 2, 0, 2130, 'mail-account', 'user', 'system/mail/account/index', 'SystemMailAccount', 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '1', '2023-04-08 08:53:43', b'0');
INSERT INTO `system_menu` VALUES (2132, '账号查询', 'system:mail-account:query', 3, 1, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2133, '账号创建', 'system:mail-account:create', 3, 2, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2134, '账号更新', 'system:mail-account:update', 3, 3, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2135, '账号删除', 'system:mail-account:delete', 3, 4, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2136, '邮件模版', '', 2, 0, 2130, 'mail-template', 'education', 'system/mail/template/index', 'SystemMailTemplate', 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '1', '2023-04-08 08:53:34', b'0');
INSERT INTO `system_menu` VALUES (2137, '模版查询', 'system:mail-template:query', 3, 1, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2138, '模版创建', 'system:mail-template:create', 3, 2, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2139, '模版更新', 'system:mail-template:update', 3, 3, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2140, '模版删除', 'system:mail-template:delete', 3, 4, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2141, '邮件记录', '', 2, 0, 2130, 'mail-log', 'log', 'system/mail/log/index', 'SystemMailLog', 0, b'1', b'1', b'1', '', '2023-01-26 02:16:50', '1', '2023-04-08 08:53:49', b'0');
INSERT INTO `system_menu` VALUES (2142, '日志查询', 'system:mail-log:query', 3, 1, 2141, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-26 02:16:50', '', '2023-01-26 02:16:50', b'0');
INSERT INTO `system_menu` VALUES (2143, '发送测试邮件', 'system:mail-template:send-mail', 3, 5, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-26 23:29:15', '1', '2023-01-26 23:29:15', b'0');
INSERT INTO `system_menu` VALUES (2144, '站内信管理', '', 1, 11, 1, 'notify', 'message', NULL, NULL, 0, b'1', b'1', b'1', '1', '2023-01-28 10:25:18', '1', '2023-01-28 10:25:46', b'0');
INSERT INTO `system_menu` VALUES (2145, '模板管理', '', 2, 0, 2144, 'notify-template', 'education', 'system/notify/template/index', 'SystemNotifyTemplate', 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '1', '2023-04-08 08:54:39', b'0');
INSERT INTO `system_menu` VALUES (2146, '站内信模板查询', 'system:notify-template:query', 3, 1, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2147, '站内信模板创建', 'system:notify-template:create', 3, 2, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2148, '站内信模板更新', 'system:notify-template:update', 3, 3, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2149, '站内信模板删除', 'system:notify-template:delete', 3, 4, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2150, '发送测试站内信', 'system:notify-template:send-notify', 3, 5, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-28 10:54:43', '1', '2023-01-28 10:54:43', b'0');
INSERT INTO `system_menu` VALUES (2151, '消息记录', '', 2, 0, 2144, 'notify-message', 'edit', 'system/notify/message/index', 'SystemNotifyMessage', 0, b'1', b'1', b'1', '', '2023-01-28 04:28:22', '1', '2023-04-08 08:54:11', b'0');
INSERT INTO `system_menu` VALUES (2152, '站内信消息查询', 'system:notify-message:query', 3, 1, 2151, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 04:28:22', '', '2023-01-28 04:28:22', b'0');
INSERT INTO `system_menu` VALUES (2153, '大屏设计器', '', 2, 2, 1281, 'go-view', 'dashboard', 'report/goview/index', 'JimuReport', 0, b'1', b'1', b'1', '1', '2023-02-07 00:03:19', '1', '2023-05-10 10:35:14', b'1');
INSERT INTO `system_menu` VALUES (2154, '创建项目', 'report:go-view-project:create', 3, 1, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:14', '1', '2023-05-10 10:34:59', b'1');
INSERT INTO `system_menu` VALUES (2155, '更新项目', 'report:go-view-project:delete', 3, 2, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:34', '1', '2023-05-10 10:35:03', b'1');
INSERT INTO `system_menu` VALUES (2156, '查询项目', 'report:go-view-project:query', 3, 0, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:53', '1', '2023-05-10 10:34:56', b'1');
INSERT INTO `system_menu` VALUES (2157, '使用 SQL 查询数据', 'report:go-view-data:get-by-sql', 3, 3, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:26:15', '1', '2023-05-10 10:35:06', b'1');
INSERT INTO `system_menu` VALUES (2158, '使用 HTTP 查询数据', 'report:go-view-data:get-by-http', 3, 4, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:26:35', '1', '2023-05-10 10:35:10', b'1');
INSERT INTO `system_menu` VALUES (2161, '接入示例', '', 2, 99, 1117, 'demo-order', 'drag', 'pay/demo/index', NULL, 0, b'1', b'1', b'1', '', '2023-02-11 14:21:42', '1', '2023-07-09 09:47:51', b'1');
INSERT INTO `system_menu` VALUES (2162, '商品规格', '', 2, 3, 2174, 'store-product-rule', 'ep:operation', 'mall/shop/storeProductRule/index', 'StoreProductRule', 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '1', '2023-06-02 11:41:21', b'0');
INSERT INTO `system_menu` VALUES (2163, '商品规则值(规格)查询', 'shop:store-product-rule:query', 3, 1, 2162, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '', '2023-05-17 10:59:10', b'0');
INSERT INTO `system_menu` VALUES (2164, '商品规则值(规格)创建', 'shop:store-product-rule:create', 3, 2, 2162, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '', '2023-05-17 10:59:10', b'0');
INSERT INTO `system_menu` VALUES (2165, '商品规则值(规格)更新', 'shop:store-product-rule:update', 3, 3, 2162, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '', '2023-05-17 10:59:10', b'0');
INSERT INTO `system_menu` VALUES (2166, '商品规则值(规格)删除', 'shop:store-product-rule:delete', 3, 4, 2162, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '', '2023-05-17 10:59:10', b'0');
INSERT INTO `system_menu` VALUES (2167, '商品规则值(规格)导出', 'shop:store-product-rule:export', 3, 5, 2162, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '', '2023-05-17 10:59:10', b'0');
INSERT INTO `system_menu` VALUES (2168, '商品管理', '', 2, 4, 2174, 'store-product', 'ep:shopping-cart', 'mall/product/storeProduct/index', 'StoreProduct', 0, b'1', b'1', b'1', '', '2023-05-22 15:02:18', '1', '2023-06-30 10:38:39', b'0');
INSERT INTO `system_menu` VALUES (2169, '商品查询', 'shop:store-product:query', 3, 1, 2168, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-22 15:02:18', '', '2023-05-22 15:02:18', b'0');
INSERT INTO `system_menu` VALUES (2170, '商品创建', 'shop:store-product:create', 3, 2, 2168, '', '', '', '', 0, b'0', b'1', b'0', '', '2023-05-22 15:02:18', '1', '2023-05-26 14:23:49', b'0');
INSERT INTO `system_menu` VALUES (2171, '商品更新', 'shop:store-product:update', 3, 3, 2168, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-22 15:02:18', '', '2023-05-22 15:02:18', b'0');
INSERT INTO `system_menu` VALUES (2172, '商品删除', 'shop:store-product:delete', 3, 4, 2168, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-22 15:02:18', '', '2023-05-22 15:02:18', b'0');
INSERT INTO `system_menu` VALUES (2173, '商品导出', 'shop:store-product:export', 3, 5, 2168, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-05-22 15:02:18', '', '2023-05-22 15:02:18', b'0');
INSERT INTO `system_menu` VALUES (2174, '商品中心', '', 1, 4, 2000, 'product', 'ep:shopping-cart', '', '', 0, b'1', b'1', b'1', '1', '2023-06-02 11:24:04', '1', '2023-08-06 17:55:53', b'0');
INSERT INTO `system_menu` VALUES (2175, '订单中心', '', 1, 5, 2000, 'order', 'ep:list', '', '', 0, b'1', b'1', b'1', '1', '2023-06-02 11:29:29', '1', '2023-08-06 17:56:04', b'0');
INSERT INTO `system_menu` VALUES (2176, '用户中心', '', 1, 6, 2000, 'member', 'ep:user', '', '', 0, b'1', b'1', b'1', '1', '2023-06-02 11:33:44', '1', '2023-08-06 17:56:14', b'0');
INSERT INTO `system_menu` VALUES (2177, '运费模板', '', 2, 5, 2174, 'shipping-templates', 'ep:document-copy', 'mall/product/shippingTemplates/index', 'ShippingTemplates', 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '1', '2023-09-04 18:31:36', b'1');
INSERT INTO `system_menu` VALUES (2178, '运费模板查询', 'product:shipping-templates:query', 3, 1, 2177, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '', '2023-09-04 18:31:15', b'1');
INSERT INTO `system_menu` VALUES (2179, '运费模板创建', 'product:shipping-templates:create', 3, 2, 2177, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '', '2023-09-04 18:31:19', b'1');
INSERT INTO `system_menu` VALUES (2180, '运费模板更新', 'product:shipping-templates:update', 3, 3, 2177, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '', '2023-09-04 18:31:23', b'1');
INSERT INTO `system_menu` VALUES (2181, '运费模板删除', 'product:shipping-templates:delete', 3, 4, 2177, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '', '2023-09-04 18:31:27', b'1');
INSERT INTO `system_menu` VALUES (2182, '运费模板导出', 'product:shipping-templates:export', 3, 5, 2177, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-02 14:40:53', '', '2023-09-04 18:31:32', b'1');
INSERT INTO `system_menu` VALUES (2183, '用户管理', '', 2, 0, 2176, 'user', 'ep:user-filled', 'mall/member/user/index', 'User', 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '1', '2023-06-09 17:48:55', b'0');
INSERT INTO `system_menu` VALUES (2184, '用户查询', 'member:user:query', 3, 1, 2183, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '', '2023-06-09 15:05:05', b'0');
INSERT INTO `system_menu` VALUES (2185, '用户创建', 'member:user:create', 3, 2, 2183, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '', '2023-06-09 15:05:05', b'0');
INSERT INTO `system_menu` VALUES (2186, '用户更新', 'member:user:update', 3, 3, 2183, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '', '2023-06-09 15:05:05', b'0');
INSERT INTO `system_menu` VALUES (2187, '用户删除', 'member:user:delete', 3, 4, 2183, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '', '2023-06-09 15:05:05', b'0');
INSERT INTO `system_menu` VALUES (2188, '用户导出', 'member:user:export', 3, 5, 2183, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-09 15:05:05', '', '2023-06-09 15:05:05', b'0');
INSERT INTO `system_menu` VALUES (2189, '评论管理', '', 2, 6, 2174, 'store-product-reply', 'ep:message', 'product/storeProductReply/index', 'StoreProductReply', 0, b'1', b'1', b'1', '', '2023-06-13 09:47:30', '1', '2023-09-04 18:32:04', b'1');
INSERT INTO `system_menu` VALUES (2190, '评论查询', 'product:store-product-reply:query', 3, 1, 2189, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:47:30', '', '2023-09-04 18:31:44', b'1');
INSERT INTO `system_menu` VALUES (2191, '评论创建', 'product:store-product-reply:create', 3, 2, 2189, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:47:31', '', '2023-09-04 18:31:47', b'1');
INSERT INTO `system_menu` VALUES (2192, '评论更新', 'product:store-product-reply:update', 3, 3, 2189, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:47:31', '', '2023-09-04 18:31:52', b'1');
INSERT INTO `system_menu` VALUES (2193, '评论删除', 'product:store-product-reply:delete', 3, 4, 2189, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:47:31', '', '2023-09-04 18:31:56', b'1');
INSERT INTO `system_menu` VALUES (2194, '评论导出', 'product:store-product-reply:export', 3, 5, 2189, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:47:31', '', '2023-09-04 18:31:59', b'1');
INSERT INTO `system_menu` VALUES (2195, '收藏管理', '', 2, 7, 2174, 'store-product-relation', 'ep:collection', 'product/storeProductRelation/index', 'StoreProductRelation', 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '1', '2023-09-04 18:32:59', b'1');
INSERT INTO `system_menu` VALUES (2196, '商品点赞和收藏查询', 'product:store-product-relation:query', 3, 1, 2195, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '', '2023-09-04 18:32:39', b'1');
INSERT INTO `system_menu` VALUES (2197, '商品点赞和收藏创建', 'product:store-product-relation:create', 3, 2, 2195, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '', '2023-09-04 18:32:43', b'1');
INSERT INTO `system_menu` VALUES (2198, '商品点赞和收藏更新', 'product:store-product-relation:update', 3, 3, 2195, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '', '2023-09-04 18:32:47', b'1');
INSERT INTO `system_menu` VALUES (2199, '商品点赞和收藏删除', 'product:store-product-relation:delete', 3, 4, 2195, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '', '2023-09-04 18:32:51', b'1');
INSERT INTO `system_menu` VALUES (2200, '商品点赞和收藏导出', 'product:store-product-relation:export', 3, 5, 2195, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-13 09:49:46', '', '2023-09-04 18:32:54', b'1');
INSERT INTO `system_menu` VALUES (2201, '购物车管理', '', 2, 8, 2174, 'store-cart', 'ep:shopping-cart', 'cart/storeCart/index', 'StoreCart', 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '1', '2023-09-04 18:32:32', b'1');
INSERT INTO `system_menu` VALUES (2202, '购物车查询', 'cart:store-cart:query', 3, 1, 2201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '', '2023-09-04 18:32:13', b'1');
INSERT INTO `system_menu` VALUES (2203, '购物车创建', 'cart:store-cart:create', 3, 2, 2201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '', '2023-09-04 18:32:17', b'1');
INSERT INTO `system_menu` VALUES (2204, '购物车更新', 'cart:store-cart:update', 3, 3, 2201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '', '2023-09-04 18:32:20', b'1');
INSERT INTO `system_menu` VALUES (2205, '购物车删除', 'cart:store-cart:delete', 3, 4, 2201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '', '2023-09-04 18:32:24', b'1');
INSERT INTO `system_menu` VALUES (2206, '购物车导出', 'cart:store-cart:export', 3, 5, 2201, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-15 17:45:50', '', '2023-09-04 18:32:28', b'1');
INSERT INTO `system_menu` VALUES (2207, '订单管理', '', 2, 1, 2175, 'store-order', 'ep:scale-to-original', 'order/storeOrder/index', 'StoreOrder', 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '1', '2023-09-04 15:04:37', b'0');
INSERT INTO `system_menu` VALUES (2208, '订单查询', 'order:store-order:query', 3, 1, 2207, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '', '2023-06-17 21:58:17', b'0');
INSERT INTO `system_menu` VALUES (2209, '订单创建', 'order:store-order:create', 3, 2, 2207, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '', '2023-06-17 21:58:17', b'0');
INSERT INTO `system_menu` VALUES (2210, '订单更新', 'order:store-order:update', 3, 3, 2207, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '', '2023-06-17 21:58:17', b'0');
INSERT INTO `system_menu` VALUES (2211, '订单删除', 'order:store-order:delete', 3, 4, 2207, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '', '2023-06-17 21:58:17', b'0');
INSERT INTO `system_menu` VALUES (2212, '订单导出', 'order:store-order:export', 3, 5, 2207, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-17 21:58:17', '', '2023-06-17 21:58:17', b'0');
INSERT INTO `system_menu` VALUES (2213, '地址管理', '', 2, 0, 2176, 'user-address', 'ep:add-location', 'member/userAddress/index', 'UserAddress', 0, b'1', b'1', b'1', '', '2023-06-18 16:32:34', '1', '2023-07-08 16:34:26', b'0');
INSERT INTO `system_menu` VALUES (2214, '用户地址查询', 'member:user-address:query', 3, 1, 2213, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 16:32:34', '', '2023-06-18 16:32:34', b'0');
INSERT INTO `system_menu` VALUES (2215, '用户地址创建', 'member:user-address:create', 3, 2, 2213, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 16:32:34', '', '2023-06-18 16:32:34', b'0');
INSERT INTO `system_menu` VALUES (2216, '用户地址更新', 'member:user-address:update', 3, 3, 2213, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 16:32:35', '', '2023-06-18 16:32:35', b'0');
INSERT INTO `system_menu` VALUES (2217, '用户地址删除', 'member:user-address:delete', 3, 4, 2213, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 16:32:35', '', '2023-06-18 16:32:35', b'0');
INSERT INTO `system_menu` VALUES (2218, '用户地址导出', 'member:user-address:export', 3, 5, 2213, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 16:32:35', '', '2023-06-18 16:32:35', b'0');
INSERT INTO `system_menu` VALUES (2219, '用户账单管理', '', 2, 0, 2176, 'user-bill', '', 'member/userBill/index', 'UserBill', 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:34:05', b'1');
INSERT INTO `system_menu` VALUES (2220, '用户账单查询', 'member:user-bill:query', 3, 1, 2219, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:33:41', b'1');
INSERT INTO `system_menu` VALUES (2221, '用户账单创建', 'member:user-bill:create', 3, 2, 2219, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:33:48', b'1');
INSERT INTO `system_menu` VALUES (2222, '用户账单更新', 'member:user-bill:update', 3, 3, 2219, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:33:52', b'1');
INSERT INTO `system_menu` VALUES (2223, '用户账单删除', 'member:user-bill:delete', 3, 4, 2219, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:33:56', b'1');
INSERT INTO `system_menu` VALUES (2224, '用户账单导出', 'member:user-bill:export', 3, 5, 2219, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:33:57', '', '2023-07-08 16:34:00', b'1');
INSERT INTO `system_menu` VALUES (2225, '售后订单', '', 2, 2, 2175, 'store-after-sales', 'ep:fold', 'order/storeAfterSales/index', 'StoreAfterSales', 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '1', '2023-09-04 17:01:23', b'1');
INSERT INTO `system_menu` VALUES (2226, '售后记录查询', 'order:store-after-sales:query', 3, 1, 2225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '', '2023-09-04 17:01:01', b'1');
INSERT INTO `system_menu` VALUES (2227, '售后记录创建', 'order:store-after-sales:create', 3, 2, 2225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '', '2023-09-04 17:01:05', b'1');
INSERT INTO `system_menu` VALUES (2228, '售后记录更新', 'order:store-after-sales:update', 3, 3, 2225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '', '2023-09-04 17:01:10', b'1');
INSERT INTO `system_menu` VALUES (2229, '售后记录删除', 'order:store-after-sales:delete', 3, 4, 2225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '', '2023-09-04 17:01:14', b'1');
INSERT INTO `system_menu` VALUES (2230, '售后记录导出', 'order:store-after-sales:export', 3, 5, 2225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-06-18 20:46:31', '', '2023-09-04 17:01:19', b'1');
INSERT INTO `system_menu` VALUES (2231, '快递公司', '', 2, 1, 2243, 'express', 'ep:expand', 'express/index', 'Express', 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '1', '2023-12-02 09:51:56', b'0');
INSERT INTO `system_menu` VALUES (2232, '快递公司查询', 'order:express:query', 3, 1, 2231, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '', '2023-12-01 18:18:51', b'0');
INSERT INTO `system_menu` VALUES (2233, '快递公司创建', 'order:express:create', 3, 2, 2231, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '', '2023-12-01 18:18:54', b'0');
INSERT INTO `system_menu` VALUES (2234, '快递公司更新', 'order:express:update', 3, 3, 2231, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '', '2023-12-01 18:18:56', b'0');
INSERT INTO `system_menu` VALUES (2235, '快递公司删除', 'order:express:delete', 3, 4, 2231, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '', '2023-12-01 18:19:05', b'0');
INSERT INTO `system_menu` VALUES (2236, '快递公司导出', 'order:express:export', 3, 5, 2231, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-02 10:12:24', '', '2023-12-01 18:19:12', b'0');
INSERT INTO `system_menu` VALUES (2237, '支付配置', '', 2, 0, 1117, 'merchant-details', 'ep:money', 'pay/merchantDetails/index', 'MerchantDetails', 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '1', '2023-07-14 15:09:50', b'0');
INSERT INTO `system_menu` VALUES (2238, '支付服务商配置查询', 'pay:merchant-details:query', 3, 1, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2239, '支付服务商配置创建', 'pay:merchant-details:create', 3, 2, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2240, '支付服务商配置更新', 'pay:merchant-details:update', 3, 3, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2241, '支付服务商配置删除', 'pay:merchant-details:delete', 3, 4, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2242, '支付服务商配置导出', 'pay:merchant-details:export', 3, 5, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2243, '快递管理', '', 1, 91, 0, '/express', 'rate', '', '', 0, b'1', b'1', b'1', '1', '2023-07-19 15:36:23', '1', '2023-12-01 18:19:20', b'0');
INSERT INTO `system_menu` VALUES (2244, '快递鸟配置', '', 2, 3, 2243, 'set', 'ep:setting', 'express/ExpressSet', 'set', 0, b'1', b'1', b'1', '1', '2023-07-19 16:09:26', '1', '2023-12-02 09:51:45', b'0');
INSERT INTO `system_menu` VALUES (2245, '电子面单', '', 2, 2, 2243, 'electronics-order', 'ep:help', 'order/electronicsOrder/index', 'ElectronicsOrder', 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '1', '2023-09-04 17:03:12', b'1');
INSERT INTO `system_menu` VALUES (2246, '电子面单查询', 'express:electronics-order:query', 3, 1, 2245, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '', '2023-09-04 17:02:52', b'1');
INSERT INTO `system_menu` VALUES (2247, '电子面单创建', 'express:electronics-order:create', 3, 2, 2245, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '', '2023-09-04 17:02:56', b'1');
INSERT INTO `system_menu` VALUES (2248, '电子面单更新', 'express:electronics-order:update', 3, 3, 2245, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '', '2023-09-04 17:02:59', b'1');
INSERT INTO `system_menu` VALUES (2249, '电子面单删除', 'express:electronics-order:delete', 3, 4, 2245, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '', '2023-09-04 17:03:03', b'1');
INSERT INTO `system_menu` VALUES (2250, '电子面单导出', 'express:electronics-order:export', 3, 5, 2245, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-20 17:50:23', '', '2023-09-04 17:03:07', b'1');
INSERT INTO `system_menu` VALUES (2251, '电子面单记录', '', 2, 3, 2175, 'store-order-electronics', 'ep:list', 'order/storeOrderElectronics/index', 'StoreOrderElectronics', 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '1', '2023-09-04 17:01:50', b'1');
INSERT INTO `system_menu` VALUES (2252, '订单电子面单记录查询', 'order:store-order-electronics:query', 3, 1, 2251, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '', '2023-09-04 17:01:31', b'1');
INSERT INTO `system_menu` VALUES (2253, '订单电子面单记录创建', 'order:store-order-electronics:create', 3, 2, 2251, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '', '2023-09-04 17:01:34', b'1');
INSERT INTO `system_menu` VALUES (2254, '订单电子面单记录更新', 'order:store-order-electronics:update', 3, 3, 2251, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '', '2023-09-04 17:01:38', b'1');
INSERT INTO `system_menu` VALUES (2255, '订单电子面单记录删除', 'order:store-order-electronics:delete', 3, 4, 2251, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '', '2023-09-04 17:01:42', b'1');
INSERT INTO `system_menu` VALUES (2256, '订单电子面单记录导出', 'order:store-order-electronics:export', 3, 5, 2251, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-22 17:36:49', '', '2023-09-04 17:01:46', b'1');
INSERT INTO `system_menu` VALUES (2257, '消息管理', '', 1, 92, 0, '/message', 'rate', '', '', 0, b'1', b'1', b'1', '1', '2023-07-25 09:41:06', '1', '2023-07-25 10:05:51', b'0');
INSERT INTO `system_menu` VALUES (2258, '微信消息', '', 2, 0, 2257, 'wechat-template', 'ep:message', 'message/wechatTemplate/index', 'WechatTemplate', 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '1', '2023-07-25 10:06:49', b'0');
INSERT INTO `system_menu` VALUES (2259, '微信模板查询', 'message:wechat-template:query', 3, 1, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2023-07-25 09:45:42', b'0');
INSERT INTO `system_menu` VALUES (2260, '微信模板创建', 'message:wechat-template:create', 3, 2, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2023-07-25 09:45:42', b'0');
INSERT INTO `system_menu` VALUES (2261, '微信模板更新', 'message:wechat-template:update', 3, 3, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2023-07-25 09:45:42', b'0');
INSERT INTO `system_menu` VALUES (2262, '微信模板删除', 'message:wechat-template:delete', 3, 4, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2023-07-25 09:45:42', b'0');
INSERT INTO `system_menu` VALUES (2263, '微信模板导出', 'message:wechat-template:export', 3, 5, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2023-07-25 09:45:42', b'0');
INSERT INTO `system_menu` VALUES (2264, '门店管理', '', 2, 1, 2000, 'shop', 'ep:briefcase', '/mall/store/shop/index', 'StoreShop', 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '1', '2023-09-06 10:38:09', b'0');
INSERT INTO `system_menu` VALUES (2265, '门店管理查询', 'store:shop:query', 3, 1, 2264, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '', '2023-08-03 14:42:11', b'0');
INSERT INTO `system_menu` VALUES (2266, '门店管理创建', 'store:shop:create', 3, 2, 2264, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '', '2023-08-03 14:42:11', b'0');
INSERT INTO `system_menu` VALUES (2267, '门店管理更新', 'store:shop:update', 3, 3, 2264, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '', '2023-08-03 14:42:11', b'0');
INSERT INTO `system_menu` VALUES (2268, '门店管理删除', 'store:shop:delete', 3, 4, 2264, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '', '2023-08-03 14:42:11', b'0');
INSERT INTO `system_menu` VALUES (2269, '门店管理导出', 'store:shop:export', 3, 5, 2264, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-03 14:42:11', '', '2023-08-03 14:42:11', b'0');
INSERT INTO `system_menu` VALUES (2270, '广告图管理', '', 2, 2, 2000, 'ads', 'ep:camera-filled', 'shop/ads/index', 'ShopAds', 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '1', '2023-09-06 10:38:20', b'0');
INSERT INTO `system_menu` VALUES (2271, '广告图管理查询', 'shop:ads:query', 3, 1, 2270, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '', '2023-08-06 16:53:34', b'0');
INSERT INTO `system_menu` VALUES (2272, '广告图管理创建', 'shop:ads:create', 3, 2, 2270, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '', '2023-08-06 16:53:34', b'0');
INSERT INTO `system_menu` VALUES (2273, '广告图管理更新', 'shop:ads:update', 3, 3, 2270, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '', '2023-08-06 16:53:34', b'0');
INSERT INTO `system_menu` VALUES (2274, '广告图管理删除', 'shop:ads:delete', 3, 4, 2270, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '', '2023-08-06 16:53:34', b'0');
INSERT INTO `system_menu` VALUES (2275, '广告图管理导出', 'shop:ads:export', 3, 5, 2270, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 16:53:34', '', '2023-08-06 16:53:34', b'0');
INSERT INTO `system_menu` VALUES (2276, '我的服务', '', 2, 3, 2000, 'service', 'ep:dessert', 'shop/service/index', 'Service', 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '1', '2023-09-06 10:38:33', b'0');
INSERT INTO `system_menu` VALUES (2277, '我的服务查询', 'shop:service:query', 3, 1, 2276, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '', '2023-08-06 17:05:02', b'0');
INSERT INTO `system_menu` VALUES (2278, '我的服务创建', 'shop:service:create', 3, 2, 2276, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '', '2023-08-06 17:05:02', b'0');
INSERT INTO `system_menu` VALUES (2279, '我的服务更新', 'shop:service:update', 3, 3, 2276, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '', '2023-08-06 17:05:02', b'0');
INSERT INTO `system_menu` VALUES (2280, '我的服务删除', 'shop:service:delete', 3, 4, 2276, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '', '2023-08-06 17:05:02', b'0');
INSERT INTO `system_menu` VALUES (2281, '我的服务导出', 'shop:service:export', 3, 5, 2276, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:05:02', '', '2023-08-06 17:05:02', b'0');
INSERT INTO `system_menu` VALUES (2282, '充值金额', '', 2, 7, 2000, 'recharge', 'ep:money', 'shop/recharge/index', 'Recharge', 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '1', '2023-12-08 10:25:23', b'1');
INSERT INTO `system_menu` VALUES (2283, '充值金额管理查询', 'shop:recharge:query', 3, 1, 2282, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '', '2023-12-08 10:25:05', b'1');
INSERT INTO `system_menu` VALUES (2284, '充值金额管理创建', 'shop:recharge:create', 3, 2, 2282, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '', '2023-12-08 10:25:09', b'1');
INSERT INTO `system_menu` VALUES (2285, '充值金额管理更新', 'shop:recharge:update', 3, 3, 2282, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '', '2023-12-08 10:25:12', b'1');
INSERT INTO `system_menu` VALUES (2286, '充值金额管理删除', 'shop:recharge:delete', 3, 4, 2282, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '', '2023-12-08 10:25:15', b'1');
INSERT INTO `system_menu` VALUES (2287, '充值金额管理导出', 'shop:recharge:export', 3, 5, 2282, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-06 17:14:26', '', '2023-12-08 10:25:19', b'1');
INSERT INTO `system_menu` VALUES (2288, '优惠券管理', '', 2, 8, 2000, 'coupons', 'ep:discount', 'mall/coupon/index', 'Coupon', 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '1', '2023-09-06 10:39:28', b'0');
INSERT INTO `system_menu` VALUES (2289, '优惠券查询', 'coupon::query', 3, 1, 2288, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '', '2023-08-08 15:24:18', b'0');
INSERT INTO `system_menu` VALUES (2290, '优惠券创建', 'coupon::create', 3, 2, 2288, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '', '2023-08-08 15:24:18', b'0');
INSERT INTO `system_menu` VALUES (2291, '优惠券更新', 'coupon::update', 3, 3, 2288, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '', '2023-08-08 15:24:18', b'0');
INSERT INTO `system_menu` VALUES (2292, '优惠券删除', 'coupon::delete', 3, 4, 2288, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '', '2023-08-08 15:24:18', b'0');
INSERT INTO `system_menu` VALUES (2293, '优惠券导出', 'coupon::export', 3, 5, 2288, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-08 15:24:18', '', '2023-08-08 15:24:18', b'0');
INSERT INTO `system_menu` VALUES (2294, '订单管理', '', 2, 1, 2306, 'order', 'ep:list', 'score/order/index', 'ScoreOrder', 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '1', '2023-12-08 09:42:51', b'1');
INSERT INTO `system_menu` VALUES (2295, '积分商城订单查询', 'score:order:query', 3, 1, 2294, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '', '2023-12-08 09:42:33', b'1');
INSERT INTO `system_menu` VALUES (2296, '积分商城订单创建', 'score:order:create', 3, 2, 2294, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '', '2023-12-08 09:42:37', b'1');
INSERT INTO `system_menu` VALUES (2297, '积分商城订单更新', 'score:order:update', 3, 3, 2294, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '', '2023-12-08 09:42:41', b'1');
INSERT INTO `system_menu` VALUES (2298, '积分商城订单删除', 'score:order:delete', 3, 4, 2294, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '', '2023-12-08 09:42:44', b'1');
INSERT INTO `system_menu` VALUES (2299, '积分商城订单导出', 'score:order:export', 3, 5, 2294, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:23:38', '', '2023-12-08 09:42:48', b'1');
INSERT INTO `system_menu` VALUES (2300, '产品管理', '', 2, 0, 2306, 'product', 'ep:shopping-cart-full', 'score/product/index', 'ScoreProduct', 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '1', '2023-12-08 09:42:26', b'1');
INSERT INTO `system_menu` VALUES (2301, '积分产品查询', 'score:product:query', 3, 1, 2300, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '', '2023-12-08 09:41:17', b'1');
INSERT INTO `system_menu` VALUES (2302, '积分产品创建', 'score:product:create', 3, 2, 2300, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '', '2023-12-08 09:42:08', b'1');
INSERT INTO `system_menu` VALUES (2303, '积分产品更新', 'score:product:update', 3, 3, 2300, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '', '2023-12-08 09:42:12', b'1');
INSERT INTO `system_menu` VALUES (2304, '积分产品删除', 'score:product:delete', 3, 4, 2300, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '', '2023-12-08 09:42:16', b'1');
INSERT INTO `system_menu` VALUES (2305, '积分产品导出', 'score:product:export', 3, 5, 2300, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-08-09 16:24:11', '', '2023-12-08 09:42:19', b'1');
INSERT INTO `system_menu` VALUES (2306, '积分商城', '', 1, 70, 0, '/score', 'rate', '', '', 0, b'1', b'1', b'1', '1', '2023-08-09 16:49:19', '1', '2023-12-08 09:42:56', b'1');
INSERT INTO `system_menu` VALUES (2307, '工作台', '', 2, 0, 2175, 'store-order-work', 'ep:bell-filled', 'order/storeOrder/work', 'StoreOrderWork', 0, b'1', b'1', b'1', '1', '2023-09-04 15:04:14', '1', '2023-09-04 15:04:14', b'0');
INSERT INTO `system_menu` VALUES (2308, '打印机管理', '', 2, 0, 2000, 'web-print', 'ep:printer', 'store/webPrint/index', 'WebPrint', 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '1', '2023-12-08 10:05:25', b'1');
INSERT INTO `system_menu` VALUES (2309, '易联云打印机查询', 'store:web-print:query', 3, 1, 2308, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '', '2023-12-08 10:05:07', b'1');
INSERT INTO `system_menu` VALUES (2310, '易联云打印机创建', 'store:web-print:create', 3, 2, 2308, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '', '2023-12-08 10:05:10', b'1');
INSERT INTO `system_menu` VALUES (2311, '易联云打印机更新', 'store:web-print:update', 3, 3, 2308, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '', '2023-12-08 10:05:13', b'1');
INSERT INTO `system_menu` VALUES (2312, '易联云打印机删除', 'store:web-print:delete', 3, 4, 2308, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '', '2023-12-08 10:05:17', b'1');
INSERT INTO `system_menu` VALUES (2313, '易联云打印机导出', 'store:web-print:export', 3, 5, 2308, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-09-06 10:19:34', '', '2023-12-08 10:05:21', b'1');
COMMIT;

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容',
  `type` tinyint NOT NULL COMMENT '公告类型（1通知 2公告）',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';

-- ----------------------------
-- Records of system_notice
-- ----------------------------
BEGIN;
INSERT INTO `system_notice` VALUES (1, 'B2C单商户微服务-统计报表功能正式发布！', '<p>新版本内容133</p>', 1, 0, 'admin', '2021-01-05 17:03:48', '1', '2023-07-26 14:30:37', b'0', 1);
INSERT INTO `system_notice` VALUES (2, '618最后三天,你还不来', '<p><img src=\"http://test.yshop.iocoder.cn/b7cb3cf49b4b3258bf7309a09dd2f4e5.jpg\">维护内容</p>', 2, 1, 'admin', '2021-01-05 17:03:48', '1', '2023-07-26 14:30:13', b'0', 1);
INSERT INTO `system_notice` VALUES (4, 'YSHOP-PRO 预售开始啦', '<p>哈哈哈哈123</p>', 1, 0, '110', '2022-02-22 01:01:25', '1', '2024-06-01 14:26:15', b'0', 121);
COMMIT;

-- ----------------------------
-- Table structure for system_notify_message
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_message`;
CREATE TABLE `system_notify_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `template_id` bigint NOT NULL COMMENT '模版编号',
  `template_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_nickname` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版发送人名称',
  `template_content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版内容',
  `template_type` int NOT NULL COMMENT '模版类型',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版参数',
  `read_status` bit(1) NOT NULL COMMENT '是否已读',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内信消息表';

-- ----------------------------
-- Records of system_notify_message
-- ----------------------------
BEGIN;
INSERT INTO `system_notify_message` VALUES (2, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{\"name\":\"1\",\"what\":\"2\"}', b'1', '2023-02-10 00:47:04', '1', '2023-01-28 11:44:08', '1', '2023-02-10 00:47:04', b'0', 1);
INSERT INTO `system_notify_message` VALUES (3, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{\"name\":\"1\",\"what\":\"2\"}', b'1', '2023-02-10 00:47:04', '1', '2023-01-28 11:45:04', '1', '2023-02-10 00:47:04', b'0', 1);
INSERT INTO `system_notify_message` VALUES (4, 103, 2, 2, 'register', '系统消息', '你好，欢迎 哈哈 加入大家庭！', 2, '{\"name\":\"哈哈\"}', b'0', NULL, '1', '2023-01-28 21:02:20', '1', '2023-01-28 21:02:20', b'0', 1);
INSERT INTO `system_notify_message` VALUES (5, 1, 2, 1, 'test', '123', '我是 芋艿，我开始 写代码 了', 1, '{\"name\":\"芋艿\",\"what\":\"写代码\"}', b'1', '2023-02-10 00:47:04', '1', '2023-01-28 22:21:42', '1', '2023-02-10 00:47:04', b'0', 1);
INSERT INTO `system_notify_message` VALUES (6, 1, 2, 1, 'test', '123', '我是 芋艿，我开始 写代码 了', 1, '{\"name\":\"芋艿\",\"what\":\"写代码\"}', b'1', '2023-01-29 10:52:06', '1', '2023-01-28 22:22:07', '1', '2023-01-29 10:52:06', b'0', 1);
INSERT INTO `system_notify_message` VALUES (7, 1, 2, 1, 'test', '123', '我是 2，我开始 3 了', 1, '{\"name\":\"2\",\"what\":\"3\"}', b'1', '2023-01-29 10:52:06', '1', '2023-01-28 23:45:21', '1', '2023-01-29 10:52:06', b'0', 1);
INSERT INTO `system_notify_message` VALUES (8, 1, 2, 2, 'register', '系统消息', '你好，欢迎 123 加入大家庭！', 2, '{\"name\":\"123\"}', b'1', '2023-01-29 10:52:06', '1', '2023-01-28 23:50:21', '1', '2023-01-29 10:52:06', b'0', 1);
COMMIT;

-- ----------------------------
-- Table structure for system_notify_template
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_template`;
CREATE TABLE `system_notify_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版编码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送人名称',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版内容',
  `type` tinyint NOT NULL COMMENT '类型',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '参数数组',
  `status` tinyint NOT NULL COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内信模板表';

-- ----------------------------
-- Records of system_notify_template
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_oauth2_access_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_access_token`;
CREATE TABLE `system_oauth2_access_token` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `user_info` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户信息',
  `access_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问令牌',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '刷新令牌',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  `shop_id` bigint DEFAULT '0' COMMENT '门店id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 访问令牌';

-- ----------------------------
-- Records of system_oauth2_access_token
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_oauth2_approve
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_approve`;
CREATE TABLE `system_oauth2_approve` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '授权范围',
  `approved` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否接受',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 批准表';

-- ----------------------------
-- Records of system_oauth2_approve
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_oauth2_client
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_client`;
CREATE TABLE `system_oauth2_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端密钥',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '应用描述',
  `status` tinyint NOT NULL COMMENT '状态',
  `access_token_validity_seconds` int NOT NULL COMMENT '访问令牌的有效期',
  `refresh_token_validity_seconds` int NOT NULL COMMENT '刷新令牌的有效期',
  `redirect_uris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '可重定向的 URI 地址',
  `authorized_grant_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权类型',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '授权范围',
  `auto_approve_scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '自动通过的授权范围',
  `authorities` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限',
  `resource_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资源',
  `additional_information` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '附加信息',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 客户端表';

-- ----------------------------
-- Records of system_oauth2_client
-- ----------------------------
BEGIN;
INSERT INTO `system_oauth2_client` VALUES (1, 'default', 'admin123', 'yshop', 'http://test.yshop.iocoder.cn/a5e2e244368878a366b516805a4aabf1.png', '我是描述', 0, 18000000, 43200, '[\"https://www.iocoder.cn\",\"https://doc.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[\"user.read\",\"user.write\"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2023-06-12 10:01:30', b'0');
INSERT INTO `system_oauth2_client` VALUES (40, 'test', 'test2', 'biubiu', 'http://test.yshop.iocoder.cn/277a899d573723f1fcdfb57340f00379.png', NULL, 0, 1800, 43200, '[\"https://www.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\"]', '[\"user_info\",\"projects\"]', '[\"user_info\"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1', '2022-06-19 00:26:13', b'0');
INSERT INTO `system_oauth2_client` VALUES (41, 'yshop-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？', 'http://test.yshop.iocoder.cn/fe4ed36596adad5120036ef61a6d0153654544d44af8dd4ad3ffe8f759933d6f.png', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"authorization_code\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-09-29 13:28:31', '1', '2022-09-29 13:28:31', b'0');
INSERT INTO `system_oauth2_client` VALUES (42, 'yshop-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？', 'http://test.yshop.iocoder.cn/604bdc695e13b3b22745be704d1f2aa8ee05c5f26f9fead6d1ca49005afbc857.jpeg', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"password\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-10-04 17:40:16', '1', '2022-10-04 20:31:21', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_oauth2_code
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_code`;
CREATE TABLE `system_oauth2_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权码',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '可重定向的 URI 地址',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 授权码表';

-- ----------------------------
-- Records of system_oauth2_code
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_oauth2_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_refresh_token`;
CREATE TABLE `system_oauth2_refresh_token` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '刷新令牌',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '授权范围',
  `expires_time` datetime NOT NULL COMMENT '过期时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  `shop_id` bigint DEFAULT '0' COMMENT '门店ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1671 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 刷新令牌';

-- ----------------------------
-- Records of system_oauth2_refresh_token
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `system_operate_log`;
CREATE TABLE `system_operate_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '链路追踪编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL DEFAULT '0' COMMENT '用户类型',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作模块类型',
  `sub_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作名',
  `biz_id` bigint NOT NULL COMMENT '操作数据模块编号',
  `action` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作内容',
  `extra` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '拓展字段',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求方法名',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求地址',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户 IP',
  `user_agent` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '浏览器 UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9038 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录 V2 版本';

-- ----------------------------
-- Records of system_operate_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_post
-- ----------------------------
DROP TABLE IF EXISTS `system_post`;
CREATE TABLE `system_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `sort` int NOT NULL COMMENT '显示顺序',
  `status` tinyint NOT NULL COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';

-- ----------------------------
-- Records of system_post
-- ----------------------------
BEGIN;
INSERT INTO `system_post` VALUES (1, 'ceo', '董事长', 1, 0, '', 'admin', '2021-01-06 17:03:48', '1', '2023-02-11 15:19:04', b'0', 1);
INSERT INTO `system_post` VALUES (2, 'se', '项目经理', 2, 0, '', 'admin', '2021-01-05 17:03:48', '1', '2021-12-12 10:47:47', b'0', 1);
INSERT INTO `system_post` VALUES (4, 'user', '普通员工', 4, 0, '111', 'admin', '2021-01-05 17:03:48', '1', '2023-02-11 15:19:00', b'0', 1);
COMMIT;

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` tinyint NOT NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `data_scope_dept_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据范围(指定部门数组)',
  `status` tinyint NOT NULL COMMENT '角色状态（0正常 1停用）',
  `type` tinyint NOT NULL COMMENT '角色类型',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

-- ----------------------------
-- Records of system_role
-- ----------------------------
BEGIN;
INSERT INTO `system_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:21', b'0', 1);
INSERT INTO `system_role` VALUES (2, '门店角色', 'common', 2, 2, '', 0, 1, '普通角色', 'admin', '2021-01-05 17:03:48', '', '2023-09-05 10:13:24', b'0', 1);
COMMIT;

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of system_role_menu
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_sensitive_word
-- ----------------------------
DROP TABLE IF EXISTS `system_sensitive_word`;
CREATE TABLE `system_sensitive_word` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '敏感词',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签数组',
  `status` tinyint NOT NULL COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='敏感词';

-- ----------------------------
-- Records of system_sensitive_word
-- ----------------------------
BEGIN;
INSERT INTO `system_sensitive_word` VALUES (3, '土豆', '好呀', '蔬菜,短信', 0, '1', '2022-04-08 21:07:12', '1', '2022-04-09 10:28:14', b'0');
INSERT INTO `system_sensitive_word` VALUES (4, 'XXX', NULL, '短信', 0, '1', '2022-04-08 21:27:49', '1', '2022-06-19 00:36:50', b'0');
INSERT INTO `system_sensitive_word` VALUES (5, '白痴', NULL, '测试', 0, '1', '2022-12-31 19:08:25', '1', '2022-12-31 19:08:25', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_sms_channel
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_channel`;
CREATE TABLE `system_sms_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `signature` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信签名',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '渠道编码',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `api_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的账号',
  `api_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信 API 的秘钥',
  `callback_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信发送回调 URL',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信渠道';

-- ----------------------------
-- Records of system_sms_channel
-- ----------------------------
BEGIN;
INSERT INTO `system_sms_channel` VALUES (2, 'yshop', 'ALIYUN', 0, '啦啦啦', '', '', NULL, '', '2021-03-31 11:53:10', '1', '2023-07-31 10:10:34', b'0');
INSERT INTO `system_sms_channel` VALUES (4, '测试渠道', 'DEBUG_DING_TALK', 0, '123', '', '', NULL, '1', '2021-04-13 00:23:14', '1', '2022-03-27 20:29:49', b'0');
INSERT INTO `system_sms_channel` VALUES (6, '测试演示', 'DEBUG_DING_TALK', 0, NULL, '', '', NULL, '1', '2022-04-10 23:07:59', '1', '2022-06-19 00:33:54', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_sms_code
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_code`;
CREATE TABLE `system_sms_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码',
  `create_ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建 IP',
  `scene` tinyint NOT NULL COMMENT '发送场景',
  `today_index` tinyint NOT NULL COMMENT '今日发送的第几条',
  `used` tinyint NOT NULL COMMENT '是否使用',
  `used_time` datetime DEFAULT NULL COMMENT '使用时间',
  `used_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '使用 IP',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_mobile` (`mobile`) USING BTREE COMMENT '手机号'
) ENGINE=InnoDB AUTO_INCREMENT=546 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='手机验证码';

-- ----------------------------
-- Records of system_sms_code
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_log`;
CREATE TABLE `system_sms_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信渠道编码',
  `template_id` bigint NOT NULL COMMENT '模板编号',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `template_type` tinyint NOT NULL COMMENT '短信类型',
  `template_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信内容',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信参数',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的模板编号',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_type` tinyint DEFAULT NULL COMMENT '用户类型',
  `send_status` tinyint NOT NULL DEFAULT '0' COMMENT '发送状态',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `send_code` int DEFAULT NULL COMMENT '发送结果的编码',
  `send_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发送结果的提示',
  `api_send_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信 API 发送结果的编码',
  `api_send_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信 API 发送失败的提示',
  `api_request_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信 API 发送返回的唯一请求 ID',
  `api_serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '短信 API 发送返回的序号',
  `receive_status` tinyint NOT NULL DEFAULT '0' COMMENT '接收状态',
  `receive_time` datetime DEFAULT NULL COMMENT '接收时间',
  `api_receive_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'API 接收结果的编码',
  `api_receive_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'API 接收结果的说明',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=411 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信日志';

-- ----------------------------
-- Records of system_sms_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_template`;
CREATE TABLE `system_sms_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` tinyint NOT NULL COMMENT '短信签名',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板内容',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数数组',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信 API 的模板编号',
  `channel_id` bigint NOT NULL COMMENT '短信渠道编号',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '短信渠道编码',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信模板';

-- ----------------------------
-- Records of system_sms_template
-- ----------------------------
BEGIN;
INSERT INTO `system_sms_template` VALUES (2, 1, 0, 'test_01', '测试验证码短信', '正在进行登录操作{operation}，您的验证码是{code}', '[\"operation\",\"code\"]', NULL, '4383920', 6, 'DEBUG_DING_TALK', '', '2021-03-31 10:49:38', '1', '2022-12-10 21:26:20', b'0');
INSERT INTO `system_sms_template` VALUES (3, 1, 0, 'test_02', '公告通知', '您的验证码{code}，该验证码5分钟内有效，请勿泄漏于他人！', '[\"code\"]', NULL, 'SMS_207945135', 2, 'ALIYUN', '', '2021-03-31 11:56:30', '1', '2021-04-10 01:22:02', b'0');
INSERT INTO `system_sms_template` VALUES (6, 3, 0, 'test-01', '测试模板', '哈哈哈 {name}', '[\"name\"]', 'f哈哈哈', '4383920', 6, 'DEBUG_DING_TALK', '1', '2021-04-10 01:07:21', '1', '2022-12-10 21:26:09', b'0');
INSERT INTO `system_sms_template` VALUES (7, 3, 0, 'test-04', '测试下', '老鸡{name}，牛逼{code}', '[\"name\",\"code\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2021-04-13 00:29:53', '1', '2021-04-14 00:30:38', b'0');
INSERT INTO `system_sms_template` VALUES (8, 1, 0, 'user-sms-login', '前台用户短信登录', '您的验证码是{code}', '[\"code\"]', NULL, '4372216', 6, 'DEBUG_DING_TALK', '1', '2021-10-11 08:10:00', '1', '2022-12-10 21:25:59', b'0');
INSERT INTO `system_sms_template` VALUES (9, 2, 0, 'bpm_task_assigned', '【工作流】任务被分配', '您收到了一条新的待办任务：{processInstanceName}-{taskName}，申请人：{startUserNickname}，处理链接：{detailUrl}', '[\"processInstanceName\",\"taskName\",\"startUserNickname\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-21 22:31:19', '1', '2022-01-22 00:03:36', b'0');
INSERT INTO `system_sms_template` VALUES (10, 2, 0, 'bpm_process_instance_reject', '【工作流】流程被不通过', '您的流程被审批不通过：{processInstanceName}，原因：{reason}，查看链接：{detailUrl}', '[\"processInstanceName\",\"reason\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:03:31', '1', '2022-05-01 12:33:14', b'0');
INSERT INTO `system_sms_template` VALUES (11, 2, 0, 'bpm_process_instance_approve', '【工作流】流程被通过', '您的流程被审批通过：{processInstanceName}，查看链接：{detailUrl}', '[\"processInstanceName\",\"detailUrl\"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:04:31', '1', '2022-03-27 20:32:21', b'0');
INSERT INTO `system_sms_template` VALUES (12, 2, 0, 'demo', '演示模板', '我就是测试一下下', '[]', NULL, 'biubiubiu', 6, 'DEBUG_DING_TALK', '1', '2022-04-10 23:22:49', '1', '2023-03-24 23:45:07', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_social_user
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user`;
CREATE TABLE `system_social_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `type` tinyint NOT NULL COMMENT '社交平台的类型',
  `openid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社交 openid',
  `token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '社交 token',
  `raw_token_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始 Token 数据，一般是 JSON 格式',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户头像',
  `raw_user_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始用户数据，一般是 JSON 格式',
  `code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '最后一次的认证 code',
  `state` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最后一次的认证 state',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社交用户表';

-- ----------------------------
-- Records of system_social_user
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_social_user_bind
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user_bind`;
CREATE TABLE `system_social_user_bind` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键(自增策略)',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `user_type` tinyint NOT NULL COMMENT '用户类型',
  `social_type` tinyint NOT NULL COMMENT '社交平台的类型',
  `social_user_id` bigint NOT NULL COMMENT '社交用户的编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社交绑定表';

-- ----------------------------
-- Records of system_social_user_bind
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for system_tenant
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant`;
CREATE TABLE `system_tenant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户名',
  `contact_user_id` bigint DEFAULT NULL COMMENT '联系人的用户编号',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_mobile` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系手机',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `domain` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '绑定域名',
  `package_id` bigint NOT NULL COMMENT '租户套餐编号',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `account_count` int NOT NULL COMMENT '账号数量',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

-- ----------------------------
-- Records of system_tenant
-- ----------------------------
BEGIN;
INSERT INTO `system_tenant` VALUES (1, '芋道源码', NULL, '芋艿', '17321315478', 0, 'https://www.iocoder.cn', 0, '2099-02-19 17:14:16', 9999, '1', '2021-01-05 17:03:47', '1', '2022-02-23 12:15:11', b'0');
INSERT INTO `system_tenant` VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'http://www.iocoder.cn', 111, '2024-03-11 00:00:00', 20, '1', '2022-02-22 00:56:14', '1', '2022-05-17 10:03:59', b'0');
INSERT INTO `system_tenant` VALUES (122, '测试租户', 113, '芋道', '15601691300', 0, 'https://www.iocoder.cn', 111, '2022-04-30 00:00:00', 50, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant_package`;
CREATE TABLE `system_tenant_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '套餐名',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `menu_ids` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联的菜单编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户套餐表';

-- ----------------------------
-- Records of system_tenant_package
-- ----------------------------
BEGIN;
INSERT INTO `system_tenant_package` VALUES (111, '普通套餐', 0, '小功能', '[1,1036,1037,1038,1039,100,101,1063,103,1064,1001,1065,1002,1003,107,1004,1005,1006,1007,1008,1009,1010,1011,1012,1017,1018,1019,1020]', '1', '2022-02-22 00:54:00', '1', '2022-09-21 22:48:12', b'0');
COMMIT;

-- ----------------------------
-- Table structure for system_user_post
-- ----------------------------
DROP TABLE IF EXISTS `system_user_post`;
CREATE TABLE `system_user_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户ID',
  `post_id` bigint NOT NULL DEFAULT '0' COMMENT '岗位ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户岗位表';

-- ----------------------------
-- Records of system_user_post
-- ----------------------------
BEGIN;
INSERT INTO `system_user_post` VALUES (112, 1, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (113, 100, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (114, 114, 3, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (115, 104, 1, '1', '2022-05-16 19:36:28', '1', '2022-05-16 19:36:28', b'0', 1);
INSERT INTO `system_user_post` VALUES (116, 117, 2, '1', '2022-07-09 17:40:26', '1', '2022-07-09 17:40:26', b'0', 1);
INSERT INTO `system_user_post` VALUES (117, 118, 1, '1', '2022-07-09 17:44:44', '1', '2022-07-09 17:44:44', b'0', 1);
COMMIT;

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS `system_user_role`;
CREATE TABLE `system_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of system_user_role
-- ----------------------------
BEGIN;
INSERT INTO `system_user_role` VALUES (1, 1, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:17', b'0', 1);
INSERT INTO `system_user_role` VALUES (2, 2, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', b'0', 1);
INSERT INTO `system_user_role` VALUES (4, 100, 101, '', '2022-01-11 13:19:45', '', '2023-09-05 14:42:07', b'1', 1);
INSERT INTO `system_user_role` VALUES (5, 100, 1, '', '2022-01-11 13:19:45', '', '2023-09-05 14:42:07', b'1', 1);
INSERT INTO `system_user_role` VALUES (6, 100, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:11', b'0', 1);
INSERT INTO `system_user_role` VALUES (10, 103, 1, '1', '2022-01-11 13:19:45', '1', '2022-01-11 13:19:45', b'0', 1);
INSERT INTO `system_user_role` VALUES (11, 107, 106, '1', '2022-02-20 22:59:33', '1', '2022-02-20 22:59:33', b'0', 118);
INSERT INTO `system_user_role` VALUES (12, 108, 107, '1', '2022-02-20 23:00:50', '1', '2022-02-20 23:00:50', b'0', 119);
INSERT INTO `system_user_role` VALUES (13, 109, 108, '1', '2022-02-20 23:11:50', '1', '2022-02-20 23:11:50', b'0', 120);
INSERT INTO `system_user_role` VALUES (14, 110, 109, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', b'0', 121);
INSERT INTO `system_user_role` VALUES (15, 111, 110, '110', '2022-02-23 13:14:38', '110', '2022-02-23 13:14:38', b'0', 121);
INSERT INTO `system_user_role` VALUES (16, 113, 111, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', b'0', 122);
INSERT INTO `system_user_role` VALUES (17, 114, 101, '1', '2022-03-19 21:51:13', '1', '2022-03-19 21:51:13', b'0', 1);
INSERT INTO `system_user_role` VALUES (18, 1, 2, '1', '2022-05-12 20:39:29', '1', '2023-05-17 15:32:04', b'1', 1);
INSERT INTO `system_user_role` VALUES (19, 116, 113, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', b'0', 124);
INSERT INTO `system_user_role` VALUES (20, 104, 101, '1', '2022-05-28 15:43:57', '1', '2022-05-28 15:43:57', b'0', 1);
INSERT INTO `system_user_role` VALUES (22, 115, 2, '1', '2022-07-21 22:08:30', '1', '2022-07-21 22:08:30', b'0', 1);
INSERT INTO `system_user_role` VALUES (23, 119, 114, '1', '2022-12-30 11:32:04', '1', '2022-12-30 11:32:04', b'0', 125);
INSERT INTO `system_user_role` VALUES (24, 120, 115, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', b'0', 126);
INSERT INTO `system_user_role` VALUES (25, 121, 116, '1', '2022-12-30 11:33:49', '1', '2022-12-30 11:33:49', b'0', 127);
INSERT INTO `system_user_role` VALUES (26, 122, 118, '1', '2022-12-30 11:47:53', '1', '2022-12-30 11:47:53', b'0', 129);
INSERT INTO `system_user_role` VALUES (27, 112, 101, '1', '2023-02-09 23:18:51', '1', '2023-02-09 23:18:51', b'0', 1);
INSERT INTO `system_user_role` VALUES (28, 123, 136, '1', '2023-03-05 21:23:35', '1', '2023-03-05 21:23:35', b'0', 147);
INSERT INTO `system_user_role` VALUES (29, 124, 137, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', b'0', 148);
INSERT INTO `system_user_role` VALUES (30, 125, 138, '1', '2023-03-05 21:59:03', '1', '2023-03-05 21:59:03', b'0', 149);
INSERT INTO `system_user_role` VALUES (31, 126, 2, '1', '2023-09-05 14:42:51', '1', '2023-09-05 14:42:51', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `post_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '岗位编号数组',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号码',
  `sex` tinyint DEFAULT '0' COMMENT '用户性别',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像地址',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_username` (`username`,`update_time`,`tenant_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ----------------------------
-- Records of system_users
-- ----------------------------
BEGIN;
INSERT INTO `system_users` VALUES (1, 'admin', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', 'yshop', '管理员', 103, '[1]', 'yshop@yixaing.co', '18000000000', 1, 'https://app2.yixiang.co/avatar/20200705181403641316.png', 0, '0:0:0:0:0:0:0:1', '2024-06-14 13:58:03', 'admin', '2021-01-05 17:03:47', NULL, '2024-06-14 13:58:03', b'0', 1);
INSERT INTO `system_users` VALUES (100, 'yshop', '$2a$10$11U48RhyJ5pSBYWSn12AD./ld671.ycSzJHbyrtpeoMeYiw31eo8a', 'yixiang', '不要吓我', 104, '[1]', 'yshop@iocoder.cn', '15601691300', 1, '', 0, '127.0.0.1', '2022-07-09 23:03:33', '', '2021-01-07 09:07:17', '1', '2023-08-06 10:11:13', b'0', 1);
INSERT INTO `system_users` VALUES (126, 'yixiang001', '$2a$04$JTIqo.OqDIy/QnGD8DyalOuD2S10Rdz20abG1Vw7uaU5xDjBqEWky', '意向餐饮管理员', '', 110, '[]', '', '18888888888', 0, '', 0, '0:0:0:0:0:0:0:1', '2023-10-07 11:05:53', '1', '2023-09-05 10:23:17', NULL, '2023-10-07 11:05:53', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `yshop_coupon`;
CREATE TABLE `yshop_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `shop_id` varchar(500) NOT NULL DEFAULT '0' COMMENT '店铺id,0表示通用',
  `shop_name` varchar(1000) DEFAULT NULL COMMENT '店铺名称逗号隔开',
  `title` varchar(50) NOT NULL COMMENT '优惠券名称',
  `is_switch` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否上架',
  `least` decimal(10,2) NOT NULL COMMENT '消费多少可用',
  `value` decimal(10,2) NOT NULL COMMENT '优惠券金额',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `weigh` int NOT NULL DEFAULT '0' COMMENT '权重',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '可用类型:0=通用,1=自取,2=外卖',
  `exchange_code` varchar(32) DEFAULT NULL COMMENT '兑换码',
  `receive` int NOT NULL DEFAULT '0' COMMENT '已领取',
  `distribute` int NOT NULL DEFAULT '0' COMMENT '发行数量',
  `score` int NOT NULL DEFAULT '0' COMMENT '所需积分',
  `instructions` text NOT NULL COMMENT '使用说明',
  `image` varchar(150) NOT NULL DEFAULT '' COMMENT '图片',
  `limit` int DEFAULT '1' COMMENT '限领数量',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='优惠券表';

-- ----------------------------
-- Records of yshop_coupon
-- ----------------------------
BEGIN;
INSERT INTO `yshop_coupon` VALUES (2, '2', '意向餐饮店', '意向店铺优惠券', 1, 0.10, 0.02, '2023-08-09 00:00:00', '2024-08-31 00:00:00', '2023-08-09 11:17:09', '2023-09-14 17:46:19', b'0', 0, 0, '666', 6, 100, 0, '111', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/f40cd0308c855bb145fc17c64b7a706562602081d87869a5e082ae2225d599a7.jpg', 1, '1', '1');
INSERT INTO `yshop_coupon` VALUES (3, '2', '意向餐饮店', '1', 1, 1.00, 1.00, '2024-02-06 00:00:00', '2024-02-26 00:00:00', '2024-02-24 10:25:41', '2024-02-24 10:25:41', b'0', 0, 0, '1', 0, 1, 0, '1', ' http://localhost:48081/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', 1, '1', '1');
COMMIT;

-- ----------------------------
-- Table structure for yshop_coupon_user
-- ----------------------------
DROP TABLE IF EXISTS `yshop_coupon_user`;
CREATE TABLE `yshop_coupon_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `shop_id` varchar(500) NOT NULL DEFAULT '0' COMMENT '店铺id,0表示通用',
  `shop_name` varchar(1000) DEFAULT NULL COMMENT '店铺名称逗号隔开',
  `title` varchar(50) NOT NULL COMMENT '优惠券名称',
  `least` decimal(10,2) NOT NULL COMMENT '消费多少可用',
  `value` decimal(10,2) NOT NULL COMMENT '优惠券金额',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '可用类型:0=通用,1=自取,2=外卖',
  `score` int NOT NULL DEFAULT '0' COMMENT '消耗积分',
  `instructions` varchar(1000) NOT NULL DEFAULT '' COMMENT '使用说明',
  `image` varchar(150) NOT NULL DEFAULT '' COMMENT '图片',
  `user_id` int NOT NULL COMMENT '用户id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '已使用:0=否,1=是',
  `coupon_id` int NOT NULL COMMENT '优惠券id',
  `exchange_code` varchar(32) DEFAULT NULL COMMENT '兑换码',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`),
  KEY `coupon_iid` (`coupon_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COMMENT='用户领的优惠券';

-- ----------------------------
-- Records of yshop_coupon_user
-- ----------------------------
BEGIN;
INSERT INTO `yshop_coupon_user` VALUES (5, '2', '意向餐饮店', '意向店铺优惠券', 0.10, 0.02, '2023-08-09 00:00:00', '2024-08-31 00:00:00', 0, 0, '111', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/f40cd0308c855bb145fc17c64b7a706562602081d87869a5e082ae2225d599a7.jpg', 2, 0, 2, NULL, '2023-08-09 11:17:09', '2023-09-14 17:46:19', '1', '1', b'0');
INSERT INTO `yshop_coupon_user` VALUES (6, '2', '意向餐饮店', '意向店铺优惠券', 0.10, 0.02, '2023-08-09 00:00:00', '2024-08-31 00:00:00', 0, 0, '111', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/f40cd0308c855bb145fc17c64b7a706562602081d87869a5e082ae2225d599a7.jpg', 9, 1, 2, NULL, '2023-08-09 11:17:09', '2023-09-14 17:46:19', '1', '1', b'0');
COMMIT;

-- ----------------------------
-- Table structure for yshop_express
-- ----------------------------
DROP TABLE IF EXISTS `yshop_express`;
CREATE TABLE `yshop_express` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT COMMENT '快递公司id',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '快递公司简称',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '快递公司全称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=439 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='快递公司表';

-- ----------------------------
-- Records of yshop_express
-- ----------------------------
BEGIN;
INSERT INTO `yshop_express` VALUES (433, 'ZTO', '中通快递', 1, '2023-07-02 10:40:03', '2023-07-02 10:41:08', '1', '1', b'0');
INSERT INTO `yshop_express` VALUES (434, 'STO', '申通快递', 2, '2023-07-02 10:40:28', '2023-07-02 10:40:28', '1', '1', b'0');
INSERT INTO `yshop_express` VALUES (435, 'HTKY', '百世快递', 3, '2023-07-02 10:40:50', '2023-07-02 10:40:50', '1', '1', b'0');
INSERT INTO `yshop_express` VALUES (436, 'YTO', '圆通速递', 4, '2023-07-02 10:41:35', '2023-07-02 10:41:35', '1', '1', b'0');
INSERT INTO `yshop_express` VALUES (437, 'EMS', 'EMS', 5, '2023-07-02 10:41:51', '2023-07-02 10:41:51', '1', '1', b'0');
INSERT INTO `yshop_express` VALUES (438, 'SF', '顺丰速运', 6, '2023-07-02 10:42:16', '2023-07-02 10:42:16', '1', '1', b'0');
COMMIT;

-- ----------------------------
-- Table structure for yshop_material
-- ----------------------------
DROP TABLE IF EXISTS `yshop_material`;
CREATE TABLE `yshop_material` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '类型1、图片；2、视频',
  `group_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '分组ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '素材名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '素材链接',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='素材库';

-- ----------------------------
-- Records of yshop_material
-- ----------------------------
BEGIN;
INSERT INTO `yshop_material` VALUES (38, '2023-09-14 10:21:54', '1', '1', NULL, '帮助.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/77286cb7280b0629172f239bb1c4ea1f9712afd24d1f4506a836a2149d40bcae.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (39, '2023-09-14 10:21:54', '1', '1', NULL, '客服.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/dcc749871b119ca807154adccd7cb5923d5f182ccfa85c36b269e0cd6a278e54.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (40, '2023-09-14 10:21:54', '1', '1', NULL, '退出登录.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/3b31de59fe0a24a3d772b49a4c1dd184d215d1c6390a89cfd8e9925ea678b0ae.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (41, '2023-09-14 10:21:54', '1', '1', NULL, '账户.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/2e4eb6d5def1f8c4d6d10a718b6a0f86176c79853242672846a493a8a669a9fb.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (42, '2023-09-14 10:21:54', '1', '1', NULL, '积分商城.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/9ba24bc27c61dbdca2dc4c089a747a62f374608a8ad290ed5cdd01f498e91540.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (43, '2023-09-14 10:21:54', '1', '1', NULL, '关于我们.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/e6164af29d51adfe27616116251bf64c63bf6adebeaa4625abbe133d15ca348b.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (44, '2023-09-14 10:21:54', '1', '1', NULL, '签到.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/3679a4a66fd8b7e2141442535b9920f3281e2e4d6cb0b239d281ba0799564ab1.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (45, '2023-09-14 10:21:54', '1', '1', NULL, '货币兑换.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/60d7b27d8c7e36030b0b8eaa9d23fa05b356ba7c3e426ba79fcae174b0608edb.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (46, '2023-09-14 10:21:54', '1', '1', NULL, '导航地址.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/5942d0091c32ecab3e1dc3f8abbfc15efa79cfaa39986e7955af4c1a6aecb834.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (47, '2023-09-14 10:21:54', '1', '1', NULL, '我的订单 (1).png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/e4c72c45a6fa12b178b9d178677093ce7e10d55c71681def9666c8b322bd72d0.png', '1', '2023-09-14 10:21:54', b'0', 0);
INSERT INTO `yshop_material` VALUES (48, '2023-09-14 10:25:14', '1', '1', NULL, 'u=1824446573,3306830779&fm=193&f=GIF.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/29670e82a9459534f3fb401dca9f88d70ede94eb179ead81bfd8fd3a8585b2f6.jpg', '1', '2023-09-14 10:25:14', b'1', 0);
INSERT INTO `yshop_material` VALUES (49, '2023-09-14 10:27:38', '1', '1', NULL, 'u=1824446573,3306830779&fm=193&f=GIF.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', '1', '2023-09-14 10:27:38', b'0', 0);
INSERT INTO `yshop_material` VALUES (50, '2023-09-14 16:35:59', '1', '1', NULL, '帮助.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/77286cb7280b0629172f239bb1c4ea1f9712afd24d1f4506a836a2149d40bcae.png', '1', '2023-09-14 16:35:59', b'0', 0);
INSERT INTO `yshop_material` VALUES (51, '2023-09-14 16:37:14', '1', '1', NULL, '客服.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/dcc749871b119ca807154adccd7cb5923d5f182ccfa85c36b269e0cd6a278e54.png', '1', '2023-09-14 16:37:14', b'0', 0);
INSERT INTO `yshop_material` VALUES (52, '2023-09-14 17:21:33', '1', '1', NULL, '1.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', '1', '2023-09-14 17:21:33', b'0', 0);
INSERT INTO `yshop_material` VALUES (53, '2023-09-14 17:22:44', '1', '1', NULL, '2.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/f40cd0308c855bb145fc17c64b7a706562602081d87869a5e082ae2225d599a7.jpg', '1', '2023-09-14 17:22:44', b'0', 0);
INSERT INTO `yshop_material` VALUES (54, '2023-09-14 17:22:44', '1', '1', NULL, '3.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '1', '2023-09-14 17:22:44', b'0', 0);
INSERT INTO `yshop_material` VALUES (55, '2023-09-14 17:22:44', '1', '1', NULL, '4.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '1', '2023-09-14 17:22:44', b'0', 0);
INSERT INTO `yshop_material` VALUES (56, '2023-11-30 15:55:43', '1', '1', NULL, '积分订单.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', '1', '2023-11-30 15:55:43', b'0', 0);
INSERT INTO `yshop_material` VALUES (57, '2023-11-30 15:56:28', '1', '1', NULL, '积分订单.png', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', '1', '2023-11-30 15:56:28', b'0', 0);
INSERT INTO `yshop_material` VALUES (58, '2023-11-30 15:57:41', '1', '1', NULL, '积分订单.png', ' http://localhost:48081/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', '1', '2023-11-30 15:57:41', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_material_group
-- ----------------------------
DROP TABLE IF EXISTS `yshop_material_group`;
CREATE TABLE `yshop_material_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分组名',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='素材分组';

-- ----------------------------
-- Records of yshop_material_group
-- ----------------------------
BEGIN;
INSERT INTO `yshop_material_group` VALUES (1, '2023-05-16 12:02:13', '1', '商品', '1', '2023-05-24 14:42:23', b'0');
INSERT INTO `yshop_material_group` VALUES (2, '2023-05-22 23:38:11', '1', '21212', '1', '2023-05-22 23:38:11', b'1');
INSERT INTO `yshop_material_group` VALUES (3, '2023-05-22 23:39:44', '1', '1', '1', '2023-05-22 23:46:22', b'1');
INSERT INTO `yshop_material_group` VALUES (4, '2023-05-22 23:52:10', '1', '1', '1', '2023-05-22 23:52:10', b'1');
INSERT INTO `yshop_material_group` VALUES (5, '2023-05-22 23:52:12', '1', '2', '1', '2023-05-22 23:52:12', b'1');
INSERT INTO `yshop_material_group` VALUES (6, '2023-05-22 23:52:14', '1', '3', '1', '2023-05-22 23:52:14', b'1');
INSERT INTO `yshop_material_group` VALUES (7, '2023-05-22 23:55:30', '1', '1', '1', '2023-05-22 23:55:30', b'1');
INSERT INTO `yshop_material_group` VALUES (8, '2023-05-22 23:55:32', '1', '2', '1', '2023-05-22 23:55:32', b'1');
INSERT INTO `yshop_material_group` VALUES (9, '2023-05-22 23:55:33', '1', '4', '1', '2023-05-22 23:55:33', b'1');
INSERT INTO `yshop_material_group` VALUES (10, '2023-05-22 23:55:33', '1', '3333', '1', '2023-05-22 23:56:04', b'1');
COMMIT;

-- ----------------------------
-- Table structure for yshop_order_number
-- ----------------------------
DROP TABLE IF EXISTS `yshop_order_number`;
CREATE TABLE `yshop_order_number` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '取餐号',
  `order_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1054 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单取餐号表';

-- ----------------------------
-- Records of yshop_order_number
-- ----------------------------
BEGIN;
INSERT INTO `yshop_order_number` VALUES (1000, '1703615452900491264');
INSERT INTO `yshop_order_number` VALUES (1001, '1703675877960712192');
INSERT INTO `yshop_order_number` VALUES (1002, '1703675968628981760');
INSERT INTO `yshop_order_number` VALUES (1003, '1703677507523313664');
INSERT INTO `yshop_order_number` VALUES (1004, '1703695133590945792');
INSERT INTO `yshop_order_number` VALUES (1005, '1703696098238922752');
INSERT INTO `yshop_order_number` VALUES (1006, '1703697465292619776');
INSERT INTO `yshop_order_number` VALUES (1007, '1703711231535218688');
INSERT INTO `yshop_order_number` VALUES (1008, '1703714583388094464');
INSERT INTO `yshop_order_number` VALUES (1009, '1703715497381462016');
INSERT INTO `yshop_order_number` VALUES (1010, '1703718316423512064');
INSERT INTO `yshop_order_number` VALUES (1011, '1704879606328197120');
INSERT INTO `yshop_order_number` VALUES (1012, '1704880263286226944');
INSERT INTO `yshop_order_number` VALUES (1013, '1704880316985901056');
INSERT INTO `yshop_order_number` VALUES (1014, '1704880485911494656');
INSERT INTO `yshop_order_number` VALUES (1015, '1710504621161578496');
INSERT INTO `yshop_order_number` VALUES (1016, '1714842349156171776');
INSERT INTO `yshop_order_number` VALUES (1017, '1715549852135325696');
INSERT INTO `yshop_order_number` VALUES (1018, '1716272228393287680');
INSERT INTO `yshop_order_number` VALUES (1019, '1716277998795096064');
INSERT INTO `yshop_order_number` VALUES (1020, '1716278197982593024');
INSERT INTO `yshop_order_number` VALUES (1021, '1716278745859358720');
INSERT INTO `yshop_order_number` VALUES (1022, '1716279604374667264');
INSERT INTO `yshop_order_number` VALUES (1023, '1716282100870545408');
INSERT INTO `yshop_order_number` VALUES (1024, '1716282959058698240');
INSERT INTO `yshop_order_number` VALUES (1025, '1716285974796828672');
INSERT INTO `yshop_order_number` VALUES (1026, '1716288494575288320');
INSERT INTO `yshop_order_number` VALUES (1027, '1716290062221574144');
INSERT INTO `yshop_order_number` VALUES (1028, '1716291271800127488');
INSERT INTO `yshop_order_number` VALUES (1029, '1716291285691662336');
INSERT INTO `yshop_order_number` VALUES (1030, '1721369605764546560');
INSERT INTO `yshop_order_number` VALUES (1031, '1721371148484083712');
INSERT INTO `yshop_order_number` VALUES (1032, '1725000691803488256');
INSERT INTO `yshop_order_number` VALUES (1033, '1725047622177128448');
INSERT INTO `yshop_order_number` VALUES (1034, '1725060861086662656');
INSERT INTO `yshop_order_number` VALUES (1035, '1725061023016157184');
INSERT INTO `yshop_order_number` VALUES (1036, '1726884445237018624');
INSERT INTO `yshop_order_number` VALUES (1037, '1727142223536979968');
INSERT INTO `yshop_order_number` VALUES (1038, '1731503113317122048');
INSERT INTO `yshop_order_number` VALUES (1039, '1731506721286782976');
INSERT INTO `yshop_order_number` VALUES (1040, '1731517938814418944');
INSERT INTO `yshop_order_number` VALUES (1041, '1732962343437991936');
INSERT INTO `yshop_order_number` VALUES (1042, '1732962574971961344');
INSERT INTO `yshop_order_number` VALUES (1043, '1796798236367781888');
INSERT INTO `yshop_order_number` VALUES (1044, '1796801853577494528');
INSERT INTO `yshop_order_number` VALUES (1045, '1796808148250525696');
INSERT INTO `yshop_order_number` VALUES (1046, '1796810678279864320');
INSERT INTO `yshop_order_number` VALUES (1047, '1796811230879416320');
INSERT INTO `yshop_order_number` VALUES (1048, '1796811866152894464');
INSERT INTO `yshop_order_number` VALUES (1049, '1796812463023325184');
INSERT INTO `yshop_order_number` VALUES (1050, '1796813371828338688');
INSERT INTO `yshop_order_number` VALUES (1051, '1796816765703946240');
INSERT INTO `yshop_order_number` VALUES (1052, '1796817117392142336');
INSERT INTO `yshop_order_number` VALUES (1053, '1796818221630750720');
COMMIT;

-- ----------------------------
-- Table structure for yshop_service
-- ----------------------------
DROP TABLE IF EXISTS `yshop_service`;
CREATE TABLE `yshop_service` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图标',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型:pages=页面,miniprogram=跳转小程序,menu=菜单,content=内容,call=电话',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '详情',
  `pid` int DEFAULT '0' COMMENT '父级id',
  `app_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '小程序app_id',
  `pages` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '页面路径',
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '电话',
  `weigh` int NOT NULL DEFAULT '0' COMMENT '权重',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态:0=下架,1=上架',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `weigh` (`weigh`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='我的服务';

-- ----------------------------
-- Records of yshop_service
-- ----------------------------
BEGIN;
INSERT INTO `yshop_service` VALUES (20, '积分签到', 'http://127.0.0.1:48081/admin-api/infra/file/4/get/3679a4a66fd8b7e2141442535b9920f3281e2e4d6cb0b239d281ba0799564ab1.png', 'pages', '<p>trte</p>', 0, '', '/pages/components/pages/integrals/integrals', '', 1, 0, '2023-08-08 11:09:56', '2023-09-04 14:09:58', '1', '1', b'1');
INSERT INTO `yshop_service` VALUES (21, '我的订单', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/e4c72c45a6fa12b178b9d178677093ce7e10d55c71681def9666c8b322bd72d0.png', 'pages', '<p>tetewt</p>', 0, '', '/pages/components/pages/orders/orders', '', 0, 1, '2023-08-11 13:52:39', '2023-09-14 16:38:29', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (22, '积分商城', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/9ba24bc27c61dbdca2dc4c089a747a62f374608a8ad290ed5cdd01f498e91540.png', 'pages', '<p>rtete</p>', 0, '', '/pages/components/pages/scoreproduct/list', '', 0, 0, '2023-08-11 13:57:58', '2023-09-14 16:38:14', '1', '1', b'1');
INSERT INTO `yshop_service` VALUES (23, '兑换订单', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/60d7b27d8c7e36030b0b8eaa9d23fa05b356ba7c3e426ba79fcae174b0608edb.png', 'pages', '', 0, '', '/pages/components/pages/scoreproduct/order', '', 0, 0, '2023-09-03 16:00:34', '2023-09-14 16:38:02', '1', '1', b'1');
INSERT INTO `yshop_service` VALUES (24, '联系客服', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/dcc749871b119ca807154adccd7cb5923d5f182ccfa85c36b269e0cd6a278e54.png', 'call', '', 0, '', '', '18888888888', 0, 1, '2023-09-03 16:01:40', '2023-09-14 16:37:33', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (25, '我的地址', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/5942d0091c32ecab3e1dc3f8abbfc15efa79cfaa39986e7955af4c1a6aecb834.png', 'pages', '', 0, '', '/pages/components/pages/address/address', '', 0, 1, '2023-09-03 16:02:29', '2023-09-14 16:36:37', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (26, '帮助中心', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/77286cb7280b0629172f239bb1c4ea1f9712afd24d1f4506a836a2149d40bcae.png', 'content', '<p>66666</p>', 0, '', '', '', 0, 1, '2023-09-03 16:03:45', '2023-09-14 16:36:24', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (27, '关于我们', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/e6164af29d51adfe27616116251bf64c63bf6adebeaa4625abbe133d15ca348b.png', 'content', '<p>88888</p>', 0, '', '', '', 0, 1, '2023-09-03 16:04:53', '2023-09-14 16:32:09', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (28, '退出登录', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/3b31de59fe0a24a3d772b49a4c1dd184d215d1c6390a89cfd8e9925ea678b0ae.png', 'pages', '', 0, '', '/pages/components/pages/login/logout', '', 0, 1, '2023-09-12 18:10:11', '2023-09-14 16:31:52', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (29, '用户协议', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 'content', '<p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">本软件许可及服务协议（以下称\"本协议\"）由您与漯河市大有前途网络科技有限公司（以下称“我们”）共同签署。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">在使用yshop-drink点餐系统软件（以下称许可软件）之前，请您仔细阅读本协议，特别是免除或者限制责任的条款、法律适用和争议解决条款。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">免除或者限制责任的条款将以粗体标识，您需要重点阅读。如您对协议有任何疑问，可向客服咨询。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">如果您同意接受本协议条款和条件的约束，您可下载安装使用许可软件。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">我们如修改本协议或其补充协议，协议条款修改后，请您仔细阅读并接受修改后的协议后再继续使用许可软件。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">一、 定义</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 本协议是您与我们之间关于您下载、安装、使用、登录本软件，以及使用本软件服务所订立的协议。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">二、授权范围</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 由于软件适配平台及终端限制，您理解您仅可在获授权的系统平台及终端使用许可软件，如您将许可软件安装在其他终端设备上（包括台式电脑、手提电脑、或授权终端外的其他手持移动终端、电视机及机顶盒等），可能会对您硬件或软件功能造成损害。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 您应该理解许可软件仅可用于非商业目的，您不可为商业运营目的安装、使用、运行许可软件。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 我们会对许可软件及其相关功能不时进行变更、升级、修改或转移，并会在许可软件系统中开发新的功能或其它服务。上述新的功能、软件服务如无独立协议的，您仍可取得相应功能或服务的授权，并可适用本协议。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">三、使用规范</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 您应该规范使用许可软件，以下方式是违反使用规范的：</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（1）从事违反法律法规政策、破坏公序良俗、损害公共利益的行为。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（2）对许可软件及其中的相关信息擅自出租、出借、复制、修改、链接、转载、汇编、发表、出版、建立镜像站点，借助许可软件发展与之有关的衍生产品、作品、服务、插件、外挂、兼容、互联等。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（3）通过非由我们及其关联公司开发、授权或认可的第三方兼容软件、系统登录或使用许可软件，或针对许可软件使用非我们及其关联公司开发、授权或认证的插件和外挂。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（4）删除许可软件及其他副本上关于版权的信息、内容。修改、删除或避开应用产品中我们为保护知识产权而设置的任何技术措施。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（5）未经我们的书面同意，擅自将许可软件出租、出借或再许可给第三方使用，或在获得许可软件的升级版本的许可使用后，同时使用多个版本的许可使用版本，或分开转让。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（6）复制、反汇编、修改许可软件或其任何部分或制造其衍生作品；对许可软件或者许可软件运行过程中释放在终端中的任何数据及许可软件运行过程中终端与服务器端的交互数据进行复制、修改、挂接运行或创作任何衍生作品，包括使用插件、外挂或非经授权的第三方工具/服务接入许可软件和相关系统等形式。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（7） 进行任何危害信息网络安全的行为，包括使用许可软件时以任何方式损坏或破坏许可软件或使其不能运行或超负荷或干扰第三方对许可软件的使用；未经允许进入他人计算机系统并删除、修改、增加存储信息；故意传播恶意程序或病毒以及其他破坏、干扰正常网络信息服务的行为。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（8）利用许可软件发表、传送、传播、储存侵害他人知识产权、商业秘密权等合法权利的内容，或从事欺诈、盗用他人账户、资金等违法犯罪活动。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（9）通过修改或伪造许可软件运行中的指令、数据、数据包，增加、删减、变动许可软件的功能或运行效果，及/或将具有上述用途的软件通过信息网络向公众传播或者运营。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（10）其他以任何不合法的方式、为任何不合法的目的、或以任何与本协议不一致的方式使用许可软件。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 您理解并同意</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（1）我们会对您是否涉嫌违反上述使用规范做出认定，并根据认定结果中止、终止对您的使用许可或采取其他依约可采取的限制措施。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（2）对于您使用许可软件时发布的涉嫌违法或涉嫌侵犯他人合法权利或违反本协议的信息，我们会直接予以删除。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（3）对于您违反上述使用规范的行为对任意第三方造成损害的，您需要以自己的名义独立承担法律责任，并应确保我们免于因此产生损失或增加费用。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（4）如您违反有关法律或者本协议之规定，使我们遭受任何损失，或受到任何第三方的索赔，或受到任何行政管理部门的处罚，您应当赔偿我们因此造成的损失及（或）发生的费用，包括合理的律师费用、调查取证费用。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">四、第三方软件或服务</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 许可软件可能使用或包含了由第三方提供的软件或服务（以下称该等服务），该等服务是为了向您提供便利而设置，是取得该第三方的合法授权的。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 由于第三方为其软件或服务的提供者，您使用该等服务时，应另行与该第三方达成服务协议，支付相应费用并承担可能的风险。您应理解我们并无权在本协议中授予您使用该等服务的任何权利，也无权对该等服务提供任何形式的保证。我们无法对该等服务提供客户支持，如果您需要获取支持，您可直接与该第三方联系。因您使用该等服务引发的任何纠纷，您可直接与该第三方协商解决。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 您理解许可软件仅在当前使用或包含该等服务，我们无法保证许可软件将会永久地使用或包含该等服务，也无法保证将来不会使用或包含该第三方的同类型或不同类型的软件或服务或其他第三方的软件或服务，一旦我们在许可软件中使用或包含前述软件或服务，相应的软件或服务同样适用本条约定。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">4. 您理解第三方需要与我们进行您的信息交互以便更好地为您提供服务，您同意在使用许可软件时如使用该等服务的，您授权我们依据《隐私协议》您使用许可软件的信息传递给该第三方，或从该第三方获取您注册或使用该等服务时提供或产生的信息。如果您不希望第三方获取您的信息的，您可停止使用该等服务，我们将停止向第三方传递您的信息。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">5. 您同意，如果该第三方确认您违反了您与其之间关于使用该等服务的协议约定停止对您提供该等服务并要求我们处理的，由于停止该等服务可能会影响您继续使用许可软件，我们可能会中止、终止对你的使用许可或采取其他我们可对您采取的限制措施。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">五、隐私政策与数据</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">保护您的个人信息对我们很重要。我们制定了《隐私协议》，您的信息收集、使用、共享、存储、保护等方面关系您切身利益的内容进行了重要披露。我们建议您完整地阅读《隐私协议》，以帮助您更好的保护您的个人信息。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">六、特别授权</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">您对您的个人信息依法拥有权利，并且可以通过查阅《隐私协议》了解我们对您的个人信息的保护及处理方式。对您提供的除个人信息外的信息，为了向您提供您使用的各项服务，并维护、改进这些服务，及优化我们的服务质量等用途，对于您提交的文字、图片和视频等受知识产权保护的内容，您同意授予我们排他的、可转让、可分发次级许可、无使用费的全球性许可，用于我们及我们关联公司使用、复制、修订、改写、发布、翻译、分发、执行和展示您提交的资料数据或制作派生作品。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">七、 无担保和责任限制</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 除法律法规有明确规定外，我们将尽最大努力确保许可软件及其所涉及的技术及信息安全、有效、准确、可靠，但受限于现有技术，您理解我们不能对此进行担保。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 您理解，对于不可抗力及第三方原因导致的您的直接或间接损失，我们无法承担责任。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 由于您因下述任一情况所引起或与此有关的人身伤害或附带的、间接的损害赔偿，包括但不限于利润损失、资料损失、业务中断的损害赔偿或其它商业损害赔偿或损失，需由您自行承担：</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（1）使用或未能使用许可软件；</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（2）第三方未经批准的使用许可软件或更改您的数据；</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（3）使用许可软件进行的行为产生的费用及损失；</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（4）您对许可软件的误解；</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">（5）非因我们的原因而引起的与许可软件有关的其它损失。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">4. 非经我们或我们授权开发并正式发布的其它任何由许可软件衍生的软件均属非法，下载、安装、使用此类软件，可能导致不可预知的风险，由此产生的法律责任与纠纷与我们无关，我们有权中止、终止使用许可和/或其他一切服务。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">5. 您与其他使用许可软件的用户之间通过许可软件进行时，因您受误导或欺骗而导致或可能导致的任何心理、生理上的伤害以及经济上的损失，均应由过错方依法承担所有责任。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">八、知识产权</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 我们拥有许可软件的著作权、商业秘密以及其他相关的知识产权，包括与许可软件有关的各种文档资料。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 许可软件的相关标识属于我们及我们的关联公司的知识产权，并受到相关法律法规的保护。未经我们明确授权，您不得复制、模仿、使用或发布上述标识，也不得修改或删除应用产品中体现我们及其关联公司的任何标识或身份信息。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 未经我们及我们的关联公司事先书面同意，您不得为任何营利性或非营利性的目的自行实施、利用、转让或许可任何第三方实施、利用、转让上述知识产权。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">九、协议终止和违约责任</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 您应理解按授权范围使用许可软件、尊重软件及软件包含内容的知识产权、按规范使用软件、按本协议约定履行义务是您获取我们授权使用软件的前提，如您严重违反本协议，我们将终止使用许可。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 您对软件的使用有赖于我们关联公司为您提供的配套服务，您违反与我们或我们关联公司的条款、协议、规则、通告等相关规定，而被上述任一网站终止提供服务的，可能导致您无法正常使用许可软件，我们有权终止使用许可。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 您理解出于维护平台秩序及保护消费者权益的目的，如果您向我们及（或）我们的关联公司作出任何形式的承诺，且相关公司已确认您违反了该承诺并通知我们依据您与其相关约定进行处理的，则我们可按您的承诺或协议约定的方式对您的使用许可及其他我们可控制的权益采取限制措施，包括中止或终止对您的使用许可。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">4. 一旦您违反本协议或与我们签订的其他协议的约定，我们可通知我们关联公司，要求其对您的权益采取限制措施，包括要求关联公司中止、终止对您提供部分或全部服务，且在其经营或实际控制的网站依法公示您的违约情况。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">5. 许可软件由您自下载平台下载取得，您需要遵守下载平台、系统平台、终端厂商对您使用许可软件方式与限制的约定，如果上述第三方确认您违反该约定需要我们处理的，我们可能会因第三方要求终止对您的使用许可。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">6. 在本使用许可终止时，您应停止对许可软件的使用行为，并销毁许可软件的全部副本。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">7. 如您违反本协议规定的条款，给我们或其他用户造成损失，您必须承担全部的赔偿责任。如我们承担了上述责任，则您同意赔偿我们的相关支出和损失，包括合理的律师费用。</span></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">十、管辖法律和可分割性</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 本协议之效力、解释、变更、执行与争议解决均适用中华人民共和国法律，如无相关法律规定的，则应参照通用国际商业惯例和（或）行业惯例。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 本协议由您与我们在郑州市金水区签署。因本协议产生或与本协议有关的争议，您可与我们以友好协商的方式予以解决或提交有管辖权的人民法院予以裁决。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">3. 本协议任何条款被有管辖权的人民法院裁定为无效，不应影响其他条款或其任何部分的效力，您与我们仍应善意履行。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">十一、其他</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">1. 我们可能根据业务调整而变更向您提供软件服务的主体，变更后的主体与您共同履行本协议并向您提供服务，以上变更不会影响您本协议项下的权益。发生争议时，您可根据您具体使用的服务及对您权益产生影响的具体行为对象确定与您履约的主体及争议相对方。</span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; </span></p><p style=\"text-align: start;\"><span style=\"font-family: 微软雅黑;\">2. 本协议的所有标题仅仅是为了醒目及阅读方便，本身并没有实际涵义，不能作为解释本协议涵义的依据。</span></p>', 0, '', '', '', 0, 0, '2023-09-15 11:16:05', '2023-09-15 16:43:29', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (30, '隐私政策', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 'content', '<p><span style=\"font-family: 微软雅黑;\">漯河市大有前途网络科技有限公司（以下简称“我们”）深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。</span></p><p><span style=\"font-family: 微软雅黑;\">我们致力于维持您对我们的信任，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。</span></p><p><span style=\"font-family: 微软雅黑;\">同时，我们承诺，我们将按业界成熟的安全标准，采取相应的安全保护措施来保护您的个人信息。</span></p><p><span style=\"font-family: 微软雅黑;\">请在使用我们的yshop-drink点餐系统前，仔细阅读并了解本《隐私协议》。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">一、我们如何收集和使用您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">个人信息是指以电子或者其他方式记录的能够单独或者与其他信息结合识别特定自然人身份或者反映特定自然人活动情况的各种信息。</span></p><p><span style=\"font-family: 微软雅黑;\">我们仅会出于本政策所述的以下目的，收集和使用您的个人信息：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（一）为您提供网上购物服务 &nbsp;</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">1、业务功能一：注册成为用户为完成创建账号，您需提供以下信息：您的姓名、手机号、创建的密码。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">在注册过程中，如果您提供以下额外信息，将有助于我们给您提供更好的服务和体验：邮箱号、昵称、头像、银行卡、身份证。但如果您不提供这些信息，将不会影响使用本服务的基本功能。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">您提供的上述信息，将在您使用本服务期间持续授权我们使用。在您注销账号时，我们将停止使用并删除上述信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">上述信息将存储于中华人民共和国境内。如需跨境传输，我们将会单独征得您的授权同意。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">2、业务功能二：商品展示、个性化推荐、发送促销营销信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（二）开展内部数据分析和研究，第三方SDK统计服务，改善我们的产品或服务</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们收集数据是根据您与我们的互动和您所做出的选择，包括您的隐私设置以及您使用的产品和功能。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们收集的数据可能包括SDK/API/JS代码版本、浏览器、互联网服务提供商、IP地址、平台、时间戳、应用标识符、应用程序版本、应用分发渠道、独立设备标识符、iOS广告标识符（IDFA)、安卓广告主标识符、网卡（MAC）地址、国际移动设备识别码（IMEI）、设备型号、终端制造厂商、终端设备操作系统版本、会话启动/停止时间、语言所在地、时区和网络状态（WiFi等）、硬盘、CPU和电池使用情况等。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（三）其他使用情况</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">当我们要将信息用于本策略未载明的其它用途时，会事先征求您的同意。</span></p><p><span style=\"font-family: 微软雅黑;\">当我们要将基于特定目的收集而来的信息用于其他目的时，会事先征求您的同意。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">二、我们如何使用 Cookie 和同类技术</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（一）Cookie为确保网站正常运转，我们会在您的计算机或移动设备上存储名为 Cookie 的小数据文件。Cookie 通常包含标识符、站点名称以及一些号码和字符。借助于 Cookie，网站能够存储您的偏好或购物篮内的商品等数据。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们不会将 Cookie 用于本政策所述目的之外的任何用途。您可根据自己的偏好管理或删除 Cookie。您可以清除计算机上保存的所有 Cookie，大部分网络浏览器都设有阻止 Cookie 的功能。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（二）网站信标和像素标签除 Cookie 外，我们还会在网站上使用网站信标和像素标签等其他同类技术。</span></p><p><span style=\"font-family: 微软雅黑;\">例如，我们向您发送的电子邮件可能含有链接至我们网站内容的点击 URL。如果您点击该链接，我们则会跟踪此次点击，帮助我们了解您的产品或服务偏好并改善客户服务。网站信标通常是一种嵌入到网站或电子邮件中的透明图像。借助于电子邮件中的像素标签，我们能够获知电子邮件是否被打开。如果您不希望自己的活动以这种方式被追踪，则可以随时从我们的寄信名单中退订。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（三）Do Not Track（请勿追踪）</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">很多网络浏览器均设有 Do Not Track 功能，该功能可向网站发布 Do Not Track 请求。目前，主要互联网标准组织尚未设立相关政策来规定网站应如何应对此类请求。但如果您的浏览器启用了 Do Not Track，那么我们的所有网站都会尊重您的选择。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">三、我们如何共享、转让、公开披露您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（一）共享</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们不会向其他任何公司、组织和个人分享您的个人信息，但以下情况除外：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">1、在获取明确同意的情况下共享：获得您的明确同意后，我们会与其他方共享您的个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">2、我们可能会根据法律法规规定，或按政府主管部门的强制性要求，对外共享您的个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">3、与我们的关联公司共享：您的个人信息可能会与我们关联公司共享。我们只会共享必要的个人信息，且受本隐私协议中所声明目的的约束。</span></p><p><span style=\"font-family: 微软雅黑;\">关联公司如要改变个人信息的处理目的，将再次征求您的授权同意。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">4、与授权合作伙伴共享：仅为实现本隐私协议中声明的目的，我们的某些服务将由授权合作伙伴提供。我们可能会与合作伙伴共享您的某些个人信息，以提供更好的客户服务和用户体验。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">例如，我们聘请来提供第三方数据统计和分析服务的公司可能需要采集和访问个人数据以进行数据统计和分析。在这种情况下，这些公司 必须遵守我们的数据隐私和安全要求。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们仅会出于合法、正当、必要、特定、明确的目的共享您的个人信息，并且只会共享提供服务所必要的个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">对我们与之共享个人信息的公司、组织和个人，我们会与其签署严格的保密协定，要求他们按照我们的说明、本隐私协议以及其他任何相关的保密和安全措施来处理个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（二）转让</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们不会将您的个人信息转让给任何公司、组织和个人，但以下情况除外：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">1、在获取明确同意的情况下转让：获得您的明确同意后，我们会向其他方转让您的个人信息；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">2、在涉及合并、收购或破产清算时，如涉及到个人信息转让，我们会在要求新的持有您个人信息的公司、组织继续受此隐私政策的约束，否则我们将要求该公司、组织重新向您征求授权同意。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（三）公开披露</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们仅会在以下情况下，公开披露您的个人信息：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">1、获得您明确同意后；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">2、基于法律的披露：在法律、法律程序、诉讼或政府主管部门强制性要求的情况下，我们可能会公开披露您的个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">四、我们如何保护您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（一）我们已使用符合业界标准的安全防护措施保护您提供的个人信息，防止数据遭到未经授权访问、公开披露、使用、修改、损坏或丢失。我们会采取一切合理可行的措施，保护您的个人信息。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">例如，在您的浏览器与“服务”之间交换数据（如信用卡信息）时受 SSL 加密保护；我们同时对我们网站提供 https 安全浏览方式；我们会使用加密技术确保数据的保密性；我们会使用受信赖的保护机制防止数据遭到恶意攻击；我们会部署访问控制机制，确保只有授权人员才可访问个人信息；以及我们会举办安全和隐私保护培训课程，加强员工对于保护个人信息重要性的认识。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（二）我们会采取一切合理可行的措施，确保未收集无关的个人信息。我们只会在达成本政策所述目的所需的期限内保留您的个人信息，除非需要延长保留期或受到法律的允许。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（三）互联网并非绝对安全的环境，而且电子邮件、即时通讯、及与其他我们用户的交流方式并未加密，我们强烈建议您不要通过此类方式发送个人信息。请使用复杂密码，协助我们保证您的账号安全。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（四）互联网环境并非百分之百安全，我们将尽力确保或担保您发送给我们的任何信息的安全性。如果我们的物理、技术、或管理防护设施遭到破坏，导致信息被非授权访问、公开披露、篡改、或毁坏，导致您的合法权益受损，我们将承担相应的法律责任。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（五）在不幸发生个人信息安全事件后，我们将按照法律法规的要求，及时向您告知：安全事件的基本情况和可能的影响、我们已采取或将要采取的处置措施、您可自主防范和降低风险的建议、对您的补救措施等。我们将及时将事件相关情况以邮件、信函、电话、推送通知等方式告知您，难以逐一告知个人信息主体时，我们会采取合理、有效的方式发布公告。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">同时，我们还将按照监管部门要求，主动上报个人信息安全事件的处置情况。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">五、您的权利</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">按照中国相关的法律、法规、标准，以及其他国家、地区的通行做法，我们保障您对自己的个人信息行使以下权利：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（一）访问您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">您有权访问您的个人信息，法律法规规定的例外情况除外。如果您想行使数据访问权，可以通过以下方式自行访问：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">账户信息——如果您希望访问或编辑您的账户中的个人资料信息和支付信息、更改您的密码、添加安全信息或关闭您的账户等，您可以通过打开个人中心在设置里找到账户安全执行此类操作。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">对于您在使用我们的产品或服务过程中产生的其他个人信息，只要我们不需要过多投入，我们会向您提供。如果您想行使数据访问权，请联系yshop客服。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（二）更正您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">当您发现我们处理的关于您的个人信息有错误时，您有权要求我们做出更正。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">您可以通过“（一）访问您的个人信息”中罗列的方式提出更正申请。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">（三）删除您的个人信息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">在以下情形中，您可以向我们提出删除个人信息的请求：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">1、如果我们处理个人信息的行为违反法律法规；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">2、如果我们收集、使用您的个人信息，却未征得您的同意；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">3、如果我们处理个人信息的行为违反了与您的约定；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">4、如果您不再使用我们的产品或服务，或您注销了账号；</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">5、如果我们不再为您提供产品或服务。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">若我们决定响应您的删除请求，我们还将同时通知从我们获得您的个人信息的实体，要求其及时删除，除非法律法规另有规定，或这些实体获得您的独立授权。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">当您从我们的服务中删除信息后，我们可能不会立即备份系统中删除相应的信息，但会在备份更新时删除这些信息。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">（四）改变您授权同意的范围</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">每个业务功能需要一些基本的个人信息才能得以完成（见本协议“第一部分”）。对于额外收集的个人信息的收集和使用，您可以随时给予或收回您的授权同意。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">当您收回同意后，我们将不再处理相应的个人信息。但您收回同意的决定，不会影响此前基于您的授权而开展的个人信息处理。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">（五）个人信息主体注销账户</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">您随时可注销此前注册的账户，您可以通过以下方式自行操作： 联系yshop客服</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">在注销账户之后，我们将停止为您提供产品或服务，并依据您的要求，删除您的个人信息，法律法规另有规定的除外。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">（六）约束信息系统自动决策</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">在某些业务功能中，我们可能仅依据信息系统、算法等在内的非人工自动决策机制做出决定。如果这些决定显著影响您的合法权益，您有权要求我们做出解释，我们也将提供适当的救济方式。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">（七）响应您的上述请求</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">为保障安全，您可能需要提供书面请求，或以其他方式证明您的身份。我们可能会先要求您验证自己的身份，然后再处理您的请求。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">我们将在三十天内做出答复。如您不满意，还可以通过以下途径投诉：</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">个人中心-投诉建议</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">对于您合理的请求，我们原则上不收取费用，但对多次重复、超出合理限度的请求，我们将视情收取一定成本费用。对于那些无端重复、需要过多技术手段（例如，需要开发新系统或从根本上改变现行惯例）、给他人合法权益带来风险或者非常不切实际（例如，涉及备份磁带上存放的信息）的请求，我们可能会予以拒绝。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">在以下情形中，按照法律法规要求，我们将无法响应您的请求：</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">1、与国家安全、国防安全有关的；</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">2、与公共安全、公共卫生、重大公共利益有关的；</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">3、与犯罪侦查、起诉和审判等有关的；</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">4、有充分证据表明您存在主观恶意或滥用权利的；</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">5、响应您的请求将导致您或其他个人、组织的合法权益受到严重损害的。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">六、我们如何处理儿童的个人信息</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">我们的产品、网站和服务主要面向成人。如果没有父母或监护人的同意，儿童不得创建自己的用户账户。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">对于经父母同意而收集儿童个人信息的情况，我们只会在受到法律允许、父母或监护人明确同意或者保护儿童所必要的情况下使用或公开披露此信息。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">尽管当地法律和习俗对儿童的定义不同，但我们将不满14周岁的任何人均视为儿童。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">如果我们发现自己在未事先获得可证实的父母同意的情况下收集了儿童的个人信息，则会设法尽快删除相关数据。</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">七、您的个人信息如何在全球范围转移</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">原则上，我们在中华人民共和国境内收集和产生的个人信息，将存储在中华人民共和国境内。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">由于我们通过遍布全球的资源和服务器提供产品或服务，这意味着，在获得您的授权同意后，您的个人信息可能会被转移到您使用产品或服务所在国家/地区的境外管辖区，或者受到来自这些管辖区的访问。</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">此类管辖区可能设有不同的数据保护法，甚至未设立相关法律。在此类情况下，我们会确保您的个人信息得到在中华人民共和国境内足够同等的保护。例如，我们会请求您对跨境转移个人信息的同意，或者在跨境数据转移之前实施数据去标识化等安全举措。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">八、本隐私协议如何更新</span></p><p><span style=\"font-family: 微软雅黑;\"> &nbsp; &nbsp; &nbsp; &nbsp; </span></p><p><span style=\"font-family: 微软雅黑;\">我们可能适时会对本隐私协议进行调整或变更，本隐私协议的任何更新将以标注更新时间的方式公布在我们网站上，除法律法规或监管规定另有强制性规定外，经调整或变更的内容一经通知或公布后的7日后生效。如您在隐私协议调整或变更后继续使用我们提供的任一服务或访问我们相关网站的，我们相信这代表您已充分阅读、理解并接受修改后的隐私协议并受其约束。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">九、第三方SDK以及说明</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们的产品基于DCloud;uni-app;App/Wap2App)开发，应用运行期间需要收集您的设备唯一识别码（IMEI/android;ID/DEVICE_ID/IDFA、SIM卡;IMSI;信息）以提供统计分析服务，并通过应用启动数据及异常错误日志分析改进性能和用户体验，为用户提供更好的服务。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">消息推送服务供应商（自启动）</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">我们可能会将您的设备平台、设备厂商、设备品牌、设备识别码等设备信息，应用列表信息、网络信息以及位置相关信息提供给合作伙伴，用于为您提供消息推送技术服务。我们在向您推送消息时，我们可能会授权合作伙伴进行链路调节，相互促活被关闭的SDK推送进程，保障您可以及时接收到我们向您推送的消息。</span></p><p><span style=\"font-family: 微软雅黑;\"> </span></p><p><span style=\"font-family: 微软雅黑;\">使用场景：推送订单付款、发货、售后以及余额提现、支付等系统类消息</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">微信一键登录/微信分享/微信支付（关联启动）</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">可能获取信息类型;存储的个人文件</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">设备权限：读取外置存储器、写入外置存储器</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">使用场景：注册登录账号、微信分享、朋友圈分享、微信小程序分享、用户下单付款、订单申请售后</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">支付宝支付（关联启动）</span></p><p><span style=\"font-family: 微软雅黑;\">设备权限：读取网络状态 &nbsp; &nbsp;</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">使用场景：用户下单付款、订单申请售后</span></p><p><span style=\"font-family: 微软雅黑;\">隐私政策链接：https://render.alipay.com/p/c/k2cx0tg8</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">设备权限：获取网络状态、访问Wi-Fi状态、位置信息、访问粗略位置、访问精准定位、读取手机状态和身份</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">使用场景：同城配送获取地址信息、同城自取自动推荐附近的门店</span></p><p><br></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">十、如何联系我们</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">如果您对本隐私政策有任何疑问、意见或建议，通过以下方式与我们联系：</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">邮箱：yshop@yixiang.co</span></p><p><br></p><p><span style=\"font-family: 微软雅黑;\">一般情况下，我们将在三十天内回复。</span></p><p><br></p>', 0, '', '', '', 0, 0, '2023-09-15 11:18:26', '2023-09-18 16:44:12', '1', '1', b'0');
INSERT INTO `yshop_service` VALUES (31, '积分订单', ' http://localhost:48081/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', 'pages', '', 0, '', '/pages/components/pages/scoreproduct/order', '', 0, 1, '2023-11-30 15:58:29', '2023-11-30 15:58:29', '1', '1', b'1');
COMMIT;

-- ----------------------------
-- Table structure for yshop_shipping_templates
-- ----------------------------
DROP TABLE IF EXISTS `yshop_shipping_templates`;
CREATE TABLE `yshop_shipping_templates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `name` varchar(255) DEFAULT NULL COMMENT '模板名称',
  `type` tinyint(1) DEFAULT NULL COMMENT '计费方式',
  `region_info` text COMMENT '地域以及费用',
  `appoint` tinyint(1) DEFAULT NULL COMMENT '指定包邮开关',
  `appoint_info` text COMMENT '指定包邮内容',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '是否删除',
  `sort` int DEFAULT NULL COMMENT '排序',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='运费模板表';

-- ----------------------------
-- Records of yshop_shipping_templates
-- ----------------------------
BEGIN;
INSERT INTO `yshop_shipping_templates` VALUES (38, '指定区域邮费', 1, '[{\"_continue\":\"1\",\"continue_price\":\"0\",\"first\":\"1\",\"price\":\"0\",\"region\":[{\"city_id\":\"0\",\"name\":\"默认全国\"}],\"regionName\":\"默认全国\"},{\"_continue\":\"1\",\"continue_price\":\"0\",\"first\":\"1\",\"price\":\"0\",\"region\":[{\"children\":[{\"city_id\":\"210100\"},{\"city_id\":\"210200\"},{\"city_id\":\"210300\"},{\"city_id\":\"210400\"},{\"city_id\":\"210500\"},{\"city_id\":\"210600\"},{\"city_id\":\"210700\"},{\"city_id\":\"210800\"},{\"city_id\":\"210900\"},{\"city_id\":\"211000\"},{\"city_id\":\"211100\"},{\"city_id\":\"211200\"},{\"city_id\":\"211300\"},{\"city_id\":\"211400\"}],\"city_id\":\"210000\",\"name\":\"辽宁省\"}],\"regionName\":\"辽宁省\"}]', 0, '[]', '1', '2023-06-06 11:04:36', '2023-06-06 14:17:04', '1', b'0', 0, NULL);
INSERT INTO `yshop_shipping_templates` VALUES (39, '指定包邮区域', 1, '[{\"_continue\":\"1\",\"continue_price\":\"0\",\"first\":\"1\",\"price\":\"0\",\"region\":[{\"city_id\":\"0\",\"name\":\"默认全国\"}],\"regionName\":\"默认全国\"}]', 1, '[{\"a_num\":\"1\",\"a_price\":\"10\",\"place\":[{\"children\":[{\"city_id\":\"140100\"},{\"city_id\":\"140200\"},{\"city_id\":\"140300\"},{\"city_id\":\"140400\"},{\"city_id\":\"140500\"},{\"city_id\":\"140600\"},{\"city_id\":\"140700\"},{\"city_id\":\"140800\"},{\"city_id\":\"140900\"},{\"city_id\":\"141000\"},{\"city_id\":\"141100\"}],\"city_id\":\"140000\",\"name\":\"山西省\"}],\"placeName\":\"山西省\"}]', '1', '2023-06-06 14:42:12', '2023-06-06 14:42:12', '1', b'0', 0, NULL);
COMMIT;

-- ----------------------------
-- Table structure for yshop_shipping_templates_free
-- ----------------------------
DROP TABLE IF EXISTS `yshop_shipping_templates_free`;
CREATE TABLE `yshop_shipping_templates_free` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模板ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `number` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '包邮件数',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '包邮金额',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计费方式',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT '分组唯一值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='运费包邮明细';

-- ----------------------------
-- Records of yshop_shipping_templates_free
-- ----------------------------
BEGIN;
INSERT INTO `yshop_shipping_templates_free` VALUES (198, 140000, 39, 140100, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (199, 140000, 39, 140200, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (200, 140000, 39, 140300, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (201, 140000, 39, 140400, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (202, 140000, 39, 140500, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (203, 140000, 39, 140600, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (204, 140000, 39, 140700, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (205, 140000, 39, 140800, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (206, 140000, 39, 140900, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (207, 140000, 39, 141000, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
INSERT INTO `yshop_shipping_templates_free` VALUES (208, 140000, 39, 141100, 1.00, 10.00, 1, 'f0c0b3c3ba41412cb8cd3fcd6816db0a');
COMMIT;

-- ----------------------------
-- Table structure for yshop_shipping_templates_region
-- ----------------------------
DROP TABLE IF EXISTS `yshop_shipping_templates_region`;
CREATE TABLE `yshop_shipping_templates_region` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模板ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `first` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '首件',
  `first_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '首件运费',
  `continues` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '续件',
  `continue_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '续件运费',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计费方式',
  `uniqid` varchar(50) NOT NULL DEFAULT '' COMMENT '分组唯一值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=281 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='运费区域明细';

-- ----------------------------
-- Records of yshop_shipping_templates_region
-- ----------------------------
BEGIN;
INSERT INTO `yshop_shipping_templates_region` VALUES (265, 0, 38, 0, 1.00, 0.00, 1.00, 0.00, 1, 'c22578ad3faa48808b4db605d616f261');
INSERT INTO `yshop_shipping_templates_region` VALUES (266, 210000, 38, 210100, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (267, 210000, 38, 210200, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (268, 210000, 38, 210300, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (269, 210000, 38, 210400, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (270, 210000, 38, 210500, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (271, 210000, 38, 210600, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (272, 210000, 38, 210700, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (273, 210000, 38, 210800, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (274, 210000, 38, 210900, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (275, 210000, 38, 211000, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (276, 210000, 38, 211100, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (277, 210000, 38, 211200, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (278, 210000, 38, 211300, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (279, 210000, 38, 211400, 1.00, 0.00, 1.00, 0.00, 1, 'eac07825ccf9410cb25fe8d77262b97e');
INSERT INTO `yshop_shipping_templates_region` VALUES (280, 0, 39, 0, 1.00, 0.00, 1.00, 0.00, 1, 'df16d9afcfa64c73af73fcf93ecdb4ea');
COMMIT;

-- ----------------------------
-- Table structure for yshop_shop_ads
-- ----------------------------
DROP TABLE IF EXISTS `yshop_shop_ads`;
CREATE TABLE `yshop_shop_ads` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `image` varchar(255) DEFAULT NULL COMMENT '图片',
  `is_switch` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显现',
  `weigh` int NOT NULL DEFAULT '0' COMMENT '权重',
  `shop_id` varchar(500) NOT NULL DEFAULT '0' COMMENT '所支持的店铺id用'',''区分，0代表全部',
  `shop_name` varchar(1000) DEFAULT NULL COMMENT '店铺名称逗号隔开',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `weigh` (`weigh`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='广告图管理';

-- ----------------------------
-- Records of yshop_shop_ads
-- ----------------------------
BEGIN;
INSERT INTO `yshop_shop_ads` VALUES (1, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 1, 1, '0', '意向餐饮店', '2023-08-06 18:42:28', '2023-09-14 10:27:55', '1', '1', b'0');
INSERT INTO `yshop_shop_ads` VALUES (2, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 1, 2, '0', '全部', '2023-08-08 09:21:32', '2023-09-14 10:27:43', '1', '1', b'0');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_order
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_order`;
CREATE TABLE `yshop_store_order` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `shop_id` bigint DEFAULT NULL COMMENT '门店id',
  `shop_name` varchar(100) DEFAULT NULL COMMENT '店铺名称',
  `extend_order_id` varchar(32) DEFAULT NULL COMMENT '额外订单号',
  `uid` bigint unsigned NOT NULL COMMENT '用户id',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL DEFAULT '' COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL DEFAULT '' COMMENT '详细地址',
  `cart_id` varchar(256) NOT NULL DEFAULT '[]' COMMENT '购物车id',
  `freight_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `total_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `pay_type` varchar(32) NOT NULL COMMENT '支付方式',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：已完成；-1：已退款）',
  `refund_status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` datetime DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `delivery_sn` varchar(100) DEFAULT '' COMMENT '快递公司编号',
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT 'normal' COMMENT '发货类型normal-手动填写 ｜face-电子面单',
  `delivery_time` datetime DEFAULT NULL COMMENT '发货时间',
  `order_type` varchar(50) DEFAULT 'send' COMMENT '购买类型:takein=自取,takeout=外卖\n',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `gain_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '消费赚取积分',
  `use_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '使用积分',
  `pay_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付积分',
  `back_integral` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '给用户退了多少积分',
  `mark` varchar(512) NOT NULL COMMENT '备注',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `combination_id` bigint unsigned DEFAULT '0' COMMENT '拼团产品id0一般产品',
  `pink_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '拼团id 0没有拼团',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `seckill_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '秒杀产品ID',
  `bargain_id` int unsigned DEFAULT '0' COMMENT '砍价id',
  `verify_code` varchar(50) NOT NULL DEFAULT '' COMMENT '核销码',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `shipping_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '配送方式 1=快递 ，2=门店自提',
  `is_channel` tinyint unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) DEFAULT '0' COMMENT '系统删除',
  `get_time` datetime DEFAULT NULL COMMENT '取餐时间',
  `number_id` int DEFAULT NULL COMMENT '取餐号',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`uid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE,
  KEY `pay_time` (`pay_time`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='订单表';

-- ----------------------------
-- Records of yshop_store_order
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_order` VALUES (33, '1725000691803488256', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 0, NULL, 'weixin', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-16 11:59:49', 1032, b'0', NULL, '9', '2023-11-16 11:59:49', '2023-11-16 11:59:49', '9');
INSERT INTO `yshop_store_order` VALUES (34, '1725047622177128448', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.02, 20.00, 0.02, 20.00, 0.00, 0, 0.00, 1, '2023-11-16 15:06:18', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-16 15:06:18', 1033, b'0', NULL, '9', '2023-11-16 15:06:18', '2023-11-16 15:06:18', '9');
INSERT INTO `yshop_store_order` VALUES (35, '1725060861086662656', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 2, 2.01, 20.00, 2.01, 20.00, 0.00, 0, 0.00, 1, '2023-11-16 15:58:54', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-16 15:58:54', 1034, b'0', NULL, '9', '2023-11-16 15:58:54', '2023-11-16 15:58:54', '9');
INSERT INTO `yshop_store_order` VALUES (36, '1725061023016157184', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 2, 0.03, 20.00, 0.03, 20.00, 0.00, 0, 0.00, 1, '2023-11-16 15:59:33', 'yue', 3, 2, NULL, '66666', '2023-11-21 10:21:55', '协商一致', NULL, 0.03, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-16 15:59:33', 1035, b'0', NULL, '9', '2023-11-16 15:59:33', '2023-11-21 10:21:55', '9');
INSERT INTO `yshop_store_order` VALUES (37, '1726884445237018624', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2023-11-21 16:49:22', 'weixin', 0, 1, NULL, '7777', '2023-11-21 16:49:10', '协商一致', NULL, 0.01, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-21 16:45:10', 1036, b'0', NULL, '9', '2023-11-21 16:45:10', '2023-11-21 16:51:42', '1');
INSERT INTO `yshop_store_order` VALUES (38, '1727142223536979968', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2023-11-22 09:49:44', 'weixin', 0, 2, NULL, '999', '2023-11-22 09:50:22', '协商一致', NULL, 0.01, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-11-22 09:49:30', 1037, b'0', NULL, '9', '2023-11-22 09:49:30', '2023-11-22 09:50:22', '9');
INSERT INTO `yshop_store_order` VALUES (39, '1731503113317122048', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 3, 6.00, 20.00, 5.98, 20.00, 0.00, 6, 0.02, 1, '2023-12-04 10:38:07', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-12-04 10:38:07', 1038, b'0', NULL, '9', '2023-12-04 10:38:07', '2023-12-04 10:38:07', '9');
INSERT INTO `yshop_store_order` VALUES (40, '1731506721286782976', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2023-12-04 10:52:27', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 0.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-12-04 10:52:27', 1039, b'0', NULL, '9', '2023-12-04 10:52:27', '2023-12-04 10:52:27', '9');
INSERT INTO `yshop_store_order` VALUES (41, '1731517938814418944', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2023-12-04 11:37:02', 'yue', 3, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-12-04 11:37:01', 1040, b'0', NULL, '9', '2023-12-04 11:37:01', '2023-12-04 11:40:22', '9');
INSERT INTO `yshop_store_order` VALUES (42, '1732962343437991936', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 0, NULL, 'weixin', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-12-08 11:16:34', 1041, b'0', NULL, '9', '2023-12-08 11:16:34', '2023-12-08 11:16:34', '9');
INSERT INTO `yshop_store_order` VALUES (43, '1732962574971961344', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 0, NULL, 'weixin', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2023-12-08 11:17:29', 1042, b'0', NULL, '9', '2023-12-08 11:17:29', '2023-12-08 11:17:29', '9');
INSERT INTO `yshop_store_order` VALUES (44, '1796798236367781888', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 14:57:37', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 14:57:37', 1043, b'0', NULL, '9', '2024-06-01 14:57:37', '2024-06-01 14:57:37', '9');
INSERT INTO `yshop_store_order` VALUES (45, '1796801853577494528', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:12:00', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:12:00', 1044, b'0', NULL, '9', '2024-06-01 15:12:00', '2024-06-01 15:12:00', '9');
INSERT INTO `yshop_store_order` VALUES (46, '1796808148250525696', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:37:01', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:37:00', 1045, b'0', NULL, '9', '2024-06-01 15:37:00', '2024-06-01 15:37:01', '9');
INSERT INTO `yshop_store_order` VALUES (47, '1796810678279864320', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:47:04', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:47:03', 1046, b'0', NULL, '9', '2024-06-01 15:47:04', '2024-06-01 15:47:04', '9');
INSERT INTO `yshop_store_order` VALUES (48, '1796811230879416320', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:49:16', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:49:15', 1047, b'0', NULL, '9', '2024-06-01 15:49:15', '2024-06-01 15:49:16', '9');
INSERT INTO `yshop_store_order` VALUES (49, '1796811866152894464', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:51:47', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:51:47', 1048, b'0', NULL, '9', '2024-06-01 15:51:47', '2024-06-01 15:51:47', '9');
INSERT INTO `yshop_store_order` VALUES (50, '1796812463023325184', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:54:09', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:54:09', 1049, b'0', NULL, '9', '2024-06-01 15:54:09', '2024-06-01 15:54:09', '9');
INSERT INTO `yshop_store_order` VALUES (51, '1796813371828338688', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 15:57:46', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 15:57:46', 1050, b'0', NULL, '9', '2024-06-01 15:57:46', '2024-06-01 15:57:46', '9');
INSERT INTO `yshop_store_order` VALUES (52, '1796816765703946240', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 16:11:15', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 16:11:15', 1051, b'0', NULL, '9', '2024-06-01 16:11:15', '2024-06-01 16:11:15', '9');
INSERT INTO `yshop_store_order` VALUES (53, '1796817117392142336', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 16:12:39', 'yue', 0, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 16:12:39', 1052, b'0', NULL, '9', '2024-06-01 16:12:39', '2024-06-01 16:12:39', '9');
INSERT INTO `yshop_store_order` VALUES (54, '1796818221630750720', 2, '意向餐饮店', NULL, 9, '', '', '', '', 0.00, 1, 0.01, 20.00, 0.01, 20.00, 0.00, 0, 0.00, 1, '2024-06-01 16:17:17', 'weixin', 3, 0, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 'normal', NULL, 'takein', NULL, 10.00, 0.00, 0.00, 0.00, '', '', NULL, 0, 0, 0, 0.00, 0, 0, '', 0, 1, 0, 0, '2024-06-01 16:17:02', 1053, b'0', NULL, '9', '2024-06-01 16:17:02', '2024-06-01 16:23:03', '9');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_order_cart_info
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_order_cart_info`;
CREATE TABLE `yshop_store_order_cart_info` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `oid` bigint unsigned NOT NULL COMMENT '订单id',
  `order_id` varchar(32) DEFAULT NULL COMMENT '订单号',
  `cart_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '购物车id',
  `product_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `cart_info` text NOT NULL COMMENT '购买东西的详细信息',
  `unique` varchar(50) NOT NULL DEFAULT '' COMMENT '唯一id',
  `is_after_sales` tinyint(1) DEFAULT '0' COMMENT '是否能售后0不能1能',
  `title` varchar(100) DEFAULT '' COMMENT '商品名称',
  `image` varchar(500) DEFAULT '' COMMENT '商品图片',
  `number` int DEFAULT '0' COMMENT '数量',
  `price` decimal(10,2) DEFAULT NULL COMMENT '价格',
  `spec` varchar(500) DEFAULT '' COMMENT '规格',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cart_id` (`cart_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='订单购物详情表';

-- ----------------------------
-- Records of yshop_store_order_cart_info
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_order_cart_info` VALUES (1, 1, '1703615452900491264', 0, 17, '', 'fc56bf55528e42faace7d3623813d559', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (2, 2, '1703675877960712192', 0, 15, '', 'b5285e89df57426a9762f2ec786761fd', 1, '饮料', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (3, 3, '1703675968628981760', 0, 16, '', 'ab91e2f6868e44e1b8a2c35408d5abdf', 1, '土豆炒肉', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 1, 0.01, '3人|特辣');
INSERT INTO `yshop_store_order_cart_info` VALUES (4, 4, '1703677507523313664', 0, 16, '', '3e722c100a634d79b9f5169584237646', 1, '土豆炒肉', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 1, 0.01, '3人|特辣');
INSERT INTO `yshop_store_order_cart_info` VALUES (5, 5, '1703695133590945792', 0, 17, '', '9ed3d729203e4e59a8d85bf15a420e14', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (6, 6, '1703696098238922752', 0, 17, '', '8d64c27d64b64af79c243ee4d2d3df0d', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (7, 7, '1703697465292619776', 0, 17, '', 'ce841f03af9d44faaf54dcb0af23d9d7', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (8, 8, '1703711231535218688', 0, 17, '', 'bbad8f6cd320469aae219dfa8a869117', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (9, 9, '1703714583388094464', 0, 15, '', '1150efbbb2c5473284b9888f46cbb09f', 1, '饮料', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (10, 10, '1703715497381462016', 0, 15, '', '21b2c927eb4747fa96668a66deda212d', 1, '饮料', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (11, 11, '1703718316423512064', 0, 17, '', 'ad23983ca2cf42ebaafe01fbbfd9f6e2', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (12, 12, '1704879606328197120', 0, 17, '', '89325402c09d412ab6594ccb6923cb2f', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (13, 13, '1704880263286226944', 0, 17, '', '0dc2c437be2f42cc8774a62271d922fc', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (14, 14, '1704880316985901056', 0, 17, '', '34ad392b21ca400cad16e91ed810ee19', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (15, 15, '1704880485911494656', 0, 17, '', '000f3fcb983944a78dac08306b436a4a', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (16, 16, '1710504621161578496', 0, 17, '', '7de49ee616e24dfa8570ec3c4a76d735', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (17, 17, '1714842349156171776', 0, 17, '', 'b71bf00034d849a58d97215f7b30fb4c', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (18, 18, '1715549852135325696', 0, 17, '', '82739ad2f5954c4fada1bfda75887108', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (19, 19, '1716272228393287680', 0, 17, '', '9e2c597890d84f17ae8092759a5481d7', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (20, 20, '1716277998795096064', 0, 17, '', 'd841866795ba40d3be88ded81806b1f1', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (21, 21, '1716278197982593024', 0, 17, '', 'f161a4309d754e1fa6dce388c4d8ad0b', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (22, 22, '1716278745859358720', 0, 17, '', '131e9a4d9ee84f90b7cb97bcc9c98afb', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (23, 23, '1716279604374667264', 0, 17, '', 'e01733ab17a0479c8e38565b825347f9', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (24, 24, '1716282100870545408', 0, 17, '', '2729f12201184741a1d390d04eed9f01', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (25, 25, '1716282959058698240', 0, 17, '', '66046faf578549ca886e77b2a39b3669', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (26, 26, '1716285974796828672', 0, 17, '', '2fd0c5de8dcb421286b4d550c22912c8', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (27, 27, '1716288494575288320', 0, 17, '', 'd139a1d2f1554b04b7e906aff938f604', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (28, 28, '1716290062221574144', 0, 17, '', '73d3c25e63fa435ebaf8789bc6299d68', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (29, 29, '1716291271800127488', 0, 17, '', 'f9019ebbecbb4a47b94ae70eeb2bf052', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (30, 30, '1716291285691662336', 0, 17, '', '1ea4c2e2d669474fb0aaaed6be67cfb8', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (31, 31, '1721369605764546560', 0, 18, '', 'd7758461e8474e7984369cc62c8a865d', 1, '1', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 3, 2.00, '默认');
INSERT INTO `yshop_store_order_cart_info` VALUES (32, 32, '1721371148484083712', 0, 17, '', '81b0f0d912884d24bff9fb4982d1418e', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (33, 33, '1725000691803488256', 0, 15, '', 'd9176155c2394427a8cad79374a47c48', 1, '饮料', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (34, 34, '1725047622177128448', 0, 17, '', '13772df59720499183f9068e16e1bf2c', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.02, '30ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (35, 35, '1725060861086662656', 0, 17, '', 'b6e4b7b8f6d34e02bc3618a838ab2a16', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (36, 35, '1725060861086662656', 0, 18, '', '389f398fbdac40e3a3d9fabf0e129ad8', 1, '1', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 1, 2.00, '默认');
INSERT INTO `yshop_store_order_cart_info` VALUES (37, 36, '1725061023016157184', 0, 17, '', 'e1d43088b8544691bfcab11c1fd70568', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.02, '30ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (38, 36, '1725061023016157184', 0, 15, '', '405cad0a357c41f5b9fe03cd374d9551', 1, '饮料', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (39, 37, '1726884445237018624', 0, 17, '', '7ddbdf7376394174b70faaebda298b79', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (40, 38, '1727142223536979968', 0, 17, '', 'b998dadd69424c77967591c6b6abe764', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (41, 39, '1731503113317122048', 0, 22, '', 'df67cd84cdfa43c0b6a11fe03f75a369', 1, '5555', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 3, 2.00, '默认');
INSERT INTO `yshop_store_order_cart_info` VALUES (42, 40, '1731506721286782976', 0, 17, '', '01a932adf7c64901a0d85d9de18b8169', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (43, 41, '1731517938814418944', 0, 17, '', '9b14921379ab455fb073fb8ea5683ed9', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (44, 42, '1732962343437991936', 0, 17, '', '28d527c2a91e40e7984d3d0954c0fc8a', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (45, 43, '1732962574971961344', 0, 17, '', '8e03369da8224487aa55851a84164876', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (46, 44, '1796798236367781888', 0, 17, '', 'beee739aaf9f4c5ab9f12045eaa5f10b', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (47, 45, '1796801853577494528', 0, 17, '', 'b2735f02edaf41519ef3c1787392c235', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (48, 46, '1796808148250525696', 0, 17, '', '4e1bc6af02b049e199562cb10534256a', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (49, 47, '1796810678279864320', 0, 17, '', '43a4f52778284708af40087f516e21a5', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (50, 48, '1796811230879416320', 0, 17, '', 'a05c0e74e41e479485e8a2ee10eed469', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (51, 49, '1796811866152894464', 0, 17, '', '410cc5aebb364fe5b34b3cec008c1000', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (52, 50, '1796812463023325184', 0, 17, '', '06bf6815bbd94250b996af635560cced', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (53, 51, '1796813371828338688', 0, 17, '', '343916bea8764cc1852055b4f3db7e09', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (54, 52, '1796816765703946240', 0, 17, '', '56cc173ab39d4b12ac49d63ba105bfbc', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (55, 53, '1796817117392142336', 0, 17, '', '1fae3fac6f5c49bb98c1dec596aa84df', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
INSERT INTO `yshop_store_order_cart_info` VALUES (56, 54, '1796818221630750720', 0, 17, '', '8e576783be9148a18dd8a8a8020e2253', 1, '小蛋糕', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 1, 0.01, '10ml');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_order_status
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_order_status`;
CREATE TABLE `yshop_store_order_status` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `oid` bigint unsigned NOT NULL COMMENT '订单id',
  `change_type` varchar(32) NOT NULL COMMENT '操作类型',
  `change_message` varchar(256) NOT NULL COMMENT '操作备注',
  `change_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `oid` (`oid`) USING BTREE,
  KEY `change_type` (`change_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='订单操作记录表';

-- ----------------------------
-- Records of yshop_store_order_status
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_order_status` VALUES (1, 1, 'yshop_create_order', '订单生成', '2023-09-18 11:42:30');
INSERT INTO `yshop_store_order_status` VALUES (2, 1, 'pay_success', '用户付款成功', '2023-09-18 11:42:30');
INSERT INTO `yshop_store_order_status` VALUES (3, 2, 'yshop_create_order', '订单生成', '2023-09-18 15:42:36');
INSERT INTO `yshop_store_order_status` VALUES (4, 2, 'pay_success', '用户付款成功', '2023-09-18 15:42:37');
INSERT INTO `yshop_store_order_status` VALUES (5, 3, 'yshop_create_order', '订单生成', '2023-09-18 15:42:58');
INSERT INTO `yshop_store_order_status` VALUES (6, 4, 'yshop_create_order', '订单生成', '2023-09-18 15:49:05');
INSERT INTO `yshop_store_order_status` VALUES (7, 4, 'pay_success', '用户付款成功', '2023-09-18 15:49:11');
INSERT INTO `yshop_store_order_status` VALUES (8, 4, 'user_take_delivery', '用户已收货', '2023-09-18 16:22:12');
INSERT INTO `yshop_store_order_status` VALUES (9, 2, 'user_take_delivery', '用户已收货', '2023-09-18 16:23:22');
INSERT INTO `yshop_store_order_status` VALUES (10, 1, 'delivery_goods', '已发货 快递公司：null快递单号：null', '2023-09-18 16:23:37');
INSERT INTO `yshop_store_order_status` VALUES (11, 1, 'user_take_delivery', '用户已收货', '2023-09-18 16:25:42');
INSERT INTO `yshop_store_order_status` VALUES (12, 5, 'yshop_create_order', '订单生成', '2023-09-18 16:59:07');
INSERT INTO `yshop_store_order_status` VALUES (13, 6, 'yshop_create_order', '订单生成', '2023-09-18 17:02:57');
INSERT INTO `yshop_store_order_status` VALUES (14, 7, 'yshop_create_order', '订单生成', '2023-09-18 17:08:23');
INSERT INTO `yshop_store_order_status` VALUES (15, 8, 'yshop_create_order', '订单生成', '2023-09-18 18:03:05');
INSERT INTO `yshop_store_order_status` VALUES (16, 9, 'yshop_create_order', '订单生成', '2023-09-18 18:16:24');
INSERT INTO `yshop_store_order_status` VALUES (17, 10, 'yshop_create_order', '订单生成', '2023-09-18 18:20:02');
INSERT INTO `yshop_store_order_status` VALUES (18, 11, 'yshop_create_order', '订单生成', '2023-09-18 18:31:14');
INSERT INTO `yshop_store_order_status` VALUES (19, 12, 'yshop_create_order', '订单生成', '2023-09-21 23:25:48');
INSERT INTO `yshop_store_order_status` VALUES (20, 13, 'yshop_create_order', '订单生成', '2023-09-21 23:28:24');
INSERT INTO `yshop_store_order_status` VALUES (21, 14, 'yshop_create_order', '订单生成', '2023-09-21 23:28:37');
INSERT INTO `yshop_store_order_status` VALUES (22, 15, 'yshop_create_order', '订单生成', '2023-09-21 23:29:17');
INSERT INTO `yshop_store_order_status` VALUES (23, 16, 'yshop_create_order', '订单生成', '2023-10-07 11:57:36');
INSERT INTO `yshop_store_order_status` VALUES (24, 16, 'pay_success', '用户付款成功', '2023-10-07 11:57:36');
INSERT INTO `yshop_store_order_status` VALUES (25, 16, 'user_take_delivery', '用户已收货', '2023-10-07 11:58:15');
INSERT INTO `yshop_store_order_status` VALUES (26, 17, 'yshop_create_order', '订单生成', '2023-10-19 11:14:11');
INSERT INTO `yshop_store_order_status` VALUES (27, 18, 'yshop_create_order', '订单生成', '2023-10-21 10:05:32');
INSERT INTO `yshop_store_order_status` VALUES (28, 19, 'yshop_create_order', '订单生成', '2023-10-23 09:56:00');
INSERT INTO `yshop_store_order_status` VALUES (29, 20, 'yshop_create_order', '订单生成', '2023-10-23 10:18:56');
INSERT INTO `yshop_store_order_status` VALUES (30, 21, 'yshop_create_order', '订单生成', '2023-10-23 10:19:44');
INSERT INTO `yshop_store_order_status` VALUES (31, 22, 'yshop_create_order', '订单生成', '2023-10-23 10:21:54');
INSERT INTO `yshop_store_order_status` VALUES (32, 23, 'yshop_create_order', '订单生成', '2023-10-23 10:25:19');
INSERT INTO `yshop_store_order_status` VALUES (33, 24, 'yshop_create_order', '订单生成', '2023-10-23 10:35:14');
INSERT INTO `yshop_store_order_status` VALUES (34, 25, 'yshop_create_order', '订单生成', '2023-10-23 10:38:39');
INSERT INTO `yshop_store_order_status` VALUES (35, 26, 'yshop_create_order', '订单生成', '2023-10-23 10:50:38');
INSERT INTO `yshop_store_order_status` VALUES (36, 27, 'yshop_create_order', '订单生成', '2023-10-23 11:00:38');
INSERT INTO `yshop_store_order_status` VALUES (37, 28, 'yshop_create_order', '订单生成', '2023-10-23 11:06:52');
INSERT INTO `yshop_store_order_status` VALUES (38, 29, 'yshop_create_order', '订单生成', '2023-10-23 11:11:41');
INSERT INTO `yshop_store_order_status` VALUES (39, 30, 'yshop_create_order', '订单生成', '2023-10-23 11:11:44');
INSERT INTO `yshop_store_order_status` VALUES (40, 31, 'yshop_create_order', '订单生成', '2023-11-06 11:31:10');
INSERT INTO `yshop_store_order_status` VALUES (41, 32, 'yshop_create_order', '订单生成', '2023-11-06 11:37:17');
INSERT INTO `yshop_store_order_status` VALUES (42, 33, 'yshop_create_order', '订单生成', '2023-11-16 11:59:48');
INSERT INTO `yshop_store_order_status` VALUES (43, 34, 'yshop_create_order', '订单生成', '2023-11-16 15:06:17');
INSERT INTO `yshop_store_order_status` VALUES (44, 34, 'pay_success', '用户付款成功', '2023-11-16 15:06:17');
INSERT INTO `yshop_store_order_status` VALUES (45, 35, 'yshop_create_order', '订单生成', '2023-11-16 15:58:54');
INSERT INTO `yshop_store_order_status` VALUES (46, 35, 'pay_success', '用户付款成功', '2023-11-16 15:58:54');
INSERT INTO `yshop_store_order_status` VALUES (47, 36, 'yshop_create_order', '订单生成', '2023-11-16 15:59:32');
INSERT INTO `yshop_store_order_status` VALUES (48, 36, 'pay_success', '用户付款成功', '2023-11-16 15:59:32');
INSERT INTO `yshop_store_order_status` VALUES (49, 36, 'user_take_delivery', '用户已收货', '2023-11-17 10:32:45');
INSERT INTO `yshop_store_order_status` VALUES (50, 36, 'apply_refund', '用户申请退款，原因：协商一致', '2023-11-21 10:21:55');
INSERT INTO `yshop_store_order_status` VALUES (51, 37, 'yshop_create_order', '订单生成', '2023-11-21 16:45:10');
INSERT INTO `yshop_store_order_status` VALUES (52, 37, 'apply_refund', '用户申请退款，原因：协商一致', '2023-11-21 16:49:10');
INSERT INTO `yshop_store_order_status` VALUES (53, 37, 'pay_success', '用户付款成功', '2023-11-21 16:49:22');
INSERT INTO `yshop_store_order_status` VALUES (54, 37, 'refund_price_success', '退款给用户：0.01元', '2023-11-21 22:04:37');
INSERT INTO `yshop_store_order_status` VALUES (55, 38, 'yshop_create_order', '订单生成', '2023-11-22 09:49:29');
INSERT INTO `yshop_store_order_status` VALUES (56, 38, 'pay_success', '用户付款成功', '2023-11-22 09:49:43');
INSERT INTO `yshop_store_order_status` VALUES (57, 38, 'apply_refund', '用户申请退款，原因：协商一致', '2023-11-22 09:50:22');
INSERT INTO `yshop_store_order_status` VALUES (58, 38, 'refund_price_success', '退款给用户：0.01元', '2023-11-22 09:50:49');
INSERT INTO `yshop_store_order_status` VALUES (59, 36, 'refund_price_success', '退款给用户：0.03元', '2023-11-22 09:56:31');
INSERT INTO `yshop_store_order_status` VALUES (60, 39, 'yshop_create_order', '订单生成', '2023-12-04 10:38:06');
INSERT INTO `yshop_store_order_status` VALUES (61, 39, 'pay_success', '用户付款成功', '2023-12-04 10:38:06');
INSERT INTO `yshop_store_order_status` VALUES (62, 40, 'yshop_create_order', '订单生成', '2023-12-04 10:52:26');
INSERT INTO `yshop_store_order_status` VALUES (63, 40, 'pay_success', '用户付款成功', '2023-12-04 10:52:27');
INSERT INTO `yshop_store_order_status` VALUES (64, 41, 'yshop_create_order', '订单生成', '2023-12-04 11:37:01');
INSERT INTO `yshop_store_order_status` VALUES (65, 41, 'pay_success', '用户付款成功', '2023-12-04 11:37:01');
INSERT INTO `yshop_store_order_status` VALUES (66, 41, 'user_take_delivery', '用户已收货', '2023-12-04 11:40:22');
INSERT INTO `yshop_store_order_status` VALUES (67, 42, 'yshop_create_order', '订单生成', '2023-12-08 11:16:34');
INSERT INTO `yshop_store_order_status` VALUES (68, 43, 'yshop_create_order', '订单生成', '2023-12-08 11:17:29');
INSERT INTO `yshop_store_order_status` VALUES (69, 44, 'yshop_create_order', '订单生成', '2024-06-01 14:57:37');
INSERT INTO `yshop_store_order_status` VALUES (70, 44, 'pay_success', '用户付款成功', '2024-06-01 14:57:37');
INSERT INTO `yshop_store_order_status` VALUES (71, 45, 'yshop_create_order', '订单生成', '2024-06-01 15:11:59');
INSERT INTO `yshop_store_order_status` VALUES (72, 45, 'pay_success', '用户付款成功', '2024-06-01 15:11:59');
INSERT INTO `yshop_store_order_status` VALUES (73, 46, 'yshop_create_order', '订单生成', '2024-06-01 15:37:00');
INSERT INTO `yshop_store_order_status` VALUES (74, 46, 'pay_success', '用户付款成功', '2024-06-01 15:37:00');
INSERT INTO `yshop_store_order_status` VALUES (75, 47, 'yshop_create_order', '订单生成', '2024-06-01 15:47:03');
INSERT INTO `yshop_store_order_status` VALUES (76, 47, 'pay_success', '用户付款成功', '2024-06-01 15:47:03');
INSERT INTO `yshop_store_order_status` VALUES (77, 48, 'yshop_create_order', '订单生成', '2024-06-01 15:49:15');
INSERT INTO `yshop_store_order_status` VALUES (78, 48, 'pay_success', '用户付款成功', '2024-06-01 15:49:15');
INSERT INTO `yshop_store_order_status` VALUES (79, 49, 'yshop_create_order', '订单生成', '2024-06-01 15:51:46');
INSERT INTO `yshop_store_order_status` VALUES (80, 49, 'pay_success', '用户付款成功', '2024-06-01 15:51:47');
INSERT INTO `yshop_store_order_status` VALUES (81, 50, 'yshop_create_order', '订单生成', '2024-06-01 15:54:09');
INSERT INTO `yshop_store_order_status` VALUES (82, 50, 'pay_success', '用户付款成功', '2024-06-01 15:54:09');
INSERT INTO `yshop_store_order_status` VALUES (83, 51, 'yshop_create_order', '订单生成', '2024-06-01 15:57:45');
INSERT INTO `yshop_store_order_status` VALUES (84, 51, 'pay_success', '用户付款成功', '2024-06-01 15:57:45');
INSERT INTO `yshop_store_order_status` VALUES (85, 52, 'yshop_create_order', '订单生成', '2024-06-01 16:11:14');
INSERT INTO `yshop_store_order_status` VALUES (86, 52, 'pay_success', '用户付款成功', '2024-06-01 16:11:15');
INSERT INTO `yshop_store_order_status` VALUES (87, 53, 'yshop_create_order', '订单生成', '2024-06-01 16:12:38');
INSERT INTO `yshop_store_order_status` VALUES (88, 53, 'pay_success', '用户付款成功', '2024-06-01 16:12:39');
INSERT INTO `yshop_store_order_status` VALUES (89, 54, 'yshop_create_order', '订单生成', '2024-06-01 16:17:02');
INSERT INTO `yshop_store_order_status` VALUES (90, 54, 'pay_success', '用户付款成功', '2024-06-01 16:17:17');
INSERT INTO `yshop_store_order_status` VALUES (91, 54, 'user_take_delivery', '用户已收货', '2024-06-01 16:23:02');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product`;
CREATE TABLE `yshop_store_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `shop_id` int DEFAULT NULL COMMENT '店铺id用''',
  `shop_name` varchar(100) DEFAULT NULL COMMENT '店铺名称',
  `image` varchar(256) NOT NULL COMMENT '商品图片',
  `slider_image` varchar(2000) NOT NULL COMMENT '轮播图',
  `store_name` varchar(128) NOT NULL COMMENT '商品名称',
  `store_info` varchar(256) NOT NULL COMMENT '商品简介',
  `keyword` varchar(256) NOT NULL COMMENT '关键字',
  `bar_code` varchar(15) DEFAULT '' COMMENT '产品条码（一维码）',
  `brand_id` bigint DEFAULT NULL COMMENT '品牌',
  `cate_id` varchar(64) NOT NULL COMMENT '分类id',
  `price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品价格',
  `vip_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '会员价格',
  `ot_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '市场价',
  `postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '邮费',
  `unit_name` varchar(32) DEFAULT NULL COMMENT '单位名',
  `sort` smallint DEFAULT '0' COMMENT '排序',
  `sales` mediumint unsigned DEFAULT '0' COMMENT '销量',
  `stock` mediumint unsigned DEFAULT '0' COMMENT '库存',
  `is_show` tinyint(1) DEFAULT '1' COMMENT '状态（0：未上架，1：上架）',
  `is_hot` tinyint(1) DEFAULT '0' COMMENT '是否热卖',
  `is_benefit` tinyint(1) DEFAULT '0' COMMENT '是否优惠',
  `is_best` tinyint(1) DEFAULT '0' COMMENT '是否精品',
  `is_new` tinyint(1) DEFAULT '0' COMMENT '是否新品',
  `description` text COMMENT '产品描述',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `is_postage` tinyint unsigned DEFAULT '0' COMMENT '是否包邮',
  `deleted` bit(1) DEFAULT b'0' COMMENT '是否删除',
  `mer_use` tinyint unsigned DEFAULT '0' COMMENT '商户是否代理 0不可代理1可代理',
  `give_integral` decimal(8,2) unsigned DEFAULT NULL COMMENT '获得积分',
  `cost` decimal(8,2) unsigned DEFAULT NULL COMMENT '成本价',
  `is_seckill` tinyint unsigned DEFAULT '0' COMMENT '秒杀状态 0 未开启 1已开启',
  `is_bargain` tinyint unsigned DEFAULT NULL COMMENT '砍价状态 0未开启 1开启',
  `is_good` tinyint(1) DEFAULT '0' COMMENT '是否优品推荐',
  `ficti` mediumint DEFAULT '100' COMMENT '虚拟销量',
  `browse` int DEFAULT '0' COMMENT '浏览量',
  `code_path` varchar(64) NOT NULL DEFAULT '' COMMENT '产品二维码地址(用户小程序海报)',
  `is_sub` tinyint(1) DEFAULT '0' COMMENT '是否单独分佣',
  `temp_id` int DEFAULT '0' COMMENT '运费模板ID',
  `spec_type` tinyint(1) DEFAULT '0' COMMENT '规格 0单 1多',
  `is_integral` tinyint(1) unsigned zerofill DEFAULT NULL COMMENT '是开启积分兑换',
  `integral` int DEFAULT '0' COMMENT '需要多少积分兑换 只在开启积分兑换时生效',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE,
  KEY `is_benefit` (`is_benefit`) USING BTREE,
  KEY `is_best` (`is_best`) USING BTREE,
  KEY `is_new` (`is_new`) USING BTREE,
  KEY `toggle_on_sale, is_del` (`deleted`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `sales` (`sales`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `is_postage` (`is_postage`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品表';

-- ----------------------------
-- Records of yshop_store_product
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product` VALUES (15, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '饮料', '单规格商品', '饮料', '', NULL, '1', 0.01, 0.00, 2.00, 0.00, '个', 0, 21, 1989, 1, 0, 0, 0, 0, '<p>单规格商品</p>', '1', '2023-05-30 13:41:51', '2023-09-14 17:28:33', '1', 0, b'0', 0, 0.00, 1.00, 0, NULL, 0, 0, 0, '', 0, 0, 1, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (16, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '土豆炒肉', '多规格', '土豆炒肉', '', NULL, '4', 0.01, 0.00, 1.00, 10.00, '个', 0, 16, 3431, 1, 0, 0, 0, 0, '<p>多规格</p>', '1', '2023-05-30 13:46:55', '2023-09-14 17:27:24', '1', 0, b'0', 0, 0.00, 1.00, 0, NULL, 0, 0, 0, '', 0, 0, 1, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (17, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', '小蛋糕', '小蛋糕商品', '小蛋糕', '', NULL, '11', 0.01, 0.00, 1.00, 0.00, '个', 0, 85, 455, 1, 0, 0, 0, 1, '<p>小蛋糕</p>', '1', '2023-06-10 11:40:05', '2023-09-14 17:24:44', '1', 0, b'0', 0, 10.00, 1.00, 0, NULL, 0, 0, 0, '', 0, 38, 1, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (18, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '1', '', '11', '', NULL, '11', 2.00, 0.00, 11.00, 0.00, '', 0, 4, 7, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 17:03:35', '2023-10-13 17:03:35', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (19, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '1111', '', '11', '', NULL, '11', 2.00, 0.00, 11.00, 0.00, '', 0, 0, 11, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 17:04:04', '2023-10-13 17:04:04', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (20, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '2222', '', '11', '', NULL, '11', 2.00, 0.00, 11.00, 0.00, '', 0, 0, 11, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 17:04:26', '2023-10-13 17:04:26', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (21, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '4444', '', '11', '', NULL, '4', 2.00, 0.00, 11.00, 0.00, '', 0, 0, 11, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 17:29:08', '2023-10-13 17:29:08', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (22, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '5555', '', '11', '', NULL, '1', 2.00, 0.00, 11.00, 0.00, '', 0, 3, 8, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 17:29:21', '2023-10-13 17:29:21', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (23, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '6666', '', '11', '', NULL, '1', 2.00, 0.00, 11.00, 0.00, '', 0, 0, 11, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 18:15:14', '2023-10-13 18:15:14', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (24, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '7777', '', '11', '', NULL, '4', 2.00, 0.00, 11.00, 0.00, '', 0, 0, 11, 1, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 18:15:29', '2023-10-13 18:15:29', '1', 0, b'0', 0, 0.00, 11.00, 0, NULL, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);
INSERT INTO `yshop_store_product` VALUES (25, 2, '意向餐饮店', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '8888', '', '11', '', NULL, '4', 1.00, 0.00, 0.00, 0.00, '', 0, 0, 12, 0, 0, 0, 0, 0, '<p>11</p>', '1', '2023-10-13 18:15:39', '2024-05-08 15:26:01', '1', 0, b'0', 0, 0.00, 0.00, 0, NULL, 0, 0, 0, '', 0, 0, 1, 0, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_attr
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_attr`;
CREATE TABLE `yshop_store_product_attr` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `attr_name` varchar(32) NOT NULL COMMENT '属性名',
  `attr_values` varchar(256) NOT NULL COMMENT '属性值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `store_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性表';

-- ----------------------------
-- Records of yshop_store_product_attr
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr` VALUES (92, 17, '体积', '10ml,30ml');
INSERT INTO `yshop_store_product_attr` VALUES (93, 16, '口味', '微辣,特辣');
INSERT INTO `yshop_store_product_attr` VALUES (94, 16, '份量', '1人,3人');
INSERT INTO `yshop_store_product_attr` VALUES (95, 15, '体积', '10ml,30ml');
INSERT INTO `yshop_store_product_attr` VALUES (96, 18, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (97, 19, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (98, 20, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (99, 21, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (100, 22, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (101, 23, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (102, 24, '规格', '默认');
INSERT INTO `yshop_store_product_attr` VALUES (111, 25, '体积', '90');
INSERT INTO `yshop_store_product_attr` VALUES (112, 25, '颜色', '黑色,白色');
INSERT INTO `yshop_store_product_attr` VALUES (113, 25, '尺寸', '55,77');
INSERT INTO `yshop_store_product_attr` VALUES (114, 25, '口味', '11,22,33');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_attr_result
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_attr_result`;
CREATE TABLE `yshop_store_product_attr_result` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `result` text NOT NULL COMMENT '商品属性参数',
  `change_time` datetime NOT NULL COMMENT '上次修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性详情表';

-- ----------------------------
-- Records of yshop_store_product_attr_result
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr_result` VALUES (61, 14, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":3.0,\"pic\":\"\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":3,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-05-30 10:43:52');
INSERT INTO `yshop_store_product_attr_result` VALUES (72, 17, '{\"attr\":[{\"detail\":[\"10ml\",\"30ml\"],\"value\":\"体积\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":1.0,\"detail\":{\"体积\":\"10ml\"},\"integral\":0,\"otPrice\":1.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.01,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":199,\"value1\":\"10ml\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":1.0,\"detail\":{\"体积\":\"30ml\"},\"integral\":0,\"otPrice\":1.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.02,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":300,\"value1\":\"30ml\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-09-14 17:24:44');
INSERT INTO `yshop_store_product_attr_result` VALUES (73, 16, '{\"attr\":[{\"detail\":[\"微辣\",\"特辣\"],\"value\":\"口味\"},{\"detail\":[\"1人\",\"3人\"],\"value\":\"份量\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":1.0,\"detail\":{\"口味\":\"微辣\",\"份量\":\"1人\"},\"integral\":0,\"otPrice\":1.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.03,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":996,\"value1\":\"微辣\",\"value2\":\"1人\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":1.0,\"detail\":{\"口味\":\"微辣\",\"份量\":\"3人\"},\"integral\":0,\"otPrice\":2.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.02,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":994,\"value1\":\"微辣\",\"value2\":\"3人\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":3.0,\"detail\":{\"口味\":\"特辣\",\"份量\":\"1人\"},\"integral\":0,\"otPrice\":4.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.04,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":666,\"value1\":\"特辣\",\"value2\":\"1人\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":4.0,\"detail\":{\"口味\":\"特辣\",\"份量\":\"3人\"},\"integral\":0,\"otPrice\":6.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.01,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":777,\"value1\":\"特辣\",\"value2\":\"3人\",\"volume\":0.0,\"weight\":0.0}]}', '2023-09-14 17:27:24');
INSERT INTO `yshop_store_product_attr_result` VALUES (74, 15, '{\"attr\":[{\"detail\":[\"10ml\",\"30ml\"],\"value\":\"体积\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":1.0,\"detail\":{\"体积\":\"10ml\"},\"integral\":0,\"otPrice\":2.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.01,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":996,\"value1\":\"10ml\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":3.0,\"detail\":{\"体积\":\"30ml\"},\"integral\":0,\"otPrice\":6.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":0.05,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":997,\"value1\":\"30ml\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-09-14 17:28:33');
INSERT INTO `yshop_store_product_attr_result` VALUES (75, 18, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 17:03:35');
INSERT INTO `yshop_store_product_attr_result` VALUES (76, 19, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 17:04:05');
INSERT INTO `yshop_store_product_attr_result` VALUES (77, 20, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 17:04:26');
INSERT INTO `yshop_store_product_attr_result` VALUES (78, 21, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 17:29:08');
INSERT INTO `yshop_store_product_attr_result` VALUES (79, 22, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 17:29:22');
INSERT INTO `yshop_store_product_attr_result` VALUES (80, 23, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 18:15:14');
INSERT INTO `yshop_store_product_attr_result` VALUES (81, 24, '{\"attr\":[{\"attrHidden\":\"\",\"detail\":[\"默认\"],\"detailValue\":\"\",\"value\":\"规格\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":11.0,\"detail\":{\"规格\":\"默认\"},\"integral\":0,\"otPrice\":11.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":2.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":11,\"value1\":\"规格\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2023-10-13 18:15:29');
INSERT INTO `yshop_store_product_attr_result` VALUES (85, 25, '{\"attr\":[{\"detail\":[\"90\"],\"value\":\"体积\"},{\"detail\":[\"黑色\",\"白色\"],\"value\":\"颜色\"},{\"detail\":[\"55\",\"77\"],\"value\":\"尺寸\"},{\"detail\":[\"11\",\"22\",\"33\"],\"value\":\"口味\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"55\",\"口味\":\"11\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"55\",\"口味\":\"22\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"55\",\"口味\":\"33\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"77\",\"口味\":\"11\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"77\",\"口味\":\"22\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"黑色\",\"尺寸\":\"77\",\"口味\":\"33\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"黑色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"55\",\"口味\":\"11\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"55\",\"口味\":\"22\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"55\",\"口味\":\"33\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"77\",\"口味\":\"11\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"77\",\"口味\":\"22\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"体积\":\"90\",\"颜色\":\"白色\",\"尺寸\":\"77\",\"口味\":\"33\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\"https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"\",\"stock\":1,\"value1\":\"90\",\"value2\":\"白色\",\"volume\":0.0,\"weight\":0.0}]}', '2024-05-08 15:26:01');
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_attr_value`;
CREATE TABLE `yshop_store_product_attr_value` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `sku` varchar(128) NOT NULL COMMENT '商品属性索引值 (attr_value|attr_value[|....])',
  `stock` int unsigned NOT NULL COMMENT '属性对应的库存',
  `sales` int unsigned DEFAULT '0' COMMENT '销量',
  `price` decimal(8,2) unsigned NOT NULL COMMENT '属性金额',
  `image` varchar(128) DEFAULT NULL COMMENT '图片',
  `unique` varchar(100) NOT NULL DEFAULT '' COMMENT '唯一值',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `bar_code` varchar(255) DEFAULT NULL COMMENT '商品条码',
  `ot_price` decimal(10,2) DEFAULT '0.00' COMMENT '原价',
  `weight` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `volume` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '体积',
  `brokerage` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '一级返佣',
  `brokerage_two` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '二级返佣',
  `pink_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '拼团价',
  `pink_stock` int NOT NULL DEFAULT '0' COMMENT '拼团库存',
  `seckill_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '秒杀价',
  `seckill_stock` int NOT NULL DEFAULT '0' COMMENT '秒杀库存',
  `integral` int(10) unsigned zerofill DEFAULT '0000000000' COMMENT '需要多少积分兑换',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`,`sku`) USING BTREE,
  KEY `store_id` (`product_id`,`sku`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性值表';

-- ----------------------------
-- Records of yshop_store_product_attr_value
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr_value` VALUES (140, 17, '10ml', 156, 43, 0.01, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 'c0cc998c37e7494790c8b7159688f3c9', 1.00, '', 1.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (141, 17, '30ml', 299, 1, 0.02, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/576916bb4464e69d58c7b13745d84492c051c98c301ceff6f80ffbf11f73d65e.jpg', 'cef371f49b2b4e76872408a682fed307', 1.00, '', 1.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (142, 16, '1人,微辣', 996, 0, 0.03, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '63243603ac97487aae6623911fd22644', 1.00, '', 1.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (143, 16, '3人,微辣', 994, 0, 0.02, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '7a92701d93564665a6a74905f9ebe3d7', 1.00, '', 2.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (144, 16, '1人,特辣', 666, 0, 0.04, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '45f52550c25240f7a43fc8dae0cf5cfa', 3.00, '', 4.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (145, 16, '3人,特辣', 775, 2, 0.01, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '9a27b489220e4a7e9c8b5e3266e7d365', 4.00, '', 6.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (146, 15, '10ml', 992, 4, 0.01, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '917d95d36ed244be8c12333acce47b4a', 1.00, '', 2.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (147, 15, '30ml', 997, 0, 0.05, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '917ceaa8df1149f5984e18586b88bfd0', 3.00, '', 6.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (148, 18, '默认', 7, 4, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '11ff495a46834401af634bc0d78a46e7', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (149, 19, '默认', 11, 0, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '4b0320e229584f3886d99de917895bc6', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (150, 20, '默认', 11, 0, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'b6217da317314ee29f2ec3f6f776725c', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (151, 21, '默认', 11, 0, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '0eb397ff5a114304a51ac9cd05ecd01c', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (152, 22, '默认', 8, 3, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '40800b8d9a6c4ea7bbbdff8ea0d7cd1b', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (153, 23, '默认', 11, 0, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '6d4b575fe1024da18e1a5fd27407ef0a', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (154, 24, '默认', 11, 0, 2.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'b842b87c382548f8b6a244ad62dfb07a', 11.00, '', 11.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (188, 25, '11,55,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '3810fcde310c475eb029ec3ffc41f0ba', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (189, 25, '22,55,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'c753b24fda59487b92523618e4fa1cb2', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (190, 25, '33,55,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'e711333d77194f0dadf9679c012758f9', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (191, 25, '11,77,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '0e031b57116d45a0b937671869b569dd', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (192, 25, '22,77,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '468e7626881944c7a59fc7b856fec7ad', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (193, 25, '33,77,90,黑色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '49623e1852194ec68351fd9d3b489ce7', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (194, 25, '11,55,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'e476a3f341994fce85503a689c248067', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (195, 25, '22,55,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '3bda2da4d7cf46a28c42aca77fd00d78', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (196, 25, '33,55,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'f7d2432e774f48e1bed67cd373290247', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (197, 25, '11,77,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', 'ba479862524a41cdbe032b1330c67ca4', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (198, 25, '22,77,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '0614f36a1fff405bbe849ab9d117d7f2', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (199, 25, '33,77,90,白色', 1, 0, 1.00, 'https://apidc.yixiang.co/admin-api/infra/file/4/get/00b7dec2e349fcfe5a83c5dbba74a52217e5ba669049ca46f716f044c40a6939.jpg', '207ffe0bfcbc41d18ec74120a1805b37', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_brand
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_brand`;
CREATE TABLE `yshop_store_product_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌名称',
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌图片',
  `sort` int DEFAULT '0' COMMENT '品牌排序',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '品牌描述',
  `status` tinyint NOT NULL COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品品牌';

-- ----------------------------
-- Records of yshop_store_product_brand
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_brand` VALUES (1, '苹果', 'https://app2.yixiang.co/file/pic/20210222221033953795.jpeg', 0, '是上市', 0, '1', '2022-07-30 22:12:18', '1', '2023-07-24 10:10:58', b'1', 1);
INSERT INTO `yshop_store_product_brand` VALUES (2, '2', 'http://127.0.0.1:48080/admin-api/infra/file/4/get/e8b3ca5e5519e3b66768c2437744b072ed1bea09b7b7625d72ac4ac7eb70358b.jpeg', 2, '', 0, '1', '2023-05-29 13:54:40', '1', '2023-05-29 13:54:40', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_category
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_category`;
CREATE TABLE `yshop_store_product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `shop_id` int DEFAULT NULL COMMENT '店铺id用''',
  `parent_id` bigint DEFAULT '0' COMMENT '父分类编号',
  `shop_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '店铺名称',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类图片',
  `sort` int DEFAULT '0' COMMENT '分类排序',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类描述',
  `status` tinyint NOT NULL COMMENT '开启状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类';

-- ----------------------------
-- Records of yshop_store_product_category
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_category` VALUES (1, 2, 0, '意向餐饮店', '饮料', 'http://127.0.0.1:48081/admin-api/infra/file/4/get/5942d0091c32ecab3e1dc3f8abbfc15efa79cfaa39986e7955af4c1a6aecb834.png', 1, '1234', 0, '1', '2022-07-30 16:36:35', '1', '2023-09-05 16:26:45', b'0', 1);
INSERT INTO `yshop_store_product_category` VALUES (4, 2, 0, '意向餐饮店', '主食', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/dcc749871b119ca807154adccd7cb5923d5f182ccfa85c36b269e0cd6a278e54.png', 2, '<p>123</p>', 0, '1', '2022-07-30 16:40:00', '1', '2023-09-14 16:51:38', b'0', 1);
INSERT INTO `yshop_store_product_category` VALUES (11, 2, 0, '意向餐饮店', '甜点', ' http://localhost:48081/admin-api/infra/file/4/get/6f981164076d5069b11f78a9c4b27818570e54ff04fced577b224e204b998457.png', 1, '', 0, '1', '2023-08-15 13:02:48', '1', '2024-06-01 14:23:35', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_relation
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_relation`;
CREATE TABLE `yshop_store_product_relation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` bigint unsigned NOT NULL COMMENT '用户ID',
  `product_id` bigint unsigned NOT NULL COMMENT '商品ID',
  `type` varchar(32) DEFAULT NULL COMMENT '类型(收藏(collect）、点赞(like))',
  `category` varchar(32) DEFAULT NULL COMMENT '某种类型的商品(普通商品、秒杀商品)',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uid` (`uid`,`product_id`,`type`,`category`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `category` (`category`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品点赞和收藏表';

-- ----------------------------
-- Records of yshop_store_product_relation
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_relation` VALUES (2, 2, 15, 'collect', 'common', '2', '2023-06-15 11:52:41', '2023-06-15 12:01:08', '2', b'0', NULL);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_reply
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_reply`;
CREATE TABLE `yshop_store_product_reply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `uid` bigint NOT NULL COMMENT '用户ID',
  `oid` bigint NOT NULL COMMENT '订单ID',
  `unique` char(32) NOT NULL COMMENT '唯一id',
  `product_id` bigint NOT NULL COMMENT '产品id',
  `reply_type` varchar(32) NOT NULL DEFAULT 'product' COMMENT '某种商品类型(普通商品、秒杀商品）',
  `product_score` tinyint(1) NOT NULL COMMENT '商品分数',
  `service_score` tinyint(1) NOT NULL COMMENT '服务分数',
  `comment` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `pics` text NOT NULL COMMENT '评论图片',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '评论时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `merchant_reply_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理员回复内容',
  `merchant_reply_time` datetime DEFAULT NULL COMMENT '管理员回复时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '0未删除1已删除',
  `is_reply` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0未回复1已回复',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `parent_id` (`reply_type`) USING BTREE,
  KEY `is_del` (`deleted`) USING BTREE,
  KEY `product_score` (`product_score`) USING BTREE,
  KEY `service_score` (`service_score`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='评论表';

-- ----------------------------
-- Records of yshop_store_product_reply
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_reply` VALUES (4, 2, 4, 'b1255a14d97748f396664968f45f68e6', 16, 'product', 5, 5, '评价', 'http://dummyimage.com/400x400', '2', '2023-06-28 17:11:06', '2023-06-29 18:38:36', '1', '666', NULL, b'0', 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_product_rule
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_product_rule`;
CREATE TABLE `yshop_store_product_rule` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `rule_name` varchar(32) NOT NULL COMMENT '规格名称',
  `rule_value` json NOT NULL COMMENT '规格值',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品规则值(规格)表';

-- ----------------------------
-- Records of yshop_store_product_rule
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_rule` VALUES (25, '饮料', '[{\"value\": \"体积\", \"detail\": [\"90\"]}, {\"value\": \"颜色\", \"detail\": [\"黑色\", \"白色\"]}, {\"value\": \"尺寸\", \"detail\": [\"55\", \"77\"]}, {\"value\": \"口味\", \"detail\": [\"11\", \"22\", \"33\"]}]', '2023-05-18 10:23:12', '1', '2024-05-08 15:25:05', '1', b'0', 0);
INSERT INTO `yshop_store_product_rule` VALUES (26, '主食', '[{\"value\": \"口味\", \"detail\": [\"微辣\", \"特辣\"]}, {\"value\": \"份量\", \"detail\": [\"1人\", \"3人\"]}, {\"value\": \"颜色\", \"detail\": [\"黑\"]}]', '2023-05-19 18:21:12', '1', '2024-03-26 15:34:17', '1', b'0', 0);
INSERT INTO `yshop_store_product_rule` VALUES (27, '1', '[{\"value\": \"2\", \"detail\": [\"2\"]}]', '2023-05-19 18:22:41', '1', '2023-05-19 18:22:41', '1', b'1', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_store_shop
-- ----------------------------
DROP TABLE IF EXISTS `yshop_store_shop`;
CREATE TABLE `yshop_store_shop` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺名称',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺电话',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '多张图片',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址',
  `address_map` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地图定位地址',
  `start_time` datetime NOT NULL COMMENT '营业开始时间',
  `end_time` datetime NOT NULL COMMENT '营业结束时间',
  `lng` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '经度',
  `lat` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '纬度',
  `distance` int NOT NULL DEFAULT '0' COMMENT '外卖配送距离,单位为千米。0表示不送外卖',
  `min_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '起送价钱',
  `delivery_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送价格',
  `notice` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '公告',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否营业:0=否,1=是',
  `admin_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '管理员id',
  `uniprint_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '打印机id',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='门店管理';

-- ----------------------------
-- Records of yshop_store_shop
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_shop` VALUES (2, '意向餐饮店', '18000000000', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', '源汇区人民东路', '河南省漯河市源汇区团结路50号-20', '2023-08-19 09:00:00', '2023-08-19 23:00:00', '114.04877877439665', '33.57093831826829', 10, 10.00, 20.00, '新店开张', 1, '126', '1', '2023-08-06 11:48:43', '2023-09-14 17:30:59', '1', '1', b'0');
INSERT INTO `yshop_store_shop` VALUES (3, 'yshop', '18000000000', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/44723283500f656cdd5906e13f2997cb292d17f516065ff4b3b38f9810bce4cb.jpg', '67号', '北京市东城区', '2023-08-06 13:35:02', '2023-08-06 15:35:02', '116.40403593222032', '39.91643892263258', 0, 1.00, 2.00, '2222', 1, '100', '2', '2023-08-06 13:14:53', '2024-03-26 15:42:20', '1', '1', b'0');
COMMIT;

-- ----------------------------
-- Table structure for yshop_user
-- ----------------------------
DROP TABLE IF EXISTS `yshop_user`;
CREATE TABLE `yshop_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户账户(跟accout一样)',
  `password` varchar(255) DEFAULT NULL COMMENT '用户密码（跟pwd）',
  `real_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '真实姓名',
  `birthday` varchar(100) DEFAULT '' COMMENT '生日',
  `card_id` varchar(20) DEFAULT '' COMMENT '身份证号码',
  `mark` varchar(255) DEFAULT '' COMMENT '用户备注',
  `partner_id` int DEFAULT '0' COMMENT '合伙人id',
  `group_id` int DEFAULT '0' COMMENT '用户分组id',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(256) DEFAULT NULL COMMENT '用户头像',
  `mobile` char(15) DEFAULT NULL COMMENT '手机号码',
  `login_date` datetime DEFAULT NULL,
  `login_ip` varchar(255) DEFAULT NULL,
  `register_ip` varchar(255) DEFAULT NULL COMMENT '注册ip',
  `add_ip` varchar(100) DEFAULT '' COMMENT '添加ip',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '最后一次登录时间',
  `last_ip` varchar(100) DEFAULT '' COMMENT '最后一次登录ip',
  `now_money` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户余额',
  `brokerage_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '佣金金额',
  `integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户剩余积分',
  `sign_num` int NOT NULL DEFAULT '0' COMMENT '连续签到天数',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1为正常，0为禁止',
  `level` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `spread_uid` bigint unsigned DEFAULT '0' COMMENT '推广元id',
  `spread_time` datetime DEFAULT NULL COMMENT '推广员关联时间',
  `user_type` varchar(32) NOT NULL DEFAULT '' COMMENT '用户类型',
  `is_promoter` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否为推广员',
  `pay_count` int unsigned DEFAULT '0' COMMENT '用户购买次数',
  `spread_count` int DEFAULT '0' COMMENT '下级人数',
  `addres` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `adminid` int unsigned DEFAULT '0' COMMENT '管理员编号 ',
  `login_type` varchar(36) NOT NULL DEFAULT '' COMMENT '用户登陆类型，h5,wechat,routine',
  `wx_profile` json DEFAULT NULL COMMENT '微信用户json信息',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号',
  `openid` varchar(100) DEFAULT NULL COMMENT '公众号openid',
  `routine_openid` varchar(100) DEFAULT NULL COMMENT '小程序openid',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别0-男1-女',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `spreaduid` (`spread_uid`) USING BTREE,
  KEY `level` (`level`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_promoter` (`is_promoter`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户表';

-- ----------------------------
-- Records of yshop_user
-- ----------------------------
BEGIN;
INSERT INTO `yshop_user` VALUES (9, '15136175246', '', '', '', '', '', 0, 0, 'yshop用户_9', NULL, '151****5246', '2024-06-01 16:21:37', '0:0:0:0:0:0:0:1', '0:0:0:0:0:0:0:1', '', NULL, '2023-11-07 17:17:45', '9', '2024-06-01 16:21:37', '', 91.87, 0.00, 9980.00, 0, 0, 0, 0, NULL, '', 0, 19, 0, '', 0, 'routine', NULL, b'0', NULL, NULL, 'oHux265Iu9R5pMKk1O3U_J6TtMC4', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_user_address
-- ----------------------------
DROP TABLE IF EXISTS `yshop_user_address`;
CREATE TABLE `yshop_user_address` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户地址id',
  `uid` bigint unsigned NOT NULL COMMENT '用户id',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `address` varchar(500) DEFAULT NULL COMMENT '地址',
  `phone` varchar(16) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `province` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在省',
  `city` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在市',
  `city_id` int DEFAULT NULL COMMENT '城市id',
  `district` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在区',
  `detail` varchar(256) NOT NULL DEFAULT '' COMMENT '收货人详细地址',
  `post_code` varchar(20) NOT NULL DEFAULT '' COMMENT '邮编',
  `longitude` varchar(50) NOT NULL DEFAULT '0' COMMENT '经度',
  `latitude` varchar(50) NOT NULL DEFAULT '0' COMMENT '纬度',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否默认',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `is_default` (`is_default`) USING BTREE,
  KEY `is_del` (`deleted`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户地址表';

-- ----------------------------
-- Records of yshop_user_address
-- ----------------------------
BEGIN;
INSERT INTO `yshop_user_address` VALUES (1, 2, '胡萝卜', '河南省漯河市源汇区交通路602号附近 富豪花园', '15136175212', '', '', NULL, '', '86号', '', '114.03841284847353', '33.5607274581116', 0, b'0', '2', '2023-09-18 11:36:10', '2023-09-18 11:36:10', NULL, '2');
INSERT INTO `yshop_user_address` VALUES (2, 2, 'hu', '河南省漯河市源汇区 大刘镇', '18000000000', '', '', NULL, '', '88888', '', '113.9202', '33.54528', 0, b'0', '2', '2023-11-02 17:41:44', '2023-11-02 17:41:44', NULL, '2');
INSERT INTO `yshop_user_address` VALUES (3, 9, 'hupeng', '河南省漯河市源汇区 源汇区河南众肯餐饮服务有限公司', '18888888888', '', '', NULL, '', '520号', '', '113.9202', '33.54528', 0, b'0', '9', '2023-11-29 15:45:59', '2023-11-29 15:45:59', NULL, '9');
COMMIT;

-- ----------------------------
-- Table structure for yshop_user_bill
-- ----------------------------
DROP TABLE IF EXISTS `yshop_user_bill`;
CREATE TABLE `yshop_user_bill` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户账单id',
  `uid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `link_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '关联id',
  `pm` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '账单标题',
  `category` varchar(64) NOT NULL DEFAULT '' COMMENT '明细种类',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '明细类型',
  `number` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '明细数字',
  `balance` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '剩余',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 = 带确定 1 = 有效 -1 = 无效',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号',
  `extend_field` varchar(255) DEFAULT '' COMMENT '扩展字段',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `openid` (`uid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `pm` (`pm`) USING BTREE,
  KEY `type` (`category`,`type`,`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户账单表';

-- ----------------------------
-- Records of yshop_user_bill
-- ----------------------------
BEGIN;
INSERT INTO `yshop_user_bill` VALUES (1, 2, '', 1, '系统增加余额', 'now_money', 'system_add', 10000.00, 10000.00, '系统增加了10000余额', '1', '2023-09-18 11:26:59', '2023-09-18 11:26:59', '1', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (2, 2, '', 1, '系统增加积分', 'now_money', 'system_add', 0.00, 0.00, '系统增加了0积分', '1', '2023-09-18 11:26:59', '2023-09-18 11:26:59', '1', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (3, 2, '0', 0, '购买商品', 'now_money', 'pay_product', 20.01, 9979.99, '余额支付20.01元购买商品', '2', '2023-09-18 11:36:33', '2023-09-18 11:36:33', '2', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (4, 2, '0', 0, '购买商品', 'now_money', 'pay_product', 20.01, 9959.98, '余额支付20.01元购买商品', '2', '2023-09-18 11:42:30', '2023-09-18 11:42:30', '2', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (5, 2, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 9959.97, '余额支付0.01元购买商品', '2', '2023-09-18 15:42:37', '2023-09-18 15:42:37', '2', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (6, 2, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 9959.97, '微信支付0.01元购买商品', NULL, '2023-09-18 15:49:11', '2023-09-18 15:49:11', NULL, 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (7, 2, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 9959.96, '余额支付0.01元购买商品', '2', '2023-10-07 11:57:37', '2023-10-07 11:57:37', '2', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (23, 9, '2', 1, '用户充值', 'now_money', 'recharge', 100.00, 100.00, '用户充值,金额100.00', '9', '2023-11-10 17:12:39', '2023-11-10 17:12:39', '9', 1, b'0', NULL, '1722905095160463360');
INSERT INTO `yshop_user_bill` VALUES (24, 9, '1', 1, '用户充值', 'now_money', 'recharge', 100.00, 200.00, '用户充值,金额100.00', '9', '2023-11-10 17:13:42', '2023-11-10 17:13:42', '9', 0, b'0', NULL, '1722905359481307136');
INSERT INTO `yshop_user_bill` VALUES (25, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.02, 99.98, '余额支付0.02元购买商品', '9', '2023-11-16 15:06:18', '2023-11-16 15:06:18', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (26, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 2.01, 97.97, '余额支付2.01元购买商品', '9', '2023-11-16 15:58:54', '2023-11-16 15:58:54', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (27, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.03, 97.94, '余额支付0.03元购买商品', '9', '2023-11-16 15:59:33', '2023-11-16 15:59:33', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (28, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 97.94, '微信支付0.01元购买商品', NULL, '2023-11-21 16:49:22', '2023-11-21 16:49:22', NULL, 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (29, 9, '37', 1, '商品退款', 'now_money', 'pay_product_refund', 0.01, 97.94, '订单退款到余额0.01元', '1', '2023-11-21 22:04:38', '2023-11-21 22:04:38', '1', 0, b'0', NULL, '1726964836241244160');
INSERT INTO `yshop_user_bill` VALUES (30, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 97.94, '微信支付0.01元购买商品', NULL, '2023-11-22 09:49:44', '2023-11-22 09:49:44', NULL, 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (31, 9, '38', 1, '商品退款', 'now_money', 'pay_product_refund', 0.01, 97.94, '订单退款到余额0.01元', '1', '2023-11-22 09:50:50', '2023-11-22 09:50:50', '1', 0, b'0', NULL, '1727142556682158080');
INSERT INTO `yshop_user_bill` VALUES (32, 9, '36', 1, '商品退款', 'now_money', 'pay_product_refund', 0.03, 97.94, '订单退款到余额0.03元', '1', '2023-11-22 09:56:32', '2023-11-22 09:56:32', '1', 0, b'0', NULL, '1727143993793314816');
INSERT INTO `yshop_user_bill` VALUES (33, 9, '', 1, '系统增加余额', 'now_money', 'system_add', 0.00, 97.97, '系统增加了0余额', '1', '2023-11-30 14:20:49', '2023-11-30 14:20:49', '1', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (34, 9, '', 1, '系统增加积分', 'now_money', 'system_add', 10000.00, 10000.00, '系统增加了10000积分', '1', '2023-11-30 14:20:49', '2023-11-30 14:20:49', '1', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (35, 9, '0', 0, '积分兑换', 'integral', 'pay_product', 10.00, 10000.00, '10积分兑换商品', '9', '2023-11-30 14:42:39', '2023-11-30 14:42:39', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (36, 9, '0', 0, '积分兑换', 'integral', 'pay_product', 10.00, 9990.00, '10积分兑换商品', '9', '2023-12-02 16:35:06', '2023-12-02 16:35:06', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (37, 9, '0', 0, '积分兑换', 'integral', 'pay_product', 10.00, 9980.00, '10积分兑换商品', '9', '2023-12-02 16:41:20', '2023-12-02 16:41:20', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (38, 9, '0', 0, '积分兑换', 'integral', 'pay_product', 10.00, 9970.00, '10积分兑换商品', '9', '2023-12-02 16:46:38', '2023-12-02 16:46:38', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (39, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 5.98, 91.99, '余额支付5.98元购买商品', '9', '2023-12-04 10:38:07', '2023-12-04 10:38:07', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (40, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.98, '余额支付0.01元购买商品', '9', '2023-12-04 10:52:27', '2023-12-04 10:52:27', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (41, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.97, '余额支付0.01元购买商品', '9', '2023-12-04 11:37:02', '2023-12-04 11:37:02', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (42, 9, '41', 1, '购买商品赠送积分', 'integral', 'gain', 10.00, 9970.00, '购买商品赠送10.00积分', '9', '2023-12-04 11:40:22', '2023-12-04 11:40:22', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (43, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.96, '余额支付0.01元购买商品', '9', '2024-06-01 14:57:37', '2024-06-01 14:57:37', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (44, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.95, '余额支付0.01元购买商品', '9', '2024-06-01 15:12:00', '2024-06-01 15:12:00', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (45, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.94, '余额支付0.01元购买商品', '9', '2024-06-01 15:37:01', '2024-06-01 15:37:01', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (46, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.93, '余额支付0.01元购买商品', '9', '2024-06-01 15:47:04', '2024-06-01 15:47:04', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (47, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.92, '余额支付0.01元购买商品', '9', '2024-06-01 15:49:16', '2024-06-01 15:49:16', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (48, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.91, '余额支付0.01元购买商品', '9', '2024-06-01 15:51:47', '2024-06-01 15:51:47', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (49, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.90, '余额支付0.01元购买商品', '9', '2024-06-01 15:54:09', '2024-06-01 15:54:09', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (50, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.89, '余额支付0.01元购买商品', '9', '2024-06-01 15:57:46', '2024-06-01 15:57:46', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (51, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.88, '余额支付0.01元购买商品', '9', '2024-06-01 16:11:15', '2024-06-01 16:11:15', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (52, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.87, '余额支付0.01元购买商品', '9', '2024-06-01 16:12:39', '2024-06-01 16:12:39', '9', 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (53, 9, '0', 0, '购买商品', 'now_money', 'pay_product', 0.01, 91.87, '微信支付0.01元购买商品', NULL, '2024-06-01 16:17:17', '2024-06-01 16:17:17', NULL, 1, b'0', NULL, '');
INSERT INTO `yshop_user_bill` VALUES (54, 9, '54', 1, '购买商品赠送积分', 'integral', 'gain', 10.00, 9980.00, '购买商品赠送10.00积分', '9', '2024-06-01 16:23:03', '2024-06-01 16:23:03', '9', 1, b'0', NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for yshop_wechat_template
-- ----------------------------
DROP TABLE IF EXISTS `yshop_wechat_template`;
CREATE TABLE `yshop_wechat_template` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '模板id',
  `tempkey` char(50) NOT NULL DEFAULT '' COMMENT '模板编号',
  `name` char(100) NOT NULL DEFAULT '' COMMENT '模板名',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '回复内容',
  `tempid` char(100) DEFAULT NULL COMMENT '模板ID',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) DEFAULT NULL COMMENT '更新者',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `type` varchar(30) DEFAULT NULL COMMENT '类型：template:模板消息 subscribe:订阅消息',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tempkey` (`tempkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='微信模板';

-- ----------------------------
-- Records of yshop_wechat_template
-- ----------------------------
BEGIN;
INSERT INTO `yshop_wechat_template` VALUES (16, 'pay_success', '订单支付成功通知', '', 'KBtfY9G1IWCzC6q-ZKo-Q-MmdP7aaF79nx0XFcBf3h4', '2023-07-25 10:41:17', '2023-09-11 15:35:56', '1', '1', 1, b'0', 'subscribe');
INSERT INTO `yshop_wechat_template` VALUES (17, 'pay_success', '订单支付成功通知', '', 'r6PWTcAOQodoyz0GT_0NCoFxssBT4ZB7AJqVdTdRvfA', '2023-07-25 10:43:14', '2023-07-25 10:43:14', '1', '1', 1, b'0', 'template');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
