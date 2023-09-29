package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.entity.ContractOptionOrder;
import com.bizzan.bitrade.entity.ContractOptionOrderDirection;
import com.bizzan.bitrade.entity.ContractOptionOrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.query.Param;

import javax.transaction.Transactional;
import java.util.List;

public interface ContractOptionOrderRepository extends JpaRepository<ContractOptionOrder, String>, JpaSpecificationExecutor<ContractOptionOrder>, QueryDslPredicateExecutor<ContractOptionOrder> {
    @Modifying
    @Query("update ContractOptionOrder contract set contract.status = :status where contract.id = :contractOptionOrderId")
    int updateStatus(@Param("contractOptionOrderId") String contractOptionOrderId, @Param("status") ContractOptionOrderStatus status);

    List<ContractOptionOrder> findByMemberIdAndOptionId(Long memberId, Long optionId);

    List<ContractOptionOrder> findByOptionId(Long optionId);

    List<ContractOptionOrder> findByMemberId(Long memberId);

    @Query("SELECT contract FROM ContractOptionOrder contract WHERE contract.memberId = :memberId and optionNo = :optionNo")
    ContractOptionOrder findByMemberIdOptionNo(@Param("memberId") Long memberId,@Param("optionNo") Integer optionNo);

    @Modifying
    @Transactional
    @Query("update ContractOptionOrder contract set contract.optionNo = :optionNo,contract.optionId = :optionId,contract.direction = :direction where contract.id = :id")
    void setOptionNoDirection(@Param("id") Long id,@Param("optionNo") int optionNo,@Param("optionId") Long optionId,@Param("direction") ContractOptionOrderDirection direction);
}
