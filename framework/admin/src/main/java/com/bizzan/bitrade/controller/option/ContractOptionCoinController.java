package com.bizzan.bitrade.controller.option;

import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.BooleanEnum;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.entity.ContractOptionCoin;
import com.bizzan.bitrade.service.ContractOptionCoinService;
import com.bizzan.bitrade.util.MessageResult;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/option-coin")
@Slf4j
public class ContractOptionCoinController extends BaseAdminController {

    @Autowired
    private ContractOptionCoinService contractOptionCoinService;

    /**
     * 获取期权合约交易对列表
     * @param pageModel
     * @return
     */
    @RequiresPermissions("option-coin:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约交易对 列表")
    public MessageResult list(
            PageModel pageModel) {

        if (pageModel.getProperty() == null) {
            List<String> list = new ArrayList<>();
            list.add("createTime");
            List<Sort.Direction> directions = new ArrayList<>();
            directions.add(Sort.Direction.DESC);
            pageModel.setProperty(list);
            pageModel.setDirection(directions);
        }
        Page<ContractOptionCoin> coinList = contractOptionCoinService.findAll(null, pageModel.getPageable());

        return success(coinList);
    }

    /**
     * 获取期权合约交易对详情
     * @param symbol
     * @return
     */
    @RequiresPermissions("option-coin:detail")
    @PostMapping("detail")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约交易对 详情")
    public MessageResult detail(@RequestParam(value = "symbol") String symbol) {
        ContractOptionCoin coin = contractOptionCoinService.findOne(symbol);
        if(coin == null){
            return error("交易对不存在");
        }
        return success(coin);
    }

    /**
     * 添加期权合约交易对
     * @param contractOptionCoin
     * @return
     */
    @RequiresPermissions("option-coin:add")
    @PostMapping("add")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约交易对 新增")
    public MessageResult add(@Valid ContractOptionCoin contractOptionCoin) {
        ContractOptionCoin coin = contractOptionCoinService.findOne(contractOptionCoin.getSymbol());
        if(coin != null) {
            return error("添加失败！交易对 " + contractOptionCoin.getSymbol() + " 已存在！");
        }
        if(contractOptionCoin.getCloseTimeGap() <= 0 || contractOptionCoin.getOpenTimeGap() <= 0) {
            return error("下注间隔时间或开奖间隔时间必须大于0");
        }
        contractOptionCoin.setCreateTime(new Date());
        contractOptionCoin.setTotalProfit(BigDecimal.ZERO);
        contractOptionCoin = contractOptionCoinService.save(contractOptionCoin);
        return MessageResult.getSuccessInstance("添加交易对成功！", coin);
    }

    /**
     * 修改期权合约交易对
     * @param symbol
     * @param enable
     * @param enableBuy
     * @param enableSell
     * @param visible
     * @param sort
     * @param amount
     * @param feePercent
     * @param winFeePercent
     * @param openTimeGap
     * @param closeTimeGap
     * @param tiedType
     * @return
     */
    @RequiresPermissions("option-coin:alter")
    @PostMapping("alter")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约交易对 新增")
    public MessageResult alter(
            @RequestParam("symbol") String symbol,
            @RequestParam(value = "enable", required = false) Integer enable, // 上下架（1:上,2）
            @RequestParam(value = "enableBuy", required = false) Integer enableBuy, // 是否可买（1:是,0:否）
            @RequestParam(value = "enableSell", required = false) Integer enableSell, // 是否可卖（1:是,0:否）
            @RequestParam(value = "visible", required = false) Integer visible, // 是否显示（1:是,2）
            @RequestParam(value = "sort", required = false) Integer sort, // 排序
            @RequestParam(value = "amount", required = false) String amount, // 允许投注数量
            @RequestParam(value = "feePercent", required = false) BigDecimal feePercent,
            @RequestParam(value = "oods", required = false) BigDecimal oods,
            @RequestParam(value = "winFeePercent", required = false) BigDecimal winFeePercent,
            @RequestParam(value = "openTimeGap", required = false) Integer openTimeGap,
            @RequestParam(value = "closeTimeGap", required = false) Integer closeTimeGap,
            @RequestParam(value = "initBuyReward", required = false) BigDecimal initBuyReward,
            @RequestParam(value = "initSellReward", required = false) BigDecimal initSellReward,
            @RequestParam(value = "tiedType", required = false) Integer tiedType
    ) {
        ContractOptionCoin coin = contractOptionCoinService.findOne(symbol);
        if(coin == null) {
            return error("交易对 " + coin.getSymbol() + " 不存在！");
        }

        if(enable != null) coin.setEnable(enable);
        if(enableBuy != null) coin.setEnableBuy(enableBuy == 1 ? BooleanEnum.IS_TRUE : BooleanEnum.IS_FALSE);
        if(enableSell != null) coin.setEnableSell(enableSell == 1 ? BooleanEnum.IS_TRUE : BooleanEnum.IS_FALSE);
        if(visible != null) coin.setVisible(visible);
        if(sort != null) coin.setSort(sort);
        if(amount != null) coin.setAmount(amount);
        if(feePercent != null) coin.setFeePercent(feePercent);
        if(winFeePercent != null) coin.setWinFeePercent(winFeePercent);
        if(openTimeGap != null) coin.setOpenTimeGap(openTimeGap);
        if(closeTimeGap != null) coin.setCloseTimeGap(closeTimeGap);
        if(tiedType != null) coin.setTiedType(tiedType);
        if(initBuyReward != null) coin.setInitBuyReward(initBuyReward);
        if(initSellReward != null) coin.setInitSellReward(initSellReward);
        if(oods != null) coin.setOods(oods);

        contractOptionCoinService.save(coin);
        return success("保存成功");
    }
}
