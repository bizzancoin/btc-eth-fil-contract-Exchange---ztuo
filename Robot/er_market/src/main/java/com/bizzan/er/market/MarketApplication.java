package com.bizzan.er.market;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
  * 获取主流交易所币种行情
 *
 */
@EnableScheduling
@SpringBootApplication
@EnableDiscoveryClient
@EnableEurekaClient
public class MarketApplication {
    public static void main( String[] args ){
    	SpringApplication.run(MarketApplication.class,args);
    }
}
