//
//  JSPSTransferTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/26.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSPSTransferTVC.h"
#import "UITextField+Verify.h"

@interface JSPSTransferTVC ()
@property (weak, nonatomic) IBOutlet UILabel *transferOrderIdLab;
@property (weak, nonatomic) IBOutlet UITextField *bankIdTF;
@property (weak, nonatomic) IBOutlet UILabel *bankInfoLab;

@end

@implementation JSPSTransferTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _transferOrderIdLab.text = _transferOrderId;
    
    //线下支付描述
    [self transferPayDescribeRequest];
}

#pragma mark - Request

/**
 *  线下转账支付描述信息
 */
- (void)transferPayDescribeRequest
{
    [XLDataService postWithUrl:RMRequestStatusOfflinePay param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             NSDictionary *dict = dataObj;
             _bankInfoLab.text = dict[@"describe"];
         }
    }];
}

/**
 *  支付 提交线下转账申请
 */
- (void)commitTransferPayRequest
{
    [XLDataService postWithUrl:RMRequestStatusCommitOfflinePay param:@{@"orderNo":_transferOrderId,@"bankCard":_bankIdTF.text} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             
             [PRUitls delay:1.0 finished:^{
                 self.tabBarController.selectedIndex = 4;
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
- (IBAction)commitTransferPayBtnClick:(id)sender
{
    if (!_bankIdTF.validateBankCard)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"银行卡输入有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        
        [self commitTransferPayRequest];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
