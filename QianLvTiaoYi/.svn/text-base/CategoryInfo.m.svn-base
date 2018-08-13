//
//  CategoryInfo.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/13.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "CategoryInfo.h"
#import <MJExtension/MJExtension.h>


@implementation Advert


@end


@implementation CategoryInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"childrenCategorys" : @"CategoryInfo"};
}

+ (NSMutableArray *)createTempCategoryInofList{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CategoryPlist" ofType:@"plist"];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *array = [CategoryInfo filterCategoryWithArray:plistArr cateID:@"0"];
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        NSString *cateID = mDic[@"productCategoryId"];
        NSArray * preArr1 = [CategoryInfo filterCategoryWithArray:plistArr cateID:cateID];
        NSMutableArray *list2 = [NSMutableArray array];
        
        for (int k = 0; k < preArr1.count; k++) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:preArr1[k]];
            NSString *cateID = mDic[@"productCategoryId"];
            NSArray *preArr2 = [CategoryInfo filterCategoryWithArray:plistArr cateID:cateID];
            [mDic addEntriesFromDictionary:@{@"childnumCategory": preArr2}];
            [list2 addObject:mDic];
        }
        
        [mDic addEntriesFromDictionary:@{@"childnumCategory": list2}];
        [list addObject:mDic];
    }
    return [CategoryInfo mj_objectArrayWithKeyValuesArray:list];
//    NSPredicate *predic=[NSPredicate predicateWithFormat:@"parentId=%@", @"0"];
//    NSMutableArray *preArr1 = [NSMutableArray arrayWithArray:[arr filteredArrayUsingPredicate:predic]];
//    for (int i = 0; i<preArr1.count; i++) {
//        NSString *cateID = preArr1[i][@"productCategoryId"];
//        NSPredicate *predic=[NSPredicate predicateWithFormat:@"parentId=%@", cateID];
//        NSArray *preArr2 = [arr filteredArrayUsingPredicate: predic];
//        
//        if (preArr2 && preArr2.count != 0) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:preArr1[i]];
//            [dic addEntriesFromDictionary:@{@"childnumCategory": preArr2}];
//            
//            for (int k = 0; k<preArr2.count; k++) {
//                NSString *cateID = preArr2[k][@"productCategoryId"];
//                NSPredicate *predic=[NSPredicate predicateWithFormat:@"parentId=%@", cateID];
//                NSArray *preArr3 = [arr filteredArrayUsingPredicate: predic];
//                if (preArr3 && preArr3.count != 0) {
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:preArr2[k]];
//                    [dic addEntriesFromDictionary:@{@"childnumCategory": preArr3}];
//                }
//            }
//        }
//    }
//    NSLog(@"%ld", preArr1.count);
//    
//    return [CategoryInfo objectArrayWithKeyValuesArray:preArr1];;
}


+ (NSArray*)filterCategoryWithArray:(NSArray *)array cateID:(NSString *)cateID{
    NSPredicate *predic=[NSPredicate predicateWithFormat:@"parentId=%@", cateID];
    NSArray *preArr = [array filteredArrayUsingPredicate: predic];
    return preArr;
}
@end
