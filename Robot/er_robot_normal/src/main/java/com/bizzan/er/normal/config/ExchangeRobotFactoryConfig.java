package com.bizzan.er.normal.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.bizzan.er.normal.robot.ExchangeRobotFactory;

@Configuration
public class ExchangeRobotFactoryConfig {
	@Bean
	public ExchangeRobotFactory getFactory() {
		ExchangeRobotFactory factory = new ExchangeRobotFactory();
		return factory;
	}
}
