//
//  countryViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/2/23.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseViewController.h"
#import "countryModel.h"
typedef void (^ReturnValueBlock) (countryModel *model);
@interface countryViewController : BaseViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
