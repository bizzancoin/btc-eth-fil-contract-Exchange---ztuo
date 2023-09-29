package com.bizzan.bitrade.engine;

import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.handler.MarketHandler;
import com.bizzan.bitrade.job.ExchangePushJob;
import com.bizzan.bitrade.service.ContractOptionCoinService;
import com.bizzan.bitrade.service.ContractOptionOrderService;
import org.java_websocket.client.WebSocketClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

/**
 * 合约撮合引擎
 */
public class ContractOptionCoinMatch {

    private Logger logger = LoggerFactory.getLogger(WebSocketClient.class);

    private String symbol;                                           // 交易对：BTC/USDT
    private String baseSymbol;                                       // 基币：USDT
    private String coinSymbol;                                       // 币种：BTC
    private CoinThumb thumb;                                         // 交易对行情
    private LinkedList<ContractTrade> lastedTradeList;               // 最新成交明细
    private int lastedTradeListSize = 50;

    private long lastUpdateTime = 0L;                                // 上次价格更新时间（主要用于控制价格刷新周期，因为websokcet获取的价格变化较快）
    private boolean isTriggerComplete = true;                        // 价格刷新是否完成，触发委托及爆仓
    private BigDecimal nowPrice = BigDecimal.ZERO;                   // 当前最新价格

    private ContractOptionCoinService contractOptionCoinService;                  // 合约币种服务
    private ContractOptionOrderService contractOptionOrderService;                // 合约订单服务

    private List<MarketHandler> handlers;                             // 行情、概要等处理者
    private ExchangePushJob exchangePushJob;                          // 推送任务

    //卖盘盘口信息
    private TradePlate sellTradePlate;
    //买盘盘口信息
    private TradePlate buyTradePlate;

    private boolean isStarted = false;                                // 是否启动完成（用于初始化时，获取一些数据库未处理的订单的，如果没获取完，不允许处理）

    /**
     * 构造函数
     * @param symbol
     */
    public ContractOptionCoinMatch(String symbol) {
        this.symbol = symbol;
        this.coinSymbol = symbol.split("/")[0];
        this.baseSymbol = symbol.split("/")[1];
        this.handlers = new ArrayList<>();
        this.lastedTradeList = new LinkedList<>();
        this.buyTradePlate = new TradePlate(symbol, ContractOptionOrderDirection.BUY);
        this.sellTradePlate = new TradePlate(symbol, ContractOptionOrderDirection.SELL);
        // 初始化行情
        this.initializeThumb();
    }

    /**
     * 启动引擎，加载未处理订单
     */
    public void run(){
        this.isStarted = true;
    }

    /**
     * 更新盘口（买卖盘，火币Websocket获取到的是20条）
     * @param buyPlateItems
     * @param sellPlateItems
     */
    public void refreshPlate(List<TradePlateItem> buyPlateItems, List<TradePlateItem> sellPlateItems) {
        if(!this.isStarted) return;

        this.buyTradePlate.setItems(buyPlateItems);
        this.sellTradePlate.setItems(sellPlateItems);

        this.exchangePushJob.addPlates(symbol, sellTradePlate);
        this.exchangePushJob.addPlates(symbol, buyTradePlate);
    }

    /**
     * 更新行情
     * @param thumb
     */
    public void refreshThumb(CoinThumb thumb) {
        if(!this.isStarted) return;

        this.thumb.setHigh(thumb.getHigh());
        this.thumb.setLow(thumb.getLow());
        this.thumb.setOpen(thumb.getClose());
        this.thumb.setClose(thumb.getClose());
        this.thumb.setTurnover(thumb.getTurnover());
        this.thumb.setVolume(thumb.getVolume());
        this.thumb.setUsdRate(thumb.getClose());
        // 计算变化（变化金额以及变化比例，其中变化比例会出现负数）
        this.thumb.setChange(thumb.getClose().subtract(thumb.getOpen()));
        if(thumb.getOpen().compareTo(BigDecimal.ZERO) > 0) {
            this.thumb.setChg(this.thumb.getChange().divide(this.thumb.getOpen(), 4, RoundingMode.UP));
        }

        //logger.info("{} 行情刷新：Hight-{}, Low-{}, Open-{}, Close-{}", symbol, thumb.getHigh(), thumb.getLow(), thumb.getOpen(), thumb.getClose());
        // 推送行情
        handleCoinThumb();
    }

    /**
     * 更新价格
     * 更新价格时，涉及到计划委托、止盈止损检测、爆仓检查，有一定耗时操作
     * @param newPrice
     */
    public void refreshPrice(BigDecimal newPrice) {
        if(!this.isStarted) return;

        long currentTime = Calendar.getInstance().getTimeInMillis();
        // 控制1秒+更新一次
        if(currentTime - lastUpdateTime > 1000) {
            lastUpdateTime = currentTime;

            // 价格未发生变化，无需继续操作
            if(this.nowPrice.compareTo(newPrice) == 0) {
                return;
            }
            //logger.info("{} 价格发生改变：{} -> {}", symbol, nowPrice, newPrice);
            this.nowPrice = newPrice;
        }
    }

    /**
     * 更新成交明细
     * @param tradeArrayList
     */
    public void refreshLastedTrade(List<ContractTrade> tradeArrayList) {
        for(ContractTrade trade : tradeArrayList) {
            if(lastedTradeList.size() > lastedTradeListSize) {
                this.lastedTradeList.removeLast();
                this.lastedTradeList.addFirst(trade);
            }else{
                this.lastedTradeList.addFirst(trade);
            }
        }
        //logger.info("{} 盘面更新：大小-{}", symbol, tradeArrayList.size());
        // 添加成交明细
        this.exchangePushJob.addTrades(symbol, tradeArrayList);
    }

    /**
     * 初始化Thumb
     */
    public void initializeThumb() {
        this.thumb = new CoinThumb();
        this.thumb.setChg(BigDecimal.ZERO);                 // 变化百分比（例：4%）
        this.thumb.setChange(BigDecimal.ZERO);              // 变化金额
        this.thumb.setOpen(BigDecimal.ZERO);                // 开盘价
        this.thumb.setClose(BigDecimal.ZERO);               // 收盘价
        this.thumb.setHigh(BigDecimal.ZERO);                // 最高价
        this.thumb.setLow(BigDecimal.ZERO);                 // 最低价
        this.thumb.setBaseUsdRate(BigDecimal.valueOf(6.42)); // 基础USDT汇率
        this.thumb.setLastDayClose(BigDecimal.ZERO);        // 前日收盘价
        this.thumb.setSymbol(this.symbol);                  // 交易对符号
        this.thumb.setUsdRate(BigDecimal.valueOf(6.42));     // USDT汇率
        this.thumb.setZone(0);                              // 交易区
        this.thumb.setVolume(BigDecimal.ZERO);              // 成交量
        this.thumb.setTurnover(BigDecimal.ZERO);            // 成交额
    }

    public void handleCoinThumb() {
        for (MarketHandler storage : handlers) {
            storage.handleTrade(symbol, thumb);
        }
    }

    public void handleKLineStorage(KLine kLine) {
        for (MarketHandler storage : handlers) {
            storage.handleKLine(symbol, kLine);
        }
    }
    // 获取交易对符号
    public String getSymbol() { return this.symbol; }
    // 获取币种符号
    public String getCoinSymbol() { return this.coinSymbol; }
    // 获取基币符号
    public String getBaseSymbol() { return this.baseSymbol; }
    // 获取交易对最新报价
    public BigDecimal getNowPrice() { return this.nowPrice; }
    // 获取交易对最新行情
    public CoinThumb getThumb() { return this.thumb; }
    // 获取最新成交明细
    public List<ContractTrade> getLastedTradeList() { return this.lastedTradeList; }
    // 获取盘口数据
    public TradePlate getTradePlate(ContractOptionOrderDirection direction){
        if(direction == ContractOptionOrderDirection.BUY){
            return buyTradePlate;
        }
        else{
            return sellTradePlate;
        }
    }
    // 添加处理者
    public void addHandler(MarketHandler storage) {
        handlers.add(storage);
    }
    public void setExchangePushJob(ExchangePushJob job) { this.exchangePushJob = job; }
}
