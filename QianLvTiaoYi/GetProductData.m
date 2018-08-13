//
//  GetProductData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetProductData.h"

@implementation GetProductData


+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [Product mj_objectWithKeyValues:responseObj[@"product"]];
}
@end
