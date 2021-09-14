//
//  MyCommissionTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyCommissionTableViewCell.h"

@implementation MyCommissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.issueTimeLabel.text = LocalizationKey(@"releaseTime");
    self.coinTypeLabel.text = LocalizationKey(@"currency");
    self.amountLabel.text = LocalizationKey(@"amount");
    self.remarkLabel.text = LocalizationKey(@"remark");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
