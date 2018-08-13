//
//  GetAreaData.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/11.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "GetAreaData.h"

@implementation GetAreaData

/**
 *  打开数据库并建表
 */
+ (void)initialize {
    [DB executeUpdate:@"CREATE TABLE IF NOT EXISTS t_Area (gmAreaId text PRIMARY KEY, code text, parentId text, name text, level text)"];
}

+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSArray *list = responseObj[@"area"];
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    for (NSDictionary *dict  in list) {
//        NSLog(@"========%@", dict);
        [self saveAreaData:dict];
        [array addObject:[Area mj_objectWithKeyValues:dict]];
        i++;
    }
    return array;
}


+(NSArray *)makeAreaDataXml {
    NSArray *list = [self fetchAreaDataWithParent_id:@"0"];
    for (int i = 0; i < list.count; i++) {
        NSMutableDictionary *mDict =list[i];
        NSString *areaID = mDict[@"code"];
        NSArray *list1 = [self fetchAreaDataWithParent_id:areaID];
        [mDict addEntriesFromDictionary:@{@"subAreaList": list1}];
        for (int i = 0; i < list1.count; i++) {
            NSMutableDictionary *mDict =list1[i];
            NSString *areaID = mDict[@"code"];
            NSArray *list2 = [self fetchAreaDataWithParent_id:areaID];
            [mDict addEntriesFromDictionary:@{@"subAreaList": list2}];
        }
    }
    return list;
}

+ (NSArray *)fetchAreaDataWithParent_id:(NSString *)parent_id{
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM t_Area WHERE parentId = '%@'", parent_id];
    FMResultSet *set = [DB executeQuery:SQL];
    NSMutableArray *list = [NSMutableArray array];
   
    while (set.next) {
        // 获得当前所指向的数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict addEntriesFromDictionary:@{@"code": [set objectForColumnName:@"code"],
                                         @"parentId": [set objectForColumnName:@"parentId"],
                                         @"name": [set objectForColumnName:@"name"]}];
        [list addObject:dict];
//         NSLog(@"%@", dict[@"parentId"]);
    }
    return list;
}



+ (void)saveAreaData:(NSDictionary *)dict {
    //插入新数据
    [DB executeUpdateWithFormat:@"INSERT INTO t_Area (gmAreaId, code, parentId, name, level) VALUES (%@, %@, %@, %@, %@)", dict[@"gmAreaId"], dict[@"code"], dict[@"parentId"], dict[@"name"], dict[@"level"]];
}
@end
