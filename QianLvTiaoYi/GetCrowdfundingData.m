//
//  GetCrowdfundingData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/1.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetCrowdfundingData.h"

@implementation GetCrowdfundingData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMCrowdfunding mj_objectArrayWithKeyValuesArray:responseObj[@"allCrowdfund"]];
}


@end
