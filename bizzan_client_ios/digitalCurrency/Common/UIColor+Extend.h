//
//  UIColor+Extend.h
//  EBOexchange
//
//  Created by WWJ on 2017/12/29.
//  Copyright © 2017年 ebo. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  十六进制颜色
 */

@interface UIColor (Extend)
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;

@end
