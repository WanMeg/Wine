//
//  CommitOrder.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/24.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCart.h"

@interface CommitOrder : NSObject

/*提交订单*/

@property (nonatomic, copy) NSString *availableIntegral;
@property (nonatomic, copy) NSString *totalIntegral;
@property (nonatomic, strong) NSArray *orderJsons;
@property (nonatomic, copy) NSString *usableIntegral;
@property (nonatomic, assign) float postPrice;//总邮费
@property (nonatomic, assign) float profit;//抵扣
@property (nonatomic, assign) float goodsPrice;//商品总价
@property (nonatomic, copy) NSString *totalPrice;//支付总价

@end

@interface OrderJson : NSObject
//店铺订单
@property (nonatomic, strong) NSArray *mallCoupons; /**红包**/
@property (nonatomic, strong) NSArray *orderDetailJsons;
@property (nonatomic, copy) NSString *postPrice;
@property (nonatomic, copy) NSString *price;     /**<店铺总价*/
@property (nonatomic, copy) NSString *productCount;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, strong) NSArray *distributions;   /**<配送方式*/
@property (nonatomic, strong) NSArray *privileges ;     /**<店铺优惠*/

@end

@interface Distribution : NSObject
//配送方式
@property (nonatomic, copy) NSString *distributionId;
@property (nonatomic, copy) NSString *distributionName;
@end


@interface Privilege : NSObject
//优惠
@property (nonatomic, copy) NSString *hdId;
@property (nonatomic, copy) NSString *hdType;
@property (nonatomic, copy) NSString *privilegeName;
@end

@interface OrderDetailJson : NSObject
//订单商品
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *shoppingcartId;
@property (nonatomic, strong) ShoppingCart *shoppingcart;
@property (nonatomic, strong) NSArray *privileges;     /**<优惠*/
@end

@interface MallCoupon : NSObject
//可选择红包
@property (nonatomic, copy) NSString *couponName;//名称
@property (nonatomic, copy) NSString *mallCouponId;//id
@property (nonatomic, copy) NSString *couponImg;//图片
@property (nonatomic, copy) NSString *couponQuota;//额度
@property (nonatomic, copy) NSString *useCondition;//条件
@property (nonatomic, copy) NSString *validStartTime;
@property (nonatomic, copy) NSString *couponDepict;//描述
@property (nonatomic, copy) NSString *validEndTime;


@end
