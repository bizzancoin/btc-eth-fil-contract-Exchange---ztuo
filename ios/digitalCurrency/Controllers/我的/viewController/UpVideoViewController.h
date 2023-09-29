//
//  UpVideoViewController.h
//  digitalCurrency
//
//  Created by startlink on 2019/9/18.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpVideoViewController : UIViewController
@property (nonatomic,copy)void (^saveBlock)(NSString *videourl,NSString *randomnum);

@end
