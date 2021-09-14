Bizzan数字货币交易系统

=====================================
# 捐赠：
#### 您的捐赠是我们开发最大的动力
- BTC/USDT(比特币/USDT)：1Dwwqhw9pV9iSSQwuJc8nAygda7XfahaoW
- ETH/USDT(以太坊/USDT)：0x4f1ea0f10aa99f608f31f70b4d3119f6928693ed
- LTC(莱特币)：LXr4TMtDhCSpdAo98vg2sbvX3UXDVPQvMa

### 主要技术

- 后端：Spring、SpringMVC、SpringData、SpringCloud、SpringBoot
- 数据库：Mysql、Mongodb
- 其他：redis、kafka、阿里云OSS、腾讯防水校验、环信推送
- 前端：Vue、iView、less
- 同时提供IOS和Android版本。


1. cloud

- 提供SpringCloud微服务注册中心功能，为基础模块，必须部署
- 依赖服务：无

2. ucenter-api

- 提供用户相关的接口（如登录、注册、资产列表）,该模块为基础为基础模块，必须部署
- 依赖服务：mysql,kafka,redis,mongodb,短信接口，邮箱账号

3. otc-api

- 提供场外交易功能接口，没有场外交易的可以不部署
- 依赖服务：mysql,redis,mongodb,短信接口

4. exchange-api

- 提供币币交易接口，没有币币交易的项目可以不部署
- 依赖服务：mysql,redis,mongodb,kafka

5. chat

- 提供实时通讯接口，基础模块，需要部署
- 依赖服务：mysql,redis,mongodb

6. admin

- 提供管理后台的所有服务接口，必须部署
- 依赖服务：mysql,redis,mongodb

7. wallet

- 提供充币、提币、获取地址等钱包服务，为基础模块，必须部署
- 依赖服务：mysql,mongodb,kafka,cloud

8. market

- 提供币种价格、k线、实时成交等接口服务，场外交易不需要部署
- 依赖服务：mysql,redis,mongodb,kafka,cloud

9. exchange

- 提供撮合交易服务，场外交易不需要部署
- 依赖服务：mysql,mongodb,kafka

10. contract-swap-api
- 提供合约币种价格、K线、盘口消息订阅、实时成交等接口服务
- 依赖服务：mysql,redis,mongodb,kafka,cloud

11. open-api(未开发完成)
- 提供用户API接口
- 依赖服务：mysql,redis,mongodb,kafka,cloud

##  重点业务介绍

    后端框架的核心模块为 exchange,market模块。

    其中exhcnge模块完全采用Java内存处理队列,大大加快处理逻辑,中间不牵涉数据库操作,保证处理速度快,其中项目启动后采用继承ApplicationListener方式，自动运行；

    启动后自动加载未处理的订单,重新加载到JVM中，从而保证数据的准确，exchange将订单处理后，将成交记录发送到market;

    market模块主要都是数据库操作，将用户变化信息持久化到数据库中。主要难点在于和前端交互socket推送，socket推送采用两种方式，web端socket采用SpringSocket，移动端采用Netty推送,其中netty推送通过定时任务处理。
	
	

## 环境搭建
- Centos 7.8
- MySQL 5.7.16
- Redis 6.0
- Mongodb 4.0
- kafka_2.11-2.2.1
- nginx-1.19.0
- JDK 1.8
- Vue
- Zookeeper

## 服务部署准备

1. 项目用了Lombok插件，无论用什么IDE工具，请务必先安装Lombok插件
2. 项目用了QueryDsl，如果遇见以Q开头的类找不到，请先编译一下对应的core模块，例如core、exchange-core、xxx-core这种模块
3. 找不到的jar包在项目jar文件夹下
4. jdk版本1.8以上
5. 初始化sql在sql文件夹中配置文件
配置文件打开这个设置会自动建表
#jpa
#spring.jpa.hibernate.ddl-auto=update.

## 修改服务配置文件
请根据服务实际部署情况修改以下配置。配置文件位置如下，如果配置文件中没有某一项配置，说明该模块未使用到该项功能，无需添加：

```
各个模块/src/main/resources/application.properties


### 服务启动
 1. maven构建打包服务

 2. 将各个模块target文件夹下的XX.jar上传到自己的服务器

 3. 先启动cloud模块，再启动market，exchange模块，剩下的没有顺序。

### 提问和建议
- 使用Issuse，我们会及时跟进解答。
- 加入交流群：区块链交易所技术知识交流群【QQ群:735446452】
- E-mail:xunibidev@gmail.com


注意事项：
当内存不足时，在linux控制台输入top可以查看java进程占用了大量内存（一个java进程占用1G以上），因为有很多jar包需要运行，所以需要控制某些jar包使用的内存，目前控制以下4个：

- java -jar -Xms512m -Xmx512m -Xmn200m -Xss256k  admin-api.jar

- java -jar -Xms512m -Xmx512m -Xmn200m -Xss256k  cloud.jar

- java -jar -Xms512m -Xmx512m -Xmn200m -Xss256k  wallet.jar