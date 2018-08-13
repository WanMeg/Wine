//
//  JSOrderDetailTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSOrderDetailTVC.h"
#import "GetOrderDetail.h"
#import "JSOrderDetailGoodsCell.h"

#import "JSOrderDetailAddressCell.h"

#import "JSGoodsDetailVC.h"
#import <UIImageView+WebCache.h>

#import "JSODStoreNameCell.h"
#import "JSODPayStyleCell.h"
#import "JSODSendMessageCell.h"
#import "JSODInvoiceCell.h"
#import "JSOrderGoodsCell.h"
#import "JSODPriceCell.h"
#import "JSODPayMoneyCell.h"

#import "JSSelectCommentTVC.h"

#import "GetOrderPayData.h"
#import "JSPayStyleVC.h"

#import "JSLogisticsInfoTVC.h"
#import "JSShoppingCartVC.h"
#import "JSOrderListVC.h"
#import "JSChooseBackGoodsTVC.h"
#import "JSBackOrderTVC.h"

@interface JSOrderDetailTVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *thanksLab;
@property (weak, nonatomic) IBOutlet UILabel *checkLogisticsLab;
@property (weak, nonatomic) IBOutlet UIImageView *finishImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHight;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomBtns;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ChildOrder *orderDetail;

@property (nonatomic, copy) NSString *productID;

@end

@implementation JSOrderDetailTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lineViewHight.constant = 0.5f;

    
    //给订单号赋值
    self.orderNumberLab.text = self.orderNo;
    
    [self setBottomButtonsStatus];
    [self requestOrderDetailWithOrderNo:self.orderNo];
}

#pragma mark - HTTPRequest

/**
 *  请求订单详情的数据
 */
- (void)requestOrderDetailWithOrderNo:(NSString *)orderNo
{
    __weak typeof(self) weakSelf = self;
    
    [GetOrderDetail postWithUrl:RMRequestStatusOrderDetail param:@{@"orderNo": orderNo} modelClass:[ChildOrder class] responseBlock:^(id dataObj, NSError *error)
    {
        if (dataObj) {
            weakSelf.orderDetail = dataObj;
            
            if (weakSelf.orderDetail.totalStatus == 0 || weakSelf.orderDetail.totalStatus == 1 || weakSelf.orderDetail.totalStatus == 4 || weakSelf.orderDetail.totalStatus == 7) {
                //订单总状态 0 1 4 7
                _checkLogisticsLab.text = @"";
                _checkLogisticsLab.userInteractionEnabled = NO;
            } else {
                // 2 3 5
                _checkLogisticsLab.text = @"查看物流信息";
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkLogisticsLabTapClick)];
                _checkLogisticsLab.userInteractionEnabled = YES;
                [_checkLogisticsLab addGestureRecognizer:tap];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  请求删除订单
 */
- (void)getDeleteOrderRequestWithOrderInfoId:(NSInteger)orderInfoId finish:(void(^)(BOOL success))finish
{
    [XLDataService getWithUrl:RMRequestStatusDeleteOrder param:@{@"orderInfoId":[NSString stringWithFormat:@"%ld",(long)orderInfoId]} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             finish(YES);
             [SVProgressHUD showSuccessWithStatus:@"删除成功。"];
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
- (void)orderGoToPayRequest
{
    
    [GetOrderPayData getWithUrl:RMRequestStatusOrderGoPay param:@{@"orderNos": _orderNo} modelClass:[WMOrderPay class] responseBlock:^(id dataObj, NSError *error) {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             [self showPayStyleVCWithOrder:dataObj];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 *  确认收货请求
 */

- (void)affirmOrderReceiptRequestWithType:(NSString *)type
{
    [XLDataService getWithUrl:RMRequestStatusAffirmOrderReceipt param:@{@"orderInfoId":_orderInfoNo ,@"type":type} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             
             [PRUitls delay:1.0 finished:^{
                 
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收货，是否立即去评价？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评价",@"返回个人中心", nil];
                 alertView.tag = 3;
                 [alertView show];
             }];
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

#pragma mark - Private

/**
 *  设置底部状态栏的显示状态
 */
- (void)setBottomButtonsStatus
{
    UIButton *btn1 = _bottomBtns[0];
    [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
    
    UIButton *btn2 = _bottomBtns[1];
    UIButton *btn3 = _bottomBtns[2];
    UIButton *btn4 = _bottomBtns[3];
    
    switch (_bottomStatus) {
        case 0:{    //待支付
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"去评价" forState:UIControlStateNormal];
            [btn4 setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 1:{    //待发货
            [btn1 setTitle:@"" forState:UIControlStateNormal];
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            [btn4 setTitle:@"等待发货" forState:UIControlStateNormal];
        }
            break;
        case 2:{    //待收货
            [btn1 setTitle:@"" forState:UIControlStateNormal];
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            [btn4 setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 6:{    //已收货
            
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            [btn2 setTitle:@"申请补货" forState:UIControlStateNormal];
            [btn3 setTitle:@"评价晒单" forState:UIControlStateNormal];
            [btn4 setTitle:@"再次购买" forState:UIControlStateNormal];
        }
            break;
        case 4:{    //订单补货
            
            [btn1 setTitle:@"" forState:UIControlStateNormal];
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            [btn4 setTitle:@"补货收货" forState:UIControlStateNormal];
        }
            break;
        case 5:{    //订单取消退款申请
            
            [btn1 setTitle:@"" forState:UIControlStateNormal];
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            [btn4 setTitle:@"退款中" forState:UIControlStateNormal];
        }
            break;
        case 3:{    //已完结
            [btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            [btn2 setTitle:@"售后" forState:UIControlStateNormal];
            [btn3 setTitle:@"评价晒单" forState:UIControlStateNormal];
            [btn4 setTitle:@"再次购买" forState:UIControlStateNormal];
        }
            break;
        case 7:{    //已取消
            [btn1 setTitle:@"" forState:UIControlStateNormal];
            [btn2 setTitle:@"" forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            [btn4 setTitle:@"已取消" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    for (UIButton *button in _bottomBtns) {
        if (button.titleLabel.text.length > 0) {
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    
    btn4.backgroundColor = [UIColor redColor];
}

#pragma mark - Actions

/**
 *  返回上个界面
 */
- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  查看物流信息
 */
- (void)checkLogisticsLabTapClick
{
    JSLogisticsInfoTVC *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogisticsInfoTVC"];
    infoVC.logisticsOrderNo = _orderDetail.orderNo;
    [self.navigationController pushViewController:infoVC animated:YES];
}

/**
 *  底部状态按钮点击事件
 */
- (IBAction)bottomStatusButtonClick:(UIButton *)sender
{
    
/***************************  去支付  ******************************/
    if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
        //去支付界面支付
        [self orderGoToPayRequest];
    }
    
/*************************** 删除订单 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"删除订单"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
    }
    
/*************************** 申请补货 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"申请补货"]) {
        JSChooseBackGoodsTVC *cbgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseBackGoodsTVC"];
        cbgVC.mOrderNo = _orderDetail.orderNo;
        cbgVC.mOrderTime = _orderDetail.createTime;
        cbgVC.backGoodsArray = _orderDetail.orderGoods;
        [self.navigationController pushViewController:cbgVC animated:YES];
    }
    
/*************************** 补货收货 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"补货收货"]) {
        //补货收货

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认补货的货物已经收到，否则可能会造成不必要的损失。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 4;
        [alertView show];
    }
    
/*************************** 评价晒单 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"评价晒单"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
        JSSelectCommentTVC *selectCommentVC = [storyboard instantiateViewControllerWithIdentifier:@"SelectCommentTVC"];
        selectCommentVC.selectOrderId = _orderDetail.orderNo;
        [self.navigationController pushViewController:selectCommentVC animated:YES];
    }
 
/*************************** 确认收货 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认货物已经收到，否则可能会造成不必要的损失。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }

/*************************** 再次购买 ******************************/
    if ([sender.titleLabel.text isEqualToString:@"再次购买"])
    {
        //加入购物车
        [XLDataService postWithUrl:RMRequestStatusAddCart param:@{@"productId": _productID,@"number":@"1"} modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
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
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            //删除订单通知
            [M_NOTIFICATION postNotificationName:@"DeleteOrderNotifi" object:nil userInfo:@{@"orderInfoNo":_orderInfoNo}];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            
            //确认收货 , 正常完成
            [self affirmOrderReceiptRequestWithType:@"1"];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 1) {
            // 去评价界面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
            JSOrderListVC *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
            orderVC.goToWhatVC = 4;
            orderVC.title = @"待评价";
            [self.navigationController pushViewController:orderVC animated:YES];
        } else if (buttonIndex == 2) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 4) {
        if (buttonIndex == 1) {
            
            //补货收货 , 换货完成
            [self affirmOrderReceiptRequestWithType:@"2"];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    //    if (indexPath.section != 0 && indexPath.section != _orderDetail.orderGoods.count + 1)
    //    {
    //        DetailOrder *detailOrder = _orderDetail.orderGoods[indexPath.section - 1];
    //        OrderGoods *orderGoods = detailOrder.orderGoods[indexPath.row];
    //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    //        JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    //        vc.goodsID = orderGoods.goodsId;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderDetail ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _orderDetail.orderGoods.count + 4;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == _orderDetail.orderGoods.count + 1 || indexPath.row == _orderDetail.orderGoods.count + 2) {
            return 44;
        } else if (indexPath.row == _orderDetail.orderGoods.count + 1 + 2) {
            return 60;
        } else {
            return 120;
        }
    } else {
        return indexPath.row == 0 ? 82 : 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JSOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odAddressCell" forIndexPath:indexPath];
        
        cell.nameLabel.text = _orderDetail.receiverName;
        
        cell.phoneNumberLabel.text = _orderDetail.receiverMobile;
        
        cell.addressLabel.text = _orderDetail.address;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {   //店铺名称
            
            JSODStoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odStoreNameCell" forIndexPath:indexPath];
            cell.odStoreNameLab.text = _orderDetail.shopName;
            return cell;
            
        } else if (indexPath.row == _orderDetail.orderGoods.count + 1) {   //支付方式
            
            JSODPayStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odPayStyleCell" forIndexPath:indexPath];
            cell.odPayStyleLab.text = _orderDetail.payWayName;
            return cell;
            
        } else if (indexPath.row == _orderDetail.orderGoods.count + 1 + 1) {   //配送信息
            
            JSODSendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odSendMessageCell" forIndexPath:indexPath];
            cell.odSendMessageLab.text = _orderDetail.deliveryWayName;
            
            return cell;
            
        } else if (indexPath.row == _orderDetail.orderGoods.count + 1 + 2) {   //发票信息
            
            JSODInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odInvoiceCell" forIndexPath:indexPath];
            cell.odInvoiceHeadLab.text = _orderDetail.receiptHead;
            cell.odInvoiceDetailLab.text = _orderDetail.receiptContent;
            return cell;
            
        } else {   //商品信息
            
            WMOrderGoods *orderGoods = _orderDetail.orderGoods[indexPath.row - 1];
            //获取产品id 用来再次购买 添加到购物车
            _productID = orderGoods.productId;
            
            JSOrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odGoodsCell" forIndexPath:indexPath];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:orderGoods.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
            cell.nameLabel.text = orderGoods.goodsName;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", orderGoods.goodsRealityPrice];
            cell.quantityLabel.text = [NSString stringWithFormat:@"x %d", orderGoods.quantity];
            cell.specLabel.text = orderGoods.goodsSpec;
            
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            //商品总额
            JSODPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odPriceCell" forIndexPath:indexPath];
            cell.odTotalPriceLab.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.totalReality];
            cell.odReturnMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.preferentialPrice];
            cell.odFreightLab.text = [NSString stringWithFormat:@"￥%.2f", _orderDetail.totalFreight];
            return cell;
            
        } else {
            //实付款
            
            JSODPayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odPayMoneyCell" forIndexPath:indexPath];
            cell.getOrderTimeLab.text = [NSString stringWithFormat:@"下单时间:%@", _orderDetail.createTime];
            cell.payMoneyLab.text = [NSString stringWithFormat:@"￥%.2f", _orderDetail.realityCost];
            
            return cell;
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
