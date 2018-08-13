//
//  GetCommentsData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetCommentsData.h"


@implementation GetCommentsData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMComments mj_objectWithKeyValues:responseObj];
}

@end
