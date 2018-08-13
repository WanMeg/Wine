//
//  XLDataService.h
//  XLNetwork
//
//  Created by Shelin on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLNetworkRequest.h"
#import "MJExtension.h"
#import "PRDataBaseManager.h"
#define DB [PRDataBaseManager defaultDBManager].dataBase

#define RMRequestErrorCodeFail 0
#define RMRequestErrorCodeNormal 100
#define RMRequestErrorCodeNoMoreData 200
#define RMRequestErrorCodeNoData 300
#define RMRequestErrorCodeNocorrelation 400
#define RMRequestErrorCodeNeedReLogin 10000

typedef NS_ENUM(NSInteger,RMRequestStatus) {
    RMRequestStatusLogin,
    RMRequestStatusSignUp,
    RMRequestStatusCategory,
    RMRequestStatusAddressList,
    RMRequestStatusPersonalInformation,
    RMRequestStatusGoodsList,
    RMRequestStatusArea,
    RMRequestStatusChildArea,
    RMRequestStatusAddAddress,
    RMRequestStatusUpdateAddress,
    RMRequestStatusDelAddress,
    RMRequestStatusGoodsDetail,
    RMRequestStatusAddCart,
    RMRequestStatusGetProductID,
    RMRequestStatusCartList,
    RMRequestStatusDelCart,
    RMRequestStatusEditCartNumber,
    RMRequestStatusCollectList,
    RMRequestStatusAddCollect,
    RMRequestStatusRemoveCollect,
    RMRequestStatusBalanceShoppingCart,
    RMRequestStatusConfirmOrder,
    RMRequestStatusOrderList,
    RMRequestStatusOrderDetail,
    RMRequestStatusWeixinPay,            //微信支付调用
    RMRequestStatusAliPay,               //支付宝支付调用
    RMRequestStatusUnionPay,             //银联支付
    RMRequestStatusCorrelation,
    RMRequestStatusForgetPwdVerification,
    RMRequestStatusMatchVerification,
    RMRequestStatusUpdatememberPwd,
    RMRequestStatusGetHotSearch,
    RMRequestStatusGetHomePage,
    RMRequestStatusPromptlyOrder, //立即下单
    RMRequestStatusAppDetails,       //商品详情URL
    
    
    RMRequestStatusMemberThreeCount,    // 个人中心三个数量
    RMRequestStatusFootmark,            // 浏览记录
    RMRequestStatusDeleteFootmark,      // 清空记录
    RMRequestStatusRemoveOneFootmark,   // 删除单个记录
    RMRequestStatusSendMessage,         // 短信
    RMRequestStatusMemberPoints,        // 积分
    RMRequestStatusMemberDeletePoints,  // 删除积分
    RMRequestStatusChangePersonalInfo,  // 修改个人信息
    RMRequestStatusUploadImage,         // 上传图片请求
    RMRequestStatusGoodsCollectList,    // 商品收藏
    RMRequestStatusGoodsCollectBanner,  // 商品收藏banner图
    RMRequestStatusStoreCollectList,    // 店铺收藏
    RMRequestStatusForgetPsw,           // 找回密码？忘记密码
    RMRequestStatusChangeLoginPsw,      // 修改登录密码
    RMRequestStatusCommentsCenter,      // 评价中心
    RMRequestStatusSendComments,        // 发表评价
    RMRequestStatusCommentsUpdate,      // 评价晒单
    RMRequestStatusMemberRedPacket,     // 会员中心红包
    RMRequestStatusMemberHelpPay,       // 帮助中心支付文档
    RMRequestStatusCommentBannerImage,  // 评论的banner图
    RMRequestStatusGoodsComment,            //商品评论
    RMRequestStatusDeleteOrder,         // 删除订单
    RMRequestStatusCancelOrder,         // 取消订单
    RMRequestStatusRecommentGoods,      // 推荐商品、猜你喜欢
    RMRequestStatusRushRedpacket,       // 主页抢红包
    RMRequestStatusRushRedpacketBanner, // 抢红包banner图
    RMRequestStatusRedpacketGoodsList,  // 红包商品列表
    RMRequestStatusGetCoupon,           // 领取红包
    RMRequestStatusNewUpGoods,          // 新品上市
    RMRequestStatusSignGetPoint,        // 主页签到
    RMRequestStatusActivityGoodsList,   // 今日团购/抢购
    RMRequestStatusCrowdfundingList,    // 商品众筹
    RMRequestStatusCrowdfundingStage,   // 众筹阶段信息
    RMRequestStatusCrowdfundingInfo,    // 商品众筹内页信息
    RMRequestStatusRushShoppingBanner,  // 抢购banner图
    RMRequestStatusTodayShoppingBanner, // 今日团购banner图
    RMRequestStatusCrowdBanner,         // 众筹banner图
    RMRequestStatusMarketActivity,      // 商城活动
    RMRequestStatusMarketActivityGoods, // 商城活动商品
    
    RMRequestStatusShopGoods,           // 店内商品
    RMRequestStatusShopDetail,          // 店铺详情
    RMRequestStatusShopList,            // 店铺列表
    
    RMRequestStatusOrderGoPay,          // 订单去支付
    RMRequestStatusConsumeUseDetails,   // 余额使用明细
    RMRequestStatusMemberConsume,       // 会员余额
    RMRequestStatusUsedBalancePay,      // 判断余额支付
    RMRequestStatusBalancePay,          // 余额支付
    
    RMRequestStatusCategoryFliterGoods, // 分类筛选商品
    RMRequestStatusGoodsListBanner,     // 商品列表banner图
    
    RMRequestStatusSystemNews,          // 系统消息
    RMRequestStatusSystemReadNews,      // 消息已读
    RMRequestStatusSystemDeleteNews,    // 删除消息
    RMRequestStatusChangeBindingPhone,  // 修改绑定手机
    RMRequestStatusVerificTure,         // 验证手机号 支付密码是否正确
    RMRequestStatusIdeaTroaction,       // 意见反馈
    RMRequestStatusIdeaList,            // 意见列表
    
    RMRequestStatusOfflinePay,          // 线下支付转账申请
    RMRequestStatusCommitOfflinePay,    // 提交线下转账
    
    RMRequestStatusOrderStatusInfo,     // 订单状态信息
    RMRequestStatusOrderLogisticsInfo,  // 订单物流信息
    RMRequestStatusAffirmOrderReceipt,  // 确认订单收货
    RMRequestStatusGetGoodsProduct,     // 获取产品id
    RMRequestStatusCalculateOrderPrice, // 计算订单价格
    
    RMRequestStatusReplenishingOrderGoods, // 订单申请补货
    
    RMRequestStatusWithdrawals,         // 提现申请
    RMRequestStatusRecharge,            // 充值
};

@interface XLDataService : NSObject

+ (NSString *)getURLStringWithStatus:(RMRequestStatus)status;

/**
 GET请求转模型
 */
+ (void)getWithUrl:(RMRequestStatus)status param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock;

/**
 POST请求转模型
 */
+ (void)postWithUrl:(RMRequestStatus)status param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock;


+ (void)putWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock;

+ (void)deleteWithUrl:(NSString *)url param:(id)param modelClass:(Class)modelClass responseBlock:(responseBlock)responseDataBlock;

+ (void)updateWithUrl:(RMRequestStatus)status param:(id)param   fileConfig:(XLFileConfig *)fileConfig responseBlock:(responseBlock)responseDataBlock;
/**
 数组、字典转模型，提供给子类的接口
 */
+ (id)modelTransformationWithResponseObj:(id)responseObj modelClass:(Class)modelClass;

/**
 数据是否存在
 */
+ (BOOL)isExistWithTable:(NSString *)table column:(NSString *)column idStr:(NSString *)idStr;

@end
