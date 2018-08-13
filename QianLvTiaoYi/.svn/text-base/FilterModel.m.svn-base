//
//  FilterModel.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


+(NSArray *)makeArrary {
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        FilterModel *fm = [[FilterModel alloc] init];
        fm.keywords = [NSString stringWithFormat:@"%d%d%d%d", i,i,i,i];
        fm.expand = NO;
        [list addObject:fm];
    }
    return list;
}

@end
