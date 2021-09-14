//
//  DepthmapCell.m
//  digitalCurrency
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "DepthmapCell.h"
#import "DepthCell.h"
#import "UIColor+Y_StockChart.h"
@implementation DepthmapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor backgroundColor];
   
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
       
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
