//
//  GetMarketActivityData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetMarketActivityData.h"

@implementation GetMarketActivityData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMMarketActivity mj_objectArrayWithKeyValuesArray:responseObj[@"marketingRule"]];
}
@end
