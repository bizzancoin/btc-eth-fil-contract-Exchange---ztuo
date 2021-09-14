//
//  MoneyPasswordViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MoneyPasswordViewController.h"
#import "MineNetManager.h"
#import "ForgetMoneyPassViewController.h"
#import "HWTFCursorView.h"
@interface MoneyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示语设置
@property (weak, nonatomic) IBOutlet UILabel *loginOrOldTitle;//旧密码或登录标题
@property (weak, nonatomic) IBOutlet UITextField *loginOrOldPassword;//旧密码或登录密码
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;//新密码
@property (weak, nonatomic) IBOutlet UITextField *certainPassword;//确认密码
@property (weak, nonatomic) IBOutlet UITextField *code;//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeButton;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIView *codeView;//验证码视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeight;//验证码视图的高度
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetBtnWidth;//忘记密码的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldPassOrLoginHeight;
@property (weak, nonatomic) IBOutlet UIView *oldPaddOrLoginView;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMoneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainMoneyPasswordLabel;
@property (nonatomic, assign) BOOL verifyGoogle;//是否需要谷歌验证 默认NO
@property (nonatomic, copy) NSString *googleCode;
@end

@implementation MoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
    [self setRightItem];
    self.loginOrOldPassword.secureTextEntry = YES;
    self.moneyPassword.secureTextEntry = YES;
    self.certainPassword.secureTextEntry = YES;
    self.loginOrOldTitle.font =  self.codeLabel.font = self.latestMoneyPasswordLabel.font = self.certainMoneyPasswordLabel.font = [UIFont systemFontOfSize:15 * kWindowWHOne];
    self.tipLabel.font =  self.loginOrOldPassword.font = self.moneyPassword.font = self.certainPassword.font
    = self.code.font = [UIFont systemFontOfSize:15 * kWindowWHOne];
    [self.codeButton setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];
    self.codeLabel.text = LocalizationKey(@"verifyCode");
    self.code.placeholder = LocalizationKey(@"inputCode");
    [self.codeButton setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];
    if (self.setStatus == 1) {
        //设置过，可以修改
        
        self.title = [[ChangeLanguage bundle] localizedStringForKey:@"changeMoneyPassword" value:nil table:@"English"];
        self.tipLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"changeMoneyPasswordTip" value:nil table:@"English"];
        self.oldPassOrLoginHeight.constant = 50;
        self.oldPaddOrLoginView.hidden = NO;
        self.loginOrOldTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"oldMoneyPassword" value:nil table:@"English"];
        self.loginOrOldPassword.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputOldMoneyPassword" value:nil table:@"English"];
        self.forgetButton.hidden = NO;
        self.forgetBtnWidth.constant = 30;
    }else{
        self.title = LocalizationKey(@"setMoneyPassword");
        self.tipLabel.text = LocalizationKey(@"setMoneyPasswordTip");
        self.oldPassOrLoginHeight.constant = 0;
        self.oldPaddOrLoginView.hidden = YES;
        self.codeView.hidden = YES;
        self.codeViewHeight.constant = 0;
        self.forgetButton.hidden = YES;
        self.forgetBtnWidth.constant = 0;
    }
    self.latestMoneyPasswordLabel.text =LocalizationKey(@"newMoneyPassword");
    self.certainMoneyPasswordLabel.text =LocalizationKey(@"certainMoneyPassword");
    self.moneyPassword.placeholder = LocalizationKey(@"inputNewMoneyPassword");
    self.certainPassword.placeholder = LocalizationKey(@"inputCertainMoneyPassword");
    [self.forgetButton setTitle:LocalizationKey(@"forgetPassword") forState:UIControlStateNormal];
    
    [_moneyPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_certainPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_loginOrOldPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_code setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    // Do any additional setup after loading the view from its nib.
    self.googleCode = @"";
    [self getGoogle];
}

- (void)setRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)RighttouchEvent{
    if (self.setStatus == 1) {
        //设置过，可以修改
        if (self.verifyGoogle) {
            [self showGoogleVerifyView];
        }else{
            [self changeMoneyPassword];
        }
    }else{
        [self setMoneyPassword];
    }
}

//MARK:--忘记密码的点击事件
- (IBAction)forgetBtnClick:(id)sender {
    ForgetMoneyPassViewController *forgetVC = [[ForgetMoneyPassViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:forgetVC];
}
//MARK:--获取验证码的点击事件
- (IBAction)codeBtnClick:(UIButton *)sender {
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
    [MineNetManager updateMoneyPasswordCodeForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view makeToast:LocalizationKey(@"getMessageCodeTip") duration:1.5 position:CSToastPositionCenter];
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeButton setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];
                            self.codeButton.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeButton setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.codeButton.userInteractionEnabled = NO;
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

//MARK:--修改资金密码的接口
-(void)changeMoneyPassword{
    if ([NSString stringIsNull:self.code.text]) {
        [self.view makeToast:LocalizationKey(@"inputCode") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.loginOrOldPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputOldMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputNewMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.certainPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputCertainMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (![self.certainPassword.text isEqualToString:self.moneyPassword.text]) {
        [self.view makeToast:LocalizationKey(@"checkPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    [MineNetManager resetMoneyPasswordForOldPassword:self.loginOrOldPassword.text withLatestPassword:self.moneyPassword.text code:self.code.text googleCode:self.googleCode CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [[AppDelegate sharedAppDelegate] popViewController];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//MARK:--设置资金密码的接口
-(void)setMoneyPassword{
    
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputNewMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.certainPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputCertainMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (![self.certainPassword.text isEqualToString:self.moneyPassword.text]) {
        [self.view makeToast:LocalizationKey(@"checkPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    [MineNetManager moneyPasswordForJyPassword:self.moneyPassword.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
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
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
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
        weakself.googleCode = code;
        [weakself changeMoneyPassword];
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
