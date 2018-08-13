//
//  JSStoreFavCollRV.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSStoreFavCollRV : UICollectionReusableView

//店铺收藏区头

//店铺图标
@property (weak, nonatomic) IBOutlet UIImageView *storeFavHeaderIconImg;
//店铺名字
@property (weak, nonatomic) IBOutlet UILabel *storeFavHeaderNameLab;
//店铺地址
@property (weak, nonatomic) IBOutlet UILabel *storeFavHeaderAddressLab;
//店铺性质 （直营）
@property (weak, nonatomic) IBOutlet UILabel *storeFavHeaderBrandLab;
//进店逛逛
@property (weak, nonatomic) IBOutlet UIButton *enterStoreBtn;

//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@end
