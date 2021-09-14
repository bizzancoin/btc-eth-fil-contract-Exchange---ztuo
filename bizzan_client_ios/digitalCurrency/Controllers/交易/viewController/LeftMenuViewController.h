//
//  LeftMenuViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^selSymbolBlock)(NSString *baseSymbol, NSString *changeSymbol);

@interface LeftMenuViewController : BaseViewController
typedef enum : NSUInteger {
    ChildViewType_USDT=0,
    ChildViewType_BTC,
    ChildViewType_ETH,
    ChildViewType_Collection
} ChildViewType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(assign,nonatomic)ChildViewType viewType;
- (void)showFromLeft;
@property (nonatomic, copy) selSymbolBlock block;
@end
