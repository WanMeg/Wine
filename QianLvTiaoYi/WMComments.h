//
//  WMComments.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMComments : NSObject

@property (nonatomic, copy) NSString *allCount;//全部
@property (nonatomic, copy) NSString *notImgCount ;//追加
@property (nonatomic, copy) NSString *yesImgCount;//晒单完成
@property (nonatomic, copy) NSString *nameUser;//名称
@property (nonatomic, strong) NSMutableArray *comments;

@end

@interface WMCommentsInfo : NSObject

@property (nonatomic, copy) NSString *commentContent;//评论信息
@property (nonatomic, copy) NSString *commentTime;//评论时间
@property (nonatomic, assign) int commodityQuality;//评论星数
@property (nonatomic, assign) int orderGoodsId ;//订单明细ID
@property (nonatomic, copy) NSString *goodsId ;//商品ID
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsName;//商品名字
@property (nonatomic, copy) NSString *goodsSpec;//商品规格
@property (nonatomic, copy) NSString *headPortrait;//头像描述
@property (nonatomic, strong) NSArray *imgUrl;//评论贴图
@property (nonatomic, assign) int mallGoodsCommentId;//评论ID
@property (nonatomic, copy) NSString *orderConfirmTime;//订单提交时间
@property (nonatomic, copy) NSString *orderNo;//订单id

@end