//
//  commissionViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2019/1/30.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import "BaseViewController.h"

@interface commissionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *symbol;
@end
