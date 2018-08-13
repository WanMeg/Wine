//
//  JSOrderListVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/21.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#define M_REMOVE_BTN [cell.deleteOrderButton removeFromSuperview]

#import "JSOrderListVC.h"
#import "JSOrderBarCell.h"
#import "JSOrderStatusCell.h"
#import "JSOrderGoodsCell.h"
#import "JSContact.h"
#import "GetOrderListData.h"
#import "JSOrderDetailTVC.h"
#import "JSPayStyleVC.h"
#import "GetOrderPayData.h"
#import "JSShoppingCartVC.h"
#import "JSSelectCommentTVC.h"
#import "JSCancleOrderView.h"

@interface JSOrderListVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UISearchBarDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *orderListSearchBar;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *oLTopViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *oLTopLabels;

@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, copy) NSString *pageNumber;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *pickedorderNo;
@property (nonatomic, strong) WMOrderPay *orderPay;
@property (nonatomic, strong) JSCancleOrderView *cancelOrderView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, assign) NSInteger cancelTag;
@end

@implementation JSOrderListVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *lab = _oLTopLabels[0];
    lab.textColor = [UIColor redColor];
    
    _orderListSearchBar.delegate = self;
    _orderListTableView.emptyDataSetSource = self;
    _orderListTableView.emptyDataSetDelegate = self;
    
    [self addTopViewsTapGesture];//调用views手势方法
    

    self.orderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        if (self.orderListTableView.mj_footer.isRefreshing) {
            [self.orderListTableView.mj_footer endRefreshing];
        }
        [self initModelsAndPager];
        [self judgeGoToWhatVCAndRequestTheData];
    }];
    
    self.orderListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.orderListTableView.mj_header.isRefreshing) {
            [self.orderListTableView.mj_header endRefreshing];
        }
        [self judgeGoToWhatVCAndRequestTheData];
    }];
    
    [self initModelsAndPager];
    [self judgeGoToWhatVCAndRequestTheData];
    
    
    //注册监听订单详情删除订单的通知
    [M_NOTIFICATION addObserver:self selector:@selector(deleteOrderNotificationMethod:) name:@"DeleteOrderNotifi" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

/**
 *  判断进入的哪一个界面请求对应的数据
 */
- (void)judgeGoToWhatVCAndRequestTheData
{
    switch (_goToWhatVC) {
        case 0:{    //全部订单
            [self getRequestDataWithOrderStatus:@"" withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        case 1:{    //待支付
            [self getRequestDataWithOrderStatus:@"0" withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        case 2:{    //待发货
            [self getRequestDataWithOrderStatus:@"1" withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        case 3:{    //待收货
            [self getRequestDataWithOrderStatus:@"2" withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        case 4:{    //待评价
            [self getRequestDataWithOrderStatus:@"6" withOpinionStatus:@"0" withIsAutotrophy:@""];
        }
            break;
        case 5:{   //售后
            [self getRequestDataWithOrderStatus:@"4" withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        default:
            break;
    }

}

/**
 *  顶部三个view点击手势
 */
- (void)addTopViewsTapGesture
{
    [_oLTopViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfTopViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

/**
 *  创建灰色view和取消订单view
 */
- (void)createBottomViewAndCancelOrderViewWith:(NSString *)orderNo
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.4;
    [self.view addSubview:_bottomView];
    
    _cancelOrderView = [[NSBundle mainBundle]loadNibNamed:@"JSCancleOrderView" owner:self options:nil].firstObject;
    _cancelOrderView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
    _cancelOrderView.bounds = CGRectMake(0, 0, WIDTH - 60, 220);
    _cancelOrderView.cancelReasonTV.delegate = self;
    _cancelOrderView.cancelOrderNo.text = [NSString stringWithFormat:@"订单号:%@",orderNo];
    [_cancelOrderView.cancelBtn addTarget:self action:@selector(cancelOrderViewCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelOrderView.confirmBtn addTarget:self action:@selector(cancelOrderViewConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelOrderView];
}


#pragma mark - HTTPRequest

/**
 *  设置参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = @"10";
    self.orderList = [NSMutableArray array];
    [self.orderListTableView reloadData];
}

/**
 *  请求获取订单不同状态下的数据
 */
- (void)getRequestDataWithOrderStatus:(NSString *)status withOpinionStatus:(NSString *)opinionStatus withIsAutotrophy:(NSString *)autotrophy
{
    NSDictionary *param = @{@"orderStatus":status,@"opinionStatus":opinionStatus,@"isAutotrophy":autotrophy,@"pageNumber": _pageNumber,@"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage],@"orderNo":_orderListSearchBar.text?_orderListSearchBar.text:@""};
    
    __weak typeof(self) weakSelf = self;
    
    [GetOrderListData postWithUrl:RMRequestStatusOrderList param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         [self.orderListTableView.mj_header endRefreshing];
         [self.orderListTableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             [weakSelf.orderList addObjectsFromArray:dataObj];
         }
         [weakSelf.orderListTableView reloadData];
         if (error.code == 200 || error.code == 200) {
             [weakSelf.orderListTableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  请求未支付前删除订单
 */
- (void)getDeleteOrderRequestWithOrderInfoId:(NSInteger)orderInfoId finish:(void(^)(BOOL success))finish
{
    
    [XLDataService getWithUrl:RMRequestStatusDeleteOrder param:@{@"orderInfoId":[NSString stringWithFormat:@"%ld",(long)orderInfoId]} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
         if (100 == error.code) {
             finish(YES);
             [SVProgressHUD showSuccessWithStatus:error.domain];
         } else {
             finish(NO);
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


/**
 *  请求未发货前取消订单
 */
- (void)getCancelOrderRequestWithOrderInfoId:(NSString *)orderInfoId withCancelReson:(NSString *)reson finish:(void(^)(BOOL success))finish
{
    [XLDataService getWithUrl:RMRequestStatusCancelOrder param:@{@"orderInfoId":orderInfoId,@"cancelCause":reson} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
         if (100 == error.code) {
             finish(YES);
             [SVProgressHUD showSuccessWithStatus:error.domain];
         } else {
             finish(NO);
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


/**
 *  去支付请求
 *
 *  参数 orderId 订单号
 */
- (void)orderGoToPayRequestWithOrderId:(NSString *)orderId
{
    [GetOrderPayData getWithUrl:RMRequestStatusOrderGoPay param:@{@"orderNos": orderId} modelClass:[WMOrderPay class] responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:error.domain];
            [self showPayStyleVCWithOrder:dataObj];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  切换到支付方式界面
 */
- (void)showPayStyleVCWithOrder:(WMOrderPay *)orderPay
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
    JSPayStyleVC *payVC = [storyboard instantiateViewControllerWithIdentifier:@"PayStyleVC"];
    payVC.payOrderNo = orderPay.mergeNo;
    payVC.payTotalMoney = orderPay.totalPrice;
    [self.navigationController pushViewController:payVC animated:YES];
}


#pragma mark - Actions

/**
 *  订单详情界面删除订单通知方法
 *
 *  Notification
 */
- (void)deleteOrderNotificationMethod:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *orderId = dict[@"orderInfoNo"];
    
    [self getDeleteOrderRequestWithOrderInfoId:[orderId integerValue] finish:^(BOOL success)
     {
         if (success) {
//             [self.orderListTableView.mj_header beginRefreshing];
         }
     }];
}


/**
 *  顶部views的手势方法
 */
- (void)handleTapOfTopViews:(UIGestureRecognizer *)sender
{
    for (int i = 0; i < _oLTopLabels.count; i++) {
        UILabel *label = _oLTopLabels[i];
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //点击时 当前页数重置为1
    self.currentPage = 1;
    //移除其它状态下数组中的元素
    [self.orderList removeAllObjects];
    
    switch (_goToWhatVC) {
        case 0:{    //全部订单
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@""];
        }
            break;
        case 1:{    //待支付
            
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@"0"];
        }
            break;
        case 2:{    //待发货
            
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@"1"];
        }
            break;
        case 3:{    //待收货
            
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@"2"];
        }
            break;
        case 4:{    //待评价 .已完结
            
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@"6"];
        }
            break;
            
        case 5:{   //补货
            [self differentStatusVCWithTag:sender.view.tag withOrderStatus:@"4"];
        }
            break;
        default:
            break;
    }
}

/**
 *  删除订单方法
 */
- (void)deleteOrderClickWith:(NSInteger)tag
{
    ParentOrder *parentOrder = _orderList[tag];
    __weak typeof(self) weakSelf = self;
    
    [self getDeleteOrderRequestWithOrderInfoId:[parentOrder.orderInfoId integerValue] finish:^(BOOL success) {
         if (success) {
             [weakSelf.orderList removeObjectAtIndex:tag];
             
             [self.orderListTableView deleteSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationNone];
             [PRUitls delay:0.3 finished:^ {
                  [weakSelf.orderListTableView reloadData];
              }];
         }
     }];
}

/**
 *  根据点击的不同orderStatus进入到不同的界面  再根据点击的不同views状态刷新出对
 *  应的数据
 */
- (void)differentStatusVCWithTag:(NSInteger)sender withOrderStatus:(NSString *)status
{
    switch (sender) {
        case 0: {   //全部订单
            [self getRequestDataWithOrderStatus:status withOpinionStatus:@"" withIsAutotrophy:@""];
        }
            break;
        case 1: {   //网站自营
            
            [self getRequestDataWithOrderStatus:status withOpinionStatus:@"" withIsAutotrophy:@"0"];
        }
            break;
        default: {   //店家商铺
            
            [self getRequestDataWithOrderStatus:status withOpinionStatus:@"" withIsAutotrophy:@"1"];
        }
            break;
    }
}


/**
 *  右侧状态按钮的点击事件  跳转对应的vc
 */
- (void)rightButtonSkipVCClick:(UIButton *)sender
{
    ParentOrder *parentOrder = _orderList[sender.tag];
    
/*************************** 去支付 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
        //支付界面
        //调用去支付的请求
        [self orderGoToPayRequestWithOrderId:parentOrder.orderNo];
    }
    
/*************************** 众筹支付定金 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"支付定金"]) {
        //支付界面
        //调用去支付的请求
        [self orderGoToPayRequestWithOrderId:parentOrder.orderNo];
    }
 
/*************************** 众筹支付尾款 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"支付尾款"]) {
        //支付界面
        //调用去支付的请求
        [self orderGoToPayRequestWithOrderId:parentOrder.orderNo];
    }
    
/*************************** 等待众筹结束 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"等待众筹结束"]) {
        M_ALERTSHOW_(@"等待众筹活动结束后才可以支付尾款");
    }
    
/*************************** 等待发货 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"等待发货"]) {
        //跳转详情
        [self skipOrderDetailVCMethodWith:parentOrder];
    }
    
/*************************** 去评价 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"去评价"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
        JSSelectCommentTVC *selectCommentVC = [storyboard instantiateViewControllerWithIdentifier:@"SelectCommentTVC"];
        selectCommentVC.selectOrderId = parentOrder.orderNo;
        [self.navigationController pushViewController:selectCommentVC animated:YES];
    }
    
/*************************** 再次购买 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"再次购买"]) {
        //再次购买界面
        //加入购物车
        OrderGoods *goods = parentOrder.ordersGoods[0];
        [XLDataService postWithUrl:RMRequestStatusAddCart param:@{@"productId": goods.productId,@"number":@"1"} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
             if (error.code == 100) {
                 [SVProgressHUD showSuccessWithStatus:error.domain];
                 
                 [PRUitls delay:1.0 finished:^{
                     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
                     JSShoppingCartVC *vc = [sb instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
                     [self.navigationController pushViewController:vc animated:YES];
                 }];
             } else {
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }
         }];
    }
    
/*************************** 确认收货 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
        [self skipOrderDetailVCMethodWith:parentOrder];
    }
    
/*************************** 补货中 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"补货中"]) {
        [self skipOrderDetailVCMethodWith:parentOrder];
    }
}

/**
 *  跳转订单详情页面
 */
- (void)skipOrderDetailVCMethodWith:(ParentOrder *)parentOrder
{
    JSOrderDetailTVC *odVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailTVC"];
    odVC.orderNo = parentOrder.orderNo;
    odVC.orderInfoNo = parentOrder.orderInfoId;
    odVC.bottomStatus = parentOrder.status;
    [self.navigationController pushViewController:odVC animated:YES];
}

/**
 *  删除、取消订单按钮点击
 */
- (void)cancelOederClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"删除订单"]) {
        PRAlertView *alertView = [[PRAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setCallBack:^(NSInteger buttonIndex) {
             if (buttonIndex == 1) {
                 [self deleteOrderClickWith:sender.tag - 5000];
             }
         }];
        [alertView show];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        ParentOrder *parentOrder = _orderList[sender.tag - 5000];
        _cancelTag = sender.tag - 5000;
        [self createBottomViewAndCancelOrderViewWith:parentOrder.orderNo];
    }
}

/**
 *  交易成功后 删除订单按钮点击
 */
- (void)deleteOrderButtonClick:(UIButton *)sender
{
    PRAlertView *alertView = [[PRAlertView alloc] initWithTitle:nil message:@"是否要删除该订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setCallBack:^(NSInteger buttonIndex) {
         if (buttonIndex == 1) {
             [self deleteOrderClickWith:sender.tag - 10000];
         }
     }];
    [alertView show];
}

/**
 *  取消订单视图的取消按钮点击事件
 */
- (void)cancelOrderViewCancelBtnClick
{
    [self.bottomView removeFromSuperview];
    [self.cancelOrderView removeFromSuperview];
}

/**
 *  取消订单视图的确定按钮点击事件
 */
- (void)cancelOrderViewConfirmBtnClick
{
    if (_cancelOrderView.cancelReasonTV.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请描述您取消订单的原因"];
        return;
    } else {
        if ([WMGeneralTool judgeStringContainsEmoji:_cancelOrderView.cancelReasonTV.text]) {
            [SVProgressHUD showErrorWithStatus:@"请不要输入表情和特殊符号！"];
            return;
        } else {
            ParentOrder *parentOrder = _orderList[_cancelTag];
            __weak typeof(self) weakSelf = self;
            [self getCancelOrderRequestWithOrderInfoId:parentOrder.orderInfoId withCancelReson:_cancelOrderView.cancelReasonTV.text finish:^(BOOL success) {
                if (success) {
                    [weakSelf cancelOrderViewCancelBtnClick];
                    [weakSelf.orderList removeObjectAtIndex:_cancelTag];
                    [weakSelf.orderListTableView deleteSections:[NSIndexSet indexSetWithIndex:_cancelTag] withRowAnimation:UITableViewRowAnimationNone];
                    [PRUitls delay:0.3 finished:^
                     {
                         [weakSelf.orderListTableView reloadData];
                     }];
                }
            }];
        }
    }
}


- (IBAction)backMemberVCClick:(UIBarButtonItem *)sender
{
    if (_isHelpVcOpen) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
}

#pragma mark - UITextViewDelegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _cancelOrderView.tipsLab.text = nil;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (M_JUDGE_EMOJI) {
        return NO;
    }
    return YES;
}


#pragma mark - UISearchBarDelegate

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.orderListSearchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.orderListSearchBar resignFirstResponder];
    [self.orderListSearchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.orderListSearchBar resignFirstResponder];// 放弃第一响应者
    //点击时 当前页数重置为1
    self.currentPage = 1;
    //移除其它状态下数组中的元素
    [self.orderList removeAllObjects];
    
    [self getRequestDataWithOrderStatus:@"" withOpinionStatus:@"" withIsAutotrophy:@""];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ParentOrder *po = _orderList[indexPath.section];
    
    if (indexPath.row == 0 || indexPath.row == po.ordersGoods.count + 1) {
        return;
    } else {
        JSOrderDetailTVC *odVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailTVC"];
        odVC.orderNo = po.orderNo;
        odVC.orderInfoNo = po.orderInfoId;
        odVC.bottomStatus = po.status;
        [self.navigationController pushViewController:odVC animated:YES];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParentOrder *parentOrder = _orderList[indexPath.section];
    //顶部状态Cell
    if (indexPath.row == 0) {
        return 40;
        //底部ButtonCell
    } else if (indexPath.row == parentOrder.ordersGoods.count + 1) {
        return 44;
    } else {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return M_HEADER_HIGHT;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return M_HEADER_HIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ParentOrder *parentOrder = _orderList[section];
    return parentOrder.ordersGoods.count + 2;  //加上上下状态cell和buttonCell
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParentOrder *parentOrder = _orderList[indexPath.section];
    
    if (indexPath.row == 0) {
        //店铺名称 订单状态cell
        
        JSOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        cell.storeNameLab.text = parentOrder.shopName;
        
        switch (parentOrder.status) { // 先区分总的状态
            case 0:{
                if ([parentOrder.orderType intValue] == 3) {
                    //众筹订单
                    switch ([parentOrder.zcStatus integerValue]) {
                        //众筹状态
                        case 0:{ //未开始
                            
                        }
                            break;
                        case 1:{ //进行中
                            if ([parentOrder.zcPayStatus intValue] == 0) {
                                //定金未支付
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"等待支付众筹定金";
                            } else if ([parentOrder.zcPayStatus intValue] == 1) {
                                //支付定金 未支付尾款
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"等待支付众筹尾款";
                            } else {
                                //定金、尾款都已支付
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"等待众筹活动结束卖家发货";
                            }
                        }
                            break;
                        case 2:{ //成功结束
                            if ([parentOrder.zcPayStatus intValue] == 0) {
                                //定金未支付
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"等待支付众筹定金";
                            } else if ([parentOrder.zcPayStatus intValue] == 1) {
                                //支付定金 未支付尾款
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"等待支付众筹尾款";
                            } else {
                                //定金、尾款都已支付
                                M_REMOVE_BTN;
                                cell.statusLab.text = @"众筹活动已结束等待卖家发货";
                            }
                        }
                            break;
                        case 3:{ //阶段结束
                            
                        }
                            break;
                        case 4:{ //失败
                            
                        }
                            break;
                        default:{//关闭
                            
                        }
                            break;
                    }
                } else {
                    //其他类型订单
                    M_REMOVE_BTN;
                    cell.statusLab.text = @"等待付款";
                }
                break;
            }
            case 1:{
                M_REMOVE_BTN;
                cell.statusLab.text = @"等待发货";
                break;
            }
            case 2:{
                M_REMOVE_BTN;
                cell.statusLab.text = @"等待收货";
                break;
            }
            case 6:{
                M_REMOVE_BTN;
                cell.statusLab.text = @"已经收货";
                break;
            }
            case 4:{
                M_REMOVE_BTN;
                cell.statusLab.text = @"等待补货";
                break;
            }
            case 5:{
                M_REMOVE_BTN;
                cell.statusLab.text = @"等待退款";
                break;
            }
            case 3:{    //交易成功
                
                [cell.statusLab removeFromSuperview];
                //交易成功后 可 删除订单
                [cell.deleteOrderButton addTarget:self action:@selector(deleteOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.deleteOrderButton.tag = indexPath.section + 10000;
                break;
            }
            default:{   //取消订单
                M_REMOVE_BTN;
                cell.statusLab.text = @"订单已取消";
                break;
            }
        }
        return cell;
        
    }  else if (indexPath.row == parentOrder.ordersGoods.count + 1) {
        //付款金额等 cell
        
        JSOrderBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        
        switch (parentOrder.status) { //先区分总状态
            case 0:{
                if ([parentOrder.orderType intValue] == 3) {
                    //众筹订单
                    switch ([parentOrder.zcStatus integerValue]) {
                        //众筹状态
                        case 0:{ //未开始
                            
                        }
                            break;
                        case 1:{ //进行中
                            if ([parentOrder.zcPayStatus intValue] == 0) {
                                //定金未支付
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"需支付定金：¥%.2f",parentOrder.handsel];
                                [cell.rightButton setTitle:@"支付定金" forState:UIControlStateNormal];
                                [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                            } else if ([parentOrder.zcPayStatus intValue] == 1) {
                                //支付定金 未支付尾款
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"已支付定金：¥%.2f",parentOrder.handsel];
                                [cell.rightButton setTitle:@"等待众筹结束" forState:UIControlStateNormal];
                                [cell.cancelButton removeFromSuperview];
                            } else {
                                //定金、尾款都已支付 （实际上众筹活动未结束的话是不能支付尾款的）
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"已支付定金：¥%.2f",parentOrder.handsel];
                            }
                        }
                            break;
                        case 2:{ //成功结束
                            
                            if ([parentOrder.zcPayStatus intValue] == 0) {
                                //定金未支付
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"需支付定金：¥%.2f",parentOrder.handsel];
                                [cell.rightButton setTitle:@"支付定金" forState:UIControlStateNormal];
                                [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                            } else if ([parentOrder.zcPayStatus intValue] == 1) {
                                //支付定金 未支付尾款
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"已支付定金：¥%.2f",parentOrder.handsel];
                                [cell.rightButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                                [cell.cancelButton removeFromSuperview];
                            } else {
                                //定金、尾款都已支付
                                cell.payTotalMoney.text = [NSString stringWithFormat:@"已支付定金和尾款：¥%.2f",parentOrder.handsel+parentOrder.endMoney];
                                [cell.rightButton setTitle:@"等待发货" forState:UIControlStateNormal];
                                [cell.cancelButton removeFromSuperview];
                            }
                        }
                            break;
                        case 3:{ //阶段结束
                            
                        }
                            break;
                        case 4:{ //失败
                            
                        }
                            break;
                        default:{//关闭
                            
                        }
                            break;
                    }
                } else {
                    //其他类型订单 实付款显示
                    cell.payTotalMoney.text = [NSString stringWithFormat:@"实付款：¥%.2f",parentOrder.realityCost];
                    [cell.rightButton setTitle:@"去支付" forState:UIControlStateNormal];
                }
            }
                break;
            case 1:{
                [cell.rightButton setTitle:@"等待发货" forState:UIControlStateNormal];
                [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
            }
                break;
            case 2:{
                [cell.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.cancelButton removeFromSuperview];
            }
                break;
            case 3:{
                //[cell.rightButton setTitle:@"去评价" forState:UIControlStateNormal];
                //[cell.cancelButton removeFromSuperview];
            }
                break;
            case 4:{
                [cell.rightButton setTitle:@"补货中" forState:UIControlStateNormal];
                [cell.cancelButton removeFromSuperview];
            }
                break;
            case 5:{
                [cell.rightButton setTitle:@"等待退款" forState:UIControlStateNormal];
                //[cell.cancelButton removeFromSuperview];
            }
                break;
            case 6:{
                [cell.rightButton setTitle:@"去评价" forState:UIControlStateNormal];
                [cell.cancelButton setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            case 7:{
                [cell.rightButton setTitle:@"已取消" forState:UIControlStateNormal];
                [cell.cancelButton setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        //右边按钮添加点击事件
        [cell.rightButton addTarget:self action:@selector(rightButtonSkipVCClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightButton.tag = indexPath.section;
        
        //取消订单按钮
        [cell.cancelButton addTarget:self action:@selector(cancelOederClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.cancelButton.tag = indexPath.section + 5000;
        
        return cell;
    } else {
        //商品信息 cell
        
        JSOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
        
        OrderGoods *goods = parentOrder.ordersGoods[indexPath.row - 1];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        cell.nameLabel.text = goods.goodsName;
        cell.activityLabel.text = goods.activityName;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", goods.goodsPrice];
        cell.quantityLabel.text = [NSString stringWithFormat:@"x %d", goods.quantity];
        
        return cell;
    }
}

#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无信息。";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
