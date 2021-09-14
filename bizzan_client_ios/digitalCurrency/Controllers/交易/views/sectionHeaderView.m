//
//  sectionHeaderView.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/6.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "sectionHeaderView.h"

@implementation sectionHeaderView
+(sectionHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"sectionHeaderView" owner:nil options:nil];
    
    sectionHeaderView*headerView=[nibView objectAtIndex:0];
    headerView.titleLabel.text=LocalizationKey(@"Current");
    headerView.frame=Rect;
    return headerView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
