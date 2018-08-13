//
//  JSGuessLikeCV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/12.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSGuessLikeCV.h"

@implementation JSGuessLikeCV

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    
    self.pagingEnabled = YES;
}


/**
 *  获取猜你喜欢数据
 */
//- (void)getGuessLikeRequestData
//{
//    __weak typeof(self) weakSelf = self;
//    
//    [GetGuessLikeData postWithUrl:RMRequestStatusRecommentGoods param:nil modelClass:[WMGuessLike class] responseBlock:^(id dataObj, NSError *error)
//     {
//         if (dataObj)
//         {
//             [weakSelf.guessLikeArray addObjectsFromArray:dataObj];
//         }
//     }];
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return _goodsList.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    JSGuessLikeCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"guessLikeCell" forIndexPath:indexPath];
//    
////    WMGuessLike *guess = _guessLikeArray[indexPath.row];
//    Goods *goods = _goodsList[indexPath.row];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
//    
//    return cell;
//}

@end
