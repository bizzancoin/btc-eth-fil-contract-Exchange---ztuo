//
//  countryModel.h
//  digitalCurrency
//
//  Created by sunliang on 2018/2/23.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseModel.h"

@interface countryModel : BaseModel
@property(nonatomic,strong)NSString *zhName;
@property(nonatomic,strong)NSString *enName;
@property(nonatomic,strong)NSString *areaCode;
@property(nonatomic,strong)NSString *language;
@property(nonatomic,strong)NSString *sort;
@property(nonatomic,strong)NSString *localCurrency;

@end
