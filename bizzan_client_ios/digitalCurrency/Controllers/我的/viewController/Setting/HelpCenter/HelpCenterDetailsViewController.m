//
//  HelpCenterDetailsViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "HelpCenterDetailsViewController.h"

@interface HelpCenterDetailsViewController ()<UIWebViewDelegate>

{

    NSString *_title;
    NSString *_source;
    NSString *_content;
    
    UIWebView *_webView;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HelpCenterDetailsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *web =[[UIWebView alloc] init];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    web.opaque = NO;
    web.scrollView.scrollEnabled = NO;
    _webView = web;
    [self loadScrollView];
    [self initData];
}



- (void)loadScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - NEW_NavHeight)];
    self.scrollView.contentSize = CGSizeMake(kWindowW, kWindowH - NEW_NavHeight);
    [self.view addSubview:self.scrollView];
}

- (void)loadSubViews{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kWindowW - 30, 0)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:23];
    label.text = _title;
    CGSize maxSize = CGSizeMake(kWindowW - 30, MAXFLOAT);
    CGSize a = [label sizeThatFits:maxSize];
    label.frame = CGRectMake(15, 15, kWindowW - 30, a.height);
    label.textColor = RGBOF(0x333333);
    [self.scrollView addSubview:label];
    
    UILabel *source = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame) + 10, kWindowW - 30, 15)];
    source.text = _source;
    source.textAlignment = NSTextAlignmentCenter;
    source.font = [UIFont systemFontOfSize:13];
    source.textColor = RGBOF(0x999999);
    [self.scrollView addSubview:source];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(source.frame) + 8, kWindowW - 30, 1)];
    lineView.backgroundColor = RGBOF(0x333333);
    [self.scrollView addSubview:lineView];
    
    _webView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), kWindowW, kWindowH - NEW_NavHeight - CGRectGetMaxY(lineView.frame));
    
    [self.scrollView addSubview:_webView];
}

- (void)initData{
    _title = self.contentModel.title;
    NSString *time = self.contentModel.createTime;
    _source = [NSString stringWithFormat:@"%@  %@",time, LocalizationKey(@"ztuoExchange")];
    _content = self.contentModel.content;
    
    NSString *htmlStr = [NSString stringWithFormat:@"<head><style>img{max-width:%dpx !important;}</style></head>%@",(int)(kWindowW - 20), _content];
    [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:HOST]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self loadSubViews];
    
    NSString *str = [NSString stringWithFormat:@"var script = document.createElement('script');"
                     "script.type = 'text/javascript';"
                     "script.text = \"function ResizeImages() { "
                     "var myimg,oldwidth,oldheight;"
                     "var maxwidth=%f;"// 图片宽度
                     "for(i=0;i <document.images.length;i++){"
                     "myimg = document.images[i];"
                     "if(myimg.width > maxwidth){"
                     "myimg.width = maxwidth;"
                     "}"
                     "}"
                     "}\";"
                     "document.getElementsByTagName('head')[0].appendChild(script);",(kWindowW - 20)];
    
    [webView stringByEvaluatingJavaScriptFromString:
     str];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    //方法1
    //HTML5的高度
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //HTML5的宽度
    NSString *htmlWidth = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"];
    //宽高比
    float i = [htmlWidth floatValue]/[htmlHeight floatValue];
    
    //webview控件的最终高度
    float height = kWindowW/i;
    
    CGRect frame = _webView.frame;
    _webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height + 10);
    self.scrollView.contentSize = CGSizeMake(kWindowW, CGRectGetMaxY(_webView.frame));
    
}


@end
