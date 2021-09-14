//
//  SelectCoinTypeModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/9.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCoinTypeModel : NSObject
@property(nonatomic,copy)NSString *buy_min_amount;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *marketPrice;
@property(nonatomic,copy)NSString *min_amount;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *nameCn;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *unit;
@end
