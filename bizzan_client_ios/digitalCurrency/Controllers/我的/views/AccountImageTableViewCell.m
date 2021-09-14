//
//  AccountImageTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "AccountImageTableViewCell.h"

@implementation AccountImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];   
    self.headTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"HeadPortrait" value:nil table:@"English"];
    self.headTitle.font = [UIFont systemFontOfSize:15 * kWindowWHOne];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
