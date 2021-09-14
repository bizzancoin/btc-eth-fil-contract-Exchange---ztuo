//
//  symbolModel.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "symbolModel.h"

@implementation symbolModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];

    
    if ([key isEqualToString:@"close"]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            
            NSString *balance = [NSString stringWithFormat:@"%@",value];
            //            NSString *balance = (NSString *)value;
            NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:balance];
            
            self.close = number;
        }
    }
    
}

@end
