//
//  MyBillInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/3/5.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBillInfoModel : NSObject

@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *commission;
@property(nonatomic,copy)NSString *avatar;
@end
