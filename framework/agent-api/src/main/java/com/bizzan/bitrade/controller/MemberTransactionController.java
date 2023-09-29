package com.bizzan.bitrade.controller;

import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.constant.TransactionType;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.MemberTransaction;
import com.bizzan.bitrade.entity.QMember;
import com.bizzan.bitrade.entity.QMemberTransaction;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.es.ESUtils;
import com.bizzan.bitrade.controller.screen.MemberTransactionScreen;
import com.bizzan.bitrade.controller.screen.MemberTransaction2ESVO;
import com.bizzan.bitrade.service.LocaleMessageSourceService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.service.MemberTransactionService;
import com.bizzan.bitrade.util.DateUtil;
import com.bizzan.bitrade.util.FileUtil;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.vo.MemberTransactionVO;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;
import static org.springframework.util.Assert.notNull;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @description 交易记录
 * @date 2019/1/17 17:07
 */
@RestController
@RequestMapping("transactions")
@Slf4j
public class MemberTransactionController extends BaseController {

    @Autowired
    private EntityManager entityManager;

    //查询工厂实体
    private JPAQueryFactory queryFactory;
    @Autowired
    private LocaleMessageSourceService messageSource;

    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberTransactionService memberTransactionService;
    @Autowired
    private ESUtils esUtils;

    @RequestMapping(value = "/detail")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult detail(@RequestParam(value = "id") Long id) {
        MemberTransaction memberTransaction = memberTransactionService.findOne(id);
        notNull(memberTransaction, "validate id!");
        return success(memberTransaction);
    }

    @RequestMapping(value = "/page-query")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult pageQuery(
            PageModel pageModel,
            MemberTransactionScreen screen,
            @SessionAttribute(SESSION_MEMBER) AuthMember user) {

        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }

        List<Predicate> predicates = new ArrayList<>();

        predicates.add(QMember.member.inviterId.eq(checkMember.getId()));

        if(screen.getMemberId()!=null) {
            predicates.add((QMember.member.id.eq(screen.getMemberId())));
        }
        if (!StringUtils.isEmpty(screen.getAccount())) {
            predicates.add(QMember.member.username.like("%"+screen.getAccount()+"%")
                        .or(QMember.member.realName.like("%"+screen.getAccount()+"%")));
        }
        if (screen.getStartTime() != null) {
            predicates.add(QMemberTransaction.memberTransaction.createTime.goe(screen.getStartTime()));
        }
        if (screen.getEndTime() != null){
            predicates.add(QMemberTransaction.memberTransaction.createTime.lt(DateUtil.dateAddDay(screen.getEndTime(),1)));
        }
        if (screen.getType() != null) {
            predicates.add(QMemberTransaction.memberTransaction.type.eq(screen.getType()));
        }

        if(screen.getMinMoney()!=null) {
            predicates.add(QMemberTransaction.memberTransaction.amount.goe(screen.getMinMoney()));
        }

        if(screen.getMaxMoney()!=null) {
            predicates.add(QMemberTransaction.memberTransaction.amount.loe(screen.getMaxMoney()));
        }

        if(screen.getMinFee()!=null) {
            predicates.add(QMemberTransaction.memberTransaction.fee.goe(screen.getMinFee()));
        }

        if(screen.getMaxFee()!=null) {
            predicates.add(QMemberTransaction.memberTransaction.fee.loe(screen.getMaxFee()));
        }

        if(screen.getSymbol() != null) {
            predicates.add(QMemberTransaction.memberTransaction.symbol.eq(screen.getSymbol()));
        }

        Page<MemberTransactionVO> results = memberTransactionService.joinFind(predicates, pageModel);

        return success(results);
    }
}
