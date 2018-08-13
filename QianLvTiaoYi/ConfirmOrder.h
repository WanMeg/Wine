//
//  ConfirmOrder.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/25.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfirmOrder : NSObject
@property (nonatomic, copy) NSString *shopId;   //店铺id
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, strong) NSArray *mallMarketingRule;//店铺活动
@property (nonatomic, strong) NSArray *createOrderCoupon;//店铺红包
@property (nonatomic, strong) NSArray *createOrderGoods;//店铺商品

@end

@interface ConfirmOrderGoods : NSObject
@property (nonatomic, copy) NSString *usingIntegralLimit;      //可用积分
@property (nonatomic, copy) NSString *goodsName;               //商品名称
@property (nonatomic, copy) NSString *goodsId;                 //商品ID
@property (nonatomic, copy) NSString *productId;               //产品ID
@property (nonatomic, assign) float postPrice;                 //邮费
@property (nonatomic, copy) NSString *hdType;                  //活动类型
@property (nonatomic, copy) NSString *hdId;                    //商品活动ID
@property (nonatomic, assign) NSInteger number;                //购买数量
@end

@interface MallMarketingRule : NSObject

@property (nonatomic, copy) NSString *mallMarketingRuleId;

@end


@interface CreateOrderCoupon : NSObject

@property (nonatomic, copy) NSString *mallCouponId;

@end
