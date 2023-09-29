package com.bizzan.bitrade;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 */
@SpringBootApplication
@EnableAspectJAutoProxy(exposeProxy=true)
public class AdminApplication {
    public static void main(String[] args) {
        SpringApplication.run(AdminApplication.class, args);
    }
}