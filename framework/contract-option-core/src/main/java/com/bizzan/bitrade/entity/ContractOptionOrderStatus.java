package com.bizzan.bitrade.entity;

public enum ContractOptionOrderStatus {
    OPEN(0, "参与中"),
    CLOSE(1, "已开奖"),
    CANCELED(2, "撤销");

    ContractOptionOrderStatus(int number, String description) {
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
