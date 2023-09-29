package com.bizzan.bitrade;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年02月06日
 *
 *exclude = {MongoAutoConfiguration.class,MongoDataAutoConfiguration.class}
 * 禁用springboot自带的mongodb配置（localhost），不禁用虽然也可以，但每次启动都会出现报错信息
 */

@SpringBootApplication
@EnableScheduling
@EnableDiscoveryClient
public class AgentApplication {
    public static void main(String[] args) {
        SpringApplication.run(AgentApplication.class, args);
    }
}
