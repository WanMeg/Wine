//
//  XLDataBase.m
//  XLNetwork
//
//  Created by Shelin on 15/11/18.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "XLDataBase.h"
#import <FMDB/FMDatabase.h>
#import "Item.h"
#import "MJExtension.h"

@implementation XLDataBase

static FMDatabase *_db;

+ (void)initialize {
    
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/Data.db",NSHomeDirectory()];
    
    _db = [FMDatabase databaseWithPath:path];
    
    [_db open];
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_Member (id integer PRIMARY KEY, appToken text NOT NULL, userName text NOT NULL, headPortrait text, mallMemberId integer NOT NULL, proCode text, realName text)"];
}

+ (void)saveItemDict:(NSDictionary *)itemDict {
    
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:itemDict];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_item (itemDict, idStr) VALUES (%@, %@)",dictData, itemDict[@"id"]];
}

+ (NSArray *)list {

    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_item"];
    NSMutableArray *list = [NSMutableArray array];
    
    while (set.next) {
        // 获得当前所指向的数据
        NSData *dictData = [set objectForColumnName:@"itemDict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        [list addObject:[Item mj_objectWithKeyValues:dict]];
    }
    return list;
}

+ (NSArray *)listWithRange:(NSRange)range {
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM t_item LIMIT %lu, %lu",(unsigned long)range.location, (unsigned long)range.length];
    FMResultSet *set = [_db executeQuery:SQL];
    NSMutableArray *list = [NSMutableArray array];
    
    while (set.next) {
        // 获得当前所指向的数据
        
        NSData *dictData = [set objectForColumnName:@"itemDict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        [list addObject:[Item mj_objectWithKeyValues:dict]];
    }
    return list;
}

+ (BOOL)isExistWithId:(NSString *)idStr
{
    BOOL isExist = NO;
    FMResultSet *resultSet= [_db executeQuery:@"SELECT * FROM t_Member where idStr = ?",idStr];
    while ([resultSet next]) {
        if([resultSet stringForColumn:@"idStr"]) {
            isExist = YES;
        }else{
            isExist = NO;
        }
    }
    return isExist;
}


@end
