//
//  AccountSettingTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "AccountSettingTableViewCell.h"

@implementation AccountSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
    self.rightLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
