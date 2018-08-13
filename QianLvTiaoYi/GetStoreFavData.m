//
//  GetStoreFavData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetStoreFavData.h"

@implementation GetStoreFavData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMStoreFav mj_objectArrayWithKeyValuesArray:responseObj[@"collectShop"]];
}

@end
