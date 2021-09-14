//
//  AccountSettingInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/27.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSettingInfoModel : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *emailVerified;
@property(nonatomic,copy)NSString *fundsVerified;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *loginVerified;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *phoneVerified;
@property(nonatomic,copy)NSString *realAuditing;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *realVerified;//1审核成功
@property(nonatomic,copy)NSString *transactions;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *realNameRejectReason;

@property(nonatomic,copy)NSString *integration;//用户积分
//0-未实名、1-视频审核,2-实名审核失败、3-视频审核失败,4-实名成功,5-待实名审核 ,6-待视频审核
@property(nonatomic,copy)NSString *kycStatus;
@property(nonatomic,copy)NSString *memberGradeId;
@property(nonatomic,copy)NSString *googleState;
@property(nonatomic,copy)NSString *memberLevel;


@end
