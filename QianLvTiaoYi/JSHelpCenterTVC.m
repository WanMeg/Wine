//
//  JSHelpCenterTVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/4/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSHelpCenterTVC.h"
#import "JSContact.h"
#import "JSUserPasswordTabVC.h"
#import "JSHelpPayVC.h"
#import "JSOrderListVC.h"
@interface JSHelpCenterTVC ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *leftThreeViews;

@end

@implementation JSHelpCenterTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Private Methods



#pragma mark - Click Actions

- (IBAction)backMemberCenterAction:(UIBarButtonItem *)sender
{
    //返回个人中心
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonsClick:(UIButton *)sender
{
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
    JSUserPasswordTabVC *userPswVC = [storyboard1 instantiateViewControllerWithIdentifier:@"UserPasswordTabVC"];
    UIStoryboard *storyboard3 = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
    JSHelpPayVC *payVC = [storyboard3 instantiateViewControllerWithIdentifier:@"HelpPayVC"];
    switch (sender.tag) {
        case 521:{
            //修改手机
            UIViewController *updatePhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdatePhoneTVC"];
            
            [self.navigationController pushViewController:updatePhoneVC animated:YES];
        }
            break;
        case 522:{
            //找回密码
            userPswVC.isLoginPswVC = YES;
            userPswVC.isForgetPswVC = YES;
            [self.navigationController pushViewController:userPswVC animated:YES];
        }
            break;
        case 523:{
            //修改登录密码
            userPswVC.isLoginPswVC = YES;
            [self.navigationController pushViewController:userPswVC animated:YES];
        }
            break;
        case 524:{
            //追踪订单
            //待收货
            JSOrderListVC *orderListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
            orderListVC.goToWhatVC = 3;
            orderListVC.isHelpVcOpen = YES;
            orderListVC.title = @"待收货";
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
            break;
        case 525:{
            //售后服务
            JSOrderListVC *orderListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
            orderListVC.goToWhatVC = 5;
            orderListVC.isHelpVcOpen = YES;
            orderListVC.title = @"补货";
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
            break;
        case 526:{
            //查询订单
            JSOrderListVC *orderListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
            orderListVC.goToWhatVC = 1;
            orderListVC.isHelpVcOpen = YES;
            orderListVC.title = @"全部订单";
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
            break;
        case 527:{
            //付款不成功
            payVC.isWhatPayVC = @"a";
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        case 528:{
            //付款方式
            payVC.isWhatPayVC = @"b";
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        case 529:{
            //支付宝被锁定
            payVC.isWhatPayVC = @"c";
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        case 530:{
            //关闭免密支付
            payVC.isWhatPayVC = @"d";
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
