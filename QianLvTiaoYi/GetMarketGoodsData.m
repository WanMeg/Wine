//
//  GetMarketGoodsData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetMarketGoodsData.h"

@implementation GetMarketGoodsData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMMarketGoods mj_objectWithKeyValues:responseObj[@"goods"]];
}


@end
