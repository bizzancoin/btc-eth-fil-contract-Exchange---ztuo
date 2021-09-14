//
//  CoinUserInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/24.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinUserInfoModel : NSObject

@property(nonatomic,copy)NSString *advertiseId;
@property(nonatomic,copy)NSString *advertiseType;
@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,copy)NSString *coinName;
@property(nonatomic,copy)NSString *coinNameCn;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *maxLimit;
@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *minLimit;
@property(nonatomic,copy)NSString *payMode;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *remainAmount;
@property(nonatomic,copy)NSString *transactions;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *avatar;

@end
