//
//  FeeLevelChildViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "FeeLevelChildViewController.h"
#import "FeeLevelTableViewCell.h"

@interface FeeLevelChildViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_recordLabel;
    FeeLevelModel *_model;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation FeeLevelChildViewController

- (instancetype)initWithModel:(FeeLevelModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeeLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeeLevelTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FeeLevelTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.leftLabel.text = LocalizationKey(@"CoinFee");
        cell.rightLabel.text = _model.exchangeFeeRate;
    }else if (indexPath.row == 1){
        cell.leftLabel.text = LocalizationKey(@"Legalcurrency");
        cell.rightLabel.text = _model.exchangeFeeRate;
    }else if (indexPath.row == 2){
        cell.leftLabel.text = LocalizationKey(@"Leveragedtransactionfees");
        cell.rightLabel.text = _model.exchangeFeeRate;
    }else if (indexPath.row == 3){
        cell.leftLabel.text = LocalizationKey(@"Dailywithdrawalquota");
        cell.rightLabel.text = _model.withdrawCoinAmount;
    }else{
        cell.leftLabel.text = LocalizationKey(@"Numberofpenswithdrawnperday");
        cell.rightLabel.text = _model.dayWithdrawCount;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWindowW - 20, 20)];
    type.textColor = RGBOF(0x333333);
    type.font = [UIFont systemFontOfSize:14];
    type.text = [NSString stringWithFormat:@"Lv%@%@",_model.ID, LocalizationKey(@"Hierarchicalprivilege")];
    type.textAlignment = NSTextAlignmentLeft;
    [view addSubview:type];
    
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


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"FeeLevelTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeeLevelTableViewCell"];
        
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
