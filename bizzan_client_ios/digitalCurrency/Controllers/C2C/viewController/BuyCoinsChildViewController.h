//
//  BuyCoinsChildViewController.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/25.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCoinTypeModel.h"
#import "XLBasePageController.h"

@interface BuyCoinsChildViewController :XLBasePageController
@property(nonatomic,strong)NSMutableArray *coinTypeArr;
@end
