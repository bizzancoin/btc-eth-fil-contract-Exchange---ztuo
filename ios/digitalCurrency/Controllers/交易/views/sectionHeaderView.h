//
//  sectionHeaderView.h
//  digitalCurrency
//
//  Created by sunliang on 2019/2/6.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sectionHeaderView : UIView
+(sectionHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
