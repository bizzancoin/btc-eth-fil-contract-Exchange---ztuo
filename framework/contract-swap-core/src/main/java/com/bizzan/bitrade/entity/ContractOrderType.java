package com.bizzan.bitrade.entity;

public enum ContractOrderType {
    MARKET_PRICE(0, "市价"),
    LIMIT_PRICE(1, "限价"),
    SPOT_LIMIT(2, "计划委托");

    ContractOrderType(int number, String description) {
        this.code = number;
        this.description = description;
    }
    private int code;
    private String description;
    public int getCode() {
        return code;
    }
    public String getDescription() {
        return description;
    }
}
