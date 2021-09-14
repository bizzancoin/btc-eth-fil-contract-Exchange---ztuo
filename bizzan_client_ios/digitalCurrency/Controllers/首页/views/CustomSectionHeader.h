//
//  CustomSectionHeader.h
//  digitalCurrency
//
//  Created by sunliang on 2018/4/11.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSectionHeader : UIView
+(CustomSectionHeader *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
@property (weak, nonatomic) IBOutlet UIButton *morebut;

@property (nonatomic,copy)void (^moreBlock)(void);
@end
