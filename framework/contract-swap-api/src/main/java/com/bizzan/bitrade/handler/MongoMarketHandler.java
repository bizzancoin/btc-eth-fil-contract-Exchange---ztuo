package com.bizzan.bitrade.handler;

import com.bizzan.bitrade.entity.CoinThumb;
import com.bizzan.bitrade.entity.ContractTrade;
import com.bizzan.bitrade.entity.KLine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MongoMarketHandler implements MarketHandler {
    @Autowired
    private MongoTemplate mongoTemplate;

    @Override
    public void handleTrade(String symbol, CoinThumb thumb) {
        // 获取火币的行情，无需存储
    }

    @Override
    public void handleTrades(String symbol, List<ContractTrade> contractTrades, CoinThumb thumb) {
        // 获取火币的行情，无需存储
    }

    @Override
    public void handleKLine(String symbol, KLine kLine) {
        // 获取火币的行情，无需存储
    }
}
