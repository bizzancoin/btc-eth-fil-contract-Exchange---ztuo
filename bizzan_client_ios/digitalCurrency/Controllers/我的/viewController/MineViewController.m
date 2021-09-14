//
//  MineViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MineViewController.h"

#import "AccountSettingViewController.h"
#import "SettingCenterViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "WalletManageModel.h"
#import "NSUserDefaultUtil.h"
#import "VersionUpdateModel.h"
#import "MineTableHeadView.h"
#import "LoginNetManager.h"
#import "IdentityAuthenticationViewController.h"
#import "NoticeCenterViewController.h"
#import "FeeLevelViewController.h"
#import "CandyBoxViewController.h"
#import "UpVideoViewController.h"
#import "MyPromoteViewController.h"

//#import "MineTableViewCell.h"
#import "MineCell.h"
#import "MineTableViewCell.h"

//自定义cell
#import "ZTMineLabelTableViewCell.h"
#import "ZTMineLabelTableViewCell1.h"
//商家认证
#import "ApplyBusinessViewController.h"
#import "BeingauditedBusViewController.h"
#import "SuccessBusViewController.h"
#import "AccountSettingInfoModel.h"
#import "FailBusinessViewController.h"


@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,chatSocketDelegate>{
    BOOL updateFlag;
    UIView *_tableHeadView;
    BOOL _realVerified;
    BOOL _fundsVerified;
    RKNotificationHub *_updateHub;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) NSMutableArray *assetTotalArr;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;
@property(nonatomic,strong)VersionUpdateModel *versionModel;
@property(nonatomic,strong) MineTableHeadView *headerView;
@property (nonatomic,assign)NSInteger memberLevel;
@property (nonatomic,copy)NSString *reasonstr;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = LocalizationKey(@"tabBarMy");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ZTMineLabelTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTMineLabelTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZTMineLabelTableViewCell1" bundle:nil] forCellReuseIdentifier:@"ZTMineLabelTableViewCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];

    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 100)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentLogin)];
    [_tableHeadView addGestureRecognizer:tap];
    _tableHeadView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = _tableHeadView;
    self.headerView=[[[MineTableHeadView alloc]init] instancetableHeardViewWithFrame:_tableHeadView.frame];
    _updateHub = [[RKNotificationHub alloc] initWithBarButtonItem:self.navigationItem.rightBarButtonItem];
    [_updateHub scaleCircleSizeBy:0.3];
    [_updateHub hideCount];

    [_tableHeadView addSubview:self.headerView];
    self.assetTotalArr = [[NSMutableArray alloc] init];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    [self RightsetupNavgationItemWithpictureName:@"wd_sz"];
}

- (void)presentLogin{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
    }
}

- (void)RighttouchEvent{
    //账户设置
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
    }else{
        SettingCenterViewController *set = [[SettingCenterViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];
    }
}

#pragma mark - 版本更新接口请求
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                 NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"app_Version ---- %@",app_Version);
                if ([app_Version compare:_versionModel.version] == NSOrderedSame ||[app_Version compare:_versionModel.version] == NSOrderedDescending) {
                    //不需要更新
                    updateFlag = NO;
                    [_updateHub decrementBy:0];
                }else{
                    [_updateHub increment];
                    updateFlag = YES;
                }
                if (!kUpdateAppStore) {

                    [self.tableView reloadData];
                }
                
            }else if ([resPonseObj[@"code"] integerValue]==4000||[resPonseObj[@"code"] integerValue]==3000){
                [YLUserInfo logout];
                
            }else if ([resPonseObj[@"code"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                
            }
        }else{
            
        }
    }];
    
}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    self.navigationItem.title = LocalizationKey(@"tabBarMy");
    [self.tableView reloadData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LanguageChange object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self versionUpdate];
    if(![YLUserInfo isLogIn]){
        //没登录不做处理
        self.headerView.headImage.image = [UIImage imageNamed:@"defaultImage"];
        self.headerView.nicknameLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"userName" value:nil table:@"English"];
        self.headerView.uidLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"accounting" value:nil table:@"English"];
    }else{
        self.headerView.nicknameLabel.text = LocalizationKey(@"login");
        [self accountSettingData];
        [self getTotalAssets];
        [self businessstatus];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakself = self;
    if (indexPath.section == 0){
        ZTMineLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTMineLabelTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titles = @[LocalizationKey(@"accountSecurity"), LocalizationKey(@"Realnameauthentication"), LocalizationKey(@"notice"), LocalizationKey(@"FeeLevel")];
        cell.senderBlock = ^(NSInteger tag) {
            //判断用户是否已经登录
            if(![YLUserInfo isLogIn]){
                [weakself showLoginViewController];
            }else{
                if (tag == 0){
                    //安全设置
                    AccountSettingViewController *accountVC = [[AccountSettingViewController alloc] init];
                    [[AppDelegate sharedAppDelegate] pushViewController:accountVC];
                }else if (tag == 1){
                    //身份认证
                    if ([self.accountInfo.kycStatus isEqualToString:@"0"] || [self.accountInfo.kycStatus isEqualToString:@"2"] || [self.accountInfo.kycStatus isEqualToString:@"5"] || [self.accountInfo.kycStatus isEqualToString:@"4"]) {
                        //身份认证
                        IdentityAuthenticationViewController *identityVC = [[IdentityAuthenticationViewController alloc] init];
                        identityVC.identifyStatus = self.accountInfo.realVerified;
                        identityVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
                        identityVC.realAuditing = self.accountInfo.realAuditing;
                        identityVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:identityVC animated:YES];
                        return;
                    }
                    //视频认证
                    UpVideoViewController *UpVideoVC = [UpVideoViewController new];
                    UpVideoVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
                    [[AppDelegate sharedAppDelegate] pushViewController:UpVideoVC];

                }else if (tag == 2){
                    //公告中心
                    NoticeCenterViewController *notice = [[NoticeCenterViewController alloc] init];
                    [[AppDelegate sharedAppDelegate] pushViewController:notice];
                }else{
                    //手续费等级
                    FeeLevelViewController *level = [[FeeLevelViewController alloc] init];
                    [[AppDelegate sharedAppDelegate] pushViewController:level];
                }
            }
        };
        return cell;
    }else if (indexPath.section == 2){
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.leftImage.image = [UIImage imageNamed:@"promoteImage"];
//        cell.leftLabel.text = LocalizationKey(@"myPromotion");
//        cell.rightLabel.hidden = YES;
        return cell;
    }else{
        ZTMineLabelTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTMineLabelTableViewCell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titles = @[LocalizationKey(@"MerchantCertification"), LocalizationKey(@"CandyBox")];
        cell.buninessBlock = ^{
            if(![YLUserInfo isLogIn]){
                [weakself showLoginViewController];
                return;
            }
            
            //实名认证
            if (![weakself.accountInfo.realVerified isEqualToString:@"1"]) {
                [weakself.view makeToast:LocalizationKey(@"validateYourID") duration:1.5 position:CSToastPositionCenter];
                
                return;
            }
            
            //资金密码
            if (![weakself.accountInfo.fundsVerified isEqualToString:@"1"]) {
                [weakself.view makeToast:LocalizationKey(@"bindingPwd") duration:1.5 position:CSToastPositionCenter];
                
                return;
            }
            if(self.memberLevel == 0){
                //未认证商家
                ApplyBusinessViewController *ApplyBusinessVC = [ApplyBusinessViewController new];
                ApplyBusinessVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:ApplyBusinessVC animated:YES];
            }
            
            if(self.memberLevel == 1){
                //待审核
                BeingauditedBusViewController *BeingauditedBusVC = [BeingauditedBusViewController new];
                BeingauditedBusVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:BeingauditedBusVC animated:YES];
            }
            
            if(self.memberLevel == 2){
                
                //审核成功
                SuccessBusViewController *SuccessVC = [SuccessBusViewController new];
                SuccessVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:SuccessVC animated:YES];
            }
            
            if (self.memberLevel == 3) {
                //审核失败
                FailBusinessViewController *FailBusinessVC = [FailBusinessViewController new];
                FailBusinessVC.Reasonstring = self.reasonstr;
                FailBusinessVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:FailBusinessVC animated:YES];
            }
            
            if(self.memberLevel == 4){
                //保证金不足
                
            }
            
            if(self.memberLevel == 5){
                //退保-待审核
                
            }
            
            if(self.memberLevel == 6){
                //退保-审核失败
                
            }
            
            if(self.memberLevel == 7){
                //退保-审核成功
                
            }
            
        };
        cell.candyBlock = ^{
            //糖果盒
            if(![YLUserInfo isLogIn]){
                [weakself showLoginViewController];
                return;
            }
            CandyBoxViewController *candy = [[CandyBoxViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:candy];
        };
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    if (indexPath.section == 2) {
        if(![YLUserInfo isLogIn]){
            [self showLoginViewController];
            return;
        }
        MyPromoteViewController *promoteVC = [[MyPromoteViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:promoteVC];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        return 100;
    }else{
        return (KScreenW - 20)*176.0f/724.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

//MARK:--请求总资产的接口
-(void)getTotalAssets{
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.assetTotalArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                CGFloat ass1 = 0.0;
                CGFloat ass2 = 0.0;
                for (WalletManageModel *walletModel in dataArr) {
                    //计算总资产
                    ass1 = ass1 +[walletModel.balance floatValue]*[walletModel.coin.usdRate floatValue];
                    ass2 = ass2 +[walletModel.balance floatValue]*[walletModel.coin.cnyRate floatValue];
                    
                    [self.assetTotalArr addObject:walletModel];
                }
                
                self.assetUSD = [NSString stringWithFormat:@"%f",ass1];
                self.assetCNY  = [NSString stringWithFormat:@"≈%.2fCNY",ass2];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取用户信息 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                if (![self.accountInfo.avatar isEqualToString:[YLUserInfo shareUserInfo].avatar]) {
                  //保存头像
                    [YLUserInfo shareUserInfo].avatar = self.accountInfo.avatar;
                    [YLUserInfo saveUser:[YLUserInfo shareUserInfo]];
                }
                [self getAccountSettingStatus];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//验证用户是否为验证商家
-(void)businessstatus{
    [MineNetManager userbusinessstatus:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.memberLevel = [[[resPonseObj objectForKey:@"data"] objectForKey:@"certifiedBusinessStatus"] integerValue];
                self.reasonstr = [[resPonseObj objectForKey:@"data"] objectForKey:@"detail"];

            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--整理账号设置的信息状态
-(void)getAccountSettingStatus{
    if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
    }else{
        NSURL *headUrl = [NSURL URLWithString:self.accountInfo.avatar];
        [self.headerView.headImage sd_setImageWithURL:headUrl];
    }    
    self.headerView.nicknameLabel.text = self.accountInfo.username;
    self.headerView.uidLabel.text = [NSString stringWithFormat:@"uid:%@",self.accountInfo.ID];
    self.headerView.welcomeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"accounting" value:nil table:@"English"];
    
    if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"0"]) {
        //普通用户
        self.headerView.identityLabel.text = LocalizationKey(@"Ordinaryusers");
    }else if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"1"]){
        //实名用户
        self.headerView.identityLabel.text = LocalizationKey(@"Realnameuser");
    }else{
        //认证商家
        self.headerView.identityLabel.text = LocalizationKey(@"Certifiedmerchant");
    }
    
    if ([_accountInfo.fundsVerified isEqualToString:@"1"]) {
        _fundsVerified = YES;
    }else{
        _fundsVerified = NO;
    }
    
    if ([_accountInfo.realVerified isEqualToString:@"1"]) {
        //审核成功
        _realVerified = YES;
    }else{
        _realVerified = NO;
    }
    
}


@end
