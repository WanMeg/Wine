//
//  GetGoodsFavData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/22.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetGoodsFavData.h"

@implementation GetGoodsFavData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    NSArray *list = responseObj[@"goods"];
    return [WMGoodsFav mj_objectArrayWithKeyValuesArray:list];
}
@end
