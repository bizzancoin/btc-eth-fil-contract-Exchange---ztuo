//
//  LeverAccountModel.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "LeverAccountModel.h"

@implementation LeverAccountModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"leverWalletList" : @"LeverWalletModel"
             };
}
@end

@implementation LeverWalletModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id", @"LeverCoin":@"leverCoin"};
}
@end

@implementation LeverCoinModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

@implementation CoinModel

@end
