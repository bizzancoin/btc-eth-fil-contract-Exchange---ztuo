//
//  ServiceChargeLevelView.h
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceChargeLevelView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinFeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinFeeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pensNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pensValueLabel;

@end

NS_ASSUME_NONNULL_END
