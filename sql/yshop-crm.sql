/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : localhost:3306
 Source Schema         : yshop-crm

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 14/09/2024 09:05:56
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
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '响应结果',
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
) ENGINE=InnoDB AUTO_INCREMENT=1622 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统异常日志';

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
  `auto_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '是否自增',
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
) ENGINE=InnoDB AUTO_INCREMENT=2894 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表字段定义';

-- ----------------------------
-- Records of infra_codegen_column
-- ----------------------------
BEGIN;
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成表定义';

-- ----------------------------
-- Records of infra_codegen_table
-- ----------------------------
BEGIN;
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
) ENGINE=InnoDB AUTO_INCREMENT=1019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件表';

-- ----------------------------
-- Records of infra_file
-- ----------------------------
BEGIN;
INSERT INTO `infra_file` VALUES (1018, 4, 'WX20240827-154350@2x.png', '26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', 'image/png', 531470, '1', '2024-08-27 16:59:32', '1', '2024-08-27 16:59:32', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件表';

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务表';

-- ----------------------------
-- Records of infra_job
-- ----------------------------
BEGIN;
INSERT INTO `infra_job` VALUES (5, '支付通知 Job', 2, 'payNotifyJob', NULL, '* * * * * ?', 0, 0, 0, '1', '2021-10-27 08:34:42', '1', '2023-07-27 18:45:48', b'1');
INSERT INTO `infra_job` VALUES (16, 'Job 示例', 2, 'demoJob', NULL, '* * * L * ?', 1, 1, 0, '1', '2022-09-24 22:31:41', '1', '2023-06-29 13:35:02', b'0');
INSERT INTO `infra_job` VALUES (17, '每日店铺收入结算任务', 2, 'revenueJob', '', '0 * * * * ?', 1, 1, 0, '1', '2024-03-08 10:34:44', '1', '2024-03-30 14:58:36', b'1');
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
) ENGINE=InnoDB AUTO_INCREMENT=169121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务日志表';

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
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`details_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='支付服务商配置';

-- ----------------------------
-- Records of merchant_details
-- ----------------------------
BEGIN;
INSERT INTO `merchant_details` VALUES ('ali_app1', 'aliPay', '2021001187645179', ' 2088821836348568', NULL, 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNAg588CxTezsPtMT4WcLXUyzyf0qBnzSACek820D4RLdJ0KiOfQzAe3MK1rEaywwWNMJbwrKoEp/bA6DNTRsXvzZ8tF1F5MXi6GdETn3ItHGdwasJM28hvZX2plYY5aQYEpqGZJBlgfQRkeYSe1pwq4JzAELXNzVbtuokssVq3WKVVIIFXEuHxrsC1SGssn0enFd7Q6kUq1O1JLcAQWAHjf9gdVFfzXex0yN6EYGRqWlr8AC5lIr0STKmNIZeCV4WlsEah9askpAyNrlKBGy0lwdfeMQVtJo3WucM9DE2dqePN5RZIECvvYWdMjmAilomx+7di72PnmAGkkHbmosDAgMBAAECggEAMisaJn949daxQ7xIHCgrd1rDch+xzX5sOmXMUvebHPmt0JhpcBCzucPyQVfzORom2bu5rtYNpFjEATNAQer+CavhYer2CIkFkt6m5xmaDQ+OINen16UyE+oU8eVqWn9Rq7LqwYgEC+l5gcrL9aVnnxCWX/4mydV9qXzhv17PeF5yqEIjrAbhQMQbVrPLQTwi3wbC7sm6Z29A5idhld4AsXjlWPXnFzkeZFl8Qc/g5QOHFjs8uIcz+K7uE3H9Gs2LSz07bh0m9jloy/90Q0OzZbPI1NIU3oDTV7/eaRldXw3o9+8uz58MDWhYoWTLLjlkWJZJcJrfnW+P7tDEWpjv2QKBgQDyCZ0dzcz9w4IN5ujOWdplNv3M/MwSb0mGCnHv3tfnvJj4GnTmeIIWic8RhSlyN12Ph+wYaBHTEc+zaXKq5FmnEtKMPXzVci9RbCECTt5M8eYEA4wuYKnAGqPsyzvnffxGAUdvalVmkyRidI/cj+ACDmWjqnsalF9Hd2mMcrhqtQKBgQCVJHL1nJKSjgFqwN80tqlz862rsFaHOsSDT89nPHgTsmr30QFk6FL+BU/wrPsXCg5pMVZtUmw3c8X1TXd9YCnu7wg2+obIUbbXBxQTdhJMq/DUL6hGsfBLkzLzs9moyL76c4gZFqXr/d/POevzIlnATFolnoDOzoEvp7YsMyBZ1wKBgHVJb1eX+PQnn4g5EyuboxdVFJwXDJUKVKiduySv6hQj8kSYHXnpf7CIS02EJ9dvOOlqxl/1Xl3Xzbx1JtnlGgS6PEk1Kp8MXB2qtjw2F8dVmU7soSuAMAIlZrZCrd650FvkFsfI0WWJfCIxtdz942FbtKkg3dK9f4ZUOVOT7AXZAoGAQbsyv3UmVFkp3rbqqPzoaiY3oLezKx6HhagjLMjF00iLRHVlO+f4y+Pje5uBfoH8H/iSstPkxfvMf3SI+UTstlW7NR/tT1RUVSjVfE5Jemk9Vwc6Dw5VbbmOd0II6A6xvQg2L3h/4CagAWDx0NKO4+XCxVm6Q2tYHHy6GXjfBTkCgYEA2x+2PAq8iqX80cLqvh7vSoCh5m6H3aSGM8h+ZgF0lkijavQyIXE0oJxuJUpqgzv/XKqUCVQbaEHuNqKczLr0+QEE+vmexaRqKiUAL4/5xLEjfKk96QE7WbjXypJVBT5KeFPc5JDkNZN/R6d8q2/o4hiNdCyg+S4l/YOOev6YWDY=', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj4e+D+2LfhldbNImCtjGbsxNQiQe6zp0SwS0iywib4pEqwS0gVDUi11uaG4R78cm7kV0GwWuYbeyl3wLmsr9269HJ/FjwWrNJLLwCLqJzNSkBssW7TXge++X3uHK93VeYmu7lRxdk5G/CqOdp5IhqveQOLxHURm+AC9iLtdtxnaCXFxcb54O63mfuZ5/9XJfBRt0boTe8vWTnr8w95PG5XlCBK0lmfZvtUazn/RYBIeCV28bwusQURvAg0Kc/gBoa3wIWiZhzaAiklUaXWoqR+yuoBwzKht8TLkXaOVxswphSoxsddrsn28Fw6rDfRiMKk3S6JcwY58P1n2By+LUPQIDAQAB', NULL, NULL, 'http://localhost:48081/app-api/order/payBack6.json', 'http://localhost:8080/#/pages/mine/mine', 'RSA2', ' 2088821836348568', NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2023-11-09 16:22:23', b'1', 1);
INSERT INTO `merchant_details` VALUES ('ali_h51', 'aliPay', '2021001187645179', ' 2088821836348568', NULL, 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNAg588CxTezsPtMT4WcLXUyzyf0qBnzSACek820D4RLdJ0KiOfQzAe3MK1rEaywwWNMJbwrKoEp/bA6DNTRsXvzZ8tF1F5MXi6GdETn3ItHGdwasJM28hvZX2plYY5aQYEpqGZJBlgfQRkeYSe1pwq4JzAELXNzVbtuokssVq3WKVVIIFXEuHxrsC1SGssn0enFd7Q6kUq1O1JLcAQWAHjf9gdVFfzXex0yN6EYGRqWlr8AC5lIr0STKmNIZeCV4WlsEah9askpAyNrlKBGy0lwdfeMQVtJo3WucM9DE2dqePN5RZIECvvYWdMjmAilomx+7di72PnmAGkkHbmosDAgMBAAECggEAMisaJn949daxQ7xIHCgrd1rDch+xzX5sOmXMUvebHPmt0JhpcBCzucPyQVfzORom2bu5rtYNpFjEATNAQer+CavhYer2CIkFkt6m5xmaDQ+OINen16UyE+oU8eVqWn9Rq7LqwYgEC+l5gcrL9aVnnxCWX/4mydV9qXzhv17PeF5yqEIjrAbhQMQbVrPLQTwi3wbC7sm6Z29A5idhld4AsXjlWPXnFzkeZFl8Qc/g5QOHFjs8uIcz+K7uE3H9Gs2LSz07bh0m9jloy/90Q0OzZbPI1NIU3oDTV7/eaRldXw3o9+8uz58MDWhYoWTLLjlkWJZJcJrfnW+P7tDEWpjv2QKBgQDyCZ0dzcz9w4IN5ujOWdplNv3M/MwSb0mGCnHv3tfnvJj4GnTmeIIWic8RhSlyN12Ph+wYaBHTEc+zaXKq5FmnEtKMPXzVci9RbCECTt5M8eYEA4wuYKnAGqPsyzvnffxGAUdvalVmkyRidI/cj+ACDmWjqnsalF9Hd2mMcrhqtQKBgQCVJHL1nJKSjgFqwN80tqlz862rsFaHOsSDT89nPHgTsmr30QFk6FL+BU/wrPsXCg5pMVZtUmw3c8X1TXd9YCnu7wg2+obIUbbXBxQTdhJMq/DUL6hGsfBLkzLzs9moyL76c4gZFqXr/d/POevzIlnATFolnoDOzoEvp7YsMyBZ1wKBgHVJb1eX+PQnn4g5EyuboxdVFJwXDJUKVKiduySv6hQj8kSYHXnpf7CIS02EJ9dvOOlqxl/1Xl3Xzbx1JtnlGgS6PEk1Kp8MXB2qtjw2F8dVmU7soSuAMAIlZrZCrd650FvkFsfI0WWJfCIxtdz942FbtKkg3dK9f4ZUOVOT7AXZAoGAQbsyv3UmVFkp3rbqqPzoaiY3oLezKx6HhagjLMjF00iLRHVlO+f4y+Pje5uBfoH8H/iSstPkxfvMf3SI+UTstlW7NR/tT1RUVSjVfE5Jemk9Vwc6Dw5VbbmOd0II6A6xvQg2L3h/4CagAWDx0NKO4+XCxVm6Q2tYHHy6GXjfBTkCgYEA2x+2PAq8iqX80cLqvh7vSoCh5m6H3aSGM8h+ZgF0lkijavQyIXE0oJxuJUpqgzv/XKqUCVQbaEHuNqKczLr0+QEE+vmexaRqKiUAL4/5xLEjfKk96QE7WbjXypJVBT5KeFPc5JDkNZN/R6d8q2/o4hiNdCyg+S4l/YOOev6YWDY=', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj4e+D+2LfhldbNImCtjGbsxNQiQe6zp0SwS0iywib4pEqwS0gVDUi11uaG4R78cm7kV0GwWuYbeyl3wLmsr9269HJ/FjwWrNJLLwCLqJzNSkBssW7TXge++X3uHK93VeYmu7lRxdk5G/CqOdp5IhqveQOLxHURm+AC9iLtdtxnaCXFxcb54O63mfuZ5/9XJfBRt0boTe8vWTnr8w95PG5XlCBK0lmfZvtUazn/RYBIeCV28bwusQURvAg0Kc/gBoa3wIWiZhzaAiklUaXWoqR+yuoBwzKht8TLkXaOVxswphSoxsddrsn28Fw6rDfRiMKk3S6JcwY58P1n2By+LUPQIDAQAB', NULL, NULL, 'http://localhost:48081/app-api/order/payBackli_h51.json', 'http://localhost:8080/#/pages/take-foods/take-foods', 'RSA2', ' 2088821836348568', NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2024-03-31 17:05:59', b'0', 1);
INSERT INTO `merchant_details` VALUES ('wx_h51', 'wxPay', 'wxc061dee8806ff712', '1493624002', 'STR', 'dayouqiantuhupeng8638004yixiangt', NULL, NULL, NULL, 'https://apidc.yixiang.co/app-api/order/payBackwx_h51.json', 'https://dc.yixiang.co/h5/#/pages/mine/mine', 'MD5', NULL, NULL, NULL, 'utf-8', 0, '1', '1', '2023-09-18 17:56:33', '2024-03-31 17:05:49', b'0', 1);
INSERT INTO `merchant_details` VALUES ('wx_miniapp1', 'wxPay', 'wx001e2dc50bf532df', '1493624002', 'PATH', 'dayouqiantuhupeng8638004yixiangt', '', '/Users/hupeng/cert/1493624002_20231121_cert/apiclient_cert.p12', '1493624002', 'http://yx.l2.ttut.cc/app-api/order/notify/payBackwx_miniapp1.json', '', 'MD5', NULL, NULL, NULL, 'UTF-8', 0, '1', NULL, NULL, '2024-04-19 13:26:29', b'0', 1);
INSERT INTO `merchant_details` VALUES ('wx_wechat1', 'wxPay', 'wxc061dee8806ff712', '1493624002', 'STR', 'dayouqiantuhupeng8638004yixiangt', NULL, NULL, NULL, 'https://apidc.yixiang.co/app-api/order/payBackwx_wechat1.json', 'https://dc.yixiang.co/h5/#/pages/take-foods/take-foods', 'MD5', NULL, NULL, NULL, 'utf-8', 0, '1', '1', '2023-09-18 17:56:33', '2024-03-31 17:05:19', b'0', 1);
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
  `is_main` tinyint(1) DEFAULT '0' COMMENT '设置主账户用于app调用1-是',
  `is_miapp` tinyint(1) DEFAULT '0' COMMENT '是否是小程序1-是',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号账号表';

-- ----------------------------
-- Records of mp_account
-- ----------------------------
BEGIN;
INSERT INTO `mp_account` VALUES (2, '1', '2', '3', '4', NULL, '5', NULL, NULL, 0, 0, NULL, '1', '2023-01-07 17:30:30', '1', '2024-04-17 09:09:47', b'1', 1);
INSERT INTO `mp_account` VALUES (3, '1', '2', '3', '4', NULL, '5', NULL, NULL, 0, 0, NULL, '1', '2023-01-08 00:34:35', '1', '2024-04-17 09:09:50', b'1', 1);
INSERT INTO `mp_account` VALUES (5, 'yshop_pro', ' gh_370eafba1888 ', 'wxdbdbc123c8c30b45', '3312eb2026a006bd0cc39af3021ef9c5', NULL, 'yshop_pro', '', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQFv8TwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyWVFZbzlITmRha1UxMDAwMGcwNzkAAgTeHZ1kAwQAAAAA', 1, 0, '', '1', '2023-06-29 13:58:21', '1', '2024-04-18 17:47:40', b'0', 1);
INSERT INTO `mp_account` VALUES (6, '222', '222', '222', '222', NULL, '222', '', NULL, 0, 0, '', '1', '2024-04-17 10:05:19', '1', '2024-04-18 17:47:40', b'0', 1);
INSERT INTO `mp_account` VALUES (7, '小程序主账户', '', 'wx001e2dc50bf532df', 'd22aa6a98472ae0b5ee6dd9b7807520c', NULL, '', '', NULL, 1, 1, '', '1', '2024-04-18 17:37:53', '1', '2024-04-18 18:17:08', b'0', 1);
INSERT INTO `mp_account` VALUES (8, '222', '', '2222', '2222222', NULL, '', '', NULL, 0, 0, '', '1', '2024-04-18 17:41:05', '1', '2024-04-18 17:47:40', b'0', 1);
INSERT INTO `mp_account` VALUES (9, '333', '', '44444', '3333', NULL, '', '', NULL, 0, 1, '', '1', '2024-04-18 17:46:04', '1', '2024-05-31 16:36:33', b'0', 1);
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
INSERT INTO `mp_auto_reply` VALUES (53, 5, 'wxdbdbc123c8c30b45', 3, 'yshop', 1, NULL, 'text', 'haha', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2023-06-29 16:25:06', '1', '2024-03-30 14:56:16', b'0', 1);
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
INSERT INTO `mp_user` VALUES (7, 'osQ2UuCF6by7YZOwicfYfbt2TbMg', 0, '2023-07-24 17:19:37', '', '', NULL, 'zh_CN', NULL, NULL, NULL, '', '', 5, 'wxdbdbc123c8c30b45', NULL, '2023-07-24 17:19:40', NULL, '2024-03-30 14:57:51', b'0', 1);
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
INSERT INTO `QRTZ_CRON_TRIGGERS` VALUES ('schedulerName', 'revenueJob', 'DEFAULT', '0 * * * * ?', 'Asia/Shanghai');
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
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('schedulerName', 'revenueJob', 'DEFAULT', NULL, 'co.yixiang.yshop.framework.quartz.core.handler.JobHandlerInvoker', '0', '1', '1', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C770800000010000000027400064A4F425F49447372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B020000787000000000000000117400104A4F425F48414E444C45525F4E414D4574000A726576656E75654A6F627800);
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
INSERT INTO `QRTZ_SCHEDULER_STATE` VALUES ('schedulerName', 'hupengdeMBP1716252806116', 1716258134815, 15000);
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
INSERT INTO `QRTZ_TRIGGERS` VALUES ('schedulerName', 'revenueJob', 'DEFAULT', 'revenueJob', 'DEFAULT', NULL, 1709891700000, 1709891640000, 5, 'PAUSED', 'CRON', 1709865283000, 0, NULL, 0, 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C770800000010000000037400114A4F425F48414E444C45525F504152414D7400007400124A4F425F52455452595F494E54455256414C737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000174000F4A4F425F52455452595F434F554E5471007E000C7800);
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
INSERT INTO `system_dept` VALUES (101, '深圳总公司', 100, 1, 127, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2024-08-08 09:42:54', b'0', 1);
INSERT INTO `system_dept` VALUES (102, '长沙分公司', 100, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:40', b'0', 1);
INSERT INTO `system_dept` VALUES (103, '研发部门', 101, 1, 126, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2024-08-08 09:41:55', b'0', 1);
INSERT INTO `system_dept` VALUES (104, '市场部门', 101, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:38', b'0', 1);
INSERT INTO `system_dept` VALUES (105, '测试部门', 101, 3, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-05-16 20:25:15', b'0', 1);
INSERT INTO `system_dept` VALUES (106, '财务部门', 101, 4, 103, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2024-08-08 09:42:28', b'0', 1);
INSERT INTO `system_dept` VALUES (107, '运维部门', 101, 5, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:33', b'0', 1);
INSERT INTO `system_dept` VALUES (108, '市场部门', 102, 1, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-02-16 08:35:45', b'0', 1);
INSERT INTO `system_dept` VALUES (109, '财务部门', 102, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:29', b'0', 1);
INSERT INTO `system_dept` VALUES (110, '新部门', 0, 1, NULL, NULL, NULL, 0, '110', '2022-02-23 20:46:30', '110', '2024-07-24 17:28:39', b'1', 121);
INSERT INTO `system_dept` VALUES (111, '顶级部门', 0, 1, NULL, NULL, NULL, 0, '113', '2022-03-07 21:44:50', '113', '2024-07-24 17:28:43', b'1', 122);
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
) ENGINE=InnoDB AUTO_INCREMENT=1499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';

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
INSERT INTO `system_dict_data` VALUES (1145, 1, '管理后台', '1', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 管理后台', '1', '2022-02-02 13:15:06', '1', '2022-03-10 16:32:59', b'0');
INSERT INTO `system_dict_data` VALUES (1146, 2, '用户 APP', '2', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 用户 APP', '1', '2022-02-02 13:15:19', '1', '2022-03-10 16:33:03', b'0');
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
INSERT INTO `system_dict_data` VALUES (1194, 10, '微信小程序', '10', 'terminal', 0, 'default', '', '终端 - 微信小程序', '1', '2022-12-10 10:51:11', '1', '2022-12-10 10:51:57', b'0');
INSERT INTO `system_dict_data` VALUES (1195, 20, 'H5 网页', '20', 'terminal', 0, 'default', '', '终端 - H5 网页', '1', '2022-12-10 10:51:30', '1', '2022-12-10 10:51:59', b'0');
INSERT INTO `system_dict_data` VALUES (1196, 11, '微信公众号', '11', 'terminal', 0, 'default', '', '终端 - 微信公众号', '1', '2022-12-10 10:54:16', '1', '2022-12-10 10:52:01', b'0');
INSERT INTO `system_dict_data` VALUES (1197, 31, '苹果 App', '31', 'terminal', 0, 'default', '', '终端 - 苹果 App', '1', '2022-12-10 10:54:42', '1', '2022-12-10 10:52:18', b'0');
INSERT INTO `system_dict_data` VALUES (1198, 32, '安卓 App', '32', 'terminal', 0, 'default', '', '终端 - 安卓 App', '1', '2022-12-10 10:55:02', '1', '2022-12-10 10:59:17', b'0');
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
INSERT INTO `system_dict_data` VALUES (1231, 10, 'Vue2 Element UI 标准模版', '10', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:03:55', '1', '2023-07-31 09:28:36', b'1');
INSERT INTO `system_dict_data` VALUES (1232, 20, 'Vue3 Element Plus 标准模版', '20', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:08', '1', '2023-04-13 00:04:08', b'0');
INSERT INTO `system_dict_data` VALUES (1233, 21, 'Vue3 Element Plus Schema 模版', '21', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1', '2023-07-31 09:29:37', b'1');
INSERT INTO `system_dict_data` VALUES (1234, 30, 'Vue3 vben 模版', '30', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1', '2023-07-31 09:28:26', b'1');
INSERT INTO `system_dict_data` VALUES (1443, 15, '子表', '15', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-13 23:06:16', '1', '2023-11-13 23:06:16', b'0');
INSERT INTO `system_dict_data` VALUES (1444, 10, '主表（标准模式）', '10', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:32:49', '1', '2023-11-14 12:32:49', b'0');
INSERT INTO `system_dict_data` VALUES (1445, 11, '主表（ERP 模式）', '11', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:33:05', '1', '2023-11-14 12:33:05', b'0');
INSERT INTO `system_dict_data` VALUES (1446, 12, '主表（内嵌模式）', '12', 'infra_codegen_template_type', 0, '', '', '', '1', '2023-11-14 12:33:31', '1', '2023-11-14 12:33:31', b'0');
INSERT INTO `system_dict_data` VALUES (1447, 0, '无级别', '0', 'customer_level', 0, 'primary', '', '', '1', '2024-07-21 16:29:18', '1', '2024-07-21 16:29:18', b'0');
INSERT INTO `system_dict_data` VALUES (1448, 1, '重点客户', '1', 'customer_level', 0, '', '', '', '1', '2024-07-21 16:29:42', '1', '2024-07-21 16:29:42', b'0');
INSERT INTO `system_dict_data` VALUES (1449, 2, '优质客户', '2', 'customer_level', 0, '', '', '', '1', '2024-07-21 16:29:58', '1', '2024-07-21 16:29:58', b'0');
INSERT INTO `system_dict_data` VALUES (1450, 3, '普通客户', '3', 'customer_level', 0, '', '', '', '1', '2024-07-21 16:30:16', '1', '2024-07-21 16:30:16', b'0');
INSERT INTO `system_dict_data` VALUES (1451, 1000, '其他', '1000', 'customer_level', 0, '', '', '', '1', '2024-07-21 16:30:37', '1', '2024-07-21 16:30:37', b'0');
INSERT INTO `system_dict_data` VALUES (1452, 1, '金融业', '1', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:32:06', '1', '2024-07-21 16:32:06', b'0');
INSERT INTO `system_dict_data` VALUES (1453, 2, '房地产', '2', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:32:20', '1', '2024-07-21 16:32:20', b'0');
INSERT INTO `system_dict_data` VALUES (1454, 3, '商业服务', '3', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:32:33', '1', '2024-07-21 16:32:33', b'0');
INSERT INTO `system_dict_data` VALUES (1455, 4, '贸易', '4', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:32:46', '1', '2024-07-21 16:32:46', b'0');
INSERT INTO `system_dict_data` VALUES (1456, 5, '运输物流', '5', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:33:00', '1', '2024-07-21 16:33:00', b'0');
INSERT INTO `system_dict_data` VALUES (1457, 6, '服务业', '6', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:33:14', '1', '2024-07-21 16:33:14', b'0');
INSERT INTO `system_dict_data` VALUES (1458, 7, '文化传媒', '7', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:33:30', '1', '2024-07-21 16:33:30', b'0');
INSERT INTO `system_dict_data` VALUES (1459, 8, 'IT/互联网', '8', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:33:47', '1', '2024-07-21 16:33:47', b'0');
INSERT INTO `system_dict_data` VALUES (1460, 9, '其它', '9', 'customer_industry', 0, '', '', '', '1', '2024-07-21 16:34:00', '1', '2024-07-21 16:34:00', b'0');
INSERT INTO `system_dict_data` VALUES (1461, 0, '无来源', '0', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:35:03', '1', '2024-07-21 16:35:03', b'0');
INSERT INTO `system_dict_data` VALUES (1462, 1, '个人资源', '1', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:35:18', '1', '2024-07-21 16:35:18', b'0');
INSERT INTO `system_dict_data` VALUES (1463, 2, '广告', '2', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:35:29', '1', '2024-07-21 16:35:29', b'0');
INSERT INTO `system_dict_data` VALUES (1464, 3, '转介绍', '3', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:35:41', '1', '2024-07-21 16:35:41', b'0');
INSERT INTO `system_dict_data` VALUES (1465, 4, '搜索引擎', '4', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:35:55', '1', '2024-07-21 16:35:55', b'0');
INSERT INTO `system_dict_data` VALUES (1466, 5, '公司资源', '5', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:37:12', '1', '2024-07-21 16:37:12', b'0');
INSERT INTO `system_dict_data` VALUES (1467, 6, '电话资源', '6', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:37:32', '1', '2024-07-21 16:37:32', b'0');
INSERT INTO `system_dict_data` VALUES (1468, 7, '官网咨询', '7', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:37:55', '1', '2024-07-21 16:37:55', b'0');
INSERT INTO `system_dict_data` VALUES (1469, 8, '公众号', '8', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:38:08', '1', '2024-07-21 16:38:08', b'0');
INSERT INTO `system_dict_data` VALUES (1470, 9, '抖音', '9', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:38:27', '1', '2024-07-21 16:38:27', b'0');
INSERT INTO `system_dict_data` VALUES (1471, 10, '企业微信', '10', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:38:44', '1', '2024-07-21 16:38:44', b'0');
INSERT INTO `system_dict_data` VALUES (1472, 1000, '其它', '1000', 'customer_source', 0, '', '', '', '1', '2024-07-21 16:38:57', '1', '2024-07-21 16:38:57', b'0');
INSERT INTO `system_dict_data` VALUES (1473, 1, '电话', '1', 'follow_type', 0, '', '', '', '1', '2024-07-21 16:41:19', '1', '2024-07-21 16:41:19', b'0');
INSERT INTO `system_dict_data` VALUES (1474, 2, '上门拜访', '2', 'follow_type', 0, '', '', '', '1', '2024-07-21 16:41:33', '1', '2024-07-21 16:41:33', b'0');
INSERT INTO `system_dict_data` VALUES (1475, 3, '微信', '3', 'follow_type', 0, '', '', '', '1', '2024-07-21 16:41:44', '1', '2024-07-21 16:41:44', b'0');
INSERT INTO `system_dict_data` VALUES (1476, 4, '短信', '4', 'follow_type', 0, '', '', '', '1', '2024-07-21 16:42:04', '1', '2024-07-21 16:42:04', b'0');
INSERT INTO `system_dict_data` VALUES (1477, 1, '现金', '1', 'payee_type', 0, '', '', '', '1', '2024-07-21 16:43:15', '1', '2024-07-21 16:43:15', b'0');
INSERT INTO `system_dict_data` VALUES (1478, 2, '对公账户', '2', 'payee_type', 0, '', '', '', '1', '2024-07-21 16:43:26', '1', '2024-07-21 16:43:26', b'0');
INSERT INTO `system_dict_data` VALUES (1479, 3, '支付宝', '3', 'payee_type', 0, '', '', '', '1', '2024-07-21 16:43:34', '1', '2024-07-21 16:43:34', b'0');
INSERT INTO `system_dict_data` VALUES (1480, 4, '微信', '4', 'payee_type', 0, '', '', '', '1', '2024-07-21 16:43:44', '1', '2024-07-21 16:43:44', b'0');
INSERT INTO `system_dict_data` VALUES (1481, 5, '其它', '5', 'payee_type', 0, '', '', '', '1', '2024-07-21 16:43:55', '1', '2024-07-21 16:43:55', b'0');
INSERT INTO `system_dict_data` VALUES (1482, 1, '新客', '1', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:42:47', '1', '2024-07-22 09:42:47', b'0');
INSERT INTO `system_dict_data` VALUES (1483, 2, '待再次沟通', '2', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:43:03', '1', '2024-07-22 09:43:03', b'0');
INSERT INTO `system_dict_data` VALUES (1484, 3, '有意向', '3', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:43:18', '1', '2024-07-22 09:43:18', b'0');
INSERT INTO `system_dict_data` VALUES (1485, 4, '已加微信', '4', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:43:33', '1', '2024-07-22 09:43:33', b'0');
INSERT INTO `system_dict_data` VALUES (1486, 5, '转商机', '5', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:43:48', '1', '2024-07-22 09:43:48', b'0');
INSERT INTO `system_dict_data` VALUES (1487, 6, '无效', '0', 'follow_status', 0, '', '', '', '1', '2024-07-22 09:43:59', '1', '2024-07-22 09:43:59', b'0');
INSERT INTO `system_dict_data` VALUES (1488, 0, '洽淡中', '0', 'business_status', 0, '', '', '', '1', '2024-07-27 15:58:41', '1', '2024-07-27 15:58:41', b'0');
INSERT INTO `system_dict_data` VALUES (1489, 1, '成交', '1', 'business_status', 0, '', '', '', '1', '2024-07-27 15:58:55', '1', '2024-07-27 15:58:55', b'0');
INSERT INTO `system_dict_data` VALUES (1490, 2, '失败', '2', 'business_status', 0, '', '', '', '1', '2024-07-27 15:59:08', '1', '2024-07-27 15:59:08', b'0');
INSERT INTO `system_dict_data` VALUES (1491, 3, '无效', '3', 'business_status', 0, '', '', '', '1', '2024-07-27 15:59:23', '1', '2024-07-27 15:59:23', b'0');
INSERT INTO `system_dict_data` VALUES (1492, 0, '待审核', '0', 'contract_check_status', 0, '', '', '', '1', '2024-08-05 15:52:46', '1', '2024-08-05 15:52:46', b'0');
INSERT INTO `system_dict_data` VALUES (1493, 1, '审核中', '1', 'contract_check_status', 0, 'warning', '', '', '1', '2024-08-05 15:54:23', '1', '2024-08-05 15:54:23', b'0');
INSERT INTO `system_dict_data` VALUES (1494, 2, '审核通过', '2', 'contract_check_status', 0, 'success', '', '', '1', '2024-08-05 15:54:39', '1', '2024-08-05 15:54:39', b'0');
INSERT INTO `system_dict_data` VALUES (1495, 3, '审核未通过', '3', 'contract_check_status', 0, 'danger', '', '', '1', '2024-08-05 15:54:58', '1', '2024-08-05 15:54:58', b'0');
INSERT INTO `system_dict_data` VALUES (1496, 0, '合同过期', '0', 'contract_handle_status', 0, 'warning', '', '', '1', '2024-08-05 16:11:12', '1', '2024-08-05 16:11:12', b'0');
INSERT INTO `system_dict_data` VALUES (1497, 1, '已续签', '1', 'contract_handle_status', 0, 'success', '', '', '1', '2024-08-05 16:11:35', '1', '2024-08-05 16:11:35', b'0');
INSERT INTO `system_dict_data` VALUES (1498, 2, '不再合作', '2', 'contract_handle_status', 0, 'danger', '', '', '1', '2024-08-05 16:11:59', '1', '2024-08-05 16:11:59', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

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
INSERT INTO `system_dict_type` VALUES (144, '代码生成的场景枚举', 'infra_codegen_scene', 0, '代码生成的场景枚举', '1', '2022-02-02 13:14:45', '1', '2022-03-10 16:33:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (145, '角色类型', 'system_role_type', 0, '角色类型', '1', '2022-02-16 13:01:46', '1', '2022-02-16 13:01:46', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (146, '文件存储器', 'infra_file_storage', 0, '文件存储器', '1', '2022-03-15 00:24:38', '1', '2022-03-15 00:24:38', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (147, 'OAuth 2.0 授权类型', 'system_oauth2_grant_type', 0, 'OAuth 2.0 授权类型（模式）', '1', '2022-05-12 00:20:52', '1', '2022-05-11 16:25:49', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (160, '终端', 'terminal', 0, '终端', '1', '2022-12-10 10:50:50', '1', '2022-12-10 10:53:11', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (164, '公众号自动回复的请求关键字匹配模式', 'mp_auto_reply_request_match', 0, '公众号自动回复的请求关键字匹配模式', '1', '2023-01-16 23:29:56', '1', '2023-01-16 23:29:56', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (165, '公众号的消息类型', 'mp_message_type', 0, '公众号的消息类型', '1', '2023-01-17 22:17:09', '1', '2023-01-17 22:17:09', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (166, '邮件发送状态', 'system_mail_send_status', 0, '邮件发送状态', '1', '2023-01-26 09:53:13', '1', '2023-01-26 09:53:13', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (167, '站内信模版的类型', 'system_notify_template_type', 0, '站内信模版的类型', '1', '2023-01-28 10:35:10', '1', '2023-01-28 10:35:10', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (168, '代码生成的前端类型', 'infra_codegen_front_type', 0, '', '1', '2023-04-12 23:57:52', '1', '2023-04-12 23:57:52', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (169, '客户等级', 'customer_level', 0, '', '1', '2024-07-21 16:27:26', '1', '2024-07-21 16:27:26', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (170, '客户行业', 'customer_industry', 0, '', '1', '2024-07-21 16:31:43', '1', '2024-07-21 16:31:43', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (171, '客户来源', 'customer_source', 0, '', '1', '2024-07-21 16:34:44', '1', '2024-07-21 16:34:44', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (172, '跟进方式', 'follow_type', 0, '', '1', '2024-07-21 16:41:01', '1', '2024-07-21 16:41:01', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (173, '收款账户', 'payee_type', 0, '', '1', '2024-07-21 16:43:00', '1', '2024-07-21 16:43:00', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (174, '跟踪状态', 'follow_status', 0, '', '1', '2024-07-22 09:42:08', '1', '2024-07-22 09:42:08', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (175, '商机状态', 'business_status', 0, '', '1', '2024-07-27 15:58:16', '1', '2024-07-27 15:58:16', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (176, '合同审核状态', 'contract_check_status', 0, '', '1', '2024-08-05 15:52:05', '1', '2024-08-05 15:52:05', b'0', '1970-01-01 00:00:00');
INSERT INTO `system_dict_type` VALUES (177, '合同处理状态', 'contract_handle_status', 0, '', '1', '2024-08-05 16:10:33', '1', '2024-08-05 16:10:33', b'0', '1970-01-01 00:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=4625 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';

-- ----------------------------
-- Records of system_login_log
-- ----------------------------
BEGIN;
INSERT INTO `system_login_log` VALUES (4624, 100, '', 1, 2, 'admin', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', NULL, '2024-09-07 15:44:07', NULL, '2024-09-07 15:44:07', b'0', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件日志表';

-- ----------------------------
-- Records of system_mail_log
-- ----------------------------
BEGIN;
INSERT INTO `system_mail_log` VALUES (354, 67, 3, '222@qq.com', 2, 'ydym_test@163.com', 14, 'test_01', 'yshop', '一个标题', '<p>你是 11 吗？</p><p><br></p><p>是的话，赶紧 222 一下！</p>', '{\"key01\":\"11\",\"key02\":\"222\"}', 20, '2024-09-10 17:12:57', NULL, 'AuthenticationFailedException: 550 User has no permission\n', '1', '2024-09-10 17:12:56', NULL, '2024-09-10 17:12:57', b'0');
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
INSERT INTO `system_mail_template` VALUES (14, '测试模版', 'test_01', 2, 'yshop', '一个标题', '<p>你是 {key01} 吗？</p><p><br></p><p>是的话，赶紧 {key02} 一下！</p>', '[\"key01\",\"key02\"]', 0, NULL, '1', '2023-01-26 01:27:40', '1', '2024-09-10 09:50:16', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=2449 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

-- ----------------------------
-- Records of system_menu
-- ----------------------------
BEGIN;
INSERT INTO `system_menu` VALUES (1, '系统管理', '', 1, 300, 0, '/system', 'fa:gavel', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-12-10 17:56:40', b'0');
INSERT INTO `system_menu` VALUES (2, '基础设施', '', 1, 200, 0, '/infra', 'ep:menu', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2023-12-10 17:55:36', b'0');
INSERT INTO `system_menu` VALUES (5, 'OA 示例', '', 1, 40, 1185, 'oa', 'people', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2021-09-20 16:26:19', '1', '2023-05-10 09:47:14', b'1');
INSERT INTO `system_menu` VALUES (100, '用户管理', 'system:user:list', 2, 1, 1, 'user', 'ep:avatar', 'system/user/index', 'SystemUser', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:00:46', b'0');
INSERT INTO `system_menu` VALUES (101, '角色管理', '', 2, 2, 1, 'role', 'ep:user', 'system/role/index', 'SystemRole', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:00:58', b'0');
INSERT INTO `system_menu` VALUES (102, '菜单管理', '', 2, 3, 1, 'menu', 'ep:menu', 'system/menu/index', 'SystemMenu', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:01:03', b'0');
INSERT INTO `system_menu` VALUES (103, '部门管理', '', 2, 4, 1, 'dept', 'ant-design:deployment-unit-outlined', 'system/dept/index', 'SystemDept', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:01:30', b'0');
INSERT INTO `system_menu` VALUES (104, '岗位管理', '', 2, 5, 1, 'post', 'fa:address-book-o', 'system/post/index', 'SystemPost', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:01:40', b'0');
INSERT INTO `system_menu` VALUES (105, '字典管理', '', 2, 6, 1, 'dict', 'ep:collection', 'system/dict/index', 'SystemDictType', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:01:51', b'0');
INSERT INTO `system_menu` VALUES (106, '配置管理', '', 2, 6, 2, 'config', 'fa:connectdevelop', 'infra/config/index', 'InfraConfig', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:36:48', b'1');
INSERT INTO `system_menu` VALUES (107, '新闻公告', '', 2, 8, 1, 'notice', 'fa-solid:newspaper', 'system/notice/index', 'SystemNotice', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:31:53', b'1');
INSERT INTO `system_menu` VALUES (108, '审计日志', '', 1, 9, 1, 'log', 'ep:document-copy', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:02:22', b'0');
INSERT INTO `system_menu` VALUES (109, '令牌管理', '', 2, 2, 1261, 'token', 'fa:key', 'system/oauth2/token/index', 'SystemTokenClient', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:02:32', b'0');
INSERT INTO `system_menu` VALUES (110, '定时任务', '', 2, 12, 2, 'job', 'fa-solid:tasks', 'infra/job/index', 'InfraJob', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:02:43', b'0');
INSERT INTO `system_menu` VALUES (111, 'MySQL 监控', '', 2, 9, 2, 'druid', 'fa-solid:box', 'infra/druid/index', 'InfraDruid', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:02:56', b'0');
INSERT INTO `system_menu` VALUES (112, 'Java 监控', '', 2, 11, 2, 'admin-server', 'ep:coffee-cup', 'infra/server/index', 'InfraAdminServer', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:03:08', b'0');
INSERT INTO `system_menu` VALUES (113, 'Redis 监控', '', 2, 10, 2, 'redis', 'fa:reddit-square', 'infra/redis/index', 'InfraRedis', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:03:23', b'0');
INSERT INTO `system_menu` VALUES (114, '表单构建', 'infra:build:list', 2, 2, 2, 'build', 'fa:wpforms', 'infra/build/index', 'InfraBuild', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:37:06', b'1');
INSERT INTO `system_menu` VALUES (115, '代码生成', 'infra:codegen:query', 2, 1, 2, 'codegen', 'ep:document-copy', 'infra/codegen/index', 'InfraCodegen', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:04:09', b'0');
INSERT INTO `system_menu` VALUES (116, '系统接口', 'infra:swagger:list', 2, 3, 2, 'swagger', 'fa:fighter-jet', 'infra/swagger/index', 'InfraSwagger', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:04:22', b'0');
INSERT INTO `system_menu` VALUES (500, '操作日志', '', 2, 1, 108, 'operate-log', 'ep:position', 'system/operatelog/index', 'SystemOperateLog', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:04:31', b'0');
INSERT INTO `system_menu` VALUES (501, '登录日志', '', 2, 2, 108, 'login-log', 'ep:promotion', 'system/loginlog/index', 'SystemLoginLog', 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 17:04:39', b'0');
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
INSERT INTO `system_menu` VALUES (1031, '配置查询', 'infra:config:query', 3, 1, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2024-07-24 17:36:24', b'1');
INSERT INTO `system_menu` VALUES (1032, '配置新增', 'infra:config:create', 3, 2, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:36:28', b'1');
INSERT INTO `system_menu` VALUES (1033, '配置修改', 'infra:config:update', 3, 3, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:36:32', b'1');
INSERT INTO `system_menu` VALUES (1034, '配置删除', 'infra:config:delete', 3, 4, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:36:36', b'1');
INSERT INTO `system_menu` VALUES (1035, '配置导出', 'infra:config:export', 3, 5, 106, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2024-07-24 17:36:41', b'1');
INSERT INTO `system_menu` VALUES (1036, '公告查询', 'system:notice:query', 3, 1, 107, '#', '#', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '', '2024-07-24 17:31:40', b'1');
INSERT INTO `system_menu` VALUES (1037, '公告新增', 'system:notice:create', 3, 2, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:31:43', b'1');
INSERT INTO `system_menu` VALUES (1038, '公告修改', 'system:notice:update', 3, 3, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:31:46', b'1');
INSERT INTO `system_menu` VALUES (1039, '公告删除', 'system:notice:delete', 3, 4, 107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', '2021-01-05 17:03:48', '1', '2024-07-24 17:31:49', b'1');
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
INSERT INTO `system_menu` VALUES (1076, '数据库文档', '', 2, 4, 2, 'db-doc', 'fa:table', 'infra/dbDoc/index', 'InfraDBDoc', 0, b'1', b'1', b'1', '', '2021-02-08 01:41:47', '1', '2024-05-31 17:27:29', b'1');
INSERT INTO `system_menu` VALUES (1077, '监控平台', '', 2, 13, 2, 'skywalking', 'eye-open', 'infra/skywalking/index', 'InfraSkyWalking', 0, b'1', b'1', b'1', '', '2021-02-08 20:41:31', '1', '2023-06-29 13:39:57', b'1');
INSERT INTO `system_menu` VALUES (1078, '访问日志', '', 2, 1, 1083, 'api-access-log', 'log', 'infra/apiAccessLog/index', 'InfraApiAccessLog', 0, b'1', b'1', b'1', '', '2021-02-26 01:32:59', '1', '2023-04-08 10:31:34', b'0');
INSERT INTO `system_menu` VALUES (1082, '日志导出', 'infra:api-access-log:export', 3, 2, 1078, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 01:32:59', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1083, 'API 日志', '', 2, 8, 2, 'log', 'fa:tasks', NULL, NULL, 0, b'1', b'1', b'1', '', '2021-02-26 02:18:24', '1', '2024-05-31 17:10:10', b'0');
INSERT INTO `system_menu` VALUES (1084, '错误日志', 'infra:api-error-log:query', 2, 2, 1083, 'api-error-log', 'log', 'infra/apiErrorLog/index', 'InfraApiErrorLog', 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2023-04-08 10:32:25', b'0');
INSERT INTO `system_menu` VALUES (1085, '日志处理', 'infra:api-error-log:update-status', 3, 2, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1086, '日志导出', 'infra:api-error-log:export', 3, 3, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1087, '任务查询', 'infra:job:query', 3, 1, 110, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:26:19', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1088, '日志查询', 'infra:api-access-log:query', 3, 1, 1078, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:28:04', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1089, '日志查询', 'infra:api-error-log:query', 3, 1, 1084, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-03-10 01:29:09', '1', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1090, '文件列表', '', 2, 5, 1243, 'file', 'upload', 'infra/file/index', 'InfraFile', 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '1', '2023-04-08 09:21:31', b'0');
INSERT INTO `system_menu` VALUES (1091, '文件查询', 'infra:file:query', 3, 1, 1090, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1092, '文件删除', 'infra:file:delete', 3, 4, 1090, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1093, '短信管理', '', 1, 11, 1, 'sms', 'ep:message', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-04-05 01:10:16', '1', '2024-05-31 17:11:16', b'0');
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
INSERT INTO `system_menu` VALUES (1110, '错误码管理', '', 2, 12, 1, 'error-code', 'fa:bomb', 'system/errorCode/index', 'SystemErrorCode', 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '1', '2024-07-24 17:33:37', b'1');
INSERT INTO `system_menu` VALUES (1111, '错误码查询', 'system:error-code:query', 3, 1, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-07-24 17:33:16', b'1');
INSERT INTO `system_menu` VALUES (1112, '错误码创建', 'system:error-code:create', 3, 2, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-07-24 17:33:20', b'1');
INSERT INTO `system_menu` VALUES (1113, '错误码更新', 'system:error-code:update', 3, 3, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-07-24 17:33:25', b'1');
INSERT INTO `system_menu` VALUES (1114, '错误码删除', 'system:error-code:delete', 3, 4, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-07-24 17:33:28', b'1');
INSERT INTO `system_menu` VALUES (1115, '错误码导出', 'system:error-code:export', 3, 5, 1110, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-04-13 21:46:42', '', '2024-07-24 17:33:32', b'1');
INSERT INTO `system_menu` VALUES (1117, '支付管理', '', 1, 90, 0, '/pay', 'fa:calculator', NULL, NULL, 0, b'1', b'1', b'1', '1', '2021-12-25 16:43:41', '1', '2023-12-10 17:53:30', b'0');
INSERT INTO `system_menu` VALUES (1138, '租户列表', '', 2, 0, 1224, 'list', 'peoples', 'system/tenant/index', 'SystemTenant', 0, b'1', b'1', b'1', '', '2021-12-14 12:31:43', '1', '2024-07-24 17:31:24', b'1');
INSERT INTO `system_menu` VALUES (1139, '租户查询', 'system:tenant:query', 3, 1, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2024-07-24 17:31:06', b'1');
INSERT INTO `system_menu` VALUES (1140, '租户创建', 'system:tenant:create', 3, 2, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2024-07-24 17:31:09', b'1');
INSERT INTO `system_menu` VALUES (1141, '租户更新', 'system:tenant:update', 3, 3, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2024-07-24 17:31:13', b'1');
INSERT INTO `system_menu` VALUES (1142, '租户删除', 'system:tenant:delete', 3, 4, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2024-07-24 17:31:16', b'1');
INSERT INTO `system_menu` VALUES (1143, '租户导出', 'system:tenant:export', 3, 5, 1138, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2021-12-14 12:31:44', '', '2024-07-24 17:31:20', b'1');
INSERT INTO `system_menu` VALUES (1150, '秘钥解析', '', 3, 6, 1129, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2021-11-08 15:15:47', '1', '2023-07-14 15:11:42', b'1');
INSERT INTO `system_menu` VALUES (1179, '商户信息', '', 2, 0, 1117, 'merchant', 'merchant', 'pay/merchant/index', 'PayApp', 0, b'1', b'1', b'1', '', '2021-12-25 09:01:44', '1', '2023-07-14 15:10:51', b'1');
INSERT INTO `system_menu` VALUES (1224, '租户管理', '', 2, 0, 1, 'tenant', 'fa-solid:house-user', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-02-20 01:41:13', '1', '2024-07-24 17:31:28', b'1');
INSERT INTO `system_menu` VALUES (1225, '租户套餐', '', 2, 0, 1224, 'package', 'eye', 'system/tenantPackage/index', 'SystemTenantPackage', 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '1', '2024-07-24 17:30:57', b'1');
INSERT INTO `system_menu` VALUES (1226, '租户套餐查询', 'system:tenant-package:query', 3, 1, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2024-07-24 17:30:44', b'1');
INSERT INTO `system_menu` VALUES (1227, '租户套餐创建', 'system:tenant-package:create', 3, 2, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2024-07-24 17:30:47', b'1');
INSERT INTO `system_menu` VALUES (1228, '租户套餐更新', 'system:tenant-package:update', 3, 3, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2024-07-24 17:30:51', b'1');
INSERT INTO `system_menu` VALUES (1229, '租户套餐删除', 'system:tenant-package:delete', 3, 4, 1225, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-02-19 17:44:06', '', '2024-07-24 17:30:54', b'1');
INSERT INTO `system_menu` VALUES (1237, '文件配置', '', 2, 0, 1243, 'file-config', 'config', 'infra/fileConfig/index', 'InfraFileConfig', 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '1', '2023-04-08 09:16:05', b'0');
INSERT INTO `system_menu` VALUES (1238, '文件配置查询', 'infra:file-config:query', 3, 1, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1239, '文件配置创建', 'infra:file-config:create', 3, 2, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1240, '文件配置更新', 'infra:file-config:update', 3, 3, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1241, '文件配置删除', 'infra:file-config:delete', 3, 4, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1242, '文件配置导出', 'infra:file-config:export', 3, 5, 1237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', b'0');
INSERT INTO `system_menu` VALUES (1243, '文件管理', '', 2, 5, 2, 'file', 'ep:files', NULL, '', 0, b'1', b'1', b'1', '1', '2022-03-16 23:47:40', '1', '2024-05-31 17:08:13', b'0');
INSERT INTO `system_menu` VALUES (1247, '敏感词管理', '', 2, 13, 1, 'sensitive-word', 'fa:intersex', 'system/sensitiveWord/index', 'SystemSensitiveWord', 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '1', '2024-07-24 17:34:00', b'1');
INSERT INTO `system_menu` VALUES (1248, '敏感词查询', 'system:sensitive-word:query', 3, 1, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-07-24 17:33:43', b'1');
INSERT INTO `system_menu` VALUES (1249, '敏感词创建', 'system:sensitive-word:create', 3, 2, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-07-24 17:33:47', b'1');
INSERT INTO `system_menu` VALUES (1250, '敏感词更新', 'system:sensitive-word:update', 3, 3, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-07-24 17:33:51', b'1');
INSERT INTO `system_menu` VALUES (1251, '敏感词删除', 'system:sensitive-word:delete', 3, 4, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-07-24 17:33:54', b'1');
INSERT INTO `system_menu` VALUES (1252, '敏感词导出', 'system:sensitive-word:export', 3, 5, 1247, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-07 16:55:03', '', '2024-07-24 17:33:57', b'1');
INSERT INTO `system_menu` VALUES (1255, '数据源配置', '', 2, 1, 2, 'data-source-config', 'ep:data-analysis', 'infra/dataSourceConfig/index', 'InfraDataSourceConfig', 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '1', '2024-07-24 17:35:11', b'1');
INSERT INTO `system_menu` VALUES (1256, '数据源配置查询', 'infra:data-source-config:query', 3, 1, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2024-07-24 17:34:54', b'1');
INSERT INTO `system_menu` VALUES (1257, '数据源配置创建', 'infra:data-source-config:create', 3, 2, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2024-07-24 17:34:57', b'1');
INSERT INTO `system_menu` VALUES (1258, '数据源配置更新', 'infra:data-source-config:update', 3, 3, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2024-07-24 17:35:01', b'1');
INSERT INTO `system_menu` VALUES (1259, '数据源配置删除', 'infra:data-source-config:delete', 3, 4, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2024-07-24 17:35:04', b'1');
INSERT INTO `system_menu` VALUES (1260, '数据源配置导出', 'infra:data-source-config:export', 3, 5, 1255, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-04-27 14:37:32', '', '2024-07-24 17:35:07', b'1');
INSERT INTO `system_menu` VALUES (1261, 'OAuth 2.0', '', 1, 10, 1, 'oauth2', 'fa:dashcube', NULL, NULL, 0, b'1', b'1', b'1', '1', '2022-05-09 23:38:17', '1', '2024-05-31 17:10:41', b'0');
INSERT INTO `system_menu` VALUES (1263, '应用管理', '', 2, 0, 1261, 'oauth2/application', 'tool', 'system/oauth2/client/index', 'SystemOAuth2Client', 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2023-04-08 08:47:31', b'0');
INSERT INTO `system_menu` VALUES (1264, '客户端查询', 'system:oauth2-client:query', 3, 1, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:06', b'0');
INSERT INTO `system_menu` VALUES (1265, '客户端创建', 'system:oauth2-client:create', 3, 2, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:23', b'0');
INSERT INTO `system_menu` VALUES (1266, '客户端更新', 'system:oauth2-client:update', 3, 3, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:28', b'0');
INSERT INTO `system_menu` VALUES (1267, '客户端删除', 'system:oauth2-client:delete', 3, 4, 1263, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:33', b'0');
INSERT INTO `system_menu` VALUES (1281, '报表管理', '', 1, 40, 0, '/report', 'chart', NULL, NULL, 1, b'0', b'1', b'1', '1', '2022-07-10 20:22:15', '1', '2023-05-10 10:35:17', b'1');
INSERT INTO `system_menu` VALUES (1282, '报表设计器', '', 2, 1, 1281, 'jimu-report', 'example', 'report/jmreport/index', 'GoView', 0, b'1', b'1', b'1', '1', '2022-07-10 20:26:36', '1', '2023-05-10 10:34:51', b'1');
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
INSERT INTO `system_menu` VALUES (2083, '地区管理', '', 2, 14, 1, 'area', 'fa:map-marker', 'system/area/index', 'SystemArea', 0, b'1', b'1', b'1', '1', '2022-12-23 17:35:05', '1', '2024-05-31 17:12:39', b'0');
INSERT INTO `system_menu` VALUES (2084, '微信管理', '', 1, 100, 0, '/mp', 'ep:chat-dot-round', NULL, NULL, 1, b'0', b'1', b'0', '1', '2023-01-01 20:11:04', '1', '2024-08-10 17:11:13', b'1');
INSERT INTO `system_menu` VALUES (2085, '账号管理', '', 2, 1, 2346, 'account', 'fa:user', 'mp/account/index', 'MpAccount', 0, b'1', b'1', b'1', '1', '2023-01-01 20:13:31', '1', '2024-08-10 17:08:16', b'1');
INSERT INTO `system_menu` VALUES (2086, '新增账号', 'mp:account:create', 3, 1, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-01 20:21:40', '1', '2024-08-10 17:07:53', b'1');
INSERT INTO `system_menu` VALUES (2087, '修改账号', 'mp:account:update', 3, 2, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:32:46', '1', '2024-08-10 17:07:56', b'1');
INSERT INTO `system_menu` VALUES (2088, '查询账号', 'mp:account:query', 3, 0, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:07', '1', '2024-08-10 17:07:49', b'1');
INSERT INTO `system_menu` VALUES (2089, '删除账号', 'mp:account:delete', 3, 3, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:21', '1', '2024-08-10 17:08:01', b'1');
INSERT INTO `system_menu` VALUES (2090, '生成二维码', 'mp:account:qr-code', 3, 4, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 17:33:58', '1', '2024-08-10 17:08:04', b'1');
INSERT INTO `system_menu` VALUES (2091, '清空 API 配额', 'mp:account:clear-quota', 3, 5, 2085, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-07 18:20:32', '1', '2024-08-10 17:08:08', b'1');
INSERT INTO `system_menu` VALUES (2092, '数据统计', 'mp:statistics:query', 2, 2, 2346, 'statistics', 'ep:picture', 'mp/statistics/index', 'MpStatistics', 0, b'1', b'1', b'0', '1', '2023-01-07 20:17:36', '1', '2024-08-10 17:08:20', b'1');
INSERT INTO `system_menu` VALUES (2093, '标签管理', '', 2, 3, 2346, 'tag', 'ep:collection-tag', 'mp/tag/index', 'MpTag', 0, b'1', b'1', b'1', '1', '2023-01-08 11:37:32', '1', '2024-08-10 17:08:48', b'1');
INSERT INTO `system_menu` VALUES (2094, '查询标签', 'mp:tag:query', 3, 0, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:03', '1', '2024-08-10 17:08:29', b'1');
INSERT INTO `system_menu` VALUES (2095, '新增标签', 'mp:tag:create', 3, 1, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:23', '1', '2024-08-10 17:08:33', b'1');
INSERT INTO `system_menu` VALUES (2096, '修改标签', 'mp:tag:update', 3, 2, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 11:59:41', '1', '2024-08-10 17:08:36', b'1');
INSERT INTO `system_menu` VALUES (2097, '删除标签', 'mp:tag:delete', 3, 3, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 12:00:04', '1', '2024-08-10 17:08:40', b'1');
INSERT INTO `system_menu` VALUES (2098, '同步标签', 'mp:tag:sync', 3, 4, 2093, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 12:00:29', '1', '2024-08-10 17:08:44', b'1');
INSERT INTO `system_menu` VALUES (2099, '粉丝管理', '', 2, 4, 2346, 'user', 'ep:avatar', 'mp/user/index', 'MpUser', 0, b'1', b'1', b'1', '1', '2023-01-08 16:51:20', '1', '2024-08-10 17:09:17', b'1');
INSERT INTO `system_menu` VALUES (2100, '查询粉丝', 'mp:user:query', 3, 0, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:16:59', '1', '2024-08-10 17:08:54', b'1');
INSERT INTO `system_menu` VALUES (2101, '修改粉丝', 'mp:user:update', 3, 1, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:17:11', '1', '2024-08-10 17:08:57', b'1');
INSERT INTO `system_menu` VALUES (2102, '同步粉丝', 'mp:user:sync', 3, 2, 2099, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-08 17:17:40', '1', '2024-08-10 17:09:01', b'1');
INSERT INTO `system_menu` VALUES (2103, '消息管理', '', 2, 5, 2346, 'message', 'ep:document-remove', 'mp/message/index', 'MpMessage', 0, b'1', b'1', b'1', '1', '2023-01-08 18:44:19', '1', '2024-08-10 17:09:21', b'1');
INSERT INTO `system_menu` VALUES (2104, '图文发表记录', '', 2, 10, 2346, 'free-publish', 'ep:list', 'mp/freePublish/index', 'MpFreePublish', 0, b'1', b'1', b'1', '1', '2023-01-13 00:30:50', '1', '2024-08-10 17:11:02', b'1');
INSERT INTO `system_menu` VALUES (2105, '查询发布列表', 'mp:free-publish:query', 3, 1, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:19:17', '1', '2024-08-10 17:10:51', b'1');
INSERT INTO `system_menu` VALUES (2106, '发布草稿', 'mp:free-publish:submit', 3, 2, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:19:46', '1', '2024-08-10 17:10:55', b'1');
INSERT INTO `system_menu` VALUES (2107, '删除发布记录', 'mp:free-publish:delete', 3, 3, 2104, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 07:20:01', '1', '2024-08-10 17:10:58', b'1');
INSERT INTO `system_menu` VALUES (2108, '图文草稿箱', '', 2, 9, 2346, 'draft', 'ep:edit', 'mp/draft/index', 'MpDraft', 0, b'1', b'1', b'0', '1', '2023-01-13 07:40:21', '1', '2024-08-10 17:10:46', b'1');
INSERT INTO `system_menu` VALUES (2109, '新建草稿', 'mp:draft:create', 3, 1, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-13 23:15:30', '1', '2024-08-10 17:10:35', b'1');
INSERT INTO `system_menu` VALUES (2110, '修改草稿', 'mp:draft:update', 3, 2, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:08:47', '1', '2024-08-10 17:10:39', b'1');
INSERT INTO `system_menu` VALUES (2111, '查询草稿', 'mp:draft:query', 3, 0, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:09:01', '1', '2024-08-10 17:10:32', b'1');
INSERT INTO `system_menu` VALUES (2112, '删除草稿', 'mp:draft:delete', 3, 3, 2108, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 10:09:19', '1', '2024-08-10 17:10:42', b'1');
INSERT INTO `system_menu` VALUES (2113, '素材管理', '', 2, 8, 2346, 'material', 'ep:basketball', 'mp/material/index', 'MpMaterial', 0, b'1', b'1', b'0', '1', '2023-01-14 14:12:07', '1', '2024-08-10 17:10:26', b'1');
INSERT INTO `system_menu` VALUES (2114, '上传临时素材', 'mp:material:upload-temporary', 3, 1, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:33:55', '1', '2024-08-10 17:10:06', b'1');
INSERT INTO `system_menu` VALUES (2115, '上传永久素材', 'mp:material:upload-permanent', 3, 2, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:34:14', '1', '2024-08-10 17:10:10', b'1');
INSERT INTO `system_menu` VALUES (2116, '删除素材', 'mp:material:delete', 3, 3, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:35:37', '1', '2024-08-10 17:10:14', b'1');
INSERT INTO `system_menu` VALUES (2117, '上传图文图片', 'mp:material:upload-news-image', 3, 4, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:36:31', '1', '2024-08-10 17:10:18', b'1');
INSERT INTO `system_menu` VALUES (2118, '查询素材', 'mp:material:query', 3, 5, 2113, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-14 15:39:22', '1', '2024-08-10 17:10:21', b'1');
INSERT INTO `system_menu` VALUES (2119, '菜单管理', '', 2, 6, 2346, 'menu', 'ep:menu', 'mp/menu/index', 'MpMenu', 0, b'1', b'1', b'0', '1', '2023-01-14 17:43:54', '1', '2024-08-10 17:09:39', b'1');
INSERT INTO `system_menu` VALUES (2120, '自动回复', '', 2, 7, 2346, 'auto-reply', 'fa-solid:republican', 'mp/autoReply/index', 'MpAutoReply', 0, b'1', b'1', b'0', '1', '2023-01-15 22:13:09', '1', '2024-08-10 17:10:00', b'1');
INSERT INTO `system_menu` VALUES (2121, '查询回复', 'mp:auto-reply:query', 3, 0, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:28:41', '1', '2024-08-10 17:09:45', b'1');
INSERT INTO `system_menu` VALUES (2122, '新增回复', 'mp:auto-reply:create', 3, 1, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:28:54', '1', '2024-08-10 17:09:48', b'1');
INSERT INTO `system_menu` VALUES (2123, '修改回复', 'mp:auto-reply:update', 3, 2, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:29:05', '1', '2024-08-10 17:09:52', b'1');
INSERT INTO `system_menu` VALUES (2124, '删除回复', 'mp:auto-reply:delete', 3, 3, 2120, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-16 22:29:34', '1', '2024-08-10 17:09:55', b'1');
INSERT INTO `system_menu` VALUES (2125, '查询菜单', 'mp:menu:query', 3, 0, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:05:41', '1', '2024-08-10 17:09:26', b'1');
INSERT INTO `system_menu` VALUES (2126, '保存菜单', 'mp:menu:save', 3, 1, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:06:01', '1', '2024-08-10 17:09:31', b'1');
INSERT INTO `system_menu` VALUES (2127, '删除菜单', 'mp:menu:delete', 3, 2, 2119, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:06:16', '1', '2024-08-10 17:09:35', b'1');
INSERT INTO `system_menu` VALUES (2128, '查询消息', 'mp:message:query', 3, 0, 2103, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:07:14', '1', '2024-08-10 17:09:08', b'1');
INSERT INTO `system_menu` VALUES (2129, '发送消息', 'mp:message:send', 3, 1, 2103, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-17 23:07:26', '1', '2024-08-10 17:09:12', b'1');
INSERT INTO `system_menu` VALUES (2130, '邮箱管理', '', 2, 11, 1, 'mail', 'fa-solid:mail-bulk', NULL, NULL, 0, b'1', b'1', b'1', '1', '2023-01-25 17:27:44', '1', '2024-05-31 16:57:11', b'0');
INSERT INTO `system_menu` VALUES (2131, '邮箱账号', '', 2, 0, 2130, 'mail-account', 'fa:universal-access', 'system/mail/account/index', 'SystemMailAccount', 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '1', '2024-05-31 16:57:16', b'0');
INSERT INTO `system_menu` VALUES (2132, '账号查询', 'system:mail-account:query', 3, 1, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2133, '账号创建', 'system:mail-account:create', 3, 2, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2134, '账号更新', 'system:mail-account:update', 3, 3, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2135, '账号删除', 'system:mail-account:delete', 3, 4, 2131, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', b'0');
INSERT INTO `system_menu` VALUES (2136, '邮件模版', '', 2, 0, 2130, 'mail-template', 'fa:tag', 'system/mail/template/index', 'SystemMailTemplate', 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '1', '2024-05-31 16:57:33', b'0');
INSERT INTO `system_menu` VALUES (2137, '模版查询', 'system:mail-template:query', 3, 1, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2138, '模版创建', 'system:mail-template:create', 3, 2, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2139, '模版更新', 'system:mail-template:update', 3, 3, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2140, '模版删除', 'system:mail-template:delete', 3, 4, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', b'0');
INSERT INTO `system_menu` VALUES (2141, '邮件记录', '', 2, 0, 2130, 'mail-log', 'fa:edit', 'system/mail/log/index', 'SystemMailLog', 0, b'1', b'1', b'1', '', '2023-01-26 02:16:50', '1', '2024-05-31 16:57:49', b'0');
INSERT INTO `system_menu` VALUES (2142, '日志查询', 'system:mail-log:query', 3, 1, 2141, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-26 02:16:50', '', '2023-01-26 02:16:50', b'0');
INSERT INTO `system_menu` VALUES (2143, '发送测试邮件', 'system:mail-template:send-mail', 3, 5, 2136, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-26 23:29:15', '1', '2023-01-26 23:29:15', b'0');
INSERT INTO `system_menu` VALUES (2144, '站内信管理', '', 1, 11, 1, 'notify', 'ep:message-box', NULL, NULL, 0, b'1', b'1', b'1', '1', '2023-01-28 10:25:18', '1', '2024-05-31 16:58:13', b'0');
INSERT INTO `system_menu` VALUES (2145, '模板管理', '', 2, 0, 2144, 'notify-template', 'fa:archive', 'system/notify/template/index', 'SystemNotifyTemplate', 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '1', '2024-05-31 16:58:29', b'0');
INSERT INTO `system_menu` VALUES (2146, '站内信模板查询', 'system:notify-template:query', 3, 1, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2147, '站内信模板创建', 'system:notify-template:create', 3, 2, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2148, '站内信模板更新', 'system:notify-template:update', 3, 3, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2149, '站内信模板删除', 'system:notify-template:delete', 3, 4, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', b'0');
INSERT INTO `system_menu` VALUES (2150, '发送测试站内信', 'system:notify-template:send-notify', 3, 5, 2145, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-01-28 10:54:43', '1', '2023-01-28 10:54:43', b'0');
INSERT INTO `system_menu` VALUES (2151, '消息记录', '', 2, 0, 2144, 'notify-message', 'fa:edit', 'system/notify/message/index', 'SystemNotifyMessage', 0, b'1', b'1', b'1', '', '2023-01-28 04:28:22', '1', '2024-05-31 17:00:09', b'0');
INSERT INTO `system_menu` VALUES (2152, '站内信消息查询', 'system:notify-message:query', 3, 1, 2151, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-01-28 04:28:22', '', '2023-01-28 04:28:22', b'0');
INSERT INTO `system_menu` VALUES (2153, '大屏设计器', '', 2, 2, 1281, 'go-view', 'dashboard', 'report/goview/index', 'JimuReport', 0, b'1', b'1', b'1', '1', '2023-02-07 00:03:19', '1', '2023-05-10 10:35:14', b'1');
INSERT INTO `system_menu` VALUES (2154, '创建项目', 'report:go-view-project:create', 3, 1, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:14', '1', '2023-05-10 10:34:59', b'1');
INSERT INTO `system_menu` VALUES (2155, '更新项目', 'report:go-view-project:delete', 3, 2, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:34', '1', '2023-05-10 10:35:03', b'1');
INSERT INTO `system_menu` VALUES (2156, '查询项目', 'report:go-view-project:query', 3, 0, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:25:53', '1', '2023-05-10 10:34:56', b'1');
INSERT INTO `system_menu` VALUES (2157, '使用 SQL 查询数据', 'report:go-view-data:get-by-sql', 3, 3, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:26:15', '1', '2023-05-10 10:35:06', b'1');
INSERT INTO `system_menu` VALUES (2158, '使用 HTTP 查询数据', 'report:go-view-data:get-by-http', 3, 4, 2153, '', '', '', NULL, 0, b'1', b'1', b'1', '1', '2023-02-07 19:26:35', '1', '2023-05-10 10:35:10', b'1');
INSERT INTO `system_menu` VALUES (2161, '接入示例', '', 2, 99, 1117, 'demo-order', 'drag', 'pay/demo/index', NULL, 0, b'1', b'1', b'1', '', '2023-02-11 14:21:42', '1', '2023-07-09 09:47:51', b'1');
INSERT INTO `system_menu` VALUES (2162, '商品规格', '', 2, 3, 2174, 'store-product-rule', 'ep:operation', 'mall/product/storeProductRule/index', 'StoreProductRule', 0, b'1', b'1', b'1', '', '2023-05-17 10:59:10', '1', '2024-07-20 17:29:16', b'0');
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
INSERT INTO `system_menu` VALUES (2174, '商品管理', '', 1, 80, 0, '/product', 'ep:shopping-cart', '', '', 0, b'1', b'1', b'1', '1', '2023-06-02 11:24:04', '1', '2024-07-27 11:00:29', b'0');
INSERT INTO `system_menu` VALUES (2237, '支付配置', '', 2, 0, 1117, 'merchant-details', 'ep:money', 'pay/merchantDetails/index', 'MerchantDetails', 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '1', '2023-07-14 15:09:50', b'0');
INSERT INTO `system_menu` VALUES (2238, '支付服务商配置查询', 'pay:merchant-details:query', 3, 1, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2024-08-10 17:05:31', b'0');
INSERT INTO `system_menu` VALUES (2239, '支付服务商配置创建', 'pay:merchant-details:create', 3, 2, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2240, '支付服务商配置更新', 'pay:merchant-details:update', 3, 3, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2241, '支付服务商配置删除', 'pay:merchant-details:delete', 3, 4, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2242, '支付服务商配置导出', 'pay:merchant-details:export', 3, 5, 2237, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-14 14:34:15', '', '2023-07-14 14:34:15', b'0');
INSERT INTO `system_menu` VALUES (2257, '消息管理', '', 1, 92, 0, '/message', 'ep:message', '', '', 0, b'1', b'1', b'1', '1', '2023-07-25 09:41:06', '1', '2024-04-18 17:49:03', b'1');
INSERT INTO `system_menu` VALUES (2258, '微信消息', '', 2, 1, 2084, 'wechat-template', 'ep:message', 'message/wechatTemplate/index', 'WechatTemplate', 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '1', '2024-08-10 17:06:55', b'1');
INSERT INTO `system_menu` VALUES (2259, '微信模板查询', 'message:wechat-template:query', 3, 1, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2024-08-10 17:06:37', b'1');
INSERT INTO `system_menu` VALUES (2260, '微信模板创建', 'message:wechat-template:create', 3, 2, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2024-08-10 17:06:41', b'1');
INSERT INTO `system_menu` VALUES (2261, '微信模板更新', 'message:wechat-template:update', 3, 3, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2024-08-10 17:06:45', b'1');
INSERT INTO `system_menu` VALUES (2262, '微信模板删除', 'message:wechat-template:delete', 3, 4, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2024-08-10 17:06:48', b'1');
INSERT INTO `system_menu` VALUES (2263, '微信模板导出', 'message:wechat-template:export', 3, 5, 2258, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2023-07-25 09:45:42', '', '2024-08-10 17:06:52', b'1');
INSERT INTO `system_menu` VALUES (2346, '公众号管理', '', 1, 2, 2084, 'wechat', 'ep:wallet', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:19:26', '1', '2024-08-10 17:11:06', b'1');
INSERT INTO `system_menu` VALUES (2347, '小程序账户', '', 2, 1, 2084, 'account2', 'ep:briefcase', 'mp/account2/index', 'MaAccount', 0, b'1', b'1', b'1', '1', '2024-04-18 17:25:29', '1', '2024-08-10 17:06:32', b'1');
INSERT INTO `system_menu` VALUES (2348, '查询', 'ma:account:query', 3, 0, 2347, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:26:39', '1', '2024-08-10 17:06:14', b'1');
INSERT INTO `system_menu` VALUES (2349, '创建', 'ma:account:create', 3, 1, 2347, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:27:21', '1', '2024-08-10 17:06:17', b'1');
INSERT INTO `system_menu` VALUES (2350, '修改', 'ma:account:update', 3, 2, 2347, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:28:00', '1', '2024-08-10 17:06:21', b'1');
INSERT INTO `system_menu` VALUES (2351, '删除', 'ma:account:delete', 3, 3, 2347, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:28:39', '1', '2024-08-10 17:06:24', b'1');
INSERT INTO `system_menu` VALUES (2352, '设置主账户', 'ma:account:set-main', 3, 4, 2347, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:29:41', '1', '2024-08-10 17:06:28', b'1');
INSERT INTO `system_menu` VALUES (2353, '设置主账户', 'mp:account:set-main', 3, 6, 2085, '', '', '', '', 0, b'1', b'1', b'1', '1', '2024-04-18 17:30:46', '1', '2024-08-10 17:08:12', b'1');
INSERT INTO `system_menu` VALUES (2381, '客户管理', '', 1, 10, 0, '/crm', 'ep:avatar', '', '', 0, b'1', b'1', b'1', '1', '2024-07-20 20:55:50', '1', '2024-07-24 16:22:03', b'0');
INSERT INTO `system_menu` VALUES (2382, '客户管理', '', 2, 0, 2381, 'customer', 'ep:credit-card', 'crm/crmcustomer/index', 'CrmCustomer', 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '1', '2024-07-20 21:23:29', b'0');
INSERT INTO `system_menu` VALUES (2383, '客户查询', 'crm:customer:query', 3, 1, 2382, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '', '2024-07-20 21:01:52', b'0');
INSERT INTO `system_menu` VALUES (2384, '客户创建', 'crm:customer:create', 3, 2, 2382, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '', '2024-07-20 21:01:52', b'0');
INSERT INTO `system_menu` VALUES (2385, '客户更新', 'crm:customer:update', 3, 3, 2382, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '', '2024-07-20 21:01:52', b'0');
INSERT INTO `system_menu` VALUES (2386, '客户删除', 'crm:customer:delete', 3, 4, 2382, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '', '2024-07-20 21:01:52', b'0');
INSERT INTO `system_menu` VALUES (2387, '客户导出', 'crm:customer:export', 3, 5, 2382, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-20 21:01:52', '', '2024-07-20 21:01:52', b'0');
INSERT INTO `system_menu` VALUES (2388, '联系人', '', 2, 1, 2381, 'customer-contacts', 'ep:user', 'crm/crmcustomercontacts/index', 'CrmCustomerContacts', 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '1', '2024-07-22 15:02:19', b'0');
INSERT INTO `system_menu` VALUES (2389, '联系人查询', 'crm:customer-contacts:query', 3, 1, 2388, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '', '2024-07-21 11:35:11', b'0');
INSERT INTO `system_menu` VALUES (2390, '联系人创建', 'crm:customer-contacts:create', 3, 2, 2388, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '', '2024-07-21 11:35:11', b'0');
INSERT INTO `system_menu` VALUES (2391, '联系人更新', 'crm:customer-contacts:update', 3, 3, 2388, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '', '2024-07-21 11:35:11', b'0');
INSERT INTO `system_menu` VALUES (2392, '联系人删除', 'crm:customer-contacts:delete', 3, 4, 2388, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '', '2024-07-21 11:35:11', b'0');
INSERT INTO `system_menu` VALUES (2393, '联系人导出', 'crm:customer-contacts:export', 3, 5, 2388, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-21 11:35:11', '', '2024-07-21 11:35:11', b'0');
INSERT INTO `system_menu` VALUES (2394, '跟进记录', '', 2, 3, 2381, 'record', 'ep:bicycle', 'crm/crmrecord/index', 'CrmRecord', 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '1', '2024-07-23 15:59:42', b'0');
INSERT INTO `system_menu` VALUES (2395, '跟进记录查询', 'crm:record:query', 3, 1, 2394, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '', '2024-07-23 15:43:12', b'0');
INSERT INTO `system_menu` VALUES (2396, '跟进记录创建', 'crm:record:create', 3, 2, 2394, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '', '2024-07-23 15:43:12', b'0');
INSERT INTO `system_menu` VALUES (2397, '跟进记录更新', 'crm:record:update', 3, 3, 2394, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '', '2024-07-23 15:43:12', b'0');
INSERT INTO `system_menu` VALUES (2398, '跟进记录删除', 'crm:record:delete', 3, 4, 2394, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '', '2024-07-23 15:43:12', b'0');
INSERT INTO `system_menu` VALUES (2399, '跟进记录导出', 'crm:record:export', 3, 5, 2394, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-23 15:43:12', '', '2024-07-23 15:43:12', b'0');
INSERT INTO `system_menu` VALUES (2400, '公海客户', '', 2, 2, 2381, 'opencustomer', 'ep:drizzling', 'crm/crmopencustomer/index', 'Opencustomer', 0, b'1', b'1', b'1', '1', '2024-07-26 15:17:53', '1', '2024-07-26 15:17:53', b'0');
INSERT INTO `system_menu` VALUES (2401, '客户查重', '', 2, 4, 2381, 'repeatcustome', 'ep:search', 'crm/crmrepeatcustomer/index', 'Repeatcustome', 0, b'1', b'1', b'1', '1', '2024-07-26 16:39:52', '1', '2024-07-26 16:39:52', b'0');
INSERT INTO `system_menu` VALUES (2402, '商机管理', '', 1, 20, 0, '/business', 'ep:money', '', '', 0, b'1', b'1', b'1', '1', '2024-07-27 11:03:36', '1', '2024-07-27 11:03:36', b'0');
INSERT INTO `system_menu` VALUES (2403, '商机需求', '', 2, 0, 2402, 'business', 'ep:office-building', 'crm/crmbusiness/index', 'CrmBusiness', 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '1', '2024-07-27 15:52:49', b'0');
INSERT INTO `system_menu` VALUES (2404, '商机查询', 'crm:business:query', 3, 1, 2403, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '', '2024-07-27 15:39:59', b'0');
INSERT INTO `system_menu` VALUES (2405, '商机创建', 'crm:business:create', 3, 2, 2403, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '', '2024-07-27 15:39:59', b'0');
INSERT INTO `system_menu` VALUES (2406, '商机更新', 'crm:business:update', 3, 3, 2403, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '', '2024-07-27 15:39:59', b'0');
INSERT INTO `system_menu` VALUES (2407, '商机删除', 'crm:business:delete', 3, 4, 2403, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '', '2024-07-27 15:39:59', b'0');
INSERT INTO `system_menu` VALUES (2408, '商机导出', 'crm:business:export', 3, 5, 2403, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-27 15:39:59', '', '2024-07-27 15:39:59', b'0');
INSERT INTO `system_menu` VALUES (2409, '跟进记录', '', 2, 1, 2402, 'businessrecord', 'ep:bicycle', 'crm/crmbusinessrecord/index', 'CrmBusinessrRecord', 0, b'1', b'1', b'1', '1', '2024-07-29 19:02:05', '1', '2024-07-29 19:07:33', b'0');
INSERT INTO `system_menu` VALUES (2410, '线索管理', '', 1, 30, 0, '/clues', 'ep:paperclip', '', '', 0, b'1', b'1', b'1', '1', '2024-07-30 15:34:07', '1', '2024-07-30 15:34:07', b'0');
INSERT INTO `system_menu` VALUES (2411, '线索管理', '', 2, 0, 2410, 'clues', 'ep:aim', 'crm/crmclues/index', 'CrmClues', 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '1', '2024-07-30 15:42:47', b'0');
INSERT INTO `system_menu` VALUES (2412, '线索查询', 'crm:clues:query', 3, 1, 2411, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '', '2024-07-30 15:35:33', b'0');
INSERT INTO `system_menu` VALUES (2413, '线索创建', 'crm:clues:create', 3, 2, 2411, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '', '2024-07-30 15:35:33', b'0');
INSERT INTO `system_menu` VALUES (2414, '线索更新', 'crm:clues:update', 3, 3, 2411, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '', '2024-07-30 15:35:33', b'0');
INSERT INTO `system_menu` VALUES (2415, '线索删除', 'crm:clues:delete', 3, 4, 2411, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '', '2024-07-30 15:35:33', b'0');
INSERT INTO `system_menu` VALUES (2416, '线索导出', 'crm:clues:export', 3, 5, 2411, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-07-30 15:35:33', '', '2024-07-30 15:35:33', b'0');
INSERT INTO `system_menu` VALUES (2417, '线索池', '', 2, 1, 2410, 'openclues', 'ep:drizzling', 'crm/crmopenclues/index', 'Openclues', 0, b'1', b'1', b'1', '1', '2024-07-31 10:35:31', '1', '2024-07-31 10:36:57', b'0');
INSERT INTO `system_menu` VALUES (2418, '跟进记录', '', 2, 2, 2410, 'cluesrecord', 'ep:bicycle', 'crm/crmcluesrecord/index', 'Cluesrecord', 0, b'1', b'1', b'1', '1', '2024-07-31 18:13:56', '1', '2024-07-31 18:13:56', b'0');
INSERT INTO `system_menu` VALUES (2419, '合同管理', '', 1, 40, 0, '/contract', 'ep:folder-opened', '', '', 0, b'1', b'1', b'1', '1', '2024-08-01 18:29:19', '1', '2024-08-01 18:29:19', b'0');
INSERT INTO `system_menu` VALUES (2420, '我的合同', '', 2, 0, 2419, 'contract', 'ep:edit', 'crm/crmcontract/index', 'CrmContract', 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '1', '2024-08-16 16:36:48', b'0');
INSERT INTO `system_menu` VALUES (2421, '合同查询', 'crm:contract:query', 3, 1, 2420, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '', '2024-08-05 11:19:21', b'0');
INSERT INTO `system_menu` VALUES (2422, '合同创建', 'crm:contract:create', 3, 2, 2420, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '', '2024-08-05 11:19:21', b'0');
INSERT INTO `system_menu` VALUES (2423, '合同更新', 'crm:contract:update', 3, 3, 2420, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '', '2024-08-05 11:19:21', b'0');
INSERT INTO `system_menu` VALUES (2424, '合同删除', 'crm:contract:delete', 3, 4, 2420, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '', '2024-08-05 11:19:21', b'0');
INSERT INTO `system_menu` VALUES (2425, '合同导出', 'crm:contract:export', 3, 5, 2420, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-05 11:19:21', '', '2024-08-05 11:19:21', b'0');
INSERT INTO `system_menu` VALUES (2426, '审批流程', '', 1, 60, 0, '/flow', 'ep:flag', '', '', 0, b'1', b'1', b'1', '1', '2024-08-07 16:53:15', '1', '2024-08-15 20:15:57', b'0');
INSERT INTO `system_menu` VALUES (2427, '审批管理', '', 2, 0, 2426, 'flow', 'ep:caret-right', 'crm/crmflow/index', 'CrmFlow', 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '1', '2024-08-07 18:19:14', b'0');
INSERT INTO `system_menu` VALUES (2428, '审批流程查询', 'crm:flow:query', 3, 1, 2427, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '', '2024-08-07 17:40:38', b'0');
INSERT INTO `system_menu` VALUES (2429, '审批流程创建', 'crm:flow:create', 3, 2, 2427, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '', '2024-08-07 17:40:38', b'0');
INSERT INTO `system_menu` VALUES (2430, '审批流程更新', 'crm:flow:update', 3, 3, 2427, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '', '2024-08-07 17:40:38', b'0');
INSERT INTO `system_menu` VALUES (2431, '审批流程删除', 'crm:flow:delete', 3, 4, 2427, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '', '2024-08-07 17:40:38', b'0');
INSERT INTO `system_menu` VALUES (2432, '审批流程导出', 'crm:flow:export', 3, 5, 2427, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-07 17:40:38', '', '2024-08-07 17:40:38', b'0');
INSERT INTO `system_menu` VALUES (2433, '我的回款', '', 2, 2, 2419, 'contract-receivables', 'ep:expand', 'crm/crmcontractreceivables/index', 'CrmContractReceivables', 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '1', '2024-08-16 16:37:02', b'0');
INSERT INTO `system_menu` VALUES (2434, '回款查询', 'crm:contract-receivables:query', 3, 1, 2433, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '', '2024-08-13 10:53:15', b'0');
INSERT INTO `system_menu` VALUES (2435, '回款创建', 'crm:contract-receivables:create', 3, 2, 2433, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '', '2024-08-13 10:53:15', b'0');
INSERT INTO `system_menu` VALUES (2436, '回款更新', 'crm:contract-receivables:update', 3, 3, 2433, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '', '2024-08-13 10:53:15', b'0');
INSERT INTO `system_menu` VALUES (2437, '回款删除', 'crm:contract-receivables:delete', 3, 4, 2433, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '', '2024-08-13 10:53:15', b'0');
INSERT INTO `system_menu` VALUES (2438, '回款导出', 'crm:contract-receivables:export', 3, 5, 2433, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-13 10:53:15', '', '2024-08-13 10:53:15', b'0');
INSERT INTO `system_menu` VALUES (2439, '发票管理', '', 1, 50, 0, '/invoice', 'ep:collection-tag', '', '', 0, b'1', b'1', b'1', '1', '2024-08-15 17:39:26', '1', '2024-08-15 20:16:06', b'0');
INSERT INTO `system_menu` VALUES (2440, '我的发票', '', 2, 0, 2439, 'invoice', 'ep:collection-tag', 'crm/crminvoice/index', 'CrmInvoice', 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '1', '2024-08-16 16:36:25', b'0');
INSERT INTO `system_menu` VALUES (2441, '发票查询', 'crm:invoice:query', 3, 1, 2440, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '', '2024-08-15 17:44:41', b'0');
INSERT INTO `system_menu` VALUES (2442, '发票创建', 'crm:invoice:create', 3, 2, 2440, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '', '2024-08-15 17:44:41', b'0');
INSERT INTO `system_menu` VALUES (2443, '发票更新', 'crm:invoice:update', 3, 3, 2440, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '', '2024-08-15 17:44:41', b'0');
INSERT INTO `system_menu` VALUES (2444, '发票删除', 'crm:invoice:delete', 3, 4, 2440, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '', '2024-08-15 17:44:41', b'0');
INSERT INTO `system_menu` VALUES (2445, '发票导出', 'crm:invoice:export', 3, 5, 2440, '', '', '', NULL, 0, b'1', b'1', b'1', '', '2024-08-15 17:44:41', '', '2024-08-15 17:44:41', b'0');
INSERT INTO `system_menu` VALUES (2446, '全部合同', '', 2, 1, 2419, 'contractall', 'ep:baseball', 'crm/crmcontract/index2', 'CrmContractAll', 0, b'1', b'1', b'1', '1', '2024-08-16 16:33:09', '1', '2024-08-17 16:13:24', b'1');
INSERT INTO `system_menu` VALUES (2447, '全部回款', '', 2, 3, 2419, 'contract-receivables-all', 'ep:basketball', 'crm/crmcontractreceivables/index2', 'CrmContractReceivablesAll', 0, b'1', b'1', b'1', '1', '2024-08-16 16:34:37', '1', '2024-08-17 16:13:29', b'1');
INSERT INTO `system_menu` VALUES (2448, '全部发票', '', 2, 1, 2439, 'invoiceall', 'ep:baseball', 'crm/crminvoice/index2', 'CrmInvoiceAll', 0, b'1', b'1', b'1', '1', '2024-08-16 16:36:06', '1', '2024-08-17 16:13:35', b'1');
COMMIT;

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `pic_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
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
INSERT INTO `system_notice` VALUES (1, 'B2C单商户微服务-统计报表功能正式发布！', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '<p>新版本内容133</p>', 1, 0, 'admin', '2021-01-05 17:03:48', '1', '2024-05-06 17:58:44', b'0', 1);
INSERT INTO `system_notice` VALUES (2, '618最后三天,你还不来', 'https://apidc.yixiang.co/admin-api/infra/file/4/get/ad0cc3947ff9a41caceab6207e13982beed27559b9bfc311128e5992cc702056.jpg', '<p>618最后三天,你还不来618最后三天,你还不来618最后三天,你还不来618最后三天,你还不来</p>', 2, 0, 'admin', '2021-01-05 17:03:48', '1', '2024-05-31 18:02:57', b'0', 1);
INSERT INTO `system_notice` VALUES (4, 'YSHOP-PRO 预售开始啦', NULL, '<p>哈哈哈哈123</p>', 1, 0, '110', '2022-02-22 01:01:25', '1', '2023-07-26 14:29:42', b'0', 121);
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
) ENGINE=InnoDB AUTO_INCREMENT=4717 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 访问令牌';

-- ----------------------------
-- Records of system_oauth2_access_token
-- ----------------------------
BEGIN;
INSERT INTO `system_oauth2_access_token` VALUES (4716, 1, 2, '{\"nickname\":\"yshop\",\"deptId\":\"100\"}', 'd02f2cc6e15a44fdbb747d66ff8e688e', 'f5f73be375494ca5b0ff7f1882b078f0', 'default', NULL, '2025-04-03 23:44:07', NULL, '2024-09-07 15:44:07', NULL, '2024-09-07 15:44:07', b'0', 0, 0);
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
INSERT INTO `system_oauth2_client` VALUES (1, 'default', 'admin123', 'yshop', 'http://www.yixiang.co/a5e2e244368878a366b516805a4aabf1.png', '我是描述', 0, 18000000, 43200, '[\"https://www.yixiang.co\",\"https://www.yixiang.co\"]', '[\"password\",\"authorization_code\",\"implicit\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[\"user.read\",\"user.write\"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2024-03-30 15:05:17', b'0');
INSERT INTO `system_oauth2_client` VALUES (40, 'test', 'test2', 'biubiu', 'http://www.yixiang.co/277a899d573723f1fcdfb57340f00379.png', NULL, 0, 1800, 43200, '[\"https://www.yixiang.co\"]', '[\"password\",\"authorization_code\",\"implicit\"]', '[\"user_info\",\"projects\"]', '[\"user_info\"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1', '2024-03-30 15:05:19', b'0');
INSERT INTO `system_oauth2_client` VALUES (41, 'yshop-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？', 'http://www.yixiang.co/fe4ed36596adad5120036ef61a6d0153654544d44af8dd4ad3ffe8f759933d6f.png', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"authorization_code\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-09-29 13:28:31', '1', '2024-03-30 15:05:21', b'0');
INSERT INTO `system_oauth2_client` VALUES (42, 'yshop-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？', 'http://www.yixiang.co/604bdc695e13b3b22745be704d1f2aa8ee05c5f26f9fead6d1ca49005afbc857.jpeg', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"password\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-10-04 17:40:16', '1', '2024-03-30 15:05:26', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=3031 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth2 刷新令牌';

-- ----------------------------
-- Records of system_oauth2_refresh_token
-- ----------------------------
BEGIN;
INSERT INTO `system_oauth2_refresh_token` VALUES (3030, 1, 'f5f73be375494ca5b0ff7f1882b078f0', 2, 'default', NULL, '2024-09-08 03:44:07', NULL, '2024-09-07 15:44:07', NULL, '2024-09-07 15:44:07', b'0', 0, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=9040 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录 V2 版本';

-- ----------------------------
-- Records of system_operate_log
-- ----------------------------
BEGIN;
INSERT INTO `system_operate_log` VALUES (9038, '', 1, 2, 'SYSTEM 用户', '重置用户密码', 129, '将用户【yshop001】的密码从【$2a$04$sKk9/vh2HPvBSdoDC6juNuokGM6U3kHVLEEOBPNL35HBK6EkEbNay】重置为【$2a$04$JKbLWjsQRdNsdkpyj9pEF.6daLJrleJ85qBCruvzYXTxCsNwo3md6】', '', 'PUT', '/admin-api/system/user/update-password', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL, '2024-06-14 00:41:48', NULL, '2024-06-14 00:41:48', b'0', 1);
INSERT INTO `system_operate_log` VALUES (9039, '', 1, 2, 'SYSTEM 用户', '更新用户', 1, '更新了用户【yshop】: 【部门】从【研发部门】修改为【yshop公司】', '', 'PUT', '/admin-api/system/user/update', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', NULL, '2024-07-24 17:28:30', NULL, '2024-07-24 17:28:30', b'0', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

-- ----------------------------
-- Records of system_role
-- ----------------------------
BEGIN;
INSERT INTO `system_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:21', b'0', 1);
INSERT INTO `system_role` VALUES (2, '门店角色', 'common', 2, 1, '[]', 0, 2, '普通角色', 'admin', '2021-01-05 17:03:48', '1', '2024-08-12 16:51:02', b'0', 1);
INSERT INTO `system_role` VALUES (140, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2024-03-26 18:14:45', '1', '2024-03-26 18:14:45', b'0', 151);
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
) ENGINE=InnoDB AUTO_INCREMENT=3604 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

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
) ENGINE=InnoDB AUTO_INCREMENT=571 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='手机验证码';

-- ----------------------------
-- Records of system_sms_code
-- ----------------------------
BEGIN;
INSERT INTO `system_sms_code` VALUES (566, '15136172213', '9999', '0:0:0:0:0:0:0:1', 1, 1, 1, '2024-03-31 15:39:27', '0:0:0:0:0:0:0:1', NULL, '2024-03-31 15:39:19', NULL, '2024-03-31 15:39:27', b'0', 1);
INSERT INTO `system_sms_code` VALUES (567, '15136123344', '9999', '0:0:0:0:0:0:0:1', 1, 1, 1, '2024-03-31 15:40:49', '0:0:0:0:0:0:0:1', NULL, '2024-03-31 15:40:10', NULL, '2024-03-31 15:40:49', b'0', 1);
INSERT INTO `system_sms_code` VALUES (568, '15136175545', '9999', '0:0:0:0:0:0:0:1', 1, 1, 1, '2024-03-31 15:43:11', '0:0:0:0:0:0:0:1', NULL, '2024-03-31 15:43:06', NULL, '2024-03-31 15:43:11', b'0', 1);
INSERT INTO `system_sms_code` VALUES (569, '15136175545', '9999', '0:0:0:0:0:0:0:1', 1, 2, 1, '2024-03-31 15:47:18', '0:0:0:0:0:0:0:1', NULL, '2024-03-31 15:47:11', NULL, '2024-03-31 15:47:18', b'0', 1);
INSERT INTO `system_sms_code` VALUES (570, '13733990534', '9999', '0:0:0:0:0:0:0:1', 1, 1, 1, '2024-04-19 17:06:12', '0:0:0:0:0:0:0:1', NULL, '2024-04-19 17:06:08', NULL, '2024-04-19 17:06:12', b'0', 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=438 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信日志';

-- ----------------------------
-- Records of system_sms_log
-- ----------------------------
BEGIN;
INSERT INTO `system_sms_log` VALUES (431, 6, 'DEBUG_DING_TALK', 8, 'user-sms-login', 1, '您的验证码是9999', '{\"code\":\"9999\"}', '4372216', '15136172213', NULL, NULL, 10, '2024-03-31 15:39:20', 0, '成功', '0', NULL, NULL, '19c276b9-6f82-42d2-bb7d-f1a0074ff421', 0, NULL, NULL, NULL, NULL, '2024-03-31 15:39:19', NULL, '2024-03-31 15:39:20', b'0');
INSERT INTO `system_sms_log` VALUES (432, 6, 'DEBUG_DING_TALK', 8, 'user-sms-login', 1, '您的验证码是9999', '{\"code\":\"9999\"}', '4372216', '15136123344', NULL, NULL, 10, '2024-03-31 15:40:11', 0, '成功', '0', NULL, NULL, 'd8839e47-8a45-4764-b7c6-ee323f8f499f', 0, NULL, NULL, NULL, NULL, '2024-03-31 15:40:10', NULL, '2024-03-31 15:40:11', b'0');
INSERT INTO `system_sms_log` VALUES (433, 6, 'DEBUG_DING_TALK', 8, 'user-sms-login', 1, '您的验证码是9999', '{\"code\":\"9999\"}', '4372216', '15136175545', NULL, NULL, 10, '2024-03-31 15:43:06', 0, '成功', '0', NULL, NULL, '0d76cd10-f6b8-4004-ad92-75cabc85c023', 0, NULL, NULL, NULL, NULL, '2024-03-31 15:43:06', NULL, '2024-03-31 15:43:06', b'0');
INSERT INTO `system_sms_log` VALUES (434, 6, 'DEBUG_DING_TALK', 8, 'user-sms-login', 1, '您的验证码是9999', '{\"code\":\"9999\"}', '4372216', '15136175545', NULL, NULL, 10, '2024-03-31 15:47:11', 0, '成功', '0', NULL, NULL, 'edd3e808-2fc3-44b9-b370-ba1a0c004724', 0, NULL, NULL, NULL, NULL, '2024-03-31 15:47:11', NULL, '2024-03-31 15:47:11', b'0');
INSERT INTO `system_sms_log` VALUES (435, 6, 'DEBUG_DING_TALK', 8, 'user-sms-login', 1, '您的验证码是9999', '{\"code\":\"9999\"}', '4372216', '13733990534', NULL, NULL, 10, '2024-04-19 17:06:09', 0, '成功', '0', NULL, NULL, 'da3771b9-508a-4ffc-abcd-c74279a29241', 0, NULL, NULL, NULL, NULL, '2024-04-19 17:06:08', NULL, '2024-04-19 17:06:09', b'0');
INSERT INTO `system_sms_log` VALUES (436, 6, 'DEBUG_DING_TALK', 12, 'demo', 2, '我就是测试一下下', '{}', 'biubiubiu', '17777777777', 71, 3, 10, '2024-09-10 15:56:13', NULL, NULL, '0', NULL, NULL, '83c17a9f-4b46-41df-a172-17bd7a00de2e', 0, NULL, NULL, NULL, '1', '2024-09-10 15:56:12', NULL, '2024-09-10 15:56:13', b'0');
INSERT INTO `system_sms_log` VALUES (437, 6, 'DEBUG_DING_TALK', 12, 'demo', 2, '我就是测试一下下', '{}', 'biubiubiu', '17777777777', 67, 3, 10, '2024-09-11 10:27:41', NULL, NULL, '0', NULL, NULL, 'f71e22aa-8245-46da-9406-f680bd3b7659', 0, NULL, NULL, NULL, '1', '2024-09-11 10:27:40', NULL, '2024-09-11 10:27:41', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

-- ----------------------------
-- Records of system_tenant
-- ----------------------------
BEGIN;
INSERT INTO `system_tenant` VALUES (1, 'yshop', NULL, 'yshop_driink', '17321315478', 0, 'https://www.yixiang.co', 0, '2099-02-19 17:14:16', 9999, '1', '2021-01-05 17:03:47', '1', '2024-03-26 17:11:05', b'0');
INSERT INTO `system_tenant` VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'https://www.yixiang.co', 111, '2024-03-11 00:00:00', 20, '1', '2022-02-22 00:56:14', '1', '2024-03-26 18:07:46', b'1');
INSERT INTO `system_tenant` VALUES (122, '测试租户', 113, 'yshop_drink', '15601691300', 0, 'https://www.yixiang.co', 111, '2022-04-30 00:00:00', 50, '1', '2022-03-07 21:37:58', '1', '2024-03-26 18:07:44', b'1');
INSERT INTO `system_tenant` VALUES (151, 'yshop租户', 127, 'yshop-drink', '18000000000', 0, 'https://www.yixiang.co', 111, '2024-04-30 00:00:00', 2, '1', '2024-03-26 18:14:45', '1', '2024-03-30 11:40:13', b'0');
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
INSERT INTO `system_tenant_package` VALUES (111, '普通套餐', 0, '小功能', '[2304,2305,1,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,1036,2317,1037,2318,1038,2319,1039,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2336,2337,2338,2339,2340,2341,2342,2343,1063,2344,1064,2345,1065,1117,100,101,103,107,2162,2163,2164,2165,2166,2167,2168,2169,2170,2171,2172,2173,2174,2175,2176,2183,2184,2185,2186,2187,2188,2207,2208,2209,2210,2211,2212,2213,2214,2215,2216,2217,2218,2231,2232,2233,2234,2235,2236,2237,2238,2239,2240,2241,2242,2243,2244,2000,2002,2003,2004,2005,2006,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2274,2275,2276,2277,2278,2279,2280,2281,1001,2282,1002,2283,1003,2284,1004,2285,1005,2286,1006,2287,1007,2288,1008,2289,1009,2290,1010,2291,1011,2292,1012,2293,2294,2295,2296,2297,1017,2298,1018,2299,1019,2300,1020,2301,2302,2303]', '1', '2022-02-22 00:54:00', '1', '2024-03-26 18:06:26', b'0');
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

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
INSERT INTO `system_user_role` VALUES (32, 127, 140, '1', '2024-03-26 18:14:45', '1', '2024-03-26 18:14:45', b'0', 151);
INSERT INTO `system_user_role` VALUES (33, 129, 2, '1', '2024-06-14 00:45:12', '1', '2024-06-14 00:45:12', b'0', 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ----------------------------
-- Records of system_users
-- ----------------------------
BEGIN;
INSERT INTO `system_users` VALUES (1, 'admin', '', 'yshop', '管理员', 100, '[1]', 'yshop@yixaing.co', '18000000000', 1, 'https://app2.yixiang.co/avatar/20200705181403641316.png', 0, '0:0:0:0:0:0:0:1', '2024-09-07 15:44:07', 'admin', '2021-01-05 17:03:47', NULL, '2024-09-07 15:44:07', b'0', 1);
INSERT INTO `system_users` VALUES (100, 'yshop', '', 'yixiang', '不要吓我', 104, '[1]', 'yshop@iocoder.cn', '15601691300', 1, '', 0, '0:0:0:0:0:0:0:1', '2024-08-16 15:23:08', '', '2021-01-07 09:07:17', NULL, '2024-08-16 15:23:08', b'0', 1);
INSERT INTO `system_users` VALUES (126, 'yixiang001', '', '意向餐饮管理员', '', 110, '[]', '', '18888888888', 0, '', 0, '0:0:0:0:0:0:0:1', '2024-03-13 18:10:56', '1', '2023-09-05 10:23:17', NULL, '2024-03-13 18:10:56', b'0', 0);
INSERT INTO `system_users` VALUES (127, 'myshop', '', 'yshop-drink', NULL, NULL, NULL, '', '18777777777', 0, '', 0, '0:0:0:0:0:0:0:1', '2024-04-02 08:18:32', '1', '2024-03-26 18:14:45', NULL, '2024-07-24 17:28:10', b'0', 151);
INSERT INTO `system_users` VALUES (128, 'my002', '', 'my002', '', NULL, '[]', '', '', 0, '', 0, '', NULL, '127', '2024-04-02 08:19:04', '127', '2024-04-02 08:19:04', b'0', 151);
INSERT INTO `system_users` VALUES (129, 'yshop001', '', 'yshop001', '', 103, '[]', '', '', 0, '', 0, '0:0:0:0:0:0:0:1', '2024-08-16 16:39:09', '1', '2024-05-05 11:41:19', NULL, '2024-08-16 16:39:09', b'0', 1);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_business
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_business`;
CREATE TABLE `yshop_crm_business` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商机名称',
  `status` int NOT NULL DEFAULT '1' COMMENT '销售阶段',
  `status_time` datetime DEFAULT NULL COMMENT '阶段推进时间',
  `is_end` tinyint NOT NULL DEFAULT '0' COMMENT '成交状态0洽淡中，1成交2失败3无效',
  `next_time` datetime NOT NULL COMMENT '下次联系时间',
  `money` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '商机金额',
  `total_price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '产品总金额',
  `deal_time` datetime DEFAULT NULL COMMENT '预计成交日期',
  `discount_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '整单折扣',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `owner_user_id` bigint NOT NULL DEFAULT '0' COMMENT '负责人ID',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商机表';

-- ----------------------------
-- Records of yshop_crm_business
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_business` VALUES (3, 73, '联通商机001', 1, NULL, 0, '2024-09-11 10:59:04', 1000.00, 499.00, NULL, 0.00, NULL, 1, '2024-09-11 10:59:24', '2024-09-11 10:59:24', '1', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_business_product
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_business_product`;
CREATE TABLE `yshop_crm_business_product` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `business_id` bigint DEFAULT '0' COMMENT '商机id',
  `product_id` bigint NOT NULL DEFAULT '0' COMMENT '产品id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `product_attr_unique` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品属性',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '单价',
  `nums` int DEFAULT '0' COMMENT '数量',
  `subtotal` decimal(10,2) DEFAULT '0.00' COMMENT '小计',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商机产品关联表';

-- ----------------------------
-- Records of yshop_crm_business_product
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_business_product` VALUES (11, 3, 27, '点餐系统', 'f598fc6319a246b2832f23fd5b6f6f16', 499.00, 1, 499.00, NULL, '2024-09-11 10:59:24', '2024-09-11 10:59:24', '1', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_clues
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_clues`;
CREATE TABLE `yshop_crm_clues` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '线索',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机',
  `telephone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态-1-无效线索，0未转客户,1转成客户',
  `customer_id` bigint NOT NULL DEFAULT '0' COMMENT '转成客户id',
  `change_time` datetime DEFAULT NULL COMMENT '转客户时间',
  `level` int NOT NULL DEFAULT '0' COMMENT '客户级别ID',
  `industry` int NOT NULL DEFAULT '0' COMMENT '客户行业ID',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT ' 客户标签',
  `source` int NOT NULL DEFAULT '0' COMMENT '客户来源ID',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `owner_user_id` bigint NOT NULL DEFAULT '0' COMMENT '负责人ID',
  `province` int DEFAULT '0' COMMENT '省份id',
  `city` int DEFAULT '0' COMMENT '城市ID',
  `area` int DEFAULT '0' COMMENT '区域ID',
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `next_time` datetime DEFAULT NULL COMMENT '下次联系时间',
  `follow_time` datetime DEFAULT NULL COMMENT '最后跟进时间',
  `collect_time` datetime DEFAULT NULL COMMENT '领取时间',
  `follow_status` tinyint(1) DEFAULT '1' COMMENT '跟进状态1|新客\n2|待再次沟通\n3|有意向\n4|已加微信\n5|转商机\n0|无效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='线索表';

-- ----------------------------
-- Records of yshop_crm_clues
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_clues` VALUES (21, 'yshop', '18888888888', '18888888888', 0, 0, NULL, 0, 0, '', 0, 'yshop', 1, 0, 0, 0, '详细地址', NULL, NULL, NULL, 1, '2024-09-11 14:59:09', '1', '2024-09-11 14:59:09', '1', b'0', 0);
INSERT INTO `yshop_crm_clues` VALUES (22, 'yshop2', '18888888888=0', '18888888880', 0, 0, NULL, 0, 0, '', 0, 'yshop2', 100, 0, 0, 0, '详细地址2', NULL, NULL, '2024-09-11 15:14:07', 1, '2024-09-11 14:59:09', '1', '2024-09-11 14:59:09', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_contract
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_contract`;
CREATE TABLE `yshop_crm_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `customer_id` bigint NOT NULL DEFAULT '0' COMMENT '客户ID',
  `business_id` bigint NOT NULL DEFAULT '0' COMMENT '商机ID',
  `contacts_id` bigint NOT NULL DEFAULT '0' COMMENT '客户签约人（联系人ID）',
  `source_id` int DEFAULT '0' COMMENT '客户来源ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '合同名称',
  `number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '合同编号',
  `order_time` datetime DEFAULT NULL COMMENT '下单时间',
  `money` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '合同金额',
  `total_price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '产品总金额',
  `return_money` decimal(10,2) DEFAULT '0.00' COMMENT '已收到款项',
  `discount_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '整单折扣',
  `check_status` tinyint NOT NULL DEFAULT '0' COMMENT '0待审核、1审核中、2审核通过、3审核未通过',
  `flow_id` bigint NOT NULL DEFAULT '0' COMMENT '审核流程ID',
  `step_id` bigint NOT NULL DEFAULT '0' COMMENT '审核步骤ID',
  `check_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '已经审批人IDs',
  `flow_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '当前需要审批的人',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `order_admin_id` bigint DEFAULT '0' COMMENT '公司签约人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `owner_user_id` bigint NOT NULL DEFAULT '0' COMMENT '负责人ID',
  `next_time` datetime DEFAULT NULL COMMENT '下次联系时间',
  `expire_handle` tinyint DEFAULT '0' COMMENT '0合同过期未处理1已续签2不再合作',
  `invoice_money` decimal(10,2) DEFAULT '0.00' COMMENT '已开票金额',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='合同表';

-- ----------------------------
-- Records of yshop_crm_contract
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_contract` VALUES (8, 73, 3, 0, 0, '新合同', 'HT202409121000', '2024-09-12 00:00:00', 999.00, 499.00, 0.00, 0.00, 0, 4, 13, '', '1', '2024-09-12 11:15:50', '2024-09-19 00:00:00', 1, NULL, 1, NULL, 0, 0.00, '2024-09-12 11:16:29', '1', '2024-09-12 11:16:30', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_contract_product
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_contract_product`;
CREATE TABLE `yshop_crm_contract_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `contract_id` bigint NOT NULL DEFAULT '0' COMMENT '合同ID',
  `product_id` bigint NOT NULL DEFAULT '0' COMMENT '产品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `product_attr_unique` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品属性',
  `price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '产品单价',
  `nums` int NOT NULL DEFAULT '0' COMMENT '数量',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '折扣',
  `subtotal` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '小计（折扣后价格）',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '逻辑删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='合同产品关系表';

-- ----------------------------
-- Records of yshop_crm_contract_product
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_contract_product` VALUES (20, 8, 27, '点餐系统', 'f598fc6319a246b2832f23fd5b6f6f16', 499.00, 1, 0.00, 499.00, NULL, '2024-09-11 10:59:24', '2024-09-11 10:59:24', '1', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_contract_receivables
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_contract_receivables`;
CREATE TABLE `yshop_crm_contract_receivables` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '回款编号',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `contract_id` bigint NOT NULL COMMENT '合同ID',
  `return_time` datetime DEFAULT NULL COMMENT '回款日期',
  `account_id` int NOT NULL COMMENT '收款账户ID',
  `money` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '回款金额',
  `check_status` tinyint NOT NULL DEFAULT '0' COMMENT '0待审核、1审核中、2审核通过、3审核未通过',
  `flow_id` bigint NOT NULL DEFAULT '0' COMMENT '审核流程ID',
  `step_id` bigint NOT NULL DEFAULT '0' COMMENT '审核步骤排序ID',
  `check_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '审批人IDs',
  `flow_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '流程审批人ID',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `owner_user_id` bigint NOT NULL DEFAULT '0' COMMENT '负责人ID',
  `order_admin_id` bigint DEFAULT NULL COMMENT '合同签约人',
  `pay_status` tinyint DEFAULT '0' COMMENT '在线支付状态1已付款0未付款',
  `pay_type` tinyint DEFAULT '1' COMMENT '收款方式1默认2在线收款3续费',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回款表';

-- ----------------------------
-- Records of yshop_crm_contract_receivables
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_customer
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_customer`;
CREATE TABLE `yshop_crm_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '客户名称',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机',
  `telephone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话',
  `deal_status` int NOT NULL DEFAULT '0' COMMENT '成交状态0未成交1成交',
  `deal_time` datetime DEFAULT NULL COMMENT '成交时间',
  `is_lock` tinyint(1) DEFAULT '0' COMMENT '1锁定',
  `level` int NOT NULL DEFAULT '0' COMMENT '客户级别ID',
  `industry` int NOT NULL DEFAULT '0' COMMENT '客户行业ID',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT ' 客户标签',
  `source` int NOT NULL DEFAULT '0' COMMENT '客户来源ID',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `user_id` int DEFAULT '0' COMMENT '前台用户ID',
  `owner_user_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `province` int DEFAULT '0' COMMENT '省份id',
  `city` int DEFAULT '0' COMMENT '城市ID',
  `area` int DEFAULT '0' COMMENT '区域ID',
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `lng` double(14,11) DEFAULT NULL COMMENT '地理位置经度',
  `lat` double(14,11) DEFAULT NULL COMMENT '地理位置维度',
  `next_time` datetime DEFAULT NULL COMMENT '下次联系时间',
  `follow_time` datetime DEFAULT NULL COMMENT '最后跟进时间',
  `collect_time` datetime DEFAULT NULL COMMENT '领取时间',
  `weixin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '微信',
  `qq` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'QQ',
  `purchase_total` decimal(18,2) DEFAULT '0.00' COMMENT '消费总额',
  `purchase_times` int DEFAULT '0' COMMENT '消费次数',
  `follow_status` tinyint(1) DEFAULT '1' COMMENT '跟进状态1|新客\n2|待再次沟通\n3|有意向\n4|已加微信\n5|转商机\n0|无效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='客户表';

-- ----------------------------
-- Records of yshop_crm_customer
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_customer` VALUES (68, '客户0012', '18888888888', '', 0, NULL, 0, 3, 9, '', 0, NULL, 0, 100, 0, 0, 0, '', NULL, NULL, NULL, '2024-08-27 17:16:24', '2024-09-09 16:22:21', '', NULL, 0.00, 0, 1, '2024-08-27 17:16:24', '1', '2024-08-27 17:17:01', '1', b'0', 0);
INSERT INTO `yshop_crm_customer` VALUES (69, 'yshop', '18888888888', '18888888888', 0, NULL, 0, 0, 0, '重要,厉害', 0, 'yshop', 0, 100, 0, 0, 0, '详细地址', 10.10000000000, 10.20000000000, NULL, NULL, '2024-09-09 16:22:21', 'wechat', '100000', 0.00, 0, 1, '2024-09-08 18:05:26', '1', '2024-09-08 18:05:26', '1', b'0', 0);
INSERT INTO `yshop_crm_customer` VALUES (70, 'yshop2', '18888888888=0', '18888888880', 0, NULL, 0, 0, 0, '重要2,厉害', 0, 'yshop2', 0, 100, 0, 0, 0, '详细地址2', 10.10000000000, 10.20000000000, NULL, NULL, '2024-09-09 16:22:21', 'wechat2', '1000002', 0.00, 0, 1, '2024-09-08 18:05:26', '1', '2024-09-08 18:05:26', '1', b'0', 0);
INSERT INTO `yshop_crm_customer` VALUES (71, '电信客户', '17777777777', '17777777777', 0, NULL, 0, 3, 9, '', 0, NULL, 0, 0, 0, 0, 0, '', NULL, NULL, NULL, '2024-09-09 16:24:11', '2024-09-09 16:24:11', '', NULL, 0.00, 0, 1, '2024-09-09 16:24:11', '1', '2024-09-09 16:24:11', '1', b'0', 0);
INSERT INTO `yshop_crm_customer` VALUES (72, '阿里云客户', '16666666666', '16666666666', 0, NULL, 0, 1, 9, '牛叉', 0, NULL, 0, 100, 0, 0, 0, '', NULL, NULL, NULL, '2024-09-09 17:03:00', '2024-09-09 17:30:52', '', NULL, 0.00, 0, 1, '2024-09-09 17:03:00', '1', '2024-09-09 17:03:00', '1', b'0', 0);
INSERT INTO `yshop_crm_customer` VALUES (73, '中国联通', '16666666666', '16666666666', 0, NULL, 0, 3, 9, '', 0, NULL, 0, 1, 0, 0, 0, '', NULL, NULL, NULL, '2024-09-11 10:56:28', '2024-09-11 10:56:28', '', NULL, 0.00, 0, 1, '2024-09-11 10:56:28', '1', '2024-09-11 10:56:28', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_customer_contacts
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_customer_contacts`;
CREATE TABLE `yshop_crm_customer_contacts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `telephone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话',
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '微信号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子邮箱',
  `decision` tinyint NOT NULL DEFAULT '-1' COMMENT '是否关键决策人1是0不是-1未知',
  `post` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '职务',
  `sex` tinyint NOT NULL DEFAULT '-1' COMMENT '性别0女1男-1未知',
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `owner_user_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `next_time` datetime DEFAULT NULL COMMENT '下次联系时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='联系人表';

-- ----------------------------
-- Records of yshop_crm_customer_contacts
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_customer_contacts` VALUES (66, 68, '客户001', '18888888888', NULL, '', '', '', -1, '', -1, '', NULL, 100, NULL, '2024-08-27 17:16:24', '1', '2024-09-09 16:22:21', '1', b'0', 0);
INSERT INTO `yshop_crm_customer_contacts` VALUES (67, 71, '电信客户', '17777777777', NULL, '17777777777', '', '222@qq.com', -1, '', -1, '', NULL, 0, NULL, '2024-09-09 16:24:11', '1', '2024-09-11 10:47:28', '1', b'0', 0);
INSERT INTO `yshop_crm_customer_contacts` VALUES (68, 72, '阿里云客户', '16666666666', NULL, '16666666666', '', '', -1, '', -1, '', NULL, 100, NULL, '2024-09-09 17:03:00', '1', '2024-09-09 17:30:52', '1', b'0', 0);
INSERT INTO `yshop_crm_customer_contacts` VALUES (69, 73, '中国联通', '16666666666', NULL, '16666666666', '', '', -1, '', -1, '', NULL, 1, NULL, '2024-09-11 10:56:28', '1', '2024-09-11 10:56:28', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_flow
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_flow`;
CREATE TABLE `yshop_crm_flow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批流名称',
  `types` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联对象 contract-合同 receivables-回款 invoice-发票',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '流程说明',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 1启用，0禁用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批流程表';

-- ----------------------------
-- Records of yshop_crm_flow
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_flow` VALUES (4, '合同审批流程', 'contract', '分步骤审批', 1, '2024-08-08 10:19:53', '1', '2024-08-17 15:52:24', '1', b'0', 0);
INSERT INTO `yshop_crm_flow` VALUES (5, '回款审核', 'receivables', '', 1, '2024-08-13 17:11:35', '1', '2024-08-13 17:11:35', '1', b'0', 0);
INSERT INTO `yshop_crm_flow` VALUES (6, '发票审批', 'invoice', '', 1, '2024-08-16 10:47:57', '1', '2024-08-27 17:11:09', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_flow_log
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_flow_log`;
CREATE TABLE `yshop_crm_flow_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `flow_id` bigint NOT NULL DEFAULT '0' COMMENT '审批流程ID',
  `types_id` bigint NOT NULL DEFAULT '0' COMMENT '对象ID（如审批类型ID）',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '审核人',
  `types` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联对象 contract-合同 receivables-回款 invoice-发票',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '审核人名称',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '审核意见',
  `is_end` tinyint NOT NULL DEFAULT '0' COMMENT '1审核结束',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0审核未通过,1审核通过',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审核日志表';

-- ----------------------------
-- Records of yshop_crm_flow_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_flow_step
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_flow_step`;
CREATE TABLE `yshop_crm_flow_step` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `flow_id` bigint NOT NULL DEFAULT '0' COMMENT '审批流程ID',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '1上级管理员，2指定用户（任意一人）3-指定部门',
  `admin_ids` bigint NOT NULL DEFAULT '0' COMMENT '审批人ID (使用逗号隔开) ,1,2,',
  `relation` int NOT NULL DEFAULT '1' COMMENT '审批流程关系（1并2或）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批步骤表';

-- ----------------------------
-- Records of yshop_crm_flow_step
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_flow_step` VALUES (1, 4, 2, 129, 1, '2024-08-08 10:19:53', '1', '2024-08-08 10:19:53', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (2, 4, 2, 100, 1, '2024-08-08 10:19:53', '1', '2024-08-08 10:19:53', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (3, 4, 3, 101, 1, '2024-08-08 10:19:53', '1', '2024-08-08 11:27:41', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (4, 4, 2, 100, 1, '2024-08-08 10:19:53', '1', '2024-08-08 11:27:41', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (5, 4, 3, 101, 1, '2024-08-08 10:19:53', '1', '2024-08-10 16:25:18', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (6, 4, 2, 100, 2, '2024-08-08 10:19:53', '1', '2024-08-10 16:25:18', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (7, 4, 3, 101, 1, '2024-08-08 10:19:53', '1', '2024-08-12 11:11:49', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (8, 4, 2, 1, 2, '2024-08-08 10:19:53', '1', '2024-08-12 11:11:49', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (9, 5, 2, 129, 1, '2024-08-13 17:11:35', '1', '2024-08-13 17:11:35', '1', b'0', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (10, 5, 2, 1, 2, '2024-08-13 17:11:35', '1', '2024-08-13 17:11:35', '1', b'0', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (11, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-16 10:47:57', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (12, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-16 10:47:57', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (13, 4, 2, 1, 1, '2024-08-08 10:19:53', '1', '2024-08-17 15:52:24', '1', b'0', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (14, 4, 2, 100, 2, '2024-08-08 10:19:53', '1', '2024-08-17 15:52:24', '1', b'0', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (15, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 16:56:44', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (16, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 16:56:44', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (17, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 16:57:35', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (18, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 16:57:35', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (19, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 17:01:42', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (20, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 17:01:42', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (21, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 17:06:11', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (22, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 17:06:11', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (23, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 17:07:11', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (24, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 17:07:11', '1', b'1', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (25, 6, 2, 100, 1, '2024-08-16 10:47:57', '1', '2024-08-27 17:11:09', '1', b'0', 0);
INSERT INTO `yshop_crm_flow_step` VALUES (26, 6, 2, 1, 2, '2024-08-16 10:47:57', '1', '2024-08-27 17:11:09', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_invoice
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_invoice`;
CREATE TABLE `yshop_crm_invoice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `contract_id` bigint NOT NULL COMMENT '合同ID',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `invoice_body` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开票主体',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '开票内容',
  `invoice_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发票抬头',
  `invoice_issue` tinyint NOT NULL DEFAULT '1' COMMENT '抬头类型1企业2个人3事业单位',
  `invoice_type` tinyint NOT NULL DEFAULT '1' COMMENT '1增普2增专',
  `register_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '统一社会信用代码',
  `bank_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开户行名称',
  `bank_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开户账号',
  `money` decimal(10,2) DEFAULT '0.00' COMMENT '发票税前金额',
  `tax_rate` int NOT NULL DEFAULT '0' COMMENT '税率',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接收发票邮箱',
  `user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人',
  `user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件手机',
  `user_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮寄地址',
  `files` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开票附件',
  `invoice_admin_id` bigint DEFAULT NULL COMMENT '开票人',
  `check_status` tinyint DEFAULT '0' COMMENT '0待审核、1审核中、2审核通过、3审核未通过',
  `flow_id` bigint DEFAULT NULL COMMENT '审核流程ID',
  `step_id` bigint DEFAULT NULL COMMENT '审核步骤ID',
  `check_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '已经审批人IDs',
  `flow_admin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前需要审批的人',
  `status` tinyint DEFAULT '0' COMMENT '状态0未开票1开票中2已开票3开票失败',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `contract_id` (`contract_id`),
  KEY `customer_i` (`customer_id`),
  KEY `invoice_admin_id` (`invoice_admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发票表';

-- ----------------------------
-- Records of yshop_crm_invoice
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_invoice` VALUES (1, 5, 66, '大有前途', '', '大有前途', 1, 1, '1234567890', NULL, NULL, 100.00, 0, NULL, '5555@qq.com', NULL, NULL, NULL, NULL, NULL, 2, 6, 12, '100,1', '', 2, '2024-08-16 11:49:11', '1', '2024-08-24 17:05:42', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_operatelog
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_operatelog`;
CREATE TABLE `yshop_crm_operatelog` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `customer_id` bigint NOT NULL DEFAULT '0' COMMENT '客户ID',
  `contract_id` bigint NOT NULL DEFAULT '0' COMMENT '合同ID',
  `receivable_id` bigint NOT NULL DEFAULT '0' COMMENT '回款ID',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '管理员账号',
  `url` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作页面',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '日志标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'User-Agent',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `customer_id` (`customer_id`),
  KEY `contract_id` (`contract_id`),
  KEY `receivable_id` (`receivable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5783 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志表';

-- ----------------------------
-- Records of yshop_crm_operatelog
-- ----------------------------
BEGIN;
INSERT INTO `yshop_crm_operatelog` VALUES (5772, 68, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '添加客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-08-27 17:16:24', '1', '2024-08-27 17:16:24', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5773, 68, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '修改客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-08-27 17:17:01', '1', '2024-08-27 17:17:01', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5774, 68, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '客户资料回收', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 16:22:21', '1', '2024-09-09 16:22:21', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5775, 69, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '客户资料回收', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 16:22:21', '1', '2024-09-09 16:22:21', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5776, 70, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '客户资料回收', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 16:22:21', '1', '2024-09-09 16:22:21', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5777, 71, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '添加客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 16:24:11', '1', '2024-09-09 16:24:11', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5778, 72, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '添加客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 17:03:00', '1', '2024-09-09 17:03:00', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5779, 72, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '转移客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-09 17:30:52', '1', '2024-09-09 17:30:52', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5780, 71, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '放入公海', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-11 10:47:28', '1', '2024-09-11 10:47:28', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5781, 73, 0, 0, 'yshop', 'yshop', 'http://localhost:48081', '添加客户', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-11 10:56:28', '1', '2024-09-11 10:56:28', '1', b'0', 0);
INSERT INTO `yshop_crm_operatelog` VALUES (5782, 0, 8, 0, 'yshop', 'yshop', 'http://localhost:48081', '添加合同', NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36', '2024-09-12 11:16:30', '1', '2024-09-12 11:16:30', '1', b'0', 0);
COMMIT;

-- ----------------------------
-- Table structure for yshop_crm_record
-- ----------------------------
DROP TABLE IF EXISTS `yshop_crm_record`;
CREATE TABLE `yshop_crm_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `types` enum('business','clues','customer') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'customer' COMMENT '关联类型(customer跟进,business商机跟进,clues线索)',
  `types_id` bigint NOT NULL COMMENT '类型ID（根据types变动而变动）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '跟进内容',
  `record_type` int NOT NULL DEFAULT '0' COMMENT '跟进类型/方式',
  `next_time` datetime DEFAULT NULL COMMENT '下次联系时间',
  `lng` double(14,11) DEFAULT NULL COMMENT '经度',
  `lat` double(14,11) DEFAULT NULL COMMENT '维度',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '创建者',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除',
  `tenant_id` bigint DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `record_id` (`id`),
  KEY `types` (`types`),
  KEY `types_id` (`types_id`),
  KEY `record_type` (`record_type`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='跟进记录';

-- ----------------------------
-- Records of yshop_crm_record
-- ----------------------------
BEGIN;
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
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='素材库';

-- ----------------------------
-- Records of yshop_material
-- ----------------------------
BEGIN;
INSERT INTO `yshop_material` VALUES (96, '2024-08-27 16:59:32', '1', '1', NULL, 'WX20240827-154350@2x.png', ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', '1', '2024-08-27 16:59:32', b'0', 0);
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
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='素材分组';

-- ----------------------------
-- Records of yshop_material_group
-- ----------------------------
BEGIN;
INSERT INTO `yshop_material_group` VALUES (1, '2023-05-16 12:02:13', '1', '商品', '1', '2023-05-24 14:42:23', b'0', 1);
INSERT INTO `yshop_material_group` VALUES (2, '2023-05-22 23:38:11', '1', '21212', '1', '2023-05-22 23:38:11', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (3, '2023-05-22 23:39:44', '1', '1', '1', '2023-05-22 23:46:22', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (4, '2023-05-22 23:52:10', '1', '1', '1', '2023-05-22 23:52:10', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (5, '2023-05-22 23:52:12', '1', '2', '1', '2023-05-22 23:52:12', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (6, '2023-05-22 23:52:14', '1', '3', '1', '2023-05-22 23:52:14', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (7, '2023-05-22 23:55:30', '1', '1', '1', '2023-05-22 23:55:30', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (8, '2023-05-22 23:55:32', '1', '2', '1', '2023-05-22 23:55:32', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (9, '2023-05-22 23:55:33', '1', '4', '1', '2023-05-22 23:55:33', b'1', 1);
INSERT INTO `yshop_material_group` VALUES (10, '2023-05-22 23:55:33', '1', '3333', '1', '2023-05-22 23:56:04', b'1', 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品表';

-- ----------------------------
-- Records of yshop_store_product
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product` VALUES (27, NULL, NULL, ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', '点餐系统', '', '', '', NULL, '20', 499.00, 0.00, 0.00, 0.00, '', 0, 1, 186, 1, 0, 0, 0, 0, '<p>点餐</p>', '1', '2024-08-27 17:28:13', '2024-08-27 17:29:02', '1', 0, b'0', 0, 0.00, 0.00, 0, NULL, 0, 0, 0, '', 0, 0, 1, 0, 0, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性表';

-- ----------------------------
-- Records of yshop_store_product_attr
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr` VALUES (151, 27, '授权方式', '标准,高级');
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
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性详情表';

-- ----------------------------
-- Records of yshop_store_product_attr_result
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr_result` VALUES (109, 27, '{\"attr\":[{\"detail\":[\"标准\",\"高级\"],\"value\":\"授权方式\"}],\"value\":[{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"授权方式\":\"标准\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\" http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":499.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"标准\",\"stock\":99,\"unique\":\"f598fc6319a246b2832f23fd5b6f6f16\",\"value1\":\"标准\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0},{\"barCode\":\"\",\"brokerage\":0.0,\"brokerageTwo\":0.0,\"cost\":0.0,\"detail\":{\"授权方式\":\"高级\"},\"integral\":0,\"otPrice\":0.0,\"pic\":\" http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png\",\"pinkPrice\":0.0,\"pinkStock\":0,\"price\":1299.0,\"seckillPrice\":0.0,\"seckillStock\":0,\"sku\":\"高级\",\"stock\":88,\"unique\":\"7c4aaf7a4c214227a13bfa5b146890b8\",\"value1\":\"高级\",\"value2\":\"\",\"volume\":0.0,\"weight\":0.0}]}', '2024-08-27 17:29:02');
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
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品属性值表';

-- ----------------------------
-- Records of yshop_store_product_attr_value
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_attr_value` VALUES (207, 27, '标准', 98, 1, 499.00, ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', 'f598fc6319a246b2832f23fd5b6f6f16', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
INSERT INTO `yshop_store_product_attr_value` VALUES (208, 27, '高级', 88, 0, 1299.00, ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', '7c4aaf7a4c214227a13bfa5b146890b8', 0.00, '', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0, 0000000000);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类';

-- ----------------------------
-- Records of yshop_store_product_category
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_category` VALUES (20, NULL, 0, NULL, '点餐', ' http://localhost:48081/admin-api/infra/file/4/get/26d4848ac60a8c0c6ab609ecad30dd1741600443304f6a5b3366d248a119cd14.png', 1, '', 0, '1', '2024-08-27 16:59:50', '1', '2024-08-27 17:26:38', b'0', 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品规则值(规格)表';

-- ----------------------------
-- Records of yshop_store_product_rule
-- ----------------------------
BEGIN;
INSERT INTO `yshop_store_product_rule` VALUES (28, '授权', '[{\"value\": \"授权方式\", \"detail\": [\"标准\", \"高级\"]}]', '2024-08-27 17:27:11', '1', '2024-08-27 17:27:11', '1', b'0', 0);
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
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tempkey` (`tempkey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='微信模板';

-- ----------------------------
-- Records of yshop_wechat_template
-- ----------------------------
BEGIN;
INSERT INTO `yshop_wechat_template` VALUES (16, 'pay_success', '订单支付成功通知', '', 'KBtfY9G1IWCzC6q-ZKo-Q-MmdP7aaF79nx0XFcBf3h4', '2023-07-25 10:41:17', '2023-09-11 15:35:56', '1', '1', 1, b'0', 'subscribe', 1);
INSERT INTO `yshop_wechat_template` VALUES (17, 'pay_success', '订单支付成功通知', '', 'r6PWTcAOQodoyz0GT_0NCoFxssBT4ZB7AJqVdTdRvfA', '2023-07-25 10:43:14', '2023-07-25 10:43:14', '1', '1', 1, b'0', 'template', 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
