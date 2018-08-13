//
//  PRFilterCollectionView.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDictionary *(^FetchTextBlcok)(NSInteger idx);
typedef void(^FliterCVSelectedBlock)(NSIndexPath *index);

typedef NS_ENUM(NSInteger,PRFilterCollectionViewCellStyle)   {
    PRFilterCollectionViewCellFill,
    PRFilterCollectionViewCellStroke
};

@interface PRFilterCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>
@property(assign, nonatomic) NSInteger sectionCount;
@property(copy, nonatomic) FetchTextBlcok fetchTextBlock;
@property(copy, nonatomic) FliterCVSelectedBlock selectedBlock;
@property(assign, nonatomic) PRFilterCollectionViewCellStyle style;

- (void)updateDatasWithCellStyle:(PRFilterCollectionViewCellStyle)style sectionCount:(NSInteger)sectionCount fetchText:(FetchTextBlcok)fetchTextBlock;

@end
