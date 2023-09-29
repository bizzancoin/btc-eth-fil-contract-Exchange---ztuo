package com.bizzan.bitrade.entity;

/**
 * 用户委托单状态
 */
public enum ContractOrderEntrustStatus {

    // 用户委托状态
    //1:委托中/2:已撤销/3:委托失败/4:委托成功
    ENTRUST_ING(0, "委托中"),
    ENTRUST_CANCEL(1, "已撤销"),
    ENTRUST_FAILURE(2, "委托失败"),
    ENTRUST_SUCCESS(3, "委托成功");

    ContractOrderEntrustStatus(int number, String description) {
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
