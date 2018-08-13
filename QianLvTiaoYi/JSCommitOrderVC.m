//
//  JSCommitOrderVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/24.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSCommitOrderVC.h"
#import "GetCommitOrderData.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "JSCommitAddressCell.h"
#import "JSCommitAmountCell.h"
#import "JSCommitStoreCell.h"
#import "JSCommitGoodsCell.h"
#import "JSCommitDescCell.h"
#import "JSCommitCouponCell.h"
#import "JSSCDistributeStyleCell.h"
#import "JSCommitInvoiceCell.h"
#import "JSCommitAmountCell.h"
#import "JSCommitMessageCell.h"
#import "JSCommitPointsCell.h"
#import "JSCommitTotalCell.h"
#import "JSAdressListTVC.h"

#import "GetAddressListData.h"
#import "ConfirmOrder.h"
#import "JSPayStyleVC.h"
#import "GetCreatedOrderData.h"

#import "JSCMShopPrivilegeTVC.h"
#import "JSCMCouponTVC.h"
#import "JSCmGoodsActionView.h"

#import "GetCalculatePriceData.h"
#import "GetResetPrice.h"

#import "JSCOInvoiceTVC.h"

@interface JSCommitOrderVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)CommitOrder *commitOrder;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *selectCoupon;
@property (nonatomic, copy) NSString *seleteCouponId;
@property (nonatomic, copy) NSString *seleteCouponName;
@property (nonatomic, copy) NSString *seletePrivilegeId;
@property (nonatomic, copy) NSString *seletePrivilegeType;
@property (nonatomic, copy) NSString *seletePrivilegeName;
@property (nonatomic, copy) NSString *invoiceType;
@property (nonatomic, copy) NSString *invoiceMessage;
@property (nonatomic, copy) NSString *buyMessage;
@property (nonatomic, strong) JSCommitMessageCell *messageCell;
@property (nonatomic, assign) NSInteger seleteIndex;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)JSCmGoodsActionView *goodsActionView;
@property (nonatomic, strong)WMCalculatePrice *calculatePrice;
@property (nonatomic, strong)WMResetPrice *resetPrice;
@property (nonatomic, assign) BOOL isResetCoupon;//判断是否重新选择了红包
@property (nonatomic, assign) BOOL isResetPri;//判断是否重新选择商品活动
@property (nonatomic, assign) BOOL usableIntegral; //判断是否使用积分
@property (nonatomic, assign) BOOL isOnce;
@end

@implementation JSCommitOrderVC

//static dispatch_once_t onceToken;


#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //注册选择相应红包的通知监听者
    [M_NOTIFICATION addObserver:self selector:@selector(seleteCouponNotifiClick:) name:@"selectCouponNotifi" object:nil];
    //注册选择相应商品活动的通知监听者
    [M_NOTIFICATION addObserver:self selector:@selector(choisePrivilegeNotifiClick:) name:@"choisePrivilegeNotifi" object:nil];
    //注册选择发票的通知监听者
    [M_NOTIFICATION addObserver:self selector:@selector(selectInvoiceNotifiClick:) name:@"setInvoiceMessageNotifi" object:nil];
    
    //调用地址的请求  获取地址id
    [self requsetAddress];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isResetPri = NO;
    _isResetCoupon = NO;
    _usableIntegral = NO;
    _isOnce = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCartIDs:(NSString *)cartIDs {
    _cartIDs = cartIDs;
    [self requestCommitOrderWithCartIDs:_cartIDs];
}

- (void)setGoodsCount:(NSInteger)goodsCount {
    _goodsCount = goodsCount;
    if (_productID && _goodsCount && _goodsAciType != 0) {
        [self requestPromptlyOrderWithProductId:_productID count:@(_goodsCount) withGoodsType:_goodsAciType];
    }
}

- (void)setGoodsAciType:(NSString *)goodsAciType
{
    _goodsAciType = goodsAciType;
    if (_productID && _goodsCount && _goodsAciType != 0) {
        [self requestPromptlyOrderWithProductId:_productID count:@(_goodsCount) withGoodsType:_goodsAciType];
    }
}

- (void)setProductID:(NSString *)productID {
    _productID = productID;
    if (_productID && _goodsCount && _goodsAciType != 0) {
        [self requestPromptlyOrderWithProductId:_productID count:@(_goodsCount) withGoodsType:_goodsAciType];
    }
}

#pragma mark - NotificationCenter

/**
 *  选择相应的红包方法
 *
 *  Notification
 */
- (void)seleteCouponNotifiClick:(NSNotification *)notifi
{
    _isResetCoupon = YES;
    NSDictionary *dict = [notifi userInfo];
    // 选择的红包id
    _seleteCouponId = dict[@"couponId"];
    
    // 选择的红包名称
    _seleteCouponName = dict[@"couponName"];
    
    //调用计算价格的请求
    [self calculateOrderPriceRequest];
    [self.tableView reloadData];
}

/**
 *  选择相应商品活动
 *
 *  Notification
 */
- (void)choisePrivilegeNotifiClick:(NSNotification *)notifi
{
    _isResetPri = YES;
    
    NSDictionary *dict = [notifi userInfo];
    _seletePrivilegeId = dict[@"privilegeId"];
    _seletePrivilegeType = dict[@"privilegeType"];
    _seletePrivilegeName = dict[@"privilegeName"];
    _seleteIndex = [dict[@"privilegeIndex"] integerValue];
    
    [self bottomViewTapClick];
    
    //调用计算价格的请求
    [self calculateOrderPriceRequest];
    [self.tableView reloadData];
}

/**
 *  设置发票信息
 *
 *  Notification
 */
- (void)selectInvoiceNotifiClick:(NSNotification *)notifi
{
    NSDictionary *dict = [notifi userInfo];
    _invoiceType = dict[@"invoiceType"];
    _invoiceMessage = dict[@"invoiceName"];
}


#pragma mark - Http Requests

/**
 *  结算请求
 *
 *  @param ：shoppingCartIds
 */
- (void)requestCommitOrderWithCartIDs:(NSString *)cartIDs
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [GetCommitOrderData getWithUrl:RMRequestStatusBalanceShoppingCart param:@{@"shoppingCartIds": cartIDs} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD dismiss];
            weakSelf.commitOrder = dataObj;
            
            _isResetPri = NO;
            _isResetCoupon = NO;
            //调用计算价格的请求
            [self calculateOrderPriceRequest];
            
            [weakSelf.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/**
 *  获取默认地址请求
 *
 */
- (void)requsetAddress
{
    NSDictionary *param = @{@"currentPage": @"1", @"pageNumber": @"1"};
    __weak typeof(self) weakSelf = self;
    [GetAddressListData postWithUrl:RMRequestStatusAddressList param:param modelClass:[Address class] responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            NSArray *list = dataObj;
            if (list.count > 0) {
                weakSelf.address = list.firstObject;
                
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

/**
 *  立即下单请求 （加入团购 加入众筹）
 */
- (void)requestPromptlyOrderWithProductId:(NSString *)proID count:(NSNumber *)count withGoodsType:(NSString *)goodsType
{
     __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [XLDataService postWithUrl:RMRequestStatusPromptlyOrder param:@{@"productId": proID, @"number": count ,@"goodsType":goodsType} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD dismiss];
            weakSelf.commitOrder = [CommitOrder mj_objectWithKeyValues:dataObj];
            
            _isResetPri = NO;
            _isResetCoupon = NO;
            //调用计算价格的请求
            [self calculateOrderPriceRequest];
            
            [weakSelf.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


/**
 *  判断是否使用积分
 *  
 *  @ 返回积分string
 */
- (NSString *)useIntegral
{
    //判断是否使用积分
    NSString *integral = nil;
    if (!_usableIntegral) {
        integral = @"0";
    } else {
        if ([_commitOrder.usableIntegral intValue] > [_commitOrder.totalIntegral intValue])
        {
            //判断商品可使用积分是否大于用户拥有积分
            //如果大于那么可以使用积分为商户拥有的积分
            integral = _commitOrder.totalIntegral;
        } else {
            integral = _commitOrder.usableIntegral;
        }
    }
    return integral;
}

/**
 *  计算价格请求
 *
 */
- (void)calculateOrderPriceRequest
{
    NSString *addressId = nil;
    if (!_address) {
        addressId = @"";
    } else {
        addressId = _address.mallDeliveryAddressId;
    }
    
    NSDictionary *param = @{@"points": [self useIntegral], //使用积分
                            @"distribution": addressId,//收货地址id
                            @"jsonString": [[self makeCalculateOrderPriceJson] mj_JSONString]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetResetPrice getWithUrl:RMRequestStatusCalculateOrderPrice param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.resetPrice = dataObj;
             [self.tableView reloadData];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 *  设置计算价格的json串
 */
- (NSArray *)makeCalculateOrderPriceJson
{
    NSMutableArray *mArr = [NSMutableArray array];
    for (OrderJson *ojson in _commitOrder.orderJsons) {
        //获取到当前选中的每个店铺的 店铺id 和 店铺的红包id
        WMJsonString *wmjs = [[WMJsonString alloc] init];
        wmjs.shopId = ojson.shopId;
        
        
        //判断是否重新选择了红包
        if (_isResetCoupon) {
            wmjs.preferentialId = _seleteCouponId;
        } else {
            if (ojson.mallCoupons.count != 0) {
                MallCoupon *coupon = ojson.mallCoupons[0];
                if (coupon.mallCouponId == NULL) {
                    wmjs.preferentialId = @"";
                } else {
                    wmjs.preferentialId = coupon.mallCouponId;
                }
            } else {
                wmjs.preferentialId = @"";
            }
        }
        
        NSMutableArray *odjs= [NSMutableArray array];
        for (OrderDetailJson *odj in ojson.orderDetailJsons) {
            // 获取到每个店铺下每个商品的购物车id  和 选择的 商品活动id
            
            WMShopCartId *wmsc = [[WMShopCartId alloc] init];
            wmsc.shoppingCartId = odj.shoppingcartId;
            
            //判断是否重新选择了活动
            if (_isResetPri) {
                wmsc.hdId = _seletePrivilegeId;
            } else {
            
                if (odj.privileges.count != 0) {
                    Privilege *pri = odj.privileges[0];
                    if (pri.hdId == NULL) {
                        wmsc.hdId = @"";
                    } else {
                        wmsc.hdId = pri.hdId;
                    }
                } else {
                    wmsc.hdId = @"";
                }
            }
            
            [odjs addObject: wmsc];
        }
        wmjs.shoppingCartIds = odjs;
        
        [mArr addObject:[wmjs mj_keyValues]];
    }
    return mArr;
}

/**
 *  提交订单请求
 *
 */
- (void)requestMakeOrderWithAddressID:(NSString *)addressID  orderJson:(NSArray *)orderJsons
{
    NSDictionary *parma = @{@"addressId": addressID,
                            @"acquirePoints": _resetPrice.availableIntegral,
                            @"points": [self useIntegral],
                            @"receiptType": _invoiceType?_invoiceType:@"",
                            @"receiptHead": _invoiceMessage?_invoiceMessage:@"",
                            @"orderJson": [orderJsons mj_JSONString]};
    
    __weak typeof(self) weakSelf = self;
    [GetCreatedOrderData postWithUrl:RMRequestStatusConfirmOrder param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:error.domain];
            [weakSelf showPayStyleVCWithOrder:dataObj];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  设置提交订单去支付的json串
 */
- (NSArray *)makeOrderJsons
{
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (OrderJson *oj in _commitOrder.orderJsons) {
        
        ConfirmOrder *co = [[ConfirmOrder alloc] init];
        co.shopId = oj.shopId;
        co.remarks = _messageCell.messageTF.text?_messageCell.messageTF.text:@"";
        
        NSMutableArray *couponArr = [NSMutableArray array];
        CreateOrderCoupon *coc = [[CreateOrderCoupon alloc]init];
        
        //判断是否重新选择了店铺红包
        if (_isResetCoupon) {
            coc.mallCouponId = _seleteCouponId;
        } else {
            //没有的话 默认选择第一个红包
            if (oj.mallCoupons.count != 0) {
                MallCoupon *coupon = oj.mallCoupons[0];
                if (coupon.mallCouponId == NULL) {
                    coc.mallCouponId = NULL;
                } else {
                    coc.mallCouponId = coupon.mallCouponId;
                }
            } else {
                coc.mallCouponId = NULL;
            }
        }
        [couponArr addObject:coc];
        
        co.createOrderCoupon = couponArr;
        
        //店铺活动
        NSMutableArray *priArr = [NSMutableArray array];
        for (Privilege *pri in oj.privileges) {
            
            MallMarketingRule *mmr = [[MallMarketingRule alloc]init];
            
            if (oj.privileges.count != 0) {
                
                if (pri.hdId == NULL) {
                    mmr.mallMarketingRuleId = NULL;
                } else {
                    mmr.mallMarketingRuleId = pri.hdId;
                }
            } else {
                mmr.mallMarketingRuleId = NULL;
            }
            
            [priArr addObject:mmr];
        }
        co.mallMarketingRule = priArr;
        
        
        NSMutableArray *odjs = [NSMutableArray array];
        for (OrderDetailJson *odj in oj.orderDetailJsons) {
            ConfirmOrderGoods *newOdj = [[ConfirmOrderGoods alloc] init];
            newOdj.usingIntegralLimit = @"0";
            newOdj.goodsName = odj.shoppingcart.name;
            newOdj.goodsId = odj.shoppingcart.goodsId;
            newOdj.productId = odj.shoppingcart.productId;
            newOdj.postPrice = odj.shoppingcart.postPrice;
            newOdj.number = odj.shoppingcart.number;
            
            //判断是否重新选择了商品的活动
            if (_isResetPri) {
                newOdj.hdId = _seletePrivilegeId;
                newOdj.hdType = _seletePrivilegeType;
                
            } else {
                //没有的话 默认选择第一个活动
                if (odj.privileges.count != 0) {
                    Privilege *pri = odj.privileges[0];
                    if (pri.hdId == NULL) {
                        newOdj.hdId = NULL;
                        newOdj.hdType = NULL;
                    } else {
                        newOdj.hdId = pri.hdId;
                        newOdj.hdType = pri.hdType;
                    }
                } else {
                    newOdj.hdId = NULL;
                    newOdj.hdType = NULL;
                }
            }
            
            [odjs addObject: newOdj];
        }
        co.createOrderGoods = odjs;
        
        [mArr addObject:[co mj_keyValues]];
    }
    return mArr;
}

/**
 *  切换到支付方式界面
 */
- (void)showPayStyleVCWithOrder:(createdOrder *)order
{
    JSPayStyleVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayStyleVC"];
    vc.payOrderNo = order.mergeNo;
    vc.payTotalMoney = order.totalPrice;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Method

/**
 *  创建灰色view
 **/
- (void)createGaryViewAndGoodsActionsView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomViewTapClick)];
    _bottomView.userInteractionEnabled = YES;
    [_bottomView addGestureRecognizer:tap];
    [self.view addSubview:_bottomView];
    
    _goodsActionView = [[NSBundle mainBundle]loadNibNamed:@"JSCmGoodsActionView" owner:self options:nil].firstObject;
    _goodsActionView.frame = CGRectMake(0, HEIGHT - 284.0f ,WIDTH , 220.0f);
    [self.view addSubview:_goodsActionView];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  提交按钮点击事件
 */
- (IBAction)commitOrderAction:(UIButton *)sender
{
    /**判断是否输入的表情符号 */
    if ([WMGeneralTool judgeStringContainsEmoji:_messageCell.messageTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请不要输入表情和特殊符号！"];
        return;
    } else {
        if (_address) {
            sender.userInteractionEnabled = NO;
            // 调用提交订单请求
            [self requestMakeOrderWithAddressID:_address.mallDeliveryAddressId  orderJson: [self makeOrderJsons]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请设置收货地址！"];
        }
    }
}

/**
 *  灰色view点击事件
 */
- (void)bottomViewTapClick
{
    [self.bottomView removeFromSuperview];
    [self.goodsActionView removeFromSuperview];
}

/**
 *  商品活动按钮点击
 */
- (void)selectGoodsActionsMethod:(UIButton *)sender
{
    OrderJson *oj = _commitOrder.orderJsons[sender.tag/1000 - 1];
    OrderDetailJson *odj = oj.orderDetailJsons[sender.tag%1000 - 1];
    
    if (odj.privileges.count != 0) {
        Privilege *pri = odj.privileges[0];
        if (pri.hdId == NULL) {
            [SVProgressHUD showInfoWithStatus:@"暂无商品活动"];
            return;
        } else {
            [self createGaryViewAndGoodsActionsView];
            _goodsActionView.actionArray = odj.privileges;
            _goodsActionView.index = sender.tag;
        }
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无商品活动"];
    }
}

/**
 *  使用积分开关点击事件
 */
- (void)usableIntegralSwitchClick:(UISwitch *)sender
{
    if (sender.isOn) {
        // 使用积分
        _usableIntegral = YES;
    } else {
        // 不使用积分
        _usableIntegral = NO;
    }
    //重新计算价格
    [self calculateOrderPriceRequest];
    //刷新价格所在的区
    [self.tableView reloadData];
}

#pragma mark - TextFeild delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (M_JUDGE_EMOJI) {
        return NO;
    }
    return YES;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSection = _commitOrder.orderJsons.count + 1;
    if (indexPath.section == 0) {
        // 选择收货地址
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
        JSAdressListTVC *vc = [sb instantiateViewControllerWithIdentifier:@"AdressListTVC"];
        vc.isCreatOrder = YES;
        
        __weak typeof(self) weakSelf = self;
        [vc setCallBack:^(Address *address){
            weakSelf.address = address;
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == lastSection) {
        //运费抵扣 section

        
    } else {
        //订单 section
        
        OrderJson *oj = _commitOrder.orderJsons[indexPath.section - 1];
        NSInteger goodsCount =  oj.orderDetailJsons.count;
        
        if (indexPath.row == goodsCount + 1) {
            // 店铺优惠 界面
            JSCMShopPrivilegeTVC *priviVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CMShopPrivilegeTVC"];
            
            if (oj.privileges.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无优惠"];
                return;
            } else {
                priviVC.privilegeArr = oj.privileges;
                [self.navigationController pushViewController:priviVC animated:YES];
            }
        } if (indexPath.row == goodsCount + 2) {
            // 选择红包 界面
            
            if (oj.mallCoupons != 0) {
                MallCoupon *coupon = oj.mallCoupons[0];
                if (coupon.mallCouponId == NULL) {
                    [SVProgressHUD showInfoWithStatus:@"暂无红包"];
                    return;
                    
                } else {
                    JSCMCouponTVC *couponVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CMCouponTVC"];
                    couponVC.mallCouponsArr = oj.mallCoupons;
                    [self.navigationController pushViewController:couponVC animated:YES];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:@"暂无红包"];
                return;
            }
        } else if (indexPath.row == goodsCount + 4) {
        
            //设置发票信息
            UIViewController *invoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"COInvoiceTVC"];
            [self.navigationController pushViewController:invoiceVC animated:YES];
        }
    }
}

#pragma mark - TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSection = _commitOrder.orderJsons.count + 1;
    if (indexPath.section == 0) {
        return 89.5f;
    } else if (indexPath.section == lastSection) {
        return indexPath.row == 0 ? 44.0f :100.0f;
    } else {
        OrderJson *oj = _commitOrder.orderJsons[indexPath.section - 1];
        NSInteger goodsCount =  oj.orderDetailJsons.count;
        
        if (indexPath.row == 0 || indexPath.row == goodsCount + 1 || indexPath.row == goodsCount + 2 || indexPath.row == goodsCount + 4 || indexPath.row == goodsCount + 5 || indexPath.row == goodsCount + 6 || indexPath.row == goodsCount + 7) {
            return 44.0f;
        } else if (indexPath.row == goodsCount + 3){
            return 66.0f;
        } else {
            return 90.0f;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_commitOrder) {
         return 2 + _commitOrder.orderJsons.count;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lastSection = _commitOrder.orderJsons.count + 1;
    
    if (section == 0) {
        return 1;
    } else if (section == lastSection) {
        return 2;
    } else {
        OrderJson *oj = _commitOrder.orderJsons[section -1];
        return oj.orderDetailJsons.count + 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSection = _commitOrder.orderJsons.count + 1;
    
    //地址Section
    if (indexPath.section == 0) {
        JSCommitAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
        if (_address) {
            [cell.warnView setHidden:YES];
            
            cell.nameLabel.text = [NSString stringWithFormat:@"收货人:%@        %@", _address.consigneeName, _address.consigneePhone];
            
            cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", _address.provinceArea ? _address.provinceArea.name : @"", _address.cityArea ? _address.cityArea.name : @"", _address.districtArea ? _address.districtArea.name : @"", _address.address ? _address.address : @""];
        } else {
            [cell.warnView setHidden:NO];
        }
        
        return cell;
        
    } else if (indexPath.section == lastSection) {
        //运费 总价 Section
        
        if (indexPath.row == 0) {
            JSCommitPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pointsCell" forIndexPath:indexPath];
            
            if ([_commitOrder.totalIntegral isEqualToString:@"0"]) {
                cell.titleLabel.text = @"共0积分，不可使用积分抵扣";
            } else {
                if ([_commitOrder.usableIntegral isEqualToString:@"0"]) {
                    cell.titleLabel.text = [NSString stringWithFormat:@"共%@积分，可使用0积分抵扣",_commitOrder.totalIntegral];
                } else {
                    if ([_commitOrder.usableIntegral intValue] >= [_commitOrder.totalIntegral intValue])
                    {
                        //判断商品可使用积分是否大于用户用的积分
                        
                        cell.titleLabel.text = [NSString stringWithFormat:@"共%@积分，可使用%@积分",_commitOrder.totalIntegral,_commitOrder.totalIntegral];
                    } else {
                        
                        cell.titleLabel.text = [NSString stringWithFormat:@"共%@积分，可使用%@积分",_commitOrder.totalIntegral,_commitOrder.usableIntegral];
                    }
                    
                    [cell.cellSwitch addTarget:self action:@selector(usableIntegralSwitchClick:) forControlEvents:UIControlEventValueChanged];
                }
            }
            return cell;
            
        } else {
            JSCommitTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell" forIndexPath:indexPath];
            
            //商品总价
            cell.goodsTotalPrice.text = [NSString stringWithFormat:@"¥%.2f",_resetPrice.goodsPrice];
            //总邮费
            cell.orderAmountLabel.text  = [NSString stringWithFormat:@"¥%.2f",_resetPrice.postPrice];
            //抵扣
            cell.discountLabel.text = [NSString stringWithFormat:@"¥%.2f",_resetPrice.profit];
            //总价
            cell.finallyLabel.text = [NSString stringWithFormat:@"￥%.2f", _resetPrice.totalPrice.floatValue];

            return cell;
        }
        
    } else {
        //订单section
        
        OrderJson *oj = _commitOrder.orderJsons[indexPath.section - 1];
        NSInteger goodsCount =  oj.orderDetailJsons.count;
        
        if (indexPath.row == 0) {   //店铺名称cell
            
            JSCommitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
            cell.confirmOrderStoreName.text = oj.shopName;
            return cell;
        } else if (indexPath.row == goodsCount + 1) {
            //店铺优惠 cell
            JSCommitDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];

            if (oj.privileges.count != 0) {
                Privilege *pri = oj.privileges[0];
                if (pri.hdId == NULL) {
                    cell.descBaoYouLab.text = @"暂无优惠";
                } else {
                    cell.descBaoYouLab.text = pri.privilegeName;
                }
            } else {
                cell.descBaoYouLab.text = @"暂无优惠";
            }
            
            return cell;
            
        } else if (indexPath.row == goodsCount + 2) {   // 红包cell
            JSCommitCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell" forIndexPath:indexPath];
            if (!_isResetCoupon) {
                if (oj.mallCoupons.count != 0) {
                    MallCoupon *coupon = oj.mallCoupons[0];
                    if (coupon.mallCouponId == NULL)
                    {
                        cell.useCouponLab.text = @"暂无红包";
                    } else {
                        cell.useCouponLab.text = [NSString stringWithFormat:@"%@,%@",coupon.couponName,coupon.useCondition];
                    }
                } else {
                    cell.useCouponLab.text = @"暂无红包";
                }
                
            } else {
                cell.useCouponLab.text = _seleteCouponName;
            }
            
            return cell;
            
        } else if (indexPath.row == goodsCount + 3) {   //配送方式cell
            JSSCDistributeStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"distributeStyleCell" forIndexPath:indexPath];
            
            return cell;
            
        } else if (indexPath.row == goodsCount + 4) {   //开具发票cell
            JSCommitInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceCell" forIndexPath:indexPath];
            if (_invoiceMessage == nil) {
                cell.subTitleLab.text = @"设置发票信息";
            } else {
                NSString *type = @"";
                if ([_invoiceType isEqualToString:@"0"]) {
                    type = @"个人";
                } else {
                    type = @"公司";
                }
                cell.subTitleLab.text = [NSString stringWithFormat:@"类型:%@,抬头:%@",type,_invoiceMessage];
            }
            return cell;
            
        } else if (indexPath.row == goodsCount + 5) {
            //留言cell
            _messageCell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
            
            return _messageCell;
        } else if (indexPath.row == goodsCount + 6) {
            //总共...cell
            JSCommitAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"amountCell" forIndexPath:indexPath];
            cell.CountLabel.text = [NSString stringWithFormat:@"总共%@件商品, 共计: ", oj.productCount];
            
            if (!_isResetCoupon) {
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", oj.price.floatValue];
            } else {
                WMResetOderJson *roj = _resetPrice.orderJsons[indexPath.section - 1];
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", roj.price.floatValue];
            }
            
            return cell;
        } else {
            //商品详情cell
            
            JSCommitGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
            OrderDetailJson *odj = oj.orderDetailJsons[indexPath.row - 1];
            cell.nameLabel.text = odj.shoppingcart.name;
            cell.specLabel.text = odj.shoppingcart.spec;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", odj.shoppingcart.price];
            cell.quantityLabel.text = [NSString stringWithFormat:@"x %ld", (long)odj.shoppingcart.number];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:odj.shoppingcart.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
            
            // 判断商品活动按钮的显示状态
            if (odj.privileges.count != 0) {
                Privilege *pri = odj.privileges[0];
                if (pri.hdId == NULL) {
                    [cell.goodsActionBtn setTitle:@"暂无商品活动" forState:UIControlStateNormal];
                } else {
                    //默认显示第一个商品活动的名称
                    [cell.goodsActionBtn setTitle:pri.privilegeName forState:UIControlStateNormal];
                }
            } else {
                [cell.goodsActionBtn setTitle:@"暂无商品活动" forState:UIControlStateNormal];
            }
            
            // 商品活动按钮添加点击事件
            [cell.goodsActionBtn addTarget:self action:@selector(selectGoodsActionsMethod:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodsActionBtn.tag = indexPath.section * 1000 + indexPath.row;
            
            if (_seleteIndex == cell.goodsActionBtn.tag) {
                //显示为选中的商品活动的名称
                [cell.goodsActionBtn setTitle:_seletePrivilegeName forState:UIControlStateNormal];
            }
            
            return cell;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
