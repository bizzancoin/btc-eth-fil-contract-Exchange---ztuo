package com.bizzan.bitrade.consumer;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.engine.ContractCoinMatch;
import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.entity.ContractOrderEntrust;
import com.bizzan.bitrade.handler.MongoMarketHandler;
import com.bizzan.bitrade.handler.NettyHandler;
import com.bizzan.bitrade.handler.WebsocketMarketHandler;
import com.bizzan.bitrade.job.ExchangePushJob;
import com.bizzan.bitrade.job.KLineSyncJob;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.WebSocketConnectionManage;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.List;

@Slf4j
@Component
public class MatchConsumer {
    @Autowired
    private KafkaTemplate<String,String> kafkaTemplate;

    @Autowired
    private ContractCoinMatchFactory contractCoinMatchFactory; // 合约引擎工厂

    @Autowired
    private ContractCoinService contractCoinService;

    @Autowired
    private ContractMarketService marketService;

    @Autowired
    private ExchangePushJob exchangePushJob;

    @Autowired
    private ContractOrderEntrustService contractOrderEntrusdtService;

    @Autowired
    private MemberTransactionService memberTransactionService;
    @Autowired
    private MemberContractWalletService memberContractWalletService;


    @Autowired
    MongoMarketHandler mongoMarketHandler;

    @Autowired
    WebsocketMarketHandler wsHandler;

    @Autowired
    NettyHandler nettyHandler;

    /**
     * 开仓
     * @param records
     */
    @KafkaListener(topics = "swap-order-open",containerFactory = "kafkaListenerContainerFactory")
    public void onOrderOpenSubmitted(List<ConsumerRecord<String, String>> records){
        for (int i = 0; i < records.size(); i++) {
            ConsumerRecord<String, String> record = records.get(i);
            log.info("【开仓订单】接收订单>>topic={},value={},size={}", record.topic(), record.value(), records.size());
            ContractOrderEntrust order = JSON.parseObject(record.value(), ContractOrderEntrust.class);
            if (order == null) {
                log.info("开仓订单转化失败");
                return;
            }
            // 加入处理引擎
            try {
                contractCoinMatchFactory.getContractCoinMatch(order.getSymbol()).trade(order);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 平仓
     * @param records
     */
    @KafkaListener(topics = "swap-order-close",containerFactory = "kafkaListenerContainerFactory")
    public void onOrderCloseSubmitted(List<ConsumerRecord<String, String>> records){
        for (int i = 0; i < records.size(); i++) {
            ConsumerRecord<String, String> record = records.get(i);
            log.info("【平仓订单】接收订单>>topic={},value={},size={}", record.topic(), record.value(), records.size());
            ContractOrderEntrust order = JSON.parseObject(record.value(), ContractOrderEntrust.class);
            if (order == null) {
                log.info("平仓订单转化失败");
                return;
            }
            // 加入处理引擎
            try {
                contractCoinMatchFactory.getContractCoinMatch(order.getSymbol()).trade(order);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 撤销委托
     * @param records
     */
    @KafkaListener(topics = "swap-order-cancel",containerFactory = "kafkaListenerContainerFactory")
    public void onOrderEntrustCancel(List<ConsumerRecord<String, String>> records){
        for (int i = 0; i < records.size(); i++) {
            ConsumerRecord<String, String> record = records.get(i);
            log.info("【撤销订单】接收订单>>topic={},value={},size={}", record.topic(), record.value(), records.size());
            ContractOrderEntrust order = JSON.parseObject(record.value(), ContractOrderEntrust.class);
            if (order == null) {
                log.info("取消订单转化失败");
                return;
            }
            // 加入处理引擎
            contractCoinMatchFactory.getContractCoinMatch(order.getSymbol()).cancelContractOrderEntrust(order, false);
        }
    }

    /**
     * 更新合约交易对信息
     * @param content
     */
    @KafkaListener(topics = {"update-contract-coin"})
    public void onUpdateContractCoin(String content) {
        if (StringUtils.isEmpty(content)) {
            return;
        }
        JSONObject json = JSON.parseObject(content);
        if (json == null) {
            return;
        }
        Long contractCoinId = json.getLong("cid");

        ContractCoin coin = contractCoinService.findOne(contractCoinId);
        if(coin != null) {
            contractCoinMatchFactory.getContractCoinMatch(coin.getSymbol()).updateContractCoin(coin);
        }
    }

    /**
     * 新增合约交易对
     * @param content
     */
    @KafkaListener(topics = {"add-contract-coin"})
    public void onAddContractCoin(String content) {
        if (StringUtils.isEmpty(content)) {
            return;
        }
        JSONObject json = JSON.parseObject(content);
        if (json == null) {
            return;
        }
        Long contractCoinId = json.getLong("id");

        ContractCoin coin = contractCoinService.findOne(contractCoinId);
        if(coin != null) {
            // 添加引擎
            ContractCoinMatch match = new ContractCoinMatch(coin.getSymbol());
            match.setContractCoinService(contractCoinService);
            match.setContractOrderEntrustService(contractOrderEntrusdtService);
            match.setMemberTransactionService(memberTransactionService);
            match.setMemberContractWalletService(memberContractWalletService);
            match.addHandler(mongoMarketHandler);
            match.addHandler(wsHandler);
            match.addHandler(nettyHandler);
            match.setExchangePushJob(exchangePushJob);
            match.run();
            contractCoinMatchFactory.addContractCoinMatch(coin.getSymbol(), match);

            // 行情同步
            WebSocketConnectionManage.getWebSocket().subNewCoin(coin.getSymbol());
        }
    }

    /**
     * 定向爆仓。。。大坏蛋
     * 提供一个交易对符号，提供一个价格
     * @param content
     */
    @KafkaListener(topics = {"swap-blast"})
    public void triggerPrice(String content) {
        if (StringUtils.isEmpty(content)) {
            return;
        }
        JSONObject json = JSON.parseObject(content);
        if (json == null) {
            return;
        }
        String symbol = json.getString("symbol");
        BigDecimal price = json.getBigDecimal("price");
        contractCoinMatchFactory.getContractCoinMatch(symbol).refreshBlastPrice(price);
    }

}
