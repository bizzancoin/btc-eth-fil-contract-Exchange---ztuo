package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.screen.ContractRewardRecordScreen;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.ContractRewardRecordService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.util.DateUtil;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.bizzan.bitrade.vo.MemberTransactionVO;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.ArrayList;
import java.util.List;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

/**
 * @author sulinxin
 */
@RestController
@RequestMapping("transactionRebates")
@Slf4j
public class MemberTransactionRebateController extends BaseController{

    @Autowired
    private MemberService memberService;
    @Autowired
    private ContractRewardRecordService contractRewardRecordService;

    @RequestMapping(value = "/page-query")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult pageQuery(
            PageModel pageModel,
            ContractRewardRecordScreen screen,
            @SessionAttribute(SESSION_MEMBER) AuthMember user) {

        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }

        if (pageModel.getDirection() == null && pageModel.getProperty() == null) {
            ArrayList<Sort.Direction> directions = new ArrayList<>();
            directions.add(Sort.Direction.DESC);
            pageModel.setDirection(directions);
            List<String> property = new ArrayList<>();
            property.add("createTime");
            pageModel.setProperty(property);
        }
        //获取查询条件
        Predicate predicate = getPredicate(screen,checkMember.getId());

        Page<ContractRewardRecord> results = contractRewardRecordService.findAll(predicate, pageModel.getPageable());

        return success(results);
    }

    private Predicate getPredicate(ContractRewardRecordScreen screen,Long id) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        QContractRewardRecord qContractRewardRecord = QContractRewardRecord.contractRewardRecord;
        booleanExpressions.add((qContractRewardRecord.member.id.eq(id)));
        if(screen.getMemberId()!=null) {
            booleanExpressions.add((qContractRewardRecord.fromMember.id.eq(screen.getMemberId())));
        }
        if (screen.getStartTime() != null) {
            booleanExpressions.add(qContractRewardRecord.createTime.goe(screen.getStartTime()));
        }
        if (screen.getEndTime() != null){
            booleanExpressions.add(qContractRewardRecord.createTime.lt(DateUtil.dateAddDay(screen.getEndTime(),1)));
        }
        if (screen.getType() != null) {
            booleanExpressions.add(qContractRewardRecord.type.eq(screen.getType()));
        }
        return PredicateUtils.getPredicate(booleanExpressions);
    }
}
