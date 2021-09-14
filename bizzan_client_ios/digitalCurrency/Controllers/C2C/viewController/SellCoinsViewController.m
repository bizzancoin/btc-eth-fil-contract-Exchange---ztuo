//
//  SellCoinsViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "SellCoinsViewController.h"
#import "AdvertisingBGView.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"
#import "BuyCoinsDetailViewController.h"
#import "C2CNetManager.h"
#import "CoinUserInfoModel.h"
#import "CToCTableViewCell.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"

@interface SellCoinsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AdvertisingBGView *_adView; //广告
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,assign)NSInteger pageNo;
@property (nonatomic,strong)NSMutableArray *coinTypeArr;
@property (nonatomic, strong) LYEmptyView *emptyView;
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (nonatomic, strong) AccountSettingInfoModel *accountInfo;

@end

@implementation SellCoinsViewController

- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"noSellCoinTip" value:nil table:@"English"]];
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CToCTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CToCTableViewCell class])];
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"noSellCoinTip" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView *emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"noSellCoinTip" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LanguageChange object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageNo = 1;
    [self getData];
    [self accountSettingData];
}
//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self getData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    [self getData];
}
//MARK:--获取广告的数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    [C2CNetManager advertisingQueryForPageNo:pageNoStr withPageSize:@"20" withAdvertiseType:@"BUY" withAdvertiseId:self.model.ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
//        NSLog(@"-model---id-%@",_model.ID);
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_coinTypeArr removeAllObjects];
                }
//                NSLog(@"--%@",resPonseObj);
                NSArray *dataArr = [CoinUserInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"context"]];
                [self.coinTypeArr addObjectsFromArray:dataArr];
                self.tableView.ly_emptyView = self.emptyView;
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (NSMutableArray *)coinTypeArr {
    if (!_coinTypeArr) {
        _coinTypeArr = [NSMutableArray array];
    }
    return _coinTypeArr;
}
//MARK:--卖币的点击事件
- (IBAction)sellCoinBtnClick:(UIButton *)sender {
    [self advertisingBGView];
}
-(void)advertisingBGView{
    if (!_adView) {
        _adView = [[NSBundle mainBundle] loadNibNamed:@"AdvertisingBGView" owner:nil options:nil].firstObject;
        _adView.frame=[UIScreen mainScreen].bounds;
        
        [_adView.buyButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.sellButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.cancelButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    }
     [_adView setMenu];
     [UIApplication.sharedApplication.keyWindow addSubview:_adView];
}
-(void)push:(UIButton*)sender{
    [_adView dismissMenu];
  
    //判断用户是否已经登录
    if(![YLUserInfo isLogIn]&&sender.tag != 3){
        [self showLoginViewController];
    }else{
        if(sender.tag == 1){
            //购买
            AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:buyVC];
        }else if (sender.tag == 2){
            //出售
            AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:sellVC];
        }else if (sender.tag == 3){
            //取消
        }else{
            //其他
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _coinTypeArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cToc";
    CToCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CToCTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CoinUserInfoModel *model = _coinTypeArr[indexPath.row];
    cell.coinUserInfoModel = model;
    [cell.buyBtn setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"sell" value:nil table:@"English"] forState:UIControlStateNormal];
    [cell.buyBtn setBackgroundColor:RGBOF(0xD0B387)];
    __weak typeof(self)weakself = self;
    cell.block = ^{
        if(![YLUserInfo isLogIn]){
            [weakself showLoginViewController];
        }else{
            if (self.accountInfo == nil) {
                return;
            }
            if ([self.accountInfo.realVerified isEqualToString:@"1"]) {
                BuyCoinsDetailViewController *detailVC = [[BuyCoinsDetailViewController alloc] init];
                CoinUserInfoModel *model = _coinTypeArr[indexPath.row];
                detailVC.advertisingId = model.advertiseId;
                detailVC.unit = model.unit;
                detailVC.headImage = model.avatar;
                detailVC.flagindex = 1;
                detailVC.remainAmount=model.remainAmount;
                [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
            }else{
                [self.view makeToast:LocalizationKey(@"validateYourID") duration:1.5 position:CSToastPositionCenter];
            }
            
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断用户是否已经登录
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
    }else{
        if (self.accountInfo == nil) {
            return;
        }
        if ([self.accountInfo.realVerified isEqualToString:@"1"]) {
            BuyCoinsDetailViewController *detailVC = [[BuyCoinsDetailViewController alloc] init];
            CoinUserInfoModel *model = _coinTypeArr[indexPath.row];
            detailVC.advertisingId = model.advertiseId;
            detailVC.unit = model.unit;
            detailVC.headImage = model.avatar;
            detailVC.flagindex = 1;
            detailVC.remainAmount=model.remainAmount;
            [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
        }else{
            [self.view makeToast:LocalizationKey(@"validateYourID") duration:1.5 position:CSToastPositionCenter];
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 166;
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
            }else{
                
            }
        }else{
            
        }
    }];
}

#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DebugLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    DebugLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}


@end
