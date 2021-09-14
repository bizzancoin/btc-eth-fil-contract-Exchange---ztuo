//
//  CustomSectionHeader.m
//  digitalCurrency
//
//  Created by sunliang on 2018/4/11.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "CustomSectionHeader.h"

@implementation CustomSectionHeader
+(CustomSectionHeader *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CustomSectionHeader" owner:nil options:nil];
    CustomSectionHeader*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}
- (IBAction)moreaction:(id)sender {
    self.moreBlock();
}

@end
