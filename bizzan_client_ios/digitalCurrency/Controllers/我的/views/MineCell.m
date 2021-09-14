//
//  MineCell.m
//  digitalCurrency
//
//  Created by leex on 2019/5/13.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.text = LocalizationKey(@"Recommended friends");
    self.comeLab.text = LocalizationKey(@"Come to");
    self.nameLab.text = LocalizationKey(@"AppName");
    self.tradeLab.text = LocalizationKey(@"Registered transactions");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
