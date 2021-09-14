//
//  commissionModel.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/25.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "commissionModel.h"

@implementation commissionModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"amount"]) {
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *balance = (NSString *)value;
            NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:balance];
            
            self.amount = [number stringValue];
        }
    }
    
    if ([key isEqualToString:@"price"]) {
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *balance = (NSString *)value;
            NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:balance];
            
            self.price = [number stringValue];
        }
    }
}

@end
