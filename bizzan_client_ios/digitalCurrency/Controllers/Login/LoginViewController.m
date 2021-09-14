//
//  LoginViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "LoginNetManager.h"
#import "YLTabBarController.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>
#import "HWTFCursorView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowRegisterBtn;
@property (weak, nonatomic) IBOutlet UILabel *noAccountlabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomspec;
@property (weak, nonatomic) IBOutlet UILabel *phonelabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordlabel;
@property (weak, nonatomic) IBOutlet UIButton *eyebutton;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;

@property (nonatomic, assign) BOOL verifyGoogle;//是否需要谷歌验证 默认NO
@property (nonatomic, copy) NSString *randstr;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *code;

#define isRemember @"isRemember"
#define rememberPassword @"rememberPassword"
#define rememberUsername @"rememberUsername"

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *a = @[@"1"];
//    a[2];
    self.code = @"";
    [self.rememberBtn setTitle:LocalizationKey(@"Remember password") forState:UIControlStateNormal];
    self.userNameTF.placeholder = LocalizationKey(@"emailOrMobile");
    self.passwordTF.placeholder = LocalizationKey(@"inputPwd");
    [self setNavigationControllerStyle];
    [self leftbutitem];
    self.bottomspec.constant = SafeAreaBottomHeight + 10;
    //通过KVC修改占位文字的颜色
    [_userNameTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:RGBOF(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
    [_userNameTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_passwordTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    self.bottomDistance.constant=kWindowH >= 812.0 ? 34 : 10;
    self.phonelabel.text = LocalizationKey(@"account");
    self.passwordlabel.text = LocalizationKey(@"pwd");
    self.noAccountlabel.text = LocalizationKey(@"noAccount");
    
    // Do any additional setup after loading the view from its nib.
    [self.loginBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
    [self.forgetPwdBtn setTitle:LocalizationKey(@"forgetPassword") forState:UIControlStateNormal];
    [self.nowRegisterBtn setTitle:LocalizationKey(@"nowregister") forState:UIControlStateNormal];
}
//记住密码
- (IBAction)rememberBtnClick:(id)sender {
    self.rememberBtn.selected = !self.rememberBtn.selected;
}

//是否显示密码
- (IBAction)openeyeaction:(id)sender {
    self.eyebutton.selected = !self.eyebutton.selected;
    self.passwordTF.secureTextEntry = !self.eyebutton.selected;
}

-(void)leftbutitem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isRemember]) {
        self.rememberBtn.selected = YES;
        self.passwordTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:rememberPassword];
        self.userNameTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:rememberUsername];
    }
//    [self setNavigationControllerStyle];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self setNavigationControllerStyle];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:NavColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}
-(void)RighttouchEvent{
    if (self.pushOrPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self cancelNavigationControllerStyle];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (IBAction)touchEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 0://登录
            //[self ToLogin];
            break;
        case 1://忘记密码
            [self.navigationController pushViewController:[[ForgetViewController alloc]initWithNibName:@"ForgetViewController" bundle:nil] animated:YES];
            
            break;
        case 2://注册
            [self.navigationController pushViewController:[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil] animated:YES];
            break;
            
        default:
            break;
    }
}
- (IBAction)loginAction:(UIButton *)sender {
    if ([NSString stringIsNull:self.userNameTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobileEmail") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.passwordTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputLoginPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self getGoogle];
    __weak typeof(self)weakself = self;
    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:[UIApplication sharedApplication].keyWindow appid:@"2038419167" callback:^(NSDictionary *resultJSON) {
        NSLog(@"resultJSON -- %@",resultJSON);
        if(0==[resultJSON[@"ret"] intValue]){
            weakself.ticket = resultJSON[@"ticket"];
            weakself.randstr = resultJSON[@"randstr"];
            if (weakself.verifyGoogle) {
                [weakself showGoogleVerifyView];
            }else{
                [weakself login];
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
        weakself.code = code;
        [weakself login];
    };
    [contrainer addSubview:code4View];
    
    [GKCover coverFrom:[UIApplication sharedApplication].keyWindow contentView:contrainer style:GKCoverStyleTransparent showStyle:GKCoverShowStyleCenter showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:YES showBlock:^{
        
    } hideBlock:^{
        
    }];
}

- (void)login{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/login"];
    NSDictionary *param = @{};
    if ([NSString stringIsNull:self.code]) {
        param = @{@"username":self.userNameTF.text, @"password":self.passwordTF.text, @"ticket":self.ticket, @"randStr":self.randstr};
    }else{
        param = @{@"username":self.userNameTF.text, @"password":self.passwordTF.text, @"ticket":self.ticket, @"randStr":self.randstr, @"code":self.code};
    }
    NSLog(@"param -- %@",param);
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"登录 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];//存储登录信息
                [[NSUserDefaults standardUserDefaults] setBool:self.rememberBtn.selected forKey:isRemember];
                [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:rememberPassword];
                [[NSUserDefaults standardUserDefaults] setValue:self.userNameTF.text forKey:rememberUsername];

                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [keychianTool saveToKeychainWithUserName:self.userNameTF.text withPassword:self.passwordTF.text];
                });
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//订阅聊天
                NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[YLUserInfo shareUserInfo].token forKey:executableFile];
                [defaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.enterType==1) {
                        YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
                        APPLICATION.window.rootViewController = SectionTabbar;
                    }else{
                        if (self.pushOrPresent) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                });
            }else{
                [self.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

#pragma mark - 判断用户是否打开谷歌验证
- (void)getGoogle{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/get/user"];
    NSDictionary *param = @{@"mobile":self.userNameTF.text};
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
