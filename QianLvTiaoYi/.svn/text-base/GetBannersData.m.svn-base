//
//  GetBannersData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetBannersData.h"

@implementation GetBannersData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    NSArray *list = responseObj[@"advertByFloor"];
    return [WMBanners mj_objectArrayWithKeyValuesArray:list];
}


@end
