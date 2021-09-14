//
//  ServiceChargeLevelView.m
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ServiceChargeLevelView.h"

@implementation ServiceChargeLevelView

- (void)awakeFromNib{
    [super awakeFromNib];

    self.currentLevelLabel.text = LocalizationKey(@"Currentlevel");
    self.coinFeeNameLabel.text = LocalizationKey(@"CoinFee");
    self.legalNameLabel.text = LocalizationKey(@"Legalcurrency");
    self.cashNameLabel.text = LocalizationKey(@"Dailywithdrawalquota");
    self.pensNameLabel.text = LocalizationKey(@"Numberofpenswithdrawnperday");

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
