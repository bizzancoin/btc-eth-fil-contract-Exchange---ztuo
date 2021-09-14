//
//  MineTableHeadView.h
//  ATC
//
//  Created by iDog on 2018/6/1.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
-(MineTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect;

@end
