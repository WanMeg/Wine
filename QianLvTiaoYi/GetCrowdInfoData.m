//
//  GetCrowdInfoData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/5.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetCrowdInfoData.h"

@implementation GetCrowdInfoData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMCrowdInfo mj_objectArrayWithKeyValuesArray:responseObj[@"info"]];
}

@end
