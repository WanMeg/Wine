//
//  GetOrderListData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/29.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetOrderListData.h"

@implementation GetOrderListData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [ParentOrder mj_objectArrayWithKeyValuesArray:responseObj[@"totalorders"]];
}
@end
