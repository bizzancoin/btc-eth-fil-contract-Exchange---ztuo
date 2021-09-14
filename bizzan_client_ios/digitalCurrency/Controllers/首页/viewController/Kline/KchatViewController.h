//
//  KchatViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/5/18.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KchatViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString*symbol;//交易对
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *collectIamgeV;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;

@end
