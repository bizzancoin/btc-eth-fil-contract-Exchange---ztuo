package com.bizzan.er.market.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.er.market.engine.MarketEngine;
import com.bizzan.er.market.engine.MarketEngineFactory;
import com.bizzan.er.market.entity.CoinThumb;
import com.bizzan.er.market.utils.MessageResult;

@RestController
public class MarketController {

	@Autowired
	private MarketEngineFactory marketEngineFactory;
	
	/**
	 * 获取交易对行情
	 * @param pair
	 * @return
	 */
	@RequestMapping("thumb/{pair}")
    public MessageResult findThumb(@PathVariable String pair){
		CoinThumb thumb = marketEngineFactory.getThumbByPair(pair);
		if(thumb != null) {
			MessageResult mr = new MessageResult(0,"success");
			mr.setData(thumb);
			return mr;
		}else {
			MessageResult mr = new MessageResult(500,"未发现交易对行情");
			return mr;
		}
    }
	
	/**
	 * 获取所有行情引擎状态
	 * @return
	 */
	@RequestMapping("status")
	public MessageResult status(){
		List<JSONObject> engineStatus = marketEngineFactory.engineStatus();
		MessageResult mr = new MessageResult(0,"success");
		mr.setData(engineStatus);
		return mr;
	}
	
	/**
	 * 更新行情获取URL
	 * @param market
	 * @param url
	 * @return
	 */
	@RequestMapping("updateUrl")
	public MessageResult updateEngineUrl(String market, String url) {
		if(marketEngineFactory.containsEngine(market)) {
			MarketEngine engine = marketEngineFactory.getEngine(market);
			engine.updateEngineUrl(url);
			MessageResult mr = new MessageResult(0, "更新成功（最新行情URL："+url);
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "行情获取引擎不存在");
			return mr;
		}
	}
	
	/**
	 * 增加别名映射
	 * @param market
	 * @param name
	 * @param alias
	 * @return
	 */
	@RequestMapping("addMaping")
	public MessageResult addMapping(String market, String name, String alias) {
		if(marketEngineFactory.containsEngine(market)) {
			MarketEngine engine = marketEngineFactory.getEngine(market);
			engine.addAliasMapping(name, alias);
			MessageResult mr = new MessageResult(0, "新增/更新别名映射 > " + name + " - " + alias);
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "行情获取引擎不存在");
			return mr;
		}
	}
	
	/**
	 * 移除映射
	 * @param market
	 * @param name
	 * @return
	 */
	@RequestMapping("removeMaping")
	public MessageResult addMapping(String market, String name) {
		if(marketEngineFactory.containsEngine(market)) {
			MarketEngine engine = marketEngineFactory.getEngine(market);
			engine.removeAliasMapp(name);
			MessageResult mr = new MessageResult(0, "新增/更新别名映射 > " + name);
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "行情获取引擎不存在");
			return mr;
		}
	}
}
