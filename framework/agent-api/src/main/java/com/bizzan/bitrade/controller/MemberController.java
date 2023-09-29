package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.*;
import com.bizzan.bitrade.dto.MemberDTO;
import com.bizzan.bitrade.dto.MemberWalletDTO;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.controller.screen.MemberScreen;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.FileUtil;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

import static com.bizzan.bitrade.constant.CertifiedBusinessStatus.*;
import static com.bizzan.bitrade.constant.MemberLevelEnum.IDENTIFICATION;
import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;
import static com.bizzan.bitrade.entity.QMember.member;
import static org.springframework.util.Assert.isTrue;
import static org.springframework.util.Assert.notNull;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @description 后台管理会员
 * @date 2019/12/25 16:50
 */
@RestController
@RequestMapping("member")
@Slf4j
public class MemberController extends BaseController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberWalletService memberWalletService;

    @Autowired
    private BusinessAuthApplyService businessAuthApplyService;

    @Autowired
    private DepositRecordService depositRecordService;

    @Autowired
    private LocaleMessageSourceService messageSource;

    @RequiresPermissions("member:all")
    @PostMapping("all")
    @AccessLog(module = AdminModule.MEMBER, operation = "所有会员Member")
    public MessageResult all() {
        List<Member> all = memberService.findAll();
        if (all != null && all.size() > 0) {
            return success(all);
        }
        return error(messageSource.getMessage("REQUEST_FAILED"));
    }

    @RequestMapping(value = "/detail")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult detail(@RequestParam("id") Long id, @SessionAttribute(SESSION_MEMBER) AuthMember user) {
        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }

        Member member = memberService.findOne(id);
        notNull(member, "validate id!");
        List<MemberWallet> list = memberWalletService.findAllByMemberId(member.getId());
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setMember(member);
        memberDTO.setList(list);
        return success(memberDTO);
    }

    /**
     * 分页获取用户列表
     * @param pageModel
     * @param screen
     * @param user
     * @return
     */
    @RequestMapping(value = "/page-query")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult page(
            PageModel pageModel,
            MemberScreen screen,
            @SessionAttribute(SESSION_MEMBER) AuthMember user) {
        // 检查用户是否是代理商
        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }
        Predicate predicate = getPredicate(screen, user.getId());
        Page<Member> all = memberService.findAll(predicate, pageModel.getPageable());
        return success(all);
    }

    /**
     * 获取指定用户资产列表
     * @param user
     * @param memberId
     * @return
     */
    @RequestMapping(value = "/assets-list")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult getUserAssets(
            @SessionAttribute(SESSION_MEMBER) AuthMember user,
            Long memberId) {
        List<MemberWallet> list = memberWalletService.findAllByMemberId(memberId);

        return success(messageSource.getMessage("SUCCESS"), list);
    }

    @RequestMapping(value = "/alter-superpartner")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult alterSuperPartner(
            @SessionAttribute(SESSION_MEMBER) AuthMember user,
            @RequestParam("superPartner") String superPartner,
            @RequestParam("memberId") Long memberId) {
        // 对比等级，等级低的不能修改下面的用户为更高等级
        Member currentUser = memberService.findOne(user.getId());
        if(superPartner.compareTo(currentUser.getSuperPartner()) <= 0) {
            return error("您无法设置比您自身等级高的等级！");
        }
        Member member = memberService.findOne(memberId);
        member.setSuperPartner(superPartner);
        memberService.save(member);
        return success(messageSource.getMessage("SUCCESS"));
    }

    private Predicate getPredicate(MemberScreen screen, Long userId) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        if (screen.getStatus() != null) {
            booleanExpressions.add(member.certifiedBusinessStatus.eq(screen.getStatus()));
        }
        if (screen.getStartTime() != null) {
            booleanExpressions.add(member.registrationTime.goe(screen.getStartTime()));
        }
        if (screen.getEndTime() != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(screen.getEndTime());
            calendar.add(Calendar.DAY_OF_YEAR, 1);
            booleanExpressions.add(member.registrationTime.lt(calendar.getTime()));
        }

        if (!StringUtils.isEmpty(screen.getAccount())) {
            booleanExpressions.add(member.username.like("%" + screen.getAccount() + "%")
                    .or(member.mobilePhone.like(screen.getAccount() + "%"))
                    .or(member.email.like(screen.getAccount() + "%"))
                    .or(member.id.eq(Long.valueOf(screen.getAccount())))
                    .or(member.realName.like("%" + screen.getAccount() + "%")));
        }
        // 筛选过滤出我邀请的人
        booleanExpressions.add(member.inviterId.eq(userId));
        if (screen.getCommonStatus() != null) {
            booleanExpressions.add(member.status.eq(screen.getCommonStatus()));
        }
        return PredicateUtils.getPredicate(booleanExpressions);
    }

    @RequiresPermissions("member:out-excel")
    @GetMapping("out-excel")
    @AccessLog(module = AdminModule.MEMBER, operation = "导出会员Member Excel")
    public MessageResult outExcel(
            @RequestParam(value = "startTime", required = false) Date startTime,
            @RequestParam(value = "endTime", required = false) Date endTime,
            @RequestParam(value = "account", required = false) String account,
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<BooleanExpression> booleanExpressionList = getBooleanExpressionList(startTime, endTime, account, null);
        List list = memberService.queryWhereOrPage(booleanExpressionList, null, null).getContent();
        return new FileUtil().exportExcel(request, response, list, "member");
    }

    // 获得条件
    private List<BooleanExpression> getBooleanExpressionList(
            Date startTime, Date endTime, String account, CertifiedBusinessStatus status) {
        List<BooleanExpression> booleanExpressionList = new ArrayList();
        if (status != null) {
            booleanExpressionList.add(member.certifiedBusinessStatus.eq(status));
        }
        if (startTime != null) {
            booleanExpressionList.add(member.registrationTime.gt(startTime));
        }
        if (endTime != null) {
            booleanExpressionList.add(member.registrationTime.lt(endTime));
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(account)) {
            booleanExpressionList.add(member.username.like("%" + account + "%")
                    .or(member.mobilePhone.like(account + "%"))
                    .or(member.email.like(account + "%")));
        }
        return booleanExpressionList;
    }
}
