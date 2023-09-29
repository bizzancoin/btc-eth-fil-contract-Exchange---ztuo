package com.bizzan.er.market.engine;

import java.util.List;
import java.util.Map;

import com.bizzan.er.market.entity.CoinThumb;

public interface MarketEngine {
	
	/**
	 * 同步行情
	 */
	public void syncMarket();
	
	/**
	 * 是否包含交易对
	 * @param pair
	 * @return
	 */
	public boolean containsPair(String pair);
	
	/**
	 * 获取所有币种价格
	 * @return
	 */
	public List<CoinThumb> thumbList();
	
	/**
	 * 获取币种行情
	 * @return
	 */
	public CoinThumb getCoinThumb(String pair);
	
	/**
	 * 获取最后更新时间
	 * @return
	 */
	public Long getLastUpdateTime();
	
	/**
	 * 更新URL
	 * @param url
	 * @return
	 */
	public boolean updateEngineUrl(String url);
	
	/**
	 * 获取别名映射
	 * @return
	 */
	public Map<String, String> getAliasMapping();
	
	/**
	 * 增加别名映射
	 * @param name
	 * @param alias
	 * @return
	 */
	public int addAliasMapping(String name, String alias);
	
	/**
	 * 删除别名映射
	 * @param name
	 * @return
	 */
	public int removeAliasMapp(String name);

	public String getUrl();
}
