//
//  PRAlipayManager.m
//  myAlipayDemo
//
//  Created by JSHENG on 16/1/8.
//  Copyright © 2016年 JSHENG. All rights reserved.
//

#import "PRAlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "Util/DataSigner.h"

@implementation PRAlipayManager


+(void)payWithOrderID:(NSString *)orderID withBackUrl:(NSString *)backUrl withPayMoney:(NSString *)money callBack:(void(^)(NSError *error))callBack
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
//    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911490190871";
    NSString *seller = @"619831976@qq.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALwILm+6AudtF/HtIUijFgBjSosV99Y1ZvA6LqalgNk6cc3gy0zUe9FG0maw3+4mTSlxYtOU8EN7EkTS4itUHHiHDAOb7r1A87gW+EvvKp2ckdR/7RdUMTeaTr7BQoiTssifLIZ2SPRhQ9oAeOGInEDZXi6fGm6eK0fY7rv4RK1lAgMBAAECgYEAuMCpL+prNA2DO5it3XsxAQyOj/7z16v9CwmAEQoJgmfkrk+0MjeNuWGHFpOwU4Wax5+7ZP2w3f0tRCaZR82LckeQxfoE/N3kImeoRt4T8JpAzIcP09gKq91ceqFkKB+slTK5boiZ2FTiF84vbN7Kyq3DkzvDAj16QEAeyQ7FcMECQQD34ptOGqHu7oxDdm7y3rY4trH+vnUSjzRh94gZ9CCYVhFviubx8gP0Hd4ZKOyoeA6hJp00TCeUG3hKOIwgKik9AkEAwi/6EUcHFuRnW0bXKfjaOOw15dVGu3sNhD1zvfKfBQ07v62TlREuTnatLdli4qvRwVcCrr0UUU8mYagqHPtHSQJAHisOC6tiGdoeZ/d5+UTxmGVjtEUpqmCTV3jwr3fun5uZ86FMChYSNRuNdDJu2vIBlctFRqAeEQBm22GWbDO1YQJANcgh4z0fyohR0+bn2rkQf2l0eAY8w9oN4U0/zCDxR+3lWW4SjNuoTpTx29v0VkEuI/UcShcWFHrub2eq2kIB+QJBAOdmqg4Ev2PLboh59qpd3V+hxaVKO6bYfkgyj6KcLw+AzzTJdo82zC38kwb95VRIINuPGytziXmf3/3RoRccqgU=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderID; //订单ID（由商家自行制定）
    order.productName = @"中国酒类批发网"; //商品标题
    order.productDescription = @"中国酒类批发网的商品"; //商品描述
    order.amount = money; //商品价格
    order.notifyURL =  backUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"wxb3fcc2085097d184";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *code = resultDic[@"resultStatus"];
            NSError *err = [NSError errorWithDomain:resultDic[@"memo"] code:code.integerValue userInfo:nil];
            callBack(err);
//            NSLog(@"reslut = %@",resultDic[@"memo"]);
        }];
    }
}
@end
