//
//  PromoteFriendsTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PromoteFriendsTableViewCell.h"

@implementation PromoteFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.registerTimeLabelWidth.constant = (kWindowW-100)/3*2;
    
    self.registerTimeLabel.text = LocalizationKey(@"registTime");
    self.userNameLabel.text = LocalizationKey(@"username");
    self.recommendedLevelLabel.text = LocalizationKey(@"referralLevel");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
