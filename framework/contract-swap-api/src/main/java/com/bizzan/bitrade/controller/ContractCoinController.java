package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.service.ContractCoinService;
import com.bizzan.bitrade.service.ContractOrderEntrustService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bizzan.bitrade.util.MessageResult;

import java.util.List;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @Title: ${file_name}
 * @Description:
 * @date 2019/4/1816:54
            */
@RestController
@RequestMapping("coin")
public class ContractCoinController extends BaseController {

    @Autowired
    private ContractCoinService coinService;

    @Autowired
    private ContractOrderEntrustService orderEntrustService;

    @Autowired
    private ContractCoinMatchFactory factory;

    //获取基币
    @RequestMapping("base-symbol")
    public MessageResult baseSymbol() {
        List<String> baseSymbol = coinService.getBaseSymbol();
        if (baseSymbol != null && baseSymbol.size() > 0) {
            return success(baseSymbol);
        }
        return error("baseSymbol null");
    }

    /**
     * 获取合约信息
     * @param symbol
     * @return
     */
    @RequestMapping("coin-info")
    public MessageResult coinInfo(String symbol) {

        ContractCoin coin = coinService.findBySymbol(symbol);
        if(coin == null) {
            return error("合约交易对不存在");
        }
        return success(coin);
    }

}
