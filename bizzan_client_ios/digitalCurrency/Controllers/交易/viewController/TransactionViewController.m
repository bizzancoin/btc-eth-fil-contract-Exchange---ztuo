//
//  TransactionViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "TransactionViewController.h"
#import "TradeViewController.h"
#import "FrenchCurrencyViewController.h"

@interface TransactionViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate>
{
    UIView *_lineView;
}
@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation TransactionViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleDefault;
    NSArray *titles = @[LocalizationKey(@"coinCurrencyTrading"), LocalizationKey(@"CurrencyTrade")];

    for (int i = 0; i < self.btnsArr.count; i++) {
        UIButton *btn = self.btnsArr[i];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changC2C) name:@"changeToC2C" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData:)name:CURRENTSELECTED_SYMBOL object:nil];

    self.navigationController.delegate = self;
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.mainScrollView];
    [self setChildViewControllers];
    
}

- (void)changC2C{
    [self typeClick:self.btnsArr[1]];
}

-(void)reloadShowData:(NSNotification *)notif{
    [self typeClick:self.btnsArr[0]];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    if ([vc isKindOfClass:NSClassFromString(@"TradeViewController")]) {
        TradeViewController *trade = (TradeViewController *)vc;
        [trade getPersonAllCollection];
    }
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.mainScrollView.frame.size.height);
}

#pragma mark - 加载试图控制器
- (void)setChildViewControllers{
    TradeViewController *indus = [[TradeViewController alloc] init];
    indus.view.frame = CGRectMake(0, 0, kWindowW, self.mainScrollView.frame.size.height);
    [self.mainScrollView addSubview:indus.view];
    [self addChildViewController:indus];
    
    FrenchCurrencyViewController *market = [[FrenchCurrencyViewController alloc] init];
    [self addChildViewController:market];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 1.添加子控制器view
    [self showVc:index];
    
//    [self navTitleBtnSel:(UIButton *)[self.navTitleView viewWithTag:index + 10086]];
}

- (void)typeClick:(UIButton *)sender{
    NSInteger tag = sender.tag;
    _lineView.centerX = sender.centerX;
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    // 1 计算滚动的位置
    CGFloat offsetX = sender.tag * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:sender.tag];
    
    switch (tag) {
        case 0:
            {
                //币币交易
            }
            break;
        case 1:
            {
                //杠杆交易
            }
            break;
        case 2:
            {
                //法币交易
            }
            break;
            
        default:
            break;
    }
}

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, Height_NavBar)];
        _naviView.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_StatusBar, kWindowW, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        [_naviView addSubview:backView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 1)];
        lineView.backgroundColor = NavColor;
        _lineView = lineView;
        [backView addSubview:lineView];

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, backView.frame.size.height- 1, kWindowW, 1)];
        bottomLine.backgroundColor = RGBOF(0xF5F5F5);
        [backView addSubview:bottomLine];
        NSArray *titles = @[LocalizationKey(@"coinCurrencyTrading"), LocalizationKey(@"CurrencyTrade")];
        
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15 + ((kWindowW - 45) / titles.count) * i + i * 15, 7, (kWindowW - 45) / titles.count, 30);
            btn.adjustsImageWhenHighlighted = NO;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:NavColor forState:UIControlStateSelected];
            btn.tag = i;
            if (i == 0) {
                btn.selected = YES;
                lineView.center = CGPointMake(btn.centerX, CGRectGetMaxY(btn.frame));
            }
            [btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];

            [self.btnsArr addObject:btn];
        }
    }
    return _naviView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        // 创建底部滚动视图
        self.mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, Height_NavBar, kWindowW, kWindowH - Height_NavBar - Height_TabBar);
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.scrollEnabled = NO;
        // 开启分页
        _mainScrollView.pagingEnabled = YES;
        // 没有弹簧效果
        _mainScrollView.bounces = NO;
        // 隐藏水平滚动条
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

@end
