//
//  VersionUpdateModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/5/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateModel : NSObject
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *platform;
@property(nonatomic,copy)NSString *publishTime;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *version;
@end
