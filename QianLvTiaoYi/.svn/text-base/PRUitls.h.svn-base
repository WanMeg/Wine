//
//  PRUitls.h
//  ELLife
//
//  Created by admin on 15/9/6.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^delayEndedBlock)();
@interface PRUitls : NSObject
+ (void)delay:(double)delay finished: (delayEndedBlock)finished;
+ (void)countDownWithTimeOut:(int)timeOut CallBack:(void (^)(BOOL isFinished, int curTime))callBack;
@end
