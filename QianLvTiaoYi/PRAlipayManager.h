//
//  PRAlipayManager.h
//  myAlipayDemo
//
//  Created by JSHENG on 16/1/8.
//  Copyright © 2016年 JSHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRAlipayManager : NSObject

+(void)payWithOrderID:(NSString *)orderID withBackUrl:(NSString *)backUrl withPayMoney:(NSString *)money callBack:(void(^)(NSError *error))callBack;

@end
