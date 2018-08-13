//
//  JSCommitOrderVC.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/24.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCommitOrderVC : UIViewController
@property (nonatomic, copy)NSString *cartIDs;    /**<购物车ID拼接字符串 以英文逗号分隔*/
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, copy) NSString *goodsAciType;//商品活动类型

@end
