//
//  JSGetCouponTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGetCouponTVC.h"
#import "JSRedPacketTVCell.h"
#import "JSLoginTVC.h"

@interface JSGetCouponTVC ()

@end

@implementation JSGetCouponTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSRedPacketTVCell" bundle:nil] forCellReuseIdentifier:@"redPacketTVCell"];
    
}

#pragma mark - Private Methods

/**
 *  领取红包请求
 */
- (void)getCouponRequest
{
    [XLDataService postWithUrl:RMRequestStatusGetCoupon param:@{@"mallCouponId": _coupon.mallCouponId,@"couponSource":@"1"} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100)
        {
            [SVProgressHUD showSuccessWithStatus:@"领取成功。"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin
{
    Member *member = [GetUserData fetchActivateMemberData];
    if (member) {
        return YES;
    } else {
        PRAlertView *alertView = [[PRAlertView alloc] init];
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
                JSLoginTVC * NC = [sb instantiateViewControllerWithIdentifier:@"LoginNC"];
                [self.navigationController presentViewController:NC animated:YES completion:nil];
            }
        }];
        return NO;
    }
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  立即领取按钮
 */
- (IBAction)getCouponBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        [self getCouponRequest];
    } else {
        return;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSRedPacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketTVCell" forIndexPath:indexPath];
    
    //名称
    cell.activityTitleLab.text = _coupon.couponName;
    //图片
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:_coupon.couponImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    //红包额度
    cell.redPacketNumberLab.text = _coupon.couponQuota;
    
    //领取开始时间
    NSNumber *startTime = _coupon.receiveStartTime[@"time"];
    //结束时间
    NSNumber *endTime = _coupon.receiveEndTime[@"time"];
    
    if (_isWhat) {
        //领取期限
        cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",[WMGeneralTool getNowReallyTimeWith:startTime],[WMGeneralTool getNowReallyTimeWith:endTime]];
    } else {
        //领取期限
        cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",_starTime,_endTime];
    }
   
    
    //满多少可使用
    cell.useConditionLab.text = [NSString stringWithFormat:@"满%@使用",_coupon.useCondition?_coupon.useCondition:@""];
    
    if (_coupon.applyRange == 0) //指定商品范围 0 指定 1全部
    {
        if (_coupon.isAutotrophy == 0) //是否自营优惠券 0是 1否
        {
            cell.goodsDetailLab.text = @"可购买自营店铺指定商品";
        } else
        {
            cell.goodsDetailLab.text = @"可购买非自营店铺指定商品";
        }
        
    } else {
        if (_coupon.isAutotrophy == 0)
        {
            cell.goodsDetailLab.text = @"可购买自营店铺所有商品";
        } else
        {
            cell.goodsDetailLab.text = @"可购买非自营店铺所有商品";
        }
    }
    
    cell.nowGetView.userInteractionEnabled = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
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
