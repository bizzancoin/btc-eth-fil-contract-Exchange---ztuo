//
//  PromoteFriendsTableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoteFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *registerTime;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *recommendedLevel;//推荐级别
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerTimeLabelWidth;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendedLevelLabel;


@end
