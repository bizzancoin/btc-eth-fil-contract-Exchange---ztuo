//
//  ReturnHistoryTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ReturnHistoryTableViewCell.h"

@implementation ReturnHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.statusBtn setTitle:LocalizationKey(@"Returned") forState:UIControlStateNormal];
    self.amountLabel.text = LocalizationKey(@"amount");
    self.timeLabel.text = LocalizationKey(@"time");
    self.rateLabel.text = LocalizationKey(@"Interest");
}

- (void)setModel:(LeverWalletModel *)model{
    _model = model;
    self.coinLabel.text = model.LeverCoin.symbol;
    self.amountValueLabel.text = model.amount;
    self.timeValueLabel.text = model.createTime;
    self.rateValueLabel.text = model.interest;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
