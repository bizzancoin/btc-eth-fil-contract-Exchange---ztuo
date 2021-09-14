//
//  ZTMineLabelTableViewCell1.m
//  digitalCurrency
//
//  Created by chu on 2019/4/27.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ZTMineLabelTableViewCell1.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"

@interface ZTMineLabelTableViewCell1 ()

@property (nonatomic,assign) NSInteger memberLevel;
@property (nonatomic,strong) AccountSettingInfoModel *accountInfo;//用户状态
@property (nonatomic,copy) NSString *reasonstr;

@end

@implementation ZTMineLabelTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (IBAction)buniessAction:(UIButton *)sender {
    if (self.buninessBlock) {
        self.buninessBlock();
    }
}

- (IBAction)candyAction:(UIButton *)sender {
    if (self.candyBlock) {
        self.candyBlock();
    }
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    if (titles.count == 2) {
        self.buniessLabel.text = titles[0];
        self.candyLabel.text = titles[1];
    }
}



@end
