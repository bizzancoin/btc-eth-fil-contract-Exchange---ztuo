//
//  FeeLevelModel.h
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeeLevelModel : NSObject

@property (nonatomic, copy) NSString *gradeName;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *gradeBound;
@property (nonatomic, copy) NSString *withdrawCoinAmount;
@property (nonatomic, copy) NSString *dayWithdrawCount;
@property (nonatomic, copy) NSString *gradeCode;
@property (nonatomic, copy) NSString *exchangeFeeRate;

@end

NS_ASSUME_NONNULL_END
