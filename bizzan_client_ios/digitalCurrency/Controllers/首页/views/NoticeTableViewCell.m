//
//  NoticeTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/7/31.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.transactionlabel.font = self.helplebel.font  = self.noticelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16 * kWindowWHOne];
     self.safelabel.font = self.problemlabel.font  = self.noticecontentlabel.font = [UIFont systemFontOfSize:12 * kWindowWHOne];
  
    
    self.transactionview.userInteractionEnabled = YES;
    self.helpView.userInteractionEnabled = YES;
    self.Noticeview.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transactionaction)];
    [self.transactionview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpaction)];
    [self.helpView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeaction)];
    [self.Noticeview addGestureRecognizer:tap5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//法币交易
-(void)transactionaction{
    self.CtoCBlock();
}

//帮助中心
-(void)helpaction{
    HelpeCenterViewController *help = [[HelpeCenterViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

//公告中心
-(void)noticeaction{
    NoticeCenterViewController *NoticeVC = [NoticeCenterViewController new];
    [[AppDelegate sharedAppDelegate] pushViewController:NoticeVC];
}

@end
