package com.bizzan.bitrade.controller.finance;


import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.AdvertiseControlStatus;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.controller.system.CoinController;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.QMember;
import com.bizzan.bitrade.entity.QMemberDeposit;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.model.screen.MemberDepositScreen;
import com.bizzan.bitrade.service.LocaleMessageSourceService;
import com.bizzan.bitrade.service.MemberDepositService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.vo.MemberDepositVO;
import com.querydsl.core.types.dsl.BooleanExpression;

import lombok.extern.slf4j.Slf4j;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

@RestController
@RequestMapping("finance/member-deposit")
@Slf4j
public class MemberDepositRecordController extends BaseAdminController {
	private Logger logger = LoggerFactory.getLogger(BaseAdminController.class);
    @Autowired
    private MemberDepositService memberDepositService;
    @Autowired
    private LocaleMessageSourceService messageSource;
    @Autowired
    private RestTemplate restTemplate;

    /**
     * 充币记录
     *
     * @param pageModel
     * @param screen
     * @return
     */
    @RequiresPermissions("finance:member-deposit:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.FINANCE, operation = "充币记录")
    public MessageResult page(PageModel pageModel, MemberDepositScreen screen) {
        List<BooleanExpression> predicates = new ArrayList<>();
        predicates.add(QMember.member.id.eq(QMemberDeposit.memberDeposit.memberId));
        if (!StringUtils.isEmpty(screen.getUnit())) {
            predicates.add((QMemberDeposit.memberDeposit.unit.equalsIgnoreCase(screen.getUnit())));
        }
        if (!StringUtils.isEmpty(screen.getAddress())) {
            predicates.add((QMemberDeposit.memberDeposit.address.eq(screen.getAddress())));
        }
        if (!StringUtils.isEmpty(screen.getAccount())) {
            predicates.add(QMember.member.username.like("%" + screen.getAccount() + "%")
                    .or(QMember.member.realName.like("%" + screen.getAccount() + "%")));
        }
        Page<MemberDepositVO> page = memberDepositService.page(predicates, pageModel);
        
        List<MemberDepositVO> list = page.getContent();
//        for(MemberDepositVO item : list) {
//        	if(!StringUtils.isEmpty(item.getAddress())) {
//        		String url = "http://SERVICE-RPC-" + item.getUnit() + "/rpc/balance/" + item.getAddress();
//        		item.setWalletBalance(getRPCWalletBalance(url, item.getUnit()));
//        	}else {
//        		item.setWalletBalance(BigDecimal.ZERO);
//        	}
//        }
        return success(messageSource.getMessage("SUCCESS"), page);
    }

    /**
     * 查询是否有未处理的充值记录
     * @return
     */
    @RequiresPermissions("finance:member-deposit:page-query")
    @PostMapping("count-not-handle")
    @AccessLog(module = AdminModule.FINANCE, operation = "查询是否有未处理的充值记录")
    public MessageResult countNotHandle() {
        Integer count = memberDepositService.countNotHandle();
        return success(messageSource.getMessage("SUCCESS"), count);
    }
    
    private BigDecimal getRPCWalletBalance(String url, String unit) {
        try {
            ResponseEntity<MessageResult> result = restTemplate.getForEntity(url, MessageResult.class);
            log.info("result={}", result);
            if (result.getStatusCode().value() == 200) {
                MessageResult mr = result.getBody();
                if (mr.getCode() == 0) {
                    String balance = mr.getData().toString();
                    BigDecimal bigDecimal = new BigDecimal(balance);
                    log.info(unit + "(" + url + ")" + messageSource.getMessage("HOT_WALLET_BALANCE"), bigDecimal);
                    return bigDecimal;
                }
            }
        } catch (IllegalStateException e) {
            log.error("error={}", e);
            return new BigDecimal("0");
        } catch (Exception e) {
            log.error("error={}", e);
            return new BigDecimal("0");
        }
        return new BigDecimal("0");
    }

    /**
     * 代理商邀请用户资产记录
     * @param pageModel
     * @param screen
     * @param meberId 代理商ID
     * @return
     */
    @RequiresPermissions("finance:member-deposit:superdeposit-page-query")
    @PostMapping(value = "/superdeposit-page-query")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult pageSuperDeposit(PageModel pageModel, MemberDepositScreen screen, Long meberId) {

        List<BooleanExpression> predicates = new ArrayList<>();
        predicates.add(QMember.member.id.eq(QMemberDeposit.memberDeposit.memberId)); // 联表查询条件
        predicates.add(QMember.member.inviterId.eq(meberId)); // 联表查询条件

        if (!StringUtils.isEmpty(screen.getUnit())) {
            predicates.add((QMemberDeposit.memberDeposit.unit.equalsIgnoreCase(screen.getUnit())));
        }
        if (!StringUtils.isEmpty(screen.getAddress())) {
            predicates.add((QMemberDeposit.memberDeposit.address.eq(screen.getAddress())));
        }
        if (!StringUtils.isEmpty(screen.getAccount())) {
            predicates.add(QMember.member.username.like("%" + screen.getAccount() + "%")
                    .or(QMember.member.realName.like("%" + screen.getAccount() + "%")));
        }
        Page<MemberDepositVO> page = memberDepositService.page(predicates, pageModel);

        List<MemberDepositVO> list = page.getContent();

        return success(messageSource.getMessage("SUCCESS"), page);
    }

    @RequiresPermissions("finance:member-deposit:audit")
    @PostMapping("audit")
    @AccessLog(module = AdminModule.FINANCE, operation = "审核充值")
    public MessageResult audit(
            @RequestParam(value = "id") Long id,
            @RequestParam(value = "status") Integer status) {
        memberDepositService.audit(id,status);
        return success(messageSource.getMessage("SUCCESS"));
    }
}
