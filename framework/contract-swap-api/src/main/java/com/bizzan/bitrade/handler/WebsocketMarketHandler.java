package com.bizzan.bitrade.handler;

import com.bizzan.bitrade.entity.CoinThumb;
import com.bizzan.bitrade.entity.ContractTrade;
import com.bizzan.bitrade.entity.KLine;
import com.bizzan.bitrade.job.ExchangePushJob;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
public class WebsocketMarketHandler implements MarketHandler{
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private ExchangePushJob pushJob;

    /**
     * 推送币种简化信息
     * @param symbol
     * @param thumb
     */
    @Override
    public void handleTrade(String symbol, CoinThumb thumb) {
        //推送缩略行情
        pushJob.addThumb(symbol,thumb);
    }

    @Override
    public void handleTrades(String symbol, List<ContractTrade> contractTrades, CoinThumb thumb) {

    }

    @Override
    public void handleKLine(String symbol, KLine kLine) {
        //推送K线数据
        messagingTemplate.convertAndSend("/topic/swap/kline/"+symbol,kLine);
    }
}
