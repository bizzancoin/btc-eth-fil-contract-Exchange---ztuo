package com.bizzan.bitrade.controller.option;

import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.entity.ContractOption;
import com.bizzan.bitrade.entity.ContractOptionOrder;
import com.bizzan.bitrade.entity.QContractOption;
import com.bizzan.bitrade.entity.QContractOptionOrder;
import com.bizzan.bitrade.model.screen.ContractOptionOrderScreen;
import com.bizzan.bitrade.model.screen.ContractOptionScreen;
import com.bizzan.bitrade.service.ContractOptionOrderService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/option/order")
@Slf4j
public class ContractOptionOrderController extends BaseAdminController {

    @Autowired
    private ContractOptionOrderService contractOptionOrderService;

    /**
     * 分页查询所有订单
     * @param pageModel
     * @param screen
     * @return
     */
    @RequiresPermissions("option:order:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约订单 列表")
    public MessageResult detail(
            PageModel pageModel,
            ContractOptionOrderScreen screen) {
        if (pageModel.getDirection() == null && pageModel.getProperty() == null) {
            ArrayList<Sort.Direction> directions = new ArrayList<>();
            directions.add(Sort.Direction.DESC);
            pageModel.setDirection(directions);
            List<String> property = new ArrayList<>();
            property.add("createTime");
            pageModel.setProperty(property);
        }
        //获取查询条件
        Predicate predicate = getPredicate(screen);
        Page<ContractOptionOrder> all = contractOptionOrderService.findAll(predicate, pageModel.getPageable());
        return success(all);
    }

    private Predicate getPredicate(ContractOptionOrderScreen screen) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        QContractOptionOrder qContractOptionOrder = QContractOptionOrder.contractOptionOrder;
        if (StringUtils.isNotBlank(screen.getSymbol())) {
            booleanExpressions.add(qContractOptionOrder.symbol.eq(screen.getSymbol()));
        }
        if (screen.getBetAmount() != null) {
            booleanExpressions.add(qContractOptionOrder.betAmount.gt(screen.getBetAmount()));
        }
        if (screen.getRewardAmount() != null) {
            booleanExpressions.add(qContractOptionOrder.rewardAmount.gt(screen.getRewardAmount()));
        }
        if (screen.getMemberId() != null) {
            booleanExpressions.add(qContractOptionOrder.memberId.eq(screen.getMemberId()));
        }

        return PredicateUtils.getPredicate(booleanExpressions);
    }

    /**
     * 某期合约所有订单
     * @param optionId
     * @return
     */
    @RequiresPermissions("option:order:option-list")
    @PostMapping("option-list")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约订单 列表")
    public MessageResult queryByOptionId(Long optionId){
        List<ContractOptionOrder> list = contractOptionOrderService.findByOptionId(optionId);
        return success(list);
    }

    /**
     * 某用户合约所有订单
     * @param memberId
     * @return
     */
    @RequiresPermissions("option:order:member-list")
    @PostMapping("member-list")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约订单 列表")
    public MessageResult queryByMember(Long memberId){
        List<ContractOptionOrder> list = contractOptionOrderService.findByMemberId(memberId);
        return success(list);
    }
    @RequiresPermissions("option:order:setOptionOrder")
    @PostMapping("setOptionOrder")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "设置期权合约")
    public MessageResult setOptionOrder(Long memberId,Integer optionNo,Short optionNoChange,Short directionChange){
        return contractOptionOrderService.setOptionOrder(memberId,optionNo,optionNoChange,directionChange);

    }

}
