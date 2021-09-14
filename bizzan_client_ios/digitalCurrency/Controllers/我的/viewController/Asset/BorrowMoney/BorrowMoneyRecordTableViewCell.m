//
//  BorrowMoneyRecordTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BorrowMoneyRecordTableViewCell.h"
#import "MoneyReturnViewController.h"

@implementation BorrowMoneyRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.returBtn setTitle:LocalizationKey(@"return") forState:UIControlStateNormal];
    self.coinLabel.text = LocalizationKey(@"Currency");
    self.amountLabel.text = LocalizationKey(@"amount");
    self.timeLabel.text = LocalizationKey(@"ApplyTime");
    self.rateLabel.text = LocalizationKey(@"moneyRate");
    self.interestLabel.text = LocalizationKey(@"Unpaidinterest");
    self.noreturnLabel.text = LocalizationKey(@"UnreturnedQuantity");
}

- (void)setModel:(LeverWalletModel *)model{
    _model = model;
    self.symbolLabel.text = model.LeverCoin.symbol;
    self.accountTypeLabel.text = [NSString stringWithFormat:@"(%@)",LocalizationKey(@"AccountLever")];
    self.coinValueLabel.text = model.coin.unit;
    self.amountValueLabel.text = model.loanBalance;
    self.timeValueLabel.text = model.createTime;
    self.rateValueLabel.text = [NSString stringWithFormat:@"%@%%",model.interestRate];
    self.interestValueLabel.text = model.accumulative;
    self.noreturnValueLabel.text = model.amount;
    //0未归还 1已归还
    if ([model.repayment isEqualToString:@"0"]) {
        [self.returBtn setTitle:LocalizationKey(@"return") forState:UIControlStateNormal];
    }else{
        [self.returBtn setTitle:LocalizationKey(@"Returned") forState:UIControlStateNormal];
    }
}

- (IBAction)returAction:(UIButton *)sender {
    if ([self.model.repayment isEqualToString:@"0"]) {
        MoneyReturnViewController *retu = [[MoneyReturnViewController alloc] init];
        retu.model = self.model;
        [[AppDelegate sharedAppDelegate] pushViewController:retu];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
