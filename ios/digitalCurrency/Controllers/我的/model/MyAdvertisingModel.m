//
//  MyAdvertisingModel.m
//  digitalCurrency
//
//  Created by iDog on 2019/3/5.
//  Copyright © 2019年 GIBX. All rights reserved.
//
#import "MyAdvertisingModel.h"
@implementation MyAdvertisingModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

@implementation CoinInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
