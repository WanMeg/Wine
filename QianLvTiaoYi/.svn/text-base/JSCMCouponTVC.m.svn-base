//
//  JSCMCouponTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/26.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCMCouponTVC.h"

#import "JSRedPacketTVCell.h"
#import "CommitOrder.h"

@interface JSCMCouponTVC ()

@end

@implementation JSCMCouponTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 160.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"JSRedPacketTVCell" bundle:nil] forCellReuseIdentifier:@"redPacketTVCell"];
}

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mallCouponsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSRedPacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketTVCell" forIndexPath:indexPath];
    
    MallCoupon *coupon = _mallCouponsArr[indexPath.row];
    
    cell.activityTitleLab.text = coupon.couponName;
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:coupon.couponImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.redPacketNumberLab.text = coupon.couponQuota;
    cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",coupon.validStartTime?coupon.validStartTime:@"",coupon.validEndTime?coupon.validEndTime:@""];
    
    cell.goodsDetailLab.text = coupon.couponDepict;
    
    cell.useConditionLab.text = [NSString stringWithFormat:@"%@使用",coupon.useCondition?coupon.useCondition:@""];
    
    cell.getNowLab.text = @"选择使用";
    
    cell.nowGetBlock = ^(NSInteger tag) {
        tag = indexPath.row;
        
        MallCoupon *coupon = _mallCouponsArr[tag];
        
        //选择一个红包后 发送通知
        [M_NOTIFICATION postNotificationName:@"selectCouponNotifi" object:nil userInfo:@{@"couponId": coupon.mallCouponId , @"couponName": [NSString stringWithFormat:@"%@,%@",coupon.couponName,coupon.useCondition]}];
        
        [PRUitls delay:0.2 finished:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

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
