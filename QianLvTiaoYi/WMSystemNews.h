//
//  WMSystemNews.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSystemNews : NSObject


@property (nonatomic, assign) int mallNewsId;//消息id
@property (nonatomic, copy) NSString *newsContent;//消息内容
@property (nonatomic, copy) NSString *newsTime;//消息时间
@property (nonatomic, copy) NSString *newsTitle;//消息标题

@property (nonatomic, assign) int isRead;//是否读取
@end
