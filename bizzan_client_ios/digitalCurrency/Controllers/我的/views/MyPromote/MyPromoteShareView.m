//
//  MyPromoteShareView.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromoteShareView.h"

@implementation MyPromoteShareView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.BGViewHeight.constant = 200;
    self.saveBtnWidth.constant = kWindowW/2;
    [self.pasteButton setTitle:LocalizationKey(@"copy") forState:UIControlStateNormal];
    self.topTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[YLUserInfo shareUserInfo].username,LocalizationKey(@"inviteYouJoin"),LocalizationKey(@"projectName")];
    [self.saveImageButton setTitle:LocalizationKey(@"promoteSaveImage") forState:UIControlStateNormal];
    self.inviteLabel.text = [NSString stringWithFormat:@"%@\n%@",LocalizationKey(@"promoteShareTip1"),LocalizationKey(@"promoteShareTip2")];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [_bgView.layer convertPoint:point fromLayer:self.layer];
    if (![_bgView.layer containsPoint:point]) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
