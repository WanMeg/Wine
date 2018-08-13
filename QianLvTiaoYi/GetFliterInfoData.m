//
//  GetFliterInfoData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/20.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetFliterInfoData.h"

@implementation GetFliterInfoData


+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [WMFliterInfo mj_objectWithKeyValues:responseObj];;
}

@end
