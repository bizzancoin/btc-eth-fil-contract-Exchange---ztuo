//
//  TradeNumCell.h
//  digitalCurrency
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Y_StockChart.h"
#import "TradeNumModel.h"
@interface TradeNumCell : UITableViewCell
-(void)configmodel:(TradeNumModel*)model widthcoinScale:(int)coinScale baseCoinScale:(int)baseCoinScale;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyType;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@end
