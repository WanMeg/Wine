//
//  GetAddressListData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetAddressListData.h"

@implementation GetAddressListData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSArray *list = responseObj[@"memberAddress"];
    return [Address mj_objectArrayWithKeyValuesArray:list];
}

@end
