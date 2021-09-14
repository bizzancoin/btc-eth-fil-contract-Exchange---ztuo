//
//  BorrowMoneyRecordViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BorrowMoneyRecordViewController.h"
#import "BorrowMoneyRecordTableViewCell.h"
#import "LeverAccountModel.h"
#import "ReturnHistoryViewController.h"
@interface BorrowMoneyRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation BorrowMoneyRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LocalizationKey(@"BorrowRecords");
    self.view.backgroundColor = BackColor;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self rightBarItemWithTitle:LocalizationKey(@"history")];

}

- (void)RighttouchEvent{
    ReturnHistoryViewController *record = [[ReturnHistoryViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:record];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BorrowMoneyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowMoneyRecordTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"BorrowMoneyRecordTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
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
    [EasyShowLodingView showLoding];
    __weak typeof(self)weakself = self;
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/loan/record_list"];
    NSDictionary *param = @{@"pageNo":@1, @"pageSize":@10, @"repayment":@"0"};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param  ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取借币记录 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"][@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"][@"content"];
                    [self.dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in data) {
                        LeverWalletModel *model = [LeverWalletModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"detailTableViewTip" value:nil table:@"English"]];
                    self.tableView.ly_emptyView = emptyView;
                    [self.tableView reloadData];
                }
                
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (void)getMoreData{
    [EasyShowLodingView showLoding];
    __weak typeof(self)weakself = self;
    self.page ++;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/loan/record_list"];
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:self.page], @"pageSize":@10, @"repayment":@"0"};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param  ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取借币记录 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
            self.page --;
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if ([responseResult[@"totalElements"] integerValue] <= self.dataSourceArr.count) {
                    return;
                }
                if (responseResult[@"data"] && [responseResult[@"data"][@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"][@"content"];
                    for (NSDictionary *dic in data) {
                        LeverWalletModel *model = [LeverWalletModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    [self.tableView reloadData];
                }
                
            }else{
                self.page --;
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - NEW_NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BorrowMoneyRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BorrowMoneyRecordTableViewCell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

@end
