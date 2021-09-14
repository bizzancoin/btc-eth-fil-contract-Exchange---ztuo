//
//  UpdateIDCardViewController.h
//  digitalCurrency
//
//  Created by chu on 2018/8/9.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^UpdateSucess)(NSDictionary *dic);

@interface UpdateIDCardViewController : BaseViewController

@property (nonatomic, copy) UpdateSucess block;

@end
