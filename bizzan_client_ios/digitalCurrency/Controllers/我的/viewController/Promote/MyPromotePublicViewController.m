//
//  MyPromotePublicViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromotePublicViewController.h"
#import "PromoteFriendsTableViewCell.h"
#import "MyCommissionTableViewCell.h"
#import "MineNetManager.h"
#import "PromoteFriendsModel.h"
#import "MyCommissionModel.h"
#import "IntegralRecordModel.h"
#import "IntegralRecordTableViewCell.h"

@interface MyPromotePublicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIView *PromoteFriendsheader;
@property (nonatomic,strong)UIView *MineNetheader;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger totalPage;

@end

@implementation MyPromotePublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
     [self.tableView registerNib:[UINib nibWithNibName:@"PromoteFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PromoteFriendsTableViewCell class])];
     [self.tableView registerNib:[UINib nibWithNibName:@"IntegralRecordTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IntegralRecordTableViewCell class])];
    self.dataArr = [[NSMutableArray alloc] init];
    NSArray *tipArr = @[LocalizationKey(@"noPromoteFriends"),LocalizationKey(@"noMyCommission")];
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:tipArr[_index]];
    self.tableView.ly_emptyView = emptyView;
    self.pageNo = 1;

    [self headRefreshWithScrollerView:_tableView];
    [self footRefreshWithScrollerView:_tableView];
}

//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    if (self.pageNo > self.totalPage) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noMoredata" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [self getData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageNo = 1;
    [self getData];
}
//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    if (_index == 0) {
        //推广好友
        [MineNetManager getPromoteFriendsPageno:pageNoStr ForCompleteHandle:^(id resPonseObj, int code) {
    
            [EasyShowLodingView hidenLoding];
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    if (self.pageNo == 1) {
                        [self.dataArr removeAllObjects];
                    }
                    self.totalPage = [[resPonseObj objectForKey:@"totalPage"] integerValue];
                    //获取数据成功
                    NSArray *dataArr = [PromoteFriendsModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                    [self.dataArr addObjectsFromArray:dataArr];
                    [self.tableView reloadData];
                   
                }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                    [YLUserInfo logout];
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
            }
        }];
        
    }else{
        //我的奖励
        __weak typeof(self)weakself = self;
        [EasyShowLodingView showLoding];
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/integration/record/page_query"];
        NSDictionary *param = @{@"pageNum":[NSNumber numberWithInteger:self.pageNo], @"pageSize":@10};
        [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
            [EasyShowLodingView hidenLoding];
            
            NSLog(@"获取用户积分列表 ---- %@",responseResult);
            if ([responseResult objectForKey:@"resError"]) {
                NSError *error = responseResult[@"resError"];
                [weakself.view makeToast:error.localizedDescription];
            }else{
                if ([responseResult[@"code"] integerValue] == 0) {
                    if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                        [self.dataArr removeAllObjects];
                        NSArray *data = responseResult[@"data"];
                        for (NSDictionary *dic in data) {
                            IntegralRecordModel *model = [IntegralRecordModel mj_objectWithKeyValues:dic];
                            [self.dataArr addObject:model];
                        }
                    }
                    [self.tableView reloadData];
                }else{
                    [weakself.view makeToast:responseResult[@"message"]];
                }
            }
        }];;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArr.count > 0) {
        if (_index == 0) {
            return 50;
        }
        return 40;
    }else{
        return 0.01;
    }
  
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArr.count > 0) {
        if (_index == 0) {
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:self.PromoteFriendsheader];
            
            return view;
        }else{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = RGBOF(0xf5f5f5);
            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW - 130, 10, 120, 20)];
            time.textColor = RGBOF(0x666666);
            time.font = [UIFont systemFontOfSize:12];
            time.text = LocalizationKey(@"time");
            time.textAlignment = NSTextAlignmentRight;
            [view addSubview:time];
            
            UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 55, 20)];
            type.textColor = RGBOF(0x666666);
            type.font = [UIFont systemFontOfSize:12];
            type.text = LocalizationKey(@"type");
            type.textAlignment = NSTextAlignmentLeft;
            [view addSubview:type];
            
            UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(type.frame) + 5, 10, kWindowW - type.frame.size.width - time.frame.size.width - 20 - 10, 20)];
            count.textColor = RGBOF(0x666666);
            count.font = [UIFont systemFontOfSize:12];
            count.text = LocalizationKey(@"amount");
            count.textAlignment = NSTextAlignmentCenter;
            [view addSubview:count];
            
            return view;
        }
    }else{
        return nil;
    }
   
    
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        //推广好友
        PromoteFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PromoteFriendsTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PromoteFriendsModel *model = self.dataArr[indexPath.row];
        cell.registerTime.text = model.createTime;
        
        cell.userName.text = model.username?:@"";
        if ([model.level isEqualToString:@"0"]) {
            cell.recommendedLevel.text = LocalizationKey(@"oneLevel");
        }else if ([model.level isEqualToString:@"1"]){
            cell.recommendedLevel.text = LocalizationKey(@"twoLevel");
        }else if ([model.level isEqualToString:@"2"]){
            cell.recommendedLevel.text = LocalizationKey(@"threeLevel");
        }else{
            cell.recommendedLevel.text = LocalizationKey(@"fourLevel");
        }
        return cell;
    }else{
        //我的佣金
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
        IntegralRecordModel *model = self.dataArr[indexPath.row];
        
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
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_index == 0) {
        return 70;
    }else{
        return 40;
    }
}
-(UIView *)PromoteFriendsheader{
    if (!_PromoteFriendsheader) {
        _PromoteFriendsheader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _PromoteFriendsheader.backgroundColor = RGBOF(0xf5f5f5);
        UILabel *registerlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (kWindowW-100)/3*2, 50)];
        registerlabel.text = LocalizationKey(@"registTime");
        registerlabel.font = [UIFont systemFontOfSize:16];
        registerlabel.textColor = RGBOF(0x666666);
        [_PromoteFriendsheader addSubview:registerlabel];
        
        UILabel *recommendedLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW - 90, 0, 80, 50)];
        recommendedLevelLabel.text = LocalizationKey(@"referralLevel");
        recommendedLevelLabel.font = [UIFont systemFontOfSize:16];
        recommendedLevelLabel.textColor = RGBOF(0x666666);
        recommendedLevelLabel.textAlignment = NSTextAlignmentCenter;
        [_PromoteFriendsheader addSubview:recommendedLevelLabel];
        
        UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(registerlabel.right, 0, kWindowW - registerlabel.right - 90, 50)];
        userNameLabel.text = LocalizationKey(@"username");
        userNameLabel.font = [UIFont systemFontOfSize:16];
        userNameLabel.textColor = RGBOF(0x666666);
        userNameLabel.textAlignment = NSTextAlignmentCenter;

        [_PromoteFriendsheader addSubview:userNameLabel];
        
    }
    return _PromoteFriendsheader;
}


-(UIView *)MineNetheader{
    if (!_MineNetheader) {
        _MineNetheader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _MineNetheader.backgroundColor = [UIColor whiteColor];
        
        UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW - 90, 0, 80, 50)];
        remarkLabel.text = LocalizationKey(@"remark");
        remarkLabel.font = [UIFont systemFontOfSize:16];
        remarkLabel.textColor = kRGBColor(126, 126, 126);
        remarkLabel.textAlignment = NSTextAlignmentRight;

        [_MineNetheader addSubview:remarkLabel];
        
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW - 150, 0, 60, 50)];
        amountLabel.text = LocalizationKey(@"amount");
        amountLabel.font = [UIFont systemFontOfSize:16];
        amountLabel.textColor = kRGBColor(126, 126, 126);
        amountLabel.textAlignment = NSTextAlignmentCenter;

        [_MineNetheader addSubview:amountLabel];
        
        UILabel *coinTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW - 210, 0, 60, 50)];
        coinTypeLabel.text = LocalizationKey(@"currency");
        coinTypeLabel.font = [UIFont systemFontOfSize:16];
        coinTypeLabel.textColor = kRGBColor(126, 126, 126);
        coinTypeLabel.textAlignment = NSTextAlignmentCenter;
        
        [_MineNetheader addSubview:coinTypeLabel];
        
        
        
        UILabel *issueTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, coinTypeLabel.left - 10, 50)];
        issueTimeLabel.text = LocalizationKey(@"releaseTime");
        issueTimeLabel.font = [UIFont systemFontOfSize:16];
        issueTimeLabel.textColor = kRGBColor(126, 126, 126);
        
        [_MineNetheader addSubview:issueTimeLabel];
    }
    
    return _MineNetheader;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
