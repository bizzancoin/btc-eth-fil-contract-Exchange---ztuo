package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.entity.ContractRewardRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;

public interface ContractRewardRecordRepository extends JpaRepository<ContractRewardRecord, Long>, JpaSpecificationExecutor<ContractRewardRecord>, QueryDslPredicateExecutor<ContractRewardRecord> {

}
