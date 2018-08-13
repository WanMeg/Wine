//
//  WMPoints.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/21.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMPoints : NSObject

/* 积分 */

@property (nonatomic,assign)int totalPoints;//总分
@property (nonatomic,strong)NSMutableArray *points;

@end


@interface WMPointsInfo : NSObject

@property (nonatomic,assign)int mallPointsdetailId; //积分id
@property (nonatomic,copy)NSString *imgUrl; //图片
@property (nonatomic,copy)NSString *pointsType; //积分状态
@property (nonatomic,copy)NSString *changeType; //改变状态
@property (nonatomic,assign)int changeCause; //改变原因
@property (nonatomic,copy)NSString *changeTime; //时间
@property (nonatomic,copy)NSString *changeCauseValue; //改变状态
@property (nonatomic,copy)NSString *changePoints; //改变分数
@property (nonatomic,copy)NSString *goodsName; //名称


@end
