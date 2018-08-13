//
//  GoodsParameter.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/16.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsParameter : NSObject
@property (nonatomic, copy) NSString *codeNo;
@property (nonatomic, copy) NSString *parameterName;
@property (nonatomic, copy) NSString *productParameterId;
@property (nonatomic, strong) NSArray *productParameterValues;
@end

@interface ProductParameterValue : NSObject
@property (nonatomic, copy) NSString *codeNo;
@property (nonatomic, copy) NSString *parameterValue;
@property (nonatomic, copy) NSString *productParameterValueId;

@end
