//
//  GetHelpPayData.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/28.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "GetHelpPayData.h"

@implementation GetHelpPayData

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass
{
    NSDictionary *dict = responseObj[@"articleList"];
    return [WMHelpPay mj_objectWithKeyValues:dict];
}

@end
