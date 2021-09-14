//
//  ImageBtn.h
//  digitalCurrency
//
//  Created by sunliang on 2018/2/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBtn : UIButton
@property(nonatomic, strong)UIImageView *image;
@property(nonatomic, strong)UILabel *lb_title;

- (id)initWithFrame:(CGRect)frame :(NSString *)title :(UIImage *)Image;
-(void)resetFrame;
@end
