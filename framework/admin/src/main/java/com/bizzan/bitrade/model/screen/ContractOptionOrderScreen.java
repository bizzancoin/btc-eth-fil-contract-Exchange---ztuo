package com.bizzan.bitrade.model.screen;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ContractOptionOrderScreen {
    private String symbol;
    private Long memberId;
    private BigDecimal betAmount;
    private BigDecimal rewardAmount;
}
