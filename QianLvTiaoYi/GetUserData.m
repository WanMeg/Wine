//
//  GetUserData.m
//  TianCaiXiaoshou
//
//  Created by Gollum on 15/12/5.
//  Copyright © 2015年 Gollum. All rights reserved.
//

#import "GetUserData.h"


#define DB [PRDataBaseManager defaultDBManager].dataBase

#define kTABLE @"Member"
#define kDICTIONARY @"memberDict"
#define kID @"mallMemberId"

@implementation GetUserData


/**
 *  打开数据库并建表
 */
+ (void)initialize {
     [DB executeUpdate:@"CREATE TABLE IF NOT EXISTS t_Member (id integer PRIMARY KEY, mallMemberId integer NOT NULL, memberDict blob NOT NULL, isActivate integer NOT NULL)"];
}
/**
 *  重写父类方法 - 返回模型对象 并更新数据库
 *
 *  @param responseObj 请求返回的 Json对象
 *  @param modelClass  要生成的模型对象
 *
 *  @return 生成之后的模型
 */
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    NSDictionary *dict = responseObj[@"memberInfo"];
    [self saveMemberDict:dict];
    return [modelClass mj_objectWithKeyValues:dict];
}

/**
 *  保存或更新数据库Member对象
 *
 *  @param memberDict 对象字典
 */
+ (void)saveMemberDict:(NSDictionary *)memberDict {
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject: memberDict];
    
    //把所有数据更新为未激活状态
    NSString * query = [NSString stringWithFormat:@"UPDATE  t_Member SET isActivate = '%d' WHERE mallMemberId != '%@'",0, memberDict[kID]];
    [DB executeUpdate:query];

    //删除已有的ID数据
//    if ([self isExistWithTable:@"Member" column:@"mallMemberId" idStr:memberDict[@"mallMemberId"]]) {
    NSString * query1 = [NSString stringWithFormat:@"DELETE FROM t_Member WHERE mallMemberId = '%@'",memberDict[kID]];
    [DB executeUpdate:query1];
    //    }
    
    //插入新数据
    [DB executeUpdateWithFormat:@"INSERT INTO t_Member (mallMemberId, memberDict, isActivate) VALUES (%@, %@, %d)", memberDict[kID], dictData, 1];
}

/**
 *  取出数据库登录用户模型
 *
 *  @param callBack 回调 模型对象
 */
+ (Member *)fetchActivateMemberData {
    Member *member;
    FMResultSet *resultSet= [DB executeQuery:@"SELECT * FROM t_Member WHERE isActivate = ?",@"1"];
    while ([resultSet next])
    {
        NSData *dictData= [resultSet objectForColumnName:kDICTIONARY];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
        member = [Member mj_objectWithKeyValues:dict];
    }
    return member;
}

+ (void)deleteMemberLoginStatus {
    //把所有数据更新为未激活状态
    NSString * query = [NSString stringWithFormat:@"UPDATE  t_Member SET isActivate = '%d'", 0];
    [DB executeUpdate:query];
}


@end
