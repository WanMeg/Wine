//
//  GetGoodsListData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetGoodsListData.h"

@implementation GetGoodsListData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
        NSArray *list = responseObj[@"goodsList"];
        return [Goods mj_objectArrayWithKeyValuesArray:list];
}
@end