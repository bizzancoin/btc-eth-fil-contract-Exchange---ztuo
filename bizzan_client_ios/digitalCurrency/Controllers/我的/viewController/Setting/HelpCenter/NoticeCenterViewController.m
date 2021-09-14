//
//  NoticeCenterViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/6.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "NoticeCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "PlatformMessageModel.h"
#import "MineNetManager.h"
#import "PlatformMessageDetailViewController.h"
@interface NoticeCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *platformMessageArr;

@end

@implementation NoticeCenterViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Noticecenter" value:nil table:@"English"];
    self.view.backgroundColor = BackColor;
    [self.view addSubview:self.tableView];

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [self customNavigationBar];
    [self getNotice];
//    [self headRefreshWithScrollerView:self.tableView];
}

- (void)refreshFooterAction{
    
}
- (void)refreshHeaderAction{
    [self getNotice];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.platformMessageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *identifier = @"helpCell";
    HelpCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HelpCenterTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.platformMessageArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(void)getNotice{
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"50" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"resPonseObj -- %@",resPonseObj);
        LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noDada")];
        self.tableView.ly_emptyView = emptyView;
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.platformMessageArr removeAllObjects];
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in arr) {
                    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                        if (![self hasChinese:dic[@"title"]]) {
                            [muArr addObject:dic];
                        }
                    }else{
                        if ([self hasChinese:dic[@"title"]]) {
                            [muArr addObject:dic];
                        }
                    }
                }
                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
                [self.platformMessageArr addObjectsFromArray:dataArr];
                
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}

- (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)moreAction:(UIButton *)sender{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlatformMessageModel*model=self.platformMessageArr[indexPath.row];
    PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
    detailVC.content = model.content;
    detailVC.navtitle = model.title;
    [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

- (NSMutableArray *)platformMessageArr{
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _platformMessageArr;
}

@end
