package com.bizzan.bitrade.entity;

public enum ContractOrderPattern {
    CROSSED(0, "全仓"),
    FIXED(1, "逐仓");

    ContractOrderPattern(int number, String description) {
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
