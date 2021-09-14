//
//  AssetsLeverTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeverAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsLeverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinType;
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinSymbol;
@property (weak, nonatomic) IBOutlet UILabel *coinSymbolUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinSymbolBorrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseSymbol;
@property (weak, nonatomic) IBOutlet UILabel *baseSymbolUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseSymbolBorrowLabel;
@property (nonatomic, strong) LeverAccountModel *model;
@end

NS_ASSUME_NONNULL_END
