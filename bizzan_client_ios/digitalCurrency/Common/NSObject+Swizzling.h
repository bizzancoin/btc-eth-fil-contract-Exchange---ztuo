//
//  NSObject+Swizzling.h
//  PaopaoRunning
//
//  Created by zwj on 2018/4/2.
//  Copyright © 2018年 HealthPao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;
  
@end
