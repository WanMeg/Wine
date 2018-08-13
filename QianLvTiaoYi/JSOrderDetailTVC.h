//
//  JSOrderDetailTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSOrderDetailTVC : UIViewController

@property (nonatomic, copy) NSString *orderNo;//总订单号
@property (nonatomic, copy) NSString *orderInfoNo;//订单编号
@property (nonatomic, assign) int bottomStatus;//底部状态
@end
