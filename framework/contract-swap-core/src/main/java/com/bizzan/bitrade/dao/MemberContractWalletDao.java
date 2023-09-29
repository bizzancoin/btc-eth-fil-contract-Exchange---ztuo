package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.entity.MemberContractWallet;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

public interface MemberContractWalletDao extends BaseDao<MemberContractWallet> {

    /**
     * 根据用户ID和合约ID查询钱包记录
     * @param memberId
     * @param contractCoin
     * @return
     */
    MemberContractWallet findByMemberIdAndContractCoin(Long memberId, ContractCoin contractCoin);

    /**
     * 增加钱包余额
     *
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance = wallet.usdtBalance + :amount where wallet.id = :walletId")
    int increaseUsdtBalance(@Param("walletId") long walletId, @Param("amount") BigDecimal amount);

    /**
     * 减少钱包余额
     *
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance = wallet.usdtBalance - :amount where wallet.id = :walletId and wallet.usdtBalance >= :amount")
    int decreaseUsdtBalance(@Param("walletId") long walletId, @Param("amount") BigDecimal amount);

    /**
     * 冻结钱包余额
     *
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance = wallet.usdtBalance - :amount,wallet.usdtFrozenBalance=wallet.usdtFrozenBalance + :amount where wallet.id = :walletId and wallet.usdtBalance >= :amount")
    int freezeUsdtBalance(@Param("walletId") long walletId, @Param("amount") BigDecimal amount);

    /**
     * 解冻钱包余额
     *
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance = wallet.usdtBalance + :amount,wallet.usdtFrozenBalance=wallet.usdtFrozenBalance - :amount where wallet.id = :walletId and wallet.usdtFrozenBalance >= :amount")
    int thawUsdtBalance(@Param("walletId") long walletId, @Param("amount") BigDecimal amount);

    /**
     * 减少冻结余额
     *
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenBalance=wallet.usdtFrozenBalance - :amount where wallet.id = :walletId and wallet.usdtFrozenBalance >= :amount")
    int decreaseUsdtFrozen(@Param("walletId") long walletId, @Param("amount") BigDecimal amount);

    /**
     * 增加冻结资产
     * @param walletId
     * @param amount
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenBalance=wallet.usdtFrozenBalance + :amount where wallet.id = :walletId")
    int increaseUsdtFrozen(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    List<MemberContractWallet> findAllByMemberId(Long id);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount + :amount,wallet.usdtBalance=wallet.usdtBalance - :amount where wallet.id = :walletId and wallet.usdtBalance >= :amount")
    void increaseUsdtBuyPrincipalAmount(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount + :amount,wallet.usdtBalance=wallet.usdtBalance - :amount where wallet.id = :walletId and wallet.usdtBalance >= :amount")
    void increaseUsdtSellPrincipalAmount(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance=wallet.usdtBalance + :amount,wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount - :amount where wallet.id = :walletId and wallet.usdtBuyPrincipalAmount >= :amount")
    void decreaseUsdtBuyPrincipalAmount(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBalance=wallet.usdtBalance + :amount,wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount - :amount where wallet.id = :walletId and wallet.usdtSellPrincipalAmount >= :amount")
    void decreaseUsdtSellPrincipalAmount(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount - :amount where wallet.id = :walletId and wallet.usdtBuyPrincipalAmount >= :amount")
    void decreaseUsdtBuyPrincipalAmountWithoutBalance(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount - :amount where wallet.id = :walletId and wallet.usdtSellPrincipalAmount >= :amount")
    void decreaseUsdtSellPrincipalAmountWithoutBalance(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrice=:avaPrice,wallet.usdtBuyPosition=wallet.usdtBuyPosition + :volume where wallet.id = :walletId")
    void updateUsdtBuyPriceAndPosition(@Param("walletId") Long walletId, @Param("avaPrice") BigDecimal avaPrice, @Param("volume") BigDecimal volume);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrice=:avaPrice,wallet.usdtSellPosition=wallet.usdtSellPosition + :volume where wallet.id = :walletId")
    void updateUsdtSellPriceAndPosition(@Param("walletId") Long walletId, @Param("avaPrice") BigDecimal avaPrice, @Param("volume") BigDecimal volume);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount - :pAmount,wallet.usdtSellPosition=wallet.usdtSellPosition - :volume where wallet.id = :walletId and wallet.usdtSellPrincipalAmount>=:pAmount and wallet.usdtSellPosition>=:volume")
    void decreaseUsdtSellPositionAndPrincipalAmount(@Param("walletId") Long walletId, @Param("volume") BigDecimal volume, @Param("pAmount") BigDecimal pAmount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount - :pAmount,wallet.usdtBuyPosition=wallet.usdtBuyPosition - :volume where wallet.id = :walletId and wallet.usdtBuyPrincipalAmount>=:pAmount and wallet.usdtBuyPosition>=:volume")
    void decreaseUsdtBuyPositionAndPrincipalAmount(@Param("walletId") Long walletId, @Param("volume") BigDecimal volume, @Param("pAmount") BigDecimal pAmount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenSellPosition = wallet.usdtFrozenSellPosition + :amount,wallet.usdtSellPosition=wallet.usdtSellPosition - :amount where wallet.id = :walletId and wallet.usdtSellPosition >= :amount")
    void freezeUsdtSellPosition(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenSellPosition = wallet.usdtFrozenSellPosition - :amount,wallet.usdtSellPosition=wallet.usdtSellPosition + :amount where wallet.id = :walletId and wallet.usdtFrozenSellPosition >= :amount")
    void thrawUsdtSellPosition(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenBuyPosition = wallet.usdtFrozenBuyPosition + :amount,wallet.usdtBuyPosition=wallet.usdtBuyPosition - :amount where wallet.id = :walletId and wallet.usdtBuyPosition >= :amount")
    void freezeUsdtBuyPosition(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtFrozenBuyPosition = wallet.usdtFrozenBuyPosition - :amount,wallet.usdtBuyPosition=wallet.usdtBuyPosition + :amount where wallet.id = :walletId and wallet.usdtFrozenBuyPosition >= :amount")
    void thrawUsdtBuyPosition(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyLeverage = :leverage where wallet.id = :walletId")
    void modifyUsdtBuyLeverage(@Param("walletId") Long walletId, @Param("leverage") BigDecimal leverage);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellLeverage = :leverage where wallet.id = :walletId")
    void modifyUsdtSellLeverage(@Param("walletId") Long walletId, @Param("leverage") BigDecimal leverage);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount + :amount,wallet.usdtFrozenBalance=wallet.usdtFrozenBalance - :amount where wallet.id = :walletId and wallet.usdtFrozenBalance >= :amount")
    void increaseUsdtBuyPrincipalAmountWithFrozen(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount + :amount,wallet.usdtFrozenBalance=wallet.usdtFrozenBalance - :amount where wallet.id = :walletId and wallet.usdtFrozenBalance >= :amount")
    void increaseUsdtSellPrincipalAmountWithFrozen(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=wallet.usdtSellPrincipalAmount - :pAmount,wallet.usdtFrozenSellPosition=wallet.usdtFrozenSellPosition - :volume where wallet.id = :walletId and wallet.usdtSellPrincipalAmount>=:pAmount and wallet.usdtFrozenSellPosition>=:volume")
    void decreaseUsdtFrozenSellPositionAndPrincipalAmount(@Param("walletId") Long walletId, @Param("volume") BigDecimal volume, @Param("pAmount") BigDecimal pAmount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=wallet.usdtBuyPrincipalAmount - :pAmount,wallet.usdtFrozenBuyPosition=wallet.usdtFrozenBuyPosition - :volume where wallet.id = :walletId and wallet.usdtBuyPrincipalAmount>=:pAmount and wallet.usdtFrozenBuyPosition>=:volume")
    void decreaseUsdtFrozenBuyPositionAndPrincipalAmount(@Param("walletId") Long walletId, @Param("volume") BigDecimal volume, @Param("pAmount") BigDecimal pAmount);

    @Query(value = "select * from member_contract_wallet as wallet where (wallet.usdt_buy_position > 0 or wallet.usdt_sell_position > 0 or wallet.usdt_frozen_buy_position > 0 or wallet.usdt_frozen_sell_position > 0) and wallet.contract_id=:contractId", nativeQuery = true)
    List<MemberContractWallet> findAllNeedSync(@Param("contractId") Long contractId);

    /**
     * 多仓保证金清零，多仓可用仓位清零，多仓冻结仓位清零
     * @param walletId
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtBuyPrincipalAmount=0,wallet.usdtFrozenBuyPosition=0,wallet.usdtBuyPosition=0 where wallet.id = :walletId")
    void blastBuy(@Param("walletId") Long walletId);

    /**
     * 空仓保证金清零，空仓可用仓位清零，空仓冻结仓位清零
     * @param walletId
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=0,wallet.usdtFrozenSellPosition=0,wallet.usdtSellPosition=0 where wallet.id = :walletId")
    void blastSell(@Param("walletId") Long walletId);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtShareNumber=:shareNumber where wallet.id = :walletId")
    void updateShareNumber(@Param("walletId") Long walletId, @Param("shareNumber") BigDecimal shareNumber);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtProfit=wallet.usdtProfit+:amount where wallet.id = :walletId")
    void increaseUsdtProfit(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtLoss=wallet.usdtLoss+:amount where wallet.id = :walletId")
    void increaseUsdtLoss(@Param("walletId") Long walletId, @Param("amount") BigDecimal amount);

    //合约调整倍率
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellLeverage = :leverage ,wallet.usdtBuyLeverage= :leverage  where wallet.id = :walletId")
    void updateUsdtBuyAndSellLeverage(@Param("walletId") Long walletId, @Param("leverage") BigDecimal leverage);

}
