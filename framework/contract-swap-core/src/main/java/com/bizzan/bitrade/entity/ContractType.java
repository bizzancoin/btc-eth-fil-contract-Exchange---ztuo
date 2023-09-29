package com.bizzan.bitrade.entity;

public enum ContractType {
    PERPETUAL(0, "金本位合约"),
    SECOND(1, "币本位合约");

    ContractType(int number, String description) {
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
