//
//  GetConsumeDetailData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetConsumeDetailData.h"

@implementation GetConsumeDetailData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMConsumeDetail mj_objectArrayWithKeyValuesArray:responseObj[@"consumes"]];
}

@end
