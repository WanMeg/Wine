//
//  JSRechargeTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRechargeTVC.h"
#import "PayStyle.h"
#import "JSRechargeYuECell.h"
#import "JSRechargeMoneyCell.h"
#import "JSRechargeStyleCell.h"
#import "PRAlipayManager.h"
#import "PRWeiXinPayManager.h"
#import "JSXXRechargeTVC.h"

@interface JSRechargeTVC ()
@property (nonatomic, strong) NSArray *payStyles;
@property (nonatomic, strong) PayStyle *currentPayStyle;
@property (nonatomic, strong) JSRechargeMoneyCell *rmCell;
@property (nonatomic, copy) NSString *rMergeNo;
@property (nonatomic, copy) NSString *rTn;
@property (nonatomic, strong) NSDictionary *prepay_id;
@end

@implementation JSRechargeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payStyles = [PayStyle makePayStyles];
}


#pragma mark - Request

/**
 *  充值请求
 */
- (void)withdrawalsRequestWithPayStyle:(NSString *)mode
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"czTxMode": mode,
                            @"price": _rmCell.rechargeMoneyTF.text,
                            @"operateType": @"0"};
    
    [XLDataService getWithUrl:RMRequestStatusRecharge param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             
             if ([mode intValue] == 1) {
                 _rMergeNo = dataObj[@"mergeNo"];
                 [PRAlipayManager payWithOrderID:_rMergeNo withBackUrl:[NSString stringWithFormat:@"%@/app/recharge/alipay",M_HTTPURLS] withPayMoney:_rmCell.rechargeMoneyTF.text callBack:^(NSError *error) {
                     if (error.code == 9000) {
                         [PRUitls delay:1.0 finished:^{
                             [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                         }];
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     }else if (error.code == 6001) {
                         [PRUitls delay:1.0 finished:^{
                             [SVProgressHUD showSuccessWithStatus:@"已取消支付"];
                         }];
                     }else {
                         [PRUitls delay:1.0 finished:^{
                             [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                         }];
                     }
                 }];
             } else if ([mode intValue] == 2) {
                 _prepay_id = dataObj[@"prepay_id"];
                 [[PRWeiXinPayManager sharedManager] weiXinRechargeWithData:_prepay_id callBack:^(NSError *error) {
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

             } else if ([mode intValue] == 3) {
                 _rTn = dataObj[@"tn"];
                 [[PRWeiXinPayManager sharedManager] unionPayWithTn:_rTn viewController:self callBack:^(NSString *code, NSDictionary *data) {
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
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确认充值按钮
 */
- (IBAction)confirmRechargeBtnClick:(id)sender
{
    if (_rmCell.rechargeMoneyTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"充值金额不能为空"];
        return;
    } else {
        if (self.currentPayStyle) {
            __weak typeof(self) weakSelf = self;
            switch (_currentPayStyle.type) {
                case 0: {
                    //支付宝
                    [weakSelf withdrawalsRequestWithPayStyle:@"1"];
                }
                    break;
                case 1: {
                    //微信
                    [weakSelf withdrawalsRequestWithPayStyle:@"2"];
                }
                    break;
                case 2: {
                    // 银联
                    [weakSelf withdrawalsRequestWithPayStyle:@"3"];
                }
                    break;
                case 3:{
                    // 线下转账
                    JSXXRechargeTVC *transferVC = [self.storyboard instantiateViewControllerWithIdentifier:@"XXRechargeTVC"];
                    transferVC.xxRechageMoney = _rmCell.rechargeMoneyTF.text;
                    [self.navigationController pushViewController:transferVC animated:YES];
                }
                    break;
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"请选择一种支付方式!"];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        __weak typeof(self) weakSelf =self;
        //点击cell 更新选中状态
        [_payStyles enumerateObjectsUsingBlock:^(PayStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == indexPath.row)
            {
                obj.selected = !obj.selected;
                weakSelf.currentPayStyle = obj.selected ? obj : nil;
            }else {
                obj.selected = NO;
            }
        }];
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.0f;
    } else {
        return 80.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JSRechargeYuECell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeYuECell" forIndexPath:indexPath];
            cell.accountYuELab.text = _yuEMoney;
            return cell;
            
        } else {
            _rmCell = [tableView dequeueReusableCellWithIdentifier:@"RechargeMoneyCell" forIndexPath:indexPath];
            
            return _rmCell;
        }
    } else {
        JSRechargeStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeStyleCell" forIndexPath:indexPath];
        
        PayStyle *ps = _payStyles[indexPath.row];
        cell.nameLabel.text = ps.name;
        cell.imgView.image = [UIImage imageNamed:ps.imgName];
        cell.descLabel.text = ps.desc;
        
        if (ps.isSelected) {
            cell.selectedImg.image = [UIImage imageNamed:@"xuanzhon.png"];
        }else {
            cell.selectedImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }

        return cell;
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
