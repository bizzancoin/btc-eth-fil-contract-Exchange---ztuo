package com.bizzan.er.normal.entity;

import lombok.Data;

@Data
public class CustomRobotKline {
	private String coinName = ""; // 交易对名称，如：xxxusdt
	private String kdate = ""; // K线日期，如：2020/02/02
	private String kline = ""; // K线数组JSON字符串
	private int pricePencent = 0; // 价格浮动范围
}
