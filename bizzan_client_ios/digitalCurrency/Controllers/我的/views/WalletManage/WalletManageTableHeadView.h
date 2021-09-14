//
//  WalletManageTableHeadView.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/12.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletManageTableHeadView : UIView
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *selectBtnLabel;
-(WalletManageTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect;

@end
