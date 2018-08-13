//
//  WMGoodsFav.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/22.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGoodsFav : NSObject

//**商品收藏**//

@property(nonatomic, copy)NSString *goodsId;  //商品ID
@property(nonatomic, assign)int goodsSales; //销量
@property(nonatomic, assign)float goodsWholesalePrice;//批发价
@property(nonatomic, assign)float goodsRetailPrice;//零售价
@property(nonatomic, copy)NSString *unit; //单位
@property(nonatomic, copy)NSString *name; //商品名称
@property(nonatomic, copy)NSString *title;//标题
@property(nonatomic, copy)NSString *imgUrl;//图片





@end
