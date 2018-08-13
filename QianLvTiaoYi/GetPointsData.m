//
//  GetPointsData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/21.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetPointsData.h"

@implementation GetPointsData


+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMPoints mj_objectWithKeyValues:responseObj];
}

@end
