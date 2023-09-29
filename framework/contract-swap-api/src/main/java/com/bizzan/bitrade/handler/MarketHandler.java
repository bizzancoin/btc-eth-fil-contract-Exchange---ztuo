package com.bizzan.bitrade.handler;

import com.bizzan.bitrade.entity.CoinThumb;
import com.bizzan.bitrade.entity.ContractTrade;
import com.bizzan.bitrade.entity.KLine;
import org.apache.http.annotation.Contract;

import java.util.List;

public interface MarketHandler {

    /**
     * 存储交易信息
     */
    void handleTrade(String symbol, CoinThumb thumb);

    /**
     * 推送交易信息(Netty使用)
     */
    void handleTrades(String symbol, List<ContractTrade> contractTrades, CoinThumb thumb);

    /**
     * 存储K线信息
     *
     * @param kLine
     */
    void handleKLine(String symbol, KLine kLine);
}
