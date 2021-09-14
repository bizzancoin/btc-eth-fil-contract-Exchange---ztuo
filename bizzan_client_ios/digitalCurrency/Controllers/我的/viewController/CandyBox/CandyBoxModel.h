//
//  CandyBoxModel.h
//  digitalCurrency
//
//  Created by chu on 2019/4/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CandyBoxModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, copy) NSString *giftCoin;
@property (nonatomic, copy) NSString *giftAmount;
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
