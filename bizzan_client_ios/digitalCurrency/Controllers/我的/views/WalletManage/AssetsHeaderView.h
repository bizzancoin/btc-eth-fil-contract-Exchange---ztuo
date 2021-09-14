//
//  AssetsHeaderView.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^eyeClickBlock)(BOOL isHiden);

@interface AssetsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAssetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdtLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *idenLabel;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
-(AssetsHeaderView *)instancetableHeardViewWithFrame:(CGRect)Rect;
@property (nonatomic, copy) eyeClickBlock block;
@end

NS_ASSUME_NONNULL_END
