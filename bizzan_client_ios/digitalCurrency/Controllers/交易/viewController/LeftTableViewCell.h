//
//  LeftTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/8/17.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"
@interface LeftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;

@property (weak, nonatomic) IBOutlet UILabel *changelabel;

-(void)configDataWithModel:(symbolModel*)model withtype:(int)type withIndex:(int)index;

@end
