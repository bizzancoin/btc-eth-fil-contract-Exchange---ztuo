//
//  BorrowMoneyRecordTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeverAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BorrowMoneyRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *returBtn;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *noreturnLabel;
@property (weak, nonatomic) IBOutlet UILabel *noreturnValueLabel;
@property (nonatomic, strong) LeverWalletModel *model;
@end

NS_ASSUME_NONNULL_END
