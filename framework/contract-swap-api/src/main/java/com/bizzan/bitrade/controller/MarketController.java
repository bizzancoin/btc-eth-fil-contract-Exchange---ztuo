package com.bizzan.bitrade.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.engine.ContractCoinMatch;
import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.service.ContractCoinService;
import com.bizzan.bitrade.service.ContractMarketService;
import lombok.extern.slf4j.Slf4j;
import org.java_websocket.client.WebSocketClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.*;

@Slf4j
@RestController
public class MarketController {

    private Logger logger = LoggerFactory.getLogger(MarketController.class);
    @Autowired
    private ContractCoinService coinService;

    @Autowired
    private ContractCoinMatchFactory contractCoinMatchFactory;

    @Autowired
    private ContractMarketService marketService;

    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 获取支持的交易币种
     * @return
     */
    @RequestMapping("symbol")
    public List<ContractCoin> findAllSymbol(){
        List<ContractCoin> coins = coinService.findAllVisible();
        return coins;
    }
    /**
     * 获取币种缩略行情
     * @return
     */
    @RequestMapping("symbol-thumb")
    public List<CoinThumb> findSymbolThumb(){
        List<ContractCoin> coins = coinService.findAllVisible();
        List<CoinThumb> thumbs = new ArrayList<>();
        for(ContractCoin coin:coins){
            ContractCoinMatch processor = contractCoinMatchFactory.getContractCoinMatch(coin.getSymbol());
            CoinThumb thumb = processor.getThumb();
            thumbs.add(thumb);
        }
        return thumbs;
    }

    /**
     * 查询最近成交记录
     * @param symbol 交易对符号
     * @param size 返回记录最大数量
     * @return
     */
    @RequestMapping("latest-trade")
    public List<ContractTrade> latestTrade(String symbol, int size){
        ContractCoinMatch match = contractCoinMatchFactory.getContractCoinMatch(symbol);
        if (match == null) {
            return null;
        }
        return match.getLastedTradeList();
    }

    /**
     * 获取某交易对详情
     * @param symbol
     * @return
     */
    @RequestMapping("symbol-info")
    public ContractCoin findSymbol(String symbol){
        ContractCoin coin = coinService.findBySymbol(symbol);
        coin.setCurrentTime(Calendar.getInstance().getTimeInMillis());
        return coin;
    }

    @RequestMapping("exchange-plate")
    public Map<String,List<TradePlateItem>> findTradePlate(String symbol){
        Map<String, List<TradePlateItem>> result = new HashMap<>();
        ContractCoinMatch match = contractCoinMatchFactory.getContractCoinMatch(symbol);
        if (match == null) {
            return null;
        }
        result.put("bid", match.getTradePlate(ContractOrderDirection.BUY).getItems());
        result.put("ask", match.getTradePlate(ContractOrderDirection.SELL).getItems());

        return result;
    }

    @RequestMapping("exchange-plate-mini")
    public Map<String, JSONObject> findTradePlateMini(String symbol){
        Map<String, JSONObject> result = new HashMap<>();
        ContractCoinMatch match = contractCoinMatchFactory.getContractCoinMatch(symbol);
        if (match == null) {
            return null;
        }
        result.put("bid", match.getTradePlate(ContractOrderDirection.BUY).toJSON(20));
        result.put("ask", match.getTradePlate(ContractOrderDirection.SELL).toJSON(20));

        return result;
    }

    @RequestMapping("exchange-plate-full")
    public Map<String,JSONObject> findTradePlateFull(String symbol){
        Map<String, JSONObject> result = new HashMap<>();
        ContractCoinMatch match = contractCoinMatchFactory.getContractCoinMatch(symbol);
        if (match == null) {
            return null;
        }
        result.put("bid", match.getTradePlate(ContractOrderDirection.BUY).toJSON());
        result.put("ask", match.getTradePlate(ContractOrderDirection.SELL).toJSON());

        return result;
    }

    /**
     * 获取币种历史K线
     * @param symbol
     * @param from
     * @param to
     * @param resolution
     * @return
     */
    @RequestMapping("history")
    public JSONArray findKHistory(String symbol, long from, long to, String resolution){
        String period = "";
        if(resolution.endsWith("H") || resolution.endsWith("h")){
            period = resolution.substring(0,resolution.length()-1) + "hour";
        }
        else if(resolution.endsWith("D") || resolution.endsWith("d")){
            period = resolution.substring(0,resolution.length()-1) + "day";
        }
        else if(resolution.endsWith("W") || resolution.endsWith("w")){
            period = resolution.substring(0,resolution.length()-1) + "week";
        }
        else if(resolution.endsWith("M") || resolution.endsWith("m")){
            period = resolution.substring(0,resolution.length()-1) + "mon";
        }
        else{
            Integer val = Integer.parseInt(resolution);
            if(val <= 60) {
                period = resolution + "min";
            }
            else {
                period = (val/60) + "hour";
            }
        }
        from = from / 1000;
        to = to / 1000;
        List<KLine> list = marketService.findAllKLine(symbol,from,to,period);
        logger.info("获取历史K线）symbol: {},  period: {}, from: {}, to: {}, size: {}", symbol, resolution, from, to, list.size());
        JSONArray array = new JSONArray();
        boolean startFlag = false;
        KLine temKline = null;
        for(KLine item:list){
            item.setTime(item.getTime() * 1000);
            // 此段处理是过滤币种开头出现0开盘/收盘的K线
            if(!startFlag && item.getOpenPrice().compareTo(BigDecimal.ZERO) == 0) {
                continue;
            }else {
                startFlag = true;
            }
            // 中间段如果出现为0的现象，需要处理一下
            if(item.getOpenPrice().compareTo(BigDecimal.ZERO) == 0) {
                item.setOpenPrice(temKline.getClosePrice());
                item.setClosePrice(temKline.getClosePrice());
                item.setHighestPrice(temKline.getClosePrice());
                item.setLowestPrice(temKline.getClosePrice());
            }
            JSONArray group = new JSONArray();
            group.add(0,item.getTime());
            group.add(1,item.getOpenPrice());
            group.add(2,item.getHighestPrice());
            group.add(3,item.getLowestPrice());
            group.add(4,item.getClosePrice());
            group.add(5,item.getVolume());
            array.add(group);

            temKline = item;
        }
        return array;
    }
}
