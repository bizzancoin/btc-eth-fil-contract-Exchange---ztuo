package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.dao.MemberWeightUpperDao;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.MemberWeightUpper;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.ContractRewardRecordService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.service.MemberWeightUpperService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.vo.RewardSetVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import javax.annotation.Resource;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

/**
 * @author sulinxin
 */
@RestController
@RequestMapping("transactionRebateSet")
public class MemberTransactionRebateSetController extends BaseController{

    @Resource
    private MemberService memberService;
    @Resource
    private MemberWeightUpperService memberWeightUpperService;
    @Resource
    private ContractRewardRecordService contractRewardRecordService;
    @Autowired
    private MemberWeightUpperDao memberWeightUpperDao;

    @RequestMapping(value = "query")
    public MessageResult query(
            @SessionAttribute(SESSION_MEMBER) AuthMember user
    ) {
        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }
        RewardSetVo vo = contractRewardRecordService.findRewardSetVoById(user.getId());
        return success(vo);
    }

    @RequestMapping(value = "clear")
    public MessageResult clear(
            @SessionAttribute(SESSION_MEMBER) AuthMember user
    ){
        Member checkMember = memberService.findOne(user.getId());
        if(!checkMember.getSuperPartner().equals("1")) {
            return error("您不是代理商！");
        }
        contractRewardRecordService.clearRewardSetVoById(user.getId());
        return success();
    }

    @RequestMapping(value = "set")
    public MessageResult set(
            @SessionAttribute(SESSION_MEMBER) AuthMember user,
            @RequestParam("id") Long memberId,
            @RequestParam("rate") Integer rate
            ) {
        if(memberId == null){
            return error("设置用户的id不能为空！");
        }
        if(rate == null){
            return error("设置用户的比例不能为空！");
        }
        if(rate.intValue() < 0 || rate.intValue() > 100){
            return error("设置用户的比例不能为小于0%或超过100%！");
        }
        Member checkMember = memberService.findOne(user.getId());
        if(!"1".equals(checkMember.getSuperPartner())) {
            return error("您不是代理商！");
        }
        Member setMember = memberService.findOne(memberId);
        if("1".equals(setMember.getSuperPartner())){
            return error("您不设置下级代理商！");
        }
        MemberWeightUpper upperMemberId = memberWeightUpperService.findMemberWeightUpperByMemberId(setMember.getInviterId());
        Member upperMember = memberService.findOne(setMember.getInviterId());
        if("1".equals(upperMember.getSuperPartner())){
            if (rate.intValue() >= 100) {
                return error("设置比例应小于此用户上级推荐人的比例！");
            }
        }else {
            if (rate.intValue() >= upperMemberId.getRate().intValue()) {
                return error("设置比例应小于此用户上级推荐人的比例！");
            }
        }
        List<Member> promotionMember = memberService.findPromotionMember(setMember.getId());
        if(promotionMember!=null && !promotionMember.isEmpty()){
            List<Long> idList= promotionMember.stream().map(Member::getId).collect(Collectors.toList());
            List<MemberWeightUpper> lowMemberWeightUpper = memberWeightUpperDao.findAllByUpperIds(idList);
            for (MemberWeightUpper memberWeightUpper:lowMemberWeightUpper) {
                if(rate.intValue() <= memberWeightUpper.getRate().intValue()){
                    return error("设置比例应大于此用户后面直推人的比例！");
                }
            }
        }
        MemberWeightUpper memberWeightUpper = memberWeightUpperService.saveMemberWeightUpper(setMember);
        List<Member> allByIds = memberService.findAllByIds(memberWeightUpper.getUpper());
        Optional<Member> firstSuperPartner = allByIds.stream().filter(e -> "1".equals(e.getSuperPartner())).findFirst();
        if(firstSuperPartner.isPresent()){
            if (!firstSuperPartner.get().getId().equals(checkMember.getId())){
                return error("不能设置下级代理商的直推用户！");
            }
        }
        memberWeightUpper.setRate(rate);
        memberWeightUpperDao.save(memberWeightUpper);
        contractRewardRecordService.clearRewardSetVoById(user.getId());
        return success();
    }
}
