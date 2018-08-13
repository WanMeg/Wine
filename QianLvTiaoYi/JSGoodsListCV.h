//
//  JSGoodsListCV.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"
typedef Goods *(^FetchGoodsBlcok)(NSInteger idx);
typedef void(^HP_CV_SelectedBlock)(NSInteger idx);

@interface JSGoodsListCV : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>
@property(assign, nonatomic) NSInteger itemsCount;
@property(copy, nonatomic) FetchGoodsBlcok fetchGoodsBlock;
@property (copy, nonatomic) HP_CV_SelectedBlock selectedBlock;

- (void)updateDatasWithSectionCount:(NSInteger)itemsCount
                          fetchText:(FetchGoodsBlcok)fetchGoodsBlock;
@end
