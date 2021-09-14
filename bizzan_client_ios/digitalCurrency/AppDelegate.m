//
//  AppDelegate.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "YLNavigationController.h"
#import "HomeViewController.h"
#import "YLTabBarController.h"
#import "KSGuaidViewManager.h"
#import "ZLGestureLockViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MyBillChatViewController.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "UIImage+GIF.h"
#import "BaiduMobStat.h"//百度统计
#import "UMMobClick/MobClick.h"//友盟统计
#import <UserNotifications/UserNotifications.h>
#import <CoreTelephony/CTCellularData.h>
#import <WebKit/WebKit.h>
#import <Bugly/Bugly.h>
#define BUGLYAPPID @"38d57617bb"
#define BUGLYAPPKEY @"e72f58ba-cab7-4b17-bbaa-57f21f80f6e8"

@interface AppDelegate ()<chatSocketDelegate,UNUserNotificationCenterDelegate>
{
    NSString*_deviceToken;
}
@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 1秒
//    [NSThread sleepForTimeInterval:1];
    //引导页
    //    KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
    //                              [UIImage imageNamed:@"guid02"],
    //                              [UIImage imageNamed:@"guid03"]];
    //    KSGuaidManager.shouldDismissWhenDragging = YES;
    //    KSGuaidManager.pageIndicatorTintColor=[UIColor whiteColor];
    //    KSGuaidManager.currentPageIndicatorTintColor=baseColor;
    //    [KSGuaidManager begin];
    [self config];
    [self registNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
    self.window.rootViewController = SectionTabbar;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self PresentGestureLockViewController];
    });
    [self.window makeKeyAndVisible];
    
//    if ([self isFirstLauch]) {
//
//    }else{
//        //启动动画
////        [self customLaunchImageView];
//    }
    return YES;
}

#pragma mark 配置工具key
- (void)config
{
    self.CNYRate = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    [ChangeLanguage initUserLanguage];//初始化应用语言
    [self initKeyboardManager];//初始化键盘工具
    [Bugly startWithAppId:BUGLYAPPID];//bug日志
    [CSToastManager setQueueEnabled:NO];//toast
    [EasyShowOptions sharedEasyShowOptions].lodingShowType = LodingShowTypeTurnAroundLeft;//loading
    [[SocketManager share] connect];//连接行情socket
    [[ChatSocketManager share] connect];//连接聊天socket
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//状态栏字体颜色
}

#pragma mark 注册推送
- (void)registNotification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //    注册远程通知服务
    if (@available(iOS 10.0, *)) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];

        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            //            NSLog(@"========%@",settings);
        }];
    }else {
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication]registerForRemoteNotifications];
}

#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}




-(void)customLaunchImageView{
    
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    launchImageView.image = [self getLaunchImage];
    [self.window addSubview:launchImageView];
    [self.window bringSubviewToFront:launchImageView];

//    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWindowH == 812.0 ? 64 : 0, 288 * kWindowWHOne, kWindowH - (kWindowH == 812.0 ? 145 : 0 ))];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 144, 422)];
    gifImageView.center = self.window.center;
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"启动页.gif" ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    gifImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    [launchImageView addSubview:gifImageView];
  
    [UIView animateWithDuration:0.5f delay:5.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
          launchImageView.alpha = 0;

    } completion:^(BOOL finished) {
        //         设置启动页广告
        [launchImageView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageViewDismiss" object:nil];
    }];
}


- (UIImage *)getLaunchImage
{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    } else {
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}


#pragma mark-注册远程通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //获取deviceToken
//    _deviceToken= [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    _deviceToken= [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                    stringByReplacingOccurrencesOfString:@">" withString:@""];
    [self PresentGestureLockViewController];
     NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//    [ChatSocketManager share].delegate=self;//先取消订阅
//    NSLog(@"注册远程推送成功——————%@",_deviceToken);
}
#pragma mark-注册远程通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败--%@",[error description]);
}

#pragma mark-收到远程推送(点击通知栏进入App或者App在前台时触发)
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){//点击通知栏进来
        YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
//        NSLog(@"远程推送的信息是--%@",userInfo);
        ChatGroupInfoModel *model=[ChatGroupInfoModel mj_objectWithKeyValues:userInfo[@"addition"]];
        MyBillChatViewController *chatVC = [[MyBillChatViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.clickIndex = 1;
        chatVC.groupModel= model;
        [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
        [ChatGroupFMDBTool createTable:model withIndex:0];
    }
}

-(void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;// 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO;// 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark-home键或者锁屏进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate=nil;
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([YLUserInfo isLogIn]) {
         NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate=self;
    }
    [self PresentGestureLockViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark-检测到程序被杀死
- (void)applicationWillTerminate:(UIApplication *)application {
    
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//         [ChatSocketManager share].delegate=self;
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
       
        return UIInterfaceOrientationMaskLandscape;
        
    } else {
       
        return UIInterfaceOrientationMaskPortrait;
    }
}
#pragma mark-弹出手势密码解锁
-(void)PresentGestureLockViewController{
    if([YLUserInfo isLogIn]&&[ZLGestureLockViewController gesturesPassword].length > 0){
        [EasyShowLodingView hidenLoding];
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeValidatePsw];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - SocketDelegate Delegate,点击icon进来会触发
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==SUBSCRIBE_APNS) {
//        NSLog(@"订阅APNS");
    }else if (cmd==UNSUBSCRIBE_APNS)
    {
//        NSLog(@"取消订阅APNS");
    }
    else{
       // NSLog(@"聊天消息-%@--%d",endStr,cmd);
    }
    NSLog(@"APNS消息-%@--%d",endStr,cmd);
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

- (UIViewController *)topViewController
{
    UINavigationController *nav = [self navigationViewController];
    return nav.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController animated:YES];
    }
}

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController withBackTitle:title animated:YES];
    }
}

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title backAction:(CommonVoidBlock)action
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController withBackTitle:title action:action animated:NO];
    }
}

- (UIViewController *)popViewController
{
    return [[self navigationViewController] popViewControllerAnimated:YES];
}
- (NSArray *)popToRootViewController
{
    return [[self navigationViewController] popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
{
    return [[self navigationViewController] popToViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *top = [self topViewController];
    
    if (vc.navigationController == nil)
    {
        if ([vc isKindOfClass:NSClassFromString(@"PGDatePickManager")] || [vc isKindOfClass:NSClassFromString(@"ZLGestureLockViewController")]) {
            [top presentViewController:vc animated:animated completion:completion];
        }else{
            YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:vc];
            [top presentViewController:nav animated:animated completion:completion];
        }
    }
    else
    {
        [top presentViewController:vc animated:animated completion:completion];
    }
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (vc.navigationController != [AppDelegate sharedAppDelegate].navigationViewController)
    {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

@end
