//
//  plateModel.h
//  digitalCurrency
//
//  Created by sunliang on 2018/2/11.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseModel.h"

@interface plateModel : BaseModel
@property(nonatomic,assign)double price;//价格
@property(nonatomic,assign)double amount;//交易量
@property(nonatomic,assign)double totalAmount;
@end
