package com.bizzan.bitrade.config;

import com.bizzan.bitrade.client.Client;
import com.bizzan.bitrade.engine.ContractCoinMatch;
import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.handler.MongoMarketHandler;
import com.bizzan.bitrade.handler.NettyHandler;
import com.bizzan.bitrade.handler.WebsocketMarketHandler;
import com.bizzan.bitrade.job.ExchangePushJob;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.socket.client.WsClientHuobi;
import com.bizzan.bitrade.util.WebSocketConnectionManage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ContractCoinMatchStarter implements ApplicationListener<ContextRefreshedEvent> {

    private Logger log = LoggerFactory.getLogger(ContractCoinMatchStarter.class);

    @Autowired
    private Client client;

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

    @Autowired
    private ContractCoinMatchFactory factory;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {

        log.info("=================== 合约应用启动初始化 ===================");
        List<ContractCoin> contractCoinList = contractCoinService.findAllEnabled();

        for(ContractCoin coin : contractCoinList) {
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
            factory.addContractCoinMatch(coin.getSymbol(), match);
        }

        log.info("========== 交易对数量：{}", factory.getMatchMap().size());

        // 设置WebSocket
        WebSocketConnectionManage.setClient(client);

        WsClientHuobi w = new WsClientHuobi(factory);
        w.setContractCoinService(contractCoinService);
        w.setContractMarketService(marketService);
        w.setExchangePushJob(exchangePushJob);
        w.run();
    }
}
