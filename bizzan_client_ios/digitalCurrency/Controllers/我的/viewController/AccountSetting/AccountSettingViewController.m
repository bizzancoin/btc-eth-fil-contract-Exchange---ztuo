//
//  AccountSettingViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountImageTableViewCell.h"
#import "AccountSettingTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MoneyPasswordViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "BindingEmailViewController.h"
#import "BindingPhoneViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "ResetPhoneViewController.h"
#import "GestureTableViewCell.h"
#import "ZLGestureLockViewController.h"
#import "UpdateIDCardViewController.h"
#import "UpVideoViewController.h"

@interface AccountSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL _phoneVerified;
    BOOL _emailVerified;
    BOOL _loginVerified;
    BOOL _fundsVerified;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
//上传路径
@property(nonatomic,strong) NSMutableArray *accountInfoArr;
@property(nonatomic,strong)NSMutableArray *accountColorArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) UIImage *headImage;
@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"securitySetting" value:nil table:@"English"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountImageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountImageTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"GestureTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GestureTableViewCell class])];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.headImage = [[UIImage alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self accountSettingData];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
   
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"resPonseObj ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
               
                [self getAccountSettingStatus];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
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
//MARK:--整理账号设置的信息状态
-(void)getAccountSettingStatus{
    if ([_accountInfo.phoneVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:3 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"bounded" value:nil table:@"English"]];
         [self.accountColorArr replaceObjectAtIndex:3 withObject:baseColor];
        _phoneVerified = YES;
    }else{
        _phoneVerified = NO;
        [self.accountInfoArr replaceObjectAtIndex:3 withObject:LocalizationKey(@"unbounded")];
        [self.accountColorArr replaceObjectAtIndex:3 withObject:RGBOF(0x999999)];
    }
    
    if ([_accountInfo.emailVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:2 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"bounded" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:2 withObject:baseColor];
        _emailVerified = YES;
    }else{
        _emailVerified = NO;
        [self.accountInfoArr replaceObjectAtIndex:2 withObject:LocalizationKey(@"unbounded")];
        [self.accountColorArr replaceObjectAtIndex:2 withObject:RGBOF(0x999999)];
    }
    
    if ([_accountInfo.loginVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:4 withObject:LocalizationKey(@"yetSetting")];
        [self.accountColorArr replaceObjectAtIndex:4 withObject:baseColor];
        _loginVerified = YES;
    }else{
        _loginVerified = NO;
        [self.accountInfoArr replaceObjectAtIndex:4 withObject:LocalizationKey(@"unSetting")];
        [self.accountColorArr replaceObjectAtIndex:4 withObject:RGBOF(0x999999)];
    }
    
    if ([_accountInfo.fundsVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:5 withObject:LocalizationKey(@"yetSetting")];
        [self.accountColorArr replaceObjectAtIndex:5 withObject:baseColor];
        _fundsVerified = YES;
    }else{
        _fundsVerified = NO;
        [self.accountInfoArr replaceObjectAtIndex:5 withObject:LocalizationKey(@"unSetting")];
        [self.accountColorArr replaceObjectAtIndex:5 withObject:RGBOF(0x999999)];
    }
    
    if ([_accountInfo.kycStatus isEqualToString:@"0"]) {
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Nonrealname" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }else if ([_accountInfo.kycStatus isEqualToString:@"1"]){
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Videoaudit" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }else if ([_accountInfo.kycStatus isEqualToString:@"2"]){
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Realnameauditfailed" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }else if ([_accountInfo.kycStatus isEqualToString:@"3"]){
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Videoauditfailed" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }else if ([_accountInfo.kycStatus isEqualToString:@"4"]){
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Realnamesuccess" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:baseColor];
    }else if ([_accountInfo.kycStatus isEqualToString:@"5"]){
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"Tobeexaminedbyrealname" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }else{
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:[[ChangeLanguage bundle] localizedStringForKey:@"WaitingforVideoAudit" value:nil table:@"English"]];
        [self.accountColorArr replaceObjectAtIndex:1 withObject:RGBOF(0x999999)];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)accountInfoArr {
    if (!_accountInfoArr) {
        _accountInfoArr = [NSMutableArray arrayWithArray:@[@"",[[ChangeLanguage bundle] localizedStringForKey:@"uncertified" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"],LocalizationKey(@"unSetting"),LocalizationKey(@"unSetting")]];
    }
    return _accountInfoArr;
}
- (NSMutableArray *)accountColorArr {
    if (!_accountColorArr) {
        _accountColorArr = [NSMutableArray arrayWithArray:@[RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999),RGBOF(0x999999)]];
    }
    return _accountColorArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0){
        return 75;
    }else{
      return 63;
    }
}

-(NSArray *)getNameArr{
    
    NSArray * nameArr = @[@"",
                          [[ChangeLanguage bundle] localizedStringForKey:@"identityAuthentication" value:nil table:@"English"],
                          [[ChangeLanguage bundle] localizedStringForKey:@"bindingEmail" value:nil table:@"English"],
                          [[ChangeLanguage bundle] localizedStringForKey:@"bindPhoneNumber" value:nil table:@"English"],
                          [[ChangeLanguage bundle] localizedStringForKey:@"loginPassword" value:nil table:@"English"],
                          [[ChangeLanguage bundle] localizedStringForKey:@"moneyPassword" value:nil table:@"English"]];
    return nameArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccountImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountImageTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.headImage.clipsToBounds = YES;
            cell.headImage.layer.cornerRadius = 30;
            if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
            }else{
                NSURL *headUrl = [NSURL URLWithString:self.accountInfo.avatar];
                [cell.headImage sd_setImageWithURL:headUrl];
            }
            return cell;
        }else{
            AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = [self getNameArr][indexPath.row];
            cell.rightLabel.text = self.accountInfoArr[indexPath.row];
            cell.rightLabel.textColor = self.accountColorArr[indexPath.row];

            return cell;
        }
    }else{
        GestureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GestureTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([ZLGestureLockViewController gesturesPassword].length > 0) {
            cell.gestureSwitch.on=YES;
        }else{
            cell.gestureSwitch.on=NO;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        NSString *tixing = LocalizationKey(@"securityTiXing");
        CGFloat height = [ToolUtil heightForString:tixing andWidth:kWindowW - 20 fontSize:13];
        return height + 25;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        NSString *tixing = LocalizationKey(@"securityTiXing");
        CGFloat height = [ToolUtil heightForString:tixing andWidth:kWindowW - 20 fontSize:13];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kWindowW - 20, height)];
        label.text = tixing;
        label.textColor = RGBOF(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        return;
    }
    if (indexPath.row == 0) {
        //改变头像
        [self changeHeaderImage];
    }else if (indexPath.row == 3){
        //绑定手机
        if (_phoneVerified){
            ResetPhoneViewController *resetVC = [[ResetPhoneViewController alloc] init];
            resetVC.phoneNum = self.accountInfo.mobilePhone;
            [[AppDelegate sharedAppDelegate] pushViewController:resetVC];
        }else{
            BindingPhoneViewController *phoneVC = [[BindingPhoneViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:phoneVC];
        }
    }else if (indexPath.row == 2){
        //绑定邮箱
        BindingEmailViewController *emailVC = [[BindingEmailViewController alloc] init];
        if (_emailVerified == YES) {
            emailVC.bindingStatus = 1;
            emailVC.emailStr = self.accountInfo.email;
        }else{
            emailVC.bindingStatus = 0;
        }
        [[AppDelegate sharedAppDelegate] pushViewController:emailVC];
    }else if (indexPath.row == 4){
        //登录密码
        if (!_phoneVerified) {
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"unBindPhoneTip" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
            return;
        }
        ChangeLoginPasswordViewController *changeLoginVC = [[ChangeLoginPasswordViewController alloc] init];
        changeLoginVC.phoneNum = self.accountInfo.mobilePhone;
        [[AppDelegate sharedAppDelegate] pushViewController:changeLoginVC];
    }else if (indexPath.row == 5){
        //资金密码
        MoneyPasswordViewController *moneyVC = [[MoneyPasswordViewController alloc] init];
        if (_fundsVerified == YES) {
            moneyVC.setStatus = 1;
        }else{
            moneyVC.setStatus = 0;
        }
        [[AppDelegate sharedAppDelegate] pushViewController:moneyVC];
        
    }else if (indexPath.row == 1){
        
        if ([self.accountInfo.kycStatus isEqualToString:@"0"] || [self.accountInfo.kycStatus isEqualToString:@"2"] || [self.accountInfo.kycStatus isEqualToString:@"5"] || [self.accountInfo.kycStatus isEqualToString:@"4"]) {
            //身份认证
            IdentityAuthenticationViewController *identityVC = [[IdentityAuthenticationViewController alloc] init];
            identityVC.identifyStatus = self.accountInfo.realVerified;
            //        identityVC.identifyStatus = @"0";
            identityVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
            identityVC.realAuditing = self.accountInfo.realAuditing;
            [[AppDelegate sharedAppDelegate] pushViewController:identityVC];
            return;
        }
        //视频认证
        UpVideoViewController *UpVideoVC = [UpVideoViewController new];
        UpVideoVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
        [[AppDelegate sharedAppDelegate] pushViewController:UpVideoVC];

        
    }else{
        //其他
    }
    
}
//MARK:--添加头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    [LEEAlert actionsheet].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"projectNameTip" value:nil table:@"English"];
        label.textColor = RGBOF(0x333333);
        label.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddContent(^(UILabel *label){
        label.text = LocalizationKey(@"addHeadImageMessage");
        label.textColor = RGBOF(0x333333);
        label.backgroundColor = [UIColor whiteColor];
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"takingPictures" value:nil table:@"English"];
        action.backgroundColor = [UIColor whiteColor];
        action.titleColor = RGBOF(0x333333);
        action.borderColor = BackColor;
        action.clickBlock = ^{
            //判断是否已授权
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                    return ;
                }
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self chooseImage:sourceType];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"tips" value:nil table:@"English"] message:[[ChangeLanguage bundle] localizedStringForKey:@"unSupportTakePhoto" value:nil table:@"English"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ok" value:nil table:@"English"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"photoAlbumSelect" value:nil table:@"English"];
        action.backgroundColor = [UIColor whiteColor];
        action.titleColor = RGBOF(0x333333);
        action.borderColor = BackColor;
        action.clickBlock = ^{
            //判断是否已授权
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                
                ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
                if (authStatus == ALAuthorizationStatusDenied) {
                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                    return;
                }
            }
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self chooseImage:sourceType];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeCancel;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"];
        action.titleColor = RGBOF(0x333333);
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeShow();
    
    
}
//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerVC = imagePickerController;
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    //将图片上传到服务器
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadingHeadPhoto" value:nil table:@"English"]];
    NSString *str=@"uc/upload/oss/image";
    NSString *urlString=[HOST stringByAppendingString:str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = imageData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [EasyShowLodingView hidenLoding];
        //上传成功
        if ([responseObject[@"code"] integerValue] == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            AccountImageTableViewCell *cell = (AccountImageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
            cell.headImage.image = headImage;
            [self headImage:responseObject[@"data"]];
        }else if([responseObject[@"code"] integerValue] == 4000) {
            [ShowLoGinVC showLoginVc:self withTipMessage:responseObject[MESSAGE]];
        }else{
            [self.view makeToast:responseObject[MESSAGE] duration:1.5 position:CSToastPositionCenter];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [EasyShowLodingView hidenLoding];
        //上传失败
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//MARK:--设置头像
-(void)headImage:(NSString *)urlString{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"settingHeadImage" value:nil table:@"English"]];
    [MineNetManager setHeadImageForUrl:urlString CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //设置头像成功
                 [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];

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
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//
//    //设置动画时间为0.25秒,xy方向缩放的最终值为1
//    [UIView animateWithDuration:0.25 animations:^{
//
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//
//    }completion:^(BOOL finish){
//
//    }];
}

@end
