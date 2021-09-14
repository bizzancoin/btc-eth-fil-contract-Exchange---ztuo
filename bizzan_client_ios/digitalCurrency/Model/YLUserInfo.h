//
//  YLUserInfo.h
//  BaseProject
//
//  Created by YLCai on 16/11/30.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLUserInfo : NSObject<NSCoding>

@property(nonatomic,strong)NSDictionary *location;
@property(nonatomic,strong)NSDictionary *country;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *memberLevel;
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *avatar;//头像地址
@property(nonatomic,strong)NSString *promotionCode;
@property(nonatomic,strong)NSString *promotionPrefix;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,copy)NSString *mobile;
//用户当前积分
@property(nonatomic,strong)NSString *integration;
//0-未实名、1-视频审核,2-实名审核失败、3-视频审核失败,4-实名成功,5-待实名审核 ,6-待视频审核
@property(nonatomic,strong)NSString *kycStatus;//用户实名状态
@property(nonatomic,strong)NSString *memberGradeId;//用户等级ID(1-6对应等级主键)
@property(nonatomic,strong)NSString *googleState;//谷歌认证状态

/*  通过初始化userIfo并保存在本地(单利模式)   */
+(instancetype)getuserInfoWithDic:(NSDictionary *)dic;

/*  获取用户已登陆的信息 */
+(instancetype)shareUserInfo;

/*  判断用户时否登陆 */
+(BOOL)isLogIn;

/*  退出登陆 */
+(instancetype)logout;

/*  保存当前userInfo */
+(void)saveUser:(YLUserInfo *)userInfo;

@end
