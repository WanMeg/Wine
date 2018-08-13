//
//  GetShoppingCartData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetShoppingCartData.h"

@implementation GetShoppingCartData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [CartShopModel mj_objectArrayWithKeyValuesArray:responseObj[@"shoppingCart"]];
}
@end
