package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.entity.ContractType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

public interface ContractCoinRepository extends JpaRepository<ContractCoin, Long>, JpaSpecificationExecutor<ContractCoin>, QueryDslPredicateExecutor<ContractCoin> {
    ContractCoin findBySymbol(String symbol);

    ContractCoin findBySymbolAndType(String symbol, ContractType type);

    @Query("select distinct a.baseSymbol from  ContractCoin a where a.enable = 1")
    List<String> findBaseSymbol();

    @Query("select distinct a.coinSymbol from  ContractCoin a where a.enable = 1 and a.baseSymbol = :baseSymbol")
    List<String> findCoinSymbol(@Param("baseSymbol")String baseSymbol);

    @Query("select distinct a.coinSymbol from  ContractCoin a where a.enable = 1")
    List<String> findAllCoinSymbol();

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractCoin coin set coin.totalLoss=coin.totalLoss+:amount where coin.id = :cid")
    void increaseTotalLoss(@Param("cid")Long cid, @Param("amount")BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractCoin coin set coin.totalProfit=coin.totalProfit+:amount where coin.id = :cid")
    void increaseTotalProfit(@Param("cid")Long cid, @Param("amount")BigDecimal amount);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractCoin coin set coin.totalOpenFee=coin.totalOpenFee+:openFee where coin.id = :cid")
    void increaseOpenFee(@Param("cid")Long cid, @Param("openFee")BigDecimal openFee);

    @Transactional(rollbackFor = Exception.class)
    @Modifying
    @Query("update ContractCoin coin set coin.totalCloseFee=coin.totalCloseFee+:closeFee where coin.id = :cid")
    void increaseCloseFee(@Param("cid")Long cid, @Param("closeFee")BigDecimal closeFee);

}
