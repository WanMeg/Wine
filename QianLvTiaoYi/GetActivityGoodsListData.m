//
//  GetActivityGoodsListData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetActivityGoodsListData.h"

@implementation GetActivityGoodsListData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMActivityGoodsList mj_objectArrayWithKeyValuesArray:responseObj[@"activityGoodsList"]];
}

@end
