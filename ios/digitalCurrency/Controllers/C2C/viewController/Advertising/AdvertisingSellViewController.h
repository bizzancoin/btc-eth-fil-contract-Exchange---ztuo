//
//  AdvertisingSellViewController.h
//  digitalCurrency
//
//  Created by iDog on 2019/1/31.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdvertisingDetailModel.h"

@interface AdvertisingSellViewController : BaseViewController
@property(nonatomic,assign)NSInteger index; //1 编辑界面进入
@property(nonatomic,strong)MyAdvertisingDetailModel *detailModel;
@end
