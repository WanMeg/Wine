//
//  GetPersonalInfoData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetPersonalInfoData.h"


@implementation GetPersonalInfoData
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSDictionary *dict = responseObj[@"memberInfo"];
    return [PersonalInfo mj_objectWithKeyValues:dict];
}
@end
