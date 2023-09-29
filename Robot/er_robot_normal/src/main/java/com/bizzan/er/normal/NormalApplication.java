package com.bizzan.er.normal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
  * 一般交易机器人+控盘机器人
 *此交易机器人依赖于er_market项目提供行情，否则无法正常运行
 */
@EnableScheduling
@SpringBootApplication
@EnableDiscoveryClient
@EnableEurekaClient
public class NormalApplication {
    public static void main( String[] args ){
    	SpringApplication.run(NormalApplication.class,args);
    }
}
