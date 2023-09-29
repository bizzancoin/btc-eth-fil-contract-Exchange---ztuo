package com.bizzan.bitrade.config;

import com.bizzan.bitrade.client.Client;
import com.bizzan.bitrade.engine.ContractOptionCoinMatch;
import com.bizzan.bitrade.engine.ContractOptionCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
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

import java.math.BigDecimal;
import java.util.List;

@Component
public class ContractCoinMatchStarter implements ApplicationListener<ContextRefreshedEvent> {

    private Logger log = LoggerFactory.getLogger(ContractCoinMatchStarter.class);

    @Autowired
    private Client client;

    @Autowired
    private ContractOptionCoinService contractOptionCoinService;

    @Autowired
    private ContractMarketService marketService;

    @Autowired
    private ContractOptionService contractOptionService;

    @Autowired
    private ContractOptionOrderService contractOptionOrderService;

    @Autowired
    private ExchangePushJob exchangePushJob;

    @Autowired
    MongoMarketHandler mongoMarketHandler;

    @Autowired
    WebsocketMarketHandler wsHandler;

    @Autowired
    NettyHandler nettyHandler;

    @Autowired
    private ContractOptionCoinMatchFactory factory;

    @Autowired
    private MemberWalletService walletService;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {

        log.info("=================== 合约应用启动初始化 ===================");
        List<ContractOptionCoin> contractOptionCoinList = contractOptionCoinService.findAllEnabled();

        for (ContractOptionCoin coin : contractOptionCoinList) {
            ContractOptionCoinMatch match = new ContractOptionCoinMatch(coin.getSymbol());
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
        w.setContractOptionCoinService(contractOptionCoinService);
        w.setContractMarketService(marketService);
        w.setExchangePushJob(exchangePushJob);
        w.run();

        // 处理订单，将所有开奖中及投注中的订单全部取消，退回用户资金
        for (int i = 0; i < contractOptionCoinList.size(); i++) {
            // 一、获取正在进行的合约
            List<ContractOption> optionsStarting = contractOptionService.findBySymbolAndStatus(contractOptionCoinList.get(i).getSymbol(), ContractOptionStatus.STARTING);
            for (int j = 0; j < optionsStarting.size(); j++) {
                ContractOption temOption = optionsStarting.get(j);
                temOption.setStatus(ContractOptionStatus.CANCELED); // 已撤销
                temOption.setResult(ContractOptionResult.CANCELED); // 已撤销

                List<ContractOptionOrder> orderList = contractOptionOrderService.findByOptionId(optionsStarting.get(j).getId());
                for (int k = 0; k < orderList.size(); k++) {
                    ContractOptionOrder temOrder = orderList.get(k);
                    MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());

                    walletService.thawBalance(wallet, temOrder.getBetAmount());

                    if (temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) {
                        walletService.thawBalance(wallet, temOrder.getFee());
                    }

                    temOrder.setResult(ContractOptionOrderResult.CANCELED);
                    temOrder.setStatus(ContractOptionOrderStatus.CANCELED);

                    contractOptionOrderService.save(temOrder);
                }
                contractOptionService.save(temOption);
            }

            // 二、获取正在开奖的订单
            List<ContractOption> optionsOpening = contractOptionService.findBySymbolAndStatus(contractOptionCoinList.get(i).getSymbol(), ContractOptionStatus.OPENING);
            for (int j = 0; j < optionsOpening.size(); j++) {
                ContractOption temOption = optionsOpening.get(j);
                temOption.setStatus(ContractOptionStatus.CANCELED); // 已撤销
                temOption.setResult(ContractOptionResult.CANCELED); // 已撤销

                List<ContractOptionOrder> orderList = contractOptionOrderService.findByOptionId(optionsOpening.get(j).getId());
                for (int k = 0; k < orderList.size(); k++) {
                    ContractOptionOrder temOrder = orderList.get(k);
                    MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());

                    walletService.thawBalance(wallet, temOrder.getBetAmount());

                    if (temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) {
                        walletService.thawBalance(wallet, temOrder.getFee());
                    }

                    temOrder.setResult(ContractOptionOrderResult.CANCELED);
                    temOrder.setStatus(ContractOptionOrderStatus.CANCELED);

                    contractOptionOrderService.save(temOrder);
                }
                contractOptionService.save(temOption);
            }
        }
    }
}
