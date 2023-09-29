package com.bizzan.bitrade.entity;

public enum ContractOptionResult {
    WAIT(0, "待开始"),
    WIN(1, "涨"),
    LOSE(2, "跌"),
    TIED(3, "平"),
    CANCELED(3, "撤销");


    ContractOptionResult(int number, String description) {
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
