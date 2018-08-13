//
//  ChildOrder.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "ParentOrder.h"

@interface ChildOrder : NSObject

@property(nonatomic, copy) NSString *deliveryAddressId;
@property(nonatomic, strong) Address *mallDeliveryAddres;
@property(nonatomic, copy) NSString *orderNo;
@property(nonatomic, copy) NSString *orderStatus;
@property(nonatomic, assign) int totalStatus; //订单总状态
@property(nonatomic, copy) NSString *orderTime;
@property(nonatomic, copy) NSString *orderTotalOrderId;
@property(nonatomic, copy) NSString *payTime;
@property(nonatomic, strong) NSMutableArray *orderGoods;

@property(nonatomic, copy) NSString *payStatus;
@property(nonatomic, copy) NSString *totalPrice;
@property(nonatomic, copy) NSString *usingIntegral;


@property(nonatomic, copy) NSString *shopName;//店铺名称
@property(nonatomic, copy) NSString *payWayName;//支付方式
@property(nonatomic, copy) NSString *deliveryWayName;//配送信息
@property(nonatomic, copy) NSString *receiptHead; //发票抬头
@property(nonatomic, copy) NSString *receiptContent;//发票内容
@property(nonatomic, assign) float totalFreight;//总运费
@property(nonatomic, assign) float realityCost;//实际支付
@property(nonatomic, copy) NSString *createTime;//下单时间
@property(nonatomic, assign) float totalReality;//支付总额

@property(nonatomic, assign) float preferentialPrice;//优惠
@property(nonatomic, copy) NSString *receiverName;//收货人名
@property(nonatomic, copy) NSString *receiverPhone;//收货人电话
@property(nonatomic, copy) NSString *address;//邮编
@property(nonatomic, copy) NSString *receiverMobile;//手机号


@end

@interface WMOrderGoods : NSObject


@property(nonatomic, copy) NSString *goodsSpec;//规格
@property(nonatomic, copy) NSString *productId;//产品id
@property(nonatomic, copy) NSString *goodsId;//商品id
@property(nonatomic, copy) NSString *goodsImgUrl;//图片
@property(nonatomic, copy) NSString *goodsName;//名称
@property(nonatomic, assign) int quantity;//数量
@property(nonatomic, assign) float goodsRealityPrice;//单价
@property(nonatomic, assign) int sonStatus;//状态
@property(nonatomic, copy) NSString *orderGoodsId;//订单明细ID

//@property(nonatomic, strong) NSArray *orderGoods;
//
//
//@property(nonatomic, copy) NSString *all_status;
//@property(nonatomic, copy) NSString *cargono;
//@property(nonatomic, copy) NSString *child_tstatus;
//@property(nonatomic, copy) NSString *close_user;
//@property(nonatomic, copy) NSString *desc;
//@property(nonatomic, copy) NSString *memberid;
//@property(nonatomic, copy) NSString *orderno;
//@property(nonatomic, copy) NSString *orders_id;
//@property(nonatomic, copy) NSString *parentorder;
//@property(nonatomic, copy) NSString *price;
//@property(nonatomic, copy) NSString *source_shop;
//@property(nonatomic, copy) NSString *update_time;

@end
