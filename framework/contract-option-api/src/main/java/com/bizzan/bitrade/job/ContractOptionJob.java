package com.bizzan.bitrade.job;


import com.bizzan.bitrade.constant.TransactionType;
import com.bizzan.bitrade.engine.ContractOptionCoinMatch;
import com.bizzan.bitrade.engine.ContractOptionCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.handler.MongoMarketHandler;
import com.bizzan.bitrade.handler.NettyHandler;
import com.bizzan.bitrade.handler.WebsocketMarketHandler;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.WebSocketConnectionManage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 * 生成每一期合约
 * 触发合约状态变更
 * 平分奖池
 */
@Component
public class ContractOptionJob {

    private Logger logger = LoggerFactory.getLogger(ContractOptionJob.class);

    @Autowired
    private ContractOptionCoinService coinService;

    @Autowired
    private ContractOptionService optionService;

    @Autowired
    private ContractOptionOrderService orderService;

    @Autowired
    private MemberWalletService walletService;

    @Autowired
    private MemberTransactionService memberTransactionService;

    @Autowired
    private ContractOptionCoinMatchFactory factory;
    @Autowired
    private ExchangePushJob exchangePushJob;

    @Autowired
    MongoMarketHandler mongoMarketHandler;

    @Autowired
    WebsocketMarketHandler wsHandler;

    @Autowired
    NettyHandler nettyHandler;

    protected Random rand = new Random();
    /**
     * 1分钟钟执行一次
     */
    @Scheduled(cron = "0 */1 * * * *")
    public void checkOptionCoin(){
        List<ContractOptionCoin> coinList = coinService.findAll();
        for(int i = 0; i < coinList.size(); i++) {
            if(!factory.containsContractCoinMatch(coinList.get(i).getSymbol())) {
                ContractOptionCoinMatch match = new ContractOptionCoinMatch(coinList.get(i).getSymbol());
                match.addHandler(mongoMarketHandler);
                match.addHandler(wsHandler);
                match.addHandler(nettyHandler);
                match.setExchangePushJob(exchangePushJob);
                match.run();
                factory.addContractCoinMatch(coinList.get(i).getSymbol(), match);

                WebSocketConnectionManage.getWebSocket().subNewCoinPrice(coinList.get(i).getSymbol());
                WebSocketConnectionManage.getWebSocket().subNewCoinDepth(coinList.get(i).getSymbol());
                logger.info("订阅新币种价格及深度：" + coinList.get(i).getSymbol());
            }
        }

    }
    /**
     * 十秒执行一次
     */
    @Scheduled(cron = "*/10 * * * * *")
    public void checkOptions(){
        long currentTime = Calendar.getInstance().getTimeInMillis(); // 毫秒
        // 获取所有期权合约交易对
        List<ContractOptionCoin> coinList = coinService.findAll();
        if(coinList != null) {
            for (int i = 0; i < coinList.size(); i++) {
                // 一、获取正在进行的合约
                List<ContractOption> options = optionService.findBySymbolAndStatus(coinList.get(i).getSymbol(), ContractOptionStatus.STARTING);
                for(int j = 0; j < options.size(); j++) {
                    // 比较时间，如果超过时间，就变化订单状态(投注中 => 开奖中),并且新增一个投注
                    long timeGap = currentTime - options.get(j).getCreateTime();
                    if(timeGap/1000 >= coinList.get(i).getOpenTimeGap() - 3) { // 3秒延迟
                        ContractOption temOption = options.get(j);
                        int perOptionNo=temOption.getOptionNo()-1;
                        ContractOption perOption = optionService.findBySymbolAndOptionNo(coinList.get(i).getSymbol(),perOptionNo);
                        BigDecimal perClosePrice=null;
                        if(perOption!=null){
                            perClosePrice = perOption.getPresetPrice();
                        }
                        temOption.setStatus(ContractOptionStatus.OPENING);
                        temOption.setOpenTime(currentTime);
                        temOption.setOpenPrice(perClosePrice==null?factory.getContractCoinMatch(coinList.get(i).getSymbol()).getNowPrice():perClosePrice);
                        optionService.save(temOption);
                        logger.info("{} - 第 {} 期期权合约状态变化：投注中 => 开奖中", temOption.getSymbol(), temOption.getOptionNo());

                        // 有效状态，则生成新一期
                        if(coinList.get(i).getEnable() == 1) {
                            ContractOption newOption = new ContractOption();
                            newOption.setResult(ContractOptionResult.WAIT);
                            newOption.setStatus(ContractOptionStatus.STARTING);
                            newOption.setTotalSellCount(0);
                            newOption.setTotalBuyCount(0);
                            newOption.setTotalBuy(BigDecimal.ZERO);
                            newOption.setTotalSell(BigDecimal.ZERO);
                            newOption.setCreateTime(Calendar.getInstance().getTimeInMillis());
                            newOption.setOptionNo(coinList.get(i).getMaxOptionNo() + 1);
                            newOption.setSymbol(coinList.get(i).getSymbol());
                            newOption.setTotalPl(BigDecimal.ZERO);
                            newOption.setInitSell(BigDecimal.ZERO);
                            newOption.setInitBuy(BigDecimal.ZERO);
                            optionService.save(newOption);

                            logger.info("{} - 新建新一期合约：第 {} 期", coinList.get(i).getSymbol(), coinList.get(i).getMaxOptionNo() + 1);

                            ContractOptionCoin temCoin = coinList.get(i);
                            temCoin.setMaxOptionNo(temCoin.getMaxOptionNo() + 1);
                            coinService.save(temCoin);
                        }
                    }else{
                        ContractOption temOption = options.get(j);
                        if(temOption.getStatus() == ContractOptionStatus.STARTING
                            && temOption.getTotalBuy().compareTo(BigDecimal.ZERO) == 0
                            && coinList.get(i).getInitBuyReward().compareTo(BigDecimal.ZERO) > 0) {
                            // 状态是下注中 且 买涨奖池为空  且  期权合约交易对的设置了初始买涨奖池
                            // 50%的概率自动初始化奖池（按照配置的奖池）
                            if(rand.nextInt(100) < 50) {
                                temOption.setInitBuy(coinList.get(i).getInitBuyReward());
                                temOption.setTotalBuy(temOption.getTotalBuy().add(coinList.get(i).getInitBuyReward()));
                                optionService.save(temOption);
                            }
                        }
                        if(temOption.getStatus() == ContractOptionStatus.STARTING
                                && temOption.getTotalSell().compareTo(BigDecimal.ZERO) == 0
                                && coinList.get(i).getInitSellReward().compareTo(BigDecimal.ZERO) > 0) {
                            // 状态是下注中 且 买涨奖池为空  且  期权合约交易对的设置了初始买涨奖池
                            // 50%的概率自动初始化奖池（按照配置的奖池）
                            if(rand.nextInt(100) < 50) {
                                temOption.setInitSell(coinList.get(i).getInitSellReward());
                                temOption.setTotalSell(temOption.getTotalSell().add(coinList.get(i).getInitSellReward()));
                                optionService.save(temOption);
                            }
                        }
                    }
                }
                if(options == null || options.size() == 0) {
                    // 有效状态，则生成新一期
                    if(coinList.get(i).getEnable() == 1) {
                        ContractOption newOption = new ContractOption();
                        newOption.setResult(ContractOptionResult.WAIT);
                        newOption.setStatus(ContractOptionStatus.STARTING);
                        newOption.setTotalSellCount(0);
                        newOption.setTotalBuyCount(0);
                        newOption.setTotalBuy(BigDecimal.ZERO);
                        newOption.setTotalSell(BigDecimal.ZERO);
                        newOption.setCreateTime(Calendar.getInstance().getTimeInMillis());
                        newOption.setOptionNo(coinList.get(i).getMaxOptionNo() + 1);
                        newOption.setSymbol(coinList.get(i).getSymbol());
                        newOption.setTotalPl(BigDecimal.ZERO);
                        newOption.setInitBuy(BigDecimal.ZERO);
                        newOption.setInitSell(BigDecimal.ZERO);
                        optionService.save(newOption);

                        ContractOptionCoin temCoin = coinList.get(i);
                        temCoin.setMaxOptionNo(temCoin.getMaxOptionNo() + 1);
                        coinService.save(temCoin);

                        logger.info("{} - 新建新一期合约：第 {} 期", temCoin.getSymbol(), temCoin.getMaxOptionNo() + 1);
                    }
                }

                // 二、获取正在开奖的订单
                logger.info("开奖中订单检查");
                List<ContractOption> optionsOpening = optionService.findBySymbolAndStatus(coinList.get(i).getSymbol(), ContractOptionStatus.OPENING);
                for(int j = 0; j < optionsOpening.size(); j++) {
                    // 比较时间，如果超过时间，就变化订单状态(开奖中 => 已开奖)
                    long timeGap = currentTime - optionsOpening.get(j).getOpenTime();
                    if(timeGap/1000 >= coinList.get(i).getCloseTimeGap() - 3) { // 3秒延迟

                        ContractOption temOption = optionsOpening.get(j);
                        if(temOption.getPresetPrice()!=null && temOption.getPresetPrice().doubleValue()!=0){
                            //设置kline
                            optionService.savePresetPrice(temOption.getSymbol(),temOption.getPresetPrice());
                        }
                        temOption.setStatus(ContractOptionStatus.CLOSED); // 已开奖
                        temOption.setCloseTime(currentTime);
                        temOption.setClosePrice((temOption.getPresetPrice()==null||temOption.getPresetPrice().doubleValue()==0)?factory.getContractCoinMatch(coinList.get(i).getSymbol()).getNowPrice():temOption.getPresetPrice());

                        logger.info("{} - 第 {} 期期权合约状态变化：开奖中 => 已开奖", temOption.getSymbol(), temOption.getOptionNo());

                        // 获取参与订单
                        List<ContractOptionOrder> orderList = orderService.findByOptionId(optionsOpening.get(j).getId());
                        // 涨跌平判断
                        if(temOption.getClosePrice().subtract(temOption.getOpenPrice()).compareTo(BigDecimal.ZERO) > 0) {
                            logger.info("{} - 第 {} 期期权合约开奖结果：涨", temOption.getSymbol(), temOption.getOptionNo());
                            temOption.setResult(ContractOptionResult.WIN);
                            // 涨，分配奖金
                            for(int k = 0; k < orderList.size(); k++) {
                                ContractOptionOrder temOrder = orderList.get(k);
                                MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());
                                if(orderList.get(k).getDirection() == ContractOptionOrderDirection.BUY) {
                                    // 赢家（退回保证金，扣除手续费，瓜分奖池）
                                    walletService.thawBalance(wallet, temOrder.getBetAmount()); // 解冻保证金
                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) { // 扣除开仓手续费
                                        walletService.decreaseFrozen(wallet.getId(), temOrder.getFee());
                                        MemberTransaction memberTransaction = new MemberTransaction();
                                        memberTransaction.setFee(BigDecimal.ZERO);
                                        memberTransaction.setAmount(BigDecimal.ZERO.subtract(temOrder.getFee()));
                                        memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction.setType(TransactionType.OPTION_FEE);
                                        memberTransaction.setMemberId(temOrder.getMemberId());
                                        memberTransaction.setRealFee("0");
                                        memberTransaction.setDiscountFee("0");
                                        memberTransaction.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction);

                                        // 平台手续费收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getFee()));
                                    }
                                    // 瓜分奖池
                                    BigDecimal reward = BigDecimal.ZERO;
//                                    if(optionsOpening.get(j).getTotalSell().compareTo(BigDecimal.ZERO) > 0) {
//                                        reward = temOrder.getBetAmount().divide(optionsOpening.get(j).getTotalSell(), 4, BigDecimal.ROUND_HALF_DOWN);
//                                    }
                                    reward = temOrder.getBetAmount().multiply(coinList.get(i).getOods()).setScale(4, RoundingMode.DOWN);
                                    // 计算抽水
                                    BigDecimal winFee = reward.multiply(coinList.get(i).getWinFeePercent());
                                    temOrder.setWinFee(winFee);
                                    if(reward.compareTo(BigDecimal.ZERO) > 0) {
                                        // 增加奖金(计算奖池 - 抽水)
                                        walletService.increaseBalance(wallet.getId(), reward.subtract(winFee));
                                        // 增加资产变更记录
                                        MemberTransaction memberTransaction = new MemberTransaction();
                                        memberTransaction.setFee(BigDecimal.ZERO);
                                        memberTransaction.setAmount(reward.subtract(winFee));
                                        memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction.setType(TransactionType.OPTION_REWARD);
                                        memberTransaction.setMemberId(temOrder.getMemberId());
                                        memberTransaction.setRealFee("0");
                                        memberTransaction.setDiscountFee("0");
                                        memberTransaction.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction);

                                        temOrder.setRewardAmount(reward.subtract(winFee));

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getWinFee()));
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.WIN);
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE);

                                    orderService.save(temOrder);
                                }else{
                                    // 输家（扣除保证金，扣除手续费）
                                    walletService.decreaseFrozen(wallet.getId(), temOrder.getBetAmount());
                                    MemberTransaction memberTransaction = new MemberTransaction();
                                    memberTransaction.setFee(BigDecimal.ZERO);
                                    memberTransaction.setAmount(BigDecimal.ZERO.subtract(temOrder.getBetAmount()));
                                    memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                    memberTransaction.setType(TransactionType.OPTION_FAIL);
                                    memberTransaction.setMemberId(temOrder.getMemberId());
                                    memberTransaction.setRealFee("0");
                                    memberTransaction.setDiscountFee("0");
                                    memberTransaction.setCreateTime(new Date());
                                    memberTransactionService.save(memberTransaction);

                                    // 平台抽水收益
                                    temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getBetAmount()));

                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) { // 扣除开仓手续费
                                        walletService.decreaseFrozen(wallet.getId(), temOrder.getFee());
                                        MemberTransaction memberTransaction1 = new MemberTransaction();
                                        memberTransaction1.setFee(BigDecimal.ZERO);
                                        memberTransaction1.setAmount(BigDecimal.ZERO.subtract(temOrder.getFee()));
                                        memberTransaction1.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction1.setType(TransactionType.OPTION_FEE);
                                        memberTransaction1.setMemberId(temOrder.getMemberId());
                                        memberTransaction1.setRealFee("0");
                                        memberTransaction1.setDiscountFee("0");
                                        memberTransaction1.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction1);

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getFee()));
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.LOSE);
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE);

                                    orderService.save(temOrder);
                                }
                            }
                        }else if(temOption.getClosePrice().subtract(temOption.getOpenPrice()).compareTo(BigDecimal.ZERO) == 0){
                            logger.info("{} - 第 {} 期期权合约开奖结果：平", temOption.getSymbol(), temOption.getOptionNo());
                            temOption.setResult(ContractOptionResult.TIED);
                            // 平，原路退回资金 / 平台通吃
                            if(coinList.get(i).getTiedType() == 1) { // 退回资金
                                for(int k = 0; k < orderList.size(); k++) {
                                    ContractOptionOrder temOrder = orderList.get(k);
                                    MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());
                                    walletService.thawBalance(wallet, temOrder.getBetAmount());

                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) {
                                        walletService.thawBalance(wallet, temOrder.getFee());
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.TIED);
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE);

                                    orderService.save(temOrder);
                                }
                            }else{ // 平台通吃
                                for(int k = 0; k < orderList.size(); k++) {
                                    ContractOptionOrder temOrder = orderList.get(k);
                                    MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());
                                    walletService.decreaseFrozen(wallet.getId(), temOrder.getBetAmount());

                                    MemberTransaction memberTransaction = new MemberTransaction();
                                    memberTransaction.setFee(BigDecimal.ZERO);
                                    memberTransaction.setAmount(BigDecimal.ZERO.subtract(temOrder.getBetAmount()));
                                    memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                    memberTransaction.setType(TransactionType.OPTION_FAIL);
                                    memberTransaction.setMemberId(temOrder.getMemberId());
                                    memberTransaction.setRealFee("0");
                                    memberTransaction.setDiscountFee("0");
                                    memberTransaction.setCreateTime(new Date());
                                    memberTransactionService.save(memberTransaction);

                                    // 平台抽水收益
                                    temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getBetAmount()));

                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) {
                                        walletService.decreaseFrozen(wallet.getId(), temOrder.getFee());

                                        MemberTransaction memberTransaction1 = new MemberTransaction();
                                        memberTransaction1.setFee(BigDecimal.ZERO);
                                        memberTransaction1.setAmount(BigDecimal.ZERO.subtract(temOrder.getFee()));
                                        memberTransaction1.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction1.setType(TransactionType.OPTION_FAIL);
                                        memberTransaction1.setMemberId(temOrder.getMemberId());
                                        memberTransaction1.setRealFee("0");
                                        memberTransaction1.setDiscountFee("0");
                                        memberTransaction1.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction1);

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getFee()));
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.TIED);
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE);

                                    orderService.save(temOrder);
                                }
                            }
                        }else{
                            logger.info("{} - 第 {} 期期权合约开奖结果：跌", temOption.getSymbol(), temOption.getOptionNo());
                            temOption.setResult(ContractOptionResult.LOSE);
                            // 跌，分配奖金
                            for(int k = 0; k < orderList.size(); k++) {
                                ContractOptionOrder temOrder = orderList.get(k);
                                MemberWallet wallet = walletService.findByCoinUnitAndMemberId(temOrder.getBaseSymbol(), temOrder.getMemberId());
                                if(orderList.get(k).getDirection() == ContractOptionOrderDirection.SELL) {
                                    // 赢家（退回保证金，扣除手续费，瓜分奖池）
                                    walletService.thawBalance(wallet, temOrder.getBetAmount()); // 解冻保证金
                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) { // 扣除开仓手续费
                                        walletService.decreaseFrozen(wallet.getId(), temOrder.getFee());
                                        MemberTransaction memberTransaction = new MemberTransaction();
                                        memberTransaction.setFee(BigDecimal.ZERO);
                                        memberTransaction.setAmount(BigDecimal.ZERO.subtract(temOrder.getFee()));
                                        memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction.setType(TransactionType.OPTION_FEE);
                                        memberTransaction.setMemberId(temOrder.getMemberId());
                                        memberTransaction.setRealFee("0");
                                        memberTransaction.setDiscountFee("0");
                                        memberTransaction.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction);

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getFee()));
                                    }
                                    // 瓜分奖池
                                    BigDecimal reward = BigDecimal.ZERO;
//                                    if(optionsOpening.get(j).getTotalBuy().compareTo(BigDecimal.ZERO) > 0) {
//                                        reward = temOrder.getBetAmount().divide(optionsOpening.get(j).getTotalBuy(), 4, BigDecimal.ROUND_HALF_DOWN);
//                                    }
                                    reward = temOrder.getBetAmount().multiply(coinList.get(i).getOods()).setScale(4, RoundingMode.DOWN);
                                    // 计算抽水
                                    BigDecimal winFee = reward.multiply(coinList.get(i).getWinFeePercent());
                                    temOrder.setWinFee(winFee);
                                    if(reward.compareTo(BigDecimal.ZERO) > 0) {
                                        // 增加奖金(计算奖池 - 抽水)
                                        walletService.increaseBalance(wallet.getId(), reward.subtract(winFee));
                                        // 增加资产变更记录
                                        MemberTransaction memberTransaction = new MemberTransaction();
                                        memberTransaction.setFee(BigDecimal.ZERO);
                                        memberTransaction.setAmount(reward.subtract(winFee));
                                        memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction.setType(TransactionType.OPTION_REWARD);
                                        memberTransaction.setMemberId(temOrder.getMemberId());
                                        memberTransaction.setRealFee("0");
                                        memberTransaction.setDiscountFee("0");
                                        memberTransaction.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction);

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getWinFee()));

                                        temOrder.setRewardAmount(reward.subtract(winFee));
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.WIN);
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE);

                                    orderService.save(temOrder);
                                }else{
                                    // 输家（扣除保证金，扣除手续费）
                                    walletService.decreaseFrozen(wallet.getId(), temOrder.getBetAmount());
                                    MemberTransaction memberTransaction = new MemberTransaction();
                                    memberTransaction.setFee(BigDecimal.ZERO);
                                    memberTransaction.setAmount(BigDecimal.ZERO.subtract(temOrder.getBetAmount()));
                                    memberTransaction.setSymbol(temOrder.getBaseSymbol());
                                    memberTransaction.setType(TransactionType.OPTION_FAIL);
                                    memberTransaction.setMemberId(temOrder.getMemberId());
                                    memberTransaction.setRealFee("0");
                                    memberTransaction.setDiscountFee("0");
                                    memberTransaction.setCreateTime(new Date());
                                    memberTransactionService.save(memberTransaction);

                                    // 平台抽水收益
                                    temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getBetAmount()));

                                    if(temOrder.getFee().compareTo(BigDecimal.ZERO) > 0) { // 扣除开仓手续费
                                        walletService.decreaseFrozen(wallet.getId(), temOrder.getFee());
                                        MemberTransaction memberTransaction1 = new MemberTransaction();
                                        memberTransaction1.setFee(BigDecimal.ZERO);
                                        memberTransaction1.setAmount(BigDecimal.ZERO.subtract(temOrder.getFee()));
                                        memberTransaction1.setSymbol(temOrder.getBaseSymbol());
                                        memberTransaction1.setType(TransactionType.OPTION_FEE);
                                        memberTransaction1.setMemberId(temOrder.getMemberId());
                                        memberTransaction1.setRealFee("0");
                                        memberTransaction1.setDiscountFee("0");
                                        memberTransaction1.setCreateTime(new Date());
                                        memberTransactionService.save(memberTransaction1);

                                        // 平台抽水收益
                                        temOption.setTotalPl(temOption.getTotalPl().add(temOrder.getFee()));
                                    }

                                    temOrder.setResult(ContractOptionOrderResult.LOSE); // 结果
                                    temOrder.setStatus(ContractOptionOrderStatus.CLOSE); // 状态

                                    orderService.save(temOrder);
                                }
                            }
                        }
                        // 累加期权合约总盈利
                        ContractOptionCoin temCoin = coinList.get(i);
                        temCoin.setTotalProfit(temCoin.getTotalProfit().add(temOption.getTotalPl()));

                        // 保存本期期权合约
                        optionService.save(temOption);
                    }
                }
            }
        }
    }
}
