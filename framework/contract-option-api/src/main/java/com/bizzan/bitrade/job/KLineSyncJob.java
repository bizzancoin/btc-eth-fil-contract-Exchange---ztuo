package com.bizzan.bitrade.job;

import com.bizzan.bitrade.engine.ContractOptionCoinMatchFactory;
import com.bizzan.bitrade.service.ContractMarketService;
import com.bizzan.bitrade.util.DateUtil;
import com.bizzan.bitrade.util.WebSocketConnectionManage;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class KLineSyncJob {

    private org.slf4j.Logger logger = LoggerFactory.getLogger(KLineSyncJob.class);

    @Autowired
    private ContractOptionCoinMatchFactory matchFactory;

    @Autowired
    private ContractMarketService contractMarketService;

    public static String PERIOD[] ={ "1min", "5min", "15min", "30min", "60min","4hour", "1day", "1mon", "1week" };

    private List<CoinSyncItem> coinList = new ArrayList<CoinSyncItem>(); // 交易对列表

    /**
     * 1分钟执行一次：检查
     */
    //@Scheduled(fixedDelay = 60000)
    public void syncKLine(){

        // 币种列表大小为0，或引擎中币种数量与当前列表数量不一致
        if(coinList.size() == 0 || coinList.size() != matchFactory.getMatchMap().size()) this.initCoinList();

        // 获取当前时间(秒)
        Long currentTime = DateUtil.getTimeMillis() / 1000;

        logger.info("分钟执行获取K线[Start]");
        for(CoinSyncItem coinItem : coinList) {
            for(String period : PERIOD) {
                long fromTime = contractMarketService.findMaxTimestamp(coinItem.getSymbol(), period);
                //long fromTime = coinItem.getLastPeriodTime(period) + 1; // +1是为了不获取上一次获取的最后一条K线
                long timeGap = currentTime - fromTime;
                if(period.equals("1min") && timeGap >= 60) { // 超出1分钟
                    if(fromTime == 0) {
                        logger.info("分钟执行获取K线[1min] ===> from == 0");
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        logger.info("分钟执行获取K线[1min] ===> from != 0, timeGap: {}", timeGap);
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % 60); // +10秒是为了获取本区间内的K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("5min") && timeGap >= 60 * 5) { // 超出5分钟
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 5 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (5 * 60));
                        logger.info("获取5分钟K线, From: {}, To: {}", fromTime, toTime);
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("15min") && timeGap >= (60 * 15 + 60)) { // 超出15分钟
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 15 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (15 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("30min") && timeGap >= (60 * 30 + 60)) { // 超出30分钟
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 30 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (30 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("60min") && timeGap >= (60 * 60 + 60)) { // 超出60分钟
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 60 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (60 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("4hour") && timeGap >= (60 * 60 * 4 + 60)) { // 超出4小时
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 4 * 60 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (4 * 60 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("1day") && timeGap >= (60 * 60 * 24 + 60)) { // 超出24小时
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 24 * 60 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (24 * 60 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("1week") && timeGap >= (60 * 60 * 24 * 7 + 60)) { // 超出24小时
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 7 * 24 * 60 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (7 * 24 * 60 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime - 10);
                    }
                }

                if(period.equals("1mon") && timeGap >= (60 * 60 * 24 * 30 + 60)) { // 超出24小时
                    if(fromTime == 0) {
                        // 初始化K线，获取最近600根K线
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 30 * 24 * 60 * 60 * 600, currentTime);
                        coinItem.setLastPeriodTime(period, currentTime);
                    }else{
                        // 非初始化，获取最近产生的K线
                        long toTime = fromTime + timeGap - (timeGap % (30 * 24 * 60 * 60));
                        WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, fromTime, toTime);
                        coinItem.setLastPeriodTime(period, toTime);
                    }
                }
            }
        }
    }

    /**
     * 5分钟执行一次：检查是否有新增交易对
     */
    @Scheduled(cron = "0 */5 * * * *")
    public void checkNewCoin(){

    }

    /**
     * 1小时执行一次：同步币种K线最新更新时间
     * 这个主要是为了防止syncKLine这个Job
     */
    @Scheduled(cron = "0 0 */1 * * *")
    public void syncKLineTime() {
        for (CoinSyncItem coinItem : coinList) {
            for (String period : PERIOD) {
                long lastTime = contractMarketService.findMaxTimestamp(coinItem.getSymbol(), period);
                coinItem.setLastPeriodTime(period, lastTime);
            }
        }
    }

    private void initCoinList(){
        // 没有列表（初始化）
        if(coinList.size() == 0) {
            for(String symbol : this.matchFactory.getMatchMap().keySet()) {
                CoinSyncItem coinItem = new CoinSyncItem(PERIOD);
                coinItem.setSymbol(symbol);

                // 设置各周期K线最后时间
                for(String period : PERIOD){
                    long lastTime = contractMarketService.findMaxTimestamp(symbol, period);
                    coinItem.setLastPeriodTime(period, lastTime);

                    if(lastTime == 0) {
                        Long currentTime = DateUtil.getTimeMillis() / 1000;

                        if(period.equals("1min")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 60 * 600, currentTime);
                        if(period.equals("5min")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 5 * 60 * 600, currentTime);
                        if(period.equals("15min")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 15 * 60 * 600, currentTime);
                        if(period.equals("30min")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 30 * 60 * 600, currentTime);
                        if(period.equals("60min")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 60 * 60 * 600, currentTime);
                        if(period.equals("4hour")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 4 * 60 * 60 * 600, currentTime);
                        if(period.equals("1day")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 24 * 60 * 60 * 600, currentTime);
                        if(period.equals("1week")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 7 * 24 * 60 * 60 * 600, currentTime);
                        if(period.equals("1mon")) WebSocketConnectionManage.getWebSocket().reqKLineList(coinItem.getSymbol(), period, currentTime - 30 * 24 * 60 * 60 * 600, currentTime);

                        coinItem.setLastPeriodTime(period, currentTime);
                    }
                }
                logger.info("初始化K线任务币种列表，添加币种：{}", symbol);
                coinList.add(coinItem);
            }
        }else{
            for(String symbol : this.matchFactory.getMatchMap().keySet()) {
                boolean hasValue = false;
                for(CoinSyncItem item : coinList) {
                    if(item.getSymbol().equals(symbol)) {
                        hasValue = true;
                    }
                }
                if(!hasValue) {
                    CoinSyncItem cs = new CoinSyncItem(PERIOD);
                    cs.setSymbol(symbol);

                    // 设置各周期K线最后时间
                    for(String p : PERIOD){
                        long lastTime = contractMarketService.findMaxTimestamp(symbol, p);
                        cs.setLastPeriodTime(p, lastTime);
                    }
                    logger.info("初始化K线任务币种列表，添加币种：{}", symbol);
                    coinList.add(cs);
                }
            }
        }
    }

    class CoinSyncItem{
        String symbol;
        Map<String, Long> lastUpdateTime;

        CoinSyncItem(String[] period){
            lastUpdateTime = new HashMap<String, Long>();
            for(String p : period) {
                lastUpdateTime.put(p, -1L);
            }
        }

        public String getSymbol() {
            return symbol;
        }
        public void setSymbol(String symbol) {
            this.symbol = symbol;
        }

        public void setLastPeriodTime(String period, Long time) {
            this.lastUpdateTime.put(period, time);
        }

        public Long getLastPeriodTime(String period) {
            return this.lastUpdateTime.get(period);
        }

    }
}
