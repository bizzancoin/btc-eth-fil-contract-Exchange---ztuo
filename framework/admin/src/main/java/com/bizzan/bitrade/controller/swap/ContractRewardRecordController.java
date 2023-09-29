package com.bizzan.bitrade.controller.swap;

import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.entity.ContractRewardRecord;
import com.bizzan.bitrade.entity.QContractRewardRecord;
import com.bizzan.bitrade.model.screen.ContractRewardRecordScreen;
import com.bizzan.bitrade.service.ContractRewardRecordService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.bizzan.bitrade.vo.RewardRecordVO;
import com.bizzan.bitrade.vo.RewardSetVo;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
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
@RequestMapping("/swap/reward")
@Slf4j
public class ContractRewardRecordController extends BaseAdminController {
    @Autowired
    private ContractRewardRecordService contractRewardRecordService;

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
    @RequiresPermissions("swap:reward:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "永续合约返佣订单 列表")
    public MessageResult pageQuery(
            PageModel pageModel,
            ContractRewardRecordScreen screen) {
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
        Page<ContractRewardRecord> all = contractRewardRecordService.findAll(predicate, pageModel.getPageable());
        return success(all);
    }

    /**
     * 返佣设置查询
     * @return
     */
    @RequiresPermissions("swap:reward:rewardSets")
    @PostMapping("rewardSets")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "返佣设置查询")
    public MessageResult rewardSets() {
        //获取查询条件
        RewardSetVo vo = contractRewardRecordService.findAllRewardSetVo();
        return success(vo);
    }

    /**
     * 清除返佣设置缓存
     * @return
     */
    @RequiresPermissions("swap:reward:clear")
    @PostMapping("clear")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "清除返佣设置缓存")
    public MessageResult clear() {
        //获取查询条件
        contractRewardRecordService.clearAllRewardSetVo();
        return success();
    }

    private Predicate getPredicate(ContractRewardRecordScreen screen) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        QContractRewardRecord qContractRewardRecord = QContractRewardRecord.contractRewardRecord;
        if(screen.getStartTime() != null) {
            booleanExpressions.add(qContractRewardRecord.createTime.goe(screen.getStartTime()));
        }
        if(screen.getEndTime() != null) {
            booleanExpressions.add(qContractRewardRecord.createTime.loe(screen.getEndTime()));
        }
        if(screen.getMemberId() != null) {
            booleanExpressions.add(qContractRewardRecord.member.id.eq(screen.getMemberId()));
        }
        if(screen.getType() != null) {
            booleanExpressions.add(qContractRewardRecord.type.eq(screen.getType()));
        }

        return PredicateUtils.getPredicate(booleanExpressions);
    }
}
