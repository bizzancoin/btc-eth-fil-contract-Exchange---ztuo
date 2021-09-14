//
//  Constant.h
//  BaseProject
//
//  Created by YLCai on 16/11/11.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#define USERINFO @"USERINFO"
#import "AppDelegate.h"
#import "ARCCompile.h"
#import "DebugMarco.h"
//自定义block
typedef void(^ResultBlock)(id resultObject,int isSuccessed);

#define   HOST     @"http://192.168.31.61/"//正拓测试

#define kUpdateAppStore 0 //是否上传到appStore 0企业分发 1appStore

#define kShowGesturePassword @"kShowGesturePassword"

#define MESSAGE @"message"

//国际化
#define LocalizationKey(key) [[ChangeLanguage bundle] localizedStringForKey:key value:nil table:@"English"]
//图片
#define UIIMAGE(name) [UIImage imageNamed:name]
//通过RGB设置颜色
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
/** 色值 RGB **/
#define HEXCOLOR(color)     [UIColor colorWithHexColorString:color]

#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)
#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
//主色调
#define MainBackColor [UIColor whiteColor]
#define BackColor  RGBOF(0xEEEEEE)
#define BlackTextColor  RGBOF(0x333333)
#define GrayTextColor  RGBOF(0x999999)
#define NavColor    RGBOF(0x3399FF)
#define AppTextColor_333333   RGBOF(0x333333)
//#define mainColor  RGBOF(0x3399FF)
#define mainColor  RGBOF(0x1F2833)
#define baseColor  NavColor
#define ViewBackgroundColor  kRGBColor(18,22,28)
#define AppTextColor  RGBOF(0xE6E6E6)
#define AppTextColor_999999  RGBOF(0x999999)
#define AppTextColor_666666  RGBOF(0x666666)
#define AppTextColor_E6E6E6  RGBOF(0xE6E6E6)

#define RedColor   RGBOF(0xF15057)   //红跌
#define GreenColor RGBOF(0x00B275)  //绿涨

#define APPCONFIG_UNIT_LINE_WIDTH                (1/[UIScreen mainScreen].scale)      //常用线宽
//设备唯一标识符
#define UUID            [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define UUIDKey         @"UUIDKey"
#define USENAMEPASSWORD         @"USENAMEPASSWORD"//用户名和密码
#define LocalizationKey(key) [[ChangeLanguage bundle] localizedStringForKey:key value:nil table:@"English"]
#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度
#define kWindowHOne    [UIScreen mainScreen].bounds.size.height / 667 //应用程序的屏幕单位高度
#define kWindowWHOne    [UIScreen mainScreen].bounds.size.width / 375 //应用程序的屏幕单位宽度

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define kAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate)

#define APPLICATION     [UIApplication sharedApplication].delegate

#define kStoryboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]
#define INT2STRING(intValue) [NSString stringWithFormat:@"%d", intValue]
//通过Storyboard ID 在对应Storyboard中获取场景对象
#define kVCFromSb(VCID, SbName)     [[UIStoryboard storyboardWithName:SbName bundle:nil] instantiateViewControllerWithIdentifier:VCID]

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\
// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
//新版导航栏高度
#define NEW_NavHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define IOS_VERSION_11_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))
//新版状态栏高度
#define NEW_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define SafeAreaTopHeight (kWindowH >= 812.0 ? 88 : 64)
#define SafeIS_IPHONE_X (kWindowH >= 812.0 ? 50 : 30)
//iPhoneX机型判断

//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)

//iPhoneX系列
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_NavBar ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
#define SafeAreaBottomHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34 : 0)
#define IS_IPHONE_X_All ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? YES : NO)

#define NavigationBarAdapterContentInsetTop (IS_IPHONE_X? 88.0f:64.0f) //顶部偏移
#define kTabbarHeight (IS_IPHONE_X ? 83.0f:49.0f)
//Docment文件夹目录
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define LocalLanguageKey         @"LocalLanguageKey" //选择语言
#define LanguageChange           @"LanguageChange" //切换语言
//日志输出
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* Constant_h */
