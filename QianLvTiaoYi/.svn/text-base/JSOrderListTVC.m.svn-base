//
//  JSOrderListTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSOrderListTVC.h"
#import "JSOrderBarCell.h"
#import "JSOrderStatusCell.h"
#import "JSOrderGoodsCell.h"
#import "JSContact.h"
#import "GetOrderListData.h"
#import "JSOrderDetailTVC.h"

@interface JSOrderListTVC ()

@property (nonatomic, strong) NSMutableArray *orderList;

@property (nonatomic, copy) NSString *pageNumber;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation JSOrderListTVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //下拉和上拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        [PRUitls delay:1.0 finished:^{
            [self initModelsAndPager];
            [self requestOrderList];
        }];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [self requestOrderList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initModelsAndPager {
    self.currentPage = 1;
    self.pageNumber = @"1";
    self.orderList = [NSMutableArray array];
    [self.tableView reloadData];
}

#pragma mark - Requests
- (void) requestOrderList {
    NSDictionary *param = @{@"pageNumber": _pageNumber,
                            @"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage]};
    __weak typeof(self) weakSelf = self;
    [GetOrderListData postWithUrl:RMRequestStatusOrderList param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (dataObj) {
            weakSelf.currentPage++;
            [weakSelf.orderList addObjectsFromArray:dataObj];
        }
        [weakSelf.tableView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParentOrder *po = _orderList[indexPath.section];
    
    JSOrderDetailTVC *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailTVC"];
    tvc.orderNo = po.orderNo;
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ParentOrder *parentOrder = _orderList[indexPath.section];
    //顶部状态Cell
    if (indexPath.row == 0) {
        return 40;
        //底部ButtonCell
    }else if (indexPath.row == parentOrder.ordersGoods.count+1){
        return 44;
    }else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ParentOrder *parentOrder = _orderList[section];
    return parentOrder.ordersGoods.count+2;  //加上上下状态cell和buttonCell
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParentOrder *parentOrder = _orderList[indexPath.section];
    
    if (indexPath.row == 0)
    {
        JSOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
//        cell.statusLabel.text = [NSString stringWithFormat:@"订单状态：%@", parentOrder.orderStatus];
//        cell.timeLabel.text = [NSString stringWithFormat:@"合计: ￥%@", parentOrder.totalPrice];
        return cell;
    }
    else if (indexPath.row == parentOrder.ordersGoods.count+1)
    {
        JSOrderBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        NSArray *statusTitles = nil;
        switch (parentOrder.status)
        {
            case 0:
                //待付款
                statusTitles = @[@"立即付款", @"取消订单"];
                break;
            case 1:
                //待发货
                statusTitles = @[@"提醒发货"];
                break;
            case 2:
                //待收货
                statusTitles = @[@"确认收货", @"查询物流"];
                break;
            case 3:
                //交易成功
                statusTitles = @[@"立即评价", @"申请售后", @"删除订单"];
                break;
            case 4:
                //售后审核中
                statusTitles = @[@"立即评价", @"删除订单"];
                break;
            case 5:
                //退换货中
                statusTitles = @[@"查看进度"];
                break;
            case 6:
                //待退款
                statusTitles = @[@"查看进度"];
                break;
            default:
                break;
        }
        [cell setupButtonsWithStatus:statusTitles];
        return cell;
    }else{
        JSOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
        OrderGoods *goods = parentOrder.ordersGoods[indexPath.row-1];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        cell.nameLabel.text = goods.goodsName;
//        cell.specLabel.text = goods.specValue;
//        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", goods.goodsPrice];
//        cell.quantityLabel.text = [NSString stringWithFormat:@"x %@", goods.quantity];
        
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
