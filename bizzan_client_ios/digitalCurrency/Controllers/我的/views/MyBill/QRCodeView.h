//
//  QRCodeView.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/11.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
