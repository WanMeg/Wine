//
//  GetThreeCountData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/22.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetThreeCountData.h"

@implementation GetThreeCountData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSDictionary *dict = responseObj[@"count"];
    return [WMThreeCount mj_objectWithKeyValues:dict];
}

@end
