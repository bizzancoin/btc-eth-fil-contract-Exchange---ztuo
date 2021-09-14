//
//  TradeNetManager.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "TradeNetManager.h"

@implementation TradeNetManager
//查询盘口信息
+(void)getexchangeplate:(NSString *)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/exchange-plate";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提交委托
+(void)SubmissionOfentrustmentWithsymbol:(NSString*)symbol withPrice:(NSString*)price withAmount:(NSString*)amount WithDirection:(NSString*)direction withType:(NSString*)type withTrigger:(NSString *)trigger CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/order/add";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"price"] = price;
    dic[@"amount"] = amount;
    dic[@"direction"] = direction;
    dic[@"type"] = type;
    if (![NSString stringIsNull:trigger]) {
        dic[@"triggerPrice"] = trigger;
    }

    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提交杠杆委托
+(void)levelOfentrustmentWithsymbol:(NSString*)symbol withPrice:(NSString*)price withAmount:(NSString*)amount WithDirection:(NSString*)direction withType:(NSString*)type withTrigger:(NSString *)trigger CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"margin-trade/order/add";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"price"] = price;
    dic[@"amount"] = amount;
    dic[@"direction"] = direction;
    dic[@"type"] = type;
    if (![NSString stringIsNull:trigger]) {
        dic[@"triggerPrice"] = trigger;
    }
    
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        NSLog(@"提交杠杆委托 -- %@",resultObject);
        completeHandle(resultObject,isSuccessed);
    }];
}

//查询币币当前委托BUY-SELL
+(void)Querythecurrentdelegatesymbol:(NSString*)symbol withpageNo:(int)pageNo withpageSize:(int)pageSize  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/order/personal/current";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"pageNo"] = [NSNumber numberWithInt:pageNo];
    dic[@"pageSize"] = [NSNumber numberWithInt:pageSize];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
+(void)QuerythecurrentdelegateParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"exchange/order/personal/current";
    [self ylNonTokenRequestWithGET:path parameters:param successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查询杠杆当前委托
+(void)levelCurrentdelegatesymbol:(NSString*)symbol withpageNo:(int)pageNo withpageSize:(int)pageSize  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"margin-trade/order/current";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    dic[@"pageNum"] = [NSNumber numberWithInt:pageNo];
    dic[@"pageSize"] = [NSNumber numberWithInt:pageSize];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

+(void)LevelCurrentdelegateParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"margin-trade/order/current";
    [self ylNonTokenRequestWithGET:path parameters:param successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取单个钱包
+(void)getwallettWithcoin:(NSString*)coin  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"uc/asset/wallet",coin];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//取消委托
+(void)cancelCommissionwithOrderID:(NSString*)orderId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"exchange/order/cancel",orderId];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
+(void)cancelLevelCommissionwithOrderID:(NSString*)orderId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"margin-trade/order/cancel",orderId];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取单个交易对的精确度
+(void)getSingleSymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/symbol-info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"symbol"] = symbol;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
+ (void)extracted:(void (^)(id, int))completeHandle param:(NSDictionary *)param path:(NSString *)path {
    [self ylNonTokenRequestWithGET:path parameters:param successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//查看历史委托
+(void)historyEntrustForParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle
{
    NSString *path = @"exchange/order/personal/history";
    [self extracted:completeHandle param:param path:path];
}
//查看杠杆历史委托
+(void)levelHistoryEntrustForParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"margin-trade/order/history";
    [self ylNonTokenRequestWithGET:path parameters:param successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

@end
