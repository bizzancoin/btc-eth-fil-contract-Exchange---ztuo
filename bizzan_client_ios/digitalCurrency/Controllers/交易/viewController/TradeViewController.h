//
//  TradeViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TradeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *asktableView;//卖出
@property (weak, nonatomic) IBOutlet UITableView *bidtableView;//买入
@property (weak, nonatomic) IBOutlet UITableView *entrusttableView;//委托
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
- (void)getPersonAllCollection;
@end
