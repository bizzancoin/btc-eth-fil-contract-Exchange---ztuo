//
//  EasyShowUtils.m
//  EasyShowViewDemo
//
//  Created by nf on 2017/11/24.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyShowUtils.h"

@implementation EasyShowUtils

+ (CGSize)textWidthWithStirng:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, SCREEN_HEIGHT_S)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil].size;
    
    if (size.width < 60) {
        size.width = 60 ;
    }
    return size ;
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
//+ (UIImageView *)imageViewSetCorner:(UIImageView *)imgView radius:(CGFloat)radius sizetoFit:(CGSize)sizetoFit
//{
//    CGRect rect = CGRectMake(0, 0, sizetoFit.width, sizetoFit.height) ;
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale) ;
//    CGContextAddPath(UIGraphicsGetCurrentContext(),
//                     UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
//                                  cornerRadii: CGSize(width: radius, height: radius)).CGPath)
//    CGContextClip(UIGraphicsGetCurrentContext())
//    
//    imgView.drawInRect(rect) ;
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
//    let output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}
//func kt_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
//    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
//    CGContextAddPath(UIGraphicsGetCurrentContext(),
//                     UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
//                                  cornerRadii: CGSize(width: radius, height: radius)).CGPath)
//    CGContextClip(UIGraphicsGetCurrentContext())
//    
//    self.drawInRect(rect)
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
//    let output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return output
//}

@end
