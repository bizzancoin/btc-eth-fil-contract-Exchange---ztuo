//
//  FeeLevelChildViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"
#import "FeeLevelModel.h"
#import "ZJScrollPageViewDelegate.h"
#import "UIViewController+ZJScrollPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeeLevelChildViewController : BaseViewController<ZJScrollPageViewChildVcDelegate>

- (instancetype)initWithModel:(FeeLevelModel *)model;

@end

NS_ASSUME_NONNULL_END
