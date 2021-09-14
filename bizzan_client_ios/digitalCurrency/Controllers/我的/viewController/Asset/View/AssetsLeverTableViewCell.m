//
//  AssetsLeverTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsLeverTableViewCell.h"

@implementation AssetsLeverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.coinType.text = LocalizationKey(@"currency");
    self.canUseLabel.text = LocalizationKey(@"usabel");
    self.borrowLabel.text = LocalizationKey(@"Borrowed");

}

- (void)setModel:(LeverAccountModel *)model{
    _model = model;
    self.symbolLabel.text = model.symbol;
    
    NSArray *list = model.leverWalletList;
    if (list.count == 2) {
        LeverWalletModel *coin = [list lastObject];
        LeverWalletModel *baseCoin = [list firstObject];
        self.coinSymbol.text = coin.coin.unit;
        self.coinSymbolUseLabel.text = model.isHidden?@"********":coin.balance;
        self.coinSymbolBorrowLabel.text = model.isHidden?@"********":model.coinLoanCount;
      
        self.baseSymbol.text = baseCoin.coin.unit;
        self.baseSymbolUseLabel.text = model.isHidden?@"********":baseCoin.balance;
        self.baseSymbolBorrowLabel.text = model.isHidden?@"********":model.baseLoanCount;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
