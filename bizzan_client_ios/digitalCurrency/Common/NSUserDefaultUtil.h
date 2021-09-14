//
//  NSUserDefaultUtil.h
//  siLuBi
//
//  Created by sunliang on 2018/1/15.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultUtil : NSObject
+(void)PutBoolDefaults:(NSString *)key Value:(BOOL)value;
+(void)PutDefaults:(NSString *)key Value:(id)value;
+(id)GetDefaults:(NSString *)key;
@end
