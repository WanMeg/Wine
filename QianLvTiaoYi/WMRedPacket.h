//
//  WMRedPacket.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/27.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMRedPacket : NSObject

@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSMutableArray *countAll;
@property (nonatomic, strong) NSMutableArray *couponList;

@end

// 会员红包model //
@interface WMCoupon : NSObject

@property (nonatomic, copy) NSString *mallCouponId;//红包id
@property (nonatomic, copy) NSString *memberCouponId;//会员红包id
@property (nonatomic, copy) NSString *couponCode;//红包编码
@property (nonatomic, copy) NSString *couponName;//红包名称
@property (nonatomic, copy) NSString *couponQuota;//红包金额
@property (nonatomic, copy) NSString *couponSource;//红包来源
@property (nonatomic, copy) NSString *acquireTime;//获得时间
@property (nonatomic, copy) NSString *useTime;//使用时间
@property (nonatomic, copy) NSString *status;//红包状态
@property (nonatomic, copy) NSString *useCondition;//使用条件
@property (nonatomic, assign) int useScope;//使用平台
//@property (nonatomic, copy) NSString *validStartTime;//有效开始时间
//@property (nonatomic, copy) NSString *validEndTime;//有效结束时间
@property (nonatomic, strong) NSDictionary *validStartTime;//可领取开始时间
@property (nonatomic, strong) NSDictionary *validEndTime;//可领取结束时间
@property (nonatomic, copy) NSString *couponImg;//红包图片

@end


@interface WMRedCount : NSObject
// 红包数量 //
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int status;

@end
