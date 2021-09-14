//
//  FeeLevelViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "FeeLevelViewController.h"
#import "ServiceChargeLevelView.h"
#import "FeeLevelModel.h"
#import "ZJScrollPageView.h"
#import "FeeLevelChildViewController.h"

@interface FeeLevelViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) ServiceChargeLevelView *headerView;
@end

@implementation FeeLevelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initHeaderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LocalizationKey(@"FeeLevel");
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"ServiceChargeLevelView" owner:self options:nil];
    ServiceChargeLevelView *backView = [nibView objectAtIndex:0];
    self.headerView = backView;
    backView.frame = CGRectMake(0, 0, kWindowW, 140);
    [self.view addSubview:backView];
    [self getData];
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    FeeLevelModel *model = self.dataSourceArr[index];
    if (!childVc) {
        childVc = [[FeeLevelChildViewController alloc] initWithModel:model];
    }
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)getData{
    [EasyShowLodingView showLoding];
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/integration/grade"];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取手续费等级 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    [self.dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in data) {
                        FeeLevelModel *model = [FeeLevelModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    [self loadSegMent];
                    [self initHeaderData];
                }
                
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (void)loadSegMent{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    //颜色渐变
    style.gradualChangeTitleColor = YES;
    //背景色
    style.segBackgroundColor = [UIColor whiteColor];
    //字体默认颜色
    style.normalTitleColor = RGBOF(0x333333);
    //字体选中颜色
    style.selectedTitleColor = NavColor;
    //线条颜色
    style.scrollLineColor = NavColor;
    style.scrollTitle = NO;
//    style.scaleTitle = YES;
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:0];
    for (FeeLevelModel *model in self.dataSourceArr) {
        [titleArr addObject:[NSString stringWithFormat:@"Lv%@",model.ID]];
    }
    self.titles = titleArr;
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, kWindowH - Height_NavBar - 160) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:_scrollPageView];
}

- (void)initHeaderData{
    for (FeeLevelModel *model in self.dataSourceArr) {
        if ([model.ID isEqualToString:[YLUserInfo shareUserInfo].memberGradeId]) {
            self.headerView.levelLabel.text = [NSString stringWithFormat:@"LV.%@",model.ID];
            self.headerView.coinFeeValueLabel.text = model.exchangeFeeRate;
            self.headerView.legalValueLabel.text = model.exchangeFeeRate;
            self.headerView.cashValueLabel.text = model.withdrawCoinAmount;
            self.headerView.pensValueLabel.text = model.dayWithdrawCount;
        }
    }
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

@end
