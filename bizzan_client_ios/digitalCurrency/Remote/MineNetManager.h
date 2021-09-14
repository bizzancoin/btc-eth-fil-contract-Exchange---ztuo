//
//  MineNetManager.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseNetManager.h"

@interface MineNetManager : BaseNetManager

+(void)saveInfosVideoUrl:(NSString *)videourl random:(NSString *)random CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//身份认证上传视频获取随机码
+(void)identityAuthenticationapprovevideorandomCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//身份认证
+(void)identityAuthenticationRealName:(NSString *)realName andIdCard:(NSString *)idCard andVideoUrl:(NSString *)videoUrl andRandom:(NSString *)random andCardDic:(NSMutableDictionary *)cardDic CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//设置交易密码
+(void)moneyPasswordForJyPassword:(NSString *)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取重置交易密码的验证码
+(void)resetMoneyPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//重置交易密码
+(void)resetMoneyPasswordForCode:(NSString *)code withNewPassword:(NSString *)newPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取修改交易密码的验证码
+(void)updateMoneyPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//修改交易密码
+(void)resetMoneyPasswordForOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword code:(NSString *)code googleCode:(NSString *)googleCode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取绑定邮箱的验证码
+(void)bindingEmailCodeForEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//绑定邮箱
+(void)bindingEmailForCode:(NSString *)code withPassword:(NSString *)password withEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//获取绑定手机的验证码
+(void)bindingPhoneCodeForPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//绑定手机
+(void)bindingPhoneForCode:(NSString *)code withPassword:(NSString *)password withPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取重置登录密码的验证码
+(void)resetLoginPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//重置登录密码
+(void)resetLoginPasswordForCode:(NSString *)code withOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword googleCode:(NSString *)googleCode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//我的订单
+(void)myBillInfoForStatus:(NSString *)status withPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//账号设置的状态信息获取
+(void)accountSettingInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取我的钱包所有信息
+(void)getMyWalletInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取我的广告
+(void)getMyAdvertisingForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上架我的广告
+(void)upMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//下架我的广告
+(void)downMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取广告的详细信息
+(void)getMyAdvertisingDetailInfoForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//明细  获取交易历史
+(void)getTradeHistoryForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上传图片
+(void)uploadImageForFile:(NSData *)file CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置头像
+(void)setHeadImageForUrl:(NSString *)urlString CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提币获取验证码
+(void)resetwithdrawCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提币申请
+(void)mentionCoinApplyForUnit:(NSString *)unit withAddress:(NSString*)address withAmount:(NSString *)amount withFee:(NSString *)fee withRemark:(NSString *)remark withJyPassword:(NSString *)jyPassword mobilecode:(NSString *)mobilecode googleCode:(NSString *)googleCode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//提币选择信息
+(void)mentionCoinInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//1付款 2取消
+(void)myBillDetailTipForUrlString:(NSString *)urlString withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
// 4放款
+(void)myBillDetailTipForOrderSn:(NSString *)orderSn withJyPassword:(NSString*)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//订单投诉
+(void)myBillDetailComplaintsForRemark:(NSString *)remark withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//平台消息
+(void)getPlatformMessageForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取更改绑定手机的验证码
+(void)changePhoneNumCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//更换手机号
+(void)changePhoneNumForPassword:(NSString *)password withPhone:(NSString*)phone withCode:(NSString *)code CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上传反馈意见
+(void)takeUpFeedBackForRemark:(NSString *)remark CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//关于我们
+(void)aboutUSInfo:(void(^)(id resPonseObj,int code))completeHandle;

//订单详情页
+(void)myBillDetailForId:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取历史聊天记录
+(void)chatRecordDetailForId:(NSString *)orderSn uidTo:(NSString *)uidTo uidFrom:(NSString *)uidFrom limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//查看历史委托
+(void)historyEntrustForPageNo:(NSString *)pageNo withPageSize:(NSString*)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查看委托详情
+(void)historyEntrustDetailForOrderId:(NSString *)orderId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//提交的身份认证信息获取
+(void)getIdentifyInfo:(void(^)(id resPonseObj,int code))completeHandle;

//获取交易对数据
+(void)getTradCoinForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取收款账户信息
+(void)getPayAccountInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置银行卡
+(void)setBankNumForUrlString:(NSString *)url withBank:(NSString *)bank withBranch:(NSString *)branch withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withCardNo:(NSString *)cardNo CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置支付宝账号
+(void)setAliPayForUrlString:(NSString *)url withAli:(NSString *)ali withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//设置微信账号
+(void)setWeChatForUrlString:(NSString *)url withWechat:(NSString *)wechat withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//推广好友记录
+(void)getPromoteFriendsPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//我的佣金记录
+(void)getMyCommissionPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//版本更新
+(void)versionUpdateForId:(NSString *)ID  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//删除我的广告
+(void)deleteAdvertiseForAdvertiseId:(NSString *)advertiseId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//持币分红
+(void)postBonusForAdvertiseId:(NSString *)advertiseId Param:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//交易挖矿记录
+(void)getmainminingAdvertiseId:(NSString *)advertiseId inviterState:(NSString *)inviterState withPageSize:(NSString*)pageSize startime:(NSString *)startime endtime:(NSString *)endtime CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//首页分配数据
+(void)Getindex_infoCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//账户状态(是否能发布广告)
+(void)userbusinessstatus:(void(^)(id resPonseObj,int code))completeHandle;

//币理财管理
+(void)financialorderlistParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//币理财项目
+(void)financialitemsCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//资产流水
+(void)assettransactionParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//提币记录
+(void)withdrawrecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//币理财
+(void)financialitemsBHBCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//申请成为商家
+(void)approvecertifiedbusinessParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//成为商家币种列表
+(void)approvebusinessauthdepositlist:(void(^)(id resPonseObj,int code))completeHandle;


//购买币理财
+(void)financialorderParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//用户协议
+(void)Userprotocol:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取提币地址
+(void)getassetwalletresetaddress:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//个人中心的竞猜类型条件接口
+(void)Getcoinguesstype:(void(^)(id resPonseObj,int code))completeHandle;

//个人中心投注记录
+(void)getcoinguessmemberId:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//中奖详情
+(void)getcoinguessdetail:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
@end
