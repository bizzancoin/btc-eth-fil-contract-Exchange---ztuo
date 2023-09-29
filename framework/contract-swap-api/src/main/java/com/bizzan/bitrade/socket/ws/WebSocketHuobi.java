package com.bizzan.bitrade.socket.ws;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.engine.ContractCoinMatch;
import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.job.ExchangePushJob;
import com.bizzan.bitrade.service.ContractCoinService;
import com.bizzan.bitrade.service.ContractMarketService;
import com.bizzan.bitrade.util.JSONUtils;
import com.bizzan.bitrade.util.WebSocketConnectionManage;
import com.bizzan.bitrade.util.ZipUtils;
import org.java_websocket.WebSocket;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.enums.ReadyState;
import org.java_websocket.handshake.ServerHandshake;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.net.URI;
import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WebSocketHuobi extends WebSocketClient {

    private Logger logger = LoggerFactory.getLogger(WebSocketClient.class);
    private ArrayList<String> subCoinList = new ArrayList<String>();

    private ContractCoinMatchFactory matchFactory;
    private ContractMarketService marketService;
    private ExchangePushJob exchangePushJob;

    public static String DEPTH = "market.%s.depth.step0"; // 深度
    public static String KLINE = "market.%s.kline.%s"; // K线
    public static String DETAIL = "market.%s.detail"; // 市场概要（最新价格、成交量等）
    public static String TRADE = "market.%s.trade.detail"; // 成交明细

    private double VOLUME_PERCENT = 0.13; // 火币成交量的百分比

    public static String PERIOD[] = { "1min", "5min", "15min", "30min", "60min","4hour", "1day", "1mon", "1week" };

    public WebSocketHuobi(URI uri, ContractCoinMatchFactory matchFactory, ContractMarketService service, ExchangePushJob pushJob) {
        super(uri);
        this.uri = uri;
        this.matchFactory = matchFactory;
        this.marketService = service;
        this.exchangePushJob = pushJob;
    }

    @Override
    public void onOpen(ServerHandshake shake) {
        logger.info("[WebSocketHuobi] 开启价格 Websocket 监听...");
        if (null != this.matchFactory.getMatchMap() && this.matchFactory.getMatchMap().size() > 0) {
            for(String symbol : this.matchFactory.getMatchMap().keySet()) {
                if(!subCoinList.contains(symbol)){
                    subCoinList.add(symbol);
                }
                // 订阅深度
                String depthTopic = String.format(DEPTH, symbol.replace("/", "").toLowerCase());
                logger.info("[WebSocketHuobi][" + symbol + "] 深度订阅: " + depthTopic);
                sendWsMarket("sub", depthTopic);

                // 订阅市场概要
                String detailTopic = String.format(DETAIL, symbol.replace("/", "").toLowerCase());
                logger.info("[WebSocketHuobi][" + symbol + "] 概要订阅: " + detailTopic);
                sendWsMarket("sub", detailTopic);

                // 订阅成交明细
                String tradeTopic = String.format(TRADE, symbol.replace("/", "").toLowerCase());
                logger.info("[WebSocketHuobi][" + symbol + "] 成交明细订阅: " + tradeTopic);
                sendWsMarket("sub", tradeTopic);

                // 订阅实时K线
//                for(String period : PERIOD) {
//                    String klineTopic = String.format(KLINE, symbol.replace("/", "").toLowerCase(), period);
//                    logger.info("[WebSocketHuobi][" + symbol + "] 实时K线订阅: " + klineTopic);
//                    sendWsMarket("sub", klineTopic);
//                }
            }
        }
    }

    /**
     * 订阅新币种行情信息
     * @param symbol
     */
    public void subNewCoin(String symbol) {
        if(!subCoinList.contains(symbol)){
            subCoinList.add(symbol);

            String detailTopic = String.format(DETAIL, symbol.replace("/", "").toLowerCase());
            logger.info("[WebSocketHuobi][" + symbol + "] 概要订阅: " + detailTopic);
            sendWsMarket("sub", detailTopic);

            String tradeTopic = String.format(TRADE, symbol.replace("/", "").toLowerCase());
            logger.info("[WebSocketHuobi][" + symbol + "] 成交明细订阅: " + tradeTopic);
            sendWsMarket("sub", tradeTopic);

            String depthTopic = String.format(DEPTH, symbol.replace("/", "").toLowerCase());
            logger.info("[WebSocketHuobi][" + symbol + "] 深度订阅: " + depthTopic);
            sendWsMarket("sub", depthTopic);
        }
    }

    // 同步K线
    public void reqKLineList(String symbol, String period, long from, long to) {
        String topic = String.format(KLINE, symbol.replace("/", "").toLowerCase(), period);

        // Huobi Websocket要求单次请求数据不能超过300条，因此需要在次对请求进行拆分
        long timeGap = to - from; // 时间差
        long divideTime = 0;
        if(period.equals("1min")) divideTime = 60 * 300; // 1分钟 * 300条
        if(period.equals("5min")) divideTime = 5* 60 * 300;
        if(period.equals("15min")) divideTime = 15* 60 * 300;
        if(period.equals("30min")) divideTime = 30 * 60 * 300;
        if(period.equals("60min")) divideTime = 60 * 60 * 300;
        if(period.equals("4hour")) divideTime = 4 * 60 * 60 * 300;
        if(period.equals("1day")) divideTime = 24 * 60 * 60 * 300;
        if(period.equals("1week")) divideTime = 7 * 24 * 60 * 60 * 300;
        if(period.equals("1mon")) divideTime = 30 * 24 * 60 * 60 * 300;

        if(timeGap > divideTime) {
            long times = timeGap % (divideTime) > 0 ?  (timeGap/(divideTime) + 1) : timeGap/(divideTime);
            long temTo = from;
            long temFrom = from;
            for(int i = 0; i < times; i++) {
                if(temTo + (divideTime) > to) {
                    temTo = to;
                }else{
                    temTo = temTo + (divideTime);
                }
                sendWsMarket("req", topic, temFrom, temTo);
                temFrom = temFrom + divideTime;
            }
        }else{
            sendWsMarket("req", topic, from, to);
        }
    }

    @Override
    public void onMessage(String arg0) {
        if (arg0 != null) {
            logger.info("[WebSocketHuobi] receive message: {}", arg0);
        }
    }

    @Override
    public void onError(Exception arg0) {
        logger.error("[WebSocketHuobi] has error ,the message is :: {}", arg0.getMessage());
        arg0.printStackTrace();
        String message = "";
        try {
            message = new String(arg0.getMessage().getBytes(), "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("[WebSocketHuobi] has error ,the message is :: {}", message);
        }
    }

    @Override
    public void onClose(int arg0, String arg1, boolean arg2) {
        logger.info("[WebSocketHuobi] connection close: {} - {} - {}", arg0, arg1, arg2);
        int tryTimes = 0;
        // 尝试20次
        logger.info("[WebSocketHuobi] 尝试重新连接，第 " + tryTimes + "次");
        if(this.getReadyState().equals(ReadyState.NOT_YET_CONNECTED) || this.getReadyState().equals(ReadyState.CLOSED) || this.getReadyState().equals(ReadyState.CLOSING)) {

            Runnable sendable = new Runnable() {
                @Override
                public void run() {
                    logger.info("[WebSocketHuobi] 开启重新连接");
                    reconnect();
                }
            };
            new Thread(sendable).start();
        }
    }

    @Override
    public void onMessage(ByteBuffer bytes) {
        try {
            String message = new String(ZipUtils.decompress(bytes.array()), "UTF-8");

            JSONObject jsonObject = JSONObject.parseObject(message);
            if (!"".equals(message)) {
                if (message.indexOf("ping") > 0) {
                    String pong = jsonObject.toString();
                    send(pong.replace("ping", "pong"));
                } else {

                    String id = "";
                    if(jsonObject.containsKey("ch")) {
                        id = jsonObject.getString("ch");
                        if (id == null || id.split("\\.").length < 3) {
                            return;
                        }
                    }
                    if(jsonObject.containsKey("rep")) {
                        id = jsonObject.getString("rep");
                        if (id == null || id.split("\\.").length < 3) {
                            return;
                        }
                    }
                    if(id.equals("")) {
                        return;
                    }
                    StringBuilder sb = new StringBuilder(id.split("\\.")[1]);
                    String symbol = sb.insert(sb.indexOf("usdt"), "/").toString().toUpperCase();

                    String type = id.split("\\.")[2];

                    if(type.equals("kline")) {

                        String data = jsonObject.getString("data");
                        String period = id.split("\\.")[3];

                        if (null != data && !"".equals(data) && JSONUtils.isJsonArray(data)) {

                            Poke poke = marketService.findPoke(symbol,type);
                            BigDecimal price = poke==null ? null : BigDecimal.valueOf(Double.parseDouble(poke.getPrice()));

                            JSONArray klineList = jsonObject.getJSONArray("data");

                            for(int i = 0; i < klineList.size(); i++) {
                                JSONObject klineObj = klineList.getJSONObject(i);

                                BigDecimal open = (price==null || i==0)? klineObj.getBigDecimal("open") : price; // 收盘价
                                BigDecimal close = (price==null || i==klineList.size()-1) ? klineObj.getBigDecimal("close") : price; // 收盘价
                                BigDecimal high = price==null ? klineObj.getBigDecimal("high") : price; // 收盘价
                                BigDecimal low = price==null ? klineObj.getBigDecimal("low") : price; // 收盘价
                                BigDecimal amount = klineObj.getBigDecimal("amount"); // 收盘价
                                BigDecimal vol = klineObj.getBigDecimal("vol"); // 收盘价
                                int count = klineObj.getIntValue("count"); // 收盘价
                                long time = klineObj.getLongValue("id");

                                KLine kline = new KLine(period);
                                kline.setClosePrice(close);
                                kline.setCount(count);
                                kline.setHighestPrice(high);
                                kline.setLowestPrice(low);
                                kline.setOpenPrice(open);
                                kline.setTime(time);
                                kline.setTurnover(amount.multiply(BigDecimal.valueOf(VOLUME_PERCENT)));
                                kline.setVolume(vol.multiply(BigDecimal.valueOf(VOLUME_PERCENT)));
                                marketService.saveKLine(symbol, kline);

                                // 推送K线(如果只有一条，说明是最新的K线，需要推送到前端K线)
                                if(klineList.size() == 1) {
                                    //logger.info("K线推送：" + kline.getPeriod() + " - " + symbol + " - " + kline.getTime());
                                    exchangePushJob.pushTickKline(symbol, kline);
                                }else if(klineList.size() > 1){
                                    if(i == klineList.size() - 1) {
                                        //logger.info("K线推送：" + kline.getPeriod() + " - " + symbol + " - " + kline.getTime());
                                        exchangePushJob.pushTickKline(symbol, kline);
                                    }
                                }
                            }
                        }
                    }else if(type.equals("depth")){
                        String tick = jsonObject.getString("tick");
                        if (null != tick && !"".equals(tick) && JSONUtils.isJsonObject(tick)) {

                            Poke poke = marketService.findPoke(symbol,type);
                            BigDecimal price = poke==null ? null : BigDecimal.valueOf(Double.parseDouble(poke.getPrice()));

                            JSONObject plateObj = JSONObject.parseObject(tick);

                            // 买盘深度
                            JSONArray bids = plateObj.getJSONArray("bids");
                            List<TradePlateItem> buyItems = new ArrayList<>();
                            for(int i = 0; i < bids.size(); i++) {
                                TradePlateItem item = new TradePlateItem();
                                JSONArray itemObj = bids.getJSONArray(i);
                                item.setPrice(price==null ? itemObj.getBigDecimal(0) : price);
                                item.setAmount(itemObj.getBigDecimal(1));
                                buyItems.add(item);
                            }

                            // 卖盘深度
                            JSONArray asks = plateObj.getJSONArray("asks");
                            List<TradePlateItem> sellItems = new ArrayList<>();
                            for(int i = 0; i < asks.size(); i++) {
                                TradePlateItem item = new TradePlateItem();
                                JSONArray itemObj = asks.getJSONArray(i);
                                item.setPrice(price==null ? itemObj.getBigDecimal(0) : price);
                                item.setAmount(itemObj.getBigDecimal(1));
                                sellItems.add(item);
                            }
                            // 刷新盘口数据
                            this.matchFactory.getContractCoinMatch(symbol).refreshPlate(buyItems, sellItems);

                            //logger.info("[WebSocketHuobi] 盘口更新：bids共 {} 条，asks共 {} 条", bids.size(), asks.size());
                        }
                    }else if(type.equals("detail")){ // 市场行情概要
                        String tick = jsonObject.getString("tick");
                        if (null != tick && !"".equals(tick) && JSONUtils.isJsonObject(tick)) {
                            JSONObject detailObj = JSONObject.parseObject(tick);
                            Poke poke = marketService.findPoke(symbol,type);
                            BigDecimal price = poke==null ? null : BigDecimal.valueOf(Double.parseDouble(poke.getPrice()));

                            BigDecimal amount = detailObj.getBigDecimal("amount");
                            BigDecimal open = price==null ? detailObj.getBigDecimal("open") : price;
                            BigDecimal close = price==null ? detailObj.getBigDecimal("close") : price;
                            BigDecimal high = price==null ? detailObj.getBigDecimal("high") : price;
                            BigDecimal count = detailObj.getBigDecimal("count");
                            BigDecimal low = price==null ? detailObj.getBigDecimal("low") : price;
                            BigDecimal vol = detailObj.getBigDecimal("vol");

                            CoinThumb thumb = new CoinThumb();
                            thumb.setOpen(open);
                            thumb.setClose(close);
                            thumb.setHigh(high);
                            thumb.setLow(low);
                            thumb.setVolume(amount.multiply(BigDecimal.valueOf(VOLUME_PERCENT))); // 成交量
                            thumb.setTurnover(vol.multiply(BigDecimal.valueOf(VOLUME_PERCENT))); // 成交额
                            this.matchFactory.getContractCoinMatch(symbol).refreshThumb(thumb);

                            // 委托触发 or 爆仓
                            this.matchFactory.getContractCoinMatch(symbol).refreshPrice(close);
                            //logger.info("[WebSocketHuobi] 价格更新：{}", close);
                        }
                    }else if(type.equals("trade")) { // 成交明细
                        String tick = jsonObject.getString("tick");
                        if (null != tick && !"".equals(tick) && JSONUtils.isJsonObject(tick)) {
                            Poke poke = marketService.findPoke(symbol,type);
                            BigDecimal pokePrice = poke==null ? null : BigDecimal.valueOf(Double.parseDouble(poke.getPrice()));
                            JSONObject detailObj = JSONObject.parseObject(tick);
                            JSONArray tradeList = detailObj.getJSONArray("data");
                            List<ContractTrade> tradeArrayList = new ArrayList<ContractTrade>();
                            for(int i = 0; i < tradeList.size(); i++) {
                                BigDecimal amount = tradeList.getJSONObject(i).getBigDecimal("amount");
                                BigDecimal price = pokePrice==null ? tradeList.getJSONObject(i).getBigDecimal("price") : pokePrice;
                                String direction = tradeList.getJSONObject(i).getString("direction");
                                long time = tradeList.getJSONObject(i).getLongValue("ts");
                                String tradeId = tradeList.getJSONObject(i).getString("tradeId");

                                // 创建交易
                                ContractTrade trade = new ContractTrade();
                                trade.setAmount(amount);
                                trade.setPrice(price);
                                if(direction.equals("buy")) {
                                    trade.setDirection(ContractOrderDirection.BUY);
                                    trade.setBuyOrderId(tradeId);
                                    trade.setBuyTurnover(amount.multiply(price));
                                }else{
                                    trade.setDirection(ContractOrderDirection.SELL);
                                    trade.setSellOrderId(tradeId);
                                    trade.setSellTurnover(amount.multiply(price));
                                }
                                trade.setSymbol(symbol);
                                trade.setTime(time);

                                tradeArrayList.add(trade);

                                // 刷新成交记录
                                this.matchFactory.getContractCoinMatch(symbol).refreshLastedTrade(tradeArrayList);
                            }

                            //logger.info("[WebSocketHuobi] 成交明细更新：共 {} 条", tradeArrayList.size());
                        }
                    }
                }
            }
        } catch (CharacterCodingException e) {
            e.printStackTrace();
            logger.error("[WebSocketHuobi] websocket exception: {}", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("[WebSocketHuobi] websocket exception: {}", e.getMessage());
        }
    }

    public void sendWsMarket(String op, String topic) {
        JSONObject req = new JSONObject();
        req.put(op, topic);
        send(req.toString());
    }

    public void sendWsMarket(String op, String topic, long from, long to) {
        JSONObject req = new JSONObject();
        req.put(op, topic);
        req.put("from", from);
        req.put("to", to);
        send(req.toString());
    }
}
