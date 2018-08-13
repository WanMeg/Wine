//
//  WMConsumeDetail.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMConsumeDetail : NSObject

// 余额使用明细

@property (nonatomic, copy) NSString *changeDate;//变动时间
@property (nonatomic, copy) NSString *changeMoney;//变动金额
@property (nonatomic, assign) int changeType;//变动类型
@property (nonatomic, copy) NSString *currentBalance;//当前余额
@property (nonatomic, copy) NSString *mallConsumedetailId;//id

@end
