//
//  NoticeTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/7/31.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *transactionview;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *transactionlabel;
@property (weak, nonatomic) IBOutlet UILabel *safelabel;
@property (weak, nonatomic) IBOutlet UILabel *helplebel;
@property (weak, nonatomic) IBOutlet UILabel *problemlabel;

@property (weak, nonatomic) IBOutlet UIView *Noticeview;
@property (weak, nonatomic) IBOutlet UILabel *noticelabel;
@property (weak, nonatomic) IBOutlet UILabel *noticecontentlabel;
@property (nonatomic,copy)void (^CtoCBlock)(void);
@end
