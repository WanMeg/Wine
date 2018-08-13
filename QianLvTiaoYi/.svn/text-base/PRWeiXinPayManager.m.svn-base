//
//  PRWeiXinPayManager.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRWeiXinPayManager.h"
#import "GetWeixinPayData.h"
#import "NSString+MD5.h"

@implementation PRWeiXinPayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PRWeiXinPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PRWeiXinPayManager alloc] init];
    });
    return instance;
}

/**
 *  微信支付
 *
 *  @param orderID  订单号
 *  @param callBack 回调
 */

-(void)payWithOrderID:(NSString *)orderID callBack:(void(^)(NSError *error))callBack {
    NSDictionary *param = @{@"outTradeNo": orderID?orderID:@""};
    self.callBack = callBack;
    [GetWeixinPayData getWithUrl:RMRequestStatusWeixinPay param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
             [self popWeixinPayWithParams:dataObj];
        }
    }];
}

/**
 *  微信支付返回的数据
 */
- (void)popWeixinPayWithParams:(OutTradeOrder *)outTO {
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = outTO.partnerid;
    req.prepayId = outTO.prepayid;
    req.nonceStr = outTO.noncestr;
    req.timeStamp =  outTO.timestamp.intValue;
    req.package = outTO.package;
    req.sign = outTO.sign;
    [WXApi sendReq:req];
}

/**
 *  微信充值
 *
 *  @param callBack 回调
 */
- (void)weiXinRechargeWithData:(NSDictionary *)dict callBack:(void(^)(NSError *error))callBack
{
    self.callBack = callBack;
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = dict[@"partnerid"];
    req.prepayId = dict[@"prepayid"];
    req.nonceStr = dict[@"noncestr"];
    req.timeStamp = [dict[@"timestamp"] intValue];
    req.package = dict[@"package"];
    req.sign = dict[@"sign"];
    [WXApi sendReq:req];
}




/**
 *  银联支付
 *
 *  @param orderNo 订单号
 *  @param vc      原视图
 */
- (void)unionPayTNWithOrderNo: (NSString *)orderNo viewController:(UIViewController *)vc callBack:(UPPaymentResultBlock)unionCallBack {
    self.UnionBlock = unionCallBack;
    [XLDataService postWithUrl:RMRequestStatusUnionPay param:@{@"orderNo": orderNo?orderNo:@""} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            NSString *tn = dataObj[@"tn"];
            [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"CasonWine" mode:@"00" viewController:vc];
        }
    }];
}

/**
 *  银联充值
 *
 *  @param vc      原视图
 */
- (void)unionPayWithTn:(NSString *)tn viewController:(UIViewController *)vc callBack:(UPPaymentResultBlock)unionCallBack
{
    self.UnionBlock = unionCallBack;
    [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"CasonWine" mode:@"00" viewController:vc];
}

#pragma mark - WXApi delegate

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        
        if (self.callBack) {
            self.callBack([NSError errorWithDomain:strMsg code:resp.errCode userInfo:nil]);
        }
    }
}

@end
