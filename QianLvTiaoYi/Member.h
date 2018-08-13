//
//  Member.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/7.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (copy, nonatomic) NSString *appToken;
@property (copy, nonatomic) NSString *headPortrait;
@property (assign, nonatomic) NSString *mallMemberId;
@property (copy, nonatomic) NSString *proCode;
@property (copy, nonatomic) NSString *realName;
@property (copy, nonatomic) NSString *userName;

@property (assign, nonatomic) BOOL isAuthentication;//认证

@end
