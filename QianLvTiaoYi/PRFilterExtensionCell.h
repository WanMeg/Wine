//
//  PRFilterExtensionCell.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRFilterCollectionView.h"

typedef void(^ExpandActionBlock)(BOOL isExpand);

@interface PRFilterExtensionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PRFilterCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (getter=isExpand, nonatomic) BOOL expand;
@property (copy, nonatomic) ExpandActionBlock expandActionBlock;


- (void)updateDatasWithCount:(NSInteger)count fetchTextBlock:(FetchTextBlcok)fetchTextBlock;
@end
