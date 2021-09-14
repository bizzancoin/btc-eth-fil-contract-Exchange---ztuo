//
//  IntegralRecordViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IntegralRecordViewController.h"
#import "IntegralRecordTableViewCell.h"
#import "IntegralRecordModel.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"

@interface IntegralRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UILabel *recordLabel;

@end

@implementation IntegralRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LocalizationKey(@"Integralrecord");
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getData];
    [self accountSettingData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntegralRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralRecordTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IntegralRecordTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2) {
        cell.backView.backgroundColor = BackColor;
    }else{
        cell.backView.backgroundColor = [UIColor whiteColor];
    }
    IntegralRecordModel *model = self.dataSourceArr[indexPath.row];
    
    if ([model.type isEqualToString:@"0"]) {
        cell.typeLabel.text = LocalizationKey(@"promotionRewards");
    }else if ([model.type isEqualToString:@"0"]){
        cell.typeLabel.text = LocalizationKey(@"C2CRecharge");
    }else{
        cell.typeLabel.text = LocalizationKey(@"coinRecharge");
    }
    cell.countLabel.text = model.amount;
    cell.timeLabel.text = model.createTime;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BackColor;
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW - 130, 10, 120, 20)];
    time.textColor = AppTextColor_333333;
    time.font = [UIFont systemFontOfSize:12];
    time.text = LocalizationKey(@"time");
    time.textAlignment = NSTextAlignmentRight;
    [view addSubview:time];
    
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 55, 20)];
    type.textColor = AppTextColor_333333;
    type.font = [UIFont systemFontOfSize:12];
    type.text = LocalizationKey(@"type");
    type.textAlignment = NSTextAlignmentLeft;
    [view addSubview:type];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(type.frame) + 5, 10, kWindowW - type.frame.size.width - time.frame.size.width - 20 - 10, 20)];
    count.textColor = AppTextColor_333333;
    count.font = [UIFont systemFontOfSize:12];
    count.text = LocalizationKey(@"amount");
    count.textAlignment = NSTextAlignmentCenter;
    [view addSubview:count];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)getData{
    self.page = 1;
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/integration/record/page_query"];
    NSDictionary *param = @{@"pageNum":@1, @"pageSize":@10};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        NSLog(@"获取用户积分列表 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    [self.dataSourceArr removeAllObjects];
                    NSArray *data = responseResult[@"data"];
                    for (NSDictionary *dic in data) {
                        IntegralRecordModel *model = [IntegralRecordModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                }
                [self.tableView reloadData];
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (void)getMoreData{
    __weak typeof(self)weakself = self;
    self.page ++;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/integration/record/page_query"];
    NSDictionary *param = @{@"pageNum":[NSNumber numberWithInteger:self.page], @"pageSize":@10};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取用户积分列表 ---- %@",responseResult);
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
            self.page --;
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    for (NSDictionary *dic in data) {
                        IntegralRecordModel *model = [IntegralRecordModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                }
                [self.tableView reloadData];
            }else{
                self.page --;
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取用户信息 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                AccountSettingInfoModel *model = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
                self.recordLabel.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"Currentscore"), model.integration];

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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];

        
        [_tableView registerNib:[UINib nibWithNibName:@"IntegralRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntegralRecordTableViewCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWindowW - 20, 30)];
        self.recordLabel = label;
        label.textColor = AppTextColor_333333;
        label.font = [UIFont systemFontOfSize:18];
        label.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"Currentscore"), [YLUserInfo shareUserInfo].integration];
        [_tableHeaderView addSubview:label];
    }
    return _tableHeaderView;
}

@end
