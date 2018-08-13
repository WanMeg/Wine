//
//  JSUserDetailTabVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSUserDetailTabVC.h"
#import "GetConsumeDetailData.h"
#import "JSConsumeDetailTVCell.h"

@interface JSUserDetailTabVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>



@property (nonatomic, strong) NSMutableArray *consumeUseDetailArr;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@end

@implementation JSUserDetailTabVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParam];
        [self getUserDetailRequestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getUserDetailRequestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Private Methods

- (void)setBasicParam
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.consumeUseDetailArr = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求账户明细数据
 */
- (void)getUserDetailRequestData
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetConsumeDetailData postWithUrl:RMRequestStatusConsumeUseDetails param:param modelClass:[WMConsumeDetail class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj)
         {
             weakSelf.currentPage++;
             
             [weakSelf.consumeUseDetailArr addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200)
         {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _consumeUseDetailArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSConsumeDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"consumeDetail" forIndexPath:indexPath];
    WMConsumeDetail *consume = _consumeUseDetailArr[indexPath.row];
    
    cell.userDetailTimeLab.text = consume.changeDate;
    cell.userDetailMoneyLab.text = consume.changeMoney;
    cell.userDetailBalanceLab.text = consume.currentBalance;
    
    //金额变动类型
    switch (consume.changeType) {
        case 0:{
            cell.userDetailStyleLab.text = @"收入";
        }
            break;
        case 1:{
            cell.userDetailStyleLab.text = @"支出";
        }
            break;
        case 2:{
            cell.userDetailStyleLab.text = @"充值";
        }
            break;
        case 3:{
            cell.userDetailStyleLab.text = @"提现";
        }
            break;
        case 4:{
            cell.userDetailStyleLab.text = @"退款";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无信息。";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
