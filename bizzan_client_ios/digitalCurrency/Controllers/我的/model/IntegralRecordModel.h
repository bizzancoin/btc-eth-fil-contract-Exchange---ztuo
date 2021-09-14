//
//  IntegralRecordModel.h
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegralRecordModel : NSObject
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
