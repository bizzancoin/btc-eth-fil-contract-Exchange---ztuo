package com.bizzan.bitrade.service;

import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.constant.TransactionType;
import com.bizzan.bitrade.dao.CoinDao;
import com.bizzan.bitrade.dao.MemberDao;
import com.bizzan.bitrade.dao.MemberDepositDao;
import com.bizzan.bitrade.dao.MemberWalletDao;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.service.Base.BaseService;
import com.bizzan.bitrade.service.Base.TopBaseService;
import com.bizzan.bitrade.util.MessageResult;
import com.bizzan.bitrade.util.PredicateUtils;
import com.bizzan.bitrade.vendor.provider.SMSProvider;
import com.bizzan.bitrade.vo.MemberDepositVO;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQuery;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Service
public class MemberDepositService extends BaseService<MemberDeposit> {

    @Autowired
    private MemberDepositDao memberDepositDao ;
    @Autowired
    private MemberWalletDao memberWalletDao;
    @Autowired
    private MemberTransactionService transactionService;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private CoinDao coinDao;
//    @Autowired
//    private SMSProvider smsProvider;

    public Page<MemberDepositVO> page(List<BooleanExpression> predicates,PageModel pageModel){
        JPAQuery<MemberDepositVO> query = queryFactory.select(Projections.fields(MemberDepositVO.class,
                QMemberDeposit.memberDeposit.id.as("id"),
                QMember.member.username,
                QMember.member.id.as("memberId"),
                QMemberDeposit.memberDeposit.address,
                QMemberDeposit.memberDeposit.amount,
                QMemberDeposit.memberDeposit.status.as("status"),
                QMemberDeposit.memberDeposit.createTime.as("createTime"),
                QMemberDeposit.memberDeposit.unit)).from(QMember.member,QMemberDeposit.memberDeposit)
                .where(predicates.toArray(new BooleanExpression[predicates.size()]));
        List<OrderSpecifier> orderSpecifiers = pageModel.getOrderSpecifiers();
        query.orderBy(orderSpecifiers.toArray(new OrderSpecifier[orderSpecifiers.size()])) ;
        long total = query.fetchCount() ;
        query.offset(pageModel.getPageSize()*(pageModel.getPageNo()-1)).limit(pageModel.getPageSize());
        List<MemberDepositVO> list = query.fetch() ;
        return new PageImpl<MemberDepositVO>(list,pageModel.getPageable(),total);
    }

    public Long getMaxId() {
    	return memberDepositDao.getMaxId();
    }

    public void audit(Long id, Integer status) {
        MemberDeposit deposit = memberDepositDao.findOne(id);
        if(deposit.getStatus()==0){
            deposit.setStatus(status);
            memberDepositDao.save(deposit);
            if(status==1){
                //增加余额
                Coin coin = coinDao.findByUnit(deposit.getUnit());
                MemberWallet wallet = memberWalletDao.getMemberWalletByCoinAndMemberId(coin.getName(), deposit.getMemberId());
                if (wallet == null) {
//                    return new MessageResult(500, "wallet cannot be null");
                    return;
                }
                if (deposit.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
                    return;
//                    return new MessageResult(500, "amount must large then 0");
                }
                // ERC20 USDT充值，余额增加到USDT上
//                if(coin.getUnit().equals("EUSDT")) {
//                    MemberWallet walletShadow = findByCoinUnitAndMemberId("USDT", wallet.getMemberId());
//                    walletShadow.setBalance(walletShadow.getBalance().add(amount));
//                }else {
                    wallet.setBalance(wallet.getBalance().add(deposit.getAmount())); // 为用户增加余额
//                }

                MemberTransaction transaction = new MemberTransaction();
                transaction.setAmount(deposit.getAmount());
                transaction.setSymbol(wallet.getCoin().getUnit());
                transaction.setAddress(wallet.getAddress());
                transaction.setMemberId(wallet.getMemberId());
                transaction.setType(TransactionType.RECHARGE);
                transaction.setFee(BigDecimal.ZERO);
                transaction.setDiscountFee("0");
                transaction.setRealFee("0");
                transaction.setCreateTime(new Date());
                transactionService.save(transaction);
                //短信通知 先去掉
//                Member mRes = memberDao.findOne(wallet.getMemberId());
//                if(mRes != null ) {
//                    try {
//                        smsProvider.sendCustomMessage(mRes.getMobilePhone(), "尊敬的用户：恭喜您充值"+ wallet.getCoin().getUnit() + "成功，充值数量为：" + amount.stripTrailingZeros().toPlainString());
//                    } catch (Exception e) {
//                        e.printStackTrace();
//                    }
//                }
            }
        }
    }

    public void add(Long memberId,BigDecimal amount,String unit) {
        MemberDeposit deposit = new MemberDeposit();
//        deposit.setAddress(address);
        deposit.setAmount(amount);
        deposit.setStatus(0);
        deposit.setMemberId(memberId);
        deposit.setUnit(unit);
        memberDepositDao.save(deposit);
    }

    public Integer countNotHandle() {
       List list = this.memberDepositDao.findAllByStatus(0);
       if(list!=null){
           return list.size();
       }else {
           return 0;
       }
    }
}
