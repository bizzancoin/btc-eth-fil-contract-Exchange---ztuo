//
//  countryModel.h
//  digitalCurrency
//
//  Created by sunliang on 2019/2/23.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import "BaseModel.h"

@interface countryModel : BaseModel
@property(nonatomic,strong)NSString *zhName;
@property(nonatomic,strong)NSString *enName;
@property(nonatomic,strong)NSString *areaCode;
@property(nonatomic,strong)NSString *language;
@property(nonatomic,strong)NSString *sort;
@property(nonatomic,strong)NSString *localCurrency;
@property(nonatomic,strong)NSString *translation;

@end
