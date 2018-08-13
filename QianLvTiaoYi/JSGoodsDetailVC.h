//
//  JSGoodsDetailVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@interface JSGoodsDetailVC : UIViewController

@property(nonatomic ,copy) NSString *goodsID;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityType;

/** 根据是活动还是普通商品*/
@property (nonatomic, assign) BOOL isActivityGoods;

@end
