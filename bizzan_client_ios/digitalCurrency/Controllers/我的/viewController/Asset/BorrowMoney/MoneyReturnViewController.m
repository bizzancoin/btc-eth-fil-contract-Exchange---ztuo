//
//  MoneyReturnViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "MoneyReturnViewController.h"

@interface MoneyReturnViewController ()
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveReturnLabel;
@property (weak, nonatomic) IBOutlet UILabel *boAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *boAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *reAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *haveAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic, strong) LeverAccountModel *accountModel;
@end

@implementation MoneyReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"return");
    // Do any additional setup after loading the view from its nib.
    [self getData];
    [self initData];
}

- (void)initData{
    self.symbolLabel.text = [NSString stringWithFormat:@"%@:%@", LocalizationKey(@"AccountLever"),self.model.LeverCoin.symbol];
    //应还数量 利息加已借数量
    NSDecimalNumber *can = [[NSDecimalNumber alloc] initWithString:self.model.amount];
    NSDecimalNumber *loan = [[NSDecimalNumber alloc] initWithString:self.model.accumulative];
    self.haveReturnLabel.text = [NSString stringWithFormat:@"%@:%@ %@", LocalizationKey(@"shouldbereturned"),[[can decimalNumberByAdding:loan] stringValue], self.model.coin.unit];
    
    self.boAmountLabel.text = LocalizationKey(@"Quantityofloans");
    self.boAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.loanBalance, self.model.coin.unit];
    
    self.rateLabel.text = LocalizationKey(@"Interest");
    self.rateValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.accumulative, self.model.coin.unit];
    
    self.reAmountLabel.text = LocalizationKey(@"returnedQuantity");
    
    self.doneBtn.layer.cornerRadius = 3;
    self.doneBtn.layer.masksToBounds = YES;
    [self.doneBtn setTitle:LocalizationKey(@"return") forState:UIControlStateNormal];
    
    self.coinLabel.text = self.model.coin.unit;
    self.amountTF.placeholder = LocalizationKey(@"inputReturnNumber");
    [self.allBtn setTitle:LocalizationKey(@"all") forState:UIControlStateNormal];
    

}

- (IBAction)doneAction:(UIButton *)sender {
    if (self.amountTF.text.length == 0) {
        return;
    }
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/loan/repayment"];
    NSDictionary *param = @{@"loanRecordId":self.model.ID, @"amount":self.amountTF.text};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"还币 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                [[AppDelegate sharedAppDelegate] popViewController];
            }else{
                [self.view makeToast:responseResult[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                
            }
        }
    }];
}

- (IBAction)allAction:(UIButton *)sender {
    //应还数量 利息加已借数量
    NSDecimalNumber *can = [[NSDecimalNumber alloc] initWithString:self.model.amount];
    NSDecimalNumber *loan = [[NSDecimalNumber alloc] initWithString:self.model.accumulative];
    self.amountTF.text = [[can decimalNumberByAdding:loan] stringValue];
}

-(void)getData{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/list"];
    NSDictionary *param = @{@"symbol":self.model.LeverCoin.symbol};
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
                    if (data.count > 0) {
                        self.accountModel = [LeverAccountModel mj_objectWithKeyValues:[data firstObject]];
                        for (LeverWalletModel *wallet in self.accountModel.leverWalletList) {
                            if ([self.model.coin.unit isEqualToString:wallet.coin.unit]) {
                                self.haveAmountLabel.text = [NSString stringWithFormat:@"%@ %@ %@", LocalizationKey(@"usabel"), wallet.balance, wallet.coin.unit];
                            }
                        }
                    }
                }
            }else{
                [self.view makeToast:responseResult[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

@end
