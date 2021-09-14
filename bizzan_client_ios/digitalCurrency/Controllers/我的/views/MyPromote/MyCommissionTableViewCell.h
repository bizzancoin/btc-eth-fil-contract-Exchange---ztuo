//
//  MyCommissionTableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommissionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *issueTime;//发放时间
@property (weak, nonatomic) IBOutlet UILabel *coinType;
@property (weak, nonatomic) IBOutlet UILabel *cash;
@property (weak, nonatomic) IBOutlet UILabel *remark;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *issueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end
