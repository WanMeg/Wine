//
//  PayStyle.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PayStyle.h"

@implementation PayStyle


+ (NSArray *)makePayStyles {
    PayStyle * ps1 = [[PayStyle alloc] init];
    ps1.name = @"支付宝支付";
    ps1.imgName = @"alipayIcon.png";
    ps1.desc = @"推荐有支付宝的用户使用";
    ps1.type = 0;
    
    PayStyle *ps2 = [[PayStyle alloc] init];
    ps2.name = @"微信支付";
    ps2.imgName = @"weixinIcon.png";
    ps2.desc = @"推荐有微信的用户使用";
    ps2.type = 1;
    
    PayStyle *ps3 = [[PayStyle alloc] init];
    ps3.name = @"银联支付";
    ps3.imgName = @"Visa-2.png";
    ps3.desc = @"安全便捷的支付";
    ps3.type = 2;
    
    PayStyle *ps4 = [[PayStyle alloc] init];
    ps4.name = @"线下转账";
    ps4.imgName = @"xianxiazhifu.png";
    ps4.desc = @"大额可选择此方式支付";
    ps4.type = 3;
    return @[ps1, ps2 ,ps3 ,ps4];
}

@end
