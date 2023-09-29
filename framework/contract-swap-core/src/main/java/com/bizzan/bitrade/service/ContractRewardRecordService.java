package com.bizzan.bitrade.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.bizzan.bitrade.constant.ContractRewardRecordType;
import com.bizzan.bitrade.constant.TransactionType;
import com.bizzan.bitrade.dao.ContractOrderEntrustDao;
import com.bizzan.bitrade.dao.ContractOrderEntrustRepository;
import com.bizzan.bitrade.dao.ContractRewardRecordRepository;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.pagination.Restrictions;
import com.bizzan.bitrade.service.Base.BaseService;
import com.bizzan.bitrade.util.BigDecimalUtils;
import com.bizzan.bitrade.util.JSONUtils;
import com.bizzan.bitrade.vo.RewardSetVo;
import com.querydsl.core.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Slf4j
@Service
public class ContractRewardRecordService extends BaseService {

    @Autowired
    private ContractRewardRecordRepository contractRewardRecordRepository;
    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberWeightUpperService memberWeightUpperService;
    @Autowired
    private MemberWalletService memberWalletService;
    @Autowired
    private MemberTransactionService memberTransactionService;
    @Autowired
    private ContractOrderEntrustDao contractOrderEntrustDao;
    @Autowired
    private DataDictionaryService dataDictionaryService;

    @Autowired
    private RedisTemplate redisTemplate ;

    private String key = "admin-all-rewardset";
    private String agentKey = "agent-all-rewardset-";


    public Page<ContractRewardRecord> findAll(Predicate predicate, Pageable pageable) {
        return contractRewardRecordRepository.findAll(predicate, pageable);
    }

    public ContractRewardRecord save(ContractRewardRecord rewardRecord) {
        return contractRewardRecordRepository.saveAndFlush(rewardRecord);
    }

    /**
     * 合约返佣
     * @param orderEntrust
     */
    @Transactional(rollbackFor = Exception.class)
    public void sendReward(ContractOrderEntrust orderEntrust) {

        BigDecimal lave = sendReturnReward(orderEntrust);
        //源用户
        Member member = memberService.findOne(orderEntrust.getMemberId());
        if(member==null){
            //源用户不存在
            return;
        }
        //剩余的 3-30%  4-70%
        Long firstId=3L;
        Long secondId=4L;
        BigDecimal rate1=BigDecimal.valueOf(0.3);
        BigDecimal rate2=BigDecimal.valueOf(0.7);

        Member member1 = memberService.findOne(firstId);
        Member member2 = memberService.findOne(secondId);


        if(lave.compareTo(BigDecimal.ZERO)==1){
            //第一个
            MemberWallet memberWallet = memberWalletService.findByCoinUnitAndMemberId("USDT", firstId);
            BigDecimal reward = BigDecimalUtils.mulDown(lave,rate1, 8);
            if (reward.compareTo(BigDecimal.ZERO) > 0) {
                memberWalletService.increaseBalance(memberWallet.getId(), reward);
                MemberTransaction memberTransaction = new MemberTransaction();
                memberTransaction.setAmount(reward);
                memberTransaction.setFee(BigDecimal.ZERO);
                memberTransaction.setMemberId(firstId);
                memberTransaction.setSymbol("USDT");
                memberTransaction.setType(TransactionType.PLATFORM_FEE_AWARD);
                memberTransaction.setDiscountFee("0");
                memberTransaction.setRealFee("0");
                memberTransaction = memberTransactionService.save(memberTransaction);
                ContractRewardRecord rewardRecord = new ContractRewardRecord();
                rewardRecord.setCoin(memberWallet.getCoin());
                rewardRecord.setContractOrderEntrust(orderEntrust);
                rewardRecord.setMember(member1);
                rewardRecord.setFromMember(member);
                rewardRecord.setType(ContractRewardRecordType.PLATFORM);
                rewardRecord.setNum(reward);
                this.save(rewardRecord);
            }
            //第二个
            MemberWallet memberWallet2 = memberWalletService.findByCoinUnitAndMemberId("USDT", secondId);
            BigDecimal reward2 = BigDecimalUtils.mulDown(lave,rate2, 8);
            if (reward2.compareTo(BigDecimal.ZERO) > 0) {
                memberWalletService.increaseBalance(memberWallet2.getId(), reward2);
                MemberTransaction memberTransaction = new MemberTransaction();
                memberTransaction.setAmount(reward2);
                memberTransaction.setFee(BigDecimal.ZERO);
                memberTransaction.setMemberId(secondId);
                memberTransaction.setSymbol("USDT");
                memberTransaction.setType(TransactionType.PLATFORM_FEE_AWARD);
                memberTransaction.setDiscountFee("0");
                memberTransaction.setRealFee("0");
                memberTransaction = memberTransactionService.save(memberTransaction);
                ContractRewardRecord rewardRecord = new ContractRewardRecord();
                rewardRecord.setCoin(memberWallet2.getCoin());
                rewardRecord.setContractOrderEntrust(orderEntrust);
                rewardRecord.setMember(member2);
                rewardRecord.setFromMember(member);
                rewardRecord.setType(ContractRewardRecordType.PLATFORM);
                rewardRecord.setNum(reward2);
                this.save(rewardRecord);
            }
        }


    }
    /**
     * 合约返佣
     * @param orderEntrust
     */
    @Transactional(rollbackFor = Exception.class)
    public BigDecimal sendReturnReward(ContractOrderEntrust orderEntrust) {
        BigDecimal lave = BigDecimal.ZERO;
        if(orderEntrust==null){
            return lave;
        }
        BigDecimal fee =BigDecimal.ZERO;
        ContractRewardRecordType type = ContractRewardRecordType.OPEN;
        if(orderEntrust.getEntrustType()==ContractOrderEntrustType.OPEN){
            fee = orderEntrust.getOpenFee();
            type = ContractRewardRecordType.OPEN;
        }else {
            fee = orderEntrust.getCloseFee();
            type = ContractRewardRecordType.CLOSE;
        }
        lave = fee;
        //修改返佣状态
        contractOrderEntrustDao.updateReward(orderEntrust.getId(),1);
        //获取上级关系
        MemberWeightUpper upper = memberWeightUpperService.findMemberWeightUpperByMemberId(orderEntrust.getMemberId());
        if(upper.getFirstMemberId()==null){
            //没有邀请人
            return lave;
        }
        //源用户
        Member member = memberService.findOne(orderEntrust.getMemberId());
        if(member==null){
            //源用户不存在
            return lave;
        }
        if(StringUtils.isEmpty(upper.getUpper())){
            //推荐关系不存在
            return lave;
        }
        List<Member> supers = memberService.findSuperPartnerMembersByIds(upper.getUpper());
        if(supers==null || supers.size()==0){
            //没有代理商或者不是代理商
            return lave;
        }
        //获取所有上级比重
        List<MemberWeightUpper> uppers = memberWeightUpperService.findAllByUpperIds(upper.getUpper());
        if(uppers==null || uppers.size()==0){
            //没有上级
            return lave;
        }

        DataDictionary commission = dataDictionaryService.findByBond("commission_rate");
        BigDecimal totalReward = BigDecimal.ZERO;
        if(commission==null){
            //未设置比例 默认50%
            totalReward = BigDecimalUtils.mulRound(fee,BigDecimal.valueOf(0.5), 8);
        }else {
            totalReward = BigDecimalUtils.mulRound(fee,BigDecimal.valueOf(Double.parseDouble(commission.getValue())), 8);
        }
        //当前已返比例
        int currentRate = 0;
        //先返佣自己
        if(upper.getRate()>0){
            currentRate=upper.getRate();
            //应返比例
            BigDecimal rate = BigDecimal.valueOf(upper.getRate()).divide(BigDecimal.valueOf(100),8,BigDecimal.ROUND_DOWN);
            //返佣
            MemberWallet memberWallet = memberWalletService.findByCoinUnitAndMemberId("USDT", upper.getMemberId());
            BigDecimal reward = BigDecimalUtils.mulDown(totalReward,rate, 8);
            if (reward.compareTo(BigDecimal.ZERO) > 0) {
                memberWalletService.increaseBalance(memberWallet.getId(), reward);
                MemberTransaction memberTransaction = new MemberTransaction();
                memberTransaction.setAmount(reward);
                memberTransaction.setFee(BigDecimal.ZERO);
                memberTransaction.setMemberId(upper.getMemberId());
                memberTransaction.setSymbol("USDT");
                memberTransaction.setType(TransactionType.CONTRACT_AWARD);
                memberTransaction.setDiscountFee("0");
                memberTransaction.setRealFee("0");
                memberTransaction = memberTransactionService.save(memberTransaction);
                ContractRewardRecord rewardRecord = new ContractRewardRecord();
                rewardRecord.setCoin(memberWallet.getCoin());
                rewardRecord.setContractOrderEntrust(orderEntrust);
                rewardRecord.setMember(member);
                rewardRecord.setFromMember(member);
                rewardRecord.setType(type);
                rewardRecord.setNum(reward);
                this.save(rewardRecord);
            }
        }
        for(MemberWeightUpper weightUpper : uppers){
            //获取用户信息
            Member upMember = memberService.findOne(weightUpper.getMemberId());
            int userRate = weightUpper.getRate();
            if("1".equals(upMember.getSuperPartner())){
                userRate=100;
            }
            //应返比例
            int releaseRate = userRate-currentRate;
            if(releaseRate<=0){
                //不返佣
                continue;
            }
            currentRate=userRate;
            BigDecimal rate = BigDecimal.valueOf(releaseRate).divide(BigDecimal.valueOf(100),8,BigDecimal.ROUND_DOWN);
            //返佣
            MemberWallet memberWallet = memberWalletService.findByCoinUnitAndMemberId("USDT", weightUpper.getMemberId());
            BigDecimal reward = BigDecimalUtils.mulDown(totalReward,rate, 8);
            if (reward.compareTo(BigDecimal.ZERO) > 0) {
                memberWalletService.increaseBalance(memberWallet.getId(), reward);
                MemberTransaction memberTransaction = new MemberTransaction();
                memberTransaction.setAmount(reward);
                memberTransaction.setFee(BigDecimal.ZERO);
                memberTransaction.setMemberId(weightUpper.getMemberId());
                memberTransaction.setSymbol("USDT");
                memberTransaction.setType(TransactionType.CONTRACT_AWARD);
                memberTransaction.setDiscountFee("0");
                memberTransaction.setRealFee("0");
                memberTransaction = memberTransactionService.save(memberTransaction);
                ContractRewardRecord rewardRecord = new ContractRewardRecord();
                rewardRecord.setCoin(memberWallet.getCoin());
                rewardRecord.setContractOrderEntrust(orderEntrust);
                rewardRecord.setMember(upMember);
                rewardRecord.setFromMember(member);
                rewardRecord.setType(type);
                rewardRecord.setNum(reward);
                this.save(rewardRecord);
            }
            if(currentRate>=100){
                //停止
                break;
            }
        }
        lave = lave.subtract(totalReward);


        //平级奖励
        if(supers.size()>1){
            DataDictionary levelReward = dataDictionaryService.findByBond("level_reward_rate");
            BigDecimal rate = BigDecimal.ZERO;
            if(commission==null){
                //未设置比例 默认2%
                rate = BigDecimal.valueOf(0.02);
            }else {
                rate = BigDecimal.valueOf(Double.parseDouble(levelReward.getValue()));
            }

            //返佣
            MemberWallet memberWallet = memberWalletService.findByCoinUnitAndMemberId("USDT", supers.get(1).getId());
            BigDecimal reward = BigDecimalUtils.mulDown(totalReward,rate, 8);
            if (reward.compareTo(BigDecimal.ZERO) > 0) {
                memberWalletService.increaseBalance(memberWallet.getId(), reward);
                MemberTransaction memberTransaction = new MemberTransaction();
                memberTransaction.setAmount(reward);
                memberTransaction.setFee(BigDecimal.ZERO);
                memberTransaction.setMemberId(supers.get(1).getId());
                memberTransaction.setSymbol("USDT");
                memberTransaction.setType(TransactionType.LEVEL_AWARD);
                memberTransaction.setDiscountFee("0");
                memberTransaction.setRealFee("0");
                memberTransaction = memberTransactionService.save(memberTransaction);
                ContractRewardRecord rewardRecord = new ContractRewardRecord();
                rewardRecord.setCoin(memberWallet.getCoin());
                rewardRecord.setContractOrderEntrust(orderEntrust);
                rewardRecord.setMember(supers.get(1));
                rewardRecord.setFromMember(member);
                rewardRecord.setType(ContractRewardRecordType.LEVEL);
                rewardRecord.setNum(reward);
                this.save(rewardRecord);
                lave = lave.subtract(reward);
            }
        }
        return lave;
    }

    public RewardSetVo findAllRewardSetVo() {
        RewardSetVo vo = null;
        ValueOperations<String,String> opt = redisTemplate.opsForValue();
        String voJson = opt.get(key);
        if(voJson!=null){
            vo = JSONObject.parseObject(voJson,RewardSetVo.class);
            return vo;
        }
        vo = new RewardSetVo();
        vo.setName("超级管理");
        vo.setRate("");
        List<Member> members = memberService.findPromotionMember(null);
        List<RewardSetVo> children = new ArrayList<>();
        for(Member member:members){
            children.add(findRewardSetVoByPid(member.getId(),member.getId(),false));
        }
        vo.setChildren(children);
        //放入缓存
        String jsonString = JSONObject.toJSONString(vo);
        opt.set(key,jsonString);
        return vo;
    }

    /**
     * 为代理商平台提供
     * @param id
     * @return
     */
    public RewardSetVo findRewardSetVoById(Long id){
        String key = agentKey+id;
        RewardSetVo vo = null;
        ValueOperations<String,String> opt = redisTemplate.opsForValue();
        String voJson = opt.get(key);
        if(voJson!=null){
            vo = JSONObject.parseObject(voJson,RewardSetVo.class);
            return vo;
        }
        vo = findRewardSetVoByPid(id,id,true);
        //放入缓存
        String jsonString = JSONObject.toJSONString(vo);
        opt.set(key,jsonString);
        return vo;
    }

    public void clearRewardSetVoById(Long id) {
        String key = agentKey+id;
        ValueOperations<String,String> opt = redisTemplate.opsForValue();
        opt.set(key,null);
    }
    private RewardSetVo findRewardSetVoByPid(Long userId,Long pid,Boolean canUpdate){
        RewardSetVo vo = new RewardSetVo();
        vo.setCanUpdate(canUpdate);
        Member member = memberService.findOne(pid);
        if("1".equals(member.getSuperPartner())){
            vo.setRate("100%");
            vo.setCanUpdate(false);
            if(userId.longValue()!=pid){
                canUpdate=false;
            }
        }else {
            MemberWeightUpper upper = memberWeightUpperService.saveMemberWeightUpper(member);
            vo.setRate(upper.getRate()+"%");
        }
        vo.setName(member.getUsername());
        vo.setRealName((member.getRealName()!=null || "".equals(member.getRealName()))?member.getRealName():"未实名");
        vo.setId(member.getId()+"");
        List<RewardSetVo> children = new ArrayList<>();
        List<Member> members = memberService.findPromotionMember(pid);
        for(Member member1:members){
            children.add(this.findRewardSetVoByPid(userId,member1.getId(),canUpdate));
        }
        vo.setChildren(children);
        return vo;
    }

    public void clearAllRewardSetVo() {
        ValueOperations<String,String> opt = redisTemplate.opsForValue();
        opt.set(key,null);
    }
}
