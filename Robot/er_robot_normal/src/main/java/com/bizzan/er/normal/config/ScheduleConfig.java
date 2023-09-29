package com.bizzan.er.normal.config;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

@Configuration
public class ScheduleConfig implements SchedulingConfigurer{
	@Autowired
	private Executor executor;

	@Override
	public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
       taskRegistrar.setScheduler(executor);
	}

	@Bean(destroyMethod = "shutdown")
	public Executor taskExecutor() {
       return Executors.newScheduledThreadPool(4);
	}
}
