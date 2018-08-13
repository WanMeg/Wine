//
//  GetCommentBannerData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/29.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetCommentBannerData.h"

@implementation GetCommentBannerData


+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    NSArray *list = responseObj[@"advertByFloor"];
    return [WMCommentBanner mj_objectArrayWithKeyValuesArray:list];
}

@end
