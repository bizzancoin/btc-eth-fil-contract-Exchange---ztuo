//
//  HelpCenterModel.m
//  digitalCurrency
//
//  Created by chu on 2018/8/8.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "HelpCenterModel.h"

@implementation HelpCenterModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *content = muDic[@"content"];
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *contentdic in content) {
        HelpCenterContentModel *model = [HelpCenterContentModel modelWithDictionary:contentdic];
        [muArr addObject:model];
    }
    [muDic setObject:muArr forKey:@"content"];
    return [[self alloc] initWithDictionary:muDic];
}


@end

@implementation HelpCenterContentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithDictionary:dic];
}

@end
