//
//  PlatformMessageDetailViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/21.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "PlatformMessageDetailViewController.h"

@interface PlatformMessageDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation PlatformMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navtitle;
//    self.title = LocalizationKey(@"notice");
    [self.view addSubview:[self webView]];
    // Do any additional setup after loading the view.
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-NEW_NavHeight)];
        _webView.delegate = self;
        [_webView scalesPageToFit];
        [_webView loadHTMLString:self.content baseURL:nil];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [EasyShowLodingView hidenLoding];
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [EasyShowLodingView hidenLoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
