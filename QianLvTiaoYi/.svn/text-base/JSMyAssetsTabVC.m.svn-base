//
//  JSMyAssetsTabVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSMyAssetsTabVC.h"

#import "GetConsumeData.h"
#import "JSFetchMoneyTVC.h"
#import "JSRechargeTVC.h"
@interface JSMyAssetsTabVC ()

@property (weak, nonatomic) IBOutlet UILabel *userBalanceLab;

@property (nonatomic, strong) WMConsume *consume;
@end

@implementation JSMyAssetsTabVC

#pragma mark - L F

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getConsumeRequestData];
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
            
            _userBalanceLab.text = [NSString stringWithFormat:@"%.2f",[_consume.balance floatValue]];
        }
    }];
}

#pragma mark - Actions

- (IBAction)backMemberCenterVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //充值界面
        JSRechargeTVC *rVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RechargeTVC"];
        rVC.yuEMoney = _userBalanceLab.text;
        [self.navigationController pushViewController:rVC animated:YES];
        
    } else if (indexPath.row == 2) {
        //提现界面
        
        JSFetchMoneyTVC *fmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FetchMoneyTVC"];
        fmVC.totalMoney = _userBalanceLab.text;
        [self.navigationController pushViewController:fmVC animated:YES];
        
    } else if (indexPath.row == 3){
        //账户明细
        
        UIViewController *userDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailTabVC"];
        [self.navigationController pushViewController:userDetailVC animated:YES];
    } else {
        return;
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
