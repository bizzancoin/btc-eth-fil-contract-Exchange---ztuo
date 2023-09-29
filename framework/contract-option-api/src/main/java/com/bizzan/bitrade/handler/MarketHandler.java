package com.bizzan.bitrade.handler;

import com.bizzan.bitrade.entity.CoinThumb;
import com.bizzan.bitrade.entity.KLine;

public interface MarketHandler {

    /**
     * 存储交易信息
     */
    void handleTrade(String symbol, CoinThumb thumb);


    /**
     * 存储K线信息
     *
     * @param kLine
     */
    void handleKLine(String symbol, KLine kLine);
}
