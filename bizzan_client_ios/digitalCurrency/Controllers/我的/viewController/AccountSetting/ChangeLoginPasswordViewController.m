//
//  ChangeLoginPasswordViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"
#import "ForgetViewController.h"
#import "HWTFCursorView.h"

@interface ChangeLoginPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;//旧登录密码
@property (weak, nonatomic) IBOutlet UITextField *latestPassword;//新登录密码
@property (weak, nonatomic) IBOutlet UITextField *certainPassword;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *oldLoginPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestLoginPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyCodeLabel;


@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@property (nonatomic, assign) BOOL verifyGoogle;//是否需要谷歌验证 默认NO
@property (nonatomic, copy) NSString *googleCode;

@end

@implementation ChangeLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"changeLoginPassword" value:nil table:@"English"];
    NSString *beforeStr = [self.phoneNum substringToIndex:3];
    NSString *backStr = [self.phoneNum substringFromIndex:self.phoneNum.length- 4 ];
    self.tipsLabel.text = [NSString stringWithFormat:@"%@%@",[[ChangeLanguage bundle] localizedStringForKey:@"youBindPhone" value:nil table:@"English"],[NSString stringWithFormat:@"%@****%@",beforeStr,backStr]];
    [self setRightItem];

//    self.oldLoginPasswordLabel.font =  self.latestLoginPasswordLabel.font = self.certainPasswordLabel.font = self.oldLoginPasswordLabel.font = self.verifyCodeLabel.font =  self.verifyButton.titleLabel.font = [UIFont systemFontOfSize: 14 * kWindowWHOne];

    self.oldLoginPasswordLabel.font =  self.latestLoginPasswordLabel.font = self.certainPasswordLabel.font = self.oldLoginPasswordLabel.font = self.verifyCodeLabel.font = [UIFont systemFontOfSize: 15 * kWindowWHOne];

    
    self.oldLoginPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"oldLoginPassword" value:nil table:@"English"];
     self.latestLoginPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"newLoginPassword" value:nil table:@"English"];
     self.certainPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"certainPassword" value:nil table:@"English"];
     self.verifyCodeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"verifyCode" value:nil table:@"English"];
    [self.verifyButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"getVerifyCode" value:nil table:@"English"] forState:UIControlStateNormal];
    self.verificationCode.placeholder =[[ChangeLanguage bundle] localizedStringForKey:@"inputCode" value:nil table:@"English"];
    self.oldPassword.placeholder =[[ChangeLanguage bundle] localizedStringForKey:@"inputOldLoginPassword" value:nil table:@"English"];
    self.latestPassword.placeholder =[[ChangeLanguage bundle] localizedStringForKey:@"inputNewLoginPassword" value:nil table:@"English"];
    self.certainPassword.placeholder =[[ChangeLanguage bundle] localizedStringForKey:@"inputCertainLoginPassword" value:nil table:@"English"];
    //[self rightBarItemWithTitle:@"忘记密码"];
    [_verificationCode setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_oldPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_latestPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_certainPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
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
    if (self.verifyGoogle) {
        [self showGoogleVerifyView];
    }else{
        [self changePassword];
    }
}

- (void)changePassword{
    
    if ([self.oldPassword.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputNewLoginPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.latestPassword.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputNewLoginPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.certainPassword.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputCertainLoginPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (![self.latestPassword.text isEqualToString:self.certainPassword.text]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"checkPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.verificationCode.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputCode" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager resetLoginPasswordForCode:self.verificationCode.text withOldPassword:self.oldPassword.text withLatestPassword:self.latestPassword.text googleCode:self.googleCode CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
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

//MARK:--获取验证码的点击事件
- (IBAction)getVerificationCodeBtnClick:(UIButton *)sender {
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"hardLoading" value:nil table:@"English"]];
    [MineNetManager resetLoginPasswordCodeForCompleteHandle:^(id resPonseObj, int code) {
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
                            [self.verifyButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"getVerifyCode" value:nil table:@"English"] forState:UIControlStateNormal];
                            self.verifyButton.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.verifyButton setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.verifyButton.userInteractionEnabled = NO;
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
        [weakself changePassword];
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
