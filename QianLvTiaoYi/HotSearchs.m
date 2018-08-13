//
//  HotSearchs.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/3.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "HotSearchs.h"


@implementation HotSearchs


- (void)setName:(NSString *)name {
    _name = name;
    _size =[name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}
@end
