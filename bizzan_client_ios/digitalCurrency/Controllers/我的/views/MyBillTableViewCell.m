//
//  MyBillTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MyBillTableViewCell.h"

@implementation MyBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.billStatus.clipsToBounds = YES;
    self.billStatus.layer.cornerRadius = 4;
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
