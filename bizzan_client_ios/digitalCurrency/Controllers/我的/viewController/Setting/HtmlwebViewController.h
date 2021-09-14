//
//  HtmlwebViewController.h
//  digitalCurrency
//
//  Created by startlink on 2018/7/7.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HtmlwebViewController : BaseViewController
@property (nonatomic,strong)WKWebView *webview;
@property (nonatomic,copy)NSString *urlstr;
@end
