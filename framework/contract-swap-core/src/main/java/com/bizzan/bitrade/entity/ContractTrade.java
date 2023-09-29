package com.bizzan.bitrade.entity;

import com.alibaba.fastjson.JSON;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class ContractTrade implements Serializable {
    private String symbol;
    private BigDecimal price;
    private BigDecimal amount;
    private BigDecimal buyTurnover;
    private BigDecimal sellTurnover;
    private ContractOrderDirection direction;
    private String buyOrderId;
    private String sellOrderId;
    private Long time;
    @Override
    public String toString() {
        return  JSON.toJSONString(this);
    }
}