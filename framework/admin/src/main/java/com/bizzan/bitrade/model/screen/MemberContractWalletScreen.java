package com.bizzan.bitrade.model.screen;

import com.bizzan.bitrade.entity.ContractOrderPattern;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class MemberContractWalletScreen {
    private Long contractId;
    private Long memberId;
    private String phone;
    private String email;
    private BigDecimal usdtBalance;
    private BigDecimal usdtFrozenBalance;
    private ContractOrderPattern usdtPattern;
    private BigDecimal usdtBuyLeverage;
    private BigDecimal usdtSellLeverage;
    private BigDecimal usdtBuyPosition;
    private BigDecimal usdtFrozenBuyPosition;
    private BigDecimal usdtBuyPrincipalAmount;
    private BigDecimal usdtSellPosition;
    private BigDecimal usdtFrozenSellPosition;
    private BigDecimal usdtSellPrincipalAmount;
}
