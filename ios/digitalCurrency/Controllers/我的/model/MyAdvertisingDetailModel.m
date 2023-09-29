//
//  MyAdvertisingDetailModel.m
//  digitalCurrency
//
//  Created by iDog on 2019/3/5.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import "MyAdvertisingDetailModel.h"

@implementation MyAdvertisingDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",@"isAuto":@"auto"};
}
@end

