//
//  Swzzling.h
//  NSArrayTest
//
//  Created by 蓝布鲁 on 2017/11/28.
//  Copyright © 2017年 蓝布鲁. All rights reserved.
//

#ifndef Swizzling_h
#define Swizzling_h

#include <objc/runtime.h>
static inline void swizzling_exchangeMethod(Class clazz, SEL originalSelector, SEL exchangeSelector) {
    // 获取原方法
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    
    // 获取需要交换的方法
    Method exchangeMethod = class_getInstanceMethod(clazz, exchangeSelector);
    
    if (class_addMethod(clazz, originalSelector, method_getImplementation(exchangeMethod), method_getTypeEncoding(exchangeMethod))) {
        class_replaceMethod(clazz, exchangeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, exchangeMethod);
    }
    
}

#endif /* Swizzling_h */
