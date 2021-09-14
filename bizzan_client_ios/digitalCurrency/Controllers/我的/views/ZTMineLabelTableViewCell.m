//
//  ZTMineLabelTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/4/27.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ZTMineLabelTableViewCell.h"
#import "SettingCenterViewController.h"

@implementation ZTMineLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)accountAction:(UIButton *)sender {
    if (self.senderBlock) {
        self.senderBlock(sender.tag);
    }
}

- (IBAction)authenAction:(UIButton *)sender {
    if (self.senderBlock) {
        self.senderBlock(sender.tag);
    }
}

- (IBAction)noticeAction:(UIButton *)sender {
    if (self.senderBlock) {
        self.senderBlock(sender.tag);
    }
}
- (IBAction)feeAction:(UIButton *)sender {
    if (self.senderBlock) {
        self.senderBlock(sender.tag);
    }
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    if (titles.count == 4) {
        self.accountLabel.text = titles[0];
        self.authenLabel.text = titles[1];
        self.noticeLabel.text = titles[2];
        self.feeLevelLabel.text = titles[3];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
