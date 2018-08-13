//
//  JSPayStyleVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSPayStyleVC.h"
#import "JSPayStyleMoneyCell.h"
#import "JSPayStylePayCell.h"
#import "JSPayStyleConsumeCell.h"
#import "JSPSUseConsumeCell.h"
#import "JSPSPasswordCell.h"
#import "JSPSMergeNoCell.h"
#import "PayStyle.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "PRAlipayManager.h"
#import "PRWeiXinPayManager.h"
#import "PRUitls.h"

#import "GetConsumeData.h"
#import "JSPSTransferTVC.h"
#import "HomePageVC.h"

#import "JSOrderListVC.h"

@interface JSPayStyleVC ()<UITableViewDataSource, UITableViewDelegate ,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *payStyles;
@property (nonatomic, strong) PayStyle *currentPayStyle;

@property (nonatomic, strong) WMConsume *consume;
@property (nonatomic, strong) JSPSUseConsumeCell *useConsumeCell;
@property (nonatomic, strong) JSPSPasswordCell *passwordCell;
@property (nonatomic, strong) JSPayStyleConsumeCell *consumeCell;

@property (nonatomic, assign) float consumeMoney;//输入的余额数
@property (nonatomic, assign) float totalPrice;//需要支付的订单总价
@property (nonatomic, assign) BOOL consumePaySuccess;//判断余额支付是否成功
@property (nonatomic, assign) BOOL useOtherPay;//是否使用其它方式支付


@property (nonatomic, assign) BOOL isUseYuE;


@end

@implementation JSPayStyleVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isUseYuE = YES;
    
    self.tableView.tableFooterView = [UIView new];
    self.payStyles = [PayStyle makePayStyles];
    
    [self getConsumeRequestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}

#pragma mark - Private

/**
 *  获取会员余额数据
 */
- (void)getConsumeRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetConsumeData getWithUrl:RMRequestStatusMemberConsume param:nil modelClass:[WMConsume class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.consume = dataObj;
             [self.tableView reloadData];
         }
     }];
}

/**
 *  使用余额支付请求成功后 开始支付
 */
- (void)useConsumePaySuccessRequestWithBalance:(NSString *)balance
{
    
    [XLDataService getWithUrl:RMRequestStatusBalancePay param:@{@"orderNo": _payOrderNo,@"balance":balance,@"payPwd":_passwordCell.passwordTF.text} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             
             [SVProgressHUD showSuccessWithStatus:error.domain];
             
             [PRUitls delay:1.0 finished:^{
                 
                if (_consumeMoney == _totalPrice) {
                     //使用余额等于订单总额
                     //支付成功返回主页
                     [PRUitls delay:1.0 finished:^{
                         NSArray * controller = [self.navigationController viewControllers];
                         UIViewController * homeVC=[controller objectAtIndex:0];
                         [self.navigationController popToViewController:homeVC animated:YES];
                     }];
                 } else {
                     //使用余额不等于订单总额时
                     [PRUitls delay:1.0 finished:^{
                         //调用其它方式
                         [self aliWeixinYinlianPay];
                     }];
                 }
             }];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


#pragma mark - Actions

- (IBAction)backToViewController:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
    JSOrderListVC *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
    orderVC.goToWhatVC = 1;
    orderVC.title = @"待付款";
    [self.navigationController pushViewController:orderVC animated:YES];
}

/**
 *  支付宝 微信 银联支付方法
 */
- (void)aliWeixinYinlianPay
{
    if (self.currentPayStyle) {
        __weak typeof(self) weakSelf = self;
        switch (_currentPayStyle.type) {
                //支付宝支付
                case 0: {
                    [PRAlipayManager payWithOrderID:_payOrderNo withBackUrl:[NSString stringWithFormat:@"%@/app/alipay",M_HTTPURLS] withPayMoney:_payTotalMoney callBack:^(NSError *error) {
                    if (error.code == 9000) {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        }];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else if (error.code == 6001) {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"已取消支付"];
                        }];
                    } else {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                        }];
                    }
                }];
            }
                break;
                //微信支付
                case 1: {
                [[PRWeiXinPayManager sharedManager] payWithOrderID:_payOrderNo callBack:^(NSError *error) {
                    if (error.code == 0) {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        }];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }else if (error.code == -2) {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"已取消支付"];
                        }];
                    }else {
                        [PRUitls delay:1.0 finished:^{
                            [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                        }];
                    }
                }];
            }
                break;
                
                case 2: {
                    // 银联支付
                    [[PRWeiXinPayManager sharedManager] unionPayTNWithOrderNo:_payOrderNo viewController:self callBack:^(NSString *code, NSDictionary *data) {
                        //结果code为成功时，先校验签名，校验成功后做后续处理
                        if([code isEqualToString:@"success"]) {
                            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }
                        else if([code isEqualToString:@"fail"]) {
                            //交易失败
                            [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                        }
                        else if([code isEqualToString:@"cancel"]) {
                            //交易取消
                            [SVProgressHUD showSuccessWithStatus:@"已取消支付"];
                        }
                    }];
                }
                break;
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请选择一种支付方式!"];
    }
}

/**
 *  提交支付
 */
- (IBAction)commitPay:(UIButton *)sender
{
    // 余额支付输入
    _consumeMoney = [_useConsumeCell.writeConsumeTF.text floatValue];

    // 订单总金额
    _totalPrice = [_payTotalMoney floatValue];
    
    /**
     *  四种方式  1.只用余额支付  2.余额 和 其它一起支付  3. 其它支付  4.线下转账
     **/
    
    if (_isUseYuE) {
        if (_useConsumeCell.writeConsumeTF.text.length == 0 || _passwordCell.passwordTF.text.length == 0)
        {
            M_ALERTSHOW_(@"使用余额和支付密码不能为空!");
        } else {
            //**** 1.只用余额支付
            
            if (_consumeMoney > [_consumeCell.consumePriceLab.text floatValue])
            {
                M_ALERTSHOW_(@"账户余额不足！");
                return;
            } else {
                if (_consumeMoney == _totalPrice) {
                    if (_currentPayStyle.selected) {
                        M_ALERTSHOW_(@"使用余额钱数可以完成支付，不需要再使用其它支付!");
                        return;
                    } else {
                        
                        //调用余额支付
                        [self useConsumePaySuccessRequestWithBalance:_useConsumeCell.writeConsumeTF.text];
                    }
                } else if (_consumeMoney > _totalPrice) {
                    
                    // 如果输入金额大于订单金额
                    M_ALERTSHOW_(@"请输入等于或者小于订单金额的钱数!");
                    return;
                } else if (_consumeMoney < _totalPrice) {
                    
                    //**** 2. 余额支付一部分  其它方式支付一部分
                    
                    if (!_useOtherPay) {
                        M_ALERTSHOW_(@"输入余额不足以完成支付，请再选择线下转账以外的其它一种方式支付!");
                        return;
                    } else {
                        if (_currentPayStyle.type == 3) {
                            M_ALERTSHOW_(@"余额支付不能与线下转账同时使用，请再选择线下转账以外的其它一种方式支付!");
                            return;
                        } else {
                            // 余额支付
                            [self useConsumePaySuccessRequestWithBalance:_useConsumeCell.writeConsumeTF.text];
                        }
                    }
                }
            }
        }
    } else {
        // 没有选择余额
        
        //*** 3.
        
        if (_currentPayStyle.type == 3) {
            
            // 线下转账
            JSPSTransferTVC *transferVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PSTransferTVC"];
            transferVC.transferOrderId = _payOrderNo;
            transferVC.isRecharge = NO;
            [self.navigationController pushViewController:transferVC animated:YES];
        } else {
             // 则选择 下面其它支付方式
            [self aliWeixinYinlianPay];
        }
    }
}

#pragma mark - UITextView Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        JSPayStylePayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (_isUseYuE) {
            cell.selectedImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
            _isUseYuE = NO;
        } else {
            cell.selectedImg.image = [UIImage imageNamed:@"xuanzhon.png"];
            _isUseYuE = YES;
        }
    }

    if (indexPath.section == 2) {
        __weak typeof(self) weakSelf =self;
        //点击cell 更新选中状态
        [_payStyles enumerateObjectsUsingBlock:^(PayStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == indexPath.row) {
                obj.selected = !obj.selected;
                weakSelf.currentPayStyle = obj.selected ? obj : nil;
                
                if (obj.selected) {
                    // 改变是否使用其他支付方式的状态
                    _useOtherPay = YES;
                } else {
                    _useOtherPay = NO;
                }
            } else {
                obj.selected = NO;
            }
        }];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - UITableViewDatasouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 44.0f : 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2 ? 30.0f : M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 200, 15)];
        label.text = @"其它支付方式";
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        return headerView;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //第一区
        
        if (indexPath.row == 0) {
            // 总订单号 cell
            
            JSPSMergeNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mergeNoCell" forIndexPath:indexPath];
            
            cell.psMergeNo.text = _payOrderNo;
            
            return cell;
        } else if (indexPath.row == 1) {
            
            // 订单金额 cell
            
            JSPayStyleMoneyCell * cell= [tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
            
            cell.moneyPrice.text = [NSString stringWithFormat:@"￥%.2f", _payTotalMoney.floatValue];
            
            return cell;
        } else if (indexPath.row == 2) {
            // 账户余额 cell
            
            _consumeCell = [tableView dequeueReusableCellWithIdentifier:@"consumeCell" forIndexPath:indexPath];
            
            _consumeCell.consumePriceLab.text = [NSString stringWithFormat:@"%.2f",[_consume.balance floatValue]];
            return _consumeCell;
        } else if (indexPath.row == 3) {
            // 使用余额 cell
            
            _useConsumeCell = [tableView dequeueReusableCellWithIdentifier:@"useConsumeCell" forIndexPath:indexPath];
            _useConsumeCell.writeConsumeTF.text = [NSString stringWithFormat:@"%.2f", _payTotalMoney.floatValue];
            _useConsumeCell.writeConsumeTF.textColor = [UIColor lightGrayColor];
            _useConsumeCell.writeConsumeTF.delegate = self;
            return _useConsumeCell;
        } else {
            // 输入密码 cell
        
            _passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell" forIndexPath:indexPath];
            
//            cell.passwordTF.text = nil;
            
            return _passwordCell;
        }
    } else if (indexPath.section == 1) {
        
        JSPayStylePayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
        cell.nameLabel.text = @"余额支付";
        cell.imgView.image = [UIImage imageNamed:@"yuezhifu"];
        cell.descLabel.text = @"推荐余额充足的用户使用";
        if (_isUseYuE) {
            cell.selectedImg.image = [UIImage imageNamed:@"xuanzhon.png"];
        }

        return cell;
    } else {
        JSPayStylePayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
        
        PayStyle *ps = _payStyles[indexPath.row];
        cell.nameLabel.text = ps.name;
        cell.imgView.image = [UIImage imageNamed:ps.imgName];
        cell.descLabel.text = ps.desc;
        
        if (ps.isSelected) {
            cell.selectedImg.image = [UIImage imageNamed:@"xuanzhon.png"];
        } else {
            cell.selectedImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
        return cell;
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
