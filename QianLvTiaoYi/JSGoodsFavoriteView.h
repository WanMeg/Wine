//
//  JSGoodsFavoriteView.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSGoodsFavoriteView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *goodsFavCollectView;
@property(nonatomic, strong) NSMutableArray *goodsFavArray;
@property (nonatomic, copy) NSString *pageNumber;
@property(nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign)BOOL isDefaultStatus;

@property (weak, nonatomic) IBOutlet UILabel *goodsFavTipsLab;

@end
