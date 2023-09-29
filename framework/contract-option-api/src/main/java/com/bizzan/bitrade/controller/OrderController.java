package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.constant.BooleanEnum;
import com.bizzan.bitrade.engine.ContractOptionCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.*;

import com.bizzan.bitrade.util.MessageResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

/**
 * 委托订单处理类
 */
@Slf4j
@RestController
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private MemberWalletService walletService;

    @Autowired
    private CoinService coinService;

    @Value("${exchange.max-cancel-times:-1}")
    private int maxCancelTimes;

    @Autowired
    private LocaleMessageSourceService msService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private ContractOptionCoinService contractOptionCoinService;

    @Autowired
    private ContractOptionOrderService contractOptionOrderService;

    @Autowired
    private ContractOptionService contractOptionService;

    @Autowired
    private MemberTransactionService memberTransactionService;

    @Autowired
    private MemberWalletService memberWalletService;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private ContractOptionCoinMatchFactory contractOptionCoinMatchFactory; // 合约引擎工厂

    private SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


    @RequestMapping("add")
    @Transactional
    public MessageResult addOrder(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                   String symbol, // 交易对符号
                                   ContractOptionOrderDirection direction, // 1：看涨  2：看跌
                                   Long optionId, // 参与对象
                                   BigDecimal amount // 参与金额
    ) {
        Assert.notNull(symbol, msService.getMessage("SELECT_SYMBOL"));
        Assert.notNull(direction, msService.getMessage("CHOOSE_UP_OR_DOWN"));
        Assert.notNull(optionId, msService.getMessage("SELECT_CONTRACT_PERIOD"));
        Assert.notNull(amount, msService.getMessage("INPUT_AMOUNT"));

        Member member = memberService.findOne(authMember.getId());
        Assert.notNull(member, msService.getMessage("USER_DOES_NOT_EXIST"));
        // 用户是否被禁止交易
        if(member.getTransactionStatus().equals(BooleanEnum.IS_FALSE)){
            return MessageResult.error(500,msService.getMessage("CANNOT_TRADE"));
        }

        ContractOptionCoin contractOptionCoin = contractOptionCoinService.findBySymbol(symbol);
        Assert.notNull(contractOptionCoin, msService.getMessage("SYMBOL_DOES_NOT_EXIST"));
        // 预测方向是否在看涨和看跌
        if(direction != ContractOptionOrderDirection.BUY && direction != ContractOptionOrderDirection.SELL) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }

        if(direction == ContractOptionOrderDirection.SELL && contractOptionCoin.getEnableSell() == BooleanEnum.IS_FALSE) {
            return MessageResult.error(500, msService.getMessage("NO_SHORT"));
        }
        if(direction == ContractOptionOrderDirection.BUY && contractOptionCoin.getEnableBuy() == BooleanEnum.IS_FALSE) {
            return MessageResult.error(500, msService.getMessage("NO_LONG"));
        }
        // 期权合约是否存在
        ContractOption contractOption = contractOptionService.findOne(optionId);
        Assert.notNull(contractOption, "CONTRACT_PERIOD_DOES_NOT_EXIST");
        if(contractOption.getStatus() != ContractOptionStatus.STARTING) {
            return MessageResult.error(500, msService.getMessage("CLOSE_THE_BET"));
        }
        if (!contractOption.getSymbol().equals(symbol)){
            return MessageResult.error(500, msService.getMessage("OPTION_CONTRACT_FAILURE"));
        }

        // 投注金额是否超出范围
        String[] amountArr = contractOptionCoin.getAmount().split(",");
        BigDecimal amountStart = BigDecimal.valueOf(Long.valueOf(amountArr[0]));
        BigDecimal amountEnd = BigDecimal.valueOf(Long.valueOf(amountArr[amountArr.length - 1]));
        if(amount.compareTo(amountStart) < 0 || amount.compareTo(amountEnd) > 0) {
            return MessageResult.error(500, msService.getMessage("AMOUNT_OUT_OF_RANGE"));
        }

        // 是否已参与过
        List<ContractOptionOrder> contractOptionOrderList = contractOptionOrderService.findByMemberIdAndOptionId(member.getId(), optionId);
        if(contractOptionOrderList != null && contractOptionOrderList.size() > 0) {
            return MessageResult.error(500, msService.getMessage("ADDORDER_PARTICIPATED_ERROR"));
        }

        MemberWallet memberWallet = memberWalletService.findByCoinUnitAndMemberId(contractOptionCoin.getBaseSymbol(), member.getId());
        // 需要 投注额 + 手续费
        BigDecimal totalAmount = amount.add(contractOptionCoin.getFeePercent().multiply(amount));
        if(totalAmount.compareTo(memberWallet.getBalance()) > 0) {
            return MessageResult.error(500, msService.getMessage("BALANCE_NOT_ENOUGH"));
        }

        // 新建订单
        ContractOptionOrder orderObj = new ContractOptionOrder();
        orderObj.setBaseSymbol(contractOptionCoin.getBaseSymbol());
        orderObj.setBetAmount(amount);
        orderObj.setCoinSymbol(contractOptionCoin.getCoinSymbol());
        orderObj.setOptionId(contractOption.getId());
        orderObj.setDirection(direction);
        orderObj.setFee(contractOptionCoin.getFeePercent().multiply(amount));
        orderObj.setWinFee(BigDecimal.ZERO);
        orderObj.setMemberId(member.getId());
        orderObj.setResult(ContractOptionOrderResult.WAIT);
        orderObj.setRewardAmount(BigDecimal.ZERO);
        orderObj.setStatus(ContractOptionOrderStatus.OPEN);
        orderObj.setSymbol(contractOptionCoin.getSymbol());
        orderObj.setCreateTime(Calendar.getInstance().getTimeInMillis());
        orderObj.setOptionNo(contractOption.getOptionNo());
        ContractOptionOrder resultObj = contractOptionOrderService.save(orderObj);

        // 锁定资产
        memberWalletService.freezeBalance(memberWallet, amount.add(amount.multiply(contractOptionCoin.getFeePercent())));

        // 总单投注额增加
        if(direction == ContractOptionOrderDirection.BUY) {
            contractOption.setTotalBuy(contractOption.getTotalBuy().add(amount));
            contractOption.setTotalBuyCount(contractOption.getTotalBuyCount() + 1);
        }else if(direction == ContractOptionOrderDirection.SELL) {
            contractOption.setTotalSell(contractOption.getTotalSell().add(amount));
            contractOption.setTotalSellCount(contractOption.getTotalSellCount() + 1);
        }
        contractOptionService.save(contractOption);

        return MessageResult.success(msService.getMessage("ADDORDER_SUCCESSFL_PARTICIPATED"));
    }

    /**
     * 获取当前币种指定期数ID的参与记录
     * @param authMember
     * @param symbol
     * @param optionId
     * @return
     */
    @RequestMapping("current")
    public MessageResult current(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                   String symbol, // 交易对符号
                                   Long optionId // 参与对象
    ) {
        List<ContractOptionOrder> orderList = contractOptionOrderService.findByMemberIdAndOptionId(authMember.getId(), optionId);
        MessageResult result = MessageResult.success();
        result.setData(orderList);
        return result;
    }

    /**
     * 获取当前币种历史参与记录
     * @param authMember
     * @param symbol
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("history")
    public MessageResult history(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                 @RequestParam(value = "symbol" ,required = false) String symbol,
                                 @RequestParam(value = "pageNo" ,required = false) int pageNo,
                                 @RequestParam(value = "pageSize" ,required = false) int pageSize
    ) {
        Page<ContractOptionOrder> list = contractOptionOrderService.findAll(authMember.getId(), symbol, pageNo, pageSize);
        MessageResult result = MessageResult.success();
        result.setData(list);
        return result;
    }
}
