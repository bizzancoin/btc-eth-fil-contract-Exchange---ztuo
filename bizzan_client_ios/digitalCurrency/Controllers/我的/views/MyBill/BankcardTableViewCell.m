//
//  BankcardTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/23.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BankcardTableViewCell.h"

@implementation BankcardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showmorecontent:(id)sender {
   
    self.showbut.selected = !self.showbut.selected;
    self.showBankBlock(self.showbut.selected);
    

}

@end
