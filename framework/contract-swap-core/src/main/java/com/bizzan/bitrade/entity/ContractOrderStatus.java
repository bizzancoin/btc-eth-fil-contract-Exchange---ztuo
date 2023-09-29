package com.bizzan.bitrade.entity;

/**
 * 用户持仓单状态
 */
public enum ContractOrderStatus {
    // 用户仓位状态
    // 1:持仓中/2:用户平仓/3:强制平仓/4:委托持仓中/5:止盈止损平仓/6:跟随持仓中/7:跟随平仓
    MARKET_IN_THE_POSITION(1, "持仓中"),
    MARKET_USER_CLOSE_OUT(2, "用户平仓"),
    MARKET_FORCED_CLOSE_OUT(3, "强制平仓"),
    MARKET_ENTRUST_IN_THE_POSITION(4, "委托持仓中"),
    MARKET_STOP_PROFIT_LOSS_CLOSE_OUT(5, "止盈止损平仓"),
    MARKET_FOLLOW_IN_THE_POSITION(6, "跟随持仓中"),
    MARKET_FOLLOW_CLOSE_OUT(7, "跟随平仓");

    ContractOrderStatus(int number, String description) {
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
