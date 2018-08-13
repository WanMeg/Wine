//
//  WMCalculatePrice.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/4.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCalculatePrice : NSObject

/**计算价格*/
@property (nonatomic, copy) NSString *points;//积分数
@property (nonatomic, copy) NSString *distribution;//地址id
@property (nonatomic, strong) NSArray *jsonString;


@property (nonatomic, copy) NSString *availableIntegral;//积分
@property (nonatomic, copy) NSString *totalIntegral;//总积分
@property (nonatomic, copy) NSString *usableIntegral;//可以积分
@property (nonatomic, strong) NSArray *orderJsons;//店铺订单

@property (nonatomic, copy) NSString *totalPrice;//总价
@property (nonatomic, assign) float postPrice;//总邮费
@property (nonatomic, assign) float profit;//总抵扣

@end


@interface WMJsonString : NSObject

@property (nonatomic, copy) NSString *shopId;//店铺id
@property (nonatomic, copy) NSString *preferentialId;//红包id
@property (nonatomic, strong) NSArray *shoppingCartIds;

@end



@interface WMShopCartId : NSObject

@property (nonatomic, copy) NSString *shoppingCartId;//商品购物车id
@property (nonatomic, copy) NSString *hdId;//商品活动id

@end