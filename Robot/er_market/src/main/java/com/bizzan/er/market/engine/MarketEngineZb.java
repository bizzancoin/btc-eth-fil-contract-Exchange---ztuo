package com.bizzan.er.market.engine;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.er.market.entity.CoinThumb;
import com.bizzan.er.market.utils.HttpClientUtil;

public class MarketEngineZb implements MarketEngine{

	private final static  Logger logger  =  LoggerFactory.getLogger(MarketEngineOkex.class);
	
	private String engineName = "Zb";
	
	private String allTickerUrl = "http://api.zb.center/data/v1/allTicker"; // 行情获取URL
	private Long updateTime = 0L; // 最后更新时间
	
	private ConcurrentHashMap<String, CoinThumb> tickers = new ConcurrentHashMap<String, CoinThumb>();

	// 名称映射（如bchusdt -> bchabcusdt, bsvusdt -> bchsvusdt
	private Map<String, String> mappingPair = new HashMap<String, String>();
	
	public MarketEngineZb(){
		// 初始化映射关系
		mappingPair.put("bchusdt", "bchabcusdt");
		mappingPair.put("bsvusdt", "bchsvusdt");
	}
	
	@Override
	public void syncMarket() {
		try {
			logger.info(this.engineName + " - 同步ZB行情...");
			String retStr = HttpClientUtil.doHttpGet(allTickerUrl, null, null);
			if(retStr != null && !retStr.equals("")){
				JSONObject retObj = JSONObject.parseObject(retStr);
				int count = 0;
				for (Map.Entry entry : retObj.entrySet()) {
					String coinPair = entry.getKey().toString().toLowerCase();
					CoinThumb thumb = this.getThumb(coinPair);
					JSONObject obj = JSONObject.parseObject(entry.getValue().toString());
					thumb.setPrice(obj.getBigDecimal("last"));
					thumb.setHigh(obj.getBigDecimal("high"));
					thumb.setLow(obj.getBigDecimal("low"));
					thumb.setLastUpdate(System.currentTimeMillis());
					count++;
		        }
				this.updateTime = System.currentTimeMillis();
				logger.info(this.engineName + " - 共获取 {} 组行情", count);
			}else {
				logger.info(this.engineName + " - 获取行情失败：{}", retStr);
			}
		}catch (Exception e) {
			e.printStackTrace();
			logger.info(this.engineName + " - " + e.getMessage());
		}
	}

	private CoinThumb getThumb(String pair) {
		if(!tickers.containsKey(pair)) {
			CoinThumb thumb = new CoinThumb();
			tickers.put(pair, thumb);
		}
		return tickers.get(pair);
	}

	@Override
	public boolean containsPair(String pair) {
		if(tickers.containsKey(pair)) {
			return true;
		}else {
			return false;
		}
	}

	@Override
	public List<CoinThumb> thumbList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public CoinThumb getCoinThumb(String pair) {
		if(mappingPair.containsKey(pair)) {
			pair = mappingPair.get(pair);
		}
		
		if(tickers.containsKey(pair)) {
			return tickers.get(pair);
		}
		
		return null;
	}

	@Override
	public Long getLastUpdateTime() {
		return updateTime;
	}

	@Override
	public boolean updateEngineUrl(String url) {
		this.allTickerUrl = url;
		return true;
	}

	@Override
	public Map<String, String> getAliasMapping() {
		return this.mappingPair;
	}

	@Override
	public int addAliasMapping(String name, String alias) {
		this.mappingPair.put(name, alias);
		return 0;
	}

	@Override
	public int removeAliasMapp(String name) {
		this.mappingPair.remove(name);
		return 0;
	}

	@Override
	public String getUrl() {
		return this.allTickerUrl;
	}

}
