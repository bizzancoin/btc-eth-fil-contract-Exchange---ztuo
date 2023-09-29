package com.bizzan.er.price.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.bizzan.er.price.robot.ExchangeRobotFactory;

@Configuration
public class ExchangeRobotFactoryConfig {
	@Bean
	public ExchangeRobotFactory getFactory() {
		ExchangeRobotFactory factory = new ExchangeRobotFactory();
		return factory;
	}
}
