//
//  XLDataService.m
//  XLNetwork
//
//  Created by Shelin on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "XLDataService.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "GetUserData.h"

static id dataObj;
static NSString *serverHostIdentifier = @"ServerIP";

@implementation XLDataService

+ (NSString *)getURLStringWithStatus:(RMRequestStatus)status {
    
//    NSString *url = M_HTTPURLS;
    NSString *url = @"http://192.168.1.108:81/app/";

    switch (status) {
            /**
             *  登录接口
             */
        case RMRequestStatusLogin:
            url = [url stringByAppendingString:@"/app/member/login"];
            break;
            /**
             *  注册接口
             */
        case RMRequestStatusSignUp:
            url = [url stringByAppendingString:@"/app/member/register"];
            break;
            /**
             *  分类接口
             */
        case RMRequestStatusCategory:
            url = [url stringByAppendingString:@"/app/productCategory"];
            break;
            /**
             *  地址列表接口
             */
        case RMRequestStatusAddressList:
            url = [url stringByAppendingString:@"/app/member/deliveryAddress"];
            break;
            /**
             *  获取个人信息接口
             */
        case RMRequestStatusPersonalInformation:
            url = [url stringByAppendingString:@"/app/member/personalInformation"];
            break;
            /**
             *  获取商品列表接口
             */
        case RMRequestStatusGoodsList:
            url = [url stringByAppendingString:@"/app/goodsList"];
            break;
            /**
             *  获取地区列表接口
             */
        case RMRequestStatusArea:
            url = [url stringByAppendingString:@"/app/areaBefore"];
            break;
            /**
             *  获取子级地区信息接口
             */
        case RMRequestStatusChildArea:
            url = [url stringByAppendingString:@"/app/areaChilden"];
            break;
            /**
             *  新增地址接口
             */
        case RMRequestStatusAddAddress:
            url = [url stringByAppendingString:@"/app/member/addAddress"];
            break;
            /**
             *  修改地址接口
             */
        case RMRequestStatusUpdateAddress:
            url = [url stringByAppendingString:@"/app/member/updateAddress"];
            break;
            /**
             *  删除地址接口
             */
        case RMRequestStatusDelAddress:
            url = [url stringByAppendingString:@"/app/member/deleteAddress"];
            break;
            /**
             *  商品详情接口
             */
        case RMRequestStatusGoodsDetail:
            url = [url stringByAppendingString:@"/app/goodsDetails"];
            break;
            /**
             *  获取产品ID接口
             */
        case RMRequestStatusGetProductID:
            url = [url stringByAppendingString:@"/app/product"];
            break;
            /**
             *  加入购物车接口
             */
        case RMRequestStatusAddCart:
            url = [url stringByAppendingString:@"/app/member/addShoppingCart"];
            break;
            /**
             *  购物车列表接口
             */
        case RMRequestStatusCartList:
            url = [url stringByAppendingString:@"/app/member/shoppingCart"];
            break;
            /**
             *  删除购物车接口
             */
        case RMRequestStatusDelCart:
            url = [url stringByAppendingString:@"/app/member/deleteShoppingCart"];
            break;
            /**
             *  修改购物车数量接口
             */
        case RMRequestStatusEditCartNumber:
            url = [url stringByAppendingString:@"/app/member/updateShoppingCartNumber"];
            break;
            /**
             *  收藏夹列表
             */
        case RMRequestStatusCollectList:
            url = [url stringByAppendingString:@"/app/member/memberCollectList"];
            break;
            /**
             *  添加到收藏夹
             */
        case RMRequestStatusAddCollect:
            url = [url stringByAppendingString:@"/app/member/addAndRemoveCollect"];
            break;
             /**
             *  结算
             */
        case RMRequestStatusBalanceShoppingCart:
            url = [url stringByAppendingString:@"/app/member/balanceShoppingcart"];
            break;
            /**
             *  提交订单
             */
        case RMRequestStatusConfirmOrder:
            url = [url stringByAppendingString:@"/app/member/confirmOrder"];
            break;
            /**
             *  订单列表
             */
        case RMRequestStatusOrderList:
            url = [url stringByAppendingString:@"/app/member/orderList"];
            break;
            /**
             *  订单的详情
             */
        case RMRequestStatusOrderDetail:
            url = [url stringByAppendingString:@"/app/member/orderDetail"];
            break;
            /**
             *  微信支付调用
             */
        case RMRequestStatusWeixinPay:
            url = [url stringByAppendingString:@"/app/member/requestScanPay"];
            break;
            
            /**
             *  支付宝支付调用
             */
        case RMRequestStatusAliPay:
            url = [url stringByAppendingString:@"/app/member/requestAliPay"];
            break;
            
            /**
             *  银联支付调用
             */
        case RMRequestStatusUnionPay:
            url = [url stringByAppendingString:@"/app/member/unionPay"];
            break;
            
            /**
             * 第三方登陆关联
             */
        case RMRequestStatusCorrelation:
            url = [url stringByAppendingString:@"/app/member/correlation"];
            break;
            /**
             *  忘记密码发送验证码
             */
        case RMRequestStatusForgetPwdVerification:
            url = [url stringByAppendingString:@"/app/forgetPwdVerification"];
            break;
            /**
             *  验证验证码
             */
        case RMRequestStatusMatchVerification:
            url = [url stringByAppendingString:@"/app/matchVerification"];
            break;
            /**
             *  更新忘记密码
             */
        case RMRequestStatusUpdatememberPwd:
            url = [url stringByAppendingString:@"/app/updatememberPwd"];
            break;
            /**
             *  热搜关键字
             */
        case RMRequestStatusGetHotSearch:
            url = [url stringByAppendingString:@"/app/getHotSearch"];
            break;
            /**
             *  首页接口
             */
        case RMRequestStatusGetHomePage:
            url = [url stringByAppendingString:@"/app/getHomePageInfo"];
            break;
            
            /**
             *  个人中心三个数量
             */
        case RMRequestStatusMemberThreeCount:
            url = [url stringByAppendingString:@"/app/member/number/three"];
            break;
            
            /**
             *  浏览记录
             */
        case RMRequestStatusFootmark:
            url = [url stringByAppendingString:@"/app/member/goodsFootmark"];
            break;
            /**
             *  清空所有浏览记录
             */
        case RMRequestStatusDeleteFootmark:
            url = [url stringByAppendingString:@"/app/member/removeFootmarkAll"];
            break;
            /**
             *  删除单个浏览记录
             */
        case RMRequestStatusRemoveOneFootmark:
            url = [url stringByAppendingString:@"/app/member/removeFootmarkOne"];
            break;
            /**
             *  发送短信
             */
        case RMRequestStatusSendMessage:
            url = [url stringByAppendingString:@"/app/sms"];
            break;
            /**
             *  修改个人信息
             */
        case RMRequestStatusChangePersonalInfo:
            url = [url stringByAppendingString:@"/app/modify/member/info"];
            break;
            /**
             *  上传图片文件
             */
        case RMRequestStatusUploadImage:
            url = [url stringByAppendingString:@"/file/image/upload"];
            break;

            /**
             *  商品收藏列表
             */
        case RMRequestStatusGoodsCollectList:
            url = [url stringByAppendingString:@"/app/member/goodsCollectList"];
            break;
            /**
             *  商品收藏banner图
             */
        case RMRequestStatusGoodsCollectBanner:
            url = [url stringByAppendingString:@"/app/banner/collect/img"];
            break;
            /**
             *  店铺收藏
             */
        case RMRequestStatusStoreCollectList:
            url = [url stringByAppendingString:@"/app/member/collect/list"];
            break;
            /**
             *  找回密码（忘记密码）
             */
        case RMRequestStatusForgetPsw:
            url = [url stringByAppendingString:@"/app/modify/forget/password"];
            break;
            /**
             *  修改登录 支付密码
             */
        case RMRequestStatusChangeLoginPsw:
            url = [url stringByAppendingString:@"/app/member/modify/password"];
            break;
            /**
             *  评价中心
             */
        case RMRequestStatusCommentsCenter:
            url = [url stringByAppendingString:@"/app/member/commentList"];
            break;
            /**
             *  发表评价  
             */
        case RMRequestStatusSendComments:
            url = [url stringByAppendingString:@"/app/member/insertComment"];
            break;
            /**
             *  评价晒单
             */
        case RMRequestStatusCommentsUpdate:
            url = [url stringByAppendingString:@"/app/member/updateComment"];
            break;
            /**
             *  积分查询
             */
        case RMRequestStatusMemberPoints:
            url = [url stringByAppendingString:@"/app/member/points"];
            break;
            /**
             *  删除积分
             */
        case RMRequestStatusMemberDeletePoints:
            url = [url stringByAppendingString:@"/app/removePoints"];
            break;
            /**
             *  会员中心红包
             */
        case RMRequestStatusMemberRedPacket:
            url = [url stringByAppendingString:@"/app/member/coupon"];
            break;
            /**
             *  帮助中心支付文档
             */
        case RMRequestStatusMemberHelpPay:
            url = [url stringByAppendingString:@"/app/article/help/pay"];
            break;
            /**
             *  评论bannner图   
             */
        case RMRequestStatusCommentBannerImage:
            url = [url stringByAppendingString:@"/app/banner/comment/img"];
            break;
            /**
             *  未支付删除订单
             */
        case RMRequestStatusDeleteOrder:
            url = [url stringByAppendingString:@"/app/member/removeOrder"];
            break;
            
            /**
             *  未发货取消订单
             */
        case RMRequestStatusCancelOrder:
            url = [url stringByAppendingString:@"/app/member/order/refund"];
            break;
            
            /**
             *  推荐商品 & 猜你喜欢
             */
        case RMRequestStatusRecommentGoods:
            url = [url stringByAppendingString:@"/app/remai/goods"];
            break;
            /**
             *  主页红包列表
             */
        case RMRequestStatusRushRedpacket:
            url = [url stringByAppendingString:@"/app/redPacketList"];
            break;
            /**
             *  主页抢红包banner图
             */
        case RMRequestStatusRushRedpacketBanner:
            url = [url stringByAppendingString:@"/app/banner/coupon/img"];
            break;
            /**
             *  红包商品列表
             */
        case RMRequestStatusRedpacketGoodsList:
            url = [url stringByAppendingString:@"/app/memberInfo/couponGoods"];
            break;
            /**
             *  领取红包
             */
        case RMRequestStatusGetCoupon:
            url = [url stringByAppendingString:@"/app/member/insertCoupon"];
            break;
            /**
             *  新品上市
             */
        case RMRequestStatusNewUpGoods:
            url = [url stringByAppendingString:@"/app/new/goods"];
            break;
            /**
             *  签到
             */
        case RMRequestStatusSignGetPoint:
            url = [url stringByAppendingString:@"/app/member/sign/point"];
            break;
            /**
             *  今日团购/抢购
             */
        case RMRequestStatusActivityGoodsList:
            url = [url stringByAppendingString:@"/app/activityGoodsList"];
            break;
            
            /**
             *  商品众筹
             */
        case RMRequestStatusCrowdfundingList:
            url = [url stringByAppendingString:@"/app/crowdfunding/all"];
            break;
            
            /**
             *  商品众筹阶段信息
             */
        case RMRequestStatusCrowdfundingStage:
            url = [url stringByAppendingString:@"/app/crowdfunding/stage"];
            break;
            /**
             *  众筹内页信息
             */
        case RMRequestStatusCrowdfundingInfo:
            url = [url stringByAppendingString:@"/app/crowdfunding/info"];
            break;
            
            /**
             *  限时抢购banner图
             */
        case RMRequestStatusRushShoppingBanner:
            url = [url stringByAppendingString:@"/app/banner/purchase/img"];
            break;
            /**
             *  今日团购banner图
             */
        case RMRequestStatusTodayShoppingBanner:
            url = [url stringByAppendingString:@"/app/banner/group/img"];
            break;
            /**
             *  众筹banner图
             */
        case RMRequestStatusCrowdBanner:
            url = [url stringByAppendingString:@"/app/banner/crowd/img"];
            break;
            
            /**
             *  商城活动
             */
        case RMRequestStatusMarketActivity:
            url = [url stringByAppendingString:@"/app/marketing/activity"];
            break;
            /**
             *  商城活动商品
             */
        case RMRequestStatusMarketActivityGoods:
            url = [url stringByAppendingString:@"/app/marketing/goods"];
            break;
            
            /**
             *  店铺内商品
             */
        case RMRequestStatusShopGoods:
            url = [url stringByAppendingString:@"/app/shopGoods"];
            break;
            /**
             *  店铺详情
             */
        case RMRequestStatusShopDetail:
            url = [url stringByAppendingString:@"/app/shopDetail"];
            break;
            /**
             *  店铺列表
             */
        case RMRequestStatusShopList:
            url = [url stringByAppendingString:@"/app/shopList"];
            break;
            
            /**
             *  订单去支付
             */
        case RMRequestStatusOrderGoPay:
            url = [url stringByAppendingString:@"/app/member/order/goPay"];
            break;
            
            /**
             *  会员余额使用明细
             */
        case RMRequestStatusConsumeUseDetails:
            url = [url stringByAppendingString:@"/app/member/consume/details"];
            break;
            
            /**
             *  会员余额
             */
        case RMRequestStatusMemberConsume:
            url = [url stringByAppendingString:@"/app/member/consume"];
            break;
            
            /**
             *  判断余额支付
             */
        case RMRequestStatusUsedBalancePay:
            url = [url stringByAppendingString:@"/app/member/used/balance"];
            break;
            
            /**
             *  使用余额支付
             */
        case RMRequestStatusBalancePay:
            url = [url stringByAppendingString:@"/app/member/balancePay"];
            break;
            /**
             *  分类筛选商品
             */
        case RMRequestStatusCategoryFliterGoods:
            url = [url stringByAppendingString:@"/app/getFiltrateInfo"];
            break;
            
            /**
             *  商品列表banner图
             */
        case RMRequestStatusGoodsListBanner:
            url = [url stringByAppendingString:@"/app/banner/goods/img"];
            break;
            
            /**
             *  消息列表
             */
        case RMRequestStatusSystemNews:
            url = [url stringByAppendingString:@"/app/member/system/news"];
            break;
            /**
             *  消息已读
             */
        case RMRequestStatusSystemReadNews:
            url = [url stringByAppendingString:@"/app/system/upNews"];
            break;
            /**
             *  删除消息
             */
        case RMRequestStatusSystemDeleteNews:
            url = [url stringByAppendingString:@"/app/member/system/delNews"];
            break;
            
            /**
             *  修改绑定手机
             */
        case RMRequestStatusChangeBindingPhone:
            url = [url stringByAppendingString:@"/app/member/modify/mobile"];
            break;
            
            /**
             *  立即下单
             */
        case RMRequestStatusPromptlyOrder:
            url = [url stringByAppendingString:@"/app/member/promptlyOrder"];
            break;
            /**
             *  商品评论
             */
        case RMRequestStatusGoodsComment:
            url = [url stringByAppendingString:@"/app/goodsComment"];
            break;

            /**
             *  验证手机号与支付密码是否正确
             */
        case RMRequestStatusVerificTure:
            url = [url stringByAppendingString:@"/app/member/verification"];
            break;
            
            /**
             *  意见反馈
             */
        case RMRequestStatusIdeaTroaction:
            url = [url stringByAppendingString:@"/app/member/service/insertMessage"];
            break;
            
            /**
             *  留言列表
             */
        case RMRequestStatusIdeaList:
            url = [url stringByAppendingString:@"/app/member/service/messageList"];
            break;
            /**
             *  商品详情URL
             */
        case RMRequestStatusAppDetails:
            url = [url stringByAppendingString:@"/app/goods/appDetails"];
            break;
            
            /**
             *  线下转账申请信息
             */
        case RMRequestStatusOfflinePay:
            url = [url stringByAppendingString:@"/app/offlinePay/describe"];
            break;
            
            /**
             *  提交线下转账申请
             */
        case RMRequestStatusCommitOfflinePay:
            url = [url stringByAppendingString:@"/app/member/offlinePay"];
            break;
            
            /**
             *  订单状态信息
             */
        case RMRequestStatusOrderStatusInfo:
            url = [url stringByAppendingString:@"/app/member/order/count"];
            break;
            
            /**
             *  订单物流信息
             */
        case RMRequestStatusOrderLogisticsInfo:
            url = [url stringByAppendingString:@"/app/service/logistics"];
            break;
            
            /**
             *  确认订单收货
             */
        case RMRequestStatusAffirmOrderReceipt:
            url = [url stringByAppendingString:@"/app/member/affirmOrderReceipt"];
            break;
            
            /**
             *  获取产品id
             */
        case RMRequestStatusGetGoodsProduct:
            url = [url stringByAppendingString:@"/app/goods/product"];
            break;
            
            /**
             *  计算订单价格
             */
        case RMRequestStatusCalculateOrderPrice:
            url = [url stringByAppendingString:@"/app/member/calculateOrderPrice"];
            break;
            
            /**
             *  订单申请补货
             */
        case RMRequestStatusReplenishingOrderGoods:
            url = [url stringByAppendingString:@"/app/member/replenishingOrderGoods"];
            break;
            
            /**
             *  提现申请
             */
        case RMRequestStatusWithdrawals:
            url = [url stringByAppendingString:@"/app/member/withdrawals"];
            break;
            
            /**
             *  充值
             */
        case RMRequestStatusRecharge:
            url = [url stringByAppendingString:@"/app/member/recharge"];
            break;
            
            
            
        default:
            break;
    }
    
    return url;
}

+ (void)getWithUrl:(RMRequestStatus)status param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    //数组、字典转化为模型数组
    Member *member = [GetUserData fetchActivateMemberData];
    //拼接包头
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary: @{@"uos": @"IPHONE", @"version": @"0.0.1", @"city": @"028", @"appToken": [NSString stringWithFormat:@"%@", member.appToken]}];
    [paramDict addEntriesFromDictionary:param];
    
    [XLNetworkRequest getRequest:[XLDataService getURLStringWithStatus:status] params:paramDict success:^(id responseObj) {
        NSLog(@"%@=========", responseObj);
        
        // 0--请求方法失败、1--请求方法成功、 2--请求方法成功无数据返回 10000--token失效
        NSString *result = responseObj[@"resultCode"];
        NSNumber *hasMore = responseObj[@"hasNextPage"];
        
        int errorCode = 0;
        if ([result isEqualToString:@"0"])
        {
            dataObj = nil;
            errorCode = RMRequestErrorCodeFail;   //请求失败
        }
        
        if ([result isEqualToString:@"1"] ) {
            dataObj = [self modelTransformationWithResponseObj:responseObj[@"resultObject"] modelClass:modelClass];
            if (dataObj == nil) {
                dataObj = responseObj[@"resultObject"];
            }
            if (hasMore != nil) {
                if (hasMore.intValue == 1) {
                    errorCode = RMRequestErrorCodeNormal;  //请求正常
                } else {
                    errorCode = RMRequestErrorCodeNoMoreData;  //没有更多分页
                }
            }else {
                errorCode = RMRequestErrorCodeNormal;  //请求正常
            }
        }
        
        if ([result isEqualToString:@"2"]){
            dataObj = nil;
            errorCode = RMRequestErrorCodeNoData;   //没有数据
        }
        
        //token过期
        if ([result isEqualToString:@"10000"]) {
            [GetUserData deleteMemberLoginStatus];
            dataObj = nil;
            errorCode = RMRequestErrorCodeNeedReLogin;
        }
        
        responseDataBlock(dataObj, [NSError errorWithDomain: responseObj[@"resultInfo"] code:errorCode userInfo:nil]);
        
    } failure:^(NSError *error) {
        responseDataBlock(nil, [NSError errorWithDomain: @"网络错误, 请重试！" code:RMRequestErrorCodeFail userInfo:nil]);
    }];
}

/**
 *  post请求 并保存到数据库
 *
 *  @param status            请求类型返回URlString
 *  @param param             入参
 *  @param modelClass        返回类型 模型
 *  @param responseDataBlock 请求回调
 */
+ (void)postWithUrl:(RMRequestStatus)status param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    Member *member = [GetUserData fetchActivateMemberData];
    
    //拼接包头
    NSString *memberToken = @"";
    
    if (member) {
        memberToken = member.appToken;
    }
    
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionaryWithDictionary: @{@"uos": @"IPHONE", @"version": @"0.0.1", @"city": @"028", @"appToken": [NSString stringWithFormat:@"%@", memberToken]}];
    
    [paramDict addEntriesFromDictionary:param];
    
    //    NSLog(@"%@", paramDict);
    [XLNetworkRequest postRequest:[XLDataService getURLStringWithStatus:status] params:paramDict success:^(id responseObj)
     {
         NSLog(@"--%@", responseObj);
         //           NSLog(@"%@+++++++", responseObj[@"resultInfo"]);
         
         // 0--请求方法失败、1--请求方法成功、 2--请求方法成功无数据返回 10000--token失效
         NSString *result = responseObj[@"resultCode"];
         NSNumber *hasMore = responseObj[@"hasNextPage"];
         
         int errorCode = 0;
         if ([result isEqualToString:@"0"])
         {
             dataObj = nil;
             errorCode = RMRequestErrorCodeFail;   //请求失败
         }
         
         if ([result isEqualToString:@"1"] )
         {
             dataObj = [self modelTransformationWithResponseObj:responseObj[@"resultObject"] modelClass:modelClass];
             if (dataObj == nil) {
                 dataObj = responseObj[@"resultObject"];
             }
             if (hasMore != nil)
             {
                 if (hasMore.intValue == 1)
                 {
                     errorCode = RMRequestErrorCodeNormal;  //请求正常
                 } else {
                     errorCode = RMRequestErrorCodeNoMoreData;  //没有更多分页
                 }
             }else {
                 errorCode = RMRequestErrorCodeNormal;  //请求正常
             }
         }
         
         if ([result isEqualToString:@"2"]){
             dataObj = nil;
             errorCode = RMRequestErrorCodeNoData;   //没有数据
         }
         
         if ([result isEqualToString:@"3"]) {
             dataObj = nil;
             errorCode = RMRequestErrorCodeNocorrelation;
         }
         
         if ([result isEqualToString:@"10000"]) {
             [GetUserData deleteMemberLoginStatus];
             dataObj = nil;
             errorCode = RMRequestErrorCodeNeedReLogin;
         }
         
         responseDataBlock(dataObj, [NSError errorWithDomain: responseObj[@"resultInfo"] code:errorCode userInfo:nil]);
         
     } failure:^(NSError *error) {
         responseDataBlock(nil, [NSError errorWithDomain: @"网络错误, 请重试！" code:RMRequestErrorCodeFail userInfo:nil]);
     }];
}


+ (void)putWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    [XLNetworkRequest putRequest:url params:param success:^(id responseObj) {
        
        dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
        responseDataBlock(dataObj, nil);
    } failure:^(NSError *error) {
        
        responseDataBlock(nil, error);
    }];
}

+ (void)deleteWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock {
    
    [XLNetworkRequest deleteRequest:url params:param success:^(id responseObj) {
        
        dataObj = [self modelTransformationWithResponseObj:responseObj modelClass:modelClass];
        responseDataBlock(dataObj, nil);
    } failure:^(NSError *error) {
        
        responseDataBlock(nil, error);
    }];
}

+ (void)updateWithUrl:(RMRequestStatus)status param:(id)param   fileConfig:(XLFileConfig *)fileConfig responseBlock:(responseBlock)responseDataBlock {
    [XLNetworkRequest updateRequest:[XLDataService getURLStringWithStatus:status] params:nil fileConfig:fileConfig successAndProgress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        responseDataBlock(
    } complete:^(id dataObj, NSError *error) {
        if (!error) {
            id result = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingAllowFragments error:nil];
            responseDataBlock(result, [NSError errorWithDomain: @"" code:100 userInfo:nil]);
        }else {
            responseDataBlock(nil, [NSError errorWithDomain: @"上传失败" code:0 userInfo:nil]);
        }
    }];
}

/**
 数组、字典转化为模型
 */
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass {
    return nil;
}

+ (BOOL)isExistWithTable:(NSString *)table column:(NSString *)column idStr:(NSString *)idStr;
{
    BOOL isExist = NO;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM t_%@ where %@ = ?",table, column];
    FMResultSet *resultSet= [DB executeQuery: query, idStr];
    while ([resultSet next]) {
        if([resultSet stringForColumn:column]) {
            isExist = YES;
        }else{
            isExist = NO;
        }
    }
    return isExist;
}
@end
