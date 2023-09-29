package com.bizzan.er.market.engine;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.http.client.ClientProtocolException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.er.market.entity.CoinThumb;
import com.bizzan.er.market.utils.HttpClientUtil;

public class MarketEngineFxh implements MarketEngine{
private final static  Logger logger  =  LoggerFactory.getLogger(MarketEngineOkex.class);
	
	private String engineName = "Fxh"; // 非小号
	
	private String allTickerUrl = "https://fxhapi.feixiaohao.com/public/v1/ticker?limit=1000"; // 行情获取URL

	private Long updateTime = 0L; // 最后更新时间
	
	private ConcurrentHashMap<String, CoinThumb> tickers = new ConcurrentHashMap<String, CoinThumb>();
	
	// 名称映射
	private Map<String, String> mappingPair = new HashMap<String, String>();

	@Override
	public void syncMarket() {
		try {
			logger.info(this.engineName + " - 同步非小号行情...");
			String retStr = HttpClientUtil.doHttpsGet(allTickerUrl, null, null);
			if(retStr != null && !retStr.equals("")){
				
				JSONArray tickerArr = JSONArray.parseArray(retStr);
				
				if(tickerArr != null && tickerArr.size() > 0) {
					logger.info(this.engineName + " - 共获取 {} 组行情", tickerArr.size());
					for(int i = 0; i < tickerArr.size(); i++) {
						JSONObject obj = tickerArr.getJSONObject(i);
						
						String coinPair1 = obj.getString("symbol").toLowerCase() + "usdt";
						
						CoinThumb thumb = this.getThumb(coinPair1);
						
						thumb.setPrice(obj.getBigDecimal("price_usd"));
						thumb.setHigh(obj.getBigDecimal("price_usd"));
						thumb.setLow(obj.getBigDecimal("price_usd"));
						thumb.setLastUpdate(System.currentTimeMillis());
						
						//===============================================================
						String coinPair2 = obj.getString("symbol").toLowerCase() + "btc";
						
						CoinThumb thumb2 = this.getThumb(coinPair2);
						
						thumb2.setPrice(obj.getBigDecimal("price_btc"));
						thumb2.setHigh(obj.getBigDecimal("price_btc"));
						thumb2.setLow(obj.getBigDecimal("price_btc"));
						thumb2.setLastUpdate(System.currentTimeMillis());
					}
					
					this.updateTime = System.currentTimeMillis();
				}
			}
		} catch (KeyManagementException e1) {
			logger.info(this.engineName + " - [KeyManagementException]" + e1.getMessage());
		} catch (ClientProtocolException e1) {
			logger.info(this.engineName + " - [ClientProtocolException]" + e1.getMessage());
		} catch (NoSuchAlgorithmException e1) {
			logger.info(this.engineName + " - [NoSuchAlgorithmException]" + e1.getMessage());
		} catch (KeyStoreException e1) {
			logger.info(this.engineName + " - [KeyStoreException]" + e1.getMessage());
		} catch (IOException e1) {
			logger.info(this.engineName + " - [IOException]" + e1.getMessage());
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
