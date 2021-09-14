//
//  MyEntrustInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailInfo;
@interface MyEntrustInfoModel : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *baseSymbol;
@property(nonatomic,copy)NSString *canceledTime;
@property(nonatomic,copy)NSString *coinSymbol;
@property(nonatomic,copy)NSString *completedTime;
@property(nonatomic,copy)NSString *direction;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *symbol;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *tradedAmount;
@property(nonatomic,copy)NSString *turnover;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSArray *detail;
@property(nonatomic,copy)NSString *triggerPrice;

@end
@interface DetailInfo : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *fee;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *time;
@end
