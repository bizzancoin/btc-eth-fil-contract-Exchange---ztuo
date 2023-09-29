package com.bizzan.bitrade.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Data
public class MemberContractWalletVo implements Serializable {
    private Long id;
    private Long memberId;
    private String coinId;

    private BigDecimal usdtBalance;// USDT余额（金本位用）
    private BigDecimal usdtFrozenBalance; // 冻结保证金（金本位用）

    private BigDecimal usdtTotalProfitAndLoss;
    private BigDecimal usdtRate = BigDecimal.valueOf(6.42);
    private BigDecimal usdtBuyPrincipalAmount;// 多仓保证金(USDT本位)
    private BigDecimal usdtSellPrincipalAmount;// 空仓保证金(USDT本位)
    
}