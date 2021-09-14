//
//  BindAliPayViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BindAliPayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MineNetManager.h"

@interface BindAliPayViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UITextField *aliPayNum;
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;
@property (weak, nonatomic) IBOutlet UIButton *QRButton;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
@property(nonatomic,copy)NSString *imageString;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipayNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectQRCodeLabel;


@end

@implementation BindAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    [self setRightItem];
    self.realName.text = self.model.realName;
    if ([self.model.aliVerified isEqualToString:@"1"]) {
        //已保存，可修改
        self.title = LocalizationKey(@"modifyAliPayNum");
        self.aliPayNum.text = self.model.alipay.aliNo;
    }else{
        self.title = LocalizationKey(@"setAliPayNum");
    }
    
    self.nameLabel.text = LocalizationKey(@"name");
    self.alipayNumLabel.text = LocalizationKey(@"alipayAccount");
    self.moneyPasswordLabel.text = LocalizationKey(@"moneyPassword");
    self.collectQRCodeLabel.text = LocalizationKey(@"collectionQR");
    self.aliPayNum.placeholder = LocalizationKey(@"inputAliPayNum");
    self.moneyPassword.placeholder = LocalizationKey(@"inputMoneyPassword");
    self.moneyPassword.secureTextEntry = YES;
    
    [_aliPayNum setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_moneyPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];

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

//MARK:--点击保存按钮点击事件
- (void)RighttouchEvent{
    if ([self.aliPayNum.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputAliPayNum") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.imageString isEqualToString:@""] || self.imageString == nil) {
        [self.view makeToast:LocalizationKey(@"inputCollectionQR") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    NSString *urlStr = @"";
    if ([self.model.aliVerified isEqualToString:@"1"]) {
        //已绑定，可修改
        urlStr = @"uc/approve/update/ali";
    }else{
        urlStr = @"uc/approve/bind/ali";
    }
    [MineNetManager setAliPayForUrlString:urlStr withAli:self.aliPayNum.text withJyPassword:self.moneyPassword.text withRealName:self.realName.text withQrCodeUrl:self.imageString CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[AppDelegate sharedAppDelegate] popViewController];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--点击上传收款二维码
- (IBAction)QRBtnClick:(id)sender {
    [self changeHeaderImage];
}
//MARK:--添加支付宝二维码头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    [LEEAlert actionsheet].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"projectNameTip" value:nil table:@"English"];
        label.textColor = RGBOF(0x333333);
        label.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddContent(^(UILabel *label){
        label.text = LocalizationKey(@"inputAliPayAddImage");
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
            [self.QRButton setBackgroundImage:headImage forState:UIControlStateNormal];
            self.imageString =responseObject[@"data"];
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
