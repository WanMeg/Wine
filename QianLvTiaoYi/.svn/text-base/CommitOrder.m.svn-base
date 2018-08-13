//
//  CommitOrder.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/24.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "CommitOrder.h"
#import "ConfirmOrder.h"

@implementation CommitOrder
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"orderJsons" : @"OrderJson"};
}

@end

//配送方式
@implementation Distribution



@end


//订单详情
@implementation OrderJson

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"orderDetailJsons" : @"OrderDetailJson",
             @"mallCoupons": @"MallCoupon",
             @"distributions": @"Distribution",
             @"privileges" : @"Privilege"};
}

@end


//优惠
@implementation Privilege


@end

//单个订单明细
@implementation OrderDetailJson

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc": @"description"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"privileges" : @"Privilege"};
}

@end

@implementation MallCoupon



@end
