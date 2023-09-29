package com.bizzan.er.market.event;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.bizzan.er.market.engine.MarketEngineFactory;
import com.bizzan.er.market.engine.MarketEngineOkex;

@Component
public class ApplicationEvent implements ApplicationListener<ContextRefreshedEvent> {
	
	private final static  Logger logger  =  LoggerFactory.getLogger(ApplicationEvent.class);
	
	@Autowired
	private MarketEngineFactory marketEngineFactory;
	
	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		logger.info("===============================================");
		logger.info("===============行情同步启动成功===============");
		logger.info("===============================================");
		logger.info("=========Okex===Huobi===Zb===Biki===FX=========");
		logger.info("===============================================");
		logger.info("============https://www.bizzan.pro=============");
		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	}

}
