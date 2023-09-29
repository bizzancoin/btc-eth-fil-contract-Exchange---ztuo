package com.bizzan.bitrade.entity;

public enum ContractOptionOrderDirection {
    BUY(0, "看涨"),
    SELL(1, "看跌"),
    TIED(2, "看平");

    ContractOptionOrderDirection(int number, String description) {
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
