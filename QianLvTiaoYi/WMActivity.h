//
//  WMActivity.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/24.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMActivity : NSObject


@property (nonatomic, strong) NSArray *adverts;//广告
@property (nonatomic, assign) int detlCode;//活动类型
@property (nonatomic, copy) NSString *detlName;//活动名称
@property (nonatomic, strong) NSArray *goods;//商品

@end

@interface WMHomeAdverts : NSObject

@property (copy, nonatomic) NSString *imgUrl;//图片地址
@property (copy, nonatomic) NSString *mallAdvertId;//id
@property (copy, nonatomic) NSString *imgLink;//链接地址
@property (copy, nonatomic) NSString *linkType;//类型
@property (copy, nonatomic) NSString *title;//广告标题

@end
