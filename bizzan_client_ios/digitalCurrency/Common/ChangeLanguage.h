//
//  ChangeLanguage.h
//  siLuBi
//
//  Created by sunliang on 2018/1/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeLanguage : NSObject
+(NSBundle *)bundle;//获取当前资源文件
+(void)initUserLanguage;//初始化语言文件
+(NSString *)userLanguage;//获取应用当前语言
+(void)setUserlanguage:(NSString *)language;//设置当前语言
@end
