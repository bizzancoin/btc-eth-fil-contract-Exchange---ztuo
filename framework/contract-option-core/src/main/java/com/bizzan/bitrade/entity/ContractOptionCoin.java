package com.bizzan.bitrade.entity;

import com.bizzan.bitrade.constant.BooleanEnum;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Data
public class ContractOptionCoin {

    @NotNull(message = "交易对不能为空")
    @Id
    private String symbol;//交易币种名称，格式：BTC/USDT
    private String name; // 合约名称（如：BTC/USDT永续合约）
    private String coinSymbol;//交易币种符号，如BTC
    private String baseSymbol;//结算币种符号，如USDT

    @Column(columnDefinition = "int(11) default 0 comment '最新期号'")
    private int maxOptionNo;//最新期号

    @Column(columnDefinition = "int(11) default 0 comment '排序'")
    private int sort;//排序，从小到大
    @Column(columnDefinition = "int(11) default 4 comment '交易币小数精度'")
    private int coinScale;//交易币小数精度
    @Column(columnDefinition = "int(11) default 4 comment '基币小数精度'")
    private int baseCoinScale;//基币小数精度

    @Column(columnDefinition = "int(2) default 1 comment '状态'")
    private int enable;//状态：1启用 2禁止

    @Column(columnDefinition = "int(2) default 1 comment '前台可见状态'")
    private int visible;//前台可见状态，1：可见，2：不可见

    @Column(columnDefinition = "int(2) default 1 comment '平局处理方式'")
    private int tiedType;//状态：1退回资金 2平台通吃

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(2) default 1 comment '是否允许看涨'")
    private BooleanEnum enableBuy = BooleanEnum.IS_TRUE;

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(2) default 1 comment '是否允许看跌'")
    private BooleanEnum  enableSell = BooleanEnum.IS_TRUE;

    private String amount = "10,20,50,100,200,500,1000,2000";// 允许投注数(默认：10,20,50,100,200,500,1000,2000)

    @Column(columnDefinition = "decimal(8,4) DEFAULT 1 comment '赔率'")
    private BigDecimal oods;// 赔率(默认1)

    @Column(columnDefinition = "decimal(8,4) DEFAULT 0 comment '开仓手续费'")
    private BigDecimal feePercent;// 开仓手续费(默认0)

    @Column(columnDefinition = "decimal(8,4) DEFAULT 0.001 comment '赢家手续费'")
    private BigDecimal winFeePercent;// 赢家手续费(默认千分之一)

    @Column(columnDefinition = "decimal(8,4) DEFAULT 0.0001 comment '忽视涨跌幅度'")
    private BigDecimal ngnorePercent;// 忽视涨跌幅度（如设置为0.005，则涨跌幅度小于0.5%的会被视为平局）

    @Column(columnDefinition = "decimal(8,4) DEFAULT 0 comment '初始买涨奖池金额'")
    private BigDecimal initBuyReward;// 初始买涨奖池金额


    @Column(columnDefinition = "decimal(8,4) DEFAULT 0 comment '初始买跌奖池金额'")
    private BigDecimal initSellReward;// 初始买跌奖池金额

    @Column(columnDefinition = "decimal(8,4) DEFAULT 0 comment '期权合约总盈利'")
    private BigDecimal totalProfit;// 期权合约总盈利

    @Column(columnDefinition = "int(11) default 300 comment '开始到开盘时间间隔'")
    private int openTimeGap;// 开始到开盘时间间隔（单位：秒， 默认5分钟）

    @Column(columnDefinition = "int(11) default 300 comment '开盘到收盘时间间隔'")
    private int closeTimeGap;// 开盘到收盘时间间隔（单位：秒， 默认5分钟）

    // openTimeGap + closeTimeGap就是一期期权合约的总时间周期
    // 默认为：一期开始后，5分钟内下单，然后停止下单，再等待5分钟出结果。出结果期间不允许下单。

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;//创建时间

    /**
     * 服务器当前市价戳
     */
    @Transient
    private Long currentTime;
}
