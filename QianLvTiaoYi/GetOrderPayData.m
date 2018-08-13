//
//  GetOrderPayData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetOrderPayData.h"

@implementation GetOrderPayData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [WMOrderPay mj_objectWithKeyValues:responseObj[@"order"]];
}
@end
