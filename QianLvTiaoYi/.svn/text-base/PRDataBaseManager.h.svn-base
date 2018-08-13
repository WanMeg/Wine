//
//  PRDataBaseManager.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/7.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
@interface PRDataBaseManager : NSObject
/// 数据库操作对象，当数据库被建立时，会存在次至
@property (nonatomic, readonly) FMDatabase * dataBase;  // 数据库操作对象
/// 单例模式
+(instancetype) defaultDBManager;

// 关闭数据库
- (void) close;

@end
