//
//  ChatGroupInfoModel.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/16.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "ChatGroupInfoModel.h"

@implementation ChatGroupInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"avatar":@"fromAvatar"};
}
@end
