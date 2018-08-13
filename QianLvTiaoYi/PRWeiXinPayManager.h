//
//  PRWeiXinPayManager.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeixinSDK/WXApi.h"
#import "UPPaymentControl.h"


typedef void(^PRWXPayCallBack)(NSError *error);

@interface PRWeiXinPayManager : NSObject<WXApiDelegate>
@property (nonatomic, copy) PRWXPayCallBack callBack;
@property (nonatomic, copy) UPPaymentResultBlock UnionBlock;

+(instancetype)sharedManager ;

-(void)payWithOrderID:(NSString *)orderID callBack:(void(^)(NSError *error))callBack;

/**
 *  微信充值
 */
- (void)weiXinRechargeWithData:(NSDictionary *)dict callBack:(void(^)(NSError *error))callBack;


- (void)unionPayTNWithOrderNo: (NSString *)orderNo viewController:(UIViewController *)vc callBack:(UPPaymentResultBlock)unionCallBack ;

/**
 *  银联充值方法
 */
- (void)unionPayWithTn:(NSString *)tn viewController:(UIViewController *)vc callBack:(UPPaymentResultBlock)unionCallBack;

@end
