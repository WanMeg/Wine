//
//  GetWeixinPayData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetWeixinPayData.h"

@implementation GetWeixinPayData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return [OutTradeOrder mj_objectWithKeyValues:responseObj[@"prepay_id"]];
}
@end
