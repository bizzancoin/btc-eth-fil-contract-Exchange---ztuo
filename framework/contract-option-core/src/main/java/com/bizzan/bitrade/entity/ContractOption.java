package com.bizzan.bitrade.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * 期权合约每一期
 */
@Entity
@Data
public class ContractOption {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    @Column(columnDefinition = "int(11) default 0 comment '合约序号'")
    private int optionNo; // 合约序号（如第1期，第2期，第3期 中的 1，2，3）

    private String symbol;//交易币种名称，格式：BTC/USDT

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开盘价格'")
    private BigDecimal openPrice;// 开盘价格
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long openTime;//开盘时间

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '收盘价格'")
    private BigDecimal closePrice;// 收盘价格
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long closeTime;// 收盘时间

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '买涨奖池总金额'")
    private BigDecimal totalBuy;// 买涨奖池总金额

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '买涨奖池总金额'")
    private BigDecimal initBuy;// 初始化金额

    @Column(columnDefinition = "int(11) default 0 comment '买涨人数'")
    private int totalBuyCount;// 买涨人数

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '买跌奖池总金额'")
    private BigDecimal totalSell;// 买跌奖池总金额

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '买涨奖池总金额'")
    private BigDecimal initSell;// 初始化卖金额

    @Column(columnDefinition = "int(11) default 0 comment '买涨人数'")
    private int totalSellCount;// 买跌人数

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(4) default 1 comment '本期合约状态'")
    private ContractOptionStatus status; // 0投注中 1开奖中  2开奖结束 3撤销

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(4) default 1 comment '当局结果'")
    private ContractOptionResult result; // 0待开奖 1涨  2跌  3平 4撤销

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '买涨奖池总金额'")
    private BigDecimal totalPl;// 平台盈利（如平局、手续费等）

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long createTime;//创建时间

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '预设收盘价格'")
    private BigDecimal presetPrice;
}
