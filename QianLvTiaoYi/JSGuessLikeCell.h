//
//  JSGuessLikeCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSGuessLikeCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray *goodsList;

@end
