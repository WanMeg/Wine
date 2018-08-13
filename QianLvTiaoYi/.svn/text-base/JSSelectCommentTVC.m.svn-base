//
//  JSSelectCommentTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/5.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSelectCommentTVC.h"

#import "JSSelectCommentTVCell.h"
#import "ChildOrder.h"
#import "JSSendCommentVC.h"
#import "GetOrderDetail.h"

@interface JSSelectCommentTVC ()

@property (nonatomic, strong) WMOrderGoods *wmOrderObj;
@property (nonatomic, strong) ChildOrder *orderDetail;

@end

@implementation JSSelectCommentTVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestOrderDetail];
}

#pragma mark - HttpRequest
/**
 *  请求订单详情的数据
 */
- (void)requestOrderDetail
{
    __weak typeof(self) weakSelf = self;
    
    [GetOrderDetail postWithUrl:RMRequestStatusOrderDetail param:@{@"orderNo": _selectOrderId} modelClass:[ChildOrder class] responseBlock:^(id dataObj, NSError *error) {
         if (dataObj) {
             weakSelf.orderDetail = dataObj;
            [weakSelf.tableView reloadData];
         }
     }];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMOrderGoods *wmGoods = _orderDetail.orderGoods[indexPath.row];
    //去评论界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
    JSSendCommentVC *sendVC = [storyboard instantiateViewControllerWithIdentifier:@"SendCommentVC"];
    
    sendVC.sendOrderNo = self.selectOrderId;
    sendVC.sendGoodsId = wmGoods.orderGoodsId;
    sendVC.sendGoodsImg = wmGoods.goodsImgUrl;
    
    [self.navigationController pushViewController:sendVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderDetail.orderGoods.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSSelectCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectGoodsCell" forIndexPath:indexPath];
    
    WMOrderGoods *wmGoods = _orderDetail.orderGoods[indexPath.row];
    
    [cell.selectCmtImg sd_setImageWithURL:[NSURL URLWithString:wmGoods.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.selectMoneyLab.text = [NSString stringWithFormat:@"¥%.2f",wmGoods.goodsRealityPrice];
    
    cell.selectGdsLab.text = wmGoods.goodsName;
    
    cell.selectNumLab.text = [NSString stringWithFormat:@"%d",wmGoods.quantity];
    
    cell.selectSpecLab.text = wmGoods.goodsSpec;
    
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
