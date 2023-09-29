package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.*;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.es.ESUtils;
import com.bizzan.bitrade.controller.screen.WithdrawRecordScreen;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.vendor.provider.SMSProvider;
import com.bizzan.bitrade.vo.WithdrawRecordVO;
import com.querydsl.core.types.Predicate;
import com.sparkframework.security.Encrypt;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.bizzan.bitrade.constant.BooleanEnum.IS_FALSE;
import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;
import static com.bizzan.bitrade.constant.WithdrawStatus.*;
import static org.springframework.util.Assert.isTrue;
import static org.springframework.util.Assert.notNull;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @description 提现
 * @date 2019/2/25 11:22
 */
@RestController
@RequestMapping("withdraw")
@Slf4j
public class WithdrawRecordController extends BaseController {
    @Autowired
    private WithdrawRecordService withdrawRecordService;

    @Autowired
    private MemberWalletService memberWalletService;

    @Autowired
    private MemberTransactionService memberTransactionService;

    @Autowired
    private LocaleMessageSourceService messageSource;
    @Autowired
    private ESUtils esUtils;

    @Autowired
    private SMSProvider smsProvider;
    
    @Autowired
    private MemberService memberService;

    @RequestMapping(value = "/page-query")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult pageQuery(
            PageModel pageModel,
            WithdrawRecordScreen screen,
            @SessionAttribute(SESSION_MEMBER) AuthMember user) {

        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }

        List<Predicate> predicates = new ArrayList<>();
        predicates.add(QWithdrawRecord.withdrawRecord.memberId.eq(QMember.member.id));
        predicates.add(QMember.member.inviterId.eq(checkMember.getId()));

        if (screen.getMemberId() != null) {
            predicates.add(QWithdrawRecord.withdrawRecord.memberId.eq(screen.getMemberId()));
        }

        if ( !StringUtils.isEmpty(screen.getMobilePhone())){
            Member member = memberService.findByPhone(screen.getMobilePhone());
            predicates.add(QWithdrawRecord.withdrawRecord.memberId.eq(member.getId()));
        }

        if ( !StringUtils.isEmpty(screen.getOrderSn())){
            predicates.add(QWithdrawRecord.withdrawRecord.transactionNumber.eq(screen.getOrderSn()));
        }

        if (screen.getStatus() != null) {
            predicates.add(QWithdrawRecord.withdrawRecord.status.eq(screen.getStatus()));
        }

        if (screen.getIsAuto() != null) {
            predicates.add(QWithdrawRecord.withdrawRecord.isAuto.eq(screen.getIsAuto()));
        }

        if (!StringUtils.isEmpty(screen.getAddress())) {
            predicates.add(QWithdrawRecord.withdrawRecord.address.eq(screen.getAddress()));
        }

        if (!StringUtils.isEmpty(screen.getUnit())) {
            predicates.add(QWithdrawRecord.withdrawRecord.coin.unit.equalsIgnoreCase(screen.getUnit()));
        }

        if (!StringUtils.isEmpty(screen.getAccount())) {
            predicates.add(QMember.member.username.like("%" + screen.getAccount() + "%")
                    .or(QMember.member.realName.like("%" + screen.getAccount() + "%")));
        }

        Page<WithdrawRecordVO> pageListMapResult = withdrawRecordService.joinFind(predicates, pageModel);
        return success(pageListMapResult);
    }

    @GetMapping("/{id}")
    @RequiresPermissions("finance:withdraw-record:detail")
    @AccessLog(module = AdminModule.FINANCE, operation = "提现记录WithdrawRecord 详情")
    public MessageResult detail(@PathVariable("id") Long id) {
        WithdrawRecord withdrawRecord = withdrawRecordService.findOne(id);
        notNull(withdrawRecord, messageSource.getMessage("NO_DATA"));
        return success(withdrawRecord);
    }
}
