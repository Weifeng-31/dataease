DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` bigint(20) DEFAULT NULL COMMENT '上级部门',
  `sub_count` int(5) DEFAULT '0' COMMENT '子部门数目',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `dept_sort` int(5) DEFAULT '999' COMMENT '排序',
  `enabled` bit(1) NOT NULL COMMENT '状态',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新者',
  `create_time` bigint(13) DEFAULT NULL COMMENT '创建日期',
  `update_time` bigint(13) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE,
  KEY `inx_pid` (`pid`),
  KEY `inx_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='部门';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` VALUES (18, 0, 1, '上海飞致云', 1, b'1', NULL, NULL, 1614048906358, 1614048906358);
INSERT INTO `sys_dept` VALUES (19, 0, 1, '北京飞致云', 2, b'1', NULL, NULL, 1614048918465, 1614048918465);
INSERT INTO `sys_dept` VALUES (20, 18, 0, '营销部', 1, b'1', NULL, NULL, 1614048946370, 1614049006759);
INSERT INTO `sys_dept` VALUES (21, 19, 0, '综合部', 1, b'1', NULL, NULL, 1614048963483, 1614048963483);
INSERT INTO `sys_dept` VALUES (22, 0, 0, '深圳飞致云', 3, b'1', NULL, NULL, 1614679834772, 1614679834772);
INSERT INTO `sys_dept` VALUES (23, 0, 0, '南京飞致云', 4, b'1', NULL, NULL, 1614679890462, 1614679890462);
COMMIT;



DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` bigint(20) DEFAULT NULL COMMENT '上级菜单ID',
  `sub_count` int(5) DEFAULT '0' COMMENT '子菜单数目',
  `type` int(11) DEFAULT NULL COMMENT '菜单类型',
  `title` varchar(255) DEFAULT NULL COMMENT '菜单标题',
  `name` varchar(255) DEFAULT NULL COMMENT '组件名称',
  `component` varchar(255) DEFAULT NULL COMMENT '组件',
  `menu_sort` int(5) DEFAULT NULL COMMENT '排序',
  `icon` varchar(255) DEFAULT NULL COMMENT '图标',
  `path` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `i_frame` bit(1) DEFAULT NULL COMMENT '是否外链',
  `cache` bit(1) DEFAULT b'0' COMMENT '缓存',
  `hidden` bit(1) DEFAULT b'0' COMMENT '隐藏',
  `permission` varchar(255) DEFAULT NULL COMMENT '权限',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新者',
  `create_time` bigint(13) DEFAULT NULL COMMENT '创建日期',
  `update_time` bigint(13) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`menu_id`) USING BTREE,
  UNIQUE KEY `uniq_title` (`title`),
  UNIQUE KEY `uniq_name` (`name`),
  KEY `inx_pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统菜单';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` VALUES (1, 0, 3, 0, '系统管理', '系统管理', 'Layout', 3, 'system', '/system', NULL, b'0', b'0', 'dir:sys', NULL, NULL, NULL, 1614916695777);
INSERT INTO `sys_menu` VALUES (2, 1, 3, 1, '用户管理', '用户管理', 'system/user/index', 1, 'peoples', 'user', NULL, b'0', b'0', 'user:read', NULL, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (3, 1, 3, 1, '菜单管理', '菜单管理', 'system/menu/index', 2, 'menu', 'menu', NULL, b'0', b'0', 'menu:read', NULL, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (4, 1, 3, 1, '组织管理', '组织管理', 'system/dept/index', 3, 'dept', 'dept', NULL, b'0', b'0', 'dept:read', NULL, NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (5, 1, 3, 1, '角色管理', '角色管理', 'system/role/index', 4, 'role', 'role', b'0', b'0', b'0', 'role:read', NULL, NULL, 1614683852133, 1614683852133);
INSERT INTO `sys_menu` VALUES (6, 1, 0, 1, '参数管理', '参数管理', 'system/systemParamSettings/index', 5, 'sys-tools', 'systemParamSettings', NULL, b'0', b'0', 'sysparam:read', NULL, NULL, NULL, 1614916731805);
INSERT INTO `sys_menu` VALUES (7, 0, 1, 0, '数据管理', '数据管理', 'Layout', 2, 'dataset', '/dataset', NULL, b'0', b'0', 'dir:data', NULL, NULL, NULL, 1614916666408);
INSERT INTO `sys_menu` VALUES (8, 7, 0, 1, '数据管理1', '数据管理1', 'dataset/index', 1, 'dataset', 'index', NULL, b'0', b'0', 'data:read', NULL, NULL, NULL, 1614916684821);
INSERT INTO `sys_menu` VALUES (9, 0, 1, 0, '视图管理', '视图管理', 'Layout', 1, 'chart', '/chart', NULL, b'0', b'0', 'dir:chart', NULL, NULL, NULL, 1614916648098);
INSERT INTO `sys_menu` VALUES (10, 9, 0, 1, '视图1', '视图1', 'chart/index', 1, 'chart', 'index', NULL, b'0', b'0', 'chart:read', NULL, NULL, NULL, 1614915491036);
INSERT INTO `sys_menu` VALUES (11, 1, 4, 1, '数据连接', '数据连接', 'system/datasource/index', 0, 'database', 'index', NULL, b'0', b'0', 'datasource:read', NULL, NULL, NULL, 1614916717642);
INSERT INTO `sys_menu` VALUES (12, 3, 0, 2, '创建菜单', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'menu:add', NULL, NULL, 1614924617327, 1614924617327);
INSERT INTO `sys_menu` VALUES (13, 3, 0, 2, '删除菜单', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'menu:del', NULL, NULL, 1614924667808, 1614924667808);
INSERT INTO `sys_menu` VALUES (14, 3, 0, 2, '编辑菜单', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'menu:edit', NULL, NULL, 1614930734224, 1614936429773);
INSERT INTO `sys_menu` VALUES (15, 2, 0, 2, '创建用户', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'user:add', NULL, NULL, 1614930862373, 1614930862373);
INSERT INTO `sys_menu` VALUES (16, 2, 0, 2, '删除用户', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'user:del', NULL, NULL, 1614930903502, 1614930903502);
INSERT INTO `sys_menu` VALUES (17, 2, 0, 2, '编辑用户', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'user:edit', NULL, NULL, 1614930935529, 1614930935529);
INSERT INTO `sys_menu` VALUES (18, 4, 0, 2, '创建组织', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'dept:add', NULL, NULL, 1614930976297, 1614930976297);
INSERT INTO `sys_menu` VALUES (19, 4, 0, 2, '删除组织', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'dept:del', NULL, NULL, 1614930997130, 1614930997130);
INSERT INTO `sys_menu` VALUES (20, 4, 0, 2, '编辑组织', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'dept:edit', NULL, NULL, 1614931022967, 1614931022967);
INSERT INTO `sys_menu` VALUES (21, 5, 0, 2, '创建角色', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'role:add', NULL, NULL, 1614931069408, 1614931069408);
INSERT INTO `sys_menu` VALUES (22, 5, 0, 2, '删除角色', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'role:del', NULL, NULL, 1614931097720, 1614931097720);
INSERT INTO `sys_menu` VALUES (23, 5, 0, 2, '编辑角色', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'role:edit', NULL, NULL, 1614931124782, 1614931124782);
INSERT INTO `sys_menu` VALUES (24, 11, 0, 2, '创建连接', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'datasource:add', NULL, NULL, 1614931168956, 1614931168956);
INSERT INTO `sys_menu` VALUES (25, 11, 0, 2, '删除连接', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'datasource:del', NULL, NULL, 1614931205899, 1614931205899);
INSERT INTO `sys_menu` VALUES (26, 11, 0, 2, '编辑连接', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'datasource:edit', NULL, NULL, 1614931234105, 1614931234105);
INSERT INTO `sys_menu` VALUES (27, 11, 0, 2, '校验连接', NULL, NULL, 999, NULL, NULL, b'0', b'0', b'0', 'datasource:validate', NULL, NULL, 1614931268578, 1614931268578);
COMMIT;

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `code` varchar(100) NOT NULL COMMENT '代码',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新者',
  `create_time` bigint(13) DEFAULT NULL COMMENT '创建日期',
  `update_time` bigint(13) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`role_id`) USING BTREE,
  UNIQUE KEY `uniq_name` (`name`),
  KEY `role_name_index` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (3, 'admin', '管理员', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role` VALUES (4, 'emp', '普通员工', NULL, NULL, NULL, NULL, NULL);
COMMIT;


DROP TABLE IF EXISTS `sys_roles_menus`;
CREATE TABLE `sys_roles_menus` (
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`menu_id`,`role_id`) USING BTREE,
  KEY `FKcngg2qadojhi3a651a5adkvbq` (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='角色菜单关联';

-- ----------------------------
-- Records of sys_roles_menus
-- ----------------------------
BEGIN;
INSERT INTO `sys_roles_menus` VALUES (1, 3);
INSERT INTO `sys_roles_menus` VALUES (2, 3);
INSERT INTO `sys_roles_menus` VALUES (3, 3);
INSERT INTO `sys_roles_menus` VALUES (4, 3);
INSERT INTO `sys_roles_menus` VALUES (5, 3);
INSERT INTO `sys_roles_menus` VALUES (6, 3);
INSERT INTO `sys_roles_menus` VALUES (7, 3);
INSERT INTO `sys_roles_menus` VALUES (8, 3);
INSERT INTO `sys_roles_menus` VALUES (9, 3);
INSERT INTO `sys_roles_menus` VALUES (10, 3);
INSERT INTO `sys_roles_menus` VALUES (11, 3);
INSERT INTO `sys_roles_menus` VALUES (12, 3);
INSERT INTO `sys_roles_menus` VALUES (13, 3);
INSERT INTO `sys_roles_menus` VALUES (14, 3);
INSERT INTO `sys_roles_menus` VALUES (15, 3);
INSERT INTO `sys_roles_menus` VALUES (16, 3);
INSERT INTO `sys_roles_menus` VALUES (17, 3);
INSERT INTO `sys_roles_menus` VALUES (18, 3);
INSERT INTO `sys_roles_menus` VALUES (19, 3);
INSERT INTO `sys_roles_menus` VALUES (20, 3);
INSERT INTO `sys_roles_menus` VALUES (21, 3);
INSERT INTO `sys_roles_menus` VALUES (22, 3);
INSERT INTO `sys_roles_menus` VALUES (23, 3);
INSERT INTO `sys_roles_menus` VALUES (24, 3);
INSERT INTO `sys_roles_menus` VALUES (25, 3);
INSERT INTO `sys_roles_menus` VALUES (26, 3);
INSERT INTO `sys_roles_menus` VALUES (27, 3);
INSERT INTO `sys_roles_menus` VALUES (1, 4);
INSERT INTO `sys_roles_menus` VALUES (2, 4);
INSERT INTO `sys_roles_menus` VALUES (3, 4);
INSERT INTO `sys_roles_menus` VALUES (12, 4);
COMMIT;


DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门名称',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `nick_name` varchar(255) DEFAULT NULL COMMENT '昵称',
  `gender` varchar(2) DEFAULT NULL COMMENT '性别',
  `phone` varchar(255) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `is_admin` bit(1) DEFAULT b'0' COMMENT '是否为admin账号',
  `enabled` bigint(20) DEFAULT NULL COMMENT '状态：1启用、0禁用',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(255) DEFAULT NULL COMMENT '更新着',
  `pwd_reset_time` bigint(13) DEFAULT NULL COMMENT '修改密码的时间',
  `create_time` bigint(13) DEFAULT NULL COMMENT '创建日期',
  `update_time` bigint(13) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE KEY `UK_kpubos9gc2cvtkb0thktkbkes` (`email`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`),
  KEY `FK5rwmryny6jthaaxkogownknqp` (`dept_id`) USING BTREE,
  KEY `inx_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统用户';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (4, 0, 'admin', '管理员', '男', NULL, 'admin@fit2cloud.com', 'e10adc3949ba59abbe56e057f20f883e', b'1', 1, NULL, NULL, NULL, NULL, 1615184951534);
COMMIT;

-- ----------------------------
-- Table structure for sys_users_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_users_roles`;
CREATE TABLE `sys_users_roles` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE,
  KEY `FKq4eq273l04bpu4efj0jd0jb98` (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户角色关联';

-- ----------------------------
-- Records of sys_users_roles
-- ----------------------------
BEGIN;
INSERT INTO `sys_users_roles` VALUES (4, 3);
COMMIT;