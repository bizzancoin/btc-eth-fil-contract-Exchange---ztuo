//
//  ChatGroupMessageTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/16.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "ChatGroupMessageTableViewCell.h"

@implementation ChatGroupMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
