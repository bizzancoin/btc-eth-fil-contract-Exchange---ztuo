//
//  CandyBoxViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "CandyBoxViewController.h"
#import "IntegralRecordTableViewCell.h"
#import "CandyBoxModel.h"

@interface CandyBoxViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation CandyBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalizationKey(@"CandyBox");
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getData];
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
        cell.backView.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backView.backgroundColor = BackColor;
    }
    CandyBoxModel *model = self.dataSourceArr[indexPath.row];
    
    cell.typeLabel.text = model.giftName;
    cell.countLabel.text = [NSString stringWithFormat:@"%@%@",model.giftAmount, model.giftCoin];
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
    view.backgroundColor = [UIColor whiteColor];
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
    type.text = LocalizationKey(@"Activityname");
    type.textAlignment = NSTextAlignmentLeft;
    [view addSubview:type];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(type.frame) + 5, 10, kWindowW - type.frame.size.width - time.frame.size.width - 20 - 10, 20)];
    count.textColor = AppTextColor_333333;
    count.font = [UIFont systemFontOfSize:12];
    count.text = LocalizationKey(@"Quantityofdonation");
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/gift/record"];
    NSDictionary *param = @{@"pageNum":@1, @"pageSize":@10};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        NSLog(@"获取糖果列表 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    [self.dataSourceArr removeAllObjects];
                    NSArray *data = responseResult[@"data"];
                    for (NSDictionary *dic in data) {
                        CandyBoxModel *model = [CandyBoxModel mj_objectWithKeyValues:dic];
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/gift/record"];
    NSDictionary *param = @{@"pageNum":[NSNumber numberWithInteger:self.page], @"pageSize":@10};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取糖果列表 ---- %@",responseResult);
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
                        CandyBoxModel *model = [CandyBoxModel mj_objectWithKeyValues:dic];
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

@end
