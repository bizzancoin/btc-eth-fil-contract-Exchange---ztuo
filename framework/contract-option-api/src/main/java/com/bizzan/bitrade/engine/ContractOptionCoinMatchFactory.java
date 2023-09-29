package com.bizzan.bitrade.engine;

import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
public class ContractOptionCoinMatchFactory {

    // symbol, match
    private ConcurrentHashMap<String, ContractOptionCoinMatch> matchMap;

    public ContractOptionCoinMatchFactory(){
        this.matchMap = new ConcurrentHashMap<>();
    }

    public void addContractCoinMatch(String symbol, ContractOptionCoinMatch match) {
        log.info("ContractCoinMatchFactory add match = {}", symbol);
        if(!this.containsContractCoinMatch(symbol)) {
            this.matchMap.put(symbol, match);
        }
    }

    public boolean containsContractCoinMatch(String symbol) {
        return this.matchMap != null && this.matchMap.containsKey(symbol);
    }

    public ContractOptionCoinMatch getContractCoinMatch(String symbol) {
        return this.matchMap.get(symbol);
    }

    public Map<String, ContractOptionCoinMatch> getMatchMap() {
        return this.matchMap;
    }
}
