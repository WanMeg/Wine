//
//  PRUitls.m
//  ELLife
//
//  Created by admin on 15/9/6.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import "PRUitls.h"


@implementation PRUitls

+ (void)delay:(double)delay finished: (delayEndedBlock)finished{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         finished();
    });
}


+ (void)countDownWithTimeOut:(int)timeOut CallBack:(void (^)(BOOL isFinished, int curTime))callBack {
    
    __block int timeout=timeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                callBack(YES, timeout);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                callBack(NO, timeout);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end