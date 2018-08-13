//
//  JSXXRechargeTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/17.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSXXRechargeTVC.h"
#import "UITextField+Verify.h"
@interface JSXXRechargeTVC ()
@property (weak, nonatomic) IBOutlet UILabel *rechargeMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTF;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTF;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (nonatomic, copy) NSString *mergeNo;

@end

@implementation JSXXRechargeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rechargeMoneyLab.text = _xxRechageMoney;
    [self transferRechargeDescribeRequest];
}


#pragma mark - Requests

/**
 *  线下充值描述信息
 */
- (void)transferRechargeDescribeRequest
{
    [XLDataService postWithUrl:RMRequestStatusOfflinePay param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             NSDictionary *dict = dataObj;
             _desLab.text = dict[@"describe"];
         }
     }];
}

/**
 *  线下充值请求
 */
- (void)withdrawalsRequestWithTransferRecharge
{
    NSDictionary *param = @{@"czTxMode": @"0",
                            @"price": _rechargeMoneyLab.text,
                            @"memberRemark": [NSString stringWithFormat:@"%@,%@",_cardNameTF.text,_bankCardTF.text],
                            @"operateType": @"0"};
    
    [XLDataService getWithUrl:RMRequestStatusRecharge param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             
             [PRUitls delay:0.5 finished:^{
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
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
 *  提交按钮
 */
- (IBAction)commitBtnClick:(id)sender
{
    if (_cardNameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"姓名不能为空!"];
        return;
    } else {
        if (!_bankCardTF.validateBankCard) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的银行卡号!"];
            return;
        } else {
            
            [self withdrawalsRequestWithTransferRecharge];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
