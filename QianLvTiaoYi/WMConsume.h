//
//  WMConsume.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMConsume : NSObject


// 余额 资产

@property (nonatomic, copy) NSString *balance;//账户余额
@property (nonatomic, copy) NSString *consumeTotal;//消费余额
@property (nonatomic, copy) NSString *incomeTotal;//收入总额
@property (nonatomic, assign) int mallConsumeId;//id

@end
