package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.entity.ContractOrderEntrust;
import com.bizzan.bitrade.entity.ContractOrderEntrustStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ContractOrderEntrustRepository extends JpaRepository<ContractOrderEntrust, Long>, JpaSpecificationExecutor<ContractOrderEntrust>, QueryDslPredicateExecutor<ContractOrderEntrust> {
    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractOrderEntrust contract set contract.status = :status where contract.id = :eid")
    void updateStatus(@Param("eid") Long eid, @Param("status") ContractOrderEntrustStatus status);

    /**
     * 查询委托中的订单
     * @return
     */
    @Query("select a from  ContractOrderEntrust a where a.status = 0")
    List<ContractOrderEntrust> findAllNeedMatch();

    @Query("select a from  ContractOrderEntrust a where a.status = 0 and a.contractId = :contractId")
    List<ContractOrderEntrust> loadUnMatchOrders(@Param("contractId") Long contractId);

    @Query("select a from  ContractOrderEntrust a where a.status = 0 and a.contractId = :contractId and a.memberId = :memberId")
    List<ContractOrderEntrust> findAllByMemberIdAndContractId(long memberId, Long contractCoinId);
}
