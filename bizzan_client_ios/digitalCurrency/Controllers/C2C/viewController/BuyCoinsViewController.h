//
//  BuyCoinsViewController.h
//  digitalCurrency
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCoinTypeModel.h"

@interface BuyCoinsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SelectCoinTypeModel *model;

@end
