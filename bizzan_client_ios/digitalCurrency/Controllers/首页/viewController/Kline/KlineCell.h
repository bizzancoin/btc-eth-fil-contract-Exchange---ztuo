//
//  KlineCell.h
//  BTC-Kline
//
//  Created by sunliang on 2018/5/17.
//  Copyright © 2018年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelBtnTagBlock)(NSInteger tag);


@interface KlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *indView;
@property (strong, nonatomic)  UIButton *KlineCurrentBtn;//选中的K线种类
@property (strong, nonatomic)  UIButton *mainCurrentBtn;//选中的主图
@property (strong, nonatomic)  UIButton *subCurrentBtn;//选中的副图
@property (weak, nonatomic) IBOutlet UIButton *macdBtn;
@property (weak, nonatomic) IBOutlet UIButton *maBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *indexBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property(nonatomic,strong)UIView*klineView;
@property (nonatomic, copy) SelBtnTagBlock block;
@property (nonatomic, assign) NSInteger selIndexBtn;


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn10;
@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
@property (weak, nonatomic) IBOutlet UIButton *btn13;

@end
