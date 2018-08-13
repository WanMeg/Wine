//
//  JSGetCouponTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMRushRedPacket.h"

@interface JSGetCouponTVC : UITableViewController

@property (nonatomic, strong) WMRushRedPacket *coupon;
@property (nonatomic, assign) BOOL isWhat;

@property (nonatomic, copy) NSString *starTime;
@property (nonatomic, copy) NSString *endTime;
@end
