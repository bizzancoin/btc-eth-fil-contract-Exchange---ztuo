//
//  DepthCell.h
//  digitalCurrency
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plateModel.h"
@interface DepthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *BuyIndex;
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *BuyPrice;
@property (weak, nonatomic) IBOutlet UILabel *SellPrice;
@property (weak, nonatomic) IBOutlet UILabel *SellNum;
@property (weak, nonatomic) IBOutlet UILabel *SellIndex;
-(void)config:(plateModel*)buymodel withmodel:(plateModel*)Sellmodel widthcoinScale:(int)coinScale baseCoinScale:(int)baseCoinScale;
@property (weak, nonatomic) IBOutlet UIView *buyView;
@property (weak, nonatomic) IBOutlet UIView *SellView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellWidth;

@end
