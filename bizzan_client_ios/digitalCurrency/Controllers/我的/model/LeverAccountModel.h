//
//  LeverAccountModel.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LeverWalletModel;
@class LeverCoinModel;
@class CoinModel;

NS_ASSUME_NONNULL_BEGIN
@interface LeverAccountModel : NSObject
@property(nonatomic,copy)NSString *coinCanLoan;
@property(nonatomic,copy)NSString *riskRate;
@property(nonatomic,strong)NSArray<LeverWalletModel *> *leverWalletList;
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString *baseCanLoan;
@property(nonatomic,copy)NSString *baseLoanCount;
@property(nonatomic,copy)NSString *proportion;
@property(nonatomic,copy)NSString *coinLoanCount;
@property(nonatomic,copy)NSString *explosionRiskRate;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *coinAccumulativeCount;
@property(nonatomic,copy)NSString *baseAccumulativeCount;
@property(nonatomic,copy)NSString *explosionPrice;
@property(nonatomic,assign)BOOL isHidden;

@end

@interface LeverWalletModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *foldBtc;
@property(nonatomic,strong)LeverCoinModel *LeverCoin;
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *frozenBalance;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *isLock;
@property(nonatomic,strong)CoinModel *coin;

@property(nonatomic,copy)NSString *interestRate;
@property(nonatomic,copy)NSString *loanBalance;
@property(nonatomic,copy)NSString *accumulative;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *repayment;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *interest;

@end

@interface LeverCoinModel : NSObject
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString *enable;
@property(nonatomic,copy)NSString *baseSymbol;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *interestRate;
@property(nonatomic,copy)NSString *coinSymbol;
@property(nonatomic,copy)NSString *minTurnIntoAmount;
@property(nonatomic,copy)NSString *minTurnOutAmount;
@property(nonatomic,copy)NSString *proportion;
@property(nonatomic,copy)NSString *ID;

@end

@interface CoinModel : NSObject
@property(nonatomic,copy)NSString *cnyRate;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *maxTxFee;
@property(nonatomic,copy)NSString *canWithdraw;
@property(nonatomic,copy)NSString *canAutoWithdraw;
@property(nonatomic,copy)NSString *withdrawThreshold;
@property(nonatomic,copy)NSString *maxWithdrawAmount;
@property(nonatomic,copy)NSString *allBalance;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *withdrawScale;
@property(nonatomic,copy)NSString *canTransfer;
@property(nonatomic,copy)NSString *minWithdrawAmount;
@property(nonatomic,copy)NSString *maxDailyWithdrawRate;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *hasLegal;
@property(nonatomic,copy)NSString *enableRpc;
@property(nonatomic,copy)NSString *minerFee;
@property(nonatomic,copy)NSString *minRechargeAmount;
@property(nonatomic,copy)NSString *masterAddress;
@property(nonatomic,copy)NSString *minTxFee;
@property(nonatomic,copy)NSString *coldWalletAddress;
@property(nonatomic,copy)NSString *canRecharge;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *isPlatformCoin;
@property(nonatomic,copy)NSString *hotAllBalance;
@property(nonatomic,copy)NSString *usdRate;
@property(nonatomic,copy)NSString *nameCn;
@property(nonatomic,copy)NSString *sgdRate;

@end

NS_ASSUME_NONNULL_END
