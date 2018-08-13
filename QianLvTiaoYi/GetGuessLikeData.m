//
//  GetGuessLikeData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/3.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetGuessLikeData.h"

@implementation GetGuessLikeData

//+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
//    
//    NSMutableArray *list = responseObj[@"remaiGoods"];
//    return [WMGuessLike mj_objectArrayWithKeyValuesArray:list];
//}
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    return [WMGuessLike mj_objectWithKeyValues:responseObj[@"remaiGoods"]];
}

@end
