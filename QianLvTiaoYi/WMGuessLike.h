//
//  WMGuessLike.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/3.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGuessLike : NSObject

//猜你喜欢 推荐 model

@property (nonatomic, strong) NSMutableArray *remaiGoods;


@end

@interface WMGuess : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *title; //商城标题
@property (nonatomic, assign) int goodsSales; //销量
@property (nonatomic, assign) float wholesalePrice; //批发
@property (nonatomic, assign) float goods_retail_price;//市场
@property (nonatomic, copy) NSString *tag;//关键字
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@end
