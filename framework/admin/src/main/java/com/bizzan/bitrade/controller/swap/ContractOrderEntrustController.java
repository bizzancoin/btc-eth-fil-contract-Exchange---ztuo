package com.bizzan.bitrade.controller.swap;

import com.alibaba.fastjson.JSON;
import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.model.screen.ContractOptionOrderScreen;
import com.bizzan.bitrade.model.screen.ContractOrderEntrustScreen;
import com.bizzan.bitrade.service.ContractOrderEntrustService;
import com.bizzan.bitrade.service.MemberService;
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
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/swap/order")
@Slf4j
public class ContractOrderEntrustController  extends BaseAdminController {
    @Autowired
    private ContractOrderEntrustService contractOrderEntrustService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    /**
     * 分页查询
     * @param pageModel
     * @param screen
     * @return
     */
    @RequiresPermissions("swap:order:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "期权合约订单 列表")
    public MessageResult pageQuery(
            PageModel pageModel,
            ContractOrderEntrustScreen screen) {
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
        Page<ContractOrderEntrust> all = contractOrderEntrustService.findAll(predicate, pageModel.getPageable());
        return success(all);
    }

    private Predicate getPredicate(ContractOrderEntrustScreen screen) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        QContractOrderEntrust qContractOrderEntrust = QContractOrderEntrust.contractOrderEntrust;
        if (screen.getContractId() != null) {
            booleanExpressions.add(qContractOrderEntrust.contractId.eq(screen.getContractId()));
        }
        if(screen.getStartTime() != null) {
            booleanExpressions.add(qContractOrderEntrust.createTime.goe(screen.getStartTime().getTime()));
        }
        if(screen.getEndTime() != null) {
            booleanExpressions.add(qContractOrderEntrust.createTime.loe(screen.getEndTime().getTime()));
        }
        if(screen.getDirection() != null) {
            booleanExpressions.add(qContractOrderEntrust.direction.eq(screen.getDirection()));
        }
        if(screen.getEntrustType() != null) {
            booleanExpressions.add(qContractOrderEntrust.entrustType.eq(screen.getEntrustType()));
        }
        if(screen.getIsBlast() != null) {
            booleanExpressions.add(qContractOrderEntrust.isBlast.eq(screen.getIsBlast()));
        }
        if(screen.getIsFromSpot() != null) {
            booleanExpressions.add(qContractOrderEntrust.isFromSpot.eq(screen.getIsFromSpot()));
        }
        if(screen.getMemberId() != null) {
            booleanExpressions.add(qContractOrderEntrust.memberId.eq(screen.getMemberId()));
        }
        if(screen.getStatus() != null) {
            booleanExpressions.add(qContractOrderEntrust.status.eq(screen.getStatus()));
        }
        if(screen.getType() != null) {
            booleanExpressions.add(qContractOrderEntrust.type.eq(screen.getType()));
        }
        if(screen.getVolume() != null) {
            booleanExpressions.add(qContractOrderEntrust.volume.goe(screen.getVolume()));
        }
        if(StringUtils.isNotEmpty(screen.getPhone())) {
            Member member = memberService.findByPhone(screen.getPhone());
            booleanExpressions.add(qContractOrderEntrust.memberId.eq(member.getId()));
        }
        if(StringUtils.isNotEmpty(screen.getEmail())) {
            Member member = memberService.findByEmail(screen.getEmail());
            booleanExpressions.add(qContractOrderEntrust.memberId.eq(member.getId()));
        }
        if(screen.getProfitAndLoss() != null) {
            booleanExpressions.add(qContractOrderEntrust.profitAndLoss.gt(screen.getProfitAndLoss()));
        }

        return PredicateUtils.getPredicate(booleanExpressions);
    }

    /**
     * 撤销委托
     * @param orderId
     * @return
     */
    @RequiresPermissions("swap:order:cancel")
    @PostMapping("cancel")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "永续合约 撤单")
    public MessageResult cancelOrder(Long orderId) {
        ContractOrderEntrust order = contractOrderEntrustService.findOne(orderId);
        if(order == null) {
            return MessageResult.error("撤销委托失败");
        }
        if(order.getStatus() != ContractOrderEntrustStatus.ENTRUST_ING) {
            return MessageResult.error("委托状态错误");
        }
        // 发送消息至Exchange系统
        kafkaTemplate.send("swap-order-cancel", JSON.toJSONString(order));

        log.info(">>>>>>>>>>订单撤销提交完成>>>>>>>>>>");
        return MessageResult.success("操作成功");
    }
}
