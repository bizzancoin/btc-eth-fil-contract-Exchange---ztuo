package com.bizzan.bitrade.engine;

import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
public class ContractCoinMatchFactory {

    // symbol, match
    private ConcurrentHashMap<String, ContractCoinMatch> matchMap;

    public ContractCoinMatchFactory(){
        this.matchMap = new ConcurrentHashMap<>();
    }

    public void addContractCoinMatch(String symbol, ContractCoinMatch match) {
        log.info("ContractCoinMatchFactory add match = {}", symbol);
        if(!this.containsContractCoinMatch(symbol)) {
            this.matchMap.put(symbol, match);
        }
    }

    public boolean containsContractCoinMatch(String symbol) {
        return this.matchMap != null && this.matchMap.containsKey(symbol);
    }

    public ContractCoinMatch getContractCoinMatch(String symbol) {
        return this.matchMap.get(symbol);
    }

    public Map<String,ContractCoinMatch > getMatchMap() {
        return this.matchMap;
    }
}
