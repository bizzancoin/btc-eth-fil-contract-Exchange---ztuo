//
//  AssetModel.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetModel : NSObject

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *baseSymbol;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *interestRate;
@property (nonatomic, copy) NSString *coinSymbol;
@property (nonatomic, copy) NSString *minTurnIntoAmount;
@property (nonatomic, copy) NSString *minTurnOutAmount;
@property (nonatomic, copy) NSString *proportion;

@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *nameCn;
@property (nonatomic, copy) NSString *jyRate;
@property (nonatomic, copy) NSString *coinScale;
@property (nonatomic, copy) NSString *maxTradingTime;
@property (nonatomic, copy) NSString *maxVolume;
@property (nonatomic, copy) NSString *sellMinAmount;
@property (nonatomic, copy) NSString *isPlatformCoin;
@property (nonatomic, copy) NSString *buyMinAmount;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
