//
//  GetLogisticsInfoData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/28.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetLogisticsInfoData.h"

@implementation GetLogisticsInfoData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [WMLogisticsInfo mj_objectArrayWithKeyValuesArray:responseObj[@"posts"]];
}
@end
