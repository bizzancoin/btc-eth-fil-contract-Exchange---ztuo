//
//  TradeFeeReturnModel.m
//  digitalCurrency
//
//  Created by chu on 2018/7/4.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "TradeFeeReturnModel.h"

@implementation TradeFeeReturnModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithDictionary:dic];
}

@end
