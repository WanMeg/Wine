//
//  GetFavoriteData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/23.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetFavoriteData.h"

@implementation GetFavoriteData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [Goods mj_objectArrayWithKeyValuesArray:responseObj[@"goods"]];
}
@end
