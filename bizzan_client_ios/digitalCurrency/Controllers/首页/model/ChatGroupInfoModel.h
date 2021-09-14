//
//  ChatGroupInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/16.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatGroupInfoModel : NSObject
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *messageType;
@property(nonatomic,copy)NSString *nameFrom;
@property(nonatomic,copy)NSString *nameTo;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *sendTime;
@property(nonatomic,copy)NSString *sendTimeStr;
@property(nonatomic,copy)NSString *uidTo;
@property(nonatomic,copy)NSString *uidFrom;
@property(nonatomic,copy)NSString *flagIndex;
@end
