package com.bizzan.bitrade.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.constant.BooleanEnum;
import com.bizzan.bitrade.engine.ContractCoinMatchFactory;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.util.Assert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.List;

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

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Value("${exchange.max-cancel-times:-1}")
    private int maxCancelTimes;

    @Autowired
    private LocaleMessageSourceService msService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private ContractCoinService contractCoinService;

    @Autowired
    private ContractOrderEntrustService contractOrderEntrustService;

    @Autowired
    private MemberTransactionService memberTransactionService;

    @Autowired
    private MemberContractWalletService memberContractWalletService;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private ContractCoinMatchFactory contractCoinMatchFactory; // 合约引擎工厂

    private SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * 合约下单（开仓）- 金本位
     * 二种操作类型：买入开多，卖出开多
     *
     * @param authMember
     * @return
     */
    @RequestMapping("open")
    public MessageResult openOrder(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                   @RequestParam(value = "contractCoinId") Long contractCoinId,// 合约交易对
                                   @RequestParam(value = "direction") ContractOrderDirection direction,// 1：买（平空）  2：卖（平多）
                                   @RequestParam(value = "type") ContractOrderType type,// 0：市价 1：限价 2：计划委托
                                   @RequestParam(value = "triggerPrice", required = false) BigDecimal triggerPrice,// 触发价格
                                   @RequestParam(value = "entrustPrice") BigDecimal entrustPrice,// 委托价格(计划委托时如为0：市价成交)
                                   @RequestParam(value = "leverage") BigDecimal leverage,// 委托价格
                                   @RequestParam(value = "volume") BigDecimal volume// 委托数量（张）
    ) {

        // 输入合法性检查
        if (contractCoinId == null || direction == null || type == null || leverage == null || volume == null) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }
        if (direction != ContractOrderDirection.BUY && direction != ContractOrderDirection.SELL) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }
        if (type != ContractOrderType.MARKET_PRICE && type != ContractOrderType.LIMIT_PRICE && type != ContractOrderType.SPOT_LIMIT) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }

        // 检查交易对是否存在
        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("NONSUPPORT_COIN"));
        }
        // 检查用户钱包是否存在
        MemberContractWallet memberContractWallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (memberContractWallet == null) {
            return MessageResult.error(500, msService.getMessage("WALLET_NOT_IN"));
        }
        // 尝试修改合约（仅当空仓时可修改合约）
        BigDecimal walletPosition = direction == ContractOrderDirection.BUY ? memberContractWallet.getUsdtBuyPosition().add(memberContractWallet.getUsdtFrozenBuyPosition()) : memberContractWallet.getUsdtSellPosition().add(memberContractWallet.getUsdtFrozenSellPosition());
        // 仓位为空，则下单时顺便修改一下合约
        if(walletPosition.compareTo(BigDecimal.ZERO) == 0) {
            if(direction == ContractOrderDirection.BUY) {
                memberContractWalletService.modifyUsdtBuyLeverage(memberContractWallet.getId(), leverage);
            }else{
                memberContractWalletService.modifyUsdtSellLeverage(memberContractWallet.getId(), leverage);
            }
        }
        ContractOrderPattern pattern = memberContractWallet.getUsdtPattern();
        // 获取合约倍数
        leverage = direction == ContractOrderDirection.BUY ? memberContractWallet.getUsdtBuyLeverage() : memberContractWallet.getUsdtSellLeverage();
        // 限价单及计划委托单需要输入委托价格
        if (type == ContractOrderType.LIMIT_PRICE || type == ContractOrderType.SPOT_LIMIT) {
            if (entrustPrice == null) {
                return MessageResult.error(500, msService.getMessage("INPUT_COMMISSION_PRICE"));
            }
        }
        // 检查用户合法性
        Member member = memberService.findOne(authMember.getId());
        if (member == null) return MessageResult.error(500, msService.getMessage("ACCOUNT_NOT_EXIST"));
        // 用户是否被禁止交易
        if (member.getTransactionStatus().equals(BooleanEnum.IS_FALSE)) {
            return MessageResult.error(500, msService.getMessage("CANNOT_TRADE"));
        }

        // 检查交易对是否可用
        if (contractCoin.getEnable() != 1 || contractCoin.getExchangeable() != 1) {
            return MessageResult.error(500, msService.getMessage("COIN_FORBIDDEN"));
        }
        // 是否允许开多仓（买涨）
        if (contractCoin.getEnableOpenBuy() == BooleanEnum.IS_FALSE && direction == ContractOrderDirection.BUY) {
            return MessageResult.error(500, msService.getMessage("SUSPEND_LONG1"));
        }
        // 是否允许开空仓（买跌）
        if (contractCoin.getEnableOpenSell() == BooleanEnum.IS_FALSE && direction == ContractOrderDirection.SELL) {
            return MessageResult.error(500, msService.getMessage("SUSPEND_SHORT1"));
        }
        // 是否允许市价开仓做多
        if (contractCoin.getEnableMarketBuy() == BooleanEnum.IS_FALSE && direction == ContractOrderDirection.BUY) {
            return MessageResult.error(500, msService.getMessage("SUSPEND_LONG2"));
        }
        // 是否允许市价开仓做空
        if (contractCoin.getEnableMarketSell() == BooleanEnum.IS_FALSE && direction == ContractOrderDirection.SELL) {
            return MessageResult.error(500, msService.getMessage("SUSPEND_SHORT2"));
        }

        // 合约倍数是否在规定范围
        if (contractCoin.getLeverageType() == 1) { // 分离倍数
            String[] leverageArr = contractCoin.getLeverage().split(",");
            boolean isExist = false;
            for (String str : leverageArr) {
                if (BigDecimal.valueOf(Integer.parseInt(str)).compareTo(leverage) == 0) {
                    isExist = true;
                }
            }
            if (!isExist) {
                return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_NOT_EXIST"));
            }
        } else { // 范围倍数
            String[] leverageArr = contractCoin.getLeverage().split(",");
            if (leverageArr.length != 2) return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_ERROR"));

            BigDecimal low = BigDecimal.valueOf(Integer.parseInt(leverageArr[0]));
            BigDecimal high = BigDecimal.valueOf(Integer.parseInt(leverageArr[1]));
            if (leverage.compareTo(low) < 0 || leverage.compareTo(high) > 0) {
                return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_NOT_ALLOWED"));
            }
        }
        // 检查下单数量是否符合范围
        if (volume.compareTo(contractCoin.getMinShare()) < 0)
            return MessageResult.error(500, msService.getMessage("NO_LESS_THAN") + contractCoin.getMinShare() + msService.getMessage("LOT"));
        if (volume.compareTo(contractCoin.getMaxShare()) > 0)
            return MessageResult.error(500, msService.getMessage("NO_HIGHER_THAN") + contractCoin.getMaxShare() + msService.getMessage("LOT"));
        if(volume.compareTo(BigDecimal.ONE) < 0)
            return MessageResult.error(500, msService.getMessage("INCORRECT_OPENING_NUMBER"));//小于1张
        if(BigDecimal.valueOf(volume.intValue()).compareTo(volume) != 0)
            return MessageResult.error(500, msService.getMessage("INCORRECT_OPENING_NUMBER")); // 含有小数

        // 检查合约引擎是否存在
        if (!contractCoinMatchFactory.containsContractCoinMatch(contractCoin.getSymbol())) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ENGINE_ERROR"));
        }

        // 计算开仓价（滑点 > 市价用）
        BigDecimal openPrice = BigDecimal.ZERO;
        BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(contractCoin.getSymbol()).getNowPrice();
        // 委托价格是否太高或太低(限价单需要在2%的价格范围内下单)
        if(type == ContractOrderType.LIMIT_PRICE) {
            if(entrustPrice.compareTo(currentPrice.multiply(BigDecimal.ONE.add(BigDecimal.valueOf(0.2)))) > 0
                    || entrustPrice.compareTo(currentPrice.multiply(BigDecimal.ONE.subtract(BigDecimal.valueOf(0.2)))) < 0) {
                return MessageResult.error(500, msService.getMessage("ORDER_PRICE_OVERRUN"));
            }
        }

        // 计算市价成交价格（大约）
        openPrice = currentPrice;
        if (direction == ContractOrderDirection.BUY) { // 买入，滑点计算，做多，更高价格成交
            if (contractCoin.getSpreadType() == 1) { // 滑点类型：百分比
                openPrice = currentPrice.add(currentPrice.multiply(contractCoin.getSpread())); // 已当前价成交（或滑点价成交）
            } else { // 滑点类型：固定额
                openPrice = currentPrice.add(contractCoin.getSpread());
            }
        } else { // 卖出，滑点计算，做空，更低价格成交
            if (contractCoin.getSpreadType() == 1) { // 滑点类型：百分比
                openPrice = currentPrice.subtract(currentPrice.multiply(contractCoin.getSpread())); // 已当前价成交（或滑点价成交）
            } else { // 滑点类型：固定额
                openPrice = currentPrice.subtract(contractCoin.getSpread());
            }
        }
        if (openPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ENGINE_ERROR"));
        }

        // 开仓，检查保证金是否足够
        /**
         * 本段代码涉及到合约保证金的计算
         * 在开仓操作下，需要计算所有持仓订单和委托订单的保证金，不局限于本币种
         *
         */
        // 0、计算当前开仓订单所需保证金
        // 合约张数 * 合约面值 / 合约倍数 （该计算方式适合于金本位，即USDT作为保证金模式）
        BigDecimal principalAmount = volume.multiply(contractCoin.getShareNumber()).multiply(currentPrice).divide(leverage, 4, BigDecimal.ROUND_DOWN);

        // 1、计算开仓手续费(合约张数 * 合约面值 * 开仓费率）
        // 1、计算开仓手续费(保证金 * 开仓费率）
        BigDecimal openFee = principalAmount.multiply(contractCoin.getOpenFee());

        // 当前账户为逐仓模式时，只需比较可用余额
        if (memberContractWallet.getUsdtPattern() == ContractOrderPattern.FIXED) {
            if (principalAmount.add(openFee).compareTo(memberContractWallet.getUsdtBalance()) > 0) {
                return MessageResult.error(500, msService.getMessage("SWAP_BALANCE_NOT_ENOUGH"));
            }
        }
        // 全仓模式，需要计算空仓和多仓总权益
        if (memberContractWallet.getUsdtPattern() == ContractOrderPattern.CROSSED) {
            // 计算金本位权益（多仓 + 空仓）
            BigDecimal usdtTotalProfitAndLoss = BigDecimal.ZERO;
            // 多仓计算方法：（当前价格 / 开仓均价 - 1）* （可用仓位 + 冻结仓位） * 合约面值
            // 多仓计算方法：（当前价格 - 开仓均价）* （可用仓位 + 冻结仓位） * 合约面值(币本位)
            if (memberContractWallet.getUsdtBuyPrice().compareTo(BigDecimal.ZERO) > 0 && memberContractWallet.getUsdtBuyPosition().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(currentPrice.subtract(memberContractWallet.getUsdtBuyPrice()).multiply(memberContractWallet.getUsdtBuyPosition().add(memberContractWallet.getUsdtFrozenBuyPosition())).multiply(memberContractWallet.getUsdtShareNumber()));
            }

            // 空仓计算方法：（1 - 当前价格 / 开仓均价）* （可用仓位 + 冻结仓位） * 合约面值
            // 空仓计算方法：（开仓均价 - 当前价格）* （可用仓位 + 冻结仓位） * 合约面值(币本位)
            if (memberContractWallet.getUsdtSellPrice().compareTo(BigDecimal.ZERO) > 0 && memberContractWallet.getUsdtSellPosition().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(memberContractWallet.getUsdtSellPrice().subtract(currentPrice).multiply(memberContractWallet.getUsdtSellPosition().add(memberContractWallet.getUsdtFrozenSellPosition())).multiply(memberContractWallet.getUsdtShareNumber()));
            }

            // 加上仓位保证金
            usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(memberContractWallet.getUsdtBuyPrincipalAmount());
            // 经过上面的计算，可能会得到一个正值，也可能得到一个负值，如果是负值，因为是全仓模式，就需要用余额减去该数值，然后计算余额是否足够
            if (usdtTotalProfitAndLoss.compareTo(BigDecimal.ZERO) < 0) {
                if (principalAmount.add(openFee).compareTo(memberContractWallet.getUsdtBalance().add(usdtTotalProfitAndLoss)) > 0) {
                    return MessageResult.error(500, msService.getMessage("SWAP_BALANCE_NOT_ENOUGH"));
                }
            } else { // 如果持仓权益是正值，则直接跟可用余额比较即可
                if (principalAmount.add(openFee).compareTo(memberContractWallet.getUsdtBalance()) > 0) {
                    return MessageResult.error(500, msService.getMessage("SWAP_BALANCE_NOT_ENOUGH"));
                }
            }
        }

        // 计划委托中的触发价格需要大于0
        if(type == ContractOrderType.SPOT_LIMIT) {
            if(triggerPrice.compareTo(BigDecimal.ZERO) <= 0) {
                return MessageResult.error(500, msService.getMessage("TRIGGER_PRICE1"));
            }
            if(entrustPrice.compareTo(BigDecimal.ZERO) < 0) {
                return MessageResult.error(500, msService.getMessage("TRIGGER_PRICE2"));
            }
        }
        // 新建合约委托单
        ContractOrderEntrust orderEntrust = new ContractOrderEntrust();
        orderEntrust.setContractId(contractCoin.getId()); // 合约ID
        orderEntrust.setMemberId(member.getId()); // 用户ID
        orderEntrust.setSymbol(contractCoin.getSymbol()); // 交易对符号
        orderEntrust.setBaseSymbol(contractCoin.getSymbol().split("/")[1]); // 基币/结算币
        orderEntrust.setCoinSymbol(contractCoin.getSymbol().split("/")[0]); // 币种符号
        orderEntrust.setDirection(direction); // 开仓方向：做多/做空
        orderEntrust.setContractOrderEntrustId(GeneratorUtil.getOrderId("CE"));
        orderEntrust.setVolume(volume); // 开仓张数
        orderEntrust.setTradedVolume(BigDecimal.ZERO); // 已交易数量
        orderEntrust.setTradedPrice(BigDecimal.ZERO); // 成交价格
        orderEntrust.setPrincipalUnit("USDT"); // 保证金单位
        orderEntrust.setPrincipalAmount(principalAmount); // 保证金数量
        orderEntrust.setCreateTime(DateUtil.getTimeMillis()); // 开仓时间
        orderEntrust.setType(type);
        orderEntrust.setTriggerPrice(triggerPrice); // 触发价
        orderEntrust.setEntrustPrice(entrustPrice); // 委托价格
        orderEntrust.setEntrustType(ContractOrderEntrustType.OPEN); // 开仓
        orderEntrust.setTriggeringTime(0L); // 触发时间，暂时无效
        orderEntrust.setShareNumber(contractCoin.getShareNumber());
        orderEntrust.setProfitAndLoss(BigDecimal.ZERO); // 盈亏（仅平仓计算）
        orderEntrust.setPatterns(memberContractWallet.getUsdtPattern()); // 仓位模式
        orderEntrust.setOpenFee(openFee); // 开仓手续费
        orderEntrust.setStatus(ContractOrderEntrustStatus.ENTRUST_ING); // 委托状态：委托中
        orderEntrust.setCurrentPrice(currentPrice);
        orderEntrust.setIsBlast(0); // 不是爆仓单
        if(type == ContractOrderType.SPOT_LIMIT) { // 是否是计划委托单
            orderEntrust.setIsFromSpot(1);
        }else{
            orderEntrust.setIsFromSpot(0);
        }

        // 保存委托单
        ContractOrderEntrust retObj = contractOrderEntrustService.save(orderEntrust);

        // 冻结保证金 + 手续费(限价或者市价时，冻结资金，计划委托不冻结资金)
        if(type == ContractOrderType.LIMIT_PRICE || type == ContractOrderType.MARKET_PRICE) {
            memberContractWalletService.freezeUsdtBalance(memberContractWallet, principalAmount.add(openFee));
        }else{
            // 计划委托，同向只能有一个（如止盈或止损单只能有一个）
        }

        if (retObj != null) {
            // 发送消息至Exchange系统
            kafkaTemplate.send("swap-order-open", JSON.toJSONString(retObj));

            //通知钱包变更
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("symbol", contractCoin.getSymbol());
            jsonObj.put("walletId", memberContractWallet.getId());
            kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));

            log.info(">>>>>>>>>>订单提交完成>>>>>>>>>>");
            // 返回结果
            MessageResult result = MessageResult.success(msService.getMessage("SWAP_SUCCESS"));
            result.setData(retObj);
            return result;
        } else {
            // 返回结果
            MessageResult result = MessageResult.error(msService.getMessage("SWAP_FAILED"));
            result.setData(null);
            return result;
        }
    }

    /**
     * 合约平仓
     * 四种操作类型：买入平空，卖出平多
     *
     * @param authMember
     * @return
     */
    @RequestMapping("close")
    public MessageResult closeOrder(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                    @RequestParam(value = "contractCoinId") Long contractCoinId,// 合约交易对
                                    @RequestParam(value = "direction") ContractOrderDirection direction,// 1：买（平空）  2：卖（平多）
                                    @RequestParam(value = "type") ContractOrderType type,// 1：市价 2：限价 3：计划委托
                                    @RequestParam(value = "triggerPrice", required = false) BigDecimal triggerPrice,// 触发价格
                                    @RequestParam(value = "entrustPrice") BigDecimal entrustPrice,// 委托价格(计划委托时如为0：市价成交)
                                    @RequestParam(value = "volume") BigDecimal volume// 委托数量（张）
    ) {
        // 输入合法性检查
        if (contractCoinId == null || direction == null || type == null || volume == null) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }
        // 检查合约是否存在
        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        // 限价单及计划委托单需要输入委托价格
        if (type == ContractOrderType.LIMIT_PRICE || type == ContractOrderType.SPOT_LIMIT) {
            if (entrustPrice == null) {
                return MessageResult.error(500, msService.getMessage("INPUT_COMMISSION_PRICE"));
            }
        }
        // 检查用户合法性
        Member member = memberService.findOne(authMember.getId());
        if (member == null) return MessageResult.error(500, msService.getMessage("ACCOUNT_NOT_EXIST"));
        // 用户是否被禁止交易
        if (member.getTransactionStatus().equals(BooleanEnum.IS_FALSE)) {
            return MessageResult.error(500, msService.getMessage("CANNOT_TRADE"));
        }

        // 获取账户
        MemberContractWallet memberContractWallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (memberContractWallet == null) {
            return MessageResult.error(500, msService.getMessage("NONSUPPORT_COIN"));
        }

        if(volume.compareTo(BigDecimal.ONE) < 0)
            return MessageResult.error(500, msService.getMessage("INCORRECT_NUMBER_CLOSING_POSITIONS"));//小于1张
        if(BigDecimal.valueOf(volume.intValue()).compareTo(volume) != 0)
            return MessageResult.error(500, msService.getMessage("INCORRECT_NUMBER_CLOSING_POSITIONS")); // 含有小数
        BigDecimal closeFee = BigDecimal.ZERO;
        if (direction == ContractOrderDirection.BUY) {
            closeFee = volume.multiply(contractCoin.getShareNumber()).multiply(memberContractWallet.getUsdtSellPrice()).divide(memberContractWallet.getUsdtSellLeverage(), 4, BigDecimal.ROUND_DOWN).multiply(contractCoin.getCloseFee());
            // 买入平空，检查空仓仓位是否足够
            if (memberContractWallet.getUsdtSellPosition().compareTo(volume) < 0) {
                return MessageResult.error(500, msService.getMessage("WRONG_AMOUNT_COMMISSION"));
            }
        } else {
            closeFee = volume.multiply(contractCoin.getShareNumber()).multiply(memberContractWallet.getUsdtBuyPrice()).divide(memberContractWallet.getUsdtBuyLeverage(), 4, BigDecimal.ROUND_DOWN).multiply(contractCoin.getCloseFee());
            // 卖出平多，检查多仓仓位是否足够
            if (memberContractWallet.getUsdtBuyPosition().compareTo(volume) < 0) {
                return MessageResult.error(500, msService.getMessage("WRONG_AMOUNT_COMMISSION"));
            }
        }

        BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(contractCoin.getSymbol()).getNowPrice();

        // 委托价格是否太高或太低(限价单需要在2%的价格范围内下单)
        if(type == ContractOrderType.LIMIT_PRICE) {
            if(entrustPrice.compareTo(currentPrice.multiply(BigDecimal.ONE.add(BigDecimal.valueOf(0.02)))) > 0
                    || entrustPrice.compareTo(currentPrice.multiply(BigDecimal.ONE.subtract(BigDecimal.valueOf(0.02)))) < 0) {
                return MessageResult.error(500, msService.getMessage("ORDER_PRICE_OVERRUN"));
            }
        }

        // 1、计算开仓手续费(合约张数 * 合约面值 * 开仓费率）
        // 1、计算平仓手续费(保证金 * 开仓费率）



        // 新建合约委托单
        ContractOrderEntrust orderEntrust = new ContractOrderEntrust();
        orderEntrust.setContractId(contractCoin.getId()); // 合约ID
        orderEntrust.setMemberId(member.getId()); // 用户ID
        orderEntrust.setSymbol(contractCoin.getSymbol()); // 交易对符号
        orderEntrust.setBaseSymbol(contractCoin.getSymbol().split("/")[1]); // 基币/结算币
        orderEntrust.setCoinSymbol(contractCoin.getSymbol().split("/")[0]); // 币种符号
        orderEntrust.setDirection(direction); // 平仓方向：平空/平多
        orderEntrust.setContractOrderEntrustId(GeneratorUtil.getOrderId("CE"));
        orderEntrust.setVolume(volume); // 平仓张数
        orderEntrust.setTradedVolume(BigDecimal.ZERO); // 已交易数量
        orderEntrust.setTradedPrice(BigDecimal.ZERO); // 成交价格
        orderEntrust.setPrincipalUnit("USDT"); // 保证金单位
        orderEntrust.setPrincipalAmount(BigDecimal.ZERO); // 保证金数量
        orderEntrust.setCreateTime(DateUtil.getTimeMillis()); // 开仓时间
        orderEntrust.setType(type);
        orderEntrust.setTriggerPrice(triggerPrice); // 触发价
        orderEntrust.setEntrustPrice(entrustPrice); // 委托价格
        orderEntrust.setEntrustType(ContractOrderEntrustType.CLOSE); // 开仓
        orderEntrust.setTriggeringTime(0L); // 触发时间，暂时无效
        orderEntrust.setShareNumber(contractCoin.getShareNumber());
        orderEntrust.setProfitAndLoss(BigDecimal.ZERO); // 盈亏（仅平仓计算）
        orderEntrust.setPatterns(memberContractWallet.getUsdtPattern()); // 仓位模式
        orderEntrust.setCloseFee(closeFee);
        orderEntrust.setCurrentPrice(currentPrice);
        orderEntrust.setIsBlast(0); // 不是爆仓单
        if(type == ContractOrderType.SPOT_LIMIT) { // 是否是计划委托单
            orderEntrust.setIsFromSpot(1);
        }else{
            orderEntrust.setIsFromSpot(0);
        }
        //计算平仓应该扣除多少保证金(平仓量/（可平仓量+冻结平仓量） *  保证金总量）
        if(type != ContractOrderType.SPOT_LIMIT) {
            if (direction == ContractOrderDirection.BUY) { // 买入平空
                BigDecimal mPrinc = volume.divide(memberContractWallet.getUsdtSellPosition().add(memberContractWallet.getUsdtFrozenSellPosition()), 8, RoundingMode.HALF_UP).multiply(memberContractWallet.getUsdtSellPrincipalAmount());
                orderEntrust.setPrincipalAmount(mPrinc);
            } else {
                BigDecimal mPrinc = volume.divide(memberContractWallet.getUsdtBuyPosition().add(memberContractWallet.getUsdtFrozenBuyPosition()), 8, RoundingMode.HALF_UP).multiply(memberContractWallet.getUsdtBuyPrincipalAmount());
                orderEntrust.setPrincipalAmount(mPrinc);
            }
        }

        // 计算滑点成交价（市价下单时用此价格）
        BigDecimal dealPrice = currentPrice;
        if (direction == ContractOrderDirection.BUY) { // 买入平空，滑点计算，更低价格
            if (contractCoin.getSpreadType() == 1) { // 滑点类型：百分比
                dealPrice = currentPrice.add(currentPrice.multiply(contractCoin.getSpread())); // 已当前价成交（或滑点价成交）
            } else { // 滑点类型：固定额
                dealPrice = currentPrice.add(contractCoin.getSpread());
            }
        } else { // 卖出，滑点计算，做空，更低价格成交
            if (contractCoin.getSpreadType() == 1) { // 滑点类型：百分比
                dealPrice = currentPrice.subtract(currentPrice.multiply(contractCoin.getSpread())); // 已当前价成交（或滑点价成交）
            } else { // 滑点类型：固定额
                dealPrice = currentPrice.subtract(contractCoin.getSpread());
            }
        }
        //
        if (dealPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ENGINE_ERROR"));
        }

        // 限价或市价下单时，需要冻结仓位，计划委托下单则无需冻结
        if(type == ContractOrderType.LIMIT_PRICE || type == ContractOrderType.MARKET_PRICE) {
            // 冻结持仓量
            if (direction == ContractOrderDirection.BUY) {
                // 冻结空仓持仓
                memberContractWalletService.freezeUsdtSellPosition(memberContractWallet.getId(), volume);
            } else {
                // 冻结多仓持仓
                memberContractWalletService.freezeUsdtBuyPosition(memberContractWallet.getId(), volume);
            }
        }

        // 保存委托单
        orderEntrust.setStatus(ContractOrderEntrustStatus.ENTRUST_ING); // 委托状态：委托中
        ContractOrderEntrust retObj = contractOrderEntrustService.save(orderEntrust);

        if (retObj != null) {
            // 发送消息至Exchange系统
            kafkaTemplate.send("swap-order-close", JSON.toJSONString(retObj));


            //通知钱包变更
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("symbol", contractCoin.getSymbol());
            jsonObj.put("walletId", memberContractWallet.getId());
            kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));

            log.info(">>>>>>>>>>订单提交完成>>>>>>>>>>");
            // 返回结果
            MessageResult result = MessageResult.success(msService.getMessage("SWAP_SUCCESS"));
            result.setData(retObj);
            return result;
        } else {
            // 返回结果
            MessageResult result = MessageResult.error(msService.getMessage("SWAP_FAILED"));
            result.setData(null);
            return result;
        }
    }

    /**
     * 一键平仓（市价全平）
     * @param authMember
     * @param contractCoinId
     * @param type 0:市价平多  1:市价平空  2:市价平多+平空
     * @return
     */
    @RequestMapping("close-all")
    public MessageResult closeAll(@SessionAttribute(SESSION_MEMBER) AuthMember authMember, Long contractCoinId, Integer type) {
        Assert.notNull(contractCoinId, msService.getMessage("CONTRACT_ID"));
        Assert.notNull(type, msService.getMessage("CLOSING_TYPE"));

        Member member  = memberService.findOne(authMember.getId());
        Assert.notNull(member, msService.getMessage("ACCOUNT_NOT_EXIST"));

        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        Assert.notNull(contractCoin, msService.getMessage("CONTRACT_NOT_EXIST"));

        MemberContractWallet wallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        Assert.notNull(wallet, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));

        BigDecimal volumeBuy = BigDecimal.ZERO;
        BigDecimal volumeSell = BigDecimal.ZERO;
        // 1、计算平仓手续费(合约张数 * 合约面值 * 开仓费率）
        BigDecimal closeFee = BigDecimal.ZERO;
        if(type == 0) { // 平多
            // 检查多仓是否存在
            if(wallet.getUsdtFrozenBuyPosition().compareTo(BigDecimal.ZERO) > 0) {
                return MessageResult.error(msService.getMessage("CANCEL_CLOSING_ORDERS1"));
            }
            if(wallet.getUsdtBuyPosition().compareTo(BigDecimal.ZERO) <= 0) {
                return MessageResult.error(msService.getMessage("NO_LONG_ORDER"));
            }
            volumeBuy = wallet.getUsdtBuyPosition();
        }else if(type == 1) {
            if(wallet.getUsdtFrozenSellPosition().compareTo(BigDecimal.ZERO) > 0) {
                return MessageResult.error(msService.getMessage("CANCEL_CLOSING_ORDERS2"));
            }
            if(wallet.getUsdtSellPosition().compareTo(BigDecimal.ZERO) <= 0) {
                return MessageResult.error(msService.getMessage("NO_SHORT_ORDER"));
            }
            volumeSell = wallet.getUsdtSellPosition();
        }else if(type == 2){
            if(wallet.getUsdtFrozenSellPosition().compareTo(BigDecimal.ZERO) > 0 || wallet.getUsdtFrozenBuyPosition().compareTo(BigDecimal.ZERO) > 0) {
                return MessageResult.error(msService.getMessage("CANCEL_CLOSING_ORDERS3"));
            }
            if(wallet.getUsdtBuyPosition().compareTo(BigDecimal.ZERO) <= 0 && wallet.getUsdtSellPosition().compareTo(BigDecimal.ZERO) <= 0) {
                return MessageResult.error(msService.getMessage("NO_LONG_SHORT_ORDERS"));
            }
            volumeBuy = wallet.getUsdtBuyPosition();
            volumeSell = wallet.getUsdtSellPosition();
        }

        BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(contractCoin.getSymbol()).getNowPrice();

        // 多仓平仓
        if(type == 0 || type == 2) {
            BigDecimal volume = volumeBuy;

            closeFee = wallet.getUsdtBuyPrincipalAmount().multiply(contractCoin.getCloseFee());
            // 新建合约委托单
            ContractOrderEntrust orderEntrust = new ContractOrderEntrust();
            orderEntrust.setContractId(contractCoin.getId()); // 合约ID
            orderEntrust.setMemberId(member.getId()); // 用户ID
            orderEntrust.setSymbol(contractCoin.getSymbol()); // 交易对符号
            orderEntrust.setBaseSymbol(contractCoin.getSymbol().split("/")[1]); // 基币/结算币
            orderEntrust.setCoinSymbol(contractCoin.getSymbol().split("/")[0]); // 币种符号
            orderEntrust.setDirection(ContractOrderDirection.SELL); // 平仓方向：平空/平多
            orderEntrust.setContractOrderEntrustId(GeneratorUtil.getOrderId("CE"));
            orderEntrust.setVolume(volume); // 平仓张数
            orderEntrust.setTradedVolume(BigDecimal.ZERO); // 已交易数量
            orderEntrust.setTradedPrice(BigDecimal.ZERO); // 成交价格
            orderEntrust.setPrincipalUnit("USDT"); // 保证金单位
            orderEntrust.setPrincipalAmount(BigDecimal.ZERO); // 保证金数量
            orderEntrust.setCreateTime(DateUtil.getTimeMillis()); // 开仓时间
            orderEntrust.setType(ContractOrderType.MARKET_PRICE);
            orderEntrust.setTriggerPrice(BigDecimal.ZERO); // 触发价
            orderEntrust.setEntrustPrice(BigDecimal.ZERO); // 委托价格
            orderEntrust.setEntrustType(ContractOrderEntrustType.CLOSE); // 平仓
            orderEntrust.setTriggeringTime(0L); // 触发时间，暂时无效
            orderEntrust.setShareNumber(contractCoin.getShareNumber());
            orderEntrust.setProfitAndLoss(BigDecimal.ZERO); // 盈亏（仅平仓计算）
            orderEntrust.setPatterns(wallet.getUsdtPattern()); // 仓位模式
            orderEntrust.setCloseFee(closeFee);
            orderEntrust.setCurrentPrice(currentPrice);
            orderEntrust.setIsBlast(0); // 不是爆仓单
            orderEntrust.setIsFromSpot(0);
            orderEntrust.setPrincipalAmount(wallet.getUsdtBuyPrincipalAmount()); // 全部多仓保证金

            memberContractWalletService.freezeUsdtBuyPosition(wallet.getId(), volume);

            // 保存委托单
            orderEntrust.setStatus(ContractOrderEntrustStatus.ENTRUST_ING); // 委托状态：委托中
            ContractOrderEntrust retObj = contractOrderEntrustService.save(orderEntrust);

            if (retObj != null) {
                // 发送消息至Exchange系统
                kafkaTemplate.send("swap-order-close", JSON.toJSONString(retObj));

                //通知钱包变更
                JSONObject jsonObj = new JSONObject();
                jsonObj.put("symbol", contractCoin.getSymbol());
                jsonObj.put("walletId", wallet.getId());
                kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));

                log.info(">>>>>>>>>>订单提交完成>>>>>>>>>>");
                // 返回结果
                MessageResult result = MessageResult.success(msService.getMessage("SWAP_SUCCESS"));
                result.setData(retObj);
                return result;
            } else {
                // 返回结果
                MessageResult result = MessageResult.error(msService.getMessage("SWAP_FAILED"));
                result.setData(null);
                return result;
            }
        }


        // 空仓平仓
        if(type == 1 || type == 2) {
            BigDecimal volume = volumeSell;
            // 1、计算平仓手续费(保证金 * 开仓费率）
            closeFee = wallet.getUsdtSellPrincipalAmount().multiply(contractCoin.getCloseFee());

            // 新建合约委托单
            ContractOrderEntrust orderEntrust = new ContractOrderEntrust();
            orderEntrust.setContractId(contractCoin.getId()); // 合约ID
            orderEntrust.setMemberId(member.getId()); // 用户ID
            orderEntrust.setSymbol(contractCoin.getSymbol()); // 交易对符号
            orderEntrust.setBaseSymbol(contractCoin.getSymbol().split("/")[1]); // 基币/结算币
            orderEntrust.setCoinSymbol(contractCoin.getSymbol().split("/")[0]); // 币种符号
            orderEntrust.setDirection(ContractOrderDirection.BUY); // 平仓方向：平空/平多
            orderEntrust.setContractOrderEntrustId(GeneratorUtil.getOrderId("CE"));
            orderEntrust.setVolume(volume); // 平仓张数
            orderEntrust.setTradedVolume(BigDecimal.ZERO); // 已交易数量
            orderEntrust.setTradedPrice(BigDecimal.ZERO); // 成交价格
            orderEntrust.setPrincipalUnit("USDT"); // 保证金单位
            orderEntrust.setPrincipalAmount(BigDecimal.ZERO); // 保证金数量
            orderEntrust.setCreateTime(DateUtil.getTimeMillis()); // 开仓时间
            orderEntrust.setType(ContractOrderType.MARKET_PRICE);
            orderEntrust.setTriggerPrice(BigDecimal.ZERO); // 触发价
            orderEntrust.setEntrustPrice(BigDecimal.ZERO); // 委托价格
            orderEntrust.setEntrustType(ContractOrderEntrustType.CLOSE); // 平仓
            orderEntrust.setTriggeringTime(0L); // 触发时间，暂时无效
            orderEntrust.setShareNumber(contractCoin.getShareNumber());
            orderEntrust.setProfitAndLoss(BigDecimal.ZERO); // 盈亏（仅平仓计算）
            orderEntrust.setPatterns(wallet.getUsdtPattern()); // 仓位模式
            orderEntrust.setCloseFee(closeFee);
            orderEntrust.setCurrentPrice(currentPrice);
            orderEntrust.setIsBlast(0); // 不是爆仓单
            orderEntrust.setIsFromSpot(0);
            orderEntrust.setPrincipalAmount(wallet.getUsdtSellPrincipalAmount()); // 全部多仓保证金

            memberContractWalletService.freezeUsdtSellPosition(wallet.getId(), volume);

            // 保存委托单
            orderEntrust.setStatus(ContractOrderEntrustStatus.ENTRUST_ING); // 委托状态：委托中
            ContractOrderEntrust retObj = contractOrderEntrustService.save(orderEntrust);

            if (retObj != null) {
                // 发送消息至Exchange系统
                kafkaTemplate.send("swap-order-close", JSON.toJSONString(retObj));

                //通知钱包变更
                JSONObject jsonObj = new JSONObject();
                jsonObj.put("symbol", contractCoin.getSymbol());
                jsonObj.put("walletId", wallet.getId());
                kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));

                log.info(">>>>>>>>>>订单提交完成>>>>>>>>>>");
                // 返回结果
                MessageResult result = MessageResult.success(msService.getMessage("SWAP_SUCCESS"));
                result.setData(retObj);
                return result;
            } else {
                // 返回结果
                MessageResult result = MessageResult.error(msService.getMessage("SWAP_FAILED"));
                result.setData(null);
                return result;
            }
        }

        return MessageResult.error(msService.getMessage("UNABLE_CLOSE_POSITION"));
    }

    /**
     * 合约撤销单
     * @param authMember
     * @param entrustId
     * @return
     */
    @RequestMapping("cancel")
    public MessageResult cancelOrder(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                     Long entrustId
    ) {
        ContractOrderEntrust entrustOrder = contractOrderEntrustService.findOne(entrustId);
        if(entrustOrder == null) {
            return MessageResult.error(500, msService.getMessage("ORDER_NO_EXIST"));
        }
        if(entrustOrder.getMemberId() != authMember.getId()) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_OPERATION"));
        }
        if(entrustOrder.getStatus() != ContractOrderEntrustStatus.ENTRUST_ING) {
            return MessageResult.error(500, msService.getMessage("DELEGATE_STATUS_ERROR"));
        }

        // 发送消息至Exchange系统
        kafkaTemplate.send("swap-order-cancel", JSON.toJSONString(entrustOrder));

        log.info(">>>>>>>>>>订单提交完成>>>>>>>>>>");
        // 返回结果
        MessageResult result = MessageResult.success(msService.getMessage("CANCELLATION_SUCCESSFUL"));
        result.setData(entrustOrder);
        return result;
    }

    /**
     * 合约撤销单(撤销所有委托，限价+计划+市价)
     * @param authMember
     * @param contractCoinId
     * @return
     */
    @RequestMapping("cancel-all")
    public MessageResult cancelAllOrder(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                        Long contractCoinId
    ) {
        List<ContractOrderEntrust> orderList = contractOrderEntrustService.findAllByMemberIdAndContractId(authMember.getId(), contractCoinId);
        if(orderList != null && orderList.size() > 0) {
            for (int i = 0; i < orderList.size(); i++) {
                ContractOrderEntrust entrustOrder = orderList.get(i);
                if (entrustOrder.getMemberId() != authMember.getId()) {
                    continue;
                }
                if (entrustOrder.getStatus() != ContractOrderEntrustStatus.ENTRUST_ING) {
                    continue;
                }

                // 发送消息至Exchange系统
                kafkaTemplate.send("swap-order-cancel", JSON.toJSONString(entrustOrder));
            }
        }
        log.info(">>>>>>>>>>撤销所有委托成功>>>>>>>>>>");
        // 返回结果
        MessageResult result = MessageResult.success(msService.getMessage("CANCELLATION_SUCCESSFUL"));
        return result;
    }

    /**
     * 获取当前持仓列表
     *
     * @param authMember
     * @return
     */
    @RequestMapping("position-list")
    public MessageResult positionList(@SessionAttribute(SESSION_MEMBER) AuthMember authMember) {
        Member member = memberService.findOne(authMember.getId());
        if (member == null) {
            return MessageResult.error(500, msService.getMessage("ACCOUNT_NOT_EXIST"));
        }
        List<MemberContractWallet> list = memberContractWalletService.findAllByMemberId(authMember.getId());
        if (list == null) {
            return MessageResult.error(500, msService.getMessage("WALLET_NOT_IN"));
        }

        // 计算账户权益
        for (MemberContractWallet wallet : list) {
            BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(wallet.getContractCoin().getSymbol()).getNowPrice();
            // 计算金本位权益（多仓 + 空仓）
            BigDecimal usdtTotalProfitAndLoss = BigDecimal.ZERO;
            // 多仓计算方法：（当前价格 / 开仓均价 - 1）* （可用仓位 + 冻结仓位） * 合约面值
            if (wallet.getUsdtBuyPrice().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(currentPrice.divide(wallet.getUsdtBuyPrice(), 4, BigDecimal.ROUND_DOWN).subtract(BigDecimal.ONE).multiply(wallet.getUsdtBuyPosition().add(wallet.getUsdtFrozenBuyPosition())).multiply(wallet.getUsdtShareNumber()));
            }

            // 空仓计算方法：（1 - 当前价格 / 开仓均价）* （可用仓位 + 冻结仓位） * 合约面值
            if (wallet.getUsdtSellPrice().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(BigDecimal.ONE.subtract(currentPrice.divide(wallet.getUsdtSellPrice(), 4, BigDecimal.ROUND_DOWN)).multiply(wallet.getUsdtSellPosition().add(wallet.getUsdtFrozenSellPosition())).multiply(wallet.getUsdtShareNumber()));
            }

            wallet.setUsdtTotalProfitAndLoss(usdtTotalProfitAndLoss);
        }

        MessageResult result = MessageResult.success("success");
        result.setData(list);
        return result;
    }

    /**
     * 获取当前持仓详情
     *
     * @param authMember
     * @return
     */
    @RequestMapping("position-detail")
    public MessageResult positionDetail(@SessionAttribute(SESSION_MEMBER) AuthMember authMember, Long contractCoinId) {
        Member member = memberService.findOne(authMember.getId());
        if (member == null) {
            return MessageResult.error(500, msService.getMessage("ACCOUNT_NOT_EXIST"));
        }
        ContractCoin coin = contractCoinService.findOne(contractCoinId);
        if (coin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        MemberContractWallet wallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), coin);
        if (wallet == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));
        }

        // 计算账户权益
        BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(coin.getSymbol()).getNowPrice();

        // 计算金本位权益（多仓 + 空仓）
        BigDecimal usdtTotalProfitAndLoss = BigDecimal.ZERO;
        // 多仓计算方法：（当前价格 / 开仓均价 - 1）* （可用仓位 + 冻结仓位） * 合约面值
        if (wallet.getUsdtBuyPrice().compareTo(BigDecimal.ZERO) > 0) {
            usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(currentPrice.divide(wallet.getUsdtBuyPrice(), 4, BigDecimal.ROUND_DOWN).subtract(BigDecimal.ONE).multiply(wallet.getUsdtBuyPosition().add(wallet.getUsdtFrozenBuyPosition())).multiply(wallet.getUsdtShareNumber()));
        }
        // 空仓计算方法：（1 - 当前价格 / 开仓均价）* （可用仓位 + 冻结仓位） * 合约面值
        if (wallet.getUsdtSellPrice().compareTo(BigDecimal.ZERO) > 0) {
            usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(BigDecimal.ONE.subtract(currentPrice.divide(wallet.getUsdtSellPrice(), 4, BigDecimal.ROUND_DOWN)).multiply(wallet.getUsdtSellPosition().add(wallet.getUsdtFrozenSellPosition())).multiply(wallet.getUsdtShareNumber()));
        }

        wallet.setUsdtTotalProfitAndLoss(usdtTotalProfitAndLoss);

        MessageResult result = MessageResult.success("success");
        result.setData(wallet);
        return result;
    }

    /**
     * 获取当前委托列表
     *
     * @param authMember
     * @return
     */
    @RequestMapping("current")
    public Page<ContractOrderEntrust> entrustList(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                                  Long contractCoinId, // 合约交易对
                                                  int pageNo,
                                                  int pageSize
    ) {
        Page<ContractOrderEntrust> contractOrderEntrustOrders = contractOrderEntrustService.queryPageEntrustingOrdersBySymbol(authMember.getId(), contractCoinId, pageNo, pageSize);
        return contractOrderEntrustOrders;
    }

    /**
     * 获取历史委托列表
     *
     * @param authMember
     * @return
     */
    @RequestMapping("history")
    public Page<ContractOrderEntrust> entrustListHistory(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                                         Long contractCoinId, // 合约交易对
                                                         int pageNo,
                                                         int pageSize
    ) {
        Page<ContractOrderEntrust> contractOrderEntrustOrders = contractOrderEntrustService.queryPageEntrustHistoryOrdersBySymbol(authMember.getId(), contractCoinId, pageNo, pageSize);
        return contractOrderEntrustOrders;
    }

    /**
     * 是否能够切换持仓模式（全仓、逐仓）
     * 需要查询是否有逐仓/全仓订单（有则不能下单）
     *
     * @param authMember
     * @param targetPattern 目标模式（1：全仓， 2：逐仓）
     * @return
     */
    @RequestMapping("can-switch-pattern")
    public MessageResult canSwitchPattern(@SessionAttribute(SESSION_MEMBER) AuthMember authMember, Long contractCoinId, ContractOrderPattern targetPattern) {

        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        MemberContractWallet wallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (wallet == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));
        }

        ContractOrderPattern temPattern = targetPattern == ContractOrderPattern.CROSSED ? ContractOrderPattern.FIXED : ContractOrderPattern.CROSSED;
        // 查询所有委托的订单
        long sizeEntrustOrder = contractOrderEntrustService.queryEntrustingOrdersCountByContractCoinIdAndPattern(authMember.getId(), contractCoinId, temPattern);
        if (sizeEntrustOrder > 0) {
            return MessageResult.error(500, msService.getMessage("CLOSE_WITHDRAW"));
        }
        MessageResult result = MessageResult.success("success");
        result.setData(null);
        return result;
    }

    /**
     * 更改持仓模式
     * 因本合约是金本位合约，因此切换持仓模式会切换所有交易对的仓位模式，所以会查询所有非目标持仓模式的订单，从而进行判断是否能够切换仓位
     *
     * @param authMember
     * @param contractCoinId
     * @param targetPattern
     * @return
     */
    @RequestMapping("switch-pattern")
    public MessageResult switchPattern(@SessionAttribute(SESSION_MEMBER) AuthMember authMember, Long contractCoinId, ContractOrderPattern targetPattern) {
        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        MemberContractWallet memberContractWallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (memberContractWallet == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));
        }

        if (targetPattern != ContractOrderPattern.FIXED && targetPattern != ContractOrderPattern.CROSSED) {
            return MessageResult.error(500, msService.getMessage("ILLEGAL_ARGUMENT"));
        }
        ContractOrderPattern temPattern = targetPattern == ContractOrderPattern.CROSSED ? ContractOrderPattern.FIXED : ContractOrderPattern.CROSSED;
        // 查询当前合约是否有正在委托的单
        long sizeEntrustOrder = contractOrderEntrustService.queryEntrustingOrdersCountByContractCoinIdAndPattern(authMember.getId(), contractCoinId, temPattern);
        if (sizeEntrustOrder > 0) {
            return MessageResult.error(500, msService.getMessage("CANCEL_FIRST"));
        }

        memberContractWallet.setUsdtPattern(targetPattern);
        memberContractWallet = memberContractWalletService.save(memberContractWallet);

        if (memberContractWallet != null) {

            //通知钱包变更
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("symbol", contractCoin.getSymbol());
            jsonObj.put("walletId", memberContractWallet.getId());
            kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));

            MessageResult result = MessageResult.success(msService.getMessage("POSITION_MODE1"));
            result.setData(memberContractWallet);
            return result;
        } else {
            return MessageResult.error(500, msService.getMessage("POSITION_MODE2"));
        }
    }

    /**
     * 修改指定交易对的合约倍数
     * 调整合约倍数理论上应该会将现有持仓订单中的多余保证金释放出来，但是本系统暂未实现此功能，留待后续需要再实现
     * 调整合约其实仅仅会影响用户相同保证金能开多少张合约的计算
     *
     * @param authMember
     * @param contractCoinId
     * @param leverage
     * @param direction
     * @return
     */
    @RequestMapping("modify-leverage")
    public MessageResult modifyLeverage(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                        Long contractCoinId,
                                        BigDecimal leverage,
                                        ContractOrderDirection direction) {
        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        MemberContractWallet memberContractWallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (memberContractWallet == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));
        }

        // 合约倍数是否在规定范围
        if (contractCoin.getLeverageType() == 1) { // 分离倍数
            String[] leverageArr = contractCoin.getLeverage().split(",");
            boolean isExist = false;
            for (String str : leverageArr) {
                if (BigDecimal.valueOf(Integer.parseInt(str)).compareTo(leverage) == 0) {
                    isExist = true;
                }
            }
            if (!isExist) {
                return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_NOT_EXIST"));
            }
        } else { // 范围倍数
            String[] leverageArr = contractCoin.getLeverage().split(",");
            if (leverageArr.length != 2) return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_ERROR"));

            BigDecimal low = BigDecimal.valueOf(Integer.parseInt(leverageArr[0]));
            BigDecimal high = BigDecimal.valueOf(Integer.parseInt(leverageArr[1]));
            if (leverage.compareTo(low) < 0 || leverage.compareTo(high) > 0) {
                return MessageResult.error(500, msService.getMessage("CONTRACT_MULTIPLE_NOT_ALLOWED"));
            }
        }

        // 查询当前合约是否有正在委托的单
        long sizeEntrustOrder = contractOrderEntrustService.queryEntrustingOrdersCountByContractCoinId(authMember.getId(), contractCoinId);
        if (sizeEntrustOrder > 0) {
            return MessageResult.error(500, msService.getMessage("CANCEL_FIRST"));
        }

        // 如果当前是逐仓模式，需要追加保证金的场合（合约倍数增加），要检查保证金是否足够
        if (memberContractWallet.getUsdtPattern() == ContractOrderPattern.FIXED) {
            if (direction == ContractOrderDirection.BUY) { // 调整多仓合约倍数
                if (leverage.compareTo(memberContractWallet.getUsdtBuyLeverage()) > 0) { // 如果合约加大
                    // 计算保证金
                    BigDecimal needPrinAmount = memberContractWallet.getUsdtBuyPosition().multiply(memberContractWallet.getUsdtShareNumber()).divide(leverage, 8, BigDecimal.ROUND_DOWN);
                    if (needPrinAmount.compareTo(memberContractWallet.getUsdtBuyPrincipalAmount()) > 0) {
                        // 调整保证金(如果余额不足以支付保证金，报错)
                        if (memberContractWallet.getUsdtBalance().compareTo(needPrinAmount.subtract(memberContractWallet.getUsdtBuyPrincipalAmount())) < 0) {
                            return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN"));
                        }
                        // 增加保证金
                        memberContractWalletService.increaseUsdtBuyPrincipalAmount(memberContractWallet.getId(), needPrinAmount.subtract(memberContractWallet.getUsdtBuyPrincipalAmount()));
                    }
                }
                // 合约倍数降低，不会减少保证金，此处有待商榷，其实无所谓
                // 调整合约倍数
                memberContractWalletService.modifyUsdtBuyAndSellLeverage(memberContractWallet.getId(), leverage);
            } else { // 调整空仓合约倍数
                if (leverage.compareTo(memberContractWallet.getUsdtSellLeverage()) > 0) { // 如果合约加大
                    // 计算保证金
                    BigDecimal needPrinAmount = memberContractWallet.getUsdtSellPosition().multiply(memberContractWallet.getUsdtShareNumber()).divide(leverage, 8, BigDecimal.ROUND_DOWN);
                    if (needPrinAmount.compareTo(memberContractWallet.getUsdtSellPrincipalAmount()) > 0) {
                        // 调整保证金(如果余额不足以支付保证金，报错)
                        if (memberContractWallet.getUsdtBalance().compareTo(needPrinAmount.subtract(memberContractWallet.getUsdtSellPrincipalAmount())) < 0) {
                            return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN"));
                        }
                        // 增加保证金
                        memberContractWalletService.increaseUsdtSellPrincipalAmount(memberContractWallet.getId(), needPrinAmount.subtract(memberContractWallet.getUsdtSellPrincipalAmount()));
                    }
                }
                // 合约倍数降低，不会减少保证金，此处有待商榷，其实无所谓
                // 调整合约倍数
                memberContractWalletService.modifyUsdtBuyAndSellLeverage(memberContractWallet.getId(), leverage);
            }
            //通知钱包变更
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("symbol", contractCoin.getSymbol());
            jsonObj.put("walletId", memberContractWallet.getId());
            kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));
        } else {// 如果当前是全仓模式，需要检查保证金够不够(根据最新价格计算)
            BigDecimal totalNeedPrin = BigDecimal.ZERO;
            BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(contractCoin.getSymbol()).getNowPrice();
            if (direction == ContractOrderDirection.BUY) { // 调整多仓合约倍数
                totalNeedPrin = totalNeedPrin.add(memberContractWallet.getUsdtBuyPosition().multiply(memberContractWallet.getUsdtShareNumber()).divide(leverage, 8, BigDecimal.ROUND_DOWN));
            } else {
                totalNeedPrin = totalNeedPrin.add(memberContractWallet.getUsdtSellPosition().multiply(memberContractWallet.getUsdtShareNumber()).divide(leverage, 8, BigDecimal.ROUND_DOWN));
            }

            // 计算账户总权益
            // 计算金本位权益（多仓 + 空仓）
            BigDecimal usdtTotalProfitAndLoss = BigDecimal.ZERO;
            // 多仓计算方法：（当前价格 / 开仓均价 - 1）* （可用仓位 + 冻结仓位） * 合约面值
            if (memberContractWallet.getUsdtBuyPrice().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(currentPrice.divide(memberContractWallet.getUsdtBuyPrice(), 8, BigDecimal.ROUND_DOWN).subtract(BigDecimal.ONE).multiply(memberContractWallet.getUsdtBuyPosition()).multiply(memberContractWallet.getUsdtShareNumber()));
            }
            // 空仓计算方法：（1 - 当前价格 / 开仓均价）* （可用仓位 + 冻结仓位） * 合约面值
            if (memberContractWallet.getUsdtSellPrice().compareTo(BigDecimal.ZERO) > 0) {
                usdtTotalProfitAndLoss = usdtTotalProfitAndLoss.add(BigDecimal.ONE.subtract(currentPrice.divide(memberContractWallet.getUsdtSellPrice(), 8, BigDecimal.ROUND_DOWN)).multiply(memberContractWallet.getUsdtSellPosition()).multiply(memberContractWallet.getUsdtShareNumber()));
            }

            // 如果总共需要的保证金 大于 可用余额+多仓仓位保证金+空仓仓位保证金
            if (totalNeedPrin.compareTo(usdtTotalProfitAndLoss.add(memberContractWallet.getUsdtBalance()).add(memberContractWallet.getUsdtBuyPrincipalAmount()).add(memberContractWallet.getUsdtSellPrincipalAmount())) > 0) {
                return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN"));
            }

            //合约调整倍率
            memberContractWalletService.modifyUsdtBuyAndSellLeverage(memberContractWallet.getId(), leverage);
            //通知钱包变更
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("symbol", contractCoin.getSymbol());
            jsonObj.put("walletId", memberContractWallet.getId());
            kafkaTemplate.send("member-wallet-change", JSON.toJSONString(jsonObj));
        }

        MessageResult result = MessageResult.success("success");
        result.setData(null);
        return result;
    }

    /**
     * 调整保证金
     *
     * @param authMember
     * @param contractCoinId
     * @param principal
     * @param direction
     * @param type           0:增加  1：减少
     * @return
     */
    @RequestMapping("ajust-principal")
    public MessageResult ajustPrincipal(@SessionAttribute(SESSION_MEMBER) AuthMember authMember,
                                        Long contractCoinId,
                                        BigDecimal principal,
                                        ContractOrderDirection direction,
                                        Integer type) {
        ContractCoin contractCoin = contractCoinService.findOne(contractCoinId);
        if (contractCoin == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_NOT_EXIST"));
        }
        MemberContractWallet memberContractWallet = memberContractWalletService.findByMemberIdAndContractCoin(authMember.getId(), contractCoin);
        if (memberContractWallet == null) {
            return MessageResult.error(500, msService.getMessage("CONTRACT_ACCOUNT_NOT_EXIST"));
        }
        if (memberContractWallet.getUsdtPattern() == ContractOrderPattern.CROSSED) {
            return MessageResult.error(500, msService.getMessage("FULL_WAREHOUSE_MODE"));
        }

        // 获取当前价格
        BigDecimal currentPrice = contractCoinMatchFactory.getContractCoinMatch(contractCoin.getSymbol()).getNowPrice();
        if (direction == ContractOrderDirection.BUY) { // 调整多仓保证金
            if (type == 1) { // 减少保证金
                // 计算盈亏
                BigDecimal pL = currentPrice.divide(memberContractWallet.getUsdtBuyPrice(), 8, BigDecimal.ROUND_DOWN).subtract(BigDecimal.ONE).multiply(memberContractWallet.getUsdtBuyPosition()).multiply(memberContractWallet.getUsdtShareNumber());
                // 如果减少后的保证金 小于 持仓需要保证金
                if (memberContractWallet.getUsdtBuyPrincipalAmount().subtract(principal).compareTo(memberContractWallet.getUsdtBuyPrincipalAmount().add(pL)) < 0) {
                    return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN_UNABLE_ADJUST"));
                } else {
                    memberContractWalletService.decreaseUsdtBuyPrincipalAmount(memberContractWallet.getId(), principal);
                    return MessageResult.success("success");
                }
            } else { // 直接增加保证金
                if (memberContractWallet.getUsdtBalance().compareTo(principal) < 0) {
                    return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN_UNABLE_ADJUST"));
                }
                memberContractWalletService.increaseUsdtBuyPrincipalAmount(memberContractWallet.getId(), principal);
                return MessageResult.success("success");
            }
        } else {
            if (type == 1) { // 减少保证金
                // 计算盈亏
                BigDecimal pL = BigDecimal.ONE.subtract(currentPrice.divide(memberContractWallet.getUsdtSellPrice(), 8, BigDecimal.ROUND_DOWN)).multiply(memberContractWallet.getUsdtSellPosition()).multiply(memberContractWallet.getUsdtShareNumber());
                // 如果减少后的保证金 小于 持仓需要保证金
                if (memberContractWallet.getUsdtSellPrincipalAmount().subtract(principal).compareTo(memberContractWallet.getUsdtSellPrincipalAmount().add(pL)) < 0) {
                    return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN_UNABLE_ADJUST"));
                } else {
                    memberContractWalletService.decreaseUsdtSellPrincipalAmount(memberContractWallet.getId(), principal);
                    return MessageResult.success("success");
                }
            } else { // 直接增加保证金
                if (memberContractWallet.getUsdtBalance().compareTo(principal) < 0) {
                    return MessageResult.error(500, msService.getMessage("INSUFFICIENT_MARGIN_UNABLE_ADJUST"));
                }
                memberContractWalletService.increaseUsdtSellPrincipalAmount(memberContractWallet.getId(), principal);
                return MessageResult.success("success");
            }
        }
    }
}