package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractCoinRepository;
import com.bizzan.bitrade.dao.MemberContractWalletDao;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.entity.ContractOrderEntrust;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.MemberContractWallet;
import com.bizzan.bitrade.service.Base.BaseService;
import com.bizzan.bitrade.util.MessageResult;
import com.querydsl.core.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@Slf4j
public class MemberContractWalletService extends BaseService {
    @Autowired
    private MemberContractWalletDao memberContractWalletDao;

    @Autowired
    private ContractCoinRepository contractCoinRepository;

    public MemberContractWallet findOne(Long id) {
        return memberContractWalletDao.findOne(id);
    }

    public MemberContractWallet findByMemberIdAndContractCoin(Long memberId, ContractCoin contractCoin) {
        return memberContractWalletDao.findByMemberIdAndContractCoin(memberId, contractCoin);
    }
    public Page<MemberContractWallet> findAll(Predicate predicate, Pageable pageable) {
        return memberContractWalletDao.findAll(predicate, pageable);
    }
    public MemberContractWallet save(MemberContractWallet memberContractWallet){
        return memberContractWalletDao.saveAndFlush(memberContractWallet);
    }

    public List<MemberContractWallet> findAllByMember(Member member) {
        return memberContractWalletDao.findAllByMemberId(member.getId());
    }

    public List<MemberContractWallet> findAllByMemberId(Long memberId) {
        return memberContractWalletDao.findAllByMemberId(memberId);
    }


    /**
     * 冻结钱包（与余额有关）
     *
     * @param memberWallet
     * @param amount
     * @return
     */
    public MessageResult freezeUsdtBalance(MemberContractWallet memberWallet, BigDecimal amount) {
        int ret = memberContractWalletDao.freezeUsdtBalance(memberWallet.getId(), amount);
        if (ret > 0) {
            return MessageResult.success();
        } else {
            return MessageResult.error("Information Expired");
        }
    }

    /**
     * 解冻钱包（与余额有关）
     *
     * @param memberWallet
     * @param amount
     * @return
     */
    public MessageResult thawUsdtBalance(MemberContractWallet memberWallet, BigDecimal amount) {
        int ret = memberContractWalletDao.thawUsdtBalance(memberWallet.getId(), amount);
        if (ret > 0) {
            return MessageResult.success();
        } else {
            return MessageResult.error("Information Expired");
        }
    }

    /**
     * 增加余额
     * @param walletId
     * @param amount
     */
    public void increaseUsdtBalance(Long walletId, BigDecimal amount){
        memberContractWalletDao.increaseUsdtBalance(walletId,amount);
    }

    /**
     * 减少余额
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtBalance(Long walletId, BigDecimal amount) {
        memberContractWalletDao.decreaseUsdtBalance(walletId, amount);
    }

    /**
     * 增加做多保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void increaseUsdtBuyPrincipalAmount(Long walletId, BigDecimal amount) {
        memberContractWalletDao.increaseUsdtBuyPrincipalAmount(walletId, amount);
    }

    /**
     * 增加做多保证金（与冻结余额有关）
     * @param walletId
     * @param amount
     */
    public void increaseUsdtBuyPrincipalAmountWithFrozen(Long walletId, BigDecimal amount) {
        memberContractWalletDao.increaseUsdtBuyPrincipalAmountWithFrozen(walletId, amount);
    }

    /**
     * 增加做空保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void increaseUsdtSellPrincipalAmount(Long walletId, BigDecimal amount) {
        memberContractWalletDao.increaseUsdtSellPrincipalAmount(walletId, amount);
    }

    /**
     * 增加做空保证金（与冻结余额有关）
     * @param walletId
     * @param amount
     */
    public void increaseUsdtSellPrincipalAmountWithFrozen(Long walletId, BigDecimal amount) {
        memberContractWalletDao.increaseUsdtSellPrincipalAmountWithFrozen(walletId, amount);
    }

    /**
     * 减少做多保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtBuyPrincipalAmount(Long walletId, BigDecimal amount) {
        memberContractWalletDao.decreaseUsdtBuyPrincipalAmount(walletId, amount);
    }

    /**
     * 减少做多保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtBuyPrincipalAmountWithoutBalance(Long walletId, BigDecimal amount) {
        memberContractWalletDao.decreaseUsdtBuyPrincipalAmountWithoutBalance(walletId, amount);
    }

    /**
     * 减少做空保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtSellPrincipalAmount(Long walletId, BigDecimal amount) {
        memberContractWalletDao.decreaseUsdtSellPrincipalAmount(walletId, amount);
    }

    /**
     * 减少做空保证金（与余额有关）
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtSellPrincipalAmountWithoutBalance(Long walletId, BigDecimal amount) {
        memberContractWalletDao.decreaseUsdtSellPrincipalAmountWithoutBalance(walletId, amount);
    }
    /**
     * 增加冻结资产（与余额无关）
     * @param id
     * @param amount
     */
    public void increaseUsdtFrozen(Long id, BigDecimal amount) {
        memberContractWalletDao.increaseUsdtFrozen(id, amount);
    }

    /**
     * 减少冻结资产（与余额无关）
     * @param walletId
     * @param amount
     */
    public void decreaseUsdtFrozen(Long walletId, BigDecimal amount){
        memberContractWalletDao.decreaseUsdtFrozen(walletId,amount);
    }

    /**
     * 更新开仓价格和持仓量（多仓）
     * @param walletId
     * @param avaPrice
     * @param volume
     */
    public void updateUsdtBuyPriceAndPosition(Long walletId, BigDecimal avaPrice, BigDecimal volume) {
        memberContractWalletDao.updateUsdtBuyPriceAndPosition(walletId, avaPrice, volume);
    }

    /**
     * 更新开仓价格和持仓量（空仓）
     * @param walletId
     * @param avaPrice
     * @param volume
     */
    public void updateUsdtSellPriceAndPosition(Long walletId, BigDecimal avaPrice, BigDecimal volume) {
        memberContractWalletDao.updateUsdtSellPriceAndPosition(walletId, avaPrice, volume);
    }

    public void decreaseUsdtSellPositionAndPrincipalAmount(Long walletId, BigDecimal volume, BigDecimal principalAmount) {
        memberContractWalletDao.decreaseUsdtSellPositionAndPrincipalAmount(walletId, volume, principalAmount);
    }

    public void decreaseUsdtFrozenSellPositionAndPrincipalAmount(Long walletId, BigDecimal volume, BigDecimal principalAmount) {
        memberContractWalletDao.decreaseUsdtFrozenSellPositionAndPrincipalAmount(walletId, volume, principalAmount);
    }

    public void decreaseUsdtBuyPositionAndPrincipalAmount(Long walletId, BigDecimal volume, BigDecimal principalAmount) {
        memberContractWalletDao.decreaseUsdtBuyPositionAndPrincipalAmount(walletId, volume, principalAmount);
    }
    public void decreaseUsdtFrozenBuyPositionAndPrincipalAmount(Long walletId, BigDecimal volume, BigDecimal principalAmount) {
        memberContractWalletDao.decreaseUsdtFrozenBuyPositionAndPrincipalAmount(walletId, volume, principalAmount);
    }
    public void freezeUsdtSellPosition(Long walletId, BigDecimal volume) {
        memberContractWalletDao.freezeUsdtSellPosition(walletId, volume);
    }
    public void thrawUsdtSellPosition(Long walletId, BigDecimal volume) {
        memberContractWalletDao.thrawUsdtSellPosition(walletId, volume);
    }
    public void freezeUsdtBuyPosition(Long walletId, BigDecimal volume) {
        memberContractWalletDao.freezeUsdtBuyPosition(walletId, volume);
    }
    public void thrawUsdtBuyPosition(Long walletId, BigDecimal volume) {
        memberContractWalletDao.thrawUsdtBuyPosition(walletId, volume);
    }
    public void modifyUsdtBuyLeverage(Long walletId, BigDecimal leverage) {
        memberContractWalletDao.modifyUsdtBuyLeverage(walletId, leverage);
    }

    public void modifyUsdtSellLeverage(Long walletId, BigDecimal leverage) {
        memberContractWalletDao.modifyUsdtSellLeverage(walletId, leverage);
    }


    public List<MemberContractWallet> findAllNeedSync(ContractCoin contractCoin) {
        return memberContractWalletDao.findAllNeedSync(contractCoin.getId());
    }

    public void blastBuy(Long walletId) {
        memberContractWalletDao.blastBuy(walletId);
    }

    public void blastSell(Long walletId) {
        memberContractWalletDao.blastSell(walletId);
    }

    public void updateShareNumber(Long walletId, BigDecimal shareNumber) {
        memberContractWalletDao.updateShareNumber(walletId, shareNumber);
    }

    public void increaseUsdtProfit(Long walletId, BigDecimal pL) {
        memberContractWalletDao.increaseUsdtProfit(walletId, pL);
    }

    public void increaseUsdtLoss(Long walletId, BigDecimal pL) {
        memberContractWalletDao.increaseUsdtLoss(walletId, pL);
    }

    //合约调整倍率
    public void modifyUsdtBuyAndSellLeverage(Long id, BigDecimal leverage) {
        memberContractWalletDao.updateUsdtBuyAndSellLeverage(id,leverage);
    }
}
