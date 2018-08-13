//
//  GetShopDetailData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/17.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetShopDetailData.h"

@implementation GetShopDetailData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMShopDetail mj_objectWithKeyValues:responseObj];;
}

@end
