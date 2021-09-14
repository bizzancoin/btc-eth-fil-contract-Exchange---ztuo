//
//  AssetsCurrencyViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsCurrencyViewController.h"
#import "AssetsHeaderView.h"
#import "WalletManageTableHeadView.h"
#import "WalletManageTableViewCell.h"
#import "MineNetManager.h"
#import "WalletManageModel.h"
#import "AccountSettingInfoModel.h"
#import "ChargeMoneyViewController.h"
#import "MentionMoneyViewController.h"
#import "UIView+LLXAlertPop.h"
#import "TurnOutViewController.h"

@interface AssetsCurrencyViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property(nonatomic,strong) WalletManageTableHeadView *sectionHeader;
@property(nonatomic,strong) AssetsHeaderView *tableHeaderView;

@property(nonatomic,strong)NSMutableArray *walletManageArr;
@property(nonatomic,assign)NSInteger selectIndex;//0未隐藏 1 隐藏
@property(nonatomic,assign)NSInteger searchIndex;//0未搜索 1 搜索
@property(nonatomic,assign)NSInteger flagIndex;//1搜索 2隐藏 0没有
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,strong)NSMutableArray *searchArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;

@end

@implementation AssetsCurrencyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getData];
//    [self accountSettingData];
}

- (void)reload
{
    [self getData];
    [self accountSettingData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MainBackColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [self getData];
    self.selectArr = [[NSMutableArray alloc] init];
    self.searchArr = [[NSMutableArray alloc] init];
    self.selectIndex = 0;
    self.searchIndex = 0;
    self.flagIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectIndex == 0){
        if (_searchIndex == 0) {
            return _walletManageArr.count;
        }else{
            return _searchArr.count;
        }
    }else{
        if (_searchIndex == 0) {
            return _selectArr.count;
        }else{
            if (_flagIndex == 1) {
                return _searchArr.count;
            }else{
                return _selectArr.count;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletManageModel *model;
    if (_selectIndex == 0){
        if (_searchIndex == 0) {
            model = _walletManageArr[indexPath.row];
        }else{
            model = _searchArr[indexPath.row];
        }
    }else{
        if (_searchIndex == 0) {
            model = _selectArr[indexPath.row];
        }else{
            if (_flagIndex == 1) {
                model = _searchArr[indexPath.row];
            }else{
                model = _selectArr[indexPath.row];
            }
        }
    }
    WalletManageCoinInfoModel *infoModel = model.coin;
    
    WalletManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletManageTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.coinType.text = infoModel.unit;
    cell.availableNum.text = self.tableHeaderView.eyeBtn.selected?@"********":[ToolUtil judgeStringForDecimalPlaces:model.balance];
    cell.freezeNum.text = self.tableHeaderView.eyeBtn.selected?@"********":[ToolUtil judgeStringForDecimalPlaces:model.frozenBalance];
    cell.lockingNum.text = self.tableHeaderView.eyeBtn.selected?@"********":(model.toReleased ? [ToolUtil judgeStringForDecimalPlaces:model.toReleased] : @"0");
    cell.index = indexPath;
    cell.model = model;
    cell.availableLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"availableCoin" value:nil table:@"English"];
    cell.freezeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"freezeCoin" value:nil table:@"English"];
    cell.lockingLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Assetstoreleased" value:nil table:@"English"];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 40)];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [view addSubview:self.sectionHeader];
    self.sectionHeader.searchBar.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"searchAssets" value:nil table:@"English"];
    self.sectionHeader.selectBtnLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"hidden0Currency" value:nil table:@"English"];
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
    WalletManageModel *model;
    if (_selectIndex == 0){
        if (_searchIndex == 0) {
            model = _walletManageArr[indexPath.row];
        }else{
            model = _searchArr[indexPath.row];
        }
    }else{
        if (_searchIndex == 0) {
            model = _selectArr[indexPath.row];
        }else{
            if (_flagIndex == 1) {
                model = _searchArr[indexPath.row];
            }else{
                model = _selectArr[indexPath.row];
            }
        }
    }
    
    if ([model.clickIndex isEqualToString:@"1"]) {
        model.clickIndex = @"0";
    }else{
        model.clickIndex = @"1";
    }
    NSArray *arrayTitle = @[LocalizationKey(@"Transfer")];

    [self.view createAlertViewTitleArray:arrayTitle textColor:nil font:[UIFont systemFontOfSize:16] type:1  actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        if ([button.currentTitle isEqualToString:LocalizationKey(@"Transfer")]){
            //划转
            [self turnOutWithModel:model];
        }
    }];
    
}

//MARK:--转出点击事件
- (void)turnOutWithModel:(WalletManageModel *)model{
    TurnOutViewController *turn = [[TurnOutViewController alloc] init];
    turn.unit = model.coin.unit;
    turn.from = AccountType_Coin;
    turn.to = AccountType_Curreny;
    [[AppDelegate sharedAppDelegate] pushViewController:turn];
    [self.tableView reloadData];
}

//MARK:--隐藏为0的币种
-(void)selectBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.flagIndex = 2;
        _selectIndex = 1;
        //被选择
        [self.sectionHeader.selectButton setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateNormal];
        [_selectArr removeAllObjects];
        if (_searchIndex == 0) {
            //未搜索
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }else if (_searchIndex == 1) {
            //搜索
            for (WalletManageModel *model in _searchArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }
    }else{
        self.flagIndex = 0;
        //未被选择
        [self.sectionHeader.selectButton setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
        [self.selectArr removeAllObjects];
        if (_searchIndex == 0) {
            //未搜索
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }else if (_searchIndex == 1) {
            //搜索
            for (WalletManageModel *model in _searchArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }
        _selectIndex = 0;
    }
    [self.tableView reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        //不处理
        self.flagIndex = 0;
        _searchIndex = 0;
    }else{
        self.flagIndex = 1;
        [self.searchArr removeAllObjects];
        //小写转大写
        NSString *transformString = [searchBar.text uppercaseString];
        if (_selectIndex == 0) {
            //未隐藏
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.coin.unit containsString:transformString]) {
                    [self.searchArr addObject:model];
                }
            }
        }else if (_selectIndex == 1) {
            //已隐藏
            for (WalletManageModel *model in _selectArr) {
                if ([model.coin.unit containsString:transformString]) {
                    [self.searchArr addObject:model];
                }
            }
        }
        _searchIndex = 1;
    }
    
    [self.tableView reloadData];
}



//键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

//MARK:---获取我的钱包所有数据
-(void)getData{
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/otc/wallet/get"];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:nil contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取法币账户 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription duration:1.5 position:CSToastPositionCenter];

            
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [self.walletManageArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
                NSDecimalNumber *ass2 = [[NSDecimalNumber alloc] initWithString:@"0"];
                [self.walletManageArr addObjectsFromArray:dataArr];
                for (WalletManageModel *walletModel in dataArr) {
                    //计算总资产
                    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:walletModel.balance];
                    NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.usdRate];
                    NSDecimalNumber *cnyRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.cnyRate];
                    
                    ass1 = [ass1 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle] withBehavior:handle];
                    ass2 = [ass2 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:cnyRate withBehavior:handle] withBehavior:handle];
                }
                self.assetUSD = [ass1 stringValue];
                self.assetCNY = [ass2 stringValue];
                [self.tableView reloadData];
                [self initHeaderData];
            }else{
                [self.view makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];

//                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"]];
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
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - NEW_NavHeight - 50 - Height_TabBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WalletManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletManageTableViewCell"];
        
    }
    return _tableView;
}

- (WalletManageTableHeadView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[WalletManageTableHeadView alloc] instancetableHeardViewWithFrame:CGRectMake(0, 0, kWindowW, 40)];
        _sectionHeader.searchBar.delegate = self;
        [_sectionHeader.selectButton addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UITextField * searchField = [_sectionHeader.searchBar valueForKey:@"_searchField"];
        searchField.font = [UIFont systemFontOfSize:13];
        [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        _sectionHeader.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
        [self doneForSearchBar];
    }
    return _sectionHeader;
}

//MARK:--给searchBar的键盘加上完成按钮
-(void)doneForSearchBar{
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38.0f)];
    toobar.backgroundColor = MainBackColor;
    toobar.translucent = YES;
    toobar.barStyle = UIBarStyleDefault;
    UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizationKey(@"done") style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:255/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    [doneBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [doneBarButtonItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [toobar setItems:@[spaceBarButtonItem,doneBarButtonItem]];
    self.sectionHeader.searchBar.inputAccessoryView = toobar;
}
- (void)resignKeyboard:(id)sender{
    [self.sectionHeader.searchBar resignFirstResponder];
}

- (AssetsHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[AssetsHeaderView alloc] instancetableHeardViewWithFrame:CGRectMake(0, 0, kWindowW, 137)];
        _tableHeaderView.totalAssetNameLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"totalAssets" value:nil table:@"English"];
        [_tableHeaderView.idenLabel setTitle:LocalizationKey(@"Ordinaryusers") forState:UIControlStateNormal];
        __weak typeof(_tableHeaderView)weak = _tableHeaderView;
        __weak typeof(self)weakself = self;
        _tableHeaderView.block = ^(BOOL isHiden) {
            if (isHiden) {
                weak.usdtLabel.text = @"********";
                weak.cnyLabel.text = @"********";
            }else{
                weak.usdtLabel.text = weakself.assetUSD;
                weak.cnyLabel.text = weakself.assetCNY;
            }
            [weakself.tableView reloadData];
        };
        
    }
    return _tableHeaderView;
}

- (void)initHeaderData{
    if (!self.assetUSD ) {
        self.tableHeaderView.usdtLabel.text = @"0.000000";
        self.tableHeaderView.cnyLabel.text = @"0.000000";
    }else{
        self.tableHeaderView.usdtLabel.text = self.tableHeaderView.eyeBtn.selected?@"********":self.assetUSD;
    }
    if (!self.assetCNY) {
        self.tableHeaderView.cnyLabel.text = @"≈0.00CNY";
        self.assetCNY = @"≈0.00CNY";
    }else{
        self.tableHeaderView.cnyLabel.text = self.tableHeaderView.eyeBtn.selected?@"********":self.assetCNY;
    }
    if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"0"]) {
        //普通用户
        [self.tableHeaderView.idenLabel setTitle:LocalizationKey(@"Ordinaryusers") forState:UIControlStateNormal];
    }else if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"1"]){
        //实名用户
        [self.tableHeaderView.idenLabel setTitle:LocalizationKey(@"Realnameuser") forState:UIControlStateNormal];
    }else{
        //认证商家
        [self.tableHeaderView.idenLabel setTitle:LocalizationKey(@"Certifiedmerchant") forState:UIControlStateNormal];
    }
    self.tableHeaderView.nameLabel.text = [YLUserInfo shareUserInfo].username;
    self.tableHeaderView.totalAssetNameLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"totalAssets" value:nil table:@"English"];

}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)walletManageArr{
    if (!_walletManageArr) {
        _walletManageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _walletManageArr;
}

@end
