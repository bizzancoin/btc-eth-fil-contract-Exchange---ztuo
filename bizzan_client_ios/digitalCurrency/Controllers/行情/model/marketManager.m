//
//  marketManager.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/24.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "marketManager.h"

@implementation marketManager

+ (marketManager *)shareInstance{
    static marketManager * instance_singleton = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance_singleton == nil) {
            instance_singleton.AllCoinArray=[NSMutableArray array];
            instance_singleton = [[marketManager alloc] init];
            instance_singleton.USDTArray=[NSMutableArray array];
            instance_singleton.BTCArray=[NSMutableArray array];
            instance_singleton.ETHArray=[NSMutableArray array];
            instance_singleton.CollectionArray=[NSMutableArray array];
        }
    });
    return (marketManager *)instance_singleton;
}
@end
