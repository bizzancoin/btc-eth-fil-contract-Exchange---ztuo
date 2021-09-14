//
//  MentionMoneyViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MentionMoneyViewController.h"
#import "MineNetManager.h"
#import "MentionCoinInfoModel.h"
#import "AddMentionCoinAddressViewController.h"
#import "UITextView+Placeholder.h"
#import "HWTFCursorView.h"

@interface MentionMoneyViewController ()<UITextFieldDelegate,AddMentionCoinAddressViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *availableCoinNum; //可用货币数量
@property (weak, nonatomic) IBOutlet UILabel *availableCoinType;//可用货币类型
@property (weak, nonatomic) IBOutlet UITextView *mentionMoneyAddress;//提币地址
@property (weak, nonatomic) IBOutlet UIButton *QrCodeButton;//二维码按钮
@property (weak, nonatomic) IBOutlet UITextField *numTextField;//数量中的货币数
@property (weak, nonatomic) IBOutlet UILabel *numCoinType;//数量中的货币类型
@property (weak, nonatomic) IBOutlet UIButton *allButton;//全部按钮
@property (weak, nonatomic) IBOutlet UITextField *poundageNum;//手续费
@property (weak, nonatomic) IBOutlet UITextField *accountNum;//到账数量
@property (weak, nonatomic) IBOutlet UILabel *accountNumCoinType;//到账数量货币的类型
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;//资金密码
@property (weak, nonatomic) IBOutlet UITextField *mobilecodeTF;//手机验证码
@property(nonatomic,strong)NSMutableArray *mentionCoinArr;
@property(nonatomic,strong)MentionCoinInfoModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *getcodeButton;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *mentionCoinAdddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *mentionButton;
@property (weak, nonatomic) IBOutlet UILabel *mobilecodelabel;
@property (nonatomic, assign) BOOL verifyGoogle;//是否需要谷歌验证 默认NO
@property (nonatomic, copy) NSString *code;
@end

@implementation MentionMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"unit -- %@",self.unit);
    self.code = @"";
    self.title = [NSString stringWithFormat:@"%@",[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoney" value:nil table:@"English"]];
    self.availableCoinType.text = self.unit;
    self.accountNumCoinType.text = self.unit;
    self.numCoinType.text = self.unit;
    self.mentionMoneyAddress.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputAddAdress" value:nil table:@"English"];
    self.numTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyPassword.secureTextEntry = YES;
    [self mentionCoinInfo];
    self.viewHeight.constant = 70 * kWindowWHOne;
    self.availableLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"availableCoin" value:nil table:@"English"];
    self.mentionCoinAdddressLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"mentionMoneyAddress" value:nil table:@"English"];
    self.amountLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"amount" value:nil table:@"English"];
    self.feeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"poundage" value:nil table:@"English"];
    self.amountNumLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"mentionMoneyAmount" value:nil table:@"English"];
    self.moneyPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"moneyPassword" value:nil table:@"English"];
    [self.mentionButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoney" value:nil table:@"English"] forState:UIControlStateNormal];
     [self.allButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"total" value:nil table:@"English"] forState:UIControlStateNormal];
//    [self.QrCodeButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"addAddress" value:nil table:@"English"] forState:UIControlStateNormal];
    self.accountNum.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputMentionMonneyAmount" value:nil table:@"English"];
    self.moneyPassword.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputMoneyPassword" value:nil table:@"English"];
    
    [_numTextField setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_moneyPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_mobilecodeTF setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_poundageNum setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_accountNum setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    
    [self getGoogle];
}
//MARK:--整理数据
-(void)arrageData{
    for (MentionCoinInfoModel *mentionModel in self.mentionCoinArr) {
        NSLog(@"--%@",mentionModel.unit);
        if ([mentionModel.unit isEqualToString:self.unit]) {
            self.model = mentionModel;
            self.availableCoinNum.text = self.model.balance;

            self.numTextField.placeholder = [NSString stringWithFormat:@"%@<=%@",[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoneyAmount" value:nil table:@"English"],[ToolUtil formartScientificNotationWithString:self.model.balance]];

            if ([self.model.minTxFee isEqualToString:self.model.maxTxFee]) {
                self.poundageNum.text = self.model.minTxFee;
                self.poundageNum.enabled = NO;
            }else{
                self.poundageNum.placeholder = [NSString stringWithFormat:@"%@%@-%@%@",[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoneyTip1" value:nil table:@"English"],[ToolUtil formartScientificNotationWithString:self.model.minTxFee],[ToolUtil formartScientificNotationWithString:self.model.maxTxFee],[[ChangeLanguage bundle] localizedStringForKey:@"poundage" value:nil table:@"English"]];
            }
            self.numTextField.delegate = self;
            self.poundageNum.delegate = self;
        }
    }
}
//MARK:--获取提币信息
-(void)mentionCoinInfo{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取提币信息 ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //[self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.mentionCoinArr addObjectsFromArray:dataArr];
                
                [self arrageData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (NSMutableArray *)mentionCoinArr {
    if (!_mentionCoinArr) {
        _mentionCoinArr = [NSMutableArray array];
    }
    return _mentionCoinArr;
}
/*
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.numTextField == textField) {
        //提币数量
        if (![textField.text isEqualToString:@""]){
            if (![self.poundageNum.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }else if (self.poundageNum == textField){
        if (![textField.text isEqualToString:@""]){
            if (![self.numTextField.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
           self.accountNum.text = @"";
        }
    }
}
 */

- (IBAction)changeTF:(UITextField *)sender {
    if (self.numTextField == sender) {
        //提币数量
        if (![sender.text isEqualToString:@""]){
            if (![self.poundageNum.text isEqualToString:@""]){
                NSDecimalNumber *selNum = [[NSDecimalNumber alloc] initWithString:self.numTextField.text];
                NSDecimalNumber *poundNum = [[NSDecimalNumber alloc] initWithString:self.poundageNum.text];
                
                NSDecimalNumber *selValue = [selNum decimalNumberBySubtracting:poundNum];
                NSLog(@"selValue --- %@",selValue);
                self.accountNum.text = [NSString stringWithFormat:@"%.5f",[selValue doubleValue] < 0 ? 0 : [selValue doubleValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }else if (self.poundageNum == sender){
        if (![sender.text isEqualToString:@""]){
            if (![self.numTextField.text isEqualToString:@""]){

                
                NSDecimalNumber *selNum = [[NSDecimalNumber alloc] initWithString:self.numTextField.text];
                NSDecimalNumber *poundNum = [[NSDecimalNumber alloc] initWithString:self.poundageNum.text];
                
                NSDecimalNumber *selValue = [selNum decimalNumberBySubtracting:poundNum];
                NSLog(@"selValue --- %@",selValue);
                self.accountNum.text = [NSString stringWithFormat:@"%.5f",[selValue doubleValue] < 0 ? 0 : [selValue doubleValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }
}


//MARK:--按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1){
        AddMentionCoinAddressViewController *addressVC = [[AddMentionCoinAddressViewController alloc] init];
        addressVC.delegate = self;
        addressVC.addressInfoArr = self.model.addresses;
        [[AppDelegate sharedAppDelegate] pushViewController:addressVC];

    }else if (sender.tag == 2){
        if (!self.poundageNum.text.length||!self.model.balance) {
            return;
        }
        //点击全部按钮
        self.numTextField.text = self.model.balance;

        NSDecimalNumber *selNum = [[NSDecimalNumber alloc] initWithString:self.numTextField.text];
        NSDecimalNumber *poundNum = [[NSDecimalNumber alloc] initWithString:self.poundageNum.text];

        NSDecimalNumber *selValue = [selNum decimalNumberBySubtracting:poundNum];
        NSLog(@"selValue --- %@",selValue);
        self.accountNum.text = [NSString stringWithFormat:@"%.5f",[selValue doubleValue] < 0 ? 0 : [selValue doubleValue]];
    }else if (sender.tag == 3){
        //点击提币
        if (self.verifyGoogle) {
            [self showGoogleVerifyView];
        }else{
            [self submitInfo];
        }
    }
}

//获取手机验证码
- (IBAction)getmobilecodeaction:(id)sender {
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"hardLoading" value:nil table:@"English"]];
    [MineNetManager resetwithdrawCodeForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"getMessageCodeTip" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.getcodeButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"getVerifyCode" value:nil table:@"English"] forState:UIControlStateNormal];
                            self.getcodeButton.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.getcodeButton setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.getcodeButton.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
    
    
}
//MARK:--添加地址的回调方法
-(void)AddAdressString:(NSString *)addAdressString{
    self.mentionMoneyAddress.text = addAdressString;
}
//MARK:--提币点击事件
-(void)submitInfo{
    if ([self.mentionMoneyAddress.text isEqualToString:@""]) {
         [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputMentionAddress" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.numTextField.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputMentionAmount" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.numTextField.text floatValue] > [self.model.balance floatValue]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"mentionMoneyTip3" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.poundageNum.text isEqualToString:@""]){
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputFee" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]){
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputMoneyPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.mobilecodeTF.text isEqualToString:@""]){
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputCode" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSString *remark = @"";
    for (AddressInfo *address in self.model.addresses) {
        if ([self.mentionMoneyAddress.text isEqualToString:address.address]) {
            remark = address.remark;
        }
    }
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager mentionCoinApplyForUnit:self.model.unit withAddress:self.mentionMoneyAddress.text withAmount:self.numTextField.text withFee:self.poundageNum.text withRemark:remark withJyPassword:self.moneyPassword.text mobilecode:self.mobilecodeTF.text googleCode:self.code CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[AppDelegate sharedAppDelegate] popViewController];
                });
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

- (void)showGoogleVerifyView{
    UIView *contrainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW - 40, 150)];
    contrainer.backgroundColor = [UIColor whiteColor];
    contrainer.layer.cornerRadius = 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, contrainer.frame.size.width - 20, 20)];
    label.text = LocalizationKey(@"enterGoogleCode");
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [contrainer addSubview:label];
    __weak typeof(self)weakself = self;
    HWTFCursorView *code4View = [[HWTFCursorView alloc] initWithCount:6 margin:20];
    code4View.frame = CGRectMake(0, 0, contrainer.frame.size.width - 40, 50);
    code4View.center = contrainer.center;
    code4View.backgroundColor = mainColor;
    code4View.block = ^(NSString * _Nonnull code) {
        [GKCover hideCover];
        weakself.code = code;
        [weakself submitInfo];
    };
    [contrainer addSubview:code4View];
    
    [GKCover coverFrom:[UIApplication sharedApplication].keyWindow contentView:contrainer style:GKCoverStyleTransparent showStyle:GKCoverShowStyleCenter showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:YES showBlock:^{
        
    } hideBlock:^{
        
    }];
}

#pragma mark - 判断用户是否打开谷歌验证
- (void)getGoogle{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/get/user"];
    NSDictionary *param = @{@"mobile":[YLUserInfo shareUserInfo].mobile};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"判断用户是否打开谷歌验证 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
            weakself.verifyGoogle = NO;
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] integerValue] == 1) {
                    weakself.verifyGoogle = YES;
                }else{
                    weakself.verifyGoogle = NO;
                }
            }else{
                weakself.verifyGoogle = NO;
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

@end
