//
//  MyAdvertisingTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MyAdvertisingTableViewCell.h"

@implementation MyAdvertisingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

 
    self.headImage.layer.cornerRadius=35/2.0;
    self.headImage.clipsToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
