//
//  BorrowMoneyViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BorrowMoneyViewController.h"
#import "BorrowMoneyRecordViewController.h"
@interface BorrowMoneyViewController ()
{
    NSInteger _currentTag;
}
@property (weak, nonatomic) IBOutlet UIButton *coinSymbolBtn;
@property (weak, nonatomic) IBOutlet UIButton *baseSymbolBtn;
@property (weak, nonatomic) IBOutlet UILabel *borrowedLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *haveAmountLabel;
@property (nonatomic, strong) LeverAccountModel *account;

@end

@implementation BorrowMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentTag = 0;
    self.title = LocalizationKey(@"BorrowMoney");
    [self rightBarItemWithTitle:LocalizationKey(@"BorrowRecords")];
    [self getLever];
}

- (void)RighttouchEvent{
    BorrowMoneyRecordViewController *record = [[BorrowMoneyRecordViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:record];
}

- (void)initData{
    NSArray *list = self.account.leverWalletList;
    NSArray *symbols = [self.symbol componentsSeparatedByString:@"/"];
    LeverWalletModel *base;
    LeverWalletModel *change;
    if (symbols.count == 2) {
        NSString *baseSymbol = [symbols lastObject];
        NSString *changeSymbol = [symbols firstObject];
        for (LeverWalletModel *wallet in list) {
            if ([baseSymbol isEqualToString:wallet.coin.unit]) {
                base = wallet;
            }
            if ([changeSymbol isEqualToString:wallet.coin.unit]) {
                change = wallet;
            }
        }
    }else{
        base = [list lastObject];
        change = [list firstObject];
    }

    self.doneBtn.layer.cornerRadius = 3;
    self.doneBtn.layer.masksToBounds = YES;
    [self.doneBtn setTitle:LocalizationKey(@"BorrowMoney") forState:UIControlStateNormal];
    
    [self.coinSymbolBtn setTitle:change.coin.unit forState:UIControlStateNormal];
    [self.baseSymbolBtn setTitle:base.coin.unit forState:UIControlStateNormal];
    
    self.borrowedLabel.text = LocalizationKey(@"Borrowed");
    self.borrowedValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.account.coinLoanCount, change.coin.unit];
    //最大额度
//    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *can = [[NSDecimalNumber alloc] initWithString:self.account.coinCanLoan];
    NSDecimalNumber *loan = [[NSDecimalNumber alloc] initWithString:self.account.coinLoanCount];
    self.maxAmountLabel.text = LocalizationKey(@"maxlimit");
    self.maxAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",[[can decimalNumberByAdding:loan] stringValue], change.coin.unit];
    self.rateLabel.text = LocalizationKey(@"moneyRate");
    self.rateValueLabel.text = [NSString stringWithFormat:@"%@",change.LeverCoin.interestRate];
    
    self.amountLabel.text = LocalizationKey(@"amount");
    
    self.amountTF.placeholder = LocalizationKey(@"inputTransferNumber");
    [self.allBtn setTitle:LocalizationKey(@"all") forState:UIControlStateNormal];

    self.coinLabel.text = change.coin.unit;
    
    self.haveAmountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"Mayborrow"), self.account.coinCanLoan, change.coin.unit];
}

- (IBAction)coinSymbolAction:(UIButton *)sender {
    [self.coinSymbolBtn setBackgroundColor:NavColor];
//    [self.coinSymbolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.baseSymbolBtn setBackgroundColor:RGBOF(0x9CCEFF)];
//    [self.baseSymbolBtn setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
    [self setDataWithTag:sender.tag];
}
- (IBAction)baseSymbolAction:(UIButton *)sender {
    [self.baseSymbolBtn setBackgroundColor:NavColor];
//    [self.baseSymbolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.coinSymbolBtn setBackgroundColor:RGBOF(0x9CCEFF)];
//    [self.coinSymbolBtn setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
    [self setDataWithTag:sender.tag];
}

- (void)setDataWithTag:(NSInteger)tag{
    _currentTag = tag;
    NSArray *list = self.account.leverWalletList;
    NSArray *symbols = [self.symbol componentsSeparatedByString:@"/"];
    LeverWalletModel *base;
    LeverWalletModel *change;
    if (symbols.count == 2) {
        NSString *baseSymbol = [symbols lastObject];
        NSString *changeSymbol = [symbols firstObject];
        for (LeverWalletModel *wallet in list) {
            if ([baseSymbol isEqualToString:wallet.coin.unit]) {
                base = wallet;
            }
            if ([changeSymbol isEqualToString:wallet.coin.unit]) {
                change = wallet;
            }
        }
    }else{
        base = [list lastObject];
        change = [list firstObject];
    }
    
    if (tag == 0) {
        self.borrowedValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.account.coinLoanCount, change.coin.unit];
        if (!self.account.coinCanLoan||!self.account.coinLoanCount) {
            return;
        }
        //最大额度
        NSDecimalNumber *can = [[NSDecimalNumber alloc] initWithString:self.account.coinCanLoan];
        NSDecimalNumber *loan = [[NSDecimalNumber alloc] initWithString:self.account.coinLoanCount];
        self.maxAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",[[can decimalNumberByAdding:loan] stringValue], change.coin.unit];
        self.rateValueLabel.text = change.LeverCoin.interestRate;
        self.coinLabel.text = change.coin.unit;
        self.haveAmountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"Mayborrow"), self.account.coinCanLoan, change.coin.unit];
    }else{
        self.borrowedValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.account.baseLoanCount, base.coin.unit];
        if (!self.account.baseCanLoan||!self.account.baseLoanCount) {
            return;
        }
        //最大额度
        NSDecimalNumber *can = [[NSDecimalNumber alloc] initWithString:self.account.baseCanLoan];
        NSDecimalNumber *loan = [[NSDecimalNumber alloc] initWithString:self.account.baseLoanCount];
        self.maxAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",[[can decimalNumberByAdding:loan] stringValue], base.coin.unit];
        self.rateValueLabel.text = change.LeverCoin.interestRate;
        self.coinLabel.text = base.coin.unit;
        self.haveAmountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"Mayborrow"), self.account.baseCanLoan, base.coin.unit];
    }
}

- (IBAction)allAction:(id)sender {
    if (_currentTag == 0) {
        self.amountTF.text = self.account.coinCanLoan;
    }else{
        self.amountTF.text = self.account.baseCanLoan;
    }
}

- (IBAction)doneAction:(id)sender {
    if (self.amountTF.text.length == 0) {
        return;
    }
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSArray *list = self.account.leverWalletList;
    LeverWalletModel *base = [list firstObject];
    LeverWalletModel *change = [list lastObject];
    NSString *coinUnit = @"";
    if (_currentTag == 0) {
        coinUnit = change.coin.unit;
    }else{
        coinUnit = base.coin.unit;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/loan/loan"];
    NSDictionary *param = @{@"symbol":self.account.symbol, @"coinUnit":coinUnit, @"amount":self.amountTF.text};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"借币 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:responseResult[MESSAGE] duration:1.5 position:CSToastPositionCenter];

            }
        }
    }];
}

#pragma mark - 获取杠杆账户
- (void)getLever{
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/list"];
    NSDictionary *param = @{@"symbol":self.symbol};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取杠杆账户 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    NSArray *dataArr = [LeverAccountModel mj_objectArrayWithKeyValuesArray:data];
                    if (dataArr.count == 1) {
                        self.account = [dataArr firstObject];
                        [self initData];
                    }
                }
            }else{
                
            }
        }
    }];
}

@end
