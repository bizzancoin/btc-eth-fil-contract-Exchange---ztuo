package com.bizzan.er.market.job;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.bizzan.er.market.engine.MarketEngineFactory;

@EnableAsync
@Component
public class SyncMarketJob {
	private final static  Logger logger  =  LoggerFactory.getLogger(SyncMarketJob.class);
	@Autowired
	private MarketEngineFactory engineFactory;
	
	@Async
	@Scheduled(fixedDelay = 4500)
    public void synchronizeExchangeCenterOKex(){
		engineFactory.getEngine("Okex").syncMarket();
	}
	
	@Async
	@Scheduled(fixedDelay = 5000)
    public void synchronizeExchangeCenterHuobi(){
		engineFactory.getEngine("Huobi").syncMarket();
	}
	
	@Async
	@Scheduled(fixedDelay = 5500)
    public void synchronizeExchangeCenterZb(){
		engineFactory.getEngine("Zb").syncMarket();
	}
	
	@Async
	@Scheduled(fixedDelay = 6000)
    public void synchronizeExchangeCenterBiki(){
		engineFactory.getEngine("Biki").syncMarket();
	}
	
	@Async
	@Scheduled(fixedDelay = 60000)
    public void synchronizeExchangeCenterFxh(){
		engineFactory.getEngine("Fxh").syncMarket();
	}
}
