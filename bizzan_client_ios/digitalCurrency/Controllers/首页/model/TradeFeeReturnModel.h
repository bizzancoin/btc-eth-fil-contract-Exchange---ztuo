//
//  TradeFeeReturnModel.h
//  digitalCurrency
//
//  Created by chu on 2018/7/4.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseModel.h"

@interface TradeFeeReturnModel : BaseModel

@property (nonatomic, copy) NSString *feeReturnTime;
@property (nonatomic, copy) NSString *averagePrice;
@property (nonatomic, copy) NSString *totalFee;
@property (nonatomic, copy) NSString *feeReturn;
@property (nonatomic, copy) NSString *multiplerPlan;

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

@end
