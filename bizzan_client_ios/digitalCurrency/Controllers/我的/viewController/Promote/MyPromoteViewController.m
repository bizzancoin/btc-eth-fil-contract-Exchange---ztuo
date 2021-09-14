//
//  MyPromoteViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromoteViewController.h"
#import "MyPromotePublicViewController.h"
#import "MyPromoteShareView.h"


@interface MyPromoteViewController ()<XLBasePageControllerDelegate,XLBasePageControllerDataSource>{
    MyPromoteShareView *_shareView;
}
@property (nonatomic, strong)  NSArray *menuList;
@property(nonatomic,copy)NSString *promoteLink;//推广链接
@end

@implementation MyPromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"myPromotion");
    self.menuList = @[LocalizationKey(@"promoteFriends"),LocalizationKey(@"Myreward")];
    [self RightsetupNavgationItemWithpictureName:@"promoteShareImage"];
    self.delegate = self;
    self.dataSource = self;
    self.lineWidth = 2.0;//选中下划线宽度
    self.titleFont = [UIFont systemFontOfSize:16.0];
    self.defaultColor = AppTextColor_333333;//默认字体颜色
    self.chooseColor = baseColor;//选中字体颜色
    self.selectIndex = 0;//默认选中第几页
    [self reloadScrollPage];
    
    self.promoteLink= [NSString stringWithFormat:@"%@%@",[YLUserInfo shareUserInfo].promotionPrefix,[YLUserInfo shareUserInfo].promotionCode];
}
//MARK:--分享
-(void)RighttouchEvent{
    [self shareView];
}
-(void)shareView{
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"MyPromoteShareView" owner:nil options:nil].firstObject;
        _shareView.frame=[UIScreen mainScreen].bounds;
        [_shareView.saveImageButton addTarget:self action:@selector(saveImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.pasteButton addTarget:self action:@selector(pasteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        CIImage *codeCIImage = [self createQRForString:self.promoteLink];
        _shareView.promoteLinks.text = [NSString stringWithFormat:@"%@\n%@",LocalizationKey(@"captivePromoteLink"),self.promoteLink];
        _shareView.QRImage.image = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    }
    [UIApplication.sharedApplication.keyWindow addSubview:_shareView];
}
//MARK:--复制推广链接
-(void)pasteBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.promoteLink;
    [_shareView makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"pastePromoteLink" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
}
//MARK:--字符串生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:@""];
    [waterimage drawInRect:CGRectMake((size-waterimage.size.width)/2.0, (size-waterimage.size.height)/2.0, waterimage.size.width, waterimage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
//MARK:--取消点击事件
-(void)cancelBtnClick{
    [_shareView removeFromSuperview];
}
//MARK:--保存图片点击事件
-(void)saveImageBtnClick{
    UIImage *saveImage = [self convertViewToImage:_shareView.bgView];
    [self saveImage:saveImage];
}
//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}
//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [_shareView makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"savePhotoFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }
    else {
        [_shareView makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"savePhotoSuccess" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }
}
- (UIImage *)convertViewToImage:(UIView *)view
{
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(NSInteger)numberViewControllersInViewPager:(XLBasePageController *)viewPager
{
    return _menuList.count;
}
-(UIViewController *)viewPager:(XLBasePageController *)viewPager indexViewControllers:(NSInteger)index
{
    MyPromotePublicViewController *publicVC = [[MyPromotePublicViewController  alloc] init];
    publicVC.index = index;
    return publicVC;
}

-(CGFloat)heightForTitleViewPager:(XLBasePageController *)viewPager
{
    return 44;
}
-(NSString *)viewPager:(XLBasePageController *)viewPager titleWithIndexViewControllers:(NSInteger)index
{
    return self.menuList[index];
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
