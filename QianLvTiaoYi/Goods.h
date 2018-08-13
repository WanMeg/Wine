//
//  Goods.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject
@property (copy, nonatomic) NSString *imgUrl; /**<商品图片*/
@property (copy, nonatomic) NSString *goodsImage;
@property (copy, nonatomic) NSString *goodsId; /**<商品ID*/
@property (copy, nonatomic) NSString *name;/**<商品名称*/
@property (copy, nonatomic) NSString *goodsName;/**<商品名称*/
@property (assign, nonatomic) float goodsPrice;/**<商品价格*/
@property (nonatomic, assign) float price;/**<商品价格*/
@property (copy, nonatomic) NSString *goodsSpec;/**<销售数量*/
@property (copy, nonatomic) NSString *maxPrice;
@property (copy, nonatomic) NSString *minPrice;
@property (copy, nonatomic) NSString *unit;
@property (copy, nonatomic) NSString *sharePath; //商品分享链接地址

@property (assign, nonatomic) double wholesalePrice;   //批发价
@property (assign, nonatomic) double marketPrice;        //市场价
@property (assign, nonatomic) double retailPrice;          //零售价
@property (assign, nonatomic) int goodsSales;               //销量

@property (copy, nonatomic) NSString *title; /**<标题*/
@property (copy, nonatomic) NSString *clickNum; /**<点击数量*/
@property (copy, nonatomic) NSString *collectNum;/**<收藏数量*/
@property (copy, nonatomic) NSString *isNewGoods;/**<是否新品*/
@property (copy, nonatomic) NSString *isGroom;/**<是否推荐*/
@property (copy, nonatomic) NSString *isDistribution; /**<是否分销商品*/
@property (copy, nonatomic) NSString *isSpecimen; /**<是否样品*/
@property (copy, nonatomic) NSString *salesTerritory;/**<销售区域*/
@property (copy, nonatomic) NSString *isUsingIntegral;/**<是否可使用积分*/
@property (copy, nonatomic) NSString *isUsingCoupons;/**<是否可使用优惠劵*/
@property (copy, nonatomic) NSString *isActivity; /**<是否活动*/



+ (NSMutableArray *)creatTempGoodsListWithCount: (int)count;

@end
