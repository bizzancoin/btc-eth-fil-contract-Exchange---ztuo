package com.bizzan.er.price;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 固定价格交易机器人
 */
@EnableScheduling
@SpringBootApplication
@EnableDiscoveryClient
@EnableEurekaClient
public class PriceApplication {
    public static void main( String[] args ){
        SpringApplication.run(PriceApplication.class,args);
    }

}
