//
//  TurnOutViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, AccountType) {
    AccountType_Coin,
    AccountType_Curreny
};

NS_ASSUME_NONNULL_BEGIN

@interface TurnOutViewController : BaseViewController

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) AccountType from;
@property (nonatomic, assign) AccountType to;

@end

NS_ASSUME_NONNULL_END
