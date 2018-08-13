//
//  FilterModel.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterModel : NSObject
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, getter=isExpand) BOOL expand;

+(NSArray *)makeArrary;
@end
