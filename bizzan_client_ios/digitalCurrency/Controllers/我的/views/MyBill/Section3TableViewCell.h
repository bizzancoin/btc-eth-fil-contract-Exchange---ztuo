//
//  Section3TableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/4.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section3TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnLeftLength;

@end
