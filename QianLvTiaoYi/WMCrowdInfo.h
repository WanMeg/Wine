//
//  WMCrowdInfo.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/5.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCrowdInfo : NSObject

@property (nonatomic, copy) NSString *isCollect;
@property (nonatomic, strong) NSMutableArray *goods;


@end


@interface WMCrowdGoods : NSObject

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *salesNum;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *handselScale;
@property (nonatomic, copy) NSString *wholesalePrice;
@property (nonatomic, copy) NSString *retailPrice;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *productList;

@end

@interface WMCrowdStage : NSObject

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stageName;
@property (nonatomic, copy) NSString *stagePosition;
@property (nonatomic, assign) float stageEnd;
@property (nonatomic, assign) float stageStart;

@end


@interface WMCrowdProduct : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *specifications_id;
@property (nonatomic, copy) NSString *value;
@end