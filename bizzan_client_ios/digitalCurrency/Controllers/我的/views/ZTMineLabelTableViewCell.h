//
//  ZTMineLabelTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/4/27.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SenderBlock)(NSInteger tag);

@interface ZTMineLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authenLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLevelLabel;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) SenderBlock senderBlock;

@end

NS_ASSUME_NONNULL_END
