//
//  HomeRecommendTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/7/20.
//  Copyright © 2019年 GIBX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendCollectionViewCell.h"
@interface HomeRecommendTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIView *backview;
@property (nonatomic, strong) NSArray *dataSourceArr;

@end
