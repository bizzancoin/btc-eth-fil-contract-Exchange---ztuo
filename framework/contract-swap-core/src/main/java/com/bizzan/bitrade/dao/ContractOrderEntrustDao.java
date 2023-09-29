package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.ContractOrderEntrust;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

public interface ContractOrderEntrustDao extends BaseDao<ContractOrderEntrust> {


    /**
     * 修改返佣状态
     *
     * @param id
     * @param isReward
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractOrderEntrust o set o.isReward = :isReward where o.id = :id")
    int updateReward(@Param("id") long id, @Param("isReward") int isReward);


    /**
     * 空仓保证金清零，空仓可用仓位清零，空仓冻结仓位清零
     * @param walletId
     */
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update MemberContractWallet wallet set wallet.usdtSellPrincipalAmount=0,wallet.usdtFrozenSellPosition=0,wallet.usdtSellPosition=0 where wallet.id = :walletId")
    void blastSell(@Param("walletId") Long walletId);


}
