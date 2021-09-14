//
//  AdvertisingSellViewController.h
//  digitalCurrency
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdvertisingDetailModel.h"

@interface AdvertisingSellViewController : BaseViewController
@property(nonatomic,assign)NSInteger index; //1 编辑界面进入
@property(nonatomic,strong)MyAdvertisingDetailModel *detailModel;
@end
