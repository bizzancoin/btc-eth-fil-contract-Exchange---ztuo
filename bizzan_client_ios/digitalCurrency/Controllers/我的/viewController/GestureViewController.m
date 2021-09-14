//
//  GestureViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/9.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "GestureViewController.h"
#import "ZLGestureLockViewController.h"
@interface GestureViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *gesturesPasswordLabel;

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"safeCenter" value:nil table:@"English"];
    self.gesturesPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"gesturesPassword" value:nil table:@"English"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        self.switchBtn.on=YES;
    }else{
         self.switchBtn.on=NO;
    }
}
- (IBAction)switchEvent:(UISwitch *)sender {

    
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        self.switchBtn.on=YES;
        //校验手势密码并关闭
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeDeletePsw];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.switchBtn.on=NO;
        //创建手势密码
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeCreatePsw];
        [self presentViewController:vc animated:YES completion:nil];
    }
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
