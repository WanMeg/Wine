//
//  ParentOrder.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentOrder : NSObject

@property (copy, nonatomic) NSString *orderInfoId;      
@property (copy, nonatomic) NSString *deliveryAddressId;    //收货城市id
@property (copy, nonatomic) NSString *orderNo;      //订单编号
@property (copy, nonatomic) NSString *orderPeople;  //收货人名
@property (assign, nonatomic) int status;           //订单状态
@property (copy, nonatomic) NSString *orderTime;    //订单时间
@property (copy, nonatomic) NSString *orderTotalorderId;//订单id
@property (copy, nonatomic) NSString *shopName;     //店铺名称
@property (assign, nonatomic) float realityCost;    //实际付款
@property (copy, nonatomic) NSString *usingTotalIntegralNumber;

@property (copy, nonatomic) NSString *orderType;    //订单类型
@property (copy, nonatomic) NSString *zcStatus;     //众筹活动是否结束
@property (copy, nonatomic) NSString *zcPayStatus;  //众筹订单支付状态
@property (assign, nonatomic) float handsel;      //众筹定金
@property (assign, nonatomic) float endMoney;     //众筹尾款


@property (strong, nonatomic) NSMutableArray *ordersGoods; //订单下的商品

+ (NSMutableArray *)createTempParentOrderListWithCount:(int)count;

@end


@interface OrderGoods : NSObject

@property (copy, nonatomic) NSString *goodsId;  //商品id
@property (copy, nonatomic) NSString *goodsName;    //商品名称
@property (copy, nonatomic) NSString *goodsNumber;  //
@property (assign, nonatomic) float goodsPrice;   //价格
@property (copy, nonatomic) NSString *imgUrl;       //图片地址
@property (copy, nonatomic) NSString *productId;    //产品id
@property (assign, nonatomic) int quantity;         //数量
@property (copy, nonatomic) NSString *spec;    //商品规格
@property (copy, nonatomic) NSString *realityPrice;    //实际付款
@property (copy, nonatomic) NSString *activityName;    //活动名称

@end
