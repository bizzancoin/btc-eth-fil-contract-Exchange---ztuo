//
//  SettingCenterTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2018/8/4.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@end
