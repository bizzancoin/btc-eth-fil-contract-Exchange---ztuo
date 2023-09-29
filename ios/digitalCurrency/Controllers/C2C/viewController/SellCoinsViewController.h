//
//  SellCoinsViewController.h
//  digitalCurrency
//
//  Created by iDog on 2019/1/30.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCoinTypeModel.h"

@interface SellCoinsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SelectCoinTypeModel *model;

@property (nonatomic, assign) BOOL vcCanScroll;

@end
