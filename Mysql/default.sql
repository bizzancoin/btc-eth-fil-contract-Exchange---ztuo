-- MySQL dump 10.13  Distrib 5.7.34, for Linux (x86_64)
--
-- Host: localhost    Database: test111
-- ------------------------------------------------------
-- Server version	5.7.34-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activity_link` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `notice_link` varchar(255) DEFAULT NULL,
  `progress` int(11) NOT NULL,
  `settings` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `step` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `accept_unit` varchar(255) NOT NULL,
  `amount_scale` int(11) NOT NULL,
  `banner_image_url` varchar(255) DEFAULT NULL,
  `content` text,
  `contenten` text,
  `detailen` varchar(255) DEFAULT NULL,
  `end_time` varchar(30) NOT NULL DEFAULT '2000-01-01 01:00:00' COMMENT '结束时间',
  `limit_times` int(11) NOT NULL,
  `max_limit_amout` decimal(24,8) DEFAULT NULL,
  `min_limit_amout` decimal(24,8) DEFAULT NULL,
  `price` decimal(18,8) DEFAULT NULL,
  `price_scale` int(11) NOT NULL,
  `small_image_url` varchar(255) DEFAULT NULL,
  `start_time` varchar(30) NOT NULL DEFAULT '2000-01-01 01:00:00' COMMENT '开始时间',
  `titleen` varchar(255) DEFAULT NULL,
  `total_supply` decimal(24,8) NOT NULL,
  `traded_amount` decimal(24,8) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  `freeze_amount` decimal(26,8) DEFAULT NULL,
  `levelone_count` int(11) NOT NULL,
  `mining_days` int(11) NOT NULL,
  `mining_daysprofit` decimal(24,8) DEFAULT NULL,
  `mining_invite` decimal(24,8) DEFAULT NULL,
  `mining_invitelimit` decimal(24,8) DEFAULT NULL,
  `mining_unit` varchar(255) NOT NULL,
  `mining_period` int(11) NOT NULL,
  `hold_limit` decimal(24,8) DEFAULT NULL,
  `hold_unit` varchar(255) DEFAULT NULL,
  `locked_days` int(11) NOT NULL,
  `locked_fee` decimal(24,8) DEFAULT NULL,
  `locked_period` int(11) NOT NULL,
  `locked_unit` varchar(255) DEFAULT NULL,
  `release_amount` decimal(24,8) DEFAULT NULL,
  `release_percent` decimal(24,8) DEFAULT NULL,
  `release_times` decimal(24,8) DEFAULT NULL,
  `release_type` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='创新实验室';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity`
--

LOCK TABLES `activity` WRITE;
/*!40000 ALTER TABLE `activity` DISABLE KEYS */;
INSERT INTO `activity` VALUES (1,'','2020-10-05 22:40:57','This event is exclusively hosted by (GIBX)',NULL,'',1200,'',0,3,'GIBXPartner cloud mining machine(4A）',6,'USDT',2,'','<p><br></p><p><span style=\"font-size: medium; font-weight: bolder;\">关于【合伙人云矿机（3A</span><span style=\"font-size: medium; font-weight: bolder;\">）】</span><br></p><div><div>合伙人云矿机（3A）是GIBX本次推出的带邀请增加产能的云矿机，同时限量发售，每人限购一台。具体规格如下：<br></div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>认购价格：5,000 GUSDT</div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>挖矿时长：6个月（180天）</div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>基础日产出：31 GUSDT/天</div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>年化收益率：15% ~ 200%</div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>发售数量：100000000台</div><div><span style=\"color: rgb(0, 0, 0); font-family: 宋体; font-size: 16px; letter-spacing: normal;\">●&nbsp;</span>邀请增加产能：每邀请一人认购相同类型云矿机，日产能增加2%，上限100%</div></div><div><br></div><div><span style=\"font-weight: bolder;\"><font size=\"3\">关于合伙人云矿机</font></span></div><div><p>币严合伙人云矿机是由GIBX推出的，该系列矿机以扩充平台级合伙人，提升GIBX综合实力为核心目标，并根据合伙人的贡献度给予相应的收益。GIBX合伙人云矿机分为6大类别，分别是：合伙人云矿机（矿霸）、合伙人云矿机（顶级）、合伙人云矿机（豪华）、合伙人云矿机（5A）、合伙人云矿机（4A）、合伙人云矿机（3A）。</p><p><br></p></div><div><p><span style=\"font-weight: bolder; font-size: medium;\">关于</span>GIBX<font size=\"3\"><b>与GUSDT</b></font></p><div>GIBX数字资产交易平台以“严选全球优质数字资产”为核心理念，为用户过滤诸如“资金盘”、“传销盘”等伪区块链数字资产，仅为具有独立公链、拥有极大发展潜力、被大众认可的数字资产提供交易通道。GIBX是由GIBX发布的平台通证，是GIBX数字资产交易平台的唯一权益通证。持有GUSDT可享未来平台分红、空投等权益。</div></div><div><br></div><div><span style=\"font-weight: bolder;\"><font size=\"3\">关于认购与部署</font></span></div><div>认购合伙人云矿机后，平台将从您的账户扣除对应数量的GUSDT，并将由GIBX工作人员于次日部署，部署完成后，将于第三日开始产生收益。</div><div><br></div><div><span style=\"font-weight: bolder;\"><font size=\"3\">关于产出</font></span>GIBX<span style=\"font-size: medium; font-weight: bolder;\">发放</span></div><div>合伙人云矿机每日产出GUSDT，产出GUSDT每日发放到账。</div><div><br></div><div><span style=\"font-weight: bolder;\"><font size=\"3\">关于邀请增加产能</font></span></div><div>本次GIBX合伙人云矿机仅有合伙人云矿机（5A）、合伙人云矿机（4A）、合伙人云矿机（3A）三款矿机支持邀请增加产能，即邀请好友注册并认购矿机，邀请人即可获得2%的日产能提升。</div><div><br></div><div>注意：本活动最终解释权归GIBX官方所有</div><div><br></div><div><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; letter-spacing: 1px;\"><span style=\"font-weight: bolder;\"><font size=\"3\">风险提示</font><font style=\"font-size: 14px;\">：</font></span></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">数字资产是创新的投资产品，价格波动较大，请您理性判断自己的投资能力，谨慎做出投资决策。</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\"><br></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; letter-spacing: 1px;\"><span style=\"color: rgb(44, 62, 80); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; letter-spacing: 1.5px; text-align: left;\">GIBX</span><span style=\"font-weight: bolder;\"><font size=\"3\">&nbsp;GROUP<span style=\"font-size: 14px;\">：</span></font></span></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\"><br></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">客户服务：service@bizzan.pro</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">技术支持：support@bizzan.pro</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">投诉建议：ceo@bizzan.pro</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\"><br></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;\\\\5FAE软雅黑&quot;, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">感谢您对<span style=\"color: rgb(44, 62, 80); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; letter-spacing: 1.5px; text-align: left; font-size: 12px;\">GIBX</span>的支持，<span style=\"color: rgb(44, 62, 80); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; letter-spacing: 1.5px; text-align: left; font-size: 12px;\">GIBX</span>团队期待您的宝贵意见。</p></div>','',NULL,'2021-10-17 00:00:00',999,20000.00000000,1.00000000,0.05000000,2,'https://bizzanex.oss-cn-hangzhou.aliyuncs.com/2021/02/25/bc11e28f-a5f2-43cc-9b84-c788ac42a92b.png','2021-07-05 00:00:00',NULL,1000000000.00000000,11.00000000,'台',0.00000000,0,180,31.00000000,0.00000000,1.00000000,'BTC',0,0.00000000,'500',3,200.00000000,2,'USDT',3000000.00000000,0.00000000,2.00000000,0),(2,'','2021-05-29 15:22:15','限时抢购',NULL,'',11,'',0,3,'限时抢购',1,'USDT',2,'','<p><br></p>','',NULL,'2021-06-30 00:00:00',10,1000.00000000,100.00000000,1.00000000,2,'','2021-06-09 00:00:00',NULL,100000.00000000,0.00000000,'BTC',0.00000000,0,0,NULL,0.00000000,0.00000000,'',0,0.00000000,'',0,0.00000000,0,'',0.00000000,0.00000000,0.00000000,0),(3,'1111','2021-06-10 21:57:20','FASHOU',NULL,'111',1,'1111',0,1,'GIBX',4,'usdt',1,'','<p><br></p>','',NULL,'2021-08-12 00:00:00',10,100000.00000000,1.00000000,0.05800000,1,'','2021-06-09 00:00:00',NULL,1000000.00000000,212.00000000,'gibx',0.00000000,0,0,NULL,1.00000000,1.00000000,'',0,0.00000000,'100',11,0.00000000,2,'',1.00000000,0.00000000,1.00000000,0),(4,'','2021-08-20 22:49:02','In June 2021, EME fully launches global ICO',NULL,'',0,'',0,1,'EME《Emerging market economies》',4,'USDT',2,'https://gibx.oss-cn-hongkong.aliyuncs.com/2021/08/20/2f34fc98-6997-4e05-9a3d-93dd903ab7c6.jpg','<p>In December 2019, the EME Foundation was formally established in Singapore. EME adheres to the concept of \"consensus value\". Through data rights confirmation, value is redistributed, data ownership returns to individuals, and each data generates value! The public chain EME was born from this.<br></p><p>The EME project vision provides shared, co-governance, transparent and secure underlying services for the trillion-level big data economy market in the future. Create an ecological model of one main chain that is the consensus of thousands of enterprise side chains, empower enterprises in all directions, create a one-stop de-neutralized service-type public chain, and solve the pain points of cumbersome enterprise blockchain operation and circulation. For details, please refer to the EME Public Chain Technology Value Advantage on page P19 of the \"EME White Paper\".</p><p>In June 2021, EME will fully open the global ICO, which is an important part of EME\'s global community growth plan. It is of great significance for the healthy construction and sustainable development of the EME community in the future. In addition, the global community created by EME is precisely to build a global community covering all parts of the world, across cultures, and across the Internet, finance, 5G technology and other industries, so as to achieve true complementarity of resources. We sincerely invite you to witness the development of EME and the future of blockchain technology value.</p><p>Regarding the method of obtaining EME Token, the most important one is that EME is obtained as a blockchain technology DEFI+ liquidity mining. After the POS mechanism + POP mechanism is confirmed through data rights, the rewards for data activities are retrieved and used to redistribute the value again and generate data computing power for mining. Each EME obtained by the consensus group is a manifestation of the value of personal data. This method will surely lay a solid market foundation in the future blockchain market and open up a broader path for the development of EME.</p><p><br></p><p>Token: EME</p><p>Total issuance: 1000000000</p><p>Contract address: 0x8c21beaf6649769b856af00f561b4e9a1c510812</p><p>Token distribution: EME fund: 5% (the lock-up is gradually released in 2 years); the creation team: 15% (combustion and circulation, of which 10% will start mining after the combustion is completed); 80% is used for liquid mining.</p><p>GIBX Issue price：0.3USDT</p><p>GIBX ICO issuance time : August 20, 2021 to December 30, 2021</p>','',NULL,'2021-08-31 00:00:00',10000,1000000000.00000000,10000.00000000,0.30000000,2,'https://gibx.oss-cn-hongkong.aliyuncs.com/2021/08/20/5361542d-8dfd-451b-ba19-0a72412a992c.jpg','2021-08-20 00:00:00',NULL,1000000000.00000000,0.00000000,'EME',0.00000000,0,0,NULL,0.00000000,0.00000000,'',0,0.00000000,'USDT',0,0.00000000,0,'',0.00000000,0.00000000,0.00000000,0),(5,'https://www.gibxcoin.com/#/lab','2021-08-21 00:02:04','In June 2021, EME fully launches global ICO',NULL,'https://www.gibxcoin.com/#/announcement/0',99,'',1,1,'EME《Emerging market economies》',4,'USDT',2,'','<p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">In December 2019, the EME Foundation was formally established in Singapore. EME adheres to the concept of \"consensus value\". Through data rights confirmation, value is redistributed, data ownership returns to individuals, and each data generates value! The public chain EME was born from this.<br></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">The EME project vision provides shared, co-governance, transparent and secure underlying services for the trillion-level big data economy market in the future. Create an ecological model of one main chain that is the consensus of thousands of enterprise side chains, empower enterprises in all directions, create a one-stop de-neutralized service-type public chain, and solve the pain points of cumbersome enterprise blockchain operation and circulation. For details, please refer to the EME Public Chain Technology Value Advantage on page P19 of the \"EME White Paper\".</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">In June 2021, EME will fully open the global ICO, which is an important part of EME\'s global community growth plan. It is of great significance for the healthy construction and sustainable development of the EME community in the future. In addition, the global community created by EME is precisely to build a global community covering all parts of the world, across cultures, and across the Internet, finance, 5G technology and other industries, so as to achieve true complementarity of resources. We sincerely invite you to witness the development of EME and the future of blockchain technology value.</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">Regarding the method of obtaining EME Token, the most important one is that EME is obtained as a blockchain technology DEFI+ liquidity mining. After the POS mechanism + POP mechanism is confirmed through data rights, the rewards for data activities are retrieved and used to redistribute the value again and generate data computing power for mining. Each EME obtained by the consensus group is a manifestation of the value of personal data. This method will surely lay a solid market foundation in the future blockchain market and open up a broader path for the development of EME.</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\"><br></p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">Token: EME</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">Total issuance: 1000000000</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">Contract address: 0x8c21beaf6649769b856af00f561b4e9a1c510812</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">Token distribution: EME fund: 5% (the lock-up is gradually released in 2 years); the creation team: 15% (combustion and circulation, of which 10% will start mining after the combustion is completed); 80% is used for liquid mining.</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">GIBX Issue price：0.3USDT</p><p style=\"padding-top: 0px; padding-bottom: 0px; text-align: justify; color: rgb(116, 119, 122); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, 微软雅黑, Arial, sans-serif; font-size: 14px; letter-spacing: 1px;\">GIBX ICO issuance time : August 20, 2021 to December 30, 2021</p>','',NULL,'2021-12-30 00:00:00',0,0.00000000,15000.00000000,0.30000000,2,'https://gibx.oss-cn-hongkong.aliyuncs.com/2021/08/21/cac4f77f-0bf3-49d2-9cde-552a0ccb7039.jpg','2021-08-20 00:00:00',NULL,1000000000.00000000,999935049.00000000,'EME',0.00000000,0,0,NULL,0.00000000,0.00000000,'',0,4500.00000000,'USDT',0,0.00000000,0,'',0.00000000,0.00000000,0.00000000,0),(6,'','2021-09-08 07:54:39','',NULL,'',0,'',0,1,'',1,'',2,'','<p><br></p>','',NULL,'2021-09-07 19:58:13',0,0.00000000,0.00000000,0.00010000,2,'','2021-09-07 19:58:13',NULL,0.00000000,0.00000000,'',0.00000000,0,0,NULL,0.00000000,0.00000000,'',0,0.00000000,'',0,0.00000000,0,'',0.00000000,0.00000000,0.00000000,0);
/*!40000 ALTER TABLE `activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_order`
--

DROP TABLE IF EXISTS `activity_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) DEFAULT NULL,
  `amount` decimal(24,8) DEFAULT NULL,
  `base_symbol` varchar(255) DEFAULT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `freeze_amount` decimal(24,8) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `price` decimal(24,8) DEFAULT NULL,
  `state` int(11) NOT NULL,
  `turnover` decimal(26,16) DEFAULT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_order`
--

LOCK TABLES `activity_order` WRITE;
/*!40000 ALTER TABLE `activity_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `enable` int(11) DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `mobile_phone` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `qq` varchar(255) DEFAULT NULL,
  `real_name` varchar(255) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `department_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_gfn44sntic2k93auag97juyij` (`username`) USING BTREE,
  KEY `FKibjnyhe6m46qfkc6vgbir1ucq` (`department_id`) USING BTREE,
  CONSTRAINT `FKnmmt6f2kg0oaxr11uhy7qqf3w` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='管理员';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'','root',0,NULL,'2021-11-18 16:37:36','13800138000','1ac745afa492672279d680cd4598fbb9','000000','Admin',1,0,'root',1);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_access_log`
--

DROP TABLE IF EXISTS `admin_access_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_access_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `access_ip` varchar(255) DEFAULT NULL,
  `access_method` varchar(255) DEFAULT NULL,
  `access_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `module` int(11) DEFAULT NULL,
  `operation` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员访问日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_access_log`
--

LOCK TABLES `admin_access_log` WRITE;
/*!40000 ALTER TABLE `admin_access_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_access_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_permission`
--

DROP TABLE IF EXISTS `admin_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='后台菜单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_permission`
--

LOCK TABLES `admin_permission` WRITE;
/*!40000 ALTER TABLE `admin_permission` DISABLE KEYS */;
INSERT INTO `admin_permission` VALUES (2,'角色管理','system:role:all',8,0,'角色管理'),(3,'用户管理','system:employee:page-query',8,0,'用户管理'),(4,'部门管理','system:department:all',8,0,'部门管理'),(5,'站点管理','system:website-information:find-one',8,0,'站点管理'),(6,'菜单管理','system:role:permission:all',8,0,'菜单管理'),(7,'系统日志','system:access-log:page-query',8,0,'系统日志'),(8,'系统管理','system-------',0,100,'系统管理'),(9,'广告管理','cms:system-advertise:page-query',18,0,'广告管理'),(10,'帮助管理','cms:system-help:page-query',18,0,'帮助管理'),(11,'会员管理','member--------',0,1,'会员管理'),(12,'会员管理','member:page-query',11,0,'会员管理'),(13,'实名管理','member:member-application:page-query',11,0,'实名管理'),(14,'会员监控','member--------',11,0,'会员监控'),(18,'内容管理','cms-------',0,9,'内容管理'),(19,'交易明细','finance:member-transaction:page-query',93,0,'交易记录'),(20,'提现管理','finance:withdraw-record:page-query',93,0,'提现管理'),(23,'币种管理','system:coin:page-query',8,0,'币币币种管理'),(26,'公告管理','cms:notice',18,0,'公告管理'),(27,'创建修改角色','system:role:merge',8,0,'创建修改角色'),(28,'更改角色权限','system:role:permission:update',8,0,'更改角色权限'),(29,'角色拥有权限','system:role:permission',8,0,'角色拥有权限'),(30,'全部权限树','system:role:permission:all',8,0,'全部权限树'),(31,'创建更改后台用户','system:employee:merge',8,0,'创建更改后台用户'),(32,'后台用户详情','system:employee:detail',8,0,'后台用户详情'),(33,'站点信息修改','system:website-information:alter',8,0,'站点信息修改'),(34,'系统日志详情','system:access-log:detail',8,0,'系统日志详情'),(35,'创建系统广告','cms:system-advertise:create',18,0,'创建系统广告'),(36,'所有系统广告','cms:system-advertise:all',18,0,'所有系统广告'),(37,'系统广告详情','cms:system-advertise:detail',18,0,'系统广告详情'),(38,'更新系统广告','cms:system-advertise:update',18,0,'更新系统广告'),(39,'删除系统广告','cms:system-advertise:deletes',18,0,'删除系统广告'),(40,'导出广告excel','cms:system-advertise:out-excel',18,0,'导出广告excel'),(41,'创建系统帮助','cms:system-help:create',18,0,'创建系统帮助'),(42,'系统帮助详情','cms:system-help:detail',18,0,'系统帮助详情'),(43,'更新系统帮助','cms:system-help:update',18,0,'更新系统帮助'),(44,'删除系统帮助','cms:system-help:deletes',18,0,'删除系统帮助'),(45,'导出系统帮助excel','cms:system-help:out-excel',18,0,'导出系统帮助excel'),(46,'会员详情','member:detail',11,0,'会员详情'),(47,'会员删除','member:delete',11,0,'会员删除'),(48,'会员更新','member:update',11,0,'会员更新'),(49,'认证商家审核','member:audit-business',66,0,'认证商家审核'),(50,'导出会员excel','member:out-excel',11,0,'导出会员excel'),(51,'实名信息详情','member:member-application:detail',11,0,'实名信息详情'),(52,'实名审核通过','member:member-application:pass',11,0,'实名审核通过'),(53,'实名审核不通过','member:member-application:no-pass',11,0,'实名审核不通过'),(54,'交易记录详情','finance:member-transaction:detail',93,0,'交易记录详情'),(55,'导出交易记录excel','finance:member-transaction:out-excel',93,0,'导出交易记录excel'),(56,'提现记录详情','finance:withdraw-record:detail',93,0,'提现记录详情'),(57,'提现记录一键审核通过','finance:withdraw-record:audit-pass',93,0,'提现记录一键审核通过'),(58,'提现记录一键审核不通过','finance:withdraw-record:audit-no-pass',93,0,'提现记录一键审核不通过'),(59,'批量打款','finance:withdraw-record:remittance',93,0,'批量打款'),(60,'币币管理','exchange-------',0,5,'币币管理父菜单'),(61,'币币交易订单详情','exchange:exchange-order:detail',60,0,'币币交易订单详情'),(62,'订单管理','exchange:exchange-order:page-query',60,0,'币币交易订单'),(63,'导出币币交易订单excel','exchange:exchange-order:out-excel',60,0,'导出币币交易订单excel'),(64,'币种管理','exchange:exchange-coin:page-query',60,0,'币种管理'),(65,'币币交易对详情','exchange:exchange-coin:detail',60,0,'币币交易对详情'),(66,'OTC管理','otc-------',0,6,'法币otc'),(67,'后台广告详情','otc:advertise:detail',66,0,'后台广告详情'),(68,'关闭后台广告','otc:advertise:turnoff',66,0,'关闭后台广告'),(69,'后台广告状态修改','otc:advertise:alter-status',66,0,'后台广告状态修改'),(70,'后台广告','otc:advertise:page-query',66,0,'后台广告'),(71,'后台广告导出excel','otc:advertise:out-excel',66,0,'后台广告导出excel'),(72,'后台申诉','otc:appeal:page-query',66,0,'后台申诉'),(73,'申诉详情','otc:appeal:detail',66,0,'申诉详情'),(74,'申诉处理','otc:appeal:audit',66,0,'申诉处理'),(75,'法币交易订单详情','otc:order:detail',66,0,'法币交易订单详情'),(76,'法币交易订单状态修改','otc:order:alert-status',66,0,'法币交易订单状态修改'),(77,'订单管理','otc:order:page-query',66,0,'法币交易订单'),(78,'导出法币交易订单excel','otc:order:out-excel',66,0,'导出法币交易订单excel'),(79,'创建otc币种','otc:otc-coin:create',66,0,'创建otc币种'),(80,'otc币种详情','otc:otc-coin:detail',66,0,'otc币种详情'),(81,'otc币种更新','otc:otc-coin:update',66,0,'otc币种更新'),(82,'otc币种交易率修改','otc:otc-coin:alter-jy-rate',66,0,'otc币种交易率修改'),(83,'币种管理','otc:otc-coin:page-query',66,0,'法币币种管理'),(84,'导出otc币种excel','otc:otc-coin:out-excel',66,0,'导出otc币种excel'),(85,'创建后台货币','system:coin:create',8,0,'创建后台货币'),(86,'部门详情','system:department:detail',8,0,'部门详情'),(87,'查询新增用户曲线','system:statistics:member-statistics',8,0,'查询新增用户曲线'),(88,'委托量曲线','system:statistics:delegation-statistics',8,0,'委托量曲线'),(89,'法币交易订单量曲线','system:statistics:order-statistics',8,0,'法币交易订单量曲线'),(90,'otc_order统计','system:statistics:dashboard',8,0,'otc_order统计'),(91,'余额管理','member:member-wallet:balance',11,0,'余额管理'),(92,'充值管理','finance:member-transaction:page-query:recharge',93,0,'充值管理'),(93,'财务管理','finance-------',0,8,'财务管理'),(94,'提币审核','finance:member-transaction:page-query:check',93,0,'提现客服审核'),(95,'手续费管理','finance:member-transaction:page-query:fee',93,0,'手续费管理'),(96,'创建公告','system:announcement:create',8,0,'创建公告'),(97,'分页查询公告','system:announcement:page-query',8,0,'分页查询公告'),(98,'删除公告','system:announcement:deletes',8,0,'删除公告'),(99,'公告详情','system:announcement:detail',8,0,'公告详情'),(100,'更新公告','system:announcement:update',8,0,'更新公告'),(101,'关闭公告','system:announcement:turn-off',8,0,'关闭公告'),(102,'打开公告','system:announcement:turn-on',8,0,'打开公告'),(103,'币币设置','exchange:set',60,0,'币币设置'),(104,'放币处理','otc:appeal:release-coin',66,0,'放币处理'),(105,'取消订单','otc:appeal:cancel-order',66,0,'取消订单'),(106,'创建修改部门','system:department:merge',8,0,'创建修改部门'),(107,'删除exchangeCoin','exchange:exchange-coin:deletes',60,0,'删除exchangeCoin'),(108,'删除otcCoin','otc:otc-coin:deletes',66,0,'删除otcCoin'),(109,'删除部门','system:department:deletes',8,0,'删除部门'),(110,'增加/修改权限','system:permission:merge',8,0,'增加权限'),(111,'权限管理','system:permission:page-query',8,0,'分页查询权限'),(112,'权限详情','system:permission:details',8,0,'权限详情'),(113,'权限删除','system:permission:deletes',8,0,'权限删除'),(114,'添加交易流水号','finance:withdraw-record:add-transaction-number',93,0,'财务提现转账成功添加流水号'),(115,'人工充值','member:member-wallet:recharge',11,0,'人工充值'),(116,'首页订单数','otc:order:get-order-num',66,0,'首页订单数'),(117,'投票管理','system:vote:merge',8,0,'新增/修改投票'),(118,'分页查询','system:vote:page-query',8,0,'分页查询'),(119,'admin更改密码','system:employee:update-password',8,0,'admin更改密码'),(120,'系统公告置顶','cms:system-help:top',18,0,'系统公告置顶'),(121,'系统广告置顶','cms:system-advertise:top',18,0,'系统广告置顶'),(122,'公告置顶','system:announcement:top',8,0,'公告置顶'),(123,'转账地址','system:transfer-address:page-query',8,0,'转账地址管理    拍币网独有'),(124,'新增/修改转账地址','system:transfer-address:merge',8,0,'新增/修改转账地址  拍币网独有'),(125,'转账地址详情','system:transfer-address:detail',8,0,'转账地址详情  拍币网独有'),(126,'批量删除转账地址','system:transfer-address:deletes',8,0,'批量删除转账地址   拍币网独有'),(128,'分红管理','system:dividend:page-query',8,0,'分红管理分页查询'),(129,'开始分红','system:dividend:start',8,0,'开始分红'),(130,'分红手续费','system:dividend:fee-query',8,0,'分红手续费'),(131,'充币记录','finance:member-deposit:page-query',93,0,'区块链钱包充币记录'),(132,'人工转账','system:coin:transfer',8,0,'热钱包转账至冷钱包'),(133,'转入明细','system:coin:hot-transfer-record:page-query',8,0,'热钱包转入冷钱包记录'),(134,'实名认证配置修改','system:member-application-config:merge',8,0,'实名认证配置修改'),(135,'实名认证配置详情','system:member-application-config:detail',8,0,'实名认证配置详情'),(136,'禁用/解禁发布广告','member:alter-publish-advertisement-status',11,0,'禁用/解禁发布广告 1表示正常'),(137,'禁用/解禁会员账号','member:alter-status',11,0,'禁用/解禁会员账号 0表示正常'),(138,'推荐会员','promotion:member:page-query',143,0,'推荐会员分页'),(139,'删除用户','system:employee:deletes',8,0,'批量删除用户'),(140,'充值管理','legal-wallet-recharge',66,0,'充值管理分页'),(141,'提币管理','legal-wallet-withdraw',66,0,'提币管理查询分页'),(142,'是否禁止交易','member:alter-transaction-status',11,0,'是否禁止交易  1表示正常'),(143,'推荐返佣','promotion-------',0,11,'推荐返佣 根'),(144,'新增/修改推荐返佣配置','promotion:reward:merge',143,0,'新增/修改推荐返佣配置'),(145,'重置会员钱包地址','member:member-wallet:reset-address',11,0,'重置会员钱包地址'),(146,'佣金参数','promotion:reward:page-query',143,0,'佣金参数'),(147,'系统信息维护','system:data-dictionary',8,0,'系统信息管理'),(148,'数据字典添加','system:data-dictionary:create',8,0,'数据字典添加'),(149,'数据字典修改','system:data-dictionary:update',8,0,'数据字典修改'),(150,'版本管理','system:app-revision:page-query',8,0,'版本管理'),(151,'添加版本信息','system:app-revision:create',8,0,'添加版本信息'),(152,'更新版本信息','system:app-revision:update',8,0,'更新版本信息'),(153,'版本信息详情','system:app-revision:details',8,0,'版本信息详情'),(154,'推荐会员导出','promotion:member:out-excel',143,0,'推荐会员导出'),(155,'推荐会员明细','promotion:member:details',143,0,'推荐会员明细'),(156,'测试权限','测试名称',18,0,'描述'),(158,'取消委托','exchange:exchange-order:cancel',18,0,'取消委托订单'),(159,'法币交易明细','finance:otc:order:page-query',93,0,'法币交易明细'),(160,'提币明细','finance:withdraw-record:page-query:success',93,0,'提币明细'),(161,'保证金管理','business-auth:manager',93,0,'保证金管理'),(162,'活动管理','activity-------',0,12,'活动管理'),(164,'签到新增','activity:sign:post',162,0,'签到新增'),(165,'签到修改','activity:sign:put',162,0,'签到修改'),(167,'签到管理','activity:sign:page-query',162,0,'签到分页'),(168,'签到详情','activity:sign:id:get',162,0,'签到详情'),(169,'签到提前关闭','activity:sign:id:early-closing',162,0,'签到提前关闭'),(170,'签到记录','activity:member-sign-record:page-query',162,0,'签到记录'),(171,'财务统计','finance:statistics:turnover',93,0,'成交量/成交额统计'),(172,'手续费合计','finance:statistics:fee',93,0,'手续费合计'),(173,'锁定钱包','member:member-wallet:lock-wallet',11,0,'锁定钱包'),(174,'解锁钱包','member:member-wallet:unlock-wallet',11,0,'解锁钱包'),(176,'角色删除','system:role:deletes',8,0,'角色删除'),(177,'保证金管理','business:auth:deposit',0,10,'保证金管理'),(178,'查询保证金策略','business:auth:deposit:page',177,0,'查询保证金策略'),(179,'创建保证金策略','business:auth:deposit:create',177,0,'创建保证金策略'),(180,'修改保证金策略','business:auth:deposit:update',177,0,'修改保证金策略'),(181,'退保审核','business:cancel-apply:check',66,0,'退保审核'),(182,'退保管理','business:cancel-apply:page-query',66,0,'退保申请记录'),(183,'退保用户详情','business:cancel-apply:detail',66,0,'退保用户详情'),(184,'认证商家','business-auth:apply:page-query',66,0,'认证商家'),(185,'佣金参数详情','promotion:reward:detail',143,0,'佣金参数详情'),(186,'认证商家详情','business-auth:apply:detail',66,0,'认证商家详情'),(187,'币种详情','system:coin:detail',8,0,'系统管理下币种详情'),(188,'添加交易对','exchange:exchange-coin:merge',60,0,'添加交易对'),(189,'修改交易对','exchange:exchange-coin:alter-rate',60,0,'修改交易对'),(190,'更新后台货币','system:coin:update',8,0,'系统管理下更新后台货币'),(191,'添加用户钱包记录','system:coin:newwallet',8,0,'系统管理下添加用户钱包记录'),(192,'启动交易引擎','exchange:exchange-coin:start-trader',60,0,'启动交易引擎'),(193,'停止交易引擎','exchange:exchange-coin:stop-trader',60,0,'停止交易引擎'),(194,'撤销某交易对委托','exchange:exchange-coin:cancel-all-order',60,0,'撤销某交易对所有委托单'),(195,'查看交易对盘面','exchange:exchange-coin:exchange-overview',60,0,'查看交易对盘面'),(196,'活动列表','activity:activity:page-query',162,0,'活动列表'),(197,'添加活动','activity:activity:add',162,0,'添加活动'),(198,'修改活动','activity:activity:modify',162,0,'修改活动'),(199,'活动详情','activity:activity:detail',162,0,'查看活动详情'),(200,'修改活动进度','activity:activity:modify-progress',162,0,'修改活动进度'),(201,'活动参与详情','activity:activity:orderlist',162,0,'活动参与详情列表'),(202,'派发活动币','activity:activity:distribute',162,0,''),(203,'CTC管理','ctc---------',0,7,''),(204,'订单列表','ctc:order:page-query',203,0,'用户买入卖出列表'),(205,'订单详情','ctc:order:order-detail',203,0,'订单详情'),(206,'标记付款','ctc:order:pay-order',203,0,'标记付款'),(207,'完成放币','ctc:order:complete-order',203,0,'完成放币'),(208,'接单','ctc:order:confirm-order',203,0,'接单'),(209,'取消订单','ctc:order:cancel-order',203,0,'取消订单'),(210,'承兑商列表','ctc:acceptor:page-query',203,0,'承兑商列表'),(211,'切换承兑商状态','ctc:acceptor:switch',203,0,'切换状态'),(212,'查看机器人参数','exchange:exchange-coin:robot-config',60,0,'查看机器人参数'),(213,'修改一般机器人参数','exchange:exchange-coin:alter-robot-config',60,0,'修改一般机器人参数'),(214,'邀请管理','invite-------',0,2,''),(215,'邀请记录','invite:management:query',214,0,'邀请记录'),(216,'邀请排名','invite:management:rank',214,0,'邀请'),(217,'更新邀请参数','invite:management:update-rank',214,0,'更新邀请参数'),(218,'邀请详情','invite:management:detail-rank',214,0,'邀请详情'),(219,'创建一般机器人','exchange:exchange-coin:create-robot-config',60,0,'创建交易机器人'),(226,'修改定价机器人','exchange:exchange-coin:alter-robot-config-price',60,0,'修改定价机器人'),(227,'创建定价机器人','exchange:exchange-coin:create-robot-config-price',60,0,'创建定价机器人'),(228,'控盘机器人','exchange:robot',60,0,'控盘机器人'),(229,'保存K线数据','exchange:exchange-coin:save-robot-kline',60,0,'保存K线数据'),(230,'控盘币种列表','exchange:exchange-coin:custom-coin-list',60,0,'控盘币种列表'),(231,'机器人k线列表','exchange:exchange-coin:robot-kline-list',60,0,'获取控盘机器人K线数据'),(232,'期权合约','option-------------',0,4,'期权合约'),(233,'交易对管理','option-coin:page-query',232,0,'获取交易对'),(234,'获取交易对详情','option-coin:detail',232,0,'获取交易对详情'),(235,'添加交易对','option-coin:add',232,0,'添加交易对'),(236,'修改交易对','option-coin:alter',232,0,'修改交易对'),(237,'合约管理','option:page-query',232,0,'查询每期合约'),(238,'订单管理','option:order:page-query',232,0,'查询所有合约订单'),(239,'单期合约所有订单','option:order:option-list',232,0,'单期合约所有订单'),(240,'指定用户所有合约订单','option:order:member-list',232,0,'指定用户所有合约订单'),(241,'重置交易引擎','exchange:exchange-coin:reset-trader	',60,0,'重置交易引擎'),(242,'永续合约','swap------------------',0,3,'永续合约'),(243,'交易对管理','swap-coin:page-query',242,0,'交易对管理'),(244,'查看交易对详情','swap-coin:detail',242,0,'查看交易对详情'),(245,'添加交易对','swap-coin:add',242,0,'添加交易对'),(246,'修改交易对','swap-coin:alter',242,0,'修改交易对'),(247,'添加合约账户','swap-coin:init-wallet',242,0,'添加合约账户'),(248,'委托管理','swap:order:page-query',242,0,'委托管理'),(249,'撤销委托','swap:order:cancel',242,0,'撤销委托'),(250,'仓位管理','swap:position:page-query',242,0,'仓位管理'),(251,'强制平仓','swap:order:force-close',242,0,'强制平仓'),(252,'定点爆仓','swap-coin:blast',242,0,'定点爆仓'),(253,'授权代理商','member:alter-member-superpartner',11,0,'授权代理商'),(254,'查询用户锁仓','activity:activity:locked-activity',162,0,'查询用户锁仓'),(255,'设置控盘跟随趋势','exchange:exchange-coin:save-robot-flow',60,0,'设置控盘跟随趋势'),(257,'戳一下','swap-coin:poke',242,0,'戳一下'),(258,'返佣管理','swap:reward:page-query',214,0,'返佣管理'),(259,'返佣比例','swap:reward:rewardSets',214,0,'返佣比例'),(260,'清除缓存','swap:reward:clear',214,0,'清除缓存'),(261,'设置预设价格','option:alter',237,0,'设置预设价格'),(262,'设置期权合约订单','option:order:setOptionOrder',237,0,'设置期权合约订单'),(263,'包赔设置','set:page-query',232,0,'获取包赔设置'),(264,'包赔设置','second-set:alter',232,0,'修改包赔设置'),(265,'包赔设置','second-set:add',232,0,'添加包赔设置'),(266,'包赔设置','second-set:del',232,0,'删除包赔设置'),(267,'周期设置','cycle:page-query',232,0,'周期设置'),(268,'周期设置','second-cycle:alter',232,0,'修改秒合约周期设置'),(269,'周期设置','second-cycle:add',232,0,'添加秒合约周期设置'),(270,'周期设置','second-cycle:del',232,0,'删除秒合约周期设置'),(271,'交易对管理','second-coin:page-query',232,0,'获取交易对'),(272,'获取交易对详情','second-coin:detail',232,0,'获取交易对详情'),(273,'添加交易对','second-coin:add',232,0,'添加交易对'),(274,'修改交易对','second-coin:alter',232,0,'修改交易对'),(275,'理财管理','finance:page-query',0,3,'理财管理'),(276,'理财账户','finance-account:page-query',275,0,'获取理财账户'),(277,'订单管理','finance-order:page-query',275,0,'添加交易对'),(278,'订单管理','second:order:page-query',232,0,'查询所有合约订单'),(279,'指定用户所有合约订单','second:order:member-list',232,0,'指定用户所有合约订单'),(280,'设置系统级别','member:set-sys-level',11,0,'设置系统级别'),(281,'设置预设平仓价格','second:order:alter',232,0,'设置预设平仓价格'),(282,'秒合约账户','second-account:page-query',232,0,'查询秒合约账户'),(283,'审核充值','finance:member-deposit:audit',93,0,'审核充值'),(284,'设置邀请人','member:set-inviter',11,0,'设置邀请人');
/*!40000 ALTER TABLE `admin_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_role`
--

DROP TABLE IF EXISTS `admin_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COMMENT='后台角色';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_role`
--

LOCK TABLES `admin_role` WRITE;
/*!40000 ALTER TABLE `admin_role` DISABLE KEYS */;
INSERT INTO `admin_role` VALUES (1,'系统管理员','系统管理员'),(61,'外部','客服'),(65,'','管理员');
/*!40000 ALTER TABLE `admin_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_role_permission`
--

DROP TABLE IF EXISTS `admin_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_role_permission` (
  `role_id` bigint(20) NOT NULL,
  `rule_id` bigint(20) NOT NULL,
  UNIQUE KEY `UKplesprlvm1sob8nl9yc5rgh3m` (`role_id`,`rule_id`) USING BTREE,
  KEY `FK52rddd3qje4p49iubt08gplb5` (`role_id`) USING BTREE,
  KEY `FKqf3fhgl5mjqqb0jeupx7yafh0` (`rule_id`) USING BTREE,
  CONSTRAINT `FK52rddd3qje4p49iubt08gplb5` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`id`),
  CONSTRAINT `FKqf3fhgl5mjqqb0jeupx7yafh0` FOREIGN KEY (`rule_id`) REFERENCES `admin_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='后台用户权限';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_role_permission`
--

LOCK TABLES `admin_role_permission` WRITE;
/*!40000 ALTER TABLE `admin_role_permission` DISABLE KEYS */;
INSERT INTO `admin_role_permission` VALUES (1,8),(1,66),(1,90),(1,116),(61,8),(61,11),(61,12),(61,13),(61,66),(61,90),(61,116),(65,2),(65,3),(65,4),(65,5),(65,6),(65,7),(65,8),(65,9),(65,10),(65,11),(65,12),(65,13),(65,14),(65,18),(65,19),(65,20),(65,23),(65,26),(65,27),(65,28),(65,29),(65,30),(65,31),(65,32),(65,33),(65,34),(65,35),(65,36),(65,37),(65,38),(65,39),(65,40),(65,41),(65,42),(65,43),(65,44),(65,45),(65,46),(65,47),(65,48),(65,49),(65,50),(65,51),(65,52),(65,53),(65,54),(65,55),(65,56),(65,57),(65,58),(65,59),(65,60),(65,61),(65,62),(65,63),(65,64),(65,65),(65,66),(65,67),(65,68),(65,69),(65,70),(65,71),(65,72),(65,73),(65,74),(65,75),(65,76),(65,77),(65,78),(65,79),(65,80),(65,81),(65,82),(65,83),(65,84),(65,85),(65,86),(65,87),(65,88),(65,89),(65,90),(65,91),(65,92),(65,93),(65,94),(65,95),(65,96),(65,97),(65,98),(65,99),(65,100),(65,101),(65,102),(65,103),(65,104),(65,105),(65,106),(65,107),(65,108),(65,109),(65,110),(65,111),(65,112),(65,113),(65,114),(65,115),(65,116),(65,117),(65,118),(65,119),(65,120),(65,121),(65,122),(65,123),(65,124),(65,125),(65,126),(65,128),(65,129),(65,130),(65,131),(65,132),(65,133),(65,134),(65,135),(65,136),(65,137),(65,138),(65,139),(65,140),(65,141),(65,142),(65,143),(65,144),(65,145),(65,146),(65,147),(65,148),(65,149),(65,150),(65,151),(65,152),(65,153),(65,154),(65,155),(65,156),(65,158),(65,159),(65,160),(65,161),(65,162),(65,164),(65,165),(65,167),(65,168),(65,169),(65,170),(65,171),(65,172),(65,173),(65,174),(65,176),(65,177),(65,178),(65,179),(65,180),(65,181),(65,182),(65,183),(65,184),(65,185),(65,186),(65,187),(65,188),(65,189),(65,190),(65,191),(65,192),(65,193),(65,194),(65,195),(65,196),(65,197),(65,198),(65,199),(65,200),(65,201),(65,202),(65,203),(65,204),(65,205),(65,206),(65,207),(65,208),(65,209),(65,210),(65,211),(65,212),(65,213),(65,214),(65,215),(65,216),(65,217),(65,218),(65,219),(65,226),(65,227),(65,228),(65,229),(65,230),(65,231),(65,232),(65,233),(65,234),(65,235),(65,236),(65,237),(65,238),(65,239),(65,240),(65,241),(65,242),(65,243),(65,244),(65,245),(65,246),(65,247),(65,248),(65,249),(65,250),(65,251),(65,252),(65,253),(65,254),(65,255),(65,257),(65,258),(65,259),(65,260);
/*!40000 ALTER TABLE `admin_role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `advertise`
--

DROP TABLE IF EXISTS `advertise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `audit_status` int(2) DEFAULT '0' COMMENT '审核状态0待审核1审核通过2不通过',
  `audit_remark` varchar(255) DEFAULT NULL COMMENT '审核不通过备注',
  `time_limit` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `coin_id` bigint(20) NOT NULL,
  `country` varchar(255) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK75rse9iecdnimf8ugtf20c43l` (`coin_id`) USING BTREE,
  KEY `FK9lueh92242ckyajg17xr9tcie` (`country`) USING BTREE,
  KEY `FKspoip5yq9ednwwondsga9c9k6` (`member_id`) USING BTREE,
  CONSTRAINT `FK75rse9iecdnimf8ugtf20c43l` FOREIGN KEY (`coin_id`) REFERENCES `otc_coin` (`id`),
  CONSTRAINT `FK9lueh92242ckyajg17xr9tcie` FOREIGN KEY (`country`) REFERENCES `country` (`zh_name`),
  CONSTRAINT `FKspoip5yq9ednwwondsga9c9k6` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advertise`
--

LOCK TABLES `advertise` WRITE;
/*!40000 ALTER TABLE `advertise` DISABLE KEYS */;
/*!40000 ALTER TABLE `advertise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announcement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` text,
  `create_time` datetime DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `is_show` bit(1) DEFAULT NULL,
  `is_top` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `lang` varchar(255) DEFAULT NULL,
  `announcement_classification` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='公告';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_revision`
--

DROP TABLE IF EXISTS `app_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_revision` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `download_url` varchar(255) DEFAULT NULL,
  `platform` int(11) DEFAULT NULL,
  `publish_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='APP版本';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_revision`
--

LOCK TABLES `app_revision` WRITE;
/*!40000 ALTER TABLE `app_revision` DISABLE KEYS */;
INSERT INTO `app_revision` VALUES (1,'https:///#/app',0,'2020-09-28 12:20:03','安卓APP','1.0.6'),(2,'https:///#/app',1,'2020-09-28 00:00:00','苹果APP','1.0.0');
/*!40000 ALTER TABLE `app_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appeal`
--

DROP TABLE IF EXISTS `appeal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appeal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `associate_id` bigint(20) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deal_with_time` datetime DEFAULT NULL,
  `initiator_id` bigint(20) DEFAULT NULL,
  `is_success` int(11) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `order_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_todwxorutclquf69bwow70kml` (`order_id`) USING BTREE,
  KEY `FKanmcnj859x2tv3y0pv7u05cqa` (`admin_id`) USING BTREE,
  CONSTRAINT `FKanmcnj859x2tv3y0pv7u05cqa` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKs3vo8h01sq39icylq1qdwekn1` FOREIGN KEY (`order_id`) REFERENCES `otc_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='OTC投诉';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appeal`
--

LOCK TABLES `appeal` WRITE;
/*!40000 ALTER TABLE `appeal` DISABLE KEYS */;
INSERT INTO `appeal` VALUES (1,600800,'2020-11-09 04:56:51','2021-03-26 11:24:10',1,0,'测试',1,NULL,11);
/*!40000 ALTER TABLE `appeal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_auth_apply`
--

DROP TABLE IF EXISTS `business_auth_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_auth_apply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `auditing_time` datetime DEFAULT NULL,
  `auth_info` text,
  `certified_business_status` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deposit_record_id` varchar(255) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `business_auth_deposit_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKds72omottejlk5isd34ha5i10` (`business_auth_deposit_id`) USING BTREE,
  KEY `FKdghp8ri44t77ntuw06gicphuu` (`member_id`) USING BTREE,
  CONSTRAINT `FKdghp8ri44t77ntuw06gicphuu` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKds72omottejlk5isd34ha5i10` FOREIGN KEY (`business_auth_deposit_id`) REFERENCES `business_auth_deposit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OTC商家申请';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_auth_apply`
--

LOCK TABLES `business_auth_apply` WRITE;
/*!40000 ALTER TABLE `business_auth_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_auth_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_auth_deposit`
--

DROP TABLE IF EXISTS `business_auth_deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_auth_deposit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '保证金数额',
  `create_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKfj3hxtr3ae1yma9bxeuqc29pj` (`admin_id`) USING BTREE,
  KEY `FKjx7799a3pwdtnu43fkpn27kj6` (`coin_id`) USING BTREE,
  CONSTRAINT `FKfj3hxtr3ae1yma9bxeuqc29pj` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKjx7799a3pwdtnu43fkpn27kj6` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='OTC商家质押币种';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_auth_deposit`
--

LOCK TABLES `business_auth_deposit` WRITE;
/*!40000 ALTER TABLE `business_auth_deposit` DISABLE KEYS */;
INSERT INTO `business_auth_deposit` VALUES (1,100000.00000000,'2020-09-29 04:57:10',0,1,'USDT'),(2,100.00000000,'2020-11-03 15:56:03',0,1,'BitcoinCash'),(3,500000.00000000,'2021-03-11 19:42:58',0,1,'ADA'),(4,1000.00000000,'2021-05-18 07:26:01',0,2,'DASH'),(5,100.00000000,'2021-05-30 12:47:10',0,2,'ADA'),(6,1000000000.00000000,'2021-06-05 21:10:45',0,1,'ADA');
/*!40000 ALTER TABLE `business_auth_deposit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bussiness_cancel_apply`
--

DROP TABLE IF EXISTS `bussiness_cancel_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bussiness_cancel_apply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cancel_apply_time` datetime DEFAULT NULL,
  `deposit_record_id` varchar(255) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `handle_time` datetime DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKbwtwtm0jd1eqa8dh7e8ychcx1` (`member_id`) USING BTREE,
  CONSTRAINT `FKbwtwtm0jd1eqa8dh7e8ychcx1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OTC商家退出';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bussiness_cancel_apply`
--

LOCK TABLES `bussiness_cancel_apply` WRITE;
/*!40000 ALTER TABLE `bussiness_cancel_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `bussiness_cancel_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coin`
--

DROP TABLE IF EXISTS `coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coin` (
  `id` bigint(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `can_auto_withdraw` int(11) DEFAULT NULL,
  `can_recharge` int(11) DEFAULT NULL,
  `can_transfer` int(11) DEFAULT NULL,
  `can_withdraw` int(11) DEFAULT NULL,
  `cny_rate` double NOT NULL,
  `enable_rpc` int(11) DEFAULT NULL,
  `is_platform_coin` int(11) DEFAULT NULL,
  `max_tx_fee` double NOT NULL,
  `max_withdraw_amount` decimal(18,8) DEFAULT NULL COMMENT '最大提币数量',
  `min_tx_fee` double NOT NULL,
  `min_withdraw_amount` decimal(18,8) DEFAULT NULL COMMENT '最小提币数量',
  `name_cn` varchar(255) NOT NULL,
  `sort` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  `usd_rate` double NOT NULL,
  `withdraw_threshold` decimal(18,8) DEFAULT NULL COMMENT '提现阈值',
  `has_legal` bit(1) NOT NULL DEFAULT b'0',
  `cold_wallet_address` varchar(255) DEFAULT NULL,
  `miner_fee` decimal(18,8) DEFAULT NULL COMMENT '矿工费',
  `withdraw_scale` int(11) DEFAULT '4' COMMENT '提币精度',
  `information` varchar(255) DEFAULT NULL,
  `infolink` varchar(255) DEFAULT NULL,
  `account_type` int(11) DEFAULT '0' COMMENT '币种账户类型',
  `deposit_address` varchar(255) DEFAULT NULL,
  `min_recharge_amount` decimal(18,8) DEFAULT NULL COMMENT '最小充值数量',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='币种';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coin`
--

LOCK TABLES `coin` WRITE;
/*!40000 ALTER TABLE `coin` DISABLE KEYS */;
INSERT INTO `coin` VALUES (1,'Bitcoin',0,1,1,1,0,0,0,0.00001,1000000.00000000,0.00001,0.00000200,'比特币',1,0,'BTC',0,0.10000000,_binary '\0','',0.00002000,4,'比特币（BitCoin）的概念最初由中本聪在2008年提出，根据中本聪的思路设计发布的开源软件以及建构其上的P2P网络。比特币是一种P2P形式的数字货币。点对点的传输意味着一个去中心化的支付系统。','https://www.bizzan.pro/#/helpdetail?cate=3&id=3&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',1,'1JMyE1wWuCUypqUUNEfd4qoQgsPpLkWGK5',0.00000010),(7,'BitcoinCash',0,0,1,0,0,0,0,0.1,1000.00000000,0.01,1.00000000,'比特币现金',7,1,'BCH',0,0.01000000,_binary '\0','',NULL,0,'比特币现金（BitcoinCash）与比特币相同，是一种基于去中心化，采用点对点网络与共识主动性，开放源代码，以区块链作为底层技术的加密货货币。','https://www.bizzan.pro/#/helpdetail?cate=3&id=17&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',0.10000000),(8,'BitcoinSV',0,0,1,0,0,0,0,0.1,1000.00000000,0.01,1.00000000,'BSV',8,1,'BSV',0,0.00010000,_binary '\0','',NULL,0,'BSV（Bitcoin Satoshi Vision）是遵循中本聪白皮书原始设计和协议稳定的比特币，实现原定的大规模链上扩容愿景，旨在成为全球通用的点对点电子现金与价值数据传输网络。','https://www.bizzan.pro/#/helpdetail?cate=3&id=18&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',0.10000000),(12,'BZB',0,0,1,0,0,0,0,10,100000.00000000,4,10.00000000,'BZB',12,1,'BZB',1,1.00000000,_binary '\0','',NULL,0,'','',1,'',1.00000000),(27,'DASH',0,0,1,0,0,0,0,1,100000.00000000,0.01,1.00000000,'达世币',27,1,'DASH',0,NULL,_binary '\0','',NULL,0,'达世币是一种数字货币。在它的帮助下，世界上任何地方的任何人都可以随时快速而轻松地，以低廉手续费完成交易，而且无需依赖中央机构。达世币以去中心化的点对点网络为基础，以强大的密码学为保障，它提供了安全、用户体验好且毫无门槛的支付方式','https://www.bizzan.pro/#/helpdetail?cate=3&id=33&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',0.10000000),(26,'DOGE',0,0,1,0,0,0,0,10,100000000.00000000,1,10000.00000000,'狗狗币',26,1,'DOGE',0,NULL,_binary '\0','',NULL,0,'Dogecoin，有人称作\"狗狗币/狗币\"，诞生于2013年12月8日，基于Scrypt算法，是国际上用户数仅次于比特币的第二大虚拟货币 ','DURXEHcF6v1mRRToXiEVAj2bLfmNxvM199',0,'',1000.00000000),(NULL,'EME',0,0,1,0,6.7,0,0,0,1000.00000000,0,1.00000000,'EME',0,1,'EME',1,NULL,_binary '\0','',NULL,0,'EME','EME',0,'',0.10000000),(9,'EOS',0,0,1,0,0,0,0,1,10000.00000000,0.1,10.00000000,'Enterprise Operation System',9,1,'EOS',0,0.00100000,_binary '\0',NULL,NULL,0,'EOS是区块链奇才BM（Daniel Larimer）领导开发的类似操作系统的区块链架构平台，旨在实现分布式应用的性能扩展。EOS 提供帐户，身份验证，数据库，异步通信以及在数以百计的CPU或群集上的程序调度。','https://www.bizzan.pro/#/helpdetail?cate=3&id=19&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',1,NULL,1.00000000),(15,'ETC',0,0,1,0,1,0,0,0.2,1000.00000000,0.1,1.00000000,'ETC',0,1,'ETC',7.2,NULL,_binary '\0','',NULL,0,'1','',0,'',1.00000000),(2,'Ethereum',0,1,1,1,0,0,0,0.0001,100000.00000000,0.0001,0.01000000,'以太坊',2,0,'ETH',0,0.01000000,_binary '\0','',NULL,0,'Ethereum（以太坊）是一个平台和一种编程语言，使开发人员能够建立和发布下一代分布式应用。 Ethereum可以用来编程，分散，担保和交易任何事物：投票，域名，金融交易所，众筹，公司管理， 合同和大部分的协议，知识产权，还有得益于硬件集成的智能资产。','https://www.bizzan.pro/#/helpdetail?cate=3&id=4&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',1,'0x4586289a020e0A4086a310D7b1972B0914e426fe',0.01000000),(4,'EUSDT',0,1,1,1,6.4,0,0,10,10000.00000000,1,10.00000000,'ERC20-USDT',4,0,'EUSDT',1,1.00000000,_binary '\0','',NULL,0,'USDT是Tether公司推出的基于稳定价值货币美元（USD）的代币Tether USD（下称USDT），1USDT=1美元，用户可以随时使用USDT与USD进行1:1兑换。Tether公司严格遵守1:1准备金保证，即每发行1个 USDT代币，其银行账户都会有1美元的资金保障。','https://www.bizzan.pro/#/helpdetail?cate=3&id=15&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',1,'0x4586289a020e0A4086a310D7b1972B0914e426fe',1.00000000),(30,'gibx',0,0,1,0,0,0,0,0,NULL,0,NULL,'gibx',0,1,'gibx',0,NULL,_binary '\0','',NULL,0,'gibx','gibx',1,'',1.00000000),(13,'HT',0,0,1,0,0,0,0,10,10000.00000000,0.1,10.00000000,'火币积分',13,1,'HT',0,NULL,_binary '\0','',NULL,0,'HT为Huobi Token的简称，全名为火币全球生态积分，昵称火腿。HT是基于以太坊的去中心化数字资产，发行总量限定5亿，由火币集团发行。','https://www.bizzan.pro/#/helpdetail?cate=3&id=40&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',1.00000000),(6,'Litecoin',0,0,1,0,0,0,0,0.1,1000.00000000,0.01,1.00000000,'莱特币',6,1,'LTC',0,0.00001000,_binary '\0','',NULL,0,'莱特币 (Litecoin, LTC) 是受比特币(BitCoin, BTC) 的启发而推出的改进版数字货币，由一名曾任职于谷歌的程序员设计并编程实现 , 2011年11月9日发布运行。莱特币与比特币在技术上具有相同的实现原理，但莱特币的创造和转让基于一种开源的加密协议，不受到任何中央机构的管理。','https://www.bizzan.pro/#/helpdetail?cate=3&id=16&cateTitle=币种资料',0,'',0.10000000),(29,'NEO',0,0,1,0,0,0,0,1,1000000.00000000,0.1,10.00000000,'小蚁币',29,1,'NEO',0,NULL,_binary '\0','',NULL,0,'NEO是一个由社区驱动的开源平台，利用区块链技术与数字身份，开发者可以通过智能合约实现资产管理数字化与自动化。NEO致力于通过分布式网络建设下一代互联网基础设施，为区块链技术大规模落地奠定基础，以实现智能经济的宏大愿景。','https://www.bizzan.pro/#/helpdetail?cate=3&id=35&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',1.00000000),(10,'Ripple',0,0,1,0,0,0,0,5,100000.00000000,1,30.00000000,'瑞波币',10,1,'XRP',0,1.00000000,_binary '\0',NULL,NULL,0,'Ripple(瑞波)是世界上第一个开放的支付网络，通过这个支付网络可以转账任意一种货币，简便易行快捷，交易确认在几秒以内完成，交易费用几乎是零，没有所谓的跨行异地以及跨国支付费用。Ripple开放式支付系统是一个虚拟货币网络、未来的电子支付平台。','https://www.bizzan.pro/#/helpdetail?cate=3&id=38&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',1,NULL,1.00000000),(14,'TRX',0,0,1,0,0,0,0,0.002,100.00000000,0.001,0.00100000,'波场币',0,1,'TRX',0,0.10000000,_binary '\0',NULL,NULL,0,'','',0,NULL,NULL),(5,'TUSDT',0,0,1,0,6.4,0,0,0.002,100000.00000000,0.001,0.00100000,'TRC20-USDT',5,1,'TUSDT',1,1.00000000,_binary '\0','',NULL,0,'USDT是Tether公司推出的基于稳定价值货币美元（USD）的代币Tether USD（下称USDT），1USDT=1美元，用户可以随时使用USDT与USD进行1:1兑换。Tether公司严格遵守1:1准备金保证，即每发行1个 USDT代币，其银行账户都会有1美元的资金保障。','https://www.bizzan.pro/#/helpdetail?cate=3&id=20&cateTitle=币种资料',1,'',10.00000000),(3,'USDT',0,1,1,1,6.42,0,0,10,100000000.00000000,0.01,100.00000000,'泰达币',1,0,'USDT',1,1.00000000,_binary '\0','',NULL,0,'USDT是Tether公司推出的基于稳定价值货币美元（USD）的代币Tether USD（下称USDT），1USDT=1美元，用户可以随时使用USDT与USD进行1:1兑换。Tether公司严格遵守1:1准备金保证，即每发行1个 USDT代币，其银行账户都会有1美元的资金保障。','https://www.bizzan.pro/#/helpdetail?cate=3&id=15&cateTitle=币种资料',1,'TE5ATZouh4x9etpJNDLdnd1SGfWbcdo9sW',10.00000000),(24,'YFI',0,0,1,0,0,0,0,0.001,10000.00000000,0.0001,0.01000000,'姨夫I',24,1,'YFI',0,NULL,_binary '\0','',NULL,0,'yearn.finance的目标很简单--它是为贷款平台服务的针对不同产品利润产出数据的聚合平台，它通过重新平衡数据得出合同交易互动中的最高利润产出。','https://www.bizzan.pro/#/helpdetail?cate=3&id=29&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',0.00100000),(23,'YFII',0,0,1,0,0,0,0,0.01,10000.00000000,0.001,0.10000000,'姨夫II',1,1,'YFII',0,NULL,_binary '\0','',NULL,0,'yearn是一个支持多种DeFi协议的聚合理财平台，会在协议间自动移仓以帮助储户获取最高的理财收益 。平台聚合Compound、dYdX、Aave、DDEX协议，用户存款时，平台会将资金自动分配至目前收益最高的协议下。然后yearn会给用户一个称为yToken的权益证明，用户可以通过ytoken取出自己原来存入的代币及相应的收益。','https://www.bizzan.pro/#/helpdetail?cate=3&id=28&cateTitle=%E5%B8%81%E7%A7%8D%E8%B5%84%E6%96%99',0,'',0.10000000);
/*!40000 ALTER TABLE `coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_coin`
--

DROP TABLE IF EXISTS `contract_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_coin_scale` int(11) NOT NULL,
  `base_symbol` varchar(255) DEFAULT NULL,
  `close_fee` decimal(18,8) DEFAULT '0.00010000' COMMENT '平仓手续费',
  `coin_scale` int(11) NOT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `enable` int(2) DEFAULT '1' COMMENT '状态',
  `enable_market_buy` int(2) DEFAULT '1' COMMENT '是否启用市价开仓做多',
  `enable_market_sell` int(2) DEFAULT '1' COMMENT '是否启用市价开仓做空',
  `enable_open_buy` int(2) DEFAULT '1' COMMENT '是否允许开仓做多',
  `enable_open_sell` int(2) DEFAULT '1' COMMENT '是否允许开仓做空',
  `enable_trigger_entrust` int(2) DEFAULT '1' COMMENT '是否启用开仓计划委托',
  `exchangeable` int(2) DEFAULT '1' COMMENT '是否可交易',
  `fee_percent` decimal(18,8) DEFAULT '0.00100000' COMMENT '隔夜费率',
  `interval_hour` int(11) DEFAULT '1' COMMENT '点差类型',
  `leverage` varchar(255) DEFAULT NULL,
  `leverage_type` int(2) DEFAULT '1' COMMENT '点差类型',
  `maintenance_margin_rate` decimal(18,8) DEFAULT '0.00500000' COMMENT '维持保证金率',
  `maker_fee` decimal(18,8) DEFAULT '0.00010000' COMMENT '平多手续费',
  `max_share` decimal(18,8) DEFAULT '1000.00000000' COMMENT '最大手数',
  `min_share` decimal(18,8) DEFAULT '1.00000000' COMMENT '最小手数',
  `name` varchar(255) DEFAULT NULL,
  `open_fee` decimal(18,8) DEFAULT '0.00010000' COMMENT '开仓手续费',
  `share_number` decimal(18,8) DEFAULT '0.00000000' COMMENT '单位手数',
  `sort` int(11) NOT NULL,
  `spread` decimal(18,8) DEFAULT '0.00000000' COMMENT '点差',
  `spread_type` int(2) DEFAULT '1' COMMENT '点差类型',
  `symbol` varchar(255) DEFAULT NULL,
  `taker_fee` decimal(18,8) DEFAULT '0.00010000' COMMENT '平空手续费',
  `total_close_fee` decimal(26,8) DEFAULT '0.00000000' COMMENT '合约总平仓手续费',
  `total_loss` decimal(26,8) DEFAULT '0.00000000' COMMENT '合约平台亏损',
  `total_open_fee` decimal(26,8) DEFAULT '0.00000000' COMMENT '合约总开仓手续费',
  `total_profit` decimal(26,8) DEFAULT '0.00000000' COMMENT '合约平台盈利',
  `type` int(11) DEFAULT '0' COMMENT '合约类型',
  `visible` int(2) DEFAULT '1' COMMENT '前台可见状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='永续合约交易对';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_coin`
--

LOCK TABLES `contract_coin` WRITE;
/*!40000 ALTER TABLE `contract_coin` DISABLE KEYS */;
INSERT INTO `contract_coin` VALUES (1,4,'USDT',0.00100000,4,'BTC',1,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'BTC永续合约',0.00100000,1.00000000,1,0.00000000,1,'BTC/USDT',0.00020000,1264230365.55869634,21398433559.55644692,295340889.02578690,73017568784.94465111,0,1),(2,4,'USDT',0.00100000,4,'ETH',1,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'ETH永续',0.00100000,1.00000000,2,0.00000000,1,'ETH/USDT',0.00020000,2053722.25527590,33483973.98590566,2053767.39746190,323422418.88997812,0,1),(3,4,'USDT',0.00100000,4,'LTC',1,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'LTC永续',0.00100000,10.00000000,3,0.00000000,1,'LTC/USDT',0.00020000,93769.75042540,23138396.21344550,93760.67042540,19538955.58134476,0,1),(6,4,'USDT',0.00100000,4,'DOGE',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'DOGE永续合约',0.00100000,10.00000000,4,0.00000000,1,'DOGE/USDT',0.00020000,0.02000000,0.00000000,0.20000000,20.00000000,0,2),(7,4,'USDT',0.00100000,4,'EOS',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'EOS永续合约',0.00100000,10.00000000,5,0.00000000,1,'EOS/USDT',0.00020000,0.00000000,0.00000000,0.10000000,0.00000000,0,2),(10,4,'USDT',0.00100000,4,'BCH',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00020000,100000.00000000,1.00000000,'BCH永续合约',0.00100000,10.00000000,1,0.00000000,1,'BCH/USDT',0.00020000,0.00000000,0.00000000,0.00000000,0.00000000,0,2),(11,4,'USDT',0.00100000,4,'YFII',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00010000,100000.00000000,1.00000000,'YFII永续合约',0.00100000,1.00000000,1,0.00000000,1,'YFII/USDT',0.00010000,0.00000000,0.00000000,0.00000000,0.00000000,0,2),(12,4,'USDT',0.00100000,4,'YFI',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00010000,100000.00000000,1.00000000,'YFI永续合约',0.00100000,1.00000000,1,0.00000000,1,'YFI/USDT',0.00010000,0.00000000,0.00000000,0.00000000,0.00000000,0,2),(13,4,'USDT',0.00100000,4,'BSV',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00010000,100000.00000000,1.00000000,'BSV永续合约',0.00100000,10.00000000,1,0.00000000,1,'BSV/USDT',0.00010000,0.00000000,0.00000000,0.00000000,0.00000000,0,2),(14,4,'USDT',0.00100000,4,'DASH',2,1,1,1,1,1,1,0.00100000,24,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00010000,100000.00000000,1.00000000,'DASH永续合约',0.00100000,10.00000000,1,0.00000000,1,'DASH/USDT',0.00010000,0.00000000,0.00000000,0.00000000,0.00000000,0,2),(15,4,'USDT',0.00010000,4,'EME',2,1,1,1,1,1,1,0.00100000,1,'10,20,30,40,50,60,70,80,90,100',1,0.00500000,0.00010000,100000000.00000000,1.00000000,'EME/USDT',0.00010000,100.00000000,1,0.00000000,1,'EME/USDT',0.00010000,0.00000000,0.00000000,0.00000000,0.00000000,0,2);
/*!40000 ALTER TABLE `contract_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_option`
--

DROP TABLE IF EXISTS `contract_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `close_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '收盘价格',
  `close_time` bigint(20) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `init_buy` decimal(18,8) DEFAULT '0.00000000' COMMENT '买涨奖池总金额',
  `init_sell` decimal(18,8) DEFAULT '0.00000000' COMMENT '买涨奖池总金额',
  `open_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '开盘价格',
  `open_time` bigint(20) DEFAULT NULL,
  `option_no` int(11) DEFAULT '0' COMMENT '合约序号',
  `result` int(4) DEFAULT '1' COMMENT '当局结果',
  `status` int(4) DEFAULT '1' COMMENT '本期合约状态',
  `symbol` varchar(255) DEFAULT NULL,
  `total_buy` decimal(18,8) DEFAULT '0.00000000' COMMENT '买涨奖池总金额',
  `total_buy_count` int(11) DEFAULT '0' COMMENT '买涨人数',
  `total_pl` decimal(18,8) DEFAULT '0.00000000' COMMENT '买涨奖池总金额',
  `total_sell` decimal(18,8) DEFAULT '0.00000000' COMMENT '买跌奖池总金额',
  `total_sell_count` int(11) DEFAULT '0' COMMENT '买涨人数',
  `preset_price` decimal(18,8) DEFAULT NULL COMMENT '预设价格',
  PRIMARY KEY (`id`),
  KEY `symbol` (`symbol`,`status`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='期权合约开奖记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_option`
--

LOCK TABLES `contract_option` WRITE;
/*!40000 ALTER TABLE `contract_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_option_coin`
--

DROP TABLE IF EXISTS `contract_option_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_option_coin` (
  `symbol` varchar(255) NOT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `base_coin_scale` int(11) DEFAULT '4' COMMENT '基币小数精度',
  `base_symbol` varchar(255) DEFAULT NULL,
  `close_time_gap` int(11) DEFAULT '300' COMMENT '开盘到收盘时间间隔',
  `coin_scale` int(11) DEFAULT '4' COMMENT '交易币小数精度',
  `coin_symbol` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `enable` int(2) DEFAULT '1' COMMENT '状态',
  `enable_buy` int(2) DEFAULT '1' COMMENT '是否允许看涨',
  `enable_sell` int(2) DEFAULT '1' COMMENT '是否允许看跌',
  `oods` decimal(8,4) DEFAULT '1.0000' COMMENT '赔率',
  `fee_percent` decimal(8,4) DEFAULT '0.0000' COMMENT '开仓手续费',
  `init_buy_reward` decimal(12,4) DEFAULT '0.0000' COMMENT '初始买涨奖池金额',
  `init_sell_reward` decimal(12,4) DEFAULT '0.0000' COMMENT '初始买跌奖池金额',
  `max_option_no` int(11) DEFAULT '0' COMMENT '最新期号',
  `name` varchar(255) DEFAULT NULL,
  `ngnore_percent` decimal(8,4) DEFAULT '0.0001' COMMENT '忽视涨跌幅度',
  `open_time_gap` int(11) DEFAULT '300' COMMENT '开始到开盘时间间隔',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `tied_type` int(2) DEFAULT '1' COMMENT '平局处理方式',
  `total_profit` decimal(8,4) DEFAULT '0.0000' COMMENT '预测合约总盈利',
  `visible` int(2) DEFAULT '1' COMMENT '前台可见状态',
  `win_fee_percent` decimal(8,4) DEFAULT '0.0010' COMMENT '赢家手续费',
  PRIMARY KEY (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='期权合约交易对';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_option_coin`
--

LOCK TABLES `contract_option_coin` WRITE;
/*!40000 ALTER TABLE `contract_option_coin` DISABLE KEYS */;
INSERT INTO `contract_option_coin` VALUES ('BTC/USDT','50,100,200,500,1000,2000',4,'USDT',60,4,'BTC','2020-11-29 02:00:20',1,1,1,1.0000,0.0000,0.0000,0.0000,398662,'BTC/USDT预测合约',NULL,60,1,1,0.0000,1,0.0500),('DOGE/USDT','500,1000,2000,5000,10000,30000,50000',4,'USDT',30,4,'DOGE','2021-05-28 20:51:05',2,1,1,1.0000,0.0000,0.0000,0.0000,142398,'DOGE/USDT预测合约',NULL,30,4,1,0.0000,2,0.0000),('ETH/USDT','1000,2000,5000,10000,20000,50000',4,'USDT',120,4,'ETH','2020-11-29 02:00:47',1,1,1,1.0000,0.0000,0.0000,0.0000,312002,'ETH/USDT预测合约',NULL,120,2,1,0.0000,1,0.0500),('LTC/USDT','5000,10000,20000,50000,100000,200000,500000',4,'USDT',240,4,'LTC','2020-11-29 02:01:05',1,1,1,1.0000,0.0000,0.0000,0.0000,301253,'LTC/USDT预测合约',NULL,240,3,1,0.0000,1,0.0500);
/*!40000 ALTER TABLE `contract_option_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_option_order`
--

DROP TABLE IF EXISTS `contract_option_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_option_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_symbol` varchar(255) DEFAULT NULL,
  `bet_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '投注金额',
  `coin_symbol` varchar(255) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `direction` int(4) DEFAULT '1' COMMENT '方向',
  `fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '手续费',
  `member_id` bigint(20) DEFAULT NULL,
  `option_id` bigint(20) DEFAULT NULL,
  `option_no` int(11) DEFAULT '0' COMMENT '合约序号',
  `result` int(4) DEFAULT '1' COMMENT '参与结果',
  `reward_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '胜利奖金',
  `status` int(4) DEFAULT '1' COMMENT '订单状态',
  `symbol` varchar(255) DEFAULT NULL,
  `win_fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '抽水',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='期权合约订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_option_order`
--

LOCK TABLES `contract_option_order` WRITE;
/*!40000 ALTER TABLE `contract_option_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_option_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_order_entrust`
--

DROP TABLE IF EXISTS `contract_order_entrust`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_order_entrust` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_symbol` varchar(255) DEFAULT NULL,
  `close_fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '开仓手续费',
  `coin_symbol` varchar(255) DEFAULT NULL,
  `contract_id` bigint(20) DEFAULT NULL,
  `contract_order_entrust_id` varchar(255) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `current_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '下单时价',
  `direction` int(11) DEFAULT '1' COMMENT '方向',
  `entrust_price` decimal(19,2) DEFAULT NULL,
  `entrust_type` int(11) DEFAULT '0' COMMENT '委托订单类型',
  `is_blast` int(2) DEFAULT '0' COMMENT '是否是计划委托的委托单',
  `is_from_spot` int(2) DEFAULT '0' COMMENT '是否是计划委托的委托单',
  `member_id` bigint(20) DEFAULT NULL,
  `open_fee` decimal(18,8) DEFAULT '0.00000000' COMMENT '开仓手续费',
  `patterns` int(11) DEFAULT '1' COMMENT '仓位模式',
  `principal_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '本金数量',
  `principal_unit` varchar(255) DEFAULT NULL,
  `profit_and_loss` decimal(18,8) DEFAULT '0.00000000' COMMENT '盈亏',
  `share_number` decimal(18,8) DEFAULT '0.00000000' COMMENT '合约面值',
  `status` int(11) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `traded_price` decimal(19,2) DEFAULT NULL,
  `traded_volume` decimal(18,8) DEFAULT '0.00000000' COMMENT '委托数量',
  `trigger_price` decimal(19,2) DEFAULT NULL,
  `triggering_time` bigint(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `volume` decimal(18,8) DEFAULT '0.00000000' COMMENT '委托数量',
  `is_reward` int(2) DEFAULT '0' COMMENT '是否已返佣',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='永续合约委托';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_order_entrust`
--

LOCK TABLES `contract_order_entrust` WRITE;
/*!40000 ALTER TABLE `contract_order_entrust` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_order_entrust` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_reward_record`
--

DROP TABLE IF EXISTS `contract_reward_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_reward_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `num` decimal(18,8) DEFAULT NULL COMMENT '奖励数量',
  `type` int(11) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  `order_id` bigint(20) NOT NULL,
  `from_member_id` bigint(20) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpealk2hwhjppr85yi2764xhpo` (`coin_id`),
  KEY `FK390fr8sh5bnxuc8q23gat1kcl` (`order_id`),
  KEY `FK5ofrlnudc62tw7cc4ghapkjmp` (`from_member_id`),
  KEY `FKpto449dtrxryaovu5yrg5dm62` (`member_id`),
  CONSTRAINT `FK390fr8sh5bnxuc8q23gat1kcl` FOREIGN KEY (`order_id`) REFERENCES `contract_order_entrust` (`id`),
  CONSTRAINT `FK5ofrlnudc62tw7cc4ghapkjmp` FOREIGN KEY (`from_member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKpealk2hwhjppr85yi2764xhpo` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKpto449dtrxryaovu5yrg5dm62` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='永续合约奖励记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_reward_record`
--

LOCK TABLES `contract_reward_record` WRITE;
/*!40000 ALTER TABLE `contract_reward_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_reward_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `zh_name` varchar(255) NOT NULL COMMENT '中文名称',
  `area_code` varchar(255) DEFAULT NULL COMMENT '英文名称',
  `en_name` varchar(255) DEFAULT NULL COMMENT '区号',
  `language` varchar(255) DEFAULT NULL COMMENT '语言',
  `local_currency` varchar(255) DEFAULT NULL COMMENT '当地货币缩写',
  `sort` int(11) NOT NULL COMMENT '排序',
  PRIMARY KEY (`zh_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='国家信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES ('中国','86','China','zh_CN','CNY',0),('俄罗斯','7','Russia','en_US','EUR',0),('加拿大','1','Canada','en_US','CAD',0),('印度','91','India','en_US','USD',0),('台湾','886','Taiwan','zh_TW','TWD',0),('土耳其','90','Turkey','en_US','EUR',0),('德国','49','Germany','de_DE','EUR',0),('意大利','39','Italy','it_IT','EUR',0),('新加坡','65','Singapore','en_US','SGD',0),('日本','81','Japan','ja_JP','USD',0),('法国','33','France','fr_FR','EUR',0),('泰国','66','Thailand','en_US','USD',0),('美国','1','America','en_US','USD',0),('英国','44','UK','en_US','EUR',0),('西班牙','34','Spain','es_ES','EUR',0),('越南','84','Vietnam','en_US','USD',0),('韩国','82','Korea','ko_KR','USD',0),('香港','852','HongKong','zh_HK','HKD',0),('马来西亚','60','Malaysia','en_US','EUR',0);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_acceptor`
--

DROP TABLE IF EXISTS `ctc_acceptor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_acceptor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `cny_in` decimal(18,2) DEFAULT NULL COMMENT '买入CNY',
  `cny_out` decimal(18,2) DEFAULT NULL COMMENT '售出CNY',
  `usdt_in` decimal(18,2) DEFAULT NULL COMMENT '买入USDT',
  `usdt_out` decimal(18,2) DEFAULT NULL COMMENT '售出USDT',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKk3nfn54patdd6rwa0skk70tq6` (`member_id`) USING BTREE,
  CONSTRAINT `FKk3nfn54patdd6rwa0skk70tq6` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='CTC商户（USDT）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_acceptor`
--

LOCK TABLES `ctc_acceptor` WRITE;
/*!40000 ALTER TABLE `ctc_acceptor` DISABLE KEYS */;
INSERT INTO `ctc_acceptor` VALUES (1,0,1,3500.00,346.50,50.00,500.00);
/*!40000 ALTER TABLE `ctc_acceptor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_order`
--

DROP TABLE IF EXISTS `ctc_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ali_no` varchar(255) DEFAULT NULL,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `amount` decimal(19,2) DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `card_no` varchar(255) DEFAULT NULL,
  `cancel_reason` varchar(255) DEFAULT NULL,
  `cancel_time` datetime DEFAULT NULL,
  `complete_time` datetime DEFAULT NULL,
  `confirm_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `direction` int(11) NOT NULL,
  `money` decimal(18,2) DEFAULT NULL COMMENT '交易金额',
  `order_sn` varchar(255) NOT NULL,
  `pay_mode` varchar(255) NOT NULL,
  `pay_time` datetime DEFAULT NULL,
  `price` decimal(18,2) DEFAULT NULL COMMENT '价格',
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `unit` varchar(255) NOT NULL,
  `qr_we_code_url` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `acceptor_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `real_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_t212u5lpa982v4yc0ue7c3eab` (`order_sn`) USING BTREE,
  KEY `FKgk8nq4d3ouoj9eyo1kfqtw0wq` (`acceptor_id`) USING BTREE,
  KEY `FK419ewpncecgofa3j1338d6ma6` (`member_id`) USING BTREE,
  CONSTRAINT `FK419ewpncecgofa3j1338d6ma6` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKgk8nq4d3ouoj9eyo1kfqtw0wq` FOREIGN KEY (`acceptor_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CTC订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_order`
--

LOCK TABLES `ctc_order` WRITE;
/*!40000 ALTER TABLE `ctc_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_dictionary`
--

DROP TABLE IF EXISTS `data_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_dictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bond` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='系统信息维护';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_dictionary`
--

LOCK TABLES `data_dictionary` WRITE;
/*!40000 ALTER TABLE `data_dictionary` DISABLE KEYS */;
INSERT INTO `data_dictionary` VALUES (1,'register_allow','新用户注册','2019-09-19 15:06:48','2019-09-19 15:06:48','1'),(2,'commission_rate','佣金比例  佣金=手续费*50%','2020-12-07 19:55:30','2020-12-07 19:55:30','0.5'),(3,'level_reward_rate','平级奖励比例  =佣金*2%','2020-12-07 19:56:28','2020-12-07 19:56:28','0.02');
/*!40000 ALTER TABLE `data_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `leader_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_1t68827l97cwyxo9r1u6t4p7d` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='后台部门';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'2019-08-27 13:33:20',1,'客服部','','2019-08-27 13:33:20'),(3,'2020-11-06 08:15:24',NULL,'演示','','2020-11-06 08:15:24');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit_record`
--

DROP TABLE IF EXISTS `deposit_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deposit_record` (
  `id` varchar(255) NOT NULL,
  `amount` decimal(19,2) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK7x5q0lmqqtty5i0w5mq09o8r7` (`coin_id`) USING BTREE,
  KEY `FKji8p5uoc1ad45npyf72rgf2lx` (`member_id`) USING BTREE,
  CONSTRAINT `FK7x5q0lmqqtty5i0w5mq09o8r7` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKji8p5uoc1ad45npyf72rgf2lx` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='存款记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit_record`
--

LOCK TABLES `deposit_record` WRITE;
/*!40000 ALTER TABLE `deposit_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `deposit_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dividend_start_record`
--

DROP TABLE IF EXISTS `dividend_start_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK226c1iy2t1dt9tjjo20pum39d` (`admin_id`) USING BTREE,
  CONSTRAINT `FK226c1iy2t1dt9tjjo20pum39d` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='持币分息记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dividend_start_record`
--

LOCK TABLES `dividend_start_record` WRITE;
/*!40000 ALTER TABLE `dividend_start_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `dividend_start_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_coin`
--

DROP TABLE IF EXISTS `exchange_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchange_coin` (
  `symbol` varchar(255) NOT NULL,
  `base_coin_scale` int(11) NOT NULL,
  `base_symbol` varchar(255) DEFAULT NULL,
  `coin_scale` int(11) NOT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `enable` int(11) NOT NULL,
  `fee` decimal(8,4) DEFAULT NULL COMMENT '交易手续费',
  `sort` int(11) NOT NULL,
  `enable_market_buy` int(11) DEFAULT '1' COMMENT '是否启用市价买',
  `enable_market_sell` int(11) DEFAULT '1' COMMENT '是否启用市价卖',
  `min_sell_price` decimal(18,8) DEFAULT NULL COMMENT '最低挂单卖价',
  `flag` int(11) DEFAULT '0' COMMENT '默认为0，1表示推荐',
  `max_trading_order` int(11) DEFAULT '0' COMMENT '最大允许同时交易的订单数，0表示不限制',
  `max_trading_time` int(11) DEFAULT '0' COMMENT '委托超时自动下架时间，单位为秒，0表示不过期',
  `instrument` varchar(20) DEFAULT NULL COMMENT '交易类型，B2C2特有',
  `min_turnover` decimal(18,8) DEFAULT NULL COMMENT '最小挂单成交额',
  `max_volume` decimal(18,8) DEFAULT NULL COMMENT '最大下单量',
  `min_volume` decimal(18,8) DEFAULT NULL COMMENT '最小下单量',
  `zone` int(11) DEFAULT '0',
  `clear_time` varchar(30) DEFAULT '1' COMMENT '清盘时间',
  `end_time` varchar(30) DEFAULT '1' COMMENT '结束时间',
  `publish_price` decimal(18,8) DEFAULT NULL COMMENT ' 分摊发行价格',
  `publish_type` int(11) DEFAULT '1' COMMENT '发行活动类型 1:无活动,2:抢购发行,3:分摊发行',
  `start_time` varchar(30) DEFAULT '1' COMMENT '开始时间',
  `exchangeable` int(11) DEFAULT '1' COMMENT ' 是否可交易',
  `publish_amount` decimal(18,8) DEFAULT NULL COMMENT ' 活动发行数量',
  `visible` int(11) DEFAULT '1' COMMENT ' 前台可见状态',
  `max_buy_price` decimal(18,8) DEFAULT NULL COMMENT '最高买单价',
  `robot_type` int(11) DEFAULT '0' COMMENT '机器人类型',
  `enable_buy` int(11) DEFAULT '1' COMMENT '是否允许买',
  `enable_sell` int(11) DEFAULT '1' COMMENT '是否允许卖',
  PRIMARY KEY (`symbol`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='币币交易对';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_coin`
--

LOCK TABLES `exchange_coin` WRITE;
/*!40000 ALTER TABLE `exchange_coin` DISABLE KEYS */;
INSERT INTO `exchange_coin` VALUES ('BCH/USDT',2,'USDT',6,'BCH',1,0.0010,4,1,1,0.00000000,1,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2019-09-14 15:26:31','2019-09-14 15:26:31',NULL,1,'2019-09-14 15:26:31',1,0.00000000,1,0.00000000,0,1,1),('BSV/USDT',2,'USDT',6,'BSV',1,0.0010,5,1,1,0.00000000,1,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2019-09-17 14:49:23','2019-09-17 14:49:23',NULL,1,'2019-09-17 14:49:23',1,0.00000000,1,0.00000000,0,1,1),('BTC/USDT',2,'USDT',8,'BTC',1,0.0010,1,1,1,0.00000000,1,0,0,NULL,100.00000000,0.00000000,0.00000000,0,'2019-09-08 11:22:19','2019-09-08 11:22:19',NULL,1,'2019-09-08 11:22:19',1,0.00000000,1,0.00000000,0,1,1),('BZB/USDT',4,'USDT',2,'BZB',2,0.0010,200,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,1.00000000,0,'2021-01-15 19:02:51','2021-01-15 19:02:51',NULL,1,'2021-01-15 19:02:51',2,0.00000000,2,0.00000000,1,1,1),('DASH/USDT',6,'USDT',4,'DASH',1,0.0010,24,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 20:23:57','2021-01-21 20:23:57',NULL,1,'2021-01-21 20:23:57',1,0.00000000,1,0.00000000,0,1,1),('DOGE/USDT',8,'USDT',6,'DOGE',1,0.0010,23,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 20:23:29','2021-01-21 20:23:29',NULL,1,'2021-01-21 20:23:29',1,0.00000000,1,0.00000000,0,1,1),('EME/USDT',2,'USDT',2,'EME',1,0.0001,8,0,0,0.00000000,0,0,0,NULL,0.00000000,0.00000000,0.00000000,0,'2021-08-18 12:21:37','2021-08-18 12:21:37',NULL,1,'2021-08-18 12:21:37',1,0.00000000,1,0.00000000,1,0,0),('EOS/ETH',6,'ETH',4,'EOS',1,0.0010,302,1,1,0.00000000,0,0,0,NULL,0.00000000,0.00000000,0.00000000,0,'2020-10-28 00:55:09','2020-10-28 00:55:09',NULL,1,'2020-10-28 00:55:09',1,0.00000000,1,0.00000000,0,1,1),('EOS/USDT',4,'USDT',6,'EOS',1,0.0010,7,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2019-09-18 15:14:25','2019-09-18 15:14:25',NULL,1,'2019-09-18 15:14:25',1,0.00000000,1,0.00000000,0,1,1),('ETC/USDT',6,'USDT',4,'ETC',1,0.0010,21,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 20:19:34','2021-01-21 20:19:34',NULL,1,'2021-01-21 20:19:34',1,0.00000000,1,0.00000000,0,1,1),('ETH/BTC',6,'BTC',6,'ETH',1,0.0010,201,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2020-10-28 00:50:36','2020-10-28 00:50:36',NULL,1,'2020-10-28 00:50:36',1,0.00000100,1,0.00000000,0,1,1),('ETH/USDT',2,'USDT',4,'ETH',1,0.0010,2,1,1,0.00000000,1,0,0,NULL,10.00000000,0.00000000,0.00000100,0,'2019-09-11 13:45:01','2019-09-11 13:45:01',NULL,1,'2019-09-11 13:45:01',1,0.00000000,1,0.00000000,0,1,1),('HT/USDT',6,'USDT',4,'HT',1,0.0010,20,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 20:19:13','2021-01-21 20:19:13',NULL,1,'2021-01-21 20:19:13',1,0.00000000,1,0.00000000,0,1,1),('LTC/ETH',4,'ETH',4,'LTC',1,0.0010,302,1,1,0.00000000,0,0,0,NULL,0.00000000,0.00000000,0.00000000,0,'2020-10-28 00:54:31','2020-10-28 00:54:31',NULL,1,'2020-10-28 00:54:31',1,0.00000000,1,0.00000000,0,1,1),('LTC/USDT',2,'USDT',6,'LTC',1,0.0010,6,1,1,0.00000000,1,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2019-09-16 14:37:10','2019-09-16 14:37:10',NULL,1,'2019-09-16 14:37:10',1,0.00000000,1,0.00000000,0,1,1),('NEO/USDT',6,'USDT',4,'NEO',1,0.0010,17,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 20:17:25','2021-01-21 20:17:25',NULL,1,'2021-01-21 20:17:25',1,0.00000000,1,0.00000000,0,1,1),('XRP/BTC',8,'BTC',2,'XRP',1,0.0010,204,1,1,0.00000000,0,0,0,NULL,0.00000000,0.00000000,0.00000100,0,'2021-01-21 16:55:41','2021-01-21 16:55:41',NULL,1,'2021-01-21 16:55:41',1,0.00000100,1,0.00000000,0,1,1),('XRP/ETH',6,'ETH',4,'XRP',1,0.0010,301,1,1,0.00000000,0,0,0,NULL,0.00000000,0.00000000,0.00000000,0,'2020-10-28 00:52:11','2020-10-28 00:52:11',NULL,1,'2020-10-28 00:52:11',1,0.00000000,1,0.00000000,0,1,1),('XRP/USDT',5,'USDT',2,'XRP',1,0.0010,3,1,1,0.00000000,1,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2019-09-12 19:12:07','2019-09-12 19:12:07',NULL,1,'2019-09-12 19:12:07',1,0.00000000,1,0.00000000,0,1,1),('YFI/USDT',2,'USDT',6,'YFI',1,0.0010,10,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 19:21:18','2021-01-21 19:21:18',NULL,1,'2021-01-21 19:21:18',1,0.00000000,1,0.00000000,0,1,1),('YFII/USDT',2,'USDT',6,'YFII',1,0.0010,9,1,1,0.00000000,0,0,0,NULL,1.00000000,0.00000000,0.00000100,0,'2021-01-21 19:20:38','2021-01-21 19:20:38',NULL,1,'2021-01-21 19:20:38',1,0.00000000,1,0.00000000,0,1,1);
/*!40000 ALTER TABLE `exchange_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_favor_symbol`
--

DROP TABLE IF EXISTS `exchange_favor_symbol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchange_favor_symbol` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `add_time` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COMMENT='交易优先符号';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_favor_symbol`
--

LOCK TABLES `exchange_favor_symbol` WRITE;
/*!40000 ALTER TABLE `exchange_favor_symbol` DISABLE KEYS */;
INSERT INTO `exchange_favor_symbol` VALUES (2,'2021-07-19 19:00:20',600810,'ETH/USDT'),(3,'2021-07-19 19:00:29',600810,'DOGE/USDT'),(4,'2021-08-01 00:59:48',600850,'DOGE/USDT'),(5,'2021-08-01 00:59:57',600850,'ETH/USDT'),(6,'2021-08-01 01:00:01',600850,'BTC/USDT'),(7,'2021-08-08 06:52:01',600850,'LTC/USDT'),(9,'2021-08-17 17:12:09',600867,'DOGE/USDT'),(10,'2021-08-18 19:50:40',600800,'LTC/USDT'),(11,'2021-08-19 18:28:24',600850,'EME/USDT'),(13,'2021-08-23 03:44:42',600867,'BTC/USDT'),(14,'2021-08-27 15:25:49',600867,'EME/USDT'),(16,'2021-09-10 19:55:45',600916,'EME/USDT'),(17,'2021-09-17 02:01:17',600943,'BTC/USDT'),(18,'2021-09-18 03:54:26',600920,'XRP/USDT'),(19,'2021-09-27 14:55:51',600890,'BTC/USDT'),(20,'2021-09-29 09:47:16',600947,'EOS/USDT'),(23,'2021-09-29 11:45:21',600960,'BTC/USDT'),(24,'2021-10-01 18:53:01',1,'BTC/USDT'),(25,'2021-10-07 15:32:45',600971,'BTC/USDT'),(28,'2021-10-13 03:13:06',600981,'EME/USDT'),(30,'2021-10-15 04:50:04',600959,'ETH/USDT'),(36,'2021-10-26 00:25:40',600953,'EME/USDT'),(39,'2021-11-04 03:08:11',601003,'EME/USDT'),(41,'2021-11-04 03:08:47',601003,'ETH/USDT'),(47,'2021-11-11 11:34:53',600980,'BTC/USDT'),(49,'2021-11-11 14:29:00',601003,'YFI/USDT'),(51,'2021-11-12 03:00:24',601003,'BTC/USDT'),(52,'2021-11-16 18:22:43',601003,'LTC/USDT');
/*!40000 ALTER TABLE `exchange_favor_symbol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_order`
--

DROP TABLE IF EXISTS `exchange_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchange_order` (
  `order_id` varchar(255) NOT NULL,
  `amount` decimal(18,8) DEFAULT NULL,
  `base_symbol` varchar(255) DEFAULT NULL,
  `canceled_time` bigint(20) DEFAULT NULL,
  `coin_symbol` varchar(255) DEFAULT NULL,
  `completed_time` bigint(20) DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `price` decimal(18,8) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `traded_amount` decimal(26,16) DEFAULT NULL,
  `turnover` decimal(26,16) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `use_discount` varchar(255) DEFAULT NULL,
  `order_resource` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`) USING BTREE,
  KEY `symbol` (`symbol`,`member_id`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='币币挂单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_order`
--

LOCK TABLES `exchange_order` WRITE;
/*!40000 ALTER TABLE `exchange_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `exchange_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKmonjtjt92g6gruqyfumtmg8m8` (`member_id`) USING BTREE,
  CONSTRAINT `FKmonjtjt92g6gruqyfumtmg8m8` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='反馈';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,'2020-09-28 06:57:58','上传照片是反转的',42900),(2,'2020-09-30 06:37:54','你好，我的资产与现有资产不符！麻烦给查收',18797),(3,'2020-10-02 12:23:23','您好，请问什么时候可以身份认证审核呢？急，谢谢！',46632),(4,'2020-10-09 17:40:33','你好，我当初买币时不需要身份认证，所以用了老公的手机号跟身份证号，现在平台需要本人身份证认证，我老公一直反对我做平台，他不知道这件事，请问我现在应该怎么解决这件事？我能不能换个手机号找朋友帮忙认证',804680),(5,'2020-10-10 21:37:41','实名通过不了',830687),(6,'2020-10-15 11:40:05','你好，我的实名认证已经做过的，也通过了为何现在后台显示有没有了？',834401),(7,'2020-10-15 11:40:55','你好，我的实名认证已经做过的，也通过了为何现在后台显示有没有了？',807435),(8,'2020-10-16 16:12:22','我已通过实名认证，但收款设置仍提示“请先完成实名认证”，请问怎么办？13906858577\n客服处发了图片，但没反应。',817615),(9,'2020-10-16 22:45:46','充币未到账',800964),(10,'2020-10-17 20:33:02','你好，我这个账号怎么没有释放％10\n',843496),(11,'2020-10-18 12:59:18','你好，提币两天了还没有审核麻烦给审核一下。\n',838125),(12,'2020-10-21 09:50:33','为什么我的卖单委托取消不了',835269),(13,'2021-03-21 12:33:07','hey',600800),(14,'2021-06-17 17:56:38','这个交易所非常棒',600800);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_item`
--

DROP TABLE IF EXISTS `financial_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `financial_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin_minnum` decimal(19,2) DEFAULT NULL,
  `coin_name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `deadline` int(11) NOT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `item_state` int(11) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `yield` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='财务项目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_item`
--

LOCK TABLES `financial_item` WRITE;
/*!40000 ALTER TABLE `financial_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `financial_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_order`
--

DROP TABLE IF EXISTS `financial_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `financial_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin_name` varchar(255) DEFAULT NULL,
  `coin_num` decimal(19,2) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `frozen_days` int(11) NOT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `order_no` bigint(20) DEFAULT NULL,
  `order_state` int(11) NOT NULL,
  `order_usdt_rate` double DEFAULT NULL,
  `plan_revenue_time` datetime DEFAULT NULL,
  `real_income` decimal(19,2) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='财务订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_order`
--

LOCK TABLES `financial_order` WRITE;
/*!40000 ALTER TABLE `financial_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `financial_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hot_transfer_record`
--

DROP TABLE IF EXISTS `hot_transfer_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hot_transfer_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `admin_id` bigint(20) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '转账金额',
  `balance` decimal(18,8) DEFAULT NULL COMMENT '热钱包余额',
  `cold_address` varchar(255) DEFAULT NULL,
  `miner_fee` decimal(18,8) DEFAULT NULL COMMENT '矿工费',
  `transaction_number` varchar(255) DEFAULT NULL,
  `transfer_time` datetime DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='热传输记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hot_transfer_record`
--

LOCK TABLES `hot_transfer_record` WRITE;
/*!40000 ALTER TABLE `hot_transfer_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `hot_transfer_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `init_plate`
--

DROP TABLE IF EXISTS `init_plate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `init_plate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `final_price` varchar(255) DEFAULT NULL,
  `init_price` varchar(255) DEFAULT NULL,
  `interference_factor` varchar(255) DEFAULT NULL,
  `relative_time` varchar(255) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `init_plate`
--

LOCK TABLES `init_plate` WRITE;
/*!40000 ALTER TABLE `init_plate` DISABLE KEYS */;
/*!40000 ALTER TABLE `init_plate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `legal_wallet_recharge`
--

DROP TABLE IF EXISTS `legal_wallet_recharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKtfjvrkn1oe0yu2tfjh6qcms73` (`admin_id`) USING BTREE,
  KEY `FKsdtoqyvbjpd0bmw4n41ijc0kk` (`coin_name`) USING BTREE,
  KEY `FK170xpb7hoxqoj5ovdrcibs9gn` (`member_id`) USING BTREE,
  CONSTRAINT `FK170xpb7hoxqoj5ovdrcibs9gn` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKsdtoqyvbjpd0bmw4n41ijc0kk` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKtfjvrkn1oe0yu2tfjh6qcms73` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包充值记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `legal_wallet_recharge`
--

LOCK TABLES `legal_wallet_recharge` WRITE;
/*!40000 ALTER TABLE `legal_wallet_recharge` DISABLE KEYS */;
/*!40000 ALTER TABLE `legal_wallet_recharge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `legal_wallet_withdraw`
--

DROP TABLE IF EXISTS `legal_wallet_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `legal_wallet_withdraw` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKe95o0059kwsgmsxxv3amdb0d2` (`admin_id`) USING BTREE,
  KEY `FKbilsav1ug8vjtn4ffghrlogqx` (`coin_name`) USING BTREE,
  KEY `FKcpw5k7o3tchlifu1wqmjhku9t` (`member_id`) USING BTREE,
  CONSTRAINT `FKbilsav1ug8vjtn4ffghrlogqx` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKcpw5k7o3tchlifu1wqmjhku9t` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKe95o0059kwsgmsxxv3amdb0d2` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包提币记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `legal_wallet_withdraw`
--

LOCK TABLES `legal_wallet_withdraw` WRITE;
/*!40000 ALTER TABLE `legal_wallet_withdraw` DISABLE KEYS */;
/*!40000 ALTER TABLE `legal_wallet_withdraw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locked_order`
--

DROP TABLE IF EXISTS `locked_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locked_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `current_releaseamount` decimal(18,8) DEFAULT NULL COMMENT '当前周期释放数量',
  `end_time` varchar(30) NOT NULL DEFAULT '2000-01-01 01:00:00' COMMENT '结束时间',
  `image` varchar(255) DEFAULT NULL,
  `locked_days` int(11) NOT NULL,
  `locked_invite` decimal(24,8) DEFAULT NULL,
  `locked_invitelimit` decimal(24,8) DEFAULT NULL,
  `locked_status` int(11) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `origin_releaseamount` decimal(18,8) DEFAULT NULL COMMENT '原始周期释放数量',
  `period` int(11) NOT NULL,
  `release_currentpercent` decimal(19,2) DEFAULT NULL,
  `release_percent` decimal(19,2) DEFAULT NULL,
  `release_times` decimal(24,8) DEFAULT NULL,
  `release_type` int(11) NOT NULL,
  `release_unit` varchar(255) DEFAULT NULL,
  `released_days` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `total_locked` decimal(18,8) DEFAULT NULL COMMENT '总锁仓',
  `total_release` decimal(18,8) DEFAULT NULL COMMENT '总释放',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='锁仓订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locked_order`
--

LOCK TABLES `locked_order` WRITE;
/*!40000 ALTER TABLE `locked_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `locked_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locked_order_detail`
--

DROP TABLE IF EXISTS `locked_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locked_order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `locked_order_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  `output` decimal(18,8) DEFAULT NULL COMMENT '矿机当期产出',
  `release_unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='锁仓订单明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locked_order_detail`
--

LOCK TABLES `locked_order_detail` WRITE;
/*!40000 ALTER TABLE `locked_order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `locked_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `email` varchar(255) DEFAULT NULL,
  `first_level` int(11) NOT NULL,
  `google_date` datetime DEFAULT NULL,
  `google_key` varchar(255) DEFAULT NULL,
  `google_state` int(11) DEFAULT NULL,
  `id_number` varchar(255) DEFAULT NULL,
  `inviter_id` bigint(20) DEFAULT NULL,
  `jy_password` varchar(255) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `login_count` int(11) NOT NULL,
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
  `super_partner` varchar(255) DEFAULT NULL,
  `third_level` int(11) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `token_expire_time` datetime DEFAULT NULL,
  `transaction_status` int(11) DEFAULT NULL,
  `transactions` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `qr_we_code_url` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `local` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_gc3jmn7c2abyo3wf6syln5t2i` (`username`) USING BTREE,
  UNIQUE KEY `UK_mbmcqelty0fbrvxp1q58dn57t` (`email`) USING BTREE,
  UNIQUE KEY `UK_10ixebfiyeqolglpuye0qb49u` (`mobile_phone`) USING BTREE,
  KEY `FKbt72vgf5myy3uhygc90xna65j` (`local`) USING BTREE,
  CONSTRAINT `FKbt72vgf5myy3uhygc90xna65j` FOREIGN KEY (`local`) REFERENCES `country` (`zh_name`)
) ENGINE=InnoDB AUTO_INCREMENT=601087 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_address`
--

DROP TABLE IF EXISTS `member_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKhcqqqntcf8hqmoa6dpo95okyh` (`coin_id`) USING BTREE,
  CONSTRAINT `FKhcqqqntcf8hqmoa6dpo95okyh` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='会员提币地址';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_address`
--

LOCK TABLES `member_address` WRITE;
/*!40000 ALTER TABLE `member_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_api_key`
--

DROP TABLE IF EXISTS `member_api_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员OpenKey';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_api_key`
--

LOCK TABLES `member_api_key` WRITE;
/*!40000 ALTER TABLE `member_api_key` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_api_key` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_application`
--

DROP TABLE IF EXISTS `member_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `audit_status` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `id_card` varchar(255) DEFAULT NULL,
  `identity_card_img_front` varchar(255) NOT NULL,
  `identity_card_img_in_hand` varchar(255) NOT NULL,
  `identity_card_img_reverse` varchar(255) NOT NULL,
  `real_name` varchar(255) DEFAULT NULL,
  `reject_reason` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK2djx7q0j54th0cgj7153qfbl1` (`member_id`) USING BTREE,
  CONSTRAINT `FK2djx7q0j54th0cgj7153qfbl1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员实名信息照片';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_application`
--

LOCK TABLES `member_application` WRITE;
/*!40000 ALTER TABLE `member_application` DISABLE KEYS */;
INSERT INTO `member_application` VALUES (1,2,'2020-09-26 21:37:55','110101199003074012','http://bizzano.oss-cn-shanghai.aliyuncs.com/2020/09/26/3a0c3080-d64d-4dbc-9424-befdd44ead25.png','http://bizzano.oss-cn-shanghai.aliyuncs.com/2020/09/26/07b65e3e-0460-46d6-b41b-703b44f18b46.png','http://bizzano.oss-cn-shanghai.aliyuncs.com/2020/09/26/3f841a9e-024c-40ab-86f6-ef6d335bcf1f.png','机器人',NULL,'2020-09-26 21:43:20',1);
/*!40000 ALTER TABLE `member_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_application_config`
--

DROP TABLE IF EXISTS `member_application_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_application_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `promotion_on` int(11) DEFAULT NULL,
  `recharge_coin_on` int(11) DEFAULT NULL,
  `transaction_on` int(11) DEFAULT NULL,
  `withdraw_coin_on` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员实名配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_application_config`
--

LOCK TABLES `member_application_config` WRITE;
/*!40000 ALTER TABLE `member_application_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_application_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_bonus`
--

DROP TABLE IF EXISTS `member_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_bonus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `arrive_time` varchar(255) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  `have_time` varchar(255) DEFAULT NULL,
  `mem_bouns` decimal(18,8) DEFAULT NULL COMMENT '分红数量',
  `member_id` bigint(20) DEFAULT NULL,
  `total` decimal(18,8) DEFAULT NULL COMMENT '当天总手续费',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员奖金';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_bonus`
--

LOCK TABLES `member_bonus` WRITE;
/*!40000 ALTER TABLE `member_bonus` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_bonus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_contract_wallet`
--

DROP TABLE IF EXISTS `member_contract_wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_contract_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin_balance` decimal(18,8) DEFAULT '0.00000000' COMMENT '币种余额',
  `coin_buy_leverage` decimal(18,8) DEFAULT '0.00000000' COMMENT '做多杠杆倍数',
  `coin_buy_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开多仓位',
  `coin_buy_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '多仓均价',
  `coin_buy_principal_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '多仓保证金',
  `coin_frozen_balance` decimal(18,8) DEFAULT '0.00000000' COMMENT '冻结余额',
  `coin_frozen_buy_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开多仓位',
  `coin_frozen_sell_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `coin_pattern` int(4) DEFAULT '1' COMMENT '币本位仓位模式',
  `coin_sell_leverage` decimal(18,8) DEFAULT '0.00000000' COMMENT '做空杠杆倍数',
  `coin_sell_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `coin_sell_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '空仓均价',
  `coin_sell_principal_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '空仓保证金',
  `coin_share_number` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `member_id` bigint(20) DEFAULT NULL,
  `usdt_balance` decimal(18,8) DEFAULT '0.00000000' COMMENT 'USDT余额',
  `usdt_buy_leverage` decimal(18,8) DEFAULT '0.00000000' COMMENT '做多杠杆倍数',
  `usdt_buy_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开多仓位',
  `usdt_buy_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '多仓均价',
  `usdt_buy_principal_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '多仓保证金',
  `usdt_frozen_balance` decimal(18,8) DEFAULT '0.00000000' COMMENT '冻结余额',
  `usdt_frozen_buy_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开多仓位',
  `usdt_frozen_sell_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `usdt_loss` decimal(18,8) DEFAULT '0.00000000' COMMENT 'USDT亏损',
  `usdt_pattern` int(4) DEFAULT '1' COMMENT '金本位仓位模式',
  `usdt_profit` decimal(18,8) DEFAULT '0.00000000' COMMENT 'USDT盈利',
  `usdt_sell_leverage` decimal(18,8) DEFAULT '0.00000000' COMMENT '做空杠杆倍数',
  `usdt_sell_position` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `usdt_sell_price` decimal(18,8) DEFAULT '0.00000000' COMMENT '空仓均价',
  `usdt_sell_principal_amount` decimal(18,8) DEFAULT '0.00000000' COMMENT '空仓保证金',
  `usdt_share_number` decimal(18,8) DEFAULT '0.00000000' COMMENT '开空仓位',
  `contract_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKe17oj0my6ih9ejhlw6m84l1cd` (`member_id`,`contract_id`),
  KEY `FKni1vfmlpo78vdm4tvr5woqvpo` (`contract_id`),
  CONSTRAINT `FKni1vfmlpo78vdm4tvr5woqvpo` FOREIGN KEY (`contract_id`) REFERENCES `contract_coin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3211 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员合约钱包';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_contract_wallet`
--

LOCK TABLES `member_contract_wallet` WRITE;
/*!40000 ALTER TABLE `member_contract_wallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_contract_wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_deposit`
--

DROP TABLE IF EXISTS `member_deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_deposit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` int(2) DEFAULT '0' COMMENT '充值状态 0 待确认  1成功  2失败',
  `address` varchar(255) DEFAULT NULL,
  `amount` decimal(18,8) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `txid` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKl2ibi99fuxplt8qt3rrpb0q4w` (`txid`,`address`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=796 DEFAULT CHARSET=utf8 COMMENT='会员充值数字币记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_deposit`
--

LOCK TABLES `member_deposit` WRITE;
/*!40000 ALTER TABLE `member_deposit` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_deposit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_finance_order`
--

DROP TABLE IF EXISTS `member_finance_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_finance_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `num` decimal(20,8) DEFAULT '0.00000000' COMMENT '理财数量',
  `member_id` bigint(20) DEFAULT NULL,
  `status` int(4) DEFAULT '0' COMMENT '订单状态 0持仓中 1撤销',
  `coin_symbol` varchar(50) DEFAULT NULL COMMENT '币种unit',
  `earn_num` decimal(20,8) DEFAULT NULL COMMENT '盈利',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='理财订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_finance_order`
--

LOCK TABLES `member_finance_order` WRITE;
/*!40000 ALTER TABLE `member_finance_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_finance_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_finance_statistic`
--

DROP TABLE IF EXISTS `member_finance_statistic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_finance_statistic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `num` decimal(20,8) DEFAULT '0.00000000' COMMENT '理财数量',
  `member_id` bigint(20) DEFAULT NULL,
  `coin_symbol` varchar(50) DEFAULT NULL COMMENT '币种unit',
  `earn_num` decimal(20,8) DEFAULT NULL COMMENT '累计盈利',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`,`coin_symbol`),
  UNIQUE KEY `UK22ri1cwm7qg2q7l2cp4q4jcsh` (`member_id`,`coin_symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='理财统计表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_finance_statistic`
--

LOCK TABLES `member_finance_statistic` WRITE;
/*!40000 ALTER TABLE `member_finance_statistic` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_finance_statistic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_invite_stastic`
--

DROP TABLE IF EXISTS `member_invite_stastic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_invite_stastic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `btc_reward` decimal(24,8) DEFAULT NULL,
  `estimated_reward` decimal(24,8) DEFAULT NULL,
  `eth_reward` decimal(24,8) DEFAULT NULL,
  `extra_reward` decimal(24,8) DEFAULT NULL,
  `is_robot` int(11) NOT NULL,
  `level_one` int(11) NOT NULL,
  `level_two` int(11) NOT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `other_reward` varchar(255) DEFAULT NULL,
  `stastic_date` varchar(30) NOT NULL DEFAULT '2000-01-01 01:00:00' COMMENT '统计日期',
  `usdt_reward` decimal(24,8) DEFAULT NULL,
  `user_identify` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `member_id` (`member_id`) USING BTREE,
  UNIQUE KEY `UK4o6jykp20ax1pybxgxcwsxq01` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员邀请记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_invite_stastic`
--

LOCK TABLES `member_invite_stastic` WRITE;
/*!40000 ALTER TABLE `member_invite_stastic` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_invite_stastic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_invite_stastic_rank`
--

DROP TABLE IF EXISTS `member_invite_stastic_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_invite_stastic_rank` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_robot` int(11) NOT NULL,
  `level_one` int(11) NOT NULL,
  `level_two` int(11) NOT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `stastic_date` datetime DEFAULT NULL,
  `type` int(11) NOT NULL,
  `user_identify` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员邀请等级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_invite_stastic_rank`
--

LOCK TABLES `member_invite_stastic_rank` WRITE;
/*!40000 ALTER TABLE `member_invite_stastic_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_invite_stastic_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_level`
--

DROP TABLE IF EXISTS `member_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_level` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_default` bit(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员等级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_level`
--

LOCK TABLES `member_level` WRITE;
/*!40000 ALTER TABLE `member_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_promotion`
--

DROP TABLE IF EXISTS `member_promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_promotion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `invitees_id` bigint(20) DEFAULT NULL,
  `inviter_id` bigint(20) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员推广';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_promotion`
--

LOCK TABLES `member_promotion` WRITE;
/*!40000 ALTER TABLE `member_promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_sign_record`
--

DROP TABLE IF EXISTS `member_sign_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_sign_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `coin_name` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `sign_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK7qa42qkaoqxlyvwhxwdstclic` (`coin_name`) USING BTREE,
  KEY `FK2r4i90tejcbf85vhk0d8besle` (`member_id`) USING BTREE,
  KEY `FKq1926wgosqk7ka4kvw8rtxew` (`sign_id`) USING BTREE,
  CONSTRAINT `FK2r4i90tejcbf85vhk0d8besle` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK7qa42qkaoqxlyvwhxwdstclic` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKq1926wgosqk7ka4kvw8rtxew` FOREIGN KEY (`sign_id`) REFERENCES `sign` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员签章记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_sign_record`
--

LOCK TABLES `member_sign_record` WRITE;
/*!40000 ALTER TABLE `member_sign_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_sign_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_team_info`
--

DROP TABLE IF EXISTS `member_team_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_team_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL COMMENT '用户id',
  `inviter_id` bigint(20) DEFAULT NULL COMMENT '邀请人id',
  `team_total_amount` decimal(20,6) DEFAULT '0.000000' COMMENT '团队业绩USDT',
  `level` int(2) DEFAULT '0' COMMENT '等级 0普通  1合约矿工  2节点矿工 3高级矿工 4超级矿工 5矿池 ',
  `sys_level` int(2) DEFAULT '0' COMMENT '系统设定级别',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户团队业绩等级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_team_info`
--

LOCK TABLES `member_team_info` WRITE;
/*!40000 ALTER TABLE `member_team_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_team_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_team_reward`
--

DROP TABLE IF EXISTS `member_team_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_team_reward` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL COMMENT '用户id',
  `source_id` bigint(20) DEFAULT NULL COMMENT '来源用户id',
  `source_type` int(2) DEFAULT '0' COMMENT '来源类型 0永续 1期权',
  `num` decimal(20,6) DEFAULT '0.000000' COMMENT '奖励数量',
  `coin_symbol` varchar(50) DEFAULT NULL,
  `type` int(2) DEFAULT '0' COMMENT '奖励类型 0佣金 1推荐奖励',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户团队奖励记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_team_reward`
--

LOCK TABLES `member_team_reward` WRITE;
/*!40000 ALTER TABLE `member_team_reward` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_team_reward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_transaction`
--

DROP TABLE IF EXISTS `member_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `amount` decimal(26,16) DEFAULT NULL COMMENT '充币金额',
  `create_time` datetime DEFAULT NULL,
  `discount_fee` varchar(255) DEFAULT NULL,
  `fee` decimal(26,16) DEFAULT NULL,
  `flag` int(11) NOT NULL DEFAULT '0',
  `member_id` bigint(20) DEFAULT NULL,
  `real_fee` varchar(255) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员交易记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_transaction`
--

LOCK TABLES `member_transaction` WRITE;
/*!40000 ALTER TABLE `member_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_wallet`
--

DROP TABLE IF EXISTS `member_wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_wallet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `balance` decimal(26,8) DEFAULT NULL COMMENT '可用余额',
  `frozen_balance` decimal(26,8) DEFAULT NULL COMMENT '冻结余额',
  `is_lock` int(11) DEFAULT '0' COMMENT '钱包不是锁定',
  `member_id` bigint(20) DEFAULT NULL,
  `to_released` decimal(18,8) DEFAULT NULL COMMENT '待释放总量',
  `version` int(11) NOT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UKm68bscpof0bpnxocxl4qdnvbe` (`member_id`,`coin_id`) USING BTREE,
  KEY `FKf9tgbp9y9py8t9c5xj0lllcib` (`coin_id`) USING BTREE,
  CONSTRAINT `FKf9tgbp9y9py8t9c5xj0lllcib` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员钱包';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_wallet`
--

LOCK TABLES `member_wallet` WRITE;
/*!40000 ALTER TABLE `member_wallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_wallet_history`
--

DROP TABLE IF EXISTS `member_wallet_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_wallet_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `coin_id` varchar(255) NOT NULL,
  `before_balance` decimal(18,8) NOT NULL,
  `after_balance` decimal(18,8) DEFAULT NULL,
  `before_frozen_balance` decimal(18,8) DEFAULT NULL,
  `after_frozen_balance` decimal(18,8) DEFAULT NULL,
  `op_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包增删记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_wallet_history`
--

LOCK TABLES `member_wallet_history` WRITE;
/*!40000 ALTER TABLE `member_wallet_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_wallet_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_weight_upper`
--

DROP TABLE IF EXISTS `member_weight_upper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_weight_upper` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `first_member_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `rate` int(11) DEFAULT NULL,
  `upper` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_weight_upper`
--

LOCK TABLES `member_weight_upper` WRITE;
/*!40000 ALTER TABLE `member_weight_upper` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_weight_upper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mining_order`
--

DROP TABLE IF EXISTS `mining_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mining_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `current_daysprofit` decimal(18,8) DEFAULT NULL COMMENT '矿机当前日产出',
  `end_time` varchar(30) NOT NULL DEFAULT '2000-01-01 01:00:00' COMMENT '结束时间',
  `member_id` bigint(20) NOT NULL,
  `mining_days` int(11) NOT NULL,
  `mining_daysprofit` decimal(18,8) DEFAULT NULL COMMENT '矿机原始日产出',
  `mining_unit` varchar(255) DEFAULT NULL,
  `mininged_days` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `mining_status` int(11) NOT NULL,
  `period` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `mining_invite` decimal(24,8) DEFAULT NULL,
  `mining_invitelimit` decimal(24,8) DEFAULT NULL,
  `total_profit` decimal(18,8) DEFAULT NULL COMMENT '矿机总产出',
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='挖矿订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mining_order`
--

LOCK TABLES `mining_order` WRITE;
/*!40000 ALTER TABLE `mining_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `mining_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mining_order_detail`
--

DROP TABLE IF EXISTS `mining_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mining_order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  `mining_order_id` bigint(20) DEFAULT NULL,
  `mining_unit` varchar(255) DEFAULT NULL,
  `output` decimal(18,8) DEFAULT NULL COMMENT '矿机当期产出',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='挖矿订单详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mining_order_detail`
--

LOCK TABLES `mining_order_detail` WRITE;
/*!40000 ALTER TABLE `mining_order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `mining_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otc_coin`
--

DROP TABLE IF EXISTS `otc_coin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otc_coin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buy_min_amount` decimal(18,8) DEFAULT NULL COMMENT '买入广告最低发布数量',
  `is_platform_coin` int(11) DEFAULT NULL,
  `jy_rate` decimal(18,6) DEFAULT NULL COMMENT '交易手续费率',
  `name` varchar(255) NOT NULL,
  `name_cn` varchar(255) NOT NULL,
  `sell_min_amount` decimal(18,8) DEFAULT NULL COMMENT '卖出广告最低发布数量',
  `sort` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='OTC币种';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otc_coin`
--

LOCK TABLES `otc_coin` WRITE;
/*!40000 ALTER TABLE `otc_coin` DISABLE KEYS */;
INSERT INTO `otc_coin` VALUES (1,0.01000000,0,0.000000,'USDT','泰达币',0.10000000,0,0,'USDT'),(2,0.01000000,0,1.000000,'Bitcoin','比特币',0.10000000,0,0,'BTC'),(3,0.01000000,0,1.000000,'Ethereum','以太坊',0.10000000,0,0,'ETH');
/*!40000 ALTER TABLE `otc_coin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otc_order`
--

DROP TABLE IF EXISTS `otc_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `release_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `qr_we_code_url` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `coin_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_qmfpakgu6mowmslv4m5iy43t9` (`order_sn`) USING BTREE,
  KEY `FKjh47nnmiehmu15wqjfwnh8a6u` (`coin_id`) USING BTREE,
  CONSTRAINT `FKjh47nnmiehmu15wqjfwnh8a6u` FOREIGN KEY (`coin_id`) REFERENCES `otc_coin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='OTC订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otc_order`
--

LOCK TABLES `otc_order` WRITE;
/*!40000 ALTER TABLE `otc_order` DISABLE KEYS */;
INSERT INTO `otc_order` VALUES (11,2,1,NULL,NULL,'','','60002160601398896','2021-03-26 11:24:10',0.00000000,'中国','2020-11-08 22:10:42',1,'13791233920','机器人',103.00,600800,'13800138001','测试',100.00,100.00,14.26533524,'381566914771550208','银联','2020-11-08 22:10:56',7.01,NULL,'',0,17,0,NULL,NULL,2);
/*!40000 ALTER TABLE `otc_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_card`
--

DROP TABLE IF EXISTS `promotion_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotion_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '单个卡券金额',
  `card_desc` varchar(255) DEFAULT NULL,
  `card_name` varchar(255) NOT NULL,
  `card_no` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `exchange_count` int(11) NOT NULL,
  `is_enabled` int(11) NOT NULL,
  `is_free` int(11) NOT NULL,
  `is_lock` int(11) NOT NULL,
  `lock_days` int(11) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `total_amount` decimal(18,8) DEFAULT NULL COMMENT '所有卡券总金额',
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_3781uubel3iuh86ht6yv0n0r7` (`card_no`) USING BTREE,
  KEY `FKem2r42s1av7tfni612176gt9f` (`coin_id`) USING BTREE,
  CONSTRAINT `FKem2r42s1av7tfni612176gt9f` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='合伙人推广卡';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_card`
--

LOCK TABLES `promotion_card` WRITE;
/*!40000 ALTER TABLE `promotion_card` DISABLE KEYS */;
INSERT INTO `promotion_card` VALUES (1,0.00100000,'','合伙人推广卡','VPTGL0FL3',30,'2020-10-13 18:43:29',2,1,1,0,0,800749,0.03000000,'Bitcoin'),(2,0.00100000,'','合伙人推广卡','REB6P3GQV',30,'2020-10-13 18:52:00',2,1,1,0,0,805330,0.03000000,'Bitcoin'),(3,0.00100000,'','合伙人推广卡','711C0NEUH',30,'2020-10-13 18:52:09',1,1,1,0,0,834706,0.03000000,'Bitcoin'),(4,0.00100000,'','合伙人推广卡','CK30OTAWO',30,'2020-10-13 18:58:39',1,1,1,0,0,804916,0.03000000,'Bitcoin'),(5,0.00100000,'','合伙人推广卡','VBLBTJH1K',30,'2020-10-18 18:50:48',0,1,1,0,0,828465,0.03000000,'Bitcoin'),(6,0.00100000,'','合伙人推广卡','0QGWGCYFB',30,'2020-10-31 02:46:37',1,1,1,0,0,1,0.03000000,'Bitcoin'),(7,0.00100000,'','合伙人推广卡','0QGXKY6AJ',30,'2021-02-25 01:39:50',2,1,1,0,0,600800,0.03000000,'Bitcoin');
/*!40000 ALTER TABLE `promotion_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_card_order`
--

DROP TABLE IF EXISTS `promotion_card_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotion_card_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '兑换金额',
  `create_time` datetime DEFAULT NULL,
  `is_free` int(11) NOT NULL,
  `is_lock` int(11) NOT NULL,
  `lock_days` int(11) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `state` int(11) NOT NULL,
  `card_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK1e6ykywfbw68oodq33no4ao8u` (`card_id`) USING BTREE,
  CONSTRAINT `FK1e6ykywfbw68oodq33no4ao8u` FOREIGN KEY (`card_id`) REFERENCES `promotion_card` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合伙人推广卡订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_card_order`
--

LOCK TABLES `promotion_card_order` WRITE;
/*!40000 ALTER TABLE `promotion_card_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotion_card_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quick_exchange`
--

DROP TABLE IF EXISTS `quick_exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quick_exchange` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(24,8) DEFAULT '0.00000000',
  `create_time` datetime DEFAULT NULL,
  `ex_amount` decimal(24,8) DEFAULT '0.00000000',
  `from_unit` varchar(255) DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  `rate` decimal(24,8) DEFAULT '0.00000000',
  `status` int(11) NOT NULL,
  `to_unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='快速兑换';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quick_exchange`
--

LOCK TABLES `quick_exchange` WRITE;
/*!40000 ALTER TABLE `quick_exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `quick_exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `red_envelope`
--

DROP TABLE IF EXISTS `red_envelope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `red_envelope` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bg_image` varchar(255) DEFAULT NULL,
  `count` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `detail` text,
  `envelope_no` varchar(255) NOT NULL,
  `expired_hours` int(11) NOT NULL,
  `invite` int(11) NOT NULL,
  `logo_image` varchar(255) DEFAULT NULL,
  `max_rand` decimal(18,8) DEFAULT NULL COMMENT '最大随机领取额',
  `member_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `plateform` int(11) NOT NULL,
  `receive_amount` decimal(18,8) DEFAULT NULL COMMENT '领取总额',
  `receive_count` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  `total_amount` decimal(18,8) DEFAULT NULL COMMENT '红包总额',
  `type` int(11) NOT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `invite_user` varchar(255) DEFAULT NULL,
  `invite_user_avatar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_kpc525u446ufbpp8a8wxq6b93` (`envelope_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `red_envelope`
--

LOCK TABLES `red_envelope` WRITE;
/*!40000 ALTER TABLE `red_envelope` DISABLE KEYS */;
INSERT INTO `red_envelope` VALUES (1,'',100000,'2030-12-31 00:00:00','<p>123</p>','0216031903INSK2',1000000000,1,'',0.00010000,1,'btc',1,0.00000000,0,0,1.00000000,0,'btc',NULL,NULL),(2,'',100,'2021-05-16 18:46:01','<p>Hello this is test red envelope funcation.</p>','0516184601CR4CR',24,0,'',800.00000000,1,'HelloRedEnvelope',1,0.00000000,0,2,10000.00000000,0,'usdt',NULL,NULL),(3,'https://bizzanex.oss-cn-hangzhou.aliyuncs.com/2021/06/11/208ae308-933e-4c3b-a1f3-4553635eb961.jpg',100,'2021-06-11 10:08:12','<p>dsfsfsdf</p>','0611100812KNUKD',24,0,'https://bizzanex.oss-cn-hangzhou.aliyuncs.com/2021/06/11/e61762c3-1626-41d8-aafd-a54395f082da.jpg',10.00000000,1,'redpack',1,0.00000000,0,2,1000.00000000,0,'usdt',NULL,NULL),(4,'',1111,'2021-06-15 06:35:44','<h1><ul><li style=\"text-align: right;\"><span style=\"font-size: 2em;\"><p></p><hr><p></p>DFFGFDGD</span></li></ul></h1>','0615063543BNXV8',2333,0,'',100.00000000,1,'BZB',1,0.00000000,0,2,111.00000000,0,'BZB',NULL,NULL);
/*!40000 ALTER TABLE `red_envelope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `red_envelope_detail`
--

DROP TABLE IF EXISTS `red_envelope_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `red_envelope_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '领取数额',
  `cate` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `envelope_id` bigint(20) DEFAULT NULL,
  `member_id` bigint(20) NOT NULL,
  `user_identify` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `red_envelope_detail`
--

LOCK TABLES `red_envelope_detail` WRITE;
/*!40000 ALTER TABLE `red_envelope_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `red_envelope_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reward_activity_setting`
--

DROP TABLE IF EXISTS `reward_activity_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reward_activity_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `info` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKra9w7qwgbxti55cmkb6kycau7` (`admin_id`) USING BTREE,
  KEY `FKmxq57nrqt4lb9lqpxwc095h1h` (`coin_id`) USING BTREE,
  CONSTRAINT `FKmxq57nrqt4lb9lqpxwc095h1h` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`),
  CONSTRAINT `FKra9w7qwgbxti55cmkb6kycau7` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reward_activity_setting`
--

LOCK TABLES `reward_activity_setting` WRITE;
/*!40000 ALTER TABLE `reward_activity_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `reward_activity_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reward_promotion_setting`
--

DROP TABLE IF EXISTS `reward_promotion_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reward_promotion_setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `effective_time` int(11) NOT NULL,
  `info` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK7fl96plmj12crmepem7t876u3` (`admin_id`) USING BTREE,
  KEY `FKfhtlsn9g8lj5qecbo596ymhey` (`coin_id`) USING BTREE,
  CONSTRAINT `FK7fl96plmj12crmepem7t876u3` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FKfhtlsn9g8lj5qecbo596ymhey` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reward_promotion_setting`
--

LOCK TABLES `reward_promotion_setting` WRITE;
/*!40000 ALTER TABLE `reward_promotion_setting` DISABLE KEYS */;
INSERT INTO `reward_promotion_setting` VALUES (2,180,'{\"one\":40,“two”:20}',1,2,'2019-07-19 00:00:00',1,'BZB');
/*!40000 ALTER TABLE `reward_promotion_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reward_record`
--

DROP TABLE IF EXISTS `reward_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reward_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,8) DEFAULT NULL COMMENT '数目',
  `create_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKtm2ha75hh60am8n7lco838nmo` (`coin_id`) USING BTREE,
  KEY `FK9m2bd6gjgad67vb6of4waxtov` (`member_id`) USING BTREE,
  CONSTRAINT `FK9m2bd6gjgad67vb6of4waxtov` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKtm2ha75hh60am8n7lco838nmo` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reward_record`
--

LOCK TABLES `reward_record` WRITE;
/*!40000 ALTER TABLE `reward_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `reward_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sign`
--

DROP TABLE IF EXISTS `sign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,2) DEFAULT NULL,
  `creation_time` datetime DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `coin_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK58kn2gi7nvswa8hb76h87wtdl` (`coin_name`) USING BTREE,
  CONSTRAINT `FK58kn2gi7nvswa8hb76h87wtdl` FOREIGN KEY (`coin_name`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sign`
--

LOCK TABLES `sign` WRITE;
/*!40000 ALTER TABLE `sign` DISABLE KEYS */;
/*!40000 ALTER TABLE `sign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_advertise`
--

DROP TABLE IF EXISTS `sys_advertise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `url` varchar(255) DEFAULT NULL,
  `lang` varchar(255) NOT NULL,
  PRIMARY KEY (`serial_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='轮播图';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_advertise`
--

LOCK TABLES `sys_advertise` WRITE;
/*!40000 ALTER TABLE `sys_advertise` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_advertise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_help`
--

DROP TABLE IF EXISTS `sys_help`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_help` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) DEFAULT NULL,
  `content` longtext,
  `create_time` datetime DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `is_top` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `sys_help_classification` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `lang` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8 COMMENT='系统帮助';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_help`
--

LOCK TABLES `sys_help` WRITE;
/*!40000 ALTER TABLE `sys_help` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_help` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_sms`
--

DROP TABLE IF EXISTS `tb_sms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_sms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key_id` varchar(255) DEFAULT NULL,
  `key_secret` varchar(255) DEFAULT NULL,
  `sign_id` varchar(255) DEFAULT NULL,
  `sms_name` varchar(255) DEFAULT NULL,
  `sms_status` varchar(255) DEFAULT NULL,
  `template_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='短信Key参数表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_sms`
--

LOCK TABLES `tb_sms` WRITE;
/*!40000 ALTER TABLE `tb_sms` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_sms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_address`
--

DROP TABLE IF EXISTS `transfer_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transfer_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `min_amount` decimal(18,2) DEFAULT NULL COMMENT '最低转账数目',
  `status` int(11) DEFAULT NULL,
  `transfer_fee` decimal(18,6) DEFAULT NULL COMMENT '转账手续费率',
  `coin_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK7iv0cmmj36ncaw1nx92x15vtu` (`coin_id`) USING BTREE,
  CONSTRAINT `FK7iv0cmmj36ncaw1nx92x15vtu` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='转账地址';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_address`
--

LOCK TABLES `transfer_address` WRITE;
/*!40000 ALTER TABLE `transfer_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_record`
--

DROP TABLE IF EXISTS `transfer_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKkrlf3bglmf2c51sorq9fpue0g` (`coin_id`) USING BTREE,
  CONSTRAINT `FKkrlf3bglmf2c51sorq9fpue0g` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='转账记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_record`
--

LOCK TABLES `transfer_record` WRITE;
/*!40000 ALTER TABLE `transfer_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet_trans_record`
--

DROP TABLE IF EXISTS `wallet_trans_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wallet_trans_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(26,16) DEFAULT NULL COMMENT '划转金额',
  `create_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `source` int(11) DEFAULT '0' COMMENT '从哪里划转',
  `target` int(11) DEFAULT '0' COMMENT '划转到哪里去',
  `unit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包交易记录\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_trans_record`
--

LOCK TABLES `wallet_trans_record` WRITE;
/*!40000 ALTER TABLE `wallet_trans_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `wallet_trans_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `website_information`
--

DROP TABLE IF EXISTS `website_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='网站信息\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `website_information`
--

LOCK TABLES `website_information` WRITE;
/*!40000 ALTER TABLE `website_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `website_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `withdraw_code_record`
--

DROP TABLE IF EXISTS `withdraw_code_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `withdraw_code_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `deal_time` datetime DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rmember_id` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `withdraw_amount` decimal(18,8) DEFAULT NULL COMMENT '申请总数量',
  `withdraw_code` varchar(255) DEFAULT NULL,
  `coin_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FKa3kybqr5vhpnf5a57ridds671` (`coin_id`) USING BTREE,
  CONSTRAINT `FKa3kybqr5vhpnf5a57ridds671` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdraw_code_record`
--

LOCK TABLES `withdraw_code_record` WRITE;
/*!40000 ALTER TABLE `withdraw_code_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdraw_code_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `withdraw_fee_history`
--

DROP TABLE IF EXISTS `withdraw_fee_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `withdraw_fee_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `biz_type` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `fee_amount` decimal(28,8) DEFAULT NULL COMMENT '手续费数量',
  `fee_coin` varchar(255) DEFAULT NULL,
  `fee_type` varchar(255) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `u_id` bigint(20) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdraw_fee_history`
--

LOCK TABLES `withdraw_fee_history` WRITE;
/*!40000 ALTER TABLE `withdraw_fee_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdraw_fee_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `withdraw_record`
--

DROP TABLE IF EXISTS `withdraw_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK2lmq6bcbk4nl3hmqcxbnx2kuc` (`admin_id`) USING BTREE,
  KEY `FK6drad9oqabujy0jsre3minxi` (`coin_id`) USING BTREE,
  CONSTRAINT `FK2lmq6bcbk4nl3hmqcxbnx2kuc` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`),
  CONSTRAINT `FK6drad9oqabujy0jsre3minxi` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdraw_record`
--

LOCK TABLES `withdraw_record` WRITE;
/*!40000 ALTER TABLE `withdraw_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdraw_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'test111'
--

--
-- Dumping routines for database 'test111'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-19 10:21:09
