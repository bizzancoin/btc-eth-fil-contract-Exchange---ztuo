//
//  WalletManageViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "WalletManageViewController.h"
#import "WalletManageTableViewCell.h"
#import "WalletManageDetailViewController.h"
#import "MentionMoneyViewController.h"
#import "ChargeMoneyViewController.h"
#import "MineNetManager.h"
#import "WalletManageModel.h"
#import "WalletManageTableHeadView.h"
#import "UIView+LLXAlertPop.h"
#import "YBPopupMenu.h"
#import "WalletTitleTableViewCell.h"
#import "WalletButTableViewCell.h"
#import "CurrencyrecordViewController.h"
#import "ChargerecordViewController.h"
#import "IntegralRecordViewController.h"
#import "AccountSettingInfoModel.h"

@interface WalletManageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,WalletManageTableViewCellDelegate,YBPopupMenuDelegate>{
    BOOL _refreshFlag;
    UIView *_tableHeadView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *totalAssets; //总资产
@property (weak, nonatomic) IBOutlet UILabel *asset1; //资产 橙色数字
@property (weak, nonatomic) IBOutlet UILabel *asset2; //资产 换算数字
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;  //眼睛按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;//底部的高度区分iPhoneX和普通机型
@property(nonatomic,strong) WalletManageTableHeadView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *identifyBtn;

@property(nonatomic,strong)NSMutableArray *walletManageArr;
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,strong)NSMutableArray *searchArr;
@property(nonatomic,assign)NSInteger selectIndex;//0未隐藏 1 隐藏
@property(nonatomic,assign)NSInteger searchIndex;//0未搜索 1 搜索
@property(nonatomic,assign)NSInteger flagIndex;//1搜索 2隐藏 0没有
@property(nonatomic,strong)NSIndexPath *clickIndexPath;
@property(nonatomic,strong)WalletManageModel *clickModel;

@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;

@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [[ChangeLanguage bundle] localizedStringForKey:@"Myassets" value:nil table:@"English"];
    [self accountSettingData];
    if (!self.assetUSD ) {
        self.asset1.text = @"0.000000";
        self.assetUSD = @"0.000000";
    }else{
      self.asset1.text = self.assetUSD;
    }
    if (!self.assetCNY) {
        self.asset2.text = @"≈0.00CNY";
        self.assetCNY = @"≈0.00CNY";
    }else{
      self.asset2.text = self.assetCNY;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
//    self.topBgViewHeight.constant = SafeAreaTopHeight+10+(kWindowW-40)*2/5 -40;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    self.tableview.estimatedRowHeight = 44;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.identifyBtn.layer.cornerRadius = self.identifyBtn.frame.size.height / 2;
    self.identifyBtn.layer.masksToBounds = YES;
    self.identifyBtn.layer.borderWidth = 1;
    self.identifyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameLabel.text = [YLUserInfo shareUserInfo].username;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"WalletManageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletManageTableViewCell class])];
    
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 40)];
    [self.backView addSubview:_tableHeadView];
    self.headerView=[[[WalletManageTableHeadView alloc]init] instancetableHeardViewWithFrame:_tableHeadView.frame];
    self.headerView.searchBar.delegate = self;
    [self.headerView.selectButton addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITextField * searchField = [self.headerView.searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:13];
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    self.headerView.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    [_tableHeadView addSubview:self.headerView];
    [self doneForSearchBar];
    
    self.totalAssets.text = [[ChangeLanguage bundle] localizedStringForKey:@"totalAssets" value:nil table:@"English"];
    [self rightBarItemWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"detail" value:nil table:@"English"]];
    [self getData];
    self.selectArr = [[NSMutableArray alloc] init];
    self.searchArr = [[NSMutableArray alloc] init];
    self.selectIndex = 0;
    self.searchIndex = 0;
    self.flagIndex = 0;
    
}

//用户等级
- (IBAction)identifyAction:(UIButton *)sender {
    
}

//MARK:--给searchBar的键盘加上完成按钮
-(void)doneForSearchBar{
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38.0f)];
    toobar.backgroundColor = mainColor;
    toobar.translucent = YES;
    toobar.barStyle = UIBarStyleDefault;
    UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizationKey(@"done") style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:255/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    [doneBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [doneBarButtonItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [toobar setItems:@[spaceBarButtonItem,doneBarButtonItem]];
    self.headerView.searchBar.inputAccessoryView = toobar;
}
- (void)resignKeyboard:(id)sender{
    [self.headerView.searchBar resignFirstResponder];
}
//MARK:--隐藏为0的币种
-(void)selectBtnClick:(UIButton *)button{
     button.selected = !button.selected;
    if (button.selected) {
        self.flagIndex = 2;
        _selectIndex = 1;
        //被选择
        [self.headerView.selectButton setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateNormal];
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
        [self.headerView.selectButton setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
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
    [_tableview reloadData];
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

     [_tableview reloadData];

}



//键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
//MARK:---获取我的钱包所有数据
-(void)getData{
    [self.walletManageArr removeAllObjects];
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"请求总资产的接口 --- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.walletManageArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
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
                
                [self.tableview reloadData];
                [self initHeaderData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
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

- (void)initHeaderData{
    if (!self.assetUSD ) {
        self.asset1.text = @"0.000000";
        self.assetUSD = @"0.000000";
    }else{
        self.asset1.text = !self.eyeButton.selected?@"********":self.assetUSD;
    }
    if (!self.assetCNY) {
        self.asset2.text = @"≈0.00CNY";
        self.assetCNY = @"≈0.00CNY";
    }else{
        self.asset2.text = !self.eyeButton.selected?@"********":self.assetCNY;
    }
    if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"0"]) {
        //普通用户
        [self.identifyBtn setTitle:LocalizationKey(@"Ordinaryusers") forState:UIControlStateNormal];
    }else if ([[YLUserInfo shareUserInfo].memberLevel isEqualToString:@"1"]){
        //实名用户
        [self.identifyBtn setTitle:LocalizationKey(@"Realnameuser") forState:UIControlStateNormal];
    }else{
        //认证商家
        [self.identifyBtn setTitle:LocalizationKey(@"Certifiedmerchant") forState:UIControlStateNormal];
    }
}


- (NSMutableArray *)walletManageArr {
    if (!_walletManageArr) {
        _walletManageArr = [NSMutableArray array];
    }
    return _walletManageArr;
}
//MARK:--明细的点击事件
-(void)RighttouchEvent{
    NSArray *namearray = @[LocalizationKey(@"Currencyrecord"),LocalizationKey(@"Chargerecord"),LocalizationKey(@"Assetflow"),LocalizationKey(@"Integralrecord")];
    
    [YBPopupMenu showAtPoint:CGPointMake(kWindowW - 32, NEW_NavHeight - 15) titles:namearray icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.arrowDirection = YBPopupMenuArrowDirectionNone;
        popupMenu.delegate = self;
        popupMenu.textColor = RGBOF(0x333333);
        popupMenu.backColor = [UIColor whiteColor];

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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.availableNum.text = [ToolUtil judgeStringForDecimalPlaces:model.balance];
        cell.freezeNum.text = [ToolUtil judgeStringForDecimalPlaces:model.frozenBalance];
        cell.lockingNum.text = model.toReleased ? [ToolUtil judgeStringForDecimalPlaces:model.toReleased] : @"0";
        cell.delegate = self;
        cell.index = indexPath;
        cell.model = model;
    cell.availableLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"availableCoin" value:nil table:@"English"];
    cell.freezeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"freezeCoin" value:nil table:@"English"];
    cell.lockingLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Assetstoreleased" value:nil table:@"English"];
    
//        if ([model.clickIndex isEqualToString:@"1"]) {
//            [cell.clickButton setImage:[UIImage imageNamed:@"downMoreImage"] forState:UIControlStateNormal];
//        }else{
//            [cell.clickButton setImage:[UIImage imageNamed:@"leftMoreImage"] forState:UIControlStateNormal];
//        }
        return cell;
    
    
   
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    [self buttonIndex:indexPath withModel:model];
    
}


-(void)buttonIndex:(NSIndexPath *)indexPath withModel:(WalletManageModel *)model{
    // canRecharge 充币
    if (![model.coin.canRecharge isEqualToString:@"1"] && ![model.coin.canWithdraw isEqualToString:@"1"]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"notRaiseMoneyTip" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        model.clickIndex = @"0";
    }else{
        //可以充币或提币
        [self coinAlterView:indexPath withModel:model];
    }
    [self.tableview reloadData];

}
//MARK:-- 提币充币
-(void)coinAlterView:(NSIndexPath*)indexPath withModel:(WalletManageModel *)model{
    self.clickIndexPath = indexPath;
    self.clickModel = model;
    NSArray *arrayTitle;
    NSArray *arrayColor;
    if ([model.coin.canRecharge isEqualToString:@"1"] &&[model.coin.canWithdraw isEqualToString:@"1"]) {
        //可以充币，提币
        arrayTitle = @[[[ChangeLanguage bundle] localizedStringForKey:@"chargeMoney" value:nil table:@"English"] ,[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoney" value:nil table:@"English"] ];
        arrayColor = @[GreenColor,RedColor];
    }else if ([model.coin.canRecharge isEqualToString:@"1"] && ![model.coin.canWithdraw isEqualToString:@"1"]){
        arrayTitle = @[[[ChangeLanguage bundle] localizedStringForKey:@"chargeMoney" value:nil table:@"English"]];
        arrayColor = @[GreenColor];
    }else{
        arrayTitle = @[[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoney" value:nil table:@"English"]];
        arrayColor = @[GreenColor];
    }
    [self.view createAlertViewTitleArray:arrayTitle textColor:arrayColor font:[UIFont systemFontOfSize:16] type:1  actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        if ([button.currentTitle isEqualToString:[[ChangeLanguage bundle] localizedStringForKey:@"chargeMoney" value:nil table:@"English"]]) {
            //充币
            [self chargeMoneyBtnClick];
           
        }else if ([button.currentTitle isEqualToString:[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoney" value:nil table:@"English"]]){
            //提币
            if (![self.accountInfo.kycStatus isEqualToString:@"4"]) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"Pleaseauthenticatethevideofirst" duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            [self mentionMoneyBtnClick];
        }else if ([button.currentTitle isEqualToString:[[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"]]){
            //取消
            [self cancelBtnClick];
        }
    }];
}
-(void)cancelBtnClick{
    self.clickModel.clickIndex = @"0";
    [self.tableview reloadData];
}
//MARK:--充币点击事件
-(void)chargeMoneyBtnClick{
    _refreshFlag = YES;
    ChargeMoneyViewController *chargeVC = [[ChargeMoneyViewController alloc] init];
    chargeVC.unit = self.clickModel.coin.unit;
    chargeVC.address = self.clickModel.address;
    [[AppDelegate sharedAppDelegate] pushViewController:chargeVC];
    self.clickModel.clickIndex = @"0";
    [self.tableview reloadData];
}
//MARK:--提币点击事件
-(void)mentionMoneyBtnClick{
    MentionMoneyViewController *mentionVC = [[MentionMoneyViewController alloc] init];
    _refreshFlag = YES;
    mentionVC.unit = self.clickModel.coin.unit;
    [[AppDelegate sharedAppDelegate] pushViewController:mentionVC];
    self.clickModel.clickIndex = @"0";
    [self.tableview reloadData];

}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
////    WalletManageModel *model = _walletManageArr[indexPath.row];
////    CGFloat height=  [self getLabelHeightWithText:model.balance WithotherText:model.frozenBalance width:(kWindowW-170)/2 font:17];
////    return height+70;
//    return 105 * kWindowWHOne;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WalletManageModel *model = _walletManageArr[indexPath.row];
//    CGFloat height=  [self getLabelHeightWithText:model.balance WithotherText:model.frozenBalance width:(kWindowW-170)/2 font:17];
//    return/var/folders/r_/qt7ndt290sg35j5pl6zflc180000gp/T/AppIconMaker/appicon.png height+70;
//    return UITableViewAutomaticDimension;
    
    return 105 * kWindowWHOne;

}
//MARK:--眼睛按钮的点击事件
- (IBAction)eyeBtnClick:(UIButton *)sender {

    if (sender.selected) {
        [_eyeButton setBackgroundImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
        self.asset1.text = @"********";
        self.asset2.text = @"********";
        [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:YES];
    }else{
        [_eyeButton setBackgroundImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateNormal];
        if(![YLUserInfo isLogIn]){
            //没登录不做处理
            self.asset1.text = @"0.000000";
            self.asset2.text = @"≈0.000000CNY";

        }else{
            self.asset1.text = self.assetUSD;
            self.asset2.text = self.assetCNY;
        }
        [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:NO];
    }
    sender.selected = !sender.selected;

}


//MARK:--点击隐藏展开总资产
-(void)eyeButtonArrageData{
    if (!self.eyeButton.selected) {
        [self.eyeButton setBackgroundImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
        self.asset1.text = @"********";
        self.asset2.text = @"********";
    }else{
        [self.eyeButton setBackgroundImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateNormal];
        if(![YLUserInfo isLogIn]){
            //没登录不做处理
            self.asset1.text = @"0.000000";
            self.asset2.text = @"≈0.00CNY";
        }else{
            self.asset1.text = self.assetUSD;
            self.asset2.text = self.assetCNY;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        self.eyeButton.selected = NO;
    }else{
        self.eyeButton.selected = YES;
    }
    [self eyeButtonArrageData];

    if (_refreshFlag) {
         [self getData];
    }
    [self getData];
    self.navigationItem.title = [[ChangeLanguage bundle] localizedStringForKey:@"Myassets" value:nil table:@"English"];
    [self rightBarItemWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"detail" value:nil table:@"English"]];
    [self.tableview reloadData];
    self.headerView.selectBtnLabel.text = LocalizationKey(@"hidden0Currency");
    self.headerView.searchBar.placeholder = LocalizationKey(@"searchAssets");
}


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
-(CGFloat)getLabelHeightWithText:(NSString *)text WithotherText:(NSString *)othertext  width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    CGRect rect1 = [othertext boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    CGFloat lastRect=rect.size.height>=rect1.size.height?rect.size.height:rect1.size.height;
    return lastRect;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
