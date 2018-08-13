//
//  GoodsBaseInfo.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/16.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsBaseInfo : NSObject

@property (nonatomic, assign) NSInteger clickNum;
@property (nonatomic, assign) NSInteger collectNum;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *customerDetails;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *detailPath;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, assign) float goodsPrice;
@property (nonatomic, assign) NSInteger goodsSales;
@property (nonatomic, copy) NSString *invoice;
@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) BOOL isAutotrophy;
@property (nonatomic, assign) BOOL isGroom;
@property (nonatomic, assign) BOOL isInvoice;
@property (nonatomic, assign) BOOL isNewGoods;
@property (nonatomic, assign) BOOL isSpecimen;
@property (nonatomic, assign) BOOL isUsingCoupons;
@property (nonatomic, assign) BOOL isUsingIntegral;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *proCode;
@property (nonatomic, copy) NSString *proLink;
@property (nonatomic, copy) NSString *salesTerritory;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, assign) NSInteger startNum;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *sharePath;
@property (nonatomic, copy) NSString *partakeNumber;   /**<团购数量*/
@property (nonatomic, assign) float goodsRebate;  /**<折扣*/
@property (nonatomic, assign) NSInteger goodsType;     /**<商品类型*/
@property (nonatomic, assign) NSInteger usingIntegralLimit; /**<可获得积分*/
@property (nonatomic, assign) NSInteger awardedNum;      /**<已购百分比*/
@property (nonatomic, copy) NSString *endTime;           /**<抢购结束时间*/
@property (nonatomic, copy) NSString *beginTime;        /**<抢购开始时间*/

@end
