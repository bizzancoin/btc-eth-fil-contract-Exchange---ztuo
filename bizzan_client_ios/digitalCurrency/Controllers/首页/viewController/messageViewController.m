//
//  messageViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "messageViewController.h"

@interface messageViewController ()
@property(nonatomic,strong)UIWebView*webView;
@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.model.name;
    [self loadString:self.model.linkUrl];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadString:(NSString *)str  {
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
//    if (![str hasPrefix:@"http://"]) {
//        urlStr = [NSString stringWithFormat:@"http://%@", str];
//    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView   {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kWindowW, kWindowH-Height_NavBar-SafeAreaBottomHeight)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        [_webView setScalesPageToFit:YES];
        [self.view addSubview:_webView];
    }
    return _webView;
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
