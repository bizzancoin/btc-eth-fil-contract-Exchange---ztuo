package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * 用户合约交易对表
 */
@Entity
@Data
@Table(uniqueConstraints ={@UniqueConstraint(columnNames={"memberId", "contract_id"})})
public class MemberContractWallet {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    private Long memberId;

    @ManyToOne
    @JoinColumn(name = "contract_id")
    private ContractCoin contractCoin;

    /**
     * 金本位合约账户
     */
    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment 'USDT余额'")
    private BigDecimal usdtBalance;// USDT余额（金本位用）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '冻结余额'")
    private BigDecimal usdtFrozenBalance; // 冻结保证金（金本位用）

    @Column(columnDefinition = "int(4) default 1 comment '金本位仓位模式'")
    private ContractOrderPattern usdtPattern; // 1逐仓 2全仓

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '做多合约倍数'")
    private BigDecimal usdtBuyLeverage;// 做多合约倍数（金本位））

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '做空合约倍数'")
    private BigDecimal usdtSellLeverage;// 做空合约倍数（金本位）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开多仓位'")
    private BigDecimal usdtBuyPosition;// 开多仓位(USDT本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开多仓位'")
    private BigDecimal usdtFrozenBuyPosition;// 冻结仓位(USDT本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '多仓均价'")
    private BigDecimal usdtBuyPrice;// 多仓均价(USDT本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '多仓保证金'")
    private BigDecimal usdtBuyPrincipalAmount;// 多仓保证金(USDT本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal usdtSellPosition;// 开空仓位(USDT本位,多少张)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal usdtFrozenSellPosition;// 冻结仓位(USDT本位,多少张)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal usdtShareNumber;// 合约面值(USDT本位,1张=多少USDT)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '空仓均价'")
    private BigDecimal usdtSellPrice;// 空仓开仓均价(USDT本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '空仓保证金'")
    private BigDecimal usdtSellPrincipalAmount;// 空仓保证金(USDT本位)

    // 用户总盈亏 = usdtProfit + usdtLoss
    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment 'USDT盈利'")
    private BigDecimal usdtProfit;// 盈利

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment 'USDT亏损'")
    private BigDecimal usdtLoss;// 亏损

    /**
     * 币本位合约账户
     */
    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '币种余额'")
    private BigDecimal coinBalance;// 币种余额（币本位用）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '冻结余额'")
    private BigDecimal coinFrozenBalance;

    @Column(columnDefinition = "int(4) default 1 comment '币本位仓位模式'")
    private ContractOrderPattern coinPattern; // 1逐仓 2全仓

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '做多合约倍数'")
    private BigDecimal coinBuyLeverage;// 做多合约倍数（币本位））

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '做空合约倍数'")
    private BigDecimal coinSellLeverage;// 做空合约倍数（币本位）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开多仓位'")
    private BigDecimal coinBuyPosition;// 开多仓位(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开多仓位'")
    private BigDecimal coinFrozenBuyPosition;// 冻结仓位(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '多仓均价'")
    private BigDecimal coinBuyPrice;// 多仓均价(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '多仓保证金'")
    private BigDecimal coinBuyPrincipalAmount;// 多仓保证金(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal coinSellPosition;// 开空仓位(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal coinFrozenSellPosition;// 冻结仓位(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开空仓位'")
    private BigDecimal coinShareNumber;// 合约面值(币本位，一张=多少Coin)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '空仓均价'")
    private BigDecimal coinSellPrice;// 空仓均价(币本位)

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '空仓保证金'")
    private BigDecimal coinSellPrincipalAmount;// 空仓保证金(币本位)

    @Transient
    private BigDecimal usdtTotalProfitAndLoss = BigDecimal.ZERO; // 持仓合约权益（空 + 多）

    @Transient
    private BigDecimal coinTotalProfitAndLoss = BigDecimal.ZERO; // 持仓合约权益（空 + 多）

    @Transient
    private BigDecimal currentPrice;

    @Transient
    private BigDecimal cnyRate = BigDecimal.valueOf(7L);

}
