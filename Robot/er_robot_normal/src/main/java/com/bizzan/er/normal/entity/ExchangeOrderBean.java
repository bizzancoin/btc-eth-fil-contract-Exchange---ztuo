package com.bizzan.er.normal.entity;


import java.math.BigDecimal;

public class ExchangeOrderBean {
	//交易对（例：BTC/USDT）
	private String symbol;
	//下单价格（例：11761.0000）
	private BigDecimal price;
	//下单数量（例：0.01）
	private BigDecimal amount;
	//下单方向（BUY或SELL）
	private String direction;
	//下单类型（LIMIT_PRICE或MARKET_PRICE）
	private String type;
	//使用折扣（例：0）
	private int useDiscount;
	//下单用户ID（例：1）
	private int uid;
	//下单签名（例：987654321asdf）
	private String sign;
	
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public BigDecimal getPrice() {
		return price;
	}
	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public String getDirection() {
		return direction;
	}
	public void setDirection(String direction) {
		this.direction = direction;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getUseDiscount() {
		return useDiscount;
	}
	public void setUseDiscount(int useDiscount) {
		this.useDiscount = useDiscount;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public String getSign() {
		return sign;
	}
	public void setSign(String sign) {
		this.sign = sign;
	}

}
