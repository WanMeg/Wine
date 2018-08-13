//
//  SubModel.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/11.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "SubModel.h"

@implementation SubModel

- (void)setName:(NSString *)name {
    _name = name;
    if ([name rangeOfString:@"null"].length > 0) {
        _name = @"";
    }
}

@end
