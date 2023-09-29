package com.bizzan.bitrade.model.screen;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ContractOptionScreen {
    private String symbol; // 合约交易对
    private Integer optionNo; // 合约序号
    private Integer totalBuyCount; // 买涨人数
    private Integer totalSellCount; // 买跌人数
    private BigDecimal totalPl; // 盈利
}
