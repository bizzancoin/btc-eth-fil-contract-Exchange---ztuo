//
//  BaseViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock;

-(void)addAlterViewWithTitle:(NSString *)title withMessage:(NSString *)message withCertainBtnTitle:(NSString *)certainBtnTilte withCancelBtnTitle:(NSString *)cancelBtnTitle withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock;

@property (nonatomic, assign) NSInteger page;
@end
