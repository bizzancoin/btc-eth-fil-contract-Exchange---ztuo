//
//  AssetsHeaderView.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsHeaderView.h"

@implementation AssetsHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.idenLabel.layer.cornerRadius = self.idenLabel.frame.size.height / 2;
    self.idenLabel.layer.borderWidth = 1;
    self.idenLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.idenLabel.layer.masksToBounds = YES;
    
}

-(AssetsHeaderView *)instancetableHeardViewWithFrame:(CGRect)Rect
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AssetsHeaderView" owner:nil options:nil];
    AssetsHeaderView *tableView=[nibView objectAtIndex:0];
    tableView.frame=Rect;
    return tableView;
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.block) {
        self.block(sender.selected);
    }
}

@end
