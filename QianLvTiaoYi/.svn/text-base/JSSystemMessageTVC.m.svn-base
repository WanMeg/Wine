//
//  JSSystemMessageTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/4.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSystemMessageTVC.h"
#import "JSSystemMessageTVCell.h"
#import "GetSystemNewsData.h"
#import "JSSMDetailVC.h"
@interface JSSystemMessageTVC ()
@property (nonatomic, strong) NSMutableArray *systemNewsArr;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/


@end

@implementation JSSystemMessageTVC


#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParam];
        [self getNewsListRequestList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNewsListRequestList];
    }];
    [self setBasicParam];
    [self getNewsListRequestList];
}
#pragma mark - Private Methods

- (void)setBasicParam
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.systemNewsArr = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求系统消息的数据
 */
- (void)getNewsListRequestList
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetSystemNewsData postWithUrl:RMRequestStatusSystemNews param:param modelClass:[WMSystemNews class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             [weakSelf.systemNewsArr addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  请求删除消息
 *
 *  @param newsID 消息ID
 */
- (void)requestRemoveNewsListWithNewId:(NSString *)newsID finish:(void(^)(BOOL success))finish
{
    
    [XLDataService getWithUrl:RMRequestStatusSystemDeleteNews param:@{@"delItems": newsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             finish(YES);
         } else {
             finish(NO);
         }
     }];
}

/**
 *  消息已读
 *
 *  @param newsID 消息ID
 */
- (void)requestRedNewsListWithNewsId:(NSString *)newsID finish:(void(^)(BOOL success))finish
{
    
    [XLDataService getWithUrl:RMRequestStatusSystemReadNews param:@{@"upItems": newsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             finish(YES);
         } else {
             finish(NO);
         }
     }];
}

#pragma mark - Actions

- (IBAction)backMemberVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _systemNewsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSSystemMessageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemMessageCell" forIndexPath:indexPath];
    
    WMSystemNews *news = _systemNewsArr[indexPath.section];
    cell.messageSendTimeLab.text = news.newsTime;
    cell.messageSendContentLab.text = news.newsTitle;
    
    if (news.isRead == 0) {
        cell.readNewsLab.text = @"未读";
        cell.readNewsLab.textColor = [UIColor redColor];
    } else {
        cell.readNewsLab.text = @"已读";
        cell.readNewsLab.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置编辑风格为删除风格
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        WMSystemNews *news = _systemNewsArr[indexPath.section];
        
        __weak typeof(self) weakSelf = self;
        
        [self requestRemoveNewsListWithNewId:[NSString stringWithFormat:@"%d",news.mallNewsId] finish:^(BOOL success)
         {
             if (success) {
                 [_systemNewsArr removeObjectAtIndex:indexPath.section];
                 [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                 [weakSelf.tableView reloadData];
             } else {
                 [SVProgressHUD showErrorWithStatus:@"删除记录失败！"];
             }
         }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSystemNews *news = _systemNewsArr[indexPath.section];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
    JSSMDetailVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"SMDetailVC"];
    // 标为已读
    [self requestRedNewsListWithNewsId:[NSString stringWithFormat:@"%d",news.mallNewsId] finish:^(BOOL success)
     {
         if (success) {
             news.isRead = YES;
         }
    }];
    detailVC.newsTitle = news.newsTitle;
    detailVC.newsContent = [NSString stringWithFormat:@"%@",news.newsContent];
    [self.navigationController pushViewController:detailVC animated:YES];
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
