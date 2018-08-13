//
//  GetCategoryData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetCategoryData.h"

@implementation GetCategoryData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSArray *list = responseObj[@"productCategory"];
    if([list isKindOfClass:[NSNull class]]){
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        [array addObject:[CategoryInfo mj_objectWithKeyValues:dict]];
    }
    return array;
}
@end
