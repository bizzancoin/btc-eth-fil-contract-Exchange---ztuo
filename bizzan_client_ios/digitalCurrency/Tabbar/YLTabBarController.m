//
//  YLTabBarController.m
//  BaseProject
//
//  Created by YLCai on 16/11/23.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import "YLTabBarController.h"
#import "YLNavigationController.h"
#import "HomeViewController.h"
#import "MarketViewController.h"
#import "TransactionViewController.h"
#import "AssetsViewController.h"
#import "MineViewController.h"
@interface YLTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation YLTabBarController

+(YLTabBarController *)defaultTabBarContrller{
    static YLTabBarController *tabBar = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[YLTabBarController alloc] init];
    });
    return tabBar;
}

+(void)initialize{
    if (self == [YLTabBarController class]) {
        UITabBar *tabBar = [UITabBar appearance];
        tabBar.barTintColor = [UIColor whiteColor];
        tabBar.translucent = NO;
        tabBar.barStyle = UIBarStyleBlack;
        UITabBarItem *barItem = [UITabBarItem appearance];
        //设置item中文字的普通样式
        NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
        normalAttributes[NSForegroundColorAttributeName] = RGBOF(0x999999);
        normalAttributes[NSFontAttributeName] = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        //设置item中文字被选中的样式
        NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
        selectedAttributes[NSForegroundColorAttributeName] =RGBOF(0x3399FF);//RGBOF(0xF0A70A);
        selectedAttributes[NSFontAttributeName] = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    [self dropShadowWithOffset:CGSizeMake(0, 0)
                        radius:5
                         color:[UIColor blackColor]
                       opacity:0.14];
    //添加子控制器
    [self initTabbar];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    self.tabBar.clipsToBounds = NO;
}

-(void)initTabbar{
    HomeViewController   *Section1VC = [[HomeViewController alloc] init];
    MarketViewController *Section2VC = [[MarketViewController alloc] init];
    TransactionViewController  *Section3VC = [[TransactionViewController alloc] init];
    AssetsViewController   *Section4VC = [[AssetsViewController alloc] init];
    MineViewController   *Section5VC = [[MineViewController alloc] init];
    Section1VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar1") image:[[UIImage imageNamed:@"shouye_un"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"shouye_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section2VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar2") image:[[UIImage imageNamed:@"hangqiang_un"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"hangqiang_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section3VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar3") image:[[UIImage imageNamed:@"bibi_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"bibi_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section4VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar4") image:[[UIImage imageNamed:@"fabi_un"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"fabi_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section5VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar5") image:[[UIImage imageNamed:@"wode_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"wode_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    YLNavigationController *Section1Navi = [[YLNavigationController alloc] initWithRootViewController:Section1VC];
    YLNavigationController *Section2Navi = [[YLNavigationController alloc] initWithRootViewController:Section2VC];
    YLNavigationController *Section3Navi = [[YLNavigationController alloc] initWithRootViewController:Section3VC];
    YLNavigationController *Section4Navi = [[YLNavigationController alloc] initWithRootViewController:Section4VC];
    YLNavigationController *Section5Navi = [[YLNavigationController alloc] initWithRootViewController:Section5VC];
    self.viewControllers = @[Section1Navi,Section2Navi,Section3Navi,Section4Navi,Section5Navi];
    
}


#pragma mark Tabbar的代理
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.viewControllers[3]) {
        if (![YLUserInfo isLogIn]) {//未登录
            [self showLoginViewController];
            return NO;
        }
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
        
}

-(void)showLoginViewController{
    LoginViewController*loginVC=[[LoginViewController alloc]init];
    YLNavigationController *nav = [[YLNavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}
//重置tabar标题
-(void)resettabarItemsTitle{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    item1.title=LocalizationKey(@"tabbar1");
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    item2.title=LocalizationKey(@"tabbar2");
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    item3.title=LocalizationKey(@"tabbar3");
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    item4.title=LocalizationKey(@"tabbar4");
    UITabBarItem *item5 = [tabBar.items objectAtIndex:4];
    item5.title=LocalizationKey(@"tabbar5");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
