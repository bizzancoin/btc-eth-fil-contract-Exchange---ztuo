//
//  bannerModel.h
//  digitalCurrency
//
//  Created by sunliang on 2018/3/6.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseModel.h"

@interface bannerModel : BaseModel
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *serialNumber;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,assign)int status;
@property(nonatomic,assign)int sysAdvertiseLocation;
@property(nonatomic,copy)NSString *linkUrl;
@property(nonatomic,copy)NSString *url;
@end
