### 主要技术

- 后端：Spring、SpringMVC、SpringData、SpringCloud、SpringBoot
- 数据库：Mysql、Mongodb
- 其他：redis、kafka、阿里云OSS、腾讯防水校验、环信推送
- 前端：Vue、iView、less
- 同时提供IOS和Android版本。

##  重点业务介绍

    后端框架的核心模块为 exchange,market模块。
    
    其中exhcnge模块完全采用Java内存处理队列,大大加快处理逻辑,中间不牵涉数据库操作,保证处理速度快,其中项目启动后采用继承ApplicationListener方式，自动运行；
    
    启动后自动加载未处理的订单,重新加载到JVM中，从而保证数据的准确，exchange将订单处理后，将成交记录发送到market;
    
    market模块主要都是数据库操作，将用户变化信息持久化到数据库中。主要难点在于和前端交互socket推送，socket推送采用两种方式，web端socket采用SpringSocket，移动端采用Netty推送,其中netty推送通过定时任务处理。


​	

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
