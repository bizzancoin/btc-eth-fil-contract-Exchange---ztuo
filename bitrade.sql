/*
 Navicat Premium Data Transfer

 Source Server         : 物理机
 Source Server Type    : MySQL
 Source Server Version : 50616
 Source Host           : 192.168.31.61:3306
 Source Schema         : bitrade

 Target Server Type    : MySQL
 Target Server Version : 50616
 File Encoding         : 65001

 Date: 29/08/2019 14:06:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `area_code` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `enable` int(11) DEFAULT NULL,
  `google_date` datetime DEFAULT NULL,
  `google_key` varchar(255) DEFAULT NULL,
  `google_state` int(11) DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `mobile_phone` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `qq` varchar(255) DEFAULT NULL,
  `real_name` varchar(255) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `department_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_gfn44sntic2k93auag97juyij` (`username`),
  KEY `FKnmmt6f2kg0oaxr11uhy7qqf3w` (`department_id`),
  CONSTRAINT `FKnmmt6f2kg0oaxr11uhy7qqf3w` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `admin`(`id`, `area_code`, `avatar`, `email`, `enable`, `google_date`, `google_key`, `google_state`, `last_login_ip`, `last_login_time`, `mobile_phone`, `password`, `qq`, `real_name`, `role_id`, `status`, `username`, `department_id`) VALUES (1, '123', '123', '1053567629@qq.com', 0, '2019-04-25 14:02:34', '0:0:0:0:0:0:0:1', 0, '192.168.31.61', '2019-08-30 15:54:53', '15139016985', '47943eeeab5ed28f8a93f7fb77ec5111', '123', '人人', 1, 0, 'root', NULL);
-- ----------------------------
-- Table structure for admin_access_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_access_log`;
CREATE TABLE `admin_access_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `access_ip` varchar(255) DEFAULT NULL,
  `access_method` varchar(255) DEFAULT NULL,
  `access_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `module` int(11) DEFAULT NULL,
  `operation` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for admin_permission
-- ----------------------------
DROP TABLE IF EXISTS `admin_permission`;
CREATE TABLE `admin_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (2, '角色管理', 'system:role:all', 8, 0, '角色管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (3, '用户管理', 'system:employee:page-query', 8, 0, '用户管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (4, '部门管理', 'system:department:all', 8, 0, '部门管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (5, '站点管理', 'system:website-information:find-one', 8, 0, '站点管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (6, '菜单管理', 'system:role:permission:all', 8, 0, '菜单管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (7, '系统日志', 'system:access-log:page-query', 8, 0, '系统日志');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (8, '系统管理', 'system-------', 0, 6, '系统管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (9, '广告管理', 'cms:system-advertise:page-query', 18, 0, '广告管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (10, '帮助管理', 'cms:system-help:page-query', 18, 0, '帮助管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (11, '会员管理', 'member--------', 0, 1, '会员管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (12, '会员管理', 'member:page-query', 11, 0, '会员管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (13, '实名管理', 'member:member-application:page-query', 11, 0, '实名管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (14, '会员监控', 'member--------', 11, 0, '会员监控');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (18, '内容管理', 'cms-------', 0, 4, '内容管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (19, '交易明细', 'finance:member-transaction:page-query', 93, 0, '交易记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (20, '提现管理', 'finance:withdraw-record:page-query', 93, 0, '提现管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (23, '币种管理', 'system:coin:page-query', 8, 0, '币币币种管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (26, '公告管理', 'cms:notice', 18, 0, '公告管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (27, '创建修改角色', 'system:role:merge', 8, 0, '创建修改角色');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (28, '更改角色权限', 'system:role:permission:update', 8, 0, '更改角色权限');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (29, '角色拥有权限', 'system:role:permission', 8, 0, '角色拥有权限');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (30, '全部权限树', 'system:role:permission:all', 8, 0, '全部权限树');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (31, '创建更改后台用户', 'system:employee:merge', 8, 0, '创建更改后台用户');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (32, '后台用户详情', 'system:employee:detail', 8, 0, '后台用户详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (33, '站点信息修改', 'system:website-information:alter', 8, 0, '站点信息修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (34, '系统日志详情', 'system:access-log:detail', 8, 0, '系统日志详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (35, '创建系统广告', 'cms:system-advertise:create', 18, 0, '创建系统广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (36, '所有系统广告', 'cms:system-advertise:all', 18, 0, '所有系统广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (37, '系统广告详情', 'cms:system-advertise:detail', 18, 0, '系统广告详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (38, '更新系统广告', 'cms:system-advertise:update', 18, 0, '更新系统广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (39, '删除系统广告', 'cms:system-advertise:deletes', 18, 0, '删除系统广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (40, '导出广告excel', 'cms:system-advertise:out-excel', 18, 0, '导出广告excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (41, '创建系统帮助', 'cms:system-help:create', 18, 0, '创建系统帮助');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (42, '系统帮助详情', 'cms:system-help:detail', 18, 0, '系统帮助详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (43, '更新系统帮助', 'cms:system-help:update', 18, 0, '更新系统帮助');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (44, '删除系统帮助', 'cms:system-help:deletes', 18, 0, '删除系统帮助');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (45, '导出系统帮助excel', 'cms:system-help:out-excel', 18, 0, '导出系统帮助excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (46, '会员详情', 'member:detail', 11, 0, '会员详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (47, '会员删除', 'member:delete', 11, 0, '会员删除');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (48, '会员更新', 'member:update', 11, 0, '会员更新');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (49, '认证商家审核', 'member:audit-business', 66, 0, '认证商家审核');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (50, '导出会员excel', 'member:out-excel', 11, 0, '导出会员excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (51, '实名信息详情', 'member:member-application:detail', 11, 0, '实名信息详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (52, '实名审核通过', 'member:member-application:pass', 11, 0, '实名审核通过');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (53, '实名审核不通过', 'member:member-application:no-pass', 11, 0, '实名审核不通过');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (54, '交易记录详情', 'finance:member-transaction:detail', 93, 0, '交易记录详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (55, '导出交易记录excel', 'finance:member-transaction:out-excel', 93, 0, '导出交易记录excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (56, '提现记录详情', 'finance:withdraw-record:detail', 93, 0, '提现记录详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (57, '提现记录一键审核通过', 'finance:withdraw-record:audit-pass', 93, 0, '提现记录一键审核通过');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (58, '提现记录一键审核不通过', 'finance:withdraw-record:audit-no-pass', 93, 0, '提现记录一键审核不通过');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (59, '批量打款', 'finance:withdraw-record:remittance', 93, 0, '批量打款');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (60, '币币管理', 'exchange-------', 0, 3, '币币管理父菜单');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (61, '币币交易订单详情', 'exchange:exchange-order:detail', 60, 0, '币币交易订单详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (62, '订单管理', 'exchange:exchange-order:page-query', 60, 0, '币币交易订单');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (63, '导出币币交易订单excel', 'exchange:exchange-order:out-excel', 60, 0, '导出币币交易订单excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (64, '币种管理', 'exchange:exchange-coin:page-query', 60, 0, '币种管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (65, '币币交易对详情', 'exchange:exchange-coin:detail', 60, 0, '币币交易对详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (66, '法币管理', 'otc-------', 0, 2, '法币otc');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (67, '后台广告详情', 'otc:advertise:detail', 66, 0, '后台广告详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (68, '关闭后台广告', 'otc:advertise:turnoff', 66, 0, '关闭后台广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (69, '后台广告状态修改', 'otc:advertise:alter-status', 66, 0, '后台广告状态修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (70, '后台广告', 'otc:advertise:page-query', 66, 0, '后台广告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (71, '后台广告导出excel', 'otc:advertise:out-excel', 66, 0, '后台广告导出excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (72, '后台申诉', 'otc:appeal:page-query', 66, 0, '后台申诉');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (73, '申诉详情', 'otc:appeal:detail', 66, 0, '申诉详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (74, '申诉处理', 'otc:appeal:audit', 66, 0, '申诉处理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (75, '法币交易订单详情', 'otc:order:detail', 66, 0, '法币交易订单详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (76, '法币交易订单状态修改', 'otc:order:alert-status', 66, 0, '法币交易订单状态修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (77, '订单管理', 'otc:order:page-query', 66, 0, '法币交易订单');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (78, '导出法币交易订单excel', 'otc:order:out-excel', 66, 0, '导出法币交易订单excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (79, '创建otc币种', 'otc:otc-coin:create', 66, 0, '创建otc币种');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (80, 'otc币种详情', 'otc:otc-coin:detail', 66, 0, 'otc币种详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (81, 'otc币种更新', 'otc:otc-coin:update', 66, 0, 'otc币种更新');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (82, 'otc币种交易率修改', 'otc:otc-coin:alter-jy-rate', 66, 0, 'otc币种交易率修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (83, '币种管理', 'otc:otc-coin:page-query', 66, 0, '法币币种管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (84, '导出otc币种excel', 'otc:otc-coin:out-excel', 66, 0, '导出otc币种excel');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (85, '创建后台货币', 'system:coin:create', 8, 0, '创建后台货币');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (86, '部门详情', 'system:department:detail', 8, 0, '部门详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (87, '查询新增用户曲线', 'system:statistics:member-statistics', 8, 0, '查询新增用户曲线');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (88, '委托量曲线', 'system:statistics:delegation-statistics', 8, 0, '委托量曲线');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (89, '法币交易订单量曲线', 'system:statistics:order-statistics', 8, 0, '法币交易订单量曲线');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (90, 'otc_order统计', 'system:statistics:dashboard', 8, 0, 'otc_order统计');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (91, '余额管理', 'member:member-wallet:closeBalance', 11, 0, '余额管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (92, '充值管理', 'finance:member-transaction:page-query:recharge', 93, 0, '充值管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (93, '财务管理', 'finance-------', 0, 5, '财务管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (94, '提币审核', 'finance:member-transaction:page-query:check', 93, 0, '提现客服审核');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (95, '手续费管理', 'finance:member-transaction:page-query:fee', 93, 0, '手续费管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (96, '创建公告', 'system:announcement:create', 8, 0, '创建公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (97, '分页查询公告', 'system:announcement:page-query', 8, 0, '分页查询公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (98, '删除公告', 'system:announcement:delete', 8, 0, '删除公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (99, '公告详情', 'system:announcement:detail', 8, 0, '公告详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (100, '更新公告', 'system:announcement:update', 8, 0, '更新公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (101, '关闭公告', 'system:announcement:turn-off', 8, 0, '关闭公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (102, '打开公告', 'system:announcement:turn-on', 8, 0, '打开公告');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (103, '币币设置', 'exchange:set', 60, 0, '币币设置');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (104, '放币处理', 'otc:appeal:release-coin', 66, 0, '放币处理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (105, '取消订单', 'otc:appeal:cancel-order', 66, 0, '取消订单');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (106, '创建修改部门', 'system:department:merge', 8, 0, '创建修改部门');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (107, '删除exchangeCoin', 'exchange:exchange-coin:deletes', 60, 0, '删除exchangeCoin');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (108, '删除otcCoin', 'otc:otc-coin:deletes', 66, 0, '删除otcCoin');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (109, '删除部门', 'system:department:deletes', 8, 0, '删除部门');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (110, '增加/修改权限', 'system:permission:merge', 8, 0, '增加权限');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (111, '权限管理', 'system:permission:page-query', 8, 0, '分页查询权限');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (112, '权限详情', 'system:permission:details', 8, 0, '权限详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (113, '权限删除', 'system:permission:deletes', 8, 0, '权限删除');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (114, '添加交易流水号', 'finance:withdraw-record:add-transaction-number', 93, 0, '财务提现转账成功添加流水号');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (115, '人工充值', 'member:member-wallet:recharge', 11, 0, '人工充值');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (116, '首页订单数', 'otc:order:get-order-num', 66, 0, '首页订单数');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (117, '投票管理', 'system:vote:merge', 8, 0, '新增/修改投票');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (118, '分页查询', 'system:vote:page-query', 8, 0, '分页查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (119, 'admin更改密码', 'system:employee:update-password', 8, 0, 'admin更改密码');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (120, '系统公告置顶', 'cms:system-help:top', 18, 0, '系统公告置顶');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (121, '系统广告置顶', 'cms:system-advertise:top', 18, 0, '系统广告置顶');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (122, '公告置顶', 'system:announcement:top', 8, 0, '公告置顶');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (123, '转账地址', 'system:transfer-address:page-query', 8, 0, '转账地址管理    拍币网独有');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (124, '新增/修改转账地址', 'system:transfer-address:merge', 8, 0, '新增/修改转账地址  拍币网独有');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (125, '转账地址详情', 'system:transfer-address:detail', 8, 0, '转账地址详情  拍币网独有');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (126, '批量删除转账地址', 'system:transfer-address:deletes', 8, 0, '批量删除转账地址   拍币网独有');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (128, '分红管理', 'system:dividend:page-query', 8, 0, '分红管理分页查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (129, '开始分红', 'system:dividend:start', 8, 0, '开始分红');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (130, '分红手续费', 'system:dividend:fee-query', 8, 0, '分红手续费');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (131, '充币记录', 'finance:member-deposit:page-query', 93, 0, '区块链钱包充币记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (132, '人工转账', 'system:coin:transfer', 8, 0, '热钱包转账至冷钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (133, '转入明细', 'system:coin:hot-transfer-record:page-query', 8, 0, '热钱包转入冷钱包记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (134, '实名认证配置修改', 'system:member-application-config:merge', 8, 0, '实名认证配置修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (135, '实名认证配置详情', 'system:member-application-config:detail', 8, 0, '实名认证配置详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (136, '禁用/解禁发布广告', 'member:alter-publish-advertisement-status', 11, 0, '禁用/解禁发布广告 1表示正常');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (137, '禁用/解禁会员账号', 'member:alter-status', 11, 0, '禁用/解禁会员账号 0表示正常');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (138, '推荐会员', 'promotion:member:page-query', 143, 0, '推荐会员分页');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (139, '删除用户', 'system:employee:deletes', 8, 0, '批量删除用户');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (140, '充值管理', 'legal-wallet-recharge', 66, 0, '充值管理分页');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (141, '提币管理', 'legal-wallet-withdraw', 66, 0, '提币管理查询分页');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (142, '是否禁止交易', 'member:alter-transaction-status', 11, 0, '是否禁止交易  1表示正常');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (143, '推荐返佣', 'promotion-------', 0, 8, '推荐返佣 根');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (144, '新增/修改推荐返佣配置', 'promotion:reward:merge', 143, 0, '新增/修改推荐返佣配置');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (145, '重置会员钱包地址', 'member:member-wallet:reset-address', 11, 0, '重置会员钱包地址');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (146, '佣金参数', 'promotion:reward:page-query', 143, 0, '佣金参数');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (147, '系统信息维护', 'system:data-dictionary', 8, 0, '系统信息管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (148, '数据字典添加', 'system:data-dictionary:create', 8, 0, '数据字典添加');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (149, '数据字典修改', 'system:data-dictionary:update', 8, 0, '数据字典修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (150, '版本管理', 'system:app-revision:page-query', 8, 0, '版本管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (151, '添加版本信息', 'system:app-revision:create', 8, 0, '添加版本信息');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (152, '更新版本信息', 'system:app-revision:update', 8, 0, '更新版本信息');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (153, '版本信息详情', 'system:app-revision:details', 8, 0, '版本信息详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (154, '推荐会员导出', 'promotion:member:out-excel', 143, 0, '推荐会员导出');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (155, '推荐会员明细', 'promotion:member:details', 143, 0, '推荐会员明细');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (156, '测试权限', '测试名称', 18, 0, '描述');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (158, '取消委托', 'exchange:exchange-order:cancel', 18, 0, '取消委托订单');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (159, '法币交易明细', 'finance:otc:order:page-query', 93, 0, '法币交易明细');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (160, '提币明细', 'finance:withdraw-record:page-query:success', 93, 0, '提币明细');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (161, '保证金管理', 'business-auth:manager', 93, 0, '保证金管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (162, '活动管理', 'activity-------', 0, 7, '活动管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (164, '签到新增', 'activity:sign:post', 162, 0, '签到新增');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (165, '签到修改', 'activity:sign:put', 162, 0, '签到修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (167, '签到管理', 'activity:sign:page-query', 162, 0, '签到分页');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (168, '签到详情', 'activity:sign:id:get', 162, 0, '签到详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (169, '签到提前关闭', 'activity:sign:id:early-closing', 162, 0, '签到提前关闭');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (170, '签到记录', 'activity:member-sign-record:page-query', 162, 0, '签到记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (171, '财务统计', 'finance:statistics:turnover', 93, 0, '成交量/成交额统计');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (172, '手续费合计', 'finance:statistics:fee', 93, 0, '手续费合计');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (173, '锁定钱包', 'member:member-wallet:lock-wallet', 11, 0, '锁定钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (174, '解锁钱包', 'member:member-wallet:unlock-wallet', 11, 0, '解锁钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (176, '角色删除', 'system:role:deletes', 8, 0, '角色删除');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (177, '保证金管理', 'business:auth:deposit', 0, 8, '保证金管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (178, '查询保证金策略', 'business:auth:deposit:page', 177, 0, '查询保证金策略');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (179, '创建保证金策略', 'business:auth:deposit:create', 177, 0, '创建保证金策略');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (180, '修改保证金策略', 'business:auth:deposit:update', 177, 0, '修改保证金策略');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (181, '退保审核', 'business:cancel-apply:check', 66, 0, '退保审核');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (182, '退保管理', 'business:cancel-apply:page-query', 66, 0, '退保申请记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (183, '退保用户详情', 'business:cancel-apply:detail', 66, 0, '退保用户详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (184, '认证商家', 'business-auth:apply:page-query', 66, 0, '认证商家');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (185, '佣金参数详情', 'promotion:reward:detail', 143, 0, '佣金参数详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (186, '认证商家详情', 'business-auth:apply:detail', 66, 0, '认证商家详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (187, '币种详情', 'system:coin:detail', 8, 0, '系统管理下币种详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (191, '添加交易对', 'exchange:exchange-coin:merge', 60, 0, '添加交易对');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (192, '糖果管理', '------gift', 0, 0, '糖果管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (193, '发放设置', 'gift:page-query', 192, 0, '糖果发放设置');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (194, '新增发放', 'gift:save', 192, 0, '新增糖果发放');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (195, '发放记录', 'gift:record:page-query', 192, 0, '糖果发放记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (196, '积分等级管理', 'member:member-grade:all', 8, 0, '积分查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (197, '积分等级更新', 'member:member-grade:update', 8, 0, '积分权限更新');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (198, 'IEO管理', '------ieo', 0, 0, 'IEO管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (199, 'IEO管理', 'ieo:page-query', 198, 0, 'IEO管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (200, '认购记录', 'ieo:record:page-query', 198, 0, '认购记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (201, '保存/修改IEO', 'ieo:save', 198, 0, '保存/修改IEO');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (202, '积分记录查询', 'member:query_page:all', 0, 0, '');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (203, '积分记录', 'member:integration_query_page:all', 11, 0, '积分记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (204, '注册送币审核', 'release:page-query', 208, 0, '注册送币审核');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (205, '审核送币', 'release:audit', 208, 0, '注册送币审核');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (206, '邀请管理', '--------inviter', 0, 0, '邀请管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (207, '邀请管理', 'invite/management:query', 206, 0, '邀请管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (208, '赠送奖励配置', 'system:reward-activity-record:page-query', 0, 0, '注册赠送,交易赠送,充值赠送');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (209, '赠送配置添加', 'system:reward-activity-record:merge', 208, 0, '添加奖励配置');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (210, '删除赠送配置', 'system:reward-activity-record:deletes', 208, 0, '批量删除');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (211, '币种修改', 'system:coin:update', 8, 0, '币种修改');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (212, '删除IEO', 'ieo:del', 198, 0, '删除IEO');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (213, '杠杆管理', NULL, 0, 0, '杠杆管理');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (214, '查询权限', 'system:permission:detail', 8, 0, '权限查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (215, '杠杆币种查询', 'lever:lever-coin:page-query', 213, 0, '分页查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (216, '法币查询', 'member:otc-wallet:query', 93, 0, '法币查询');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (217, '新增杠杆', 'lever:lever-coin:merge', 213, 0, '新增交易对');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (218, '杠杆交易对详情', 'lever:lever-coin:detail', 213, 0, '杠杆交易对详情');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (219, '删除杠杆', 'lever:lever-coin:deletes', 213, 0, '删除');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (220, '修改杠杆交易对', 'lever:lever-coin:alter-rate', 213, 0, '修改杠杆交易对');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (221, '导出', 'lever:lever-coin:out_excel', 213, 0, '导出杠杆交易对');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (222, '获取币种单位', 'lever:lever-coin:all_base_symbol_units', 213, 0, '获取所有币种单位');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (223, '获取所有交易币种', 'lever:lever-coin:all_coin_symbol_units', 213, 0, '获取所有交易币种');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (224, '风险率设置', 'loss-threshold:all', 213, 0, '查询所有风险率');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (225, '查询划转记录', 'lever:lever-coin:transfer', 213, 0, '查询划转记录');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (226, '锁定/解锁', 'lever:lever-coin:lock_wallet', 213, 0, '锁定或解锁杠杆账户');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (227, '查询风险率', 'lever:lever-coin:risk_list', 213, 0, '查询账户风险率');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (228, '查询杠杆交易钱包', 'lever:lever-coin:list', 213, 0, '查询杠杆交易钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (229, '修改', 'lossThreshold:update', 213, 0, '修改亏损阀值\n');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (230, '删除', 'lossThreshold:delete', 213, 0, '删除亏损阀值');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (231, '新增', 'loss-threshold:create', 213, 0, '新增阀值');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (232, '重置密码', 'member:pwd-reset', 11, 0, '重置会员密码');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (233, '锁定钱包', 'member:otc-wallet:lock-wallet', 11, 0, '锁定法币钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (234, ' 帮助取消置顶', 'cms:system-help:down', 18, 0, '系统帮助取消置顶');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (235, '公告取消置顶', 'system:announcement:dwon', 18, 0, '公告取消置顶');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (236, '解锁钱包', 'member:otc-wallet:unlock-wallet', 11, 0, '解锁法币钱包');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (237, '查询所有法币账户', 'member:otc-wallet:closeBalance', 11, 0, '查询用户法币账户');
INSERT INTO `admin_permission`(`id`, `title`, `name`, `parent_id`, `sort`, `description`) VALUES (238, '修改交易对', 'exchange:exchange-coin:alter-rate', 60, 0, '修改交易对');

-- ----------------------------
-- Table structure for admin_role
-- ----------------------------
DROP TABLE IF EXISTS `admin_role`;
CREATE TABLE `admin_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for admin_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `admin_role_permission`;
CREATE TABLE `admin_role_permission` (
  `role_id` bigint(20) NOT NULL,
  `rule_id` bigint(20) NOT NULL,
  UNIQUE KEY `UKplesprlvm1sob8nl9yc5rgh3m` (`role_id`,`rule_id`),
  KEY `FK52rddd3qje4p49iubt08gplb5` (`role_id`) USING BTREE,
  KEY `FKqf3fhgl5mjqqb0jeupx7yafh0` (`rule_id`) USING BTREE,
  CONSTRAINT `admin_role_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`id`),
  CONSTRAINT `admin_role_permission_ibfk_2` FOREIGN KEY (`rule_id`) REFERENCES `admin_permission` (`id`),
  CONSTRAINT `admin_role_permission_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`id`),
  CONSTRAINT `admin_role_permission_ibfk_4` FOREIGN KEY (`rule_id`) REFERENCES `admin_permission` (`id`),
  CONSTRAINT `FK52rddd3qje4p49iubt08gplb5` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`id`),
  CONSTRAINT `FKqf3fhgl5mjqqb0jeupx7yafh0` FOREIGN KEY (`rule_id`) REFERENCES `admin_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for advertise
-- ----------------------------
DROP TABLE IF EXISTS `advertise`;
CREATE TABLE `advertise` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `advertise_type` int(11) NOT NULL,
  `auto` int(11) DEFAULT NULL,
  `autoword` varchar(255) DEFAULT NULL,
  `coin_unit` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deal_amount` decimal(18,8) DEFAULT NULL COMMENT '交易中数量',
  `level` int(11) DEFAULT NULL,
  `limit_money` varchar(255) DEFAULT NULL,
  `max_limit` decimal(18,2) DEFAULT NULL COMMENT '最高单笔交易额',
  `min_limit` decimal(18,2) DEFAULT NULL COMMENT '最低单笔交易额',
  `number` decimal(18,8) DEFAULT NULL COMMENT '计划数量',
  `pay_mode` varchar(255) DEFAULT NULL,
  `premise_rate` decimal(18,6) DEFAULT NULL COMMENT '溢价百分比',
  `price` decimal(18,2) DEFAULT NULL COMMENT '交易价格',
  `price_type` int(11) NOT NULL,
  `remain_amount` decimal(18,8) DEFAULT NULL COMMENT '计划剩余数量',
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `coin_id` bigint(20) NOT NULL,
  `country` varchar(255) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK75rse9iecdnimf8ugtf20c43l` (`coin_id`),
  KEY `FK9lueh92242ckyajg17xr9tcie` (`country`),
  KEY `FKspoip5yq9ednwwondsga9c9k6` (`member_id`),
  CONSTRAINT `FK75rse9iecdnimf8ugtf20c43l` FOREIGN KEY (`coin_id`) REFERENCES `otc_coin` (`id`),
  CONSTRAINT `FK9lueh92242ckyajg17xr9tcie` FOREIGN KEY (`country`) REFERENCES `country` (`zh_name`),
  CONSTRAINT `FKspoip5yq9ednwwondsga9c9k6` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for airdrop
-- ----------------------------
DROP TABLE IF EXISTS `airdrop`;
CREATE TABLE `airdrop` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `error_index` int(11) DEFAULT NULL,
  `error_msg` text,
  `file_name` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `success_count` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3lo6cbxpuewbore50ffbwfiqr` (`admin_id`),
  CONSTRAINT `FK3lo6cbxpuewbore50ffbwfiqr` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` text,
  `create_time` datetime DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `is_show` bit(1) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `is_top` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for app_revision
-- ----------------------------
DROP TABLE IF EXISTS `app_revision`;
CREATE TABLE `app_revision` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `download_url` varchar(255) DEFAULT NULL,
  `platform` int(11) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for appeal
-- ----------------------------
DROP TABLE IF EXISTS `appeal`;
CREATE TABLE `appeal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `associate_id` bigint(20) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deal_with_time` datetime DEFAULT NULL,
  `img_urls` varchar(255) DEFAULT NULL,
  `initiator_id` bigint(20) DEFAULT NULL,
  `is_success` int(11) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `order_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_todwxorutclquf69bwow70kml` (`order_id`),
  KEY `FKanmcnj859x2tv3y0pv7u05cqa` (`admin_id`),
  CONSTRAINT `FKanmcnj859x2tv3y0pv7u05cqa` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKs3vo8h01sq39icylq1qdwekn1` FOREIGN KEY (`order_id`) REFERENCES `otc_order` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_auth_apply
-- ----------------------------
DROP TABLE IF EXISTS `business_auth_apply`;
CREATE TABLE `business_auth_apply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '保证金数额',
  `auditing_time` datetime DEFAULT NULL,
  `auth_info` text,
  `certified_business_status` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deposit_record_id` varchar(255) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `business_auth_deposit_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKds72omottejlk5isd34ha5i10` (`business_auth_deposit_id`),
  KEY `FKdghp8ri44t77ntuw06gicphuu` (`member_id`),
  CONSTRAINT `FKdghp8ri44t77ntuw06gicphuu` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKds72omottejlk5isd34ha5i10` FOREIGN KEY (`business_auth_deposit_id`) REFERENCES `business_auth_deposit` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_auth_deposit
-- ----------------------------
DROP TABLE IF EXISTS `business_auth_deposit`;
CREATE TABLE `business_auth_deposit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '保证金数额',
  `create_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKfj3hxtr3ae1yma9bxeuqc29pj` (`admin_id`),
  KEY `FKjx7799a3pwdtnu43fkpn27kj6` (`coin_id`),
  CONSTRAINT `FKfj3hxtr3ae1yma9bxeuqc29pj` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKjx7799a3pwdtnu43fkpn27kj6` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for bussiness_cancel_apply
-- ----------------------------
DROP TABLE IF EXISTS `bussiness_cancel_apply`;
CREATE TABLE `bussiness_cancel_apply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cancel_apply_time` datetime DEFAULT NULL,
  `deposit_record_id` varchar(255) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `handle_time` datetime DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbwtwtm0jd1eqa8dh7e8ychcx1` (`member_id`),
  CONSTRAINT `FKbwtwtm0jd1eqa8dh7e8ychcx1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coin
-- ----------------------------
DROP TABLE IF EXISTS `coin`;
CREATE TABLE `coin` (
  `name` varchar(255) NOT NULL,
  `can_auto_withdraw` int(11) DEFAULT NULL,
  `can_recharge` int(11) DEFAULT NULL,
  `can_transfer` int(11) DEFAULT NULL,
  `can_withdraw` int(11) DEFAULT NULL,
  `cny_rate` decimal(18,8) DEFAULT '0.00000000' COMMENT '人民币汇率',
  `cold_wallet_address` varchar(255) DEFAULT NULL,
  `enable_rpc` int(11) DEFAULT NULL,
  `has_legal` bit(1) NOT NULL DEFAULT b'0',
  `is_platform_coin` int(11) DEFAULT '0' COMMENT '是否为平台币',
  `master_address` varchar(64) DEFAULT NULL COMMENT '主充值地址',
  `max_daily_withdraw_rate` decimal(18,8) DEFAULT '0.00000000' COMMENT '单日最大提币量',
  `max_tx_fee` double NOT NULL,
  `max_withdraw_amount` decimal(18,8) DEFAULT NULL COMMENT '最大提币数量',
  `min_recharge_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '最小充币数量',
  `min_tx_fee` double NOT NULL,
  `min_withdraw_amount` decimal(18,8) DEFAULT NULL COMMENT '最小提币数量',
  `miner_fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '矿工费',
  `name_cn` varchar(255) NOT NULL,
  `sgd_rate` decimal(18,2) DEFAULT '0.00' COMMENT '美元汇率',
  `sort` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  `usd_rate` decimal(18,8) DEFAULT '0.00000000' COMMENT '美元汇率',
  `withdraw_scale` int(11) DEFAULT '4' COMMENT '提币精度',
  `withdraw_threshold` decimal(18,8) DEFAULT NULL COMMENT '自动提现阈值',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `coin`(`name`, `can_auto_withdraw`, `can_recharge`, `can_transfer`, `can_withdraw`, `cny_rate`, `cold_wallet_address`, `enable_rpc`, `has_legal`, `is_platform_coin`, `master_address`, `max_daily_withdraw_rate`, `max_tx_fee`, `max_withdraw_amount`, `min_recharge_amount`, `min_tx_fee`, `min_withdraw_amount`, `miner_fee`, `name_cn`, `sgd_rate`, `sort`, `status`, `unit`, `usd_rate`, `withdraw_scale`, `withdraw_threshold`) VALUES ('BNB', 0, 0, 1, 0, 300.00000000, NULL, 0, b'0', 0, NULL, 0.00000000, 100, 10.00000000, 0.00000000, 100, 10.00000000, 0.00000000, 'BNB', NULL, 10, 0, 'BNB', 30.00000000, 0, 100.00000000);
INSERT INTO `coin`(`name`, `can_auto_withdraw`, `can_recharge`, `can_transfer`, `can_withdraw`, `cny_rate`, `cold_wallet_address`, `enable_rpc`, `has_legal`, `is_platform_coin`, `master_address`, `max_daily_withdraw_rate`, `max_tx_fee`, `max_withdraw_amount`, `min_recharge_amount`, `min_tx_fee`, `min_withdraw_amount`, `miner_fee`, `name_cn`, `sgd_rate`, `sort`, `status`, `unit`, `usd_rate`, `withdraw_scale`, `withdraw_threshold`) VALUES ('BTC', 0, 0, 1, 0, 60000.00000000, NULL, 0, b'0', 0, NULL, 0.00000000, 10, 1000.00000000, 0.00000000, 10, 100.00000000, 0.00000000, 'BTC', NULL, 3, 0, 'BTC', 10000.00000000, 0, 100.00000000);
INSERT INTO `coin`(`name`, `can_auto_withdraw`, `can_recharge`, `can_transfer`, `can_withdraw`, `cny_rate`, `cold_wallet_address`, `enable_rpc`, `has_legal`, `is_platform_coin`, `master_address`, `max_daily_withdraw_rate`, `max_tx_fee`, `max_withdraw_amount`, `min_recharge_amount`, `min_tx_fee`, `min_withdraw_amount`, `miner_fee`, `name_cn`, `sgd_rate`, `sort`, `status`, `unit`, `usd_rate`, `withdraw_scale`, `withdraw_threshold`) VALUES ('ETH', 0, 0, 1, 0, 3000.00000000, NULL, 0, b'0', 0, NULL, 0.00000000, 10, 1000.00000000, 0.00000000, 10, 100.00000000, 0.00000000, 'ETH', NULL, 2, 0, 'ETH', 200.00000000, 0, 10.00000000);
INSERT INTO `coin`(`name`, `can_auto_withdraw`, `can_recharge`, `can_transfer`, `can_withdraw`, `cny_rate`, `cold_wallet_address`, `enable_rpc`, `has_legal`, `is_platform_coin`, `master_address`, `max_daily_withdraw_rate`, `max_tx_fee`, `max_withdraw_amount`, `min_recharge_amount`, `min_tx_fee`, `min_withdraw_amount`, `miner_fee`, `name_cn`, `sgd_rate`, `sort`, `status`, `unit`, `usd_rate`, `withdraw_scale`, `withdraw_threshold`) VALUES ('HT', 0, 0, 1, 0, 240.00000000, NULL, 0, b'0', 0, NULL, 0.00000000, 10, 100.00000000, 0.00000000, 10, 10.00000000, 0.00000000, 'HT', NULL, 5, 0, 'HT', 32.00000000, 0, 100.00000000);
INSERT INTO `coin`(`name`, `can_auto_withdraw`, `can_recharge`, `can_transfer`, `can_withdraw`, `cny_rate`, `cold_wallet_address`, `enable_rpc`, `has_legal`, `is_platform_coin`, `master_address`, `max_daily_withdraw_rate`, `max_tx_fee`, `max_withdraw_amount`, `min_recharge_amount`, `min_tx_fee`, `min_withdraw_amount`, `miner_fee`, `name_cn`, `sgd_rate`, `sort`, `status`, `unit`, `usd_rate`, `withdraw_scale`, `withdraw_threshold`) VALUES ('USDT', 0, 1, 1, 0, 300000.00000000, NULL, 0, b'0', 0, NULL, 0.00000000, 100, 100.00000000, 0.00000000, 10, 1.00000000, 0.00000000, 'USDT', NULL, 1, 0, 'USDT', 600.00000000, 0, 20.00000000);

-- ----------------------------
-- Table structure for country
-- ----------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `zh_name` varchar(255) NOT NULL,
  `area_code` varchar(255) DEFAULT NULL,
  `en_name` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `local_currency` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  PRIMARY KEY (`zh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `country`(`zh_name`, `area_code`, `en_name`, `language`, `local_currency`, `sort`) VALUES ('中国', '86', 'China', 'zh_CN', 'CNY', 0);
INSERT INTO `country`(`zh_name`, `area_code`, `en_name`, `language`, `local_currency`, `sort`) VALUES ('中国台湾', '886', 'Taiwan,China', 'zh_TW', 'TWD', 0);
INSERT INTO `country`(`zh_name`, `area_code`, `en_name`, `language`, `local_currency`, `sort`) VALUES ('新加坡', '65', 'Singapore', 'en_US', 'SGD', 0);
INSERT INTO `country`(`zh_name`, `area_code`, `en_name`, `language`, `local_currency`, `sort`) VALUES ('美国', '1', 'America', 'en_US', 'USD', 0);
INSERT INTO `country`(`zh_name`, `area_code`, `en_name`, `language`, `local_currency`, `sort`) VALUES ('香港', '852', 'HongKong', 'zh_HK', 'HKD', 0);

-- ----------------------------
-- Table structure for data_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `data_dictionary`;
CREATE TABLE `data_dictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bond` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `leader_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_1t68827l97cwyxo9r1u6t4p7d` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `department`(`id`, `create_time`, `leader_id`, `name`, `remark`, `update_time`) VALUES (1, '2019-04-28 14:23:57', NULL, '系统', '系统管理员', '2019-04-28 14:23:57');
INSERT INTO `department`(`id`, `create_time`, `leader_id`, `name`, `remark`, `update_time`) VALUES (2, '2019-04-28 14:24:06', NULL, '测试', '测试', '2019-04-28 14:24:06');

-- ----------------------------
-- Table structure for deposit_record
-- ----------------------------
DROP TABLE IF EXISTS `deposit_record`;
CREATE TABLE `deposit_record` (
  `id` varchar(255) NOT NULL,
  `amount` decimal(18,8) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7x5q0lmqqtty5i0w5mq09o8r7` (`coin_id`),
  KEY `FKji8p5uoc1ad45npyf72rgf2lx` (`member_id`),
  CONSTRAINT `FK7x5q0lmqqtty5i0w5mq09o8r7` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKji8p5uoc1ad45npyf72rgf2lx` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dividend_start_record
-- ----------------------------
DROP TABLE IF EXISTS `dividend_start_record`;
CREATE TABLE `dividend_start_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,6) DEFAULT NULL COMMENT '数量',
  `date` datetime DEFAULT NULL,
  `end` bigint(20) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `rate` decimal(18,2) DEFAULT NULL COMMENT '比例',
  `start` bigint(20) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK226c1iy2t1dt9tjjo20pum39d` (`admin_id`),
  CONSTRAINT `FK226c1iy2t1dt9tjjo20pum39d` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for emption_record
-- ----------------------------
DROP TABLE IF EXISTS `emption_record`;
CREATE TABLE `emption_record` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID自增',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `ieo_id` bigint(20) DEFAULT NULL COMMENT 'ieoId',
  `user_name` varchar(64) NOT NULL COMMENT '用户昵称',
  `user_mobile` varchar(16) NOT NULL COMMENT '用户手机号',
  `ieo_name` varchar(128) NOT NULL COMMENT '项目名称',
  `sale_coin` varchar(16) NOT NULL COMMENT '发售币种',
  `sale_amount` decimal(14,4) NOT NULL COMMENT '发售总量',
  `raise_coin` varchar(16) NOT NULL COMMENT '募集币种',
  `ratio` decimal(12,4) NOT NULL COMMENT '募集币种与发售币种的比率',
  `start_time` datetime DEFAULT NULL COMMENT '募集开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '募集结束时间',
  `status` char(1) DEFAULT '0' COMMENT '状态',
  `receive_amount` decimal(14,4) NOT NULL COMMENT '认购数量',
  `pay_amount` decimal(14,4) NOT NULL COMMENT '使用数量',
  `expect_time` datetime DEFAULT NULL COMMENT '预计上线时间',
  `create_time` datetime DEFAULT NULL,
  `pic_view` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='认购记录表';

-- ----------------------------
-- Table structure for exchange_coin
-- ----------------------------
DROP TABLE IF EXISTS `exchange_coin`;
CREATE TABLE `exchange_coin` (
  `symbol` varchar(255) NOT NULL,
  `base_coin_scale` int(11) NOT NULL,
  `base_fee` decimal(18,4) DEFAULT '0.0000' COMMENT '结算币种手续费',
  `base_symbol` varchar(255) DEFAULT NULL,
  `coin_scale` int(11) NOT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `enable` int(11) NOT NULL,
  `enable_market_buy` int(11) DEFAULT '1' COMMENT '是否启用市价买',
  `enable_market_sell` int(11) DEFAULT '1' COMMENT '是否启用市价卖',
  `fee` decimal(18,4) DEFAULT '0.0000' COMMENT '基币手续费',
  `flag` int(11) DEFAULT '0',
  `max_trading_order` int(11) DEFAULT '0' COMMENT '最大允许同时交易的订单数，0表示不限制',
  `max_trading_time` int(11) DEFAULT '0' COMMENT '委托超时自动下架时间，单位为秒，0表示不过期',
  `max_volume` decimal(18,8) DEFAULT '0.00000000' COMMENT '最大下单量',
  `min_sell_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '卖单最低价格',
  `min_turnover` decimal(18,8) DEFAULT '0.00000000' COMMENT '最小成交额',
  `min_volume` decimal(18,8) DEFAULT '0.00000000' COMMENT '最小下单量',
  `sort` int(11) NOT NULL,
  `zone` int(11) DEFAULT '0',
  `default_symbol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('BNB/BTC', 8, NULL, 'BTC', 8, 'BNB', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('BNB/ETH', 6, NULL, 'ETH', 8, 'BNB', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('BNB/USDT', 6, NULL, 'USDT', 8, 'BNB', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('BTC/USDT', 2, NULL, 'USDT', 6, 'BTC', 1, 1, 1, 1.0000, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('ETH/BTC', 6, NULL, 'BTC', 8, 'ETH', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('ETH/USDT', 4, NULL, 'USDT', 6, 'ETH', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('HT/BTC', 8, NULL, 'BTC', 8, 'HT', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('HT/ETH', 6, NULL, 'ETH', 8, 'HT', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');
INSERT INTO `exchange_coin`(`symbol`, `base_coin_scale`, `base_fee`, `base_symbol`, `coin_scale`, `coin_symbol`, `enable`, `enable_market_buy`, `enable_market_sell`, `fee`, `flag`, `max_trading_order`, `max_trading_time`, `max_volume`, `min_sell_price`, `min_turnover`, `min_volume`, `sort`, `zone`, `default_symbol`) VALUES ('HT/USDT', 6, NULL, 'USDT', 8, 'HT', 1, 1, 1, 0.0002, 0, 0, 0, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0, 0, '0');

-- ----------------------------
-- Table structure for exchange_favor_symbol
-- ----------------------------
DROP TABLE IF EXISTS `exchange_favor_symbol`;
CREATE TABLE `exchange_favor_symbol` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `add_time` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for exchange_order
-- ----------------------------
DROP TABLE IF EXISTS `exchange_order`;
CREATE TABLE `exchange_order` (
  `order_id` varchar(255) NOT NULL,
  `amount` decimal(18,8) DEFAULT '0.00000000',
  `base_symbol` varchar(255) DEFAULT NULL,
  `canceled_time` bigint(20) DEFAULT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `completed_time` bigint(20) DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `margin_trade` int(11) DEFAULT NULL,
  `member_trade` int(11) DEFAULT '1',
  `member_id` bigint(20) DEFAULT NULL,
  `price` decimal(18,8) DEFAULT '0.00000000',
  `status` int(11) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `traded_amount` decimal(18,8) DEFAULT '0.00000000',
  `turnover` decimal(18,8) DEFAULT '0.00000000',
  `type` int(11) DEFAULT NULL,
  `trigger_price` decimal(18,8) DEFAULT NULL,
  `order_resource` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `index_member_id_time` (`member_id`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmonjtjt92g6gruqyfumtmg8m8` (`member_id`),
  CONSTRAINT `FKmonjtjt92g6gruqyfumtmg8m8` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gift_config
-- ----------------------------
DROP TABLE IF EXISTS `gift_config`;
CREATE TABLE `gift_config` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID自增',
  `gift_name` varchar(128) NOT NULL COMMENT '活动名称',
  `gift_coin` varchar(16) NOT NULL COMMENT '赠送币种',
  `amount` decimal(14,4) NOT NULL COMMENT '总量',
  `have_coin` varchar(16) NOT NULL COMMENT '持有币种',
  `have_amount` decimal(14,4) DEFAULT NULL COMMENT '持有数量',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='糖果设置表';

-- ----------------------------
-- Table structure for gift_record
-- ----------------------------
DROP TABLE IF EXISTS `gift_record`;
CREATE TABLE `gift_record` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID自增',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `user_name` varchar(64) DEFAULT NULL COMMENT '用户昵称',
  `user_mobile` varchar(16) DEFAULT NULL COMMENT '用户手机号',
  `gift_name` varchar(128) NOT NULL COMMENT '活动名称',
  `gift_coin` varchar(16) NOT NULL COMMENT '赠送币种',
  `gift_amount` decimal(14,4) DEFAULT '0.0000' COMMENT '赠送数量',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='糖果赠送记录表';

-- ----------------------------
-- Table structure for hot_transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `hot_transfer_record`;
CREATE TABLE `hot_transfer_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `admin_id` bigint(20) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '转账金额',
  `balance` decimal(18,8) DEFAULT '0.00000000' COMMENT '热钱包余额',
  `cold_address` varchar(255) DEFAULT NULL,
  `miner_fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '矿工费',
  `transaction_number` varchar(255) DEFAULT NULL,
  `transfer_time` datetime DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ieo_emption
-- ----------------------------
DROP TABLE IF EXISTS `ieo_emption`;
CREATE TABLE `ieo_emption` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID自增',
  `ieo_name` varchar(128) NOT NULL COMMENT '项目名称',
  `pic_view` varchar(128) DEFAULT NULL COMMENT '项目缩略图',
  `pic` varchar(128) DEFAULT NULL COMMENT '项目图片',
  `sale_coin` varchar(16) NOT NULL COMMENT '发售币种',
  `sale_amount` decimal(14,4) NOT NULL COMMENT '发售总量',
  `surplus_amount` decimal(14,4) NOT NULL COMMENT '剩余量',
  `raise_coin` varchar(16) NOT NULL COMMENT '募集币种',
  `ratio` decimal(12,4) NOT NULL COMMENT '募集币种与发售币种的比率',
  `start_time` datetime DEFAULT NULL COMMENT '募集开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '募集结束时间',
  `fee` decimal(5,4) NOT NULL COMMENT '手续费',
  `expect_time` datetime DEFAULT NULL COMMENT '预计上线时间',
  `success_ratio` decimal(3,2) NOT NULL COMMENT '抢购成功几率',
  `limit_amount` decimal(14,4) NOT NULL COMMENT '每人抢购限额',
  `have_amount` decimal(14,4) NOT NULL COMMENT '允许抢购条件持有数量',
  `have_coin` varchar(16) NOT NULL COMMENT '持有币种',
  `sell_mode` text COMMENT '售卖方式',
  `sell_detail` text COMMENT '项目详情',
  `create_time` datetime DEFAULT NULL,
  `create_user` varchar(50) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_user` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ieo配置表';

-- ----------------------------
-- Table structure for init_plate
-- ----------------------------
DROP TABLE IF EXISTS `init_plate`;
CREATE TABLE `init_plate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `final_price` varchar(255) DEFAULT NULL,
  `init_price` varchar(255) DEFAULT NULL,
  `interference_factor` varchar(255) DEFAULT NULL,
  `relative_time` varchar(255) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for integration_record
-- ----------------------------
DROP TABLE IF EXISTS `integration_record`;
CREATE TABLE `integration_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `amount` bigint(20) NOT NULL COMMENT '积分赠送数量',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for legal_wallet_recharge
-- ----------------------------
DROP TABLE IF EXISTS `legal_wallet_recharge`;
CREATE TABLE `legal_wallet_recharge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,2) NOT NULL COMMENT '充值金额',
  `creation_time` datetime DEFAULT NULL,
  `deal_time` datetime DEFAULT NULL,
  `pay_mode` int(11) NOT NULL,
  `payment_instrument` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `state` int(11) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_name` varchar(255) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKtfjvrkn1oe0yu2tfjh6qcms73` (`admin_id`),
  KEY `FKsdtoqyvbjpd0bmw4n41ijc0kk` (`coin_name`),
  KEY `FK170xpb7hoxqoj5ovdrcibs9gn` (`member_id`),
  CONSTRAINT `FK170xpb7hoxqoj5ovdrcibs9gn` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKsdtoqyvbjpd0bmw4n41ijc0kk` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKtfjvrkn1oe0yu2tfjh6qcms73` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for legal_wallet_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `legal_wallet_withdraw`;
CREATE TABLE `legal_wallet_withdraw` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '申请总数量',
  `create_time` datetime DEFAULT NULL,
  `deal_time` datetime DEFAULT NULL,
  `pay_mode` int(11) NOT NULL,
  `payment_instrument` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `remit_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_name` varchar(255) NOT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKe95o0059kwsgmsxxv3amdb0d2` (`admin_id`),
  KEY `FKbilsav1ug8vjtn4ffghrlogqx` (`coin_name`),
  KEY `FKcpw5k7o3tchlifu1wqmjhku9t` (`member_id`),
  CONSTRAINT `FKbilsav1ug8vjtn4ffghrlogqx` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKcpw5k7o3tchlifu1wqmjhku9t` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKe95o0059kwsgmsxxv3amdb0d2` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lever_coin
-- ----------------------------
DROP TABLE IF EXISTS `lever_coin`;
CREATE TABLE `lever_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_symbol` varchar(255) NOT NULL,
  `coin_symbol` varchar(255) NOT NULL,
  `enable` int(11) DEFAULT NULL,
  `interest_rate` decimal(18,8) DEFAULT NULL COMMENT '借贷利率',
  `min_turn_into_amount` decimal(18,8) DEFAULT NULL COMMENT '最小转入金额',
  `min_turn_out_amount` decimal(18,8) DEFAULT NULL COMMENT '最小转出金额',
  `proportion` decimal(19,2) NOT NULL,
  `sort` int(11) NOT NULL,
  `symbol` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `lever_coin`(`id`, `base_symbol`, `coin_symbol`, `enable`, `interest_rate`, `min_turn_into_amount`, `min_turn_out_amount`, `proportion`, `sort`, `symbol`) VALUES (1, 'USDT', 'ETH', 1, 0.00200000, 10.00000000, 10.00000000, 3.00, 0, 'ETH/USDT');
INSERT INTO `lever_coin`(`id`, `base_symbol`, `coin_symbol`, `enable`, `interest_rate`, `min_turn_into_amount`, `min_turn_out_amount`, `proportion`, `sort`, `symbol`) VALUES (2, 'USDT', 'BTC', 1, 0.00200000, 0.00100000, 0.00100000, 5.00, 0, 'BTC/USDT');

-- ----------------------------
-- Table structure for lever_wallet
-- ----------------------------
DROP TABLE IF EXISTS `lever_wallet`;
CREATE TABLE `lever_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `balance` decimal(18,8) DEFAULT NULL COMMENT '可用余额',
  `frozen_balance` decimal(18,8) DEFAULT NULL COMMENT '冻结余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包是否锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '是否处于爆仓状态',
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `lever_coin_id` bigint(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKq9qs85kkbu4q5my6e8higb7m1` (`coin_id`),
  KEY `FK9o9ybbe0ak4pgh9c6b3qeqqqf` (`lever_coin_id`),
  CONSTRAINT `FK9o9ybbe0ak4pgh9c6b3qeqqqf` FOREIGN KEY (`lever_coin_id`) REFERENCES `lever_coin` (`id`),
  CONSTRAINT `FKq9qs85kkbu4q5my6e8higb7m1` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lever_wallet_transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `lever_wallet_transfer_record`;
CREATE TABLE `lever_wallet_transfer_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '金额',
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `lever_coin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK790qm871imload2wh6f1rgplk` (`coin_id`),
  KEY `FKgofcyu74g536u214pae6oailu` (`lever_coin_id`),
  CONSTRAINT `FK790qm871imload2wh6f1rgplk` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKgofcyu74g536u214pae6oailu` FOREIGN KEY (`lever_coin_id`) REFERENCES `lever_coin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for loan_record
-- ----------------------------
DROP TABLE IF EXISTS `loan_record`;
CREATE TABLE `loan_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `accumulative` decimal(18,8) DEFAULT NULL COMMENT '累计利息',
  `amount` decimal(18,8) DEFAULT NULL COMMENT '未归还的借贷金额',
  `create_time` datetime DEFAULT NULL,
  `interest_rate` decimal(18,8) DEFAULT NULL COMMENT '借贷利率',
  `loan_balance` decimal(18,8) DEFAULT NULL COMMENT '借贷金额（记录值，不变化）',
  `member_id` bigint(20) DEFAULT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `repayment` int(11) DEFAULT NULL,
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `lever_coin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3kdsljtrpiglp1f0habb96yjk` (`coin_id`),
  KEY `FKo6760jivsxxr7616790x2w04p` (`lever_coin_id`),
  CONSTRAINT `FK3kdsljtrpiglp1f0habb96yjk` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKo6760jivsxxr7616790x2w04p` FOREIGN KEY (`lever_coin_id`) REFERENCES `lever_coin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lock_position_record
-- ----------------------------
DROP TABLE IF EXISTS `lock_position_record`;
CREATE TABLE `lock_position_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '锁仓金额',
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `unlock_time` datetime DEFAULT NULL,
  `wallet_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKf2t2wbo5u4htn4qfbmfepu45v` (`coin_id`),
  CONSTRAINT `FKf2t2wbo5u4htn4qfbmfepu45v` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for loss_threshold
-- ----------------------------
DROP TABLE IF EXISTS `loss_threshold`;
CREATE TABLE `loss_threshold` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `perform_actions` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `threshold` decimal(19,2) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `coin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKoa38gp4svpx11v6a42ph2h9ld` (`coin_id`),
  CONSTRAINT `FKoa38gp4svpx11v6a42ph2h9ld` FOREIGN KEY (`coin_id`) REFERENCES `lever_coin` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `loss_threshold`(`id`, `create_time`, `perform_actions`, `status`, `threshold`, `update_time`, `coin_id`) VALUES (1, '2019-08-26 10:51:37', 0, 0, 150.00, '2019-08-26 10:51:37', 1);
INSERT INTO `loss_threshold`(`id`, `create_time`, `perform_actions`, `status`, `threshold`, `update_time`, `coin_id`) VALUES (2, '2019-08-26 10:51:47', 1, 0, 120.00, '2019-08-26 10:51:47', 1);
INSERT INTO `loss_threshold`(`id`, `create_time`, `perform_actions`, `status`, `threshold`, `update_time`, `coin_id`) VALUES (3, '2019-08-26 10:55:02', 0, 0, 140.00, '2019-08-26 10:55:02', 2);
INSERT INTO `loss_threshold`(`id`, `create_time`, `perform_actions`, `status`, `threshold`, `update_time`, `coin_id`) VALUES (4, '2019-08-26 10:55:11', 1, 0, 110.00, '2019-08-26 10:55:11', 2);

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ali_no` varchar(255) DEFAULT NULL,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `appeal_success_times` int(11) NOT NULL,
  `appeal_times` int(11) NOT NULL,
  `application_time` datetime DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `card_no` varchar(255) DEFAULT NULL,
  `certified_business_apply_time` datetime DEFAULT NULL,
  `certified_business_check_time` datetime DEFAULT NULL,
  `certified_business_status` int(11) DEFAULT NULL,
  `channel_id` int(11) DEFAULT '0',
  `email` varchar(255) DEFAULT NULL,
  `first_level` int(11) NOT NULL,
  `google_date` datetime DEFAULT NULL,
  `google_key` varchar(255) DEFAULT NULL,
  `google_state` int(11) DEFAULT '0',
  `id_number` varchar(255) DEFAULT NULL,
  `inviter_id` bigint(20) DEFAULT NULL,
  `is_channel` int(11) DEFAULT '0',
  `jy_password` varchar(255) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `login_count` int(11) NOT NULL,
  `login_lock` int(11) DEFAULT NULL,
  `margin` varchar(255) DEFAULT NULL,
  `member_level` int(11) DEFAULT NULL,
  `mobile_phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `promotion_code` varchar(255) DEFAULT NULL,
  `publish_advertise` int(11) DEFAULT NULL,
  `real_name` varchar(255) DEFAULT NULL,
  `real_name_status` int(11) DEFAULT NULL,
  `registration_time` datetime DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `second_level` int(11) NOT NULL,
  `sign_in_ability` bit(1) NOT NULL DEFAULT b'1',
  `status` int(11) DEFAULT NULL,
  `third_level` int(11) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `token_expire_time` datetime DEFAULT NULL,
  `transaction_status` int(11) DEFAULT NULL,
  `transaction_time` datetime DEFAULT NULL,
  `transactions` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `qr_we_code_url` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `local` varchar(255) DEFAULT NULL,
  `integration` bigint(20) DEFAULT '0',
  `member_grade_id` bigint(20) NOT NULL DEFAULT '1' COMMENT '等级id',
  `kyc_status` int(2) DEFAULT '0' COMMENT 'kyc等级',
  `generalize_total` bigint(20) DEFAULT '0' COMMENT '注册赠送积分',
  `inviter_parent_id` bigint(20) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_gc3jmn7c2abyo3wf6syln5t2i` (`username`),
  UNIQUE KEY `UK_mbmcqelty0fbrvxp1q58dn57t` (`email`),
  UNIQUE KEY `UK_10ixebfiyeqolglpuye0qb49u` (`mobile_phone`),
  KEY `FKbt72vgf5myy3uhygc90xna65j` (`local`),
  CONSTRAINT `FKbt72vgf5myy3uhygc90xna65j` FOREIGN KEY (`local`) REFERENCES `country` (`zh_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_address
-- ----------------------------
DROP TABLE IF EXISTS `member_address`;
CREATE TABLE `member_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhcqqqntcf8hqmoa6dpo95okyh` (`coin_id`),
  CONSTRAINT `FKhcqqqntcf8hqmoa6dpo95okyh` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_api_key
-- ----------------------------
DROP TABLE IF EXISTS `member_api_key`;
CREATE TABLE `member_api_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(255) DEFAULT NULL,
  `api_name` varchar(255) DEFAULT NULL,
  `bind_ip` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `expire_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `secret_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for member_application
-- ----------------------------
DROP TABLE IF EXISTS `member_application`;
CREATE TABLE `member_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `audit_status` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `id_card` varchar(255) DEFAULT NULL,
  `identity_card_img_front` varchar(255) NOT NULL,
  `identity_card_img_in_hand` varchar(255) NOT NULL,
  `identity_card_img_reverse` varchar(255) NOT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `real_name` varchar(255) DEFAULT NULL,
  `reject_reason` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT '0' COMMENT '认证类型',
  `update_time` datetime DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  `kyc_status` int(2) DEFAULT '0' COMMENT 'kyc等级',
  `video_random` varchar(6) DEFAULT NULL COMMENT '视频认证随机数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK2djx7q0j54th0cgj7153qfbl1` (`member_id`),
  CONSTRAINT `FK2djx7q0j54th0cgj7153qfbl1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_application_config
-- ----------------------------
DROP TABLE IF EXISTS `member_application_config`;
CREATE TABLE `member_application_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `promotion_on` int(11) DEFAULT NULL,
  `recharge_coin_on` int(11) DEFAULT NULL,
  `transaction_on` int(11) DEFAULT NULL,
  `withdraw_coin_on` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_bonus
-- ----------------------------
DROP TABLE IF EXISTS `member_bonus`;
CREATE TABLE `member_bonus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `arrive_time` varchar(255) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `have_time` varchar(255) DEFAULT NULL,
  `mem_bouns` decimal(18,8) DEFAULT NULL COMMENT '分红数量',
  `member_id` bigint(20) DEFAULT NULL,
  `total` decimal(18,8) DEFAULT NULL COMMENT '当天总手续费',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_deposit
-- ----------------------------
DROP TABLE IF EXISTS `member_deposit`;
CREATE TABLE `member_deposit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT '0.00000000',
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `txid` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKl2ibi99fuxplt8qt3rrpb0q4w` (`txid`,`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_grade
-- ----------------------------
DROP TABLE IF EXISTS `member_grade`;
CREATE TABLE `member_grade` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `grade_name` varchar(255) DEFAULT NULL,
  `grade_code` varchar(255) DEFAULT NULL,
  `withdraw_coin_amount` decimal(18,6) DEFAULT NULL COMMENT '提币数量',
  `day_withdraw_count` int(11) DEFAULT NULL,
  `grade_bound` int(11) DEFAULT NULL,
  `exchange_fee_rate` decimal(10,6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (1, '等级1', '1', 1.000000, 2, 10000, 0.000500);
INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (2, '等级2', '2', 2.000000, 4, 30000, 0.000400);
INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (3, '等级3', '3', 3.000000, 4, 50000, 0.000300);
INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (4, '等级4', '4', 4.000000, 5, 70000, 0.000200);
INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (5, '等级5', '5', 6.000000, 5, 80000, 0.000100);
INSERT INTO `member_grade`(`id`, `grade_name`, `grade_code`, `withdraw_coin_amount`, `day_withdraw_count`, `grade_bound`, `exchange_fee_rate`) VALUES (6, '等级6', '6', 7.000000, 5, 100000, 0.000000);

-- ----------------------------
-- Table structure for member_level
-- ----------------------------
DROP TABLE IF EXISTS `member_level`;
CREATE TABLE `member_level` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_default` bit(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ----------------------------
-- Table structure for member_promotion
-- ----------------------------
DROP TABLE IF EXISTS `member_promotion`;
CREATE TABLE `member_promotion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `invitees_id` bigint(20) DEFAULT NULL,
  `inviter_id` bigint(20) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_sign_record
-- ----------------------------
DROP TABLE IF EXISTS `member_sign_record`;
CREATE TABLE `member_sign_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `coin_name` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `sign_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7qa42qkaoqxlyvwhxwdstclic` (`coin_name`),
  KEY `FK2r4i90tejcbf85vhk0d8besle` (`member_id`),
  KEY `FKq1926wgosqk7ka4kvw8rtxew` (`sign_id`),
  CONSTRAINT `FK2r4i90tejcbf85vhk0d8besle` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK7qa42qkaoqxlyvwhxwdstclic` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKq1926wgosqk7ka4kvw8rtxew` FOREIGN KEY (`sign_id`) REFERENCES `sign` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_transaction
-- ----------------------------
DROP TABLE IF EXISTS `member_transaction`;
CREATE TABLE `member_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `airdrop_id` bigint(20) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '充币金额',
  `create_time` datetime DEFAULT NULL,
  `fee` decimal(19,8) DEFAULT NULL,
  `flag` int(11) NOT NULL DEFAULT '0',
  `member_id` bigint(20) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_wallet
-- ----------------------------
DROP TABLE IF EXISTS `member_wallet`;
CREATE TABLE `member_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `balance` decimal(18,8) DEFAULT NULL COMMENT '可用余额',
  `frozen_balance` decimal(18,8) DEFAULT NULL COMMENT '冻结余额',
  `release_balance` decimal(18,8) DEFAULT NULL COMMENT '待释放余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包不是锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKm68bscpof0bpnxocxl4qdnvbe` (`member_id`,`coin_id`),
  KEY `FKf9tgbp9y9py8t9c5xj0lllcib` (`coin_id`),
  CONSTRAINT `FKf9tgbp9y9py8t9c5xj0lllcib` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for member_wallet_1556542005633
-- ----------------------------
DROP TABLE IF EXISTS `member_wallet_1556542005633`;
CREATE TABLE `member_wallet_1556542005633` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `address` varchar(255) DEFAULT NULL,
  `balance` decimal(18,8) DEFAULT NULL COMMENT '可用余额',
  `frozen_balance` decimal(18,8) DEFAULT NULL COMMENT '冻结余额',
  `release_balance` decimal(18,8) DEFAULT NULL COMMENT '待释放余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包不是锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------





-- ----------------------------
-- Table structure for otc_coin
-- ----------------------------
DROP TABLE IF EXISTS `otc_coin`;
CREATE TABLE `otc_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buy_min_amount` decimal(18,8) DEFAULT NULL COMMENT '买入广告最低发布数量',
  `coin_scale` int(11) DEFAULT '8' COMMENT '币种精度',
  `is_platform_coin` int(11) DEFAULT NULL,
  `jy_rate` decimal(18,6) DEFAULT NULL COMMENT '交易手续费率',
  `max_trading_time` int(11) DEFAULT '0' COMMENT '广告上架后自动下架时间，单位为秒，0表示不过期',
  `max_volume` int(11) DEFAULT '0' COMMENT '最大挂单数量，0表示不限制',
  `name` varchar(255) NOT NULL,
  `name_cn` varchar(255) NOT NULL,
  `sell_min_amount` decimal(18,8) DEFAULT NULL COMMENT '卖出广告最低发布数量',
  `sort` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `otc_coin`(`id`, `buy_min_amount`, `coin_scale`, `is_platform_coin`, `jy_rate`, `max_trading_time`, `max_volume`, `name`, `name_cn`, `sell_min_amount`, `sort`, `status`, `unit`) VALUES (4, 12.00000000, 8, 0, 1.000000, 0, 0, 'USDT', 'USDT', 13.00000000, 0, 0, 'USDT');

-- ----------------------------
-- Table structure for otc_order
-- ----------------------------
DROP TABLE IF EXISTS `otc_order`;
CREATE TABLE `otc_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `advertise_id` bigint(20) NOT NULL,
  `advertise_type` int(11) NOT NULL,
  `ali_no` varchar(255) DEFAULT NULL,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `card_no` varchar(255) DEFAULT NULL,
  `cancel_time` datetime DEFAULT NULL,
  `commission` decimal(18,8) DEFAULT NULL COMMENT '手续费',
  `country` varchar(255) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `customer_id` bigint(20) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_real_name` varchar(255) DEFAULT NULL,
  `max_limit` decimal(18,2) DEFAULT NULL COMMENT '最高交易额',
  `member_id` bigint(20) NOT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `member_real_name` varchar(255) DEFAULT NULL,
  `min_limit` decimal(18,2) DEFAULT NULL COMMENT '最低交易额',
  `money` decimal(18,2) DEFAULT NULL COMMENT '交易金额',
  `number` decimal(18,8) DEFAULT NULL COMMENT '交易数量',
  `order_sn` varchar(255) NOT NULL,
  `pay_mode` varchar(255) NOT NULL,
  `pay_time` datetime DEFAULT NULL,
  `price` decimal(18,2) DEFAULT NULL COMMENT '价格',
  `reference_number` varchar(16) DEFAULT '' COMMENT '付款参考号',
  `release_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `qr_we_code_url` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `coin_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_qmfpakgu6mowmslv4m5iy43t9` (`order_sn`),
  KEY `FKjh47nnmiehmu15wqjfwnh8a6u` (`coin_id`),
  CONSTRAINT `FKjh47nnmiehmu15wqjfwnh8a6u` FOREIGN KEY (`coin_id`) REFERENCES `otc_coin` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for otc_wallet
-- ----------------------------
DROP TABLE IF EXISTS `otc_wallet`;
CREATE TABLE `otc_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `balance` decimal(18,8) DEFAULT NULL COMMENT '可用余额',
  `frozen_balance` decimal(18,8) DEFAULT NULL COMMENT '冻结余额',
  `release_balance` decimal(18,8) DEFAULT NULL COMMENT '待释放余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包不是锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `version` int(11) NOT NULL,
  `coin_id` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcy68pru628qy2ker8klalb5j7` (`coin_id`),
  CONSTRAINT `FKcy68pru628qy2ker8klalb5j7` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for payment_history
-- ----------------------------
DROP TABLE IF EXISTS `payment_history`;
CREATE TABLE `payment_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '金额',
  `create_time` datetime DEFAULT NULL,
  `interest` decimal(18,8) DEFAULT NULL COMMENT '还款的利息数额',
  `interest_rate` decimal(18,8) DEFAULT NULL COMMENT '借贷利率',
  `loan_record_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `payment_type` int(11) DEFAULT NULL,
  `principal` decimal(18,8) DEFAULT NULL COMMENT '还款的本金数额',
  `status` int(11) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `lever_coin_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqfy2j75nya39clfyban0tt2ss` (`coin_id`),
  KEY `FKo1ixtge087s4m0rjl50o5d24j` (`lever_coin_id`),
  CONSTRAINT `FKo1ixtge087s4m0rjl50o5d24j` FOREIGN KEY (`lever_coin_id`) REFERENCES `lever_coin` (`id`),
  CONSTRAINT `FKqfy2j75nya39clfyban0tt2ss` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for platform_transaction
-- ----------------------------
DROP TABLE IF EXISTS `platform_transaction`;
CREATE TABLE `platform_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT '0.00000000',
  `biz_order_id` varchar(255) DEFAULT NULL,
  `day` varchar(255) DEFAULT NULL,
  `direction` int(11) NOT NULL,
  `time` datetime DEFAULT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for poundage_convert_eth
-- ----------------------------
DROP TABLE IF EXISTS `poundage_convert_eth`;
CREATE TABLE `poundage_convert_eth` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin_id` varchar(255) DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  `eth_usdt_rate` varchar(255) DEFAULT NULL,
  `exchange_order_id` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `mine_amount` decimal(18,8) DEFAULT '0.00000000',
  `poundage_amount` decimal(18,8) DEFAULT '0.00000000',
  `poundage_amount_eth` decimal(18,8) DEFAULT '0.00000000',
  `symbol` varchar(255) DEFAULT NULL,
  `transaction_time` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `usdt_rate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pre_coin
-- ----------------------------
DROP TABLE IF EXISTS `pre_coin`;
CREATE TABLE `pre_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `link` varchar(256) DEFAULT NULL COMMENT '详情链接',
  `name` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `vote_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7o7qmhrc4n2fvyl1mf5k1lhtw` (`vote_id`),
  CONSTRAINT `FK7o7qmhrc4n2fvyl1mf5k1lhtw` FOREIGN KEY (`vote_id`) REFERENCES `vote` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for release_balance
-- ----------------------------
DROP TABLE IF EXISTS `release_balance`;
CREATE TABLE `release_balance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `coin_name` varchar(255) DEFAULT NULL COMMENT '币种名字',
  `coin_unit` varchar(255) DEFAULT NULL COMMENT '币种单位',
  `register_time` datetime DEFAULT NULL COMMENT '注册时间',
  `user_name` varchar(255) DEFAULT NULL COMMENT '会员名称',
  `phone` varchar(255) DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `release_balance` decimal(20,0) DEFAULT NULL COMMENT '释放余额',
  `release_state` varchar(20) DEFAULT NULL COMMENT '释放余额状态  0 - 未审核   1 - 已审核  2 - 全部',
  `release_time` datetime DEFAULT NULL COMMENT '释放时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='注册送币审核';

-- ----------------------------
-- Table structure for reward_activity_setting
-- ----------------------------
DROP TABLE IF EXISTS `reward_activity_setting`;
CREATE TABLE `reward_activity_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `info` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKra9w7qwgbxti55cmkb6kycau7` (`admin_id`),
  KEY `FKmxq57nrqt4lb9lqpxwc095h1h` (`coin_id`),
  CONSTRAINT `FKmxq57nrqt4lb9lqpxwc095h1h` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKra9w7qwgbxti55cmkb6kycau7` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for reward_promotion_setting
-- ----------------------------
DROP TABLE IF EXISTS `reward_promotion_setting`;
CREATE TABLE `reward_promotion_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `effective_time` int(11) NOT NULL,
  `info` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7fl96plmj12crmepem7t876u3` (`admin_id`),
  KEY `FKfhtlsn9g8lj5qecbo596ymhey` (`coin_id`),
  CONSTRAINT `FK7fl96plmj12crmepem7t876u3` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKfhtlsn9g8lj5qecbo596ymhey` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for reward_record
-- ----------------------------
DROP TABLE IF EXISTS `reward_record`;
CREATE TABLE `reward_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '数目',
  `create_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKtm2ha75hh60am8n7lco838nmo` (`coin_id`),
  KEY `FK9m2bd6gjgad67vb6of4waxtov` (`member_id`),
  CONSTRAINT `FK9m2bd6gjgad67vb6of4waxtov` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKtm2ha75hh60am8n7lco838nmo` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for reward_wallet
-- ----------------------------
DROP TABLE IF EXISTS `reward_wallet`;
CREATE TABLE `reward_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `balance` decimal(18,8) DEFAULT NULL COMMENT '可用余额',
  `coin_unit` varchar(255) DEFAULT NULL,
  `frozen_balance` decimal(18,8) DEFAULT NULL COMMENT '冻结余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包不是锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for risk_record
-- ----------------------------
DROP TABLE IF EXISTS `risk_record`;
CREATE TABLE `risk_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `current_threshold` decimal(19,2) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `perform_actions` int(11) DEFAULT NULL,
  `lever_coin_id` bigint(20) DEFAULT NULL,
  `loss_threshold_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKg61lc7c35ro0snj1le341yg1c` (`lever_coin_id`),
  KEY `FKk8u66l4rub7e8hux5yn1an3vo` (`loss_threshold_id`),
  CONSTRAINT `FKg61lc7c35ro0snj1le341yg1c` FOREIGN KEY (`lever_coin_id`) REFERENCES `lever_coin` (`id`),
  CONSTRAINT `FKk8u66l4rub7e8hux5yn1an3vo` FOREIGN KEY (`loss_threshold_id`) REFERENCES `loss_threshold` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for robot_transaction
-- ----------------------------
DROP TABLE IF EXISTS `robot_transaction`;
CREATE TABLE `robot_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '充币金额',
  `create_time` datetime DEFAULT NULL,
  `fee` decimal(19,8) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sign
-- ----------------------------
DROP TABLE IF EXISTS `sign`;
CREATE TABLE `sign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK58kn2gi7nvswa8hb76h87wtdl` (`coin_name`),
  CONSTRAINT `FK58kn2gi7nvswa8hb76h87wtdl` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_advertise
-- ----------------------------
DROP TABLE IF EXISTS `sys_advertise`;
CREATE TABLE `sys_advertise` (
  `serial_number` varchar(255) NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  `content` text,
  `create_time` datetime DEFAULT NULL,
  `end_time` varchar(255) NOT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  `start_time` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `sys_advertise_location` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`serial_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_help
-- ----------------------------
DROP TABLE IF EXISTS `sys_help`;
CREATE TABLE `sys_help` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) DEFAULT NULL,
  `content` text,
  `create_time` datetime DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `sys_help_classification` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `is_top` varchar(1) DEFAULT '1' COMMENT '是否置顶默认非置顶',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_sms
-- ----------------------------
DROP TABLE IF EXISTS `tb_sms`;
CREATE TABLE `tb_sms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key_id` varchar(255) DEFAULT NULL,
  `key_secret` varchar(255) DEFAULT NULL,
  `sign_id` varchar(255) DEFAULT NULL,
  `sms_name` varchar(255) DEFAULT NULL,
  `sms_status` varchar(255) DEFAULT NULL,
  `template_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for transfer_address
-- ----------------------------
DROP TABLE IF EXISTS `transfer_address`;
CREATE TABLE `transfer_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `min_amount` decimal(18,2) DEFAULT NULL COMMENT '最低转账数目',
  `status` int(11) DEFAULT NULL,
  `transfer_fee` decimal(18,6) DEFAULT NULL COMMENT '转账手续费率',
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7iv0cmmj36ncaw1nx92x15vtu` (`coin_id`),
  CONSTRAINT `FK7iv0cmmj36ncaw1nx92x15vtu` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `transfer_record`;
CREATE TABLE `transfer_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `amount` decimal(19,2) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `fee` decimal(18,8) DEFAULT NULL COMMENT '手续费',
  `member_id` bigint(20) DEFAULT NULL,
  `order_sn` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKkrlf3bglmf2c51sorq9fpue0g` (`coin_id`),
  CONSTRAINT `FKkrlf3bglmf2c51sorq9fpue0g` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for vote
-- ----------------------------
DROP TABLE IF EXISTS `vote`;
CREATE TABLE `vote` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,2) DEFAULT NULL COMMENT '每次投票消耗的平台币数量',
  `create_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `vote_limit` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for vote_detail
-- ----------------------------
DROP TABLE IF EXISTS `vote_detail`;
CREATE TABLE `vote_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `vote_amount` int(11) NOT NULL,
  `pre_coin_id` bigint(20) DEFAULT NULL,
  `vote_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpe45amd6s8di5y2x7tf8ir6vo` (`pre_coin_id`),
  KEY `FKrdttjtg7msjaguxmnv0ntf5yt` (`vote_id`),
  CONSTRAINT `FKpe45amd6s8di5y2x7tf8ir6vo` FOREIGN KEY (`pre_coin_id`) REFERENCES `pre_coin` (`id`),
  CONSTRAINT `FKrdttjtg7msjaguxmnv0ntf5yt` FOREIGN KEY (`vote_id`) REFERENCES `vote` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for website_information
-- ----------------------------
DROP TABLE IF EXISTS `website_information`;
CREATE TABLE `website_information` (
  `id` bigint(20) NOT NULL,
  `address_icon` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `copyright` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `other_information` text,
  `postcode` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for withdraw_record
-- ----------------------------
DROP TABLE IF EXISTS `withdraw_record`;
CREATE TABLE `withdraw_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `arrived_amount` decimal(18,8) DEFAULT NULL COMMENT '预计到账数量',
  `can_auto_withdraw` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deal_time` datetime DEFAULT NULL,
  `fee` decimal(18,8) DEFAULT NULL COMMENT '手续费',
  `is_auto` int(11) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `total_amount` decimal(18,8) DEFAULT NULL COMMENT '申请总数量',
  `transaction_number` varchar(255) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2lmq6bcbk4nl3hmqcxbnx2kuc` (`admin_id`),
  KEY `FK6drad9oqabujy0jsre3minxi` (`coin_id`),
  CONSTRAINT `FK2lmq6bcbk4nl3hmqcxbnx2kuc` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FK6drad9oqabujy0jsre3minxi` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;




