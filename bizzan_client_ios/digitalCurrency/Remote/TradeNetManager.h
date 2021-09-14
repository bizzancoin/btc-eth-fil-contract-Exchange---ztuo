//
//  TradeNetManager.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseNetManager.h"

@interface TradeNetManager : BaseNetManager
//查询盘口信息
+(void)getexchangeplate:(NSString *)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提交币币委托
+(void)SubmissionOfentrustmentWithsymbol:(NSString*)symbol withPrice:(NSString*)price withAmount:(NSString*)amount WithDirection:(NSString*)direction withType:(NSString*)type withTrigger:(NSString *)trigger CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提交杠杆委托
+(void)levelOfentrustmentWithsymbol:(NSString*)symbol withPrice:(NSString*)price withAmount:(NSString*)amount WithDirection:(NSString*)direction withType:(NSString*)type withTrigger:(NSString *)trigger CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询币币当前委托
+(void)Querythecurrentdelegatesymbol:(NSString*)symbol withpageNo:(int)pageNo withpageSize:(int)pageSize  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
+(void)QuerythecurrentdelegateParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询杠杆当前委托
+(void)levelCurrentdelegatesymbol:(NSString*)symbol withpageNo:(int)pageNo withpageSize:(int)pageSize  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
+(void)LevelCurrentdelegateParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//获取单个钱包
+(void)getwallettWithcoin:(NSString*)coin  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//取消币币委托
+(void)cancelCommissionwithOrderID:(NSString*)orderId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//取消杠杆委托
+(void)cancelLevelCommissionwithOrderID:(NSString*)orderId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//获取单个交易对的精确度
+(void)getSingleSymbol:(NSString*)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查看币币历史委托
+(void)historyEntrustForParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查看杠杆历史委托
+(void)levelHistoryEntrustForParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
@end
