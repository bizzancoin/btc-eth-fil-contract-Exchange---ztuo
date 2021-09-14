//
//  NSArray+Safe.m
//  NSArrayTest
//
//  Created by 蓝布鲁 on 2017/11/28.
//  Copyright © 2017年 蓝布鲁. All rights reserved.
//

#import "NSArray+Safe.h"
#import "Swzzling.h"

@implementation NSArray (Safe)

//#ifdef DEBUG
//
//#else   // release模式下不会发生崩溃

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:), @selector(emptyArray_objectAtIndex:));
        swizzling_exchangeMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:), @selector(arrayI_objectAtIndex:));
        swizzling_exchangeMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:), @selector(arrayM_objectAtIndex:));
        swizzling_exchangeMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:), @selector(singleObjectArrayI_objectAtIndex:));
        
        swizzling_exchangeMethod(objc_getClass("__NSArray0"), @selector(objectAtIndexedSubscript:), @selector(emptyArray_objectAtIndexedSubscript:));
        swizzling_exchangeMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(arrayI_objectAtIndexedSubscript:));
        swizzling_exchangeMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(arrayM_objectAtIndexedSubscript:));
        swizzling_exchangeMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:), @selector(singleObjectArrayI_objectAtIndexedSubscript:));
      
        
    });
    
    
}
//
//#endif
//

#pragma MARK -  - (id)objectAtIndex:
- (id)emptyArray_objectAtIndex:(NSUInteger)index{
    return nil;
}

- (id)arrayI_objectAtIndex:(NSUInteger)index{
    if(index < self.count){
        return [self arrayI_objectAtIndex:index];
    }
    return nil;
}

- (id)arrayM_objectAtIndex:(NSUInteger)index{
    if(index < self.count){
        return [self arrayM_objectAtIndex:index];
    }
    return nil;
}

- (id)singleObjectArrayI_objectAtIndex:(NSUInteger)index{
    if(index < self.count){
        return [self singleObjectArrayI_objectAtIndex:index];
    }
    return nil;
}

#pragma MARK -  - (id)objectAtIndexedSubscript:
- (id)emptyArray_objectAtIndexedSubscript:(NSUInteger)index{
    return nil;
}

- (id)arrayI_objectAtIndexedSubscript:(NSUInteger)index{
    if(index < self.count){
        return [self arrayI_objectAtIndex:index];
    }
    return nil;
}

- (id)arrayM_objectAtIndexedSubscript:(NSUInteger)index{
    if(index < self.count){
        return [self arrayM_objectAtIndex:index];
    }
    return nil;
}

- (id)singleObjectArrayI_objectAtIndexedSubscript:(NSUInteger)index{
    if(index < self.count){
        return [self singleObjectArrayI_objectAtIndexedSubscript:index];
    }
    return nil;
}

@end
