//
//  tradeCell.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kindName;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backwidth;

@end
