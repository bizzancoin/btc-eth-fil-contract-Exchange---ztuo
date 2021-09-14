//
//  NSDictionary+Log.m
//  ReadingClub
//
//  Created by qtkj on 16/9/1.
//  Copyright © 2016年 qtkj. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}


//#ifdef DEBUG
//用po打印调试信息时会调用该方法
//- (NSString *)debugDescription {
//    NSError *error = nil;
//    //字典转成json
//    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
//    //如果报错了就按原先的格式输出
//    if (error) {
//        return [super debugDescription];
//    }
//    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//    
//    return jsonString;
//}
//
////打印到控制台时会调用该方法
//- (NSString *)descriptionWithLocale:(id)locale {
//    return self.debugDescription;
//}
//
////有些时候不走上面的方法，而是走这个方法
//- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
//    return self.debugDescription;
//}
//

@end
