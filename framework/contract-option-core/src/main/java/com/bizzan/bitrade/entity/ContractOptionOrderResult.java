package com.bizzan.bitrade.entity;

public enum ContractOptionOrderResult {
    WAIT(0, "待开始"),
    WIN(1, "胜利"),
    LOSE(2, "失败"),
    TIED(3, "平局"),
    CANCELED(4, "撤销");

    ContractOptionOrderResult(int number, String description) {
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
