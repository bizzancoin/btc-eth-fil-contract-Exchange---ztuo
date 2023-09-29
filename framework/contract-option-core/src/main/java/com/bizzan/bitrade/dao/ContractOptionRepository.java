package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.entity.ContractOption;
import com.bizzan.bitrade.entity.ContractOptionCoin;
import com.bizzan.bitrade.entity.ContractOptionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ContractOptionRepository extends JpaRepository<ContractOption, Long>, JpaSpecificationExecutor<ContractOption>, QueryDslPredicateExecutor<ContractOption> {
    List<ContractOption> findBySymbolAndStatus(String symbol, ContractOptionStatus status);

    ContractOption findBySymbolAndOptionNo(String symbol, int perOptionNo);
//
//    ContractOption findBySymbol(String symbol);
//
//    @Query("select distinct a.baseSymbol from  ContractOptionCoin a where a.enable = 1")
//    List<String> findBaseSymbol();
//
//    @Query("select distinct a.coinSymbol from  ContractOptionCoin a where a.enable = 1 and a.baseSymbol = :baseSymbol")
//    List<String> findCoinSymbol(@Param("baseSymbol") String baseSymbol);
//
//    @Query("select distinct a.coinSymbol from  ContractOptionCoin a where a.enable = 1")
//    List<String> findAllCoinSymbol();
}
