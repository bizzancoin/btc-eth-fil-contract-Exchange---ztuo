package com.bizzan.er.normal.entity;

import java.math.BigDecimal;

public class CoinThumb {
	private BigDecimal price; // 当前价格
	private BigDecimal high; // 最高价格
	private BigDecimal low; // 最低价格
	private Long lastUpdate; // 最后更新时间
	
	public CoinThumb() {
		price = BigDecimal.ZERO;
		high = BigDecimal.ZERO;
		low = BigDecimal.ZERO;
		lastUpdate = 0L;
	}
	
	public Long getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Long lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
	public BigDecimal getPrice() {
		return price;
	}
	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	public BigDecimal getHigh() {
		return high;
	}
	public void setHigh(BigDecimal high) {
		this.high = high;
	}
	public BigDecimal getLow() {
		return low;
	}
	public void setLow(BigDecimal low) {
		this.low = low;
	}
}
