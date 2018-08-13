//
//  GetSystemNewsData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetSystemNewsData.h"

@implementation GetSystemNewsData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMSystemNews mj_objectArrayWithKeyValuesArray:responseObj[@"newsList"]];
}

@end
