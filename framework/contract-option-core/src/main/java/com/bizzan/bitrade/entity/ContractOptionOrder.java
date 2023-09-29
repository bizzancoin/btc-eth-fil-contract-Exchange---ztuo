package com.bizzan.bitrade.entity;

import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Data
public class ContractOptionOrder implements Serializable {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    /**
     * 期权合约ID
     */
    private Long optionId;

    @Column(columnDefinition = "int(11) default 0 comment '合约序号'")
    private int optionNo; // 合约序号（如第1期，第2期，第3期 中的 1，2，3）

    private Long memberId; // 用户ID

    private String symbol;//交易对符号
    private String coinSymbol;//币单位
    private String baseSymbol;//结算单位

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(4) default 1 comment '方向'")
    private ContractOptionOrderDirection direction; // 0看涨 1看跌

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(4) default 1 comment '订单状态'")
    private ContractOptionOrderStatus status; // 0参与中  1已开奖

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(4) default 1 comment '参与结果'")
    private ContractOptionOrderResult result; // 0待开始  1胜利  2失败  3平局

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '手续费'")
    private BigDecimal fee;// 手续费（当局结束时收取，开盘不收取且平局不收取，该部分金额需要先冻结）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '抽水'")
    private BigDecimal winFee;// 抽水

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '投注金额'")
    private BigDecimal betAmount; // 投注金额（胜利返还，失败扣除，平局退回）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '胜利奖金'")
    private BigDecimal rewardAmount; // 获奖金额（根据投注金额占总投注金额的比例，瓜分对向奖池）

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long createTime;//创建时间

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }
}
