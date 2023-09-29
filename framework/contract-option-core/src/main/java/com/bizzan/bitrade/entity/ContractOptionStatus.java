package com.bizzan.bitrade.entity;

public enum ContractOptionStatus {
    STARTING(0, "下注中"),
    OPENING(1, "开奖中"),
    CLOSED(2, "已开奖"),
    CANCELED(3, "撤销");


    ContractOptionStatus(int number, String description) {
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
