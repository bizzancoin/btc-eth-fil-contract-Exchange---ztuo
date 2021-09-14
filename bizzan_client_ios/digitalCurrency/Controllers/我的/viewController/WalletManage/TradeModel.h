//
//  TradeModel.h
//  digitalCurrency
//
//  Created by chu on 2018/7/4.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseModel.h"

@interface TradeModel : BaseModel

@property (nonatomic, copy) NSString *tradeTime;
@property (nonatomic, copy) NSString *tradePair;
@property (nonatomic, copy) NSString *tradeDirection;
@property (nonatomic, copy) NSString *tradePrice;
@property (nonatomic, copy) NSString *tradeOrderVolume;
@property (nonatomic, copy) NSString *tradeDeal;
@property (nonatomic, copy) NSString *tradeServiceCharge;

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

@end
