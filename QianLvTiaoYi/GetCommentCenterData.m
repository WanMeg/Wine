//
//  GetCommentCenterData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetCommentCenterData.h"

@implementation GetCommentCenterData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    NSArray *list = responseObj[@"comments"];
    return [WMCommentData mj_objectArrayWithKeyValuesArray:list];
}
@end
