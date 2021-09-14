//
//  PlatformMessageModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/3/1.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformMessageModel : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *isShow;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *isTop;

@end
