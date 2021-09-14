//
//  ZTMineLabelTableViewCell1.h
//  digitalCurrency
//
//  Created by chu on 2019/4/27.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BuninessBlock)(void);
typedef void(^CandyBlock)(void);
@interface ZTMineLabelTableViewCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buniessLabel;
@property (weak, nonatomic) IBOutlet UILabel *candyLabel;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) BuninessBlock buninessBlock;
@property (nonatomic, copy) CandyBlock candyBlock;

@end

NS_ASSUME_NONNULL_END
