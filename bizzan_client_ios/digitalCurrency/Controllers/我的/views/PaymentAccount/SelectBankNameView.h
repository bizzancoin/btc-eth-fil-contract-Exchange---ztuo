//
//  SelectBankNameView.h
//  digitalCurrency
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBankNameModel.h"

@class SelectBankNameView;
@protocol SelectBankNameViewDelegate <NSObject>
- (void)selectBankNameModel:(SelectBankNameModel *)model;
@end
@interface SelectBankNameView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray<SelectBankNameModel *> *modelArr;
@property (nonatomic,weak) id<SelectBankNameViewDelegate> delegate;
@end
