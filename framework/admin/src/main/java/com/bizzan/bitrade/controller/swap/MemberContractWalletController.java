package com.bizzan.bitrade.controller.swap;

import com.alibaba.druid.sql.ast.expr.SQLCaseExpr;
import com.alibaba.fastjson.JSON;
import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.controller.common.BaseAdminController;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.model.screen.ContractOrderEntrustScreen;
import com.bizzan.bitrade.model.screen.MemberContractWalletScreen;
import com.bizzan.bitrade.service.ContractCoinService;
import com.bizzan.bitrade.service.MemberContractWalletService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 持仓管理
 */
@RestController
@RequestMapping("/swap/position")
@Slf4j
public class MemberContractWalletController extends BaseAdminController {
    @Autowired
    private MemberContractWalletService memberContractWalletService;
    @Autowired
    private MemberService memberService;
    @Autowired
    private RestTemplate restTemplate;
    @Autowired
    private ContractCoinService contractCoinService;

    @RequiresPermissions("swap:position:page-query")
    @PostMapping("page-query")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "永续合约用户持仓管理 列表")
    public MessageResult detail(
            PageModel pageModel,
            MemberContractWalletScreen screen) {
        if (pageModel.getDirection() == null && pageModel.getProperty() == null) {
            ArrayList<Sort.Direction> directions = new ArrayList<>();
            directions.add(Sort.Direction.DESC);
            pageModel.setDirection(directions);
            List<String> property = new ArrayList<>();
            property.add("usdtBalance"); // 默认金额排序
            pageModel.setProperty(property);
        }
        //获取查询条件
        Predicate predicate = getPredicate(screen);
        Page<MemberContractWallet> all = memberContractWalletService.findAll(predicate, pageModel.getPageable());
        // 获取最新价格
        String serviceName = "contract-swap-api";
        String marketUrl = "http://" + serviceName + "/swap/symbol-thumb";
//        ResponseEntity<List> thumbsResult = restTemplate.getForEntity(marketUrl, List.class);
//        List<CoinThumb> thumbList = (List<CoinThumb>)thumbsResult.getBody();

        ParameterizedTypeReference<List<CoinThumb>> typeRef = new ParameterizedTypeReference<List<CoinThumb>>() {};
        ResponseEntity<List<CoinThumb>> responseEntity = restTemplate.exchange(marketUrl, HttpMethod.POST, new HttpEntity<>(null), typeRef);
        List<CoinThumb> thumbList =responseEntity.getBody();

        List<MemberContractWallet> list = all.getContent();
        for(MemberContractWallet wallet :list) {
            for(int i = 0; i < thumbList.size(); i++) {
                CoinThumb thumb = thumbList.get(i);
                if(wallet.getContractCoin().getSymbol().equals(thumb.getSymbol())) {
                    wallet.setCurrentPrice(thumb.getClose());
                }
            }

            // 设置CNY / USDT汇率
            wallet.setCnyRate(BigDecimal.valueOf(7));
        }
        return success(all);
    }

    private Predicate getPredicate(MemberContractWalletScreen screen) {
        ArrayList<BooleanExpression> booleanExpressions = new ArrayList<>();
        QMemberContractWallet qMemberContractWallet = QMemberContractWallet.memberContractWallet;
        if (screen.getContractId() != null) {
            ContractCoin coin = contractCoinService.findOne(screen.getContractId());
            booleanExpressions.add(qMemberContractWallet.contractCoin.eq(coin));
        }
        if(screen.getMemberId() != null) {
            booleanExpressions.add(qMemberContractWallet.memberId.eq(screen.getMemberId()));
        }
        if(StringUtils.isNotEmpty(screen.getPhone())) {
            Member member = memberService.findByPhone(screen.getPhone());
            booleanExpressions.add(qMemberContractWallet.memberId.eq(member.getId()));
        }
        if(StringUtils.isNotEmpty(screen.getEmail())) {
            Member member = memberService.findByEmail(screen.getEmail());
            booleanExpressions.add(qMemberContractWallet.memberId.eq(member.getId()));
        }
        if(screen.getUsdtBalance() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtBalance.goe(screen.getUsdtBalance()));
        }
        if(screen.getUsdtFrozenBalance() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtFrozenBalance.goe(screen.getUsdtFrozenBalance()));
        }
        if(screen.getUsdtPattern() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtPattern.eq(screen.getUsdtPattern()));
        }
        if(screen.getUsdtBuyLeverage() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtBuyLeverage.goe(screen.getUsdtBuyLeverage()));
        }
        if(screen.getUsdtSellLeverage() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtSellLeverage.goe(screen.getUsdtSellLeverage()));
        }
        if(screen.getUsdtBuyPosition() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtBuyPosition.goe(screen.getUsdtBuyPosition()));
        }
        if(screen.getUsdtFrozenBuyPosition() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtFrozenBuyPosition.goe(screen.getUsdtFrozenBuyPosition()));
        }
        if(screen.getUsdtBuyPrincipalAmount() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtBuyPrincipalAmount.goe(screen.getUsdtBuyPrincipalAmount()));
        }
        if(screen.getUsdtSellPosition() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtSellPosition.goe(screen.getUsdtSellPosition()));
        }
        if(screen.getUsdtFrozenSellPosition() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtFrozenSellPosition.goe(screen.getUsdtFrozenSellPosition()));
        }
        if(screen.getUsdtSellPrincipalAmount() != null) {
            booleanExpressions.add(qMemberContractWallet.usdtSellPrincipalAmount.goe(screen.getUsdtSellPrincipalAmount()));
        }

        return PredicateUtils.getPredicate(booleanExpressions);
    }


    /**
     * 强制市价平仓
     * @param walletId
     * @return
     */
    @RequiresPermissions("swap:order:force-close")
    @PostMapping("force-close")
    @AccessLog(module = AdminModule.CONTRACTOPTION, operation = "永续合约用户持仓管理 强制平仓")
    public MessageResult forceClose(Long walletId) {
        MemberContractWallet wallet = memberContractWalletService.findOne(walletId);
        if(wallet == null) {
            return MessageResult.error("撤销委托失败");
        }
        return MessageResult.success("操作成功");
    }

}
