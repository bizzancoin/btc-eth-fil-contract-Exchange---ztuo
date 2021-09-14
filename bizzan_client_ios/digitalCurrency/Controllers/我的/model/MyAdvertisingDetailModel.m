//
//  MyAdvertisingDetailModel.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/5.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MyAdvertisingDetailModel.h"

@implementation MyAdvertisingDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",@"isAuto":@"auto"};
}
@end

