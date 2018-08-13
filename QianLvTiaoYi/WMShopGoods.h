//
//  WMShopGoods.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/16.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSGCounts.h"
#import "WMMallShop.h"

@interface WMShopGoods : NSObject

@property (nonatomic, strong) NSMutableArray *adverts;//轮播图数组
@property (nonatomic, strong) WMSGCounts *counts;//三个数量
@property (nonatomic, assign) BOOL isCollect; //是否收藏
@property (nonatomic, strong) WMMallShop *mallShop;//店铺信息

@end


@interface WMAdverts : NSObject

@property (nonatomic, copy) NSString *imgUrl;

@end