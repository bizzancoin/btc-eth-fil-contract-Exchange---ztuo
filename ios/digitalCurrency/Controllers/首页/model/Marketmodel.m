//
//  Marketmodel.m
//  digitalCurrency
//
//  Created by startlink on 2019/7/4.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import "Marketmodel.h"

@implementation Marketmodel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"currentBonusETHBnous"]) {
        if ([value isKindOfClass:[NSString class]]) {

            NSString *balance = (NSString *)value;
            NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:balance];

            self.currentBonusETHBnous = [number stringValue];
        }
    }
}

@end
