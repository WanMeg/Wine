//
//  JSGDCouponTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/1.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGDCouponTVC.h"
#import "WMRushRedPacket.h"
#import "JSRedPacketTVCell.h"
#import "JSGetCouponTVC.h"

@interface JSGDCouponTVC ()


@end

@implementation JSGDCouponTVC

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

    return _gdCouponArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSRedPacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketTVCell" forIndexPath:indexPath];
    
    WMRushRedPacket *coupon = _gdCouponArray[indexPath.row];
    
    cell.activityTitleLab.text = coupon.couponName;
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.redPacketNumberLab.text = coupon.couponQuota;
    
    NSString *start = [coupon.validStartTime substringToIndex:[coupon.validStartTime length]-2];
    NSString *end = [coupon.validEndTime substringToIndex:[coupon.validStartTime length]-2];
    cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",start?start:@"",end?end:@""];
    
    cell.goodsDetailLab.text = coupon.couponDepict;
    
    cell.useConditionLab.text = [NSString stringWithFormat:@"满%@使用",coupon.useCondition?coupon.useCondition:@""];
    
    
    cell.nowGetBlock = ^(NSInteger tag) {
        tag = indexPath.row;
        
        WMRushRedPacket *rushRP = _gdCouponArray[tag];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        JSGetCouponTVC *getCouponVC = [storyboard instantiateViewControllerWithIdentifier:@"GetCouponTVC"];
        getCouponVC.isWhat = NO;
        getCouponVC.coupon = rushRP;
        getCouponVC.starTime = rushRP.validStartTime;
        getCouponVC.endTime = rushRP.validEndTime;
        
        [self.navigationController pushViewController:getCouponVC animated:YES];
    };
    
    return cell;

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
