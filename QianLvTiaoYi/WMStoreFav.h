//
//  WMStoreFav.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMStoreFav : NSObject

/* 店铺收藏 */
@property (nonatomic, copy) NSString *shopname;     //店名
@property (nonatomic, copy) NSString *shopLogo;     //logo
@property (nonatomic, copy) NSString *shopId;       //店铺id
@property (nonatomic, assign) int shopType;     //店铺类型
@property (nonatomic, copy) NSString *province;     //省
@property (nonatomic, copy) NSString *city;         //市
@property (nonatomic, copy) NSString *district;     //区

@property (nonatomic, strong) NSArray *mapGoods;    //商品信息

@end


@interface WMMapGoods : NSObject

@property (nonatomic, copy) NSString *goodsId;          //商品id
@property (nonatomic, copy) NSString *imgUrl;           //商品图片
@property (nonatomic, copy) NSString *unit;             //单位
@property (nonatomic, copy) NSString *title;            //商城标题
@property (nonatomic, assign) float goodsWholesalePrice;//批发价
@property (nonatomic, assign) float goodsWeight;      //重量
@property (nonatomic, assign) float goodsRetailPrice;   //零售价
@property (nonatomic, copy) NSString *goodsName;        //商品名称
@property (nonatomic, assign)int goodsSales;         //销售数量

@end