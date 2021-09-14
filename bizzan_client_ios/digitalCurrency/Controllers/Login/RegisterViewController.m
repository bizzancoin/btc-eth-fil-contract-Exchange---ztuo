//
//  RegisterViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "RegisterViewController.h"
#import "countryViewController.h"
#import "LoginNetManager.h"
#import "ImageBtn.h"
#import "countryModel.h"
#import "PlatformMessageDetailViewController.h"
#import "MineNetManager.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>

#define api_2 [NSString stringWithFormat:@"%@%@",HOST,@"cn/uc/mobile/code"]

@interface RegisterViewController ()<UITextFieldDelegate>
{
     BOOL _isEmail;//邮箱注册
    NSDictionary *_g3Result;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *agressButton;//同意协议按钮
@property (weak, nonatomic) IBOutlet UIButton *AgreementButton;//查看协议
@property (weak, nonatomic) IBOutlet UITextField *ConfirmpasswordTF;//确认密码
@property (weak, nonatomic) IBOutlet UILabel *phonelabel;
@property (weak, nonatomic) IBOutlet UILabel *usernamelabel;
@property (weak, nonatomic) IBOutlet UILabel *verifycodelabel;
@property (weak, nonatomic) IBOutlet UILabel *invitaLabel;
@property (weak, nonatomic) IBOutlet UITextField *invitaTF;

@property (weak, nonatomic) IBOutlet UILabel *passwordlabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmlabel;
@property (weak, nonatomic) IBOutlet UIButton *gotologinbut;
@property (weak, nonatomic) IBOutlet UILabel *haveAccountnumber;

@property (nonatomic,assign)BOOL isAgree;

@property (weak, nonatomic) IBOutlet UIButton *eyebutton1;
@property (weak, nonatomic) IBOutlet UIButton *eyebutton2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyLabelMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyTFHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyTFMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyLineMarginTopConstraint;

@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryViewMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *countryView;

//用户协议
@property (nonatomic,copy)NSString *contentstr;

@property (nonatomic, strong) countryModel *countryModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=LocalizationKey(@"register");
    self.isAgree = NO;
    [self getUserprotocol];
    [self rightBarItemWithTitle:LocalizationKey(@"emailRegister")];
    self.countryTF.delegate = self;
    [_phoneNumberTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_verifyCodeTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_userNameTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_ConfirmpasswordTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_invitaTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_countryTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];

    [_phoneNumberTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_verifyCodeTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_userNameTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_passwordTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_ConfirmpasswordTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_invitaTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_countryTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];


//    UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountry)];
//    [self.boardView addGestureRecognizer:tapRecognizerWeibo];

    self.backViewHeightConstraint.constant = CGRectGetMaxY(self.registerBtn.frame) + 60 > kWindowH - Height_NavBar ? CGRectGetMaxY(self.registerBtn.frame) + 60 : kWindowH - Height_NavBar;
    
    [self.verifyButton setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];

    [self.registerBtn setTitle:LocalizationKey(@"register") forState:UIControlStateNormal];
    self.phoneNumberTF.placeholder = LocalizationKey(@"inputMobile");
    self.verifyCodeTF.placeholder = LocalizationKey(@"inputPhoneCode");
    self.userNameTF.placeholder = LocalizationKey(@"inputUsername");
    self.passwordTF.placeholder = LocalizationKey(@"inputPwd");
    self.ConfirmpasswordTF.placeholder = LocalizationKey(@"PcertainPassword");
    self.invitaTF.placeholder = LocalizationKey(@"Invitationcode");
    self.countryTF.placeholder = LocalizationKey(@"selectCountry");

    [self.agressButton setTitle:LocalizationKey(@"readandagree") forState:UIControlStateNormal];
    [self.AgreementButton setTitle:LocalizationKey(@"Userprotocol") forState:UIControlStateNormal];
    self.usernamelabel.text = LocalizationKey(@"username");
    self.phonelabel.text = LocalizationKey(@"phoneNum");
    self.verifycodelabel.text = LocalizationKey(@"verifyCode");
    self.passwordlabel.text = LocalizationKey(@"pwd");
    self.confirmlabel.text = LocalizationKey(@"certainPassword");
    self.haveAccountnumber.text = LocalizationKey(@"Existingaccounts");
    self.invitaLabel.text = LocalizationKey(@"Invitationcode");
    self.countryLabel.text = LocalizationKey(@"selectCountry");

    [self.gotologinbut setTitle:LocalizationKey(@"Loginimmediately") forState:UIControlStateNormal];
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = kWindowW * 0.7 * 46 / 256 / 2;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.countryTF) {
        [self selectCountry];
        return NO;
    }
    return YES;
}

//立即登录
- (IBAction)LoginImmediatelyaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//阅读并同意
- (IBAction)Agreeaction:(id)sender {
    self.agressButton.selected = !self.agressButton.selected;
}

- (IBAction)openeyeTF1:(id)sender {
    self.eyebutton1.selected = !self.eyebutton1.selected;
    self.passwordTF.secureTextEntry = !self.eyebutton1.selected;
}
- (IBAction)openeyeTF2:(id)sender {
    self.eyebutton2.selected = !self.eyebutton2.selected;
    self.ConfirmpasswordTF.secureTextEntry = !self.eyebutton2.selected;
}

//用户协议
- (IBAction)Agreementaction:(id)sender {
    PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
    detailVC.content = self.contentstr;
    detailVC.navtitle = LocalizationKey(@"Userprotocol");
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)getCode:(UIButton *)sender {
    if ([NSString stringIsNull:self.phoneNumberTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobile") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.countryTF.text]) {
        [self.view makeToast:LocalizationKey(@"selectCountry") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [self getphonncode];

}

- (IBAction)regisAction:(UIButton *)sender {
    /*邮箱注册按钮*/
    if (_isEmail) {
        if ([NSString stringIsNull:self.phoneNumberTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputEmail") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.userNameTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputUsername") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.passwordTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputPwd") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.countryTF.text]) {
            [self.view makeToast:LocalizationKey(@"selectCountry") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if (!self.agressButton.selected) {
            [self.view makeToast:LocalizationKey(@"PleaseUserprotocol") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        [self emailRegis];
        return;
    }else{
        [self goRegister];
        return;
    }
}

//获取用户协议
-(void)getUserprotocol{
    
    [MineNetManager Userprotocol:@{@"id":@"17"} CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
               
                self.contentstr = resPonseObj[@"data"][@"content"];
            }else{
                [UIApplication.sharedApplication.keyWindow makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [UIApplication.sharedApplication.keyWindow makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setNavigationControllerStyle];
}

-(void)selectCountry{
    __weak typeof(self)weakSelf=self;
    countryViewController *countryVC = [[countryViewController alloc]init];
    countryVC.hidesBottomBarWhenPushed=YES;
    countryVC.returnValueBlock = ^(countryModel *model){
        weakSelf.countryModel = model;
        if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
            weakSelf.countryTF.text = model.enName;
        }else{
            weakSelf.countryTF.text = model.zhName;
        }
    };
    [self.navigationController pushViewController:countryVC animated:YES];
}

#pragma mark-切换邮箱注册Or手机号码注册
-(void)RighttouchEvent{
    [self finished];
    //开始动画
    [UIView beginAnimations:@"doflip" context:nil];
    //设置时常
    [UIView setAnimationDuration:0.5];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置代理
    [UIView setAnimationDelegate:self];
    //动画结束
//    [UIView setAnimationDidStopSelector:@selector(finished)];
    //设置翻转方向
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
}

-(void)finished{
    _isEmail = !_isEmail;
    if (_isEmail) {
        self.verifyCodeTF.hidden=YES;
        self.verifyButton.hidden=YES;
        self.lineView.hidden=YES;
        
        self.verifyLabelMarginTopConstraint.constant = 0;
        self.verifyLabelHeightConstraint.constant = 0;
        self.verifycodelabel.hidden = YES;
        self.verifyTFMarginTopConstraint.constant = 0;
        self.verifyTFHeightConstraint.constant = 0;
        self.verifyLineMarginTopConstraint.constant = 0;
        
        self.countryView.hidden = NO;
//        self.countryViewHeightConstraint.constant = 0;
//        self.countryViewMarginTopConstraint.constant = 0;
        
        self.backViewHeightConstraint.constant = 475 + 60 > (kWindowH - Height_NavBar) ? 475 + 60 : (kWindowH - Height_NavBar);

    }else{
        self.verifyCodeTF.hidden=NO;
        self.verifyButton.hidden=NO;
        self.lineView.hidden=NO;
        
        self.verifyLabelMarginTopConstraint.constant = 10;
        self.verifyLabelHeightConstraint.constant = 17;
        self.verifycodelabel.hidden = NO;
        self.verifyTFMarginTopConstraint.constant = 5;
        self.verifyTFHeightConstraint.constant = 30;
        self.verifyLineMarginTopConstraint.constant = 5;
        
        self.countryView.hidden = NO;
        self.countryViewHeightConstraint.constant = 68;
        self.countryViewMarginTopConstraint.constant = 10;
        
        self.backViewHeightConstraint.constant = 615 + 60 > (kWindowH - Height_NavBar) ? 615 + 60 : (kWindowH - Height_NavBar);

    }
//    self.backViewHeightConstraint.constant = CGRectGetMaxY(self.registerBtn.frame) + 60 > (kWindowH - Height_NavBar) ? CGRectGetMaxY(self.registerBtn.frame) + 60 : (kWindowH - Height_NavBar);

    [self.view layoutIfNeeded];
    
    _phoneNumberTF.text=@"";
    _verifyCodeTF.text=@"";
    _userNameTF.text=@"";
    _passwordTF.text=@"";
    NSString * mobileRegister = LocalizationKey(@"moblieRegister");
    NSString * emailRegister = LocalizationKey(@"emailRegister");
    self.navigationItem.title=_isEmail==YES?emailRegister:mobileRegister;
    self.navigationItem.rightBarButtonItem.title=_isEmail==YES?mobileRegister:emailRegister;
   _phoneNumberTF.placeholder=_isEmail==YES?LocalizationKey(@"email"):LocalizationKey(@"phoneNum");
    _phonelabel.text = _isEmail==YES?LocalizationKey(@"emailAccount"):LocalizationKey(@"phoneNum");
    [_phoneNumberTF resignFirstResponder];
    _phoneNumberTF.keyboardType=_isEmail==YES?UIKeyboardTypeNumbersAndPunctuation:UIKeyboardTypeNumberPad;
}

//获取手机验证码
-(void)getphonncode{
    [self.view endEditing:YES];
    if (!_isEmail) {
        // 加载腾讯验证码
        [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2038419167" callback:^(NSDictionary *resultJSON) { // appid在验证码接入平台注册申请，
            if(0==[resultJSON[@"ret"] intValue]) {
                /**
                 验证成功
                 返回内容：
                 resultJSON[@"appid"]为回传的业务appid
                 resultJSON[@"ticket"]为验证码票据
                 resultJSON[@"randstr"]为随机串
                 */
                _g3Result = resultJSON;
                __block NSMutableString *postResult = [[NSMutableString alloc] init];
                [postResult appendFormat:@"%@", [NSString stringWithFormat:@"phone=%@&country=%@",self.phoneNumberTF.text,self.countryModel.zhName]];
                NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
                NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",HOST,@"uc/mobile/code"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
                secondaryRequest.HTTPMethod = @"POST";
                secondaryRequest.allHTTPHeaderFields = headerFields;
                secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [EasyShowLodingView hidenLoding];
                    });
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if (!error && httpResponse.statusCode == 200) {
                        NSError *err;
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                        if (!err) {
                            if ([dict[@"code"] integerValue] == 0) {
                                //发送短信验证码成功
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [APPLICATION.window makeToast:dict[@"message"] duration:1.5 position:CSToastPositionCenter];
                                });
                                __block int timeout=60; //倒计时时间
                                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                                dispatch_source_set_event_handler(_timer, ^{
                                    if(timeout<=0){ //倒计时结束，关闭
                                        dispatch_source_cancel(_timer);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.verifyButton setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];
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
                            }
                            else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [APPLICATION.window makeToast:dict[@"message"] duration:1.5 position:CSToastPositionCenter];
                                });
                                
                            }
                        }
                    }
                }];
                [task resume];
            }
        }];
    }else{
        
        
    }
    
}
#pragma mark-手机号码注册

- (void)goRegister{
        if ([NSString stringIsNull:self.phoneNumberTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputMobile") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.verifyCodeTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputCode") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.userNameTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputUsername") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if ([NSString stringIsNull:self.passwordTF.text]) {
            [self.view makeToast:LocalizationKey(@"inputPwd") duration:1.5 position:CSToastPositionCenter];
            return;
        }
       if ([NSString stringIsNull:self.ConfirmpasswordTF.text]) {
            [self.view makeToast:LocalizationKey(@"PcertainPassword") duration:1.5 position:CSToastPositionCenter];
           return;
       }
    
    if (![self.passwordTF.text isEqualToString:self.ConfirmpasswordTF.text] ) {
        [self.view makeToast:LocalizationKey(@"inputPwdNoSame") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.countryTF.text]) {
        [self.view makeToast:LocalizationKey(@"selectCountry") duration:1.5 position:CSToastPositionCenter];
        return;
    }

    if (!self.agressButton.selected) {
        [self.view makeToast:LocalizationKey(@"PleaseUserprotocol") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSMutableDictionary *codeDic = [NSMutableDictionary dictionary];
    [codeDic setValue:_g3Result[@"ticket"] forKey:@"ticket"];
    [codeDic setValue:_g3Result[@"randstr"] forKey:@"randStr"];

    [LoginNetManager getAccountForPhone:self.phoneNumberTF.text withpassword:self.passwordTF.text withcode:self.verifyCodeTF.text withusername:self.userNameTF.text withcountry:self.countryModel.zhName withpromotion:self.invitaTF.text withG3Result:codeDic CompleteHandle:^(id resPonseObj, int code) {
        
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
  
}

- (void)emailRegis{
    //邮箱注册
    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2038419167" callback:^(NSDictionary *resultJSON) {
        if(0==[resultJSON[@"ret"] intValue]){
            _g3Result = resultJSON;
            NSString *ticket = resultJSON[@"ticket"];
            NSString *randstr = resultJSON[@"randstr"];
            
            __block NSMutableString *postResult = [[NSMutableString alloc] init];
            [postResult appendFormat:@"%@", [NSString stringWithFormat:@"country=%@&email=%@&password=%@&username=%@&promotion=%@&ticket=%@&randStr=%@",self.countryModel.zhName,self.phoneNumberTF.text,self.passwordTF.text,self.userNameTF.text,self.invitaTF.text, ticket, randstr]];
            NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
            NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",HOST,@"uc/register/email"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
            secondaryRequest.HTTPMethod = @"POST";
            secondaryRequest.allHTTPHeaderFields = headerFields;
            secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            [EasyShowLodingView showLoding];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [EasyShowLodingView hidenLoding];
                });
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (!error && httpResponse.statusCode == 200) {
                    NSError *err;
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                    if (!err) {
                        if ([dict[@"code"] integerValue] == 0) {
                            //邮箱注册成功
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [APPLICATION.window makeToast:dict[@"message"] duration:1.5 position:CSToastPositionCenter];
                            });
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [APPLICATION.window makeToast:dict[@"message"] duration:1.5 position:CSToastPositionCenter];
                            });
                            
                        }
                    }
                }
            }];
            
            [task resume];
        }
    }];
        
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 40)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self cancelNavigationControllerStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
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
