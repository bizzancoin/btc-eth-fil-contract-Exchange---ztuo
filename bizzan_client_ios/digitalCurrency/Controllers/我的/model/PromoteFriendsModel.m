//
//  PromoteFriendsModel.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "PromoteFriendsModel.h"

@implementation PromoteFriendsModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (!oldValue) {// 以字符串类型为例
        return  @"";
    }
    return oldValue;
}


- (id)valueForUndefinedKey:(NSString *)key
{
    return @"";
}
@end
