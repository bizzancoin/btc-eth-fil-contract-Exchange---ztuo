package com.bizzan.er.market.engine;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.alibaba.fastjson.JSONObject;

import com.bizzan.er.market.entity.CoinThumb;
import com.bizzan.er.market.utils.MessageResult;

public class MarketEngineFactory {
	
	private ConcurrentHashMap<String, MarketEngine> engineMap;

    public MarketEngineFactory() {
    	engineMap = new ConcurrentHashMap<>();
    }
    
    public void addEngine(String market, MarketEngine engine) {
    	if(!this.containsEngine(market)) {
    		engineMap.put(market, engine);
    	}
    }
    
    public boolean containsEngine(String market) {
    	return engineMap != null && engineMap.containsKey(market);
    }
    
    public MarketEngine getEngine(String market) {
    	return engineMap.get(market);
    }
    
    public ConcurrentHashMap<String, MarketEngine> getEngineList() {
    	return engineMap;
    }
    
    public List<JSONObject> engineStatus() {
    	List<JSONObject> list = new ArrayList<JSONObject>();
    	engineMap.forEach((engineName, engine)->{
    		JSONObject obj = new JSONObject();
    		obj.put("market", engineName);
    		obj.put("url", engine.getUrl());
    		obj.put("updateTime", engine.getLastUpdateTime());
    		list.add(obj);
    	});
    	return list;
    }
    /**
     * 获取交易对行情
     * @param pair
     * @return
     */
    public CoinThumb getThumbByPair(String pair){
    	List<CoinThumb> thumbs = new ArrayList<CoinThumb>();
    	Long currentTime = System.currentTimeMillis();
    	engineMap.forEach((engineName, engine)->{
    		CoinThumb tem = engine.getCoinThumb(pair);
    		// 最后更新时间不超过3分钟
    		if(tem != null && (currentTime - tem.getLastUpdate() < 180000)) {
    			thumbs.add(tem);
    		}
    	});
    	// 从各大交易所获取的价格进行过滤
    	if(thumbs.size() > 0) {
    		CoinThumb thumb = null;
    		int index = 0;
    		for(int i = 0; i < thumbs.size(); i++) {
    			if(thumbs.get(i).getPrice().compareTo(BigDecimal.ZERO) > 0) {
    				if(thumb != null) {
    					// 最后更新的价格
    					if(thumbs.get(i).getLastUpdate() > thumb.getLastUpdate()) {
    						thumb = thumbs.get(i);
    						index = i;
    					}
    				}else {
    					thumb = thumbs.get(i);
    				}
    			}
    		}
    		// 检查最后获得的价格是否与其他价格相差太大(10%为标准)，只有数量超过2的时候才有可比性
    		if(thumbs.size() > 2) {
    			int count = 0;
    			int newIndex = 0;
	    		for(int j = 0; j < thumbs.size(); j++) {
	    			if( j != index) {
	    				BigDecimal percent = thumbs.get(j).getPrice().subtract(thumb.getPrice()).abs().divide(thumb.getPrice(), 3, BigDecimal.ROUND_HALF_DOWN);
	    				if(percent.compareTo(BigDecimal.valueOf(0.1)) > 0) {
	    					count++;
	    					newIndex = j;
	    				}
	    			}
	    		}
	    		// 价差超10%的存在两个以上
	    		if(count > 1) {
	    			thumb = thumbs.get(newIndex);
	    		}
    		}
    		return thumb;
    	}
    	return null;
    }
}
