//
//  UpVideoViewController.h
//  digitalCurrency
//
//  Created by startlink on 2018/9/18.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpVideoViewController : UIViewController

@property (nonatomic,copy)void (^saveBlock)(NSString *videourl,NSString *randomnum);
@property(nonatomic,copy)NSString *realNameRejectReason;//拒绝理由

@end
