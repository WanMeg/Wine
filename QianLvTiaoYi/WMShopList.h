//
//  WMShopList.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/17.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMShopList : NSObject

/** 店铺列表 **/

@property (nonatomic, copy) NSString *mallShopId;// id
@property (nonatomic, copy) NSString *distance;//距离
@property (nonatomic, copy) NSString *shopLogo;// logo
@property (nonatomic, copy) NSString *shopTitile;//标题
@property (nonatomic, copy) NSString *shopNotice;// 公告
@property (nonatomic, copy) NSString *shopName;//名称
@property (nonatomic, copy) NSString *shopType;// 类型
@property (nonatomic, copy) NSString *shopLabel;//标签
@property (nonatomic, copy) NSString *shopDepict;//描述
@property (nonatomic, copy) NSString *companyAddress;//地址


@property (nonatomic, strong) NSMutableArray *goodsList;// 商品列表


@end


@interface WMShopGoodsList : NSObject

@property (nonatomic, copy) NSString *imgUrl;// 图片
@property (nonatomic, assign) float goodsPrice;//当前价格
@property (nonatomic, assign) float price;// 批发价格
@property (nonatomic, copy) NSString *goodsId;//id
@property (nonatomic, copy) NSString *des;//描述
@property (nonatomic, copy) NSString *title;// 标题
@property (nonatomic, assign) int goodsSales;//销量
@property (nonatomic, copy) NSString *unit;// 单位
@property (nonatomic, copy) NSString *tag;//搜索字段
@property (nonatomic, copy) NSString *name;//名称


@end