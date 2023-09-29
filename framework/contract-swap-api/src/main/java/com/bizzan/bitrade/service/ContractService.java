package com.bizzan.bitrade.service;

import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.service.Base.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ContractService  extends BaseService {

    @Autowired
    private ContractCoinMatchFactory contractCoinMatchFactory; // 合约引擎工厂

    @Autowired
    private ContractCoinService contractCoinService; // 合约币种交易对服务

    @Autowired
    private ContractOrderEntrustService contractOrderEntrustService; // 合约委托订单服务
}
