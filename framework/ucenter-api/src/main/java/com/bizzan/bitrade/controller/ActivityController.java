package com.bizzan.bitrade.controller;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;
import static org.springframework.util.Assert.hasText;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.bizzan.bitrade.constant.BooleanEnum;
import com.bizzan.bitrade.constant.MemberLevelEnum;
import com.bizzan.bitrade.constant.SysConstant;
import com.bizzan.bitrade.controller.BaseController;
import com.bizzan.bitrade.entity.Activity;
import com.bizzan.bitrade.entity.ActivityOrder;
import com.bizzan.bitrade.entity.Coin;
import com.bizzan.bitrade.entity.ExchangeOrderDirection;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.MemberWallet;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.ActivityOrderService;
import com.bizzan.bitrade.service.ActivityService;
import com.bizzan.bitrade.service.CoinService;
import com.bizzan.bitrade.service.LocaleMessageSourceService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.service.MemberWalletService;
import com.bizzan.bitrade.util.DateUtil;
import com.bizzan.bitrade.util.MessageResult;

@RestController
@RequestMapping("activity")
public class ActivityController  extends BaseController {
	@Autowired
    private ActivityService activityService;
	
	@Autowired
    private ActivityOrderService activityOrderService;
    
	@Autowired
    private LocaleMessageSourceService sourceService;
	
	@Autowired
    private RedisTemplate redisTemplate;
	
	@Autowired
    private MemberService memberService;
	
	@Autowired
    private CoinService coinService;
	
	@Autowired
    private MemberWalletService walletService;
	
	private SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
    @RequestMapping("page-query")
    public MessageResult page(int pageNo, int pageSize, int step) {
    	MessageResult mr = new MessageResult();
        Page<Activity> all = activityService.queryByStep(pageNo, pageSize, step);
        mr.setCode(0);
        mr.setData(all);
        return mr;
    }
    
    @RequestMapping("detail")
    public MessageResult detail(Long id) {
        Activity detail = activityService.findOne(id);
        Assert.notNull(detail, "validate id!");
        return success(detail);
    }
    
    @RequestMapping("attend")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult attendActivity(@SessionAttribute(SESSION_MEMBER) AuthMember user,
    									BigDecimal amount,
    									Long activityId,
    									String code, 
    									String aims) {
    	
    	if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return MessageResult.error(500, sourceService.getMessage("NUMBER_OF_ILLEGAL"));
        }
    	Assert.notNull(activityId, "valid activity id");
    	// 检查验证码是否正确
    	hasText(code, sourceService.getMessage("MISSING_VERIFICATION_CODE"));
        hasText(aims, sourceService.getMessage("MISSING_PHONE_OR_EMAIL"));
        ValueOperations valueOperations = redisTemplate.opsForValue();
        Member member = memberService.findOne(user.getId());
        if (member.getEmail() != null && aims.equals(member.getEmail())) {
            Object info = valueOperations.get(SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + member.getEmail());
            if (!info.toString().equals(code)) {
                return MessageResult.error(sourceService.getMessage("VERIFICATION_CODE_INCORRECT"));
            } else {
                valueOperations.getOperations().delete(SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + member.getEmail());
            }
        }else if (member.getMobilePhone() != null && aims.equals(member.getMobilePhone())) {
            Object info = valueOperations.get(SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + member.getMobilePhone());
            if ( info==null ||!info.toString().equals(code)) {
                return MessageResult.error(sourceService.getMessage("VERIFICATION_CODE_INCORRECT"));
            } else {
                valueOperations.getOperations().delete(SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + member.getMobilePhone());
            }
        } else  {
            return MessageResult.error(sourceService.getMessage("ACTIVITY_ATTEND_FAIL"));
        }
        
        // 是否经过实名认证
//        if(member.getMemberLevel()== MemberLevelEnum.GENERAL){
//            return MessageResult.error(500,"请先进行实名认证");
//        }
        
        //是否被禁止交易
        if(member.getTransactionStatus().equals(BooleanEnum.IS_FALSE)){
            return MessageResult.error(sourceService.getMessage("CANNOT_TRADE"));
        }
        
        // 检查活动是否存在
        Activity activity = activityService.findOne(activityId);
        Assert.notNull(activity, sourceService.getMessage("ACTIVITY_NOT_EXIST"));

        // 一级邀请人数是否满足
        if(activity.getLeveloneCount() > 0) {
        	if(member.getFirstLevel() < activity.getLeveloneCount()) {
        		return MessageResult.error(500, sourceService.getMessage("ACTIVITY_FIRST_DISSATISFY")+activity.getLeveloneCount());
        	}
        }
        // 云矿机检查
        if(activity.getType() == 5) {
        	if(amount.intValue() < 1) {
        		return MessageResult.error(sourceService.getMessage("ACTIVITY_NUMBER_INCORRECT"));
        	}
        }
        //检查活动是否是正确的类型
        if(activity.getType() == 1 || activity.getType() == 2 || activity.getType() == 0) {
        	return MessageResult.error(sourceService.getMessage("ACTIVITY_GO_EXCHANGE"));
        }
        // 检查活动是否在进行中
        if(activity.getStep() != 1) {
        	return MessageResult.error(sourceService.getMessage("ACTIVITY_STATUS_NOT_IN_PROGRESS"));
        }
        // 检查当前时间是否处在活动期间内
        long currentTime = Calendar.getInstance().getTimeInMillis(); // 当前时间戳
        try {
			if(dateTimeFormat.parse(activity.getEndTime()).getTime() < currentTime) {
				return MessageResult.error(sourceService.getMessage("ACTIVITY_STATUS_FINISH"));
			}
			if(dateTimeFormat.parse(activity.getStartTime()).getTime() > currentTime) {
				return MessageResult.error(sourceService.getMessage("ACTIVITY_STATUS_NOT_START"));
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return MessageResult.error("UNKNOWN ERROR！Code：9901");
		}
        
        // 自由认购类型，检查是否超过最大发售量
        if(activity.getType() == 4 || activity.getType() == 5) {
        	if(activity.getTradedAmount().compareTo(activity.getTotalSupply()) >= 0) {
        		return MessageResult.error(sourceService.getMessage("ACTIVITY_SUM_NUM_LIMIT"));
        	}
        }
        // 最低起兑量/最低锁仓量
    	if(activity.getMinLimitAmout().compareTo(BigDecimal.ZERO) > 0) {
    		if(activity.getMinLimitAmout().compareTo(amount) > 0) {
    			return MessageResult.error(sourceService.getMessage("ACTIVITY_NUM_LOW_LIMIT"));
    		}
    	}
    	if(activity.getMaxLimitAmout().compareTo(BigDecimal.ZERO) > 0 || activity.getLimitTimes() > 0) {
	    	// 最高兑换量/最高锁仓量(先获取已下单的量)
	    	List<ActivityOrder> orderDetailList = activityOrderService.findAllByActivityIdAndMemberId(member.getId(), activityId);
	    	BigDecimal alreadyAttendAmount = BigDecimal.ZERO;
	    	int alreadyAttendTimes = 0;
	    	if(orderDetailList != null) {
	    		alreadyAttendTimes = orderDetailList.size();
	    		for(int i = 0; i < orderDetailList.size(); i++) {
	    			if(activity.getType() == 3) {
	    				alreadyAttendAmount = alreadyAttendAmount.add(orderDetailList.get(i).getFreezeAmount());
	    			}else {
	    				alreadyAttendAmount = alreadyAttendAmount.add(orderDetailList.get(i).getAmount());
	    			}
	    		}
	    	}
	    	// 最高限购量
	    	if(activity.getMaxLimitAmout().compareTo(BigDecimal.ZERO) > 0) {
		    	if(alreadyAttendAmount.add(amount).compareTo(activity.getMaxLimitAmout()) > 0) {
		    		return MessageResult.error(sourceService.getMessage("ACTIVITY_NUM_HIGH_LIMIT"));
		    	}
	    	}
	    	// 个人限购次数
	    	if(activity.getLimitTimes() > 0) {
	    		if(activity.getLimitTimes() < alreadyAttendTimes + 1) {
	    			return MessageResult.error(sourceService.getMessage("ACTIVITY_BUY_LIMIT"));
	    		}
	    	}
    	}
    	
    	// 检查持仓要求
    	if(activity.getHoldLimit().compareTo(BigDecimal.ZERO) > 0 && activity.getHoldUnit() != null && activity.getHoldUnit() != "") {
    		MemberWallet holdCoinWallet = walletService.findByCoinUnitAndMemberId(activity.getHoldUnit(), member.getId());
    		if (holdCoinWallet == null) {
                return MessageResult.error("ACTIVITY_WALLET_NOT_EXIST");
            }
    		if(holdCoinWallet.getIsLock().equals(BooleanEnum.IS_TRUE)){
                return MessageResult.error(sourceService.getMessage("ACTIVITY_POSITION_WALLET_LOCKING"));
            }
    		if(holdCoinWallet.getBalance().compareTo(activity.getHoldLimit()) < 0) {
    			return MessageResult.error( activity.getHoldUnit() +sourceService.getMessage("ACTIVITY_POSITION_NUM_NOT"));
    		}
    	}
    	
        // 查询币种是否存在
        Coin coin;
        coin = coinService.findByUnit(activity.getAcceptUnit());
        if (coin == null) {
            return MessageResult.error(sourceService.getMessage("NONSUPPORT_COIN"));
        }
        
        // 检查钱包是否可用
        MemberWallet acceptCoinWallet = walletService.findByCoinUnitAndMemberId(activity.getAcceptUnit(), member.getId());
        if (acceptCoinWallet == null || acceptCoinWallet == null) {
            return MessageResult.error(sourceService.getMessage("NONSUPPORT_COIN"));
        }
        if(acceptCoinWallet.getIsLock().equals(BooleanEnum.IS_TRUE)){
            return MessageResult.error(sourceService.getMessage("ACTIVITY_WALLET_LOCKING"));
        }
        
        // 检查余额是否充足
        BigDecimal totalAcceptCoinAmount = BigDecimal.ZERO;
        if(activity.getType() == 3) { // 持仓瓜分
        	totalAcceptCoinAmount = amount.setScale(activity.getAmountScale(), BigDecimal.ROUND_HALF_DOWN);
        }else if(activity.getType() == 4) {  // 自由认购
        	totalAcceptCoinAmount = activity.getPrice().multiply(amount).setScale(activity.getAmountScale(), BigDecimal.ROUND_HALF_DOWN);
        }else if(activity.getType() == 5) {  // 矿机认购
        	totalAcceptCoinAmount = activity.getPrice().multiply(amount).setScale(activity.getAmountScale(), BigDecimal.ROUND_HALF_DOWN);
        }else if(activity.getType() == 6) { // 锁仓认购
            // 保存了锁仓数量和门槛费
            totalAcceptCoinAmount = amount.add(activity.getLockedFee()).setScale(activity.getAmountScale(), BigDecimal.ROUND_HALF_DOWN);
        }

        if(acceptCoinWallet.getBalance().compareTo(totalAcceptCoinAmount) < 0){
        	return MessageResult.error(sourceService.getMessage("INSUFFICIENT_COIN") + activity.getAcceptUnit());
        }
        
        ActivityOrder activityOrder = new ActivityOrder();
        activityOrder.setActivityId(activityId);
        if(activity.getType() == 3) {
        	activityOrder.setAmount(BigDecimal.ZERO);
        	activityOrder.setFreezeAmount(totalAcceptCoinAmount); // 冻结资产数量（仅持仓瓜分需要设置此值）
        }else if(activity.getType() == 4) {
        	activityOrder.setAmount(amount); // 实际下单数量
        	activityOrder.setFreezeAmount(BigDecimal.ZERO);
        }else if(activity.getType() == 5) {
        	activityOrder.setAmount(amount); // 实际下单数量
        	activityOrder.setFreezeAmount(BigDecimal.ZERO);
        }else if(activity.getType() == 6){
            activityOrder.setAmount(amount); // 实际锁仓数量
            activityOrder.setFreezeAmount(totalAcceptCoinAmount); // 这里冻结的资产包含了用户实际锁仓数量和门槛费
        }else{
        	activityOrder.setAmount(BigDecimal.ZERO);
        	activityOrder.setFreezeAmount(BigDecimal.ZERO);
        }
        activityOrder.setBaseSymbol(activity.getAcceptUnit());
        activityOrder.setCoinSymbol(activity.getUnit());
        activityOrder.setCreateTime(DateUtil.getCurrentDate());
        activityOrder.setMemberId(member.getId());
        activityOrder.setPrice(activity.getPrice());
        activityOrder.setState(1); //未成交
        activityOrder.setTurnover(totalAcceptCoinAmount);//作为资产冻结或扣除资产的标准，锁仓活动中，此项目作为参与数量
        activityOrder.setType(activity.getType());
        
        MessageResult mr = activityOrderService.saveActivityOrder(member.getId(), activityOrder);
        
        if (mr.getCode() != 0) {
            return MessageResult.error(500, sourceService.getMessage("ACTIVITY_ATTEND_FAIL") + mr.getMessage());
        }else {
        	return MessageResult.success(sourceService.getMessage("ACTIVITY_ATTEND_SUCCESS"));
        }
    }
    
    @RequestMapping("getmemberrecords")
    public MessageResult getMemberRecordsByActivityId(@SessionAttribute(SESSION_MEMBER) AuthMember user, Long activityId) {
    	
    	Assert.notNull(activityId, "valid activity id");
    	List<ActivityOrder> orderList = activityOrderService.findAllByActivityIdAndMemberId(user.getId(), activityId);

    	return success(orderList);
    }
    
    /**
     * 获取用户参与的所有订单
     * @param user
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("getmyorders")
    public MessageResult getMemberOrders(@SessionAttribute(SESSION_MEMBER) AuthMember user, @RequestParam(value = "pageNo", defaultValue = "1") Integer pageNo, @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
    	
    	Assert.notNull(user, "valid user");
    	Page<ActivityOrder> orderList = activityOrderService.finaAllByMemberId(user.getId(), pageNo, pageSize);
    	for(int i = 0; i < orderList.getContent().size(); i++) {
    		Activity item = activityService.findOne(orderList.getContent().get(i).getActivityId());
    		if(item != null) {
    			orderList.getContent().get(i).setActivityName(item.getTitle());
    		}
    	}
    	return success(orderList);
    }
}
