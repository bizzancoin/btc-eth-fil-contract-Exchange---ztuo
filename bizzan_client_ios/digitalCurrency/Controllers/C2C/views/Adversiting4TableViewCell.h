//
//  Adversiting4TableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/3/5.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Adversiting4TableViewCell;
@protocol Adversiting4TableViewCellDelegate <NSObject>
- (void)tableViewIndex:(NSIndexPath *)index buttonTag: (NSInteger)buttonTag;
@end
@interface Adversiting4TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,weak) id<Adversiting4TableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelwidth;
@property(nonatomic,strong)NSIndexPath *index;
@end
