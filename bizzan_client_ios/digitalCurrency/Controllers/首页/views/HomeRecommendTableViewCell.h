//
//  HomeRecommendTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2018/7/20.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendCollectionViewCell.h"
@interface HomeRecommendTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIView *backview;
@property (nonatomic, strong) NSArray *dataSourceArr;

@end
