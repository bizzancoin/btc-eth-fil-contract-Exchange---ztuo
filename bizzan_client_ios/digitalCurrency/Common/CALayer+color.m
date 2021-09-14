//
//  CALayer+color.m
//  horizonLoan
//
//  Created by sunliang on 2017/9/27.
//  Copyright © 2017年 ztuo. All rights reserved.
//

#import "CALayer+color.h"
#import <UIKit/UIKit.h>
@implementation CALayer (color)
- (void)setBorderColorWithUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

@end
