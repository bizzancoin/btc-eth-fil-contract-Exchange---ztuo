//
//  IdentifyPersionInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/13.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifyPersionInfoModel : NSObject
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *identityCardImgFront;
@property(nonatomic,copy)NSString *identityCardImgInHand;
@property(nonatomic,copy)NSString *identityCardImgReverse;
@property(nonatomic,copy)NSString *realName;
@end
