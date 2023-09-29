package com.bizzan.er.market.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.bizzan.er.market.engine.MarketEngine;
import com.bizzan.er.market.engine.MarketEngineBiki;
import com.bizzan.er.market.engine.MarketEngineFactory;
import com.bizzan.er.market.engine.MarketEngineFxh;
import com.bizzan.er.market.engine.MarketEngineHuobi;
import com.bizzan.er.market.engine.MarketEngineOkex;
import com.bizzan.er.market.engine.MarketEngineZb;

@Configuration
public class MarketEngineConfig {
	@Bean
	public MarketEngineFactory marketEngineFactory() {
		
		MarketEngineFactory factory = new MarketEngineFactory();
		
		MarketEngine okexEngine = new MarketEngineOkex();
		factory.addEngine("Okex", okexEngine);
		
		MarketEngine zbEngine = new MarketEngineZb();
		factory.addEngine("Zb", zbEngine);
		
		MarketEngine huobiEngine = new MarketEngineHuobi();
		factory.addEngine("Huobi", huobiEngine);
		
		MarketEngine bikiEngine = new MarketEngineBiki();
		factory.addEngine("Biki", bikiEngine);
		
		MarketEngine fxhEngine = new MarketEngineFxh();
		factory.addEngine("Fxh", fxhEngine);
		
		return factory;
	}
}
