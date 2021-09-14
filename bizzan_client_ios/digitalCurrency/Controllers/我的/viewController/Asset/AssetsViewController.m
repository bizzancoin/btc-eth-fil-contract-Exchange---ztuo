//
//  AssetsViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsCoinViewController.h"
#import "AssetsCurrencyViewController.h"
#import "YBPopupMenu.h"
#import "CurrencyrecordViewController.h"
#import "ChargerecordViewController.h"
#import "WalletManageDetailViewController.h"
#import "IntegralRecordViewController.h"

@interface AssetsViewController ()<UIScrollViewDelegate, YBPopupMenuDelegate>
{
    NSArray *_titles;
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UIView *segView;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AssetsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = [[ChangeLanguage bundle] localizedStringForKey:@"Myassets" value:nil table:@"English"];
    [self rightBarItemWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"detail" value:nil table:@"English"]];
    _titles = @[LocalizationKey(@"AssetsCoin"), LocalizationKey(@"AssetsCurrency")];
    for (int i = 0; i < self.btnsArr.count; i++) {
        UIButton *btn = self.btnsArr[i];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
    }
    if (self.childViewControllers[_selectedIndex]&&[self.childViewControllers[_selectedIndex] performSelector:@selector(reload)]) {
        [self.childViewControllers[_selectedIndex] reload];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = 0;
    // Do any additional setup after loading the view.
    self.navigationItem.title = [[ChangeLanguage bundle] localizedStringForKey:@"Myassets" value:nil table:@"English"];
    _titles = @[LocalizationKey(@"AssetsCoin"), LocalizationKey(@"AssetsCurrency")];
    [self.view addSubview:self.segView];
    [self.view addSubview:self.scrollView];
    [self setChildController];

}

//MARK:--明细的点击事件
-(void)RighttouchEvent{
    NSArray *namearray = @[LocalizationKey(@"Currencyrecord"),LocalizationKey(@"Chargerecord"),LocalizationKey(@"Assetflow"),LocalizationKey(@"Integralrecord")];
    
    [YBPopupMenu showAtPoint:CGPointMake(kWindowW - 32, NEW_NavHeight - 15) titles:namearray icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.arrowDirection = YBPopupMenuArrowDirectionNone;
        popupMenu.delegate = self;
        popupMenu.textColor = RGBOF(0x333333);
        popupMenu.backColor = MainBackColor;
        
    }];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        //提币记录
        CurrencyrecordViewController *detailVC = [[CurrencyrecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 1) {
        //冲币记录
        ChargerecordViewController *detailVC = [[ChargerecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 2) {
        //资产流水
        WalletManageDetailViewController *detailVC = [[WalletManageDetailViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 3) {
        //积分记录
        IntegralRecordViewController *detailVC = [[IntegralRecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
}

- (void)setChildController
{
    //添加子控制器
    AssetsCoinViewController *comVC = [[AssetsCoinViewController alloc] init];
    comVC.view.frame = CGRectMake(0, 0, kWindowW, self.scrollView.frame.size.height);
    [self addChildViewController:comVC];
    [self.scrollView addSubview:comVC.view];
    
    AssetsCurrencyViewController *Currency = [[AssetsCurrencyViewController alloc] init];
    Currency.view.frame = CGRectMake(kWindowW * 1, 0, kWindowW, self.scrollView.frame.size.height);
    [self addChildViewController:Currency];
    [self.scrollView addSubview:Currency.view];
    
}

#pragma mark - UIScrollViewDelegate
- (void)showVc:(NSInteger)index {
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 1.添加子控制器view
    if (index == _selectedIndex) {
        return;
    }
    [self changeAction:self.btnsArr[index]];
}

- (void)changeAction:(UIButton *)sender{
    UIButton *btn = self.btnsArr[sender.tag];
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
            btn.layer.borderColor = NavColor.CGColor;
        }else{
            btn.selected = NO;
            btn.layer.borderColor = RGBOF(0xdddddd).CGColor;
        }
    }
    // 1 计算滚动的位置
    CGFloat offsetX = btn.tag * self.view.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:btn.tag];
    _selectedIndex = sender.tag;
    if (self.childViewControllers[_selectedIndex]&&[self.childViewControllers[_selectedIndex] performSelector:@selector(reload)]) {
        [self.childViewControllers[_selectedIndex] reload];
    }
}

- (UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _segView.backgroundColor = MainBackColor;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kWindowW, 1)];
        line.backgroundColor = BackColor;
        [_segView addSubview:line];
        for (int i = 0; i < _titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15 + i * ((kWindowW - 50) / 2) + i * 10, 10, (kWindowW - 40) / 2, 30);
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:NavColor forState:UIControlStateSelected];
            [btn setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3;
            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = RGBOF(0xdddddd).CGColor;
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            if (i == 0) {
                btn.selected = YES;
                btn.layer.borderColor = NavColor.CGColor;
            }
            [self.btnsArr addObject:btn];
            [_segView addSubview:btn];
        }
    }
    return _segView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(kWindowW * _titles.count, kWindowH-NEW_NavHeight - 50);
        _scrollView.frame=CGRectMake(0, 50, kWindowW, kWindowH-NEW_NavHeight - 50);
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

@end
