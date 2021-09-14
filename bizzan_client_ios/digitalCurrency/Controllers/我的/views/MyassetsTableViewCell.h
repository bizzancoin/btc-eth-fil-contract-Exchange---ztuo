//
//  MyassetsTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyassetsTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UILabel *titleview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,copy)void (^selectBlock)(NSInteger num);
@end
