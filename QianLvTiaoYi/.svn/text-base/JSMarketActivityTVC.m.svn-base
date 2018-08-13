//
//  JSMarketActivityTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSMarketActivityTVC.h"
#import "JSMarketTabVCell.h"
#import "GetMarketActivityData.h"
#import "JSMarketGoodsCVC.h"
@interface JSMarketActivityTVC ()

@property (nonatomic, strong) NSMutableArray *marketActArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@end

@implementation JSMarketActivityTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self setBasicParameter];
        [self getMarketActRequestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getMarketActRequestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Private Method

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.marketActArray = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求商城活动的数据
 */
- (void)getMarketActRequestData
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetMarketActivityData postWithUrl:RMRequestStatusMarketActivity param:param modelClass:[WMMarketActivity class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj)
         {
             weakSelf.currentPage++;
             
             [weakSelf.marketActArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200)
         {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

#pragma mark - Actions

- (IBAction)backHomePageVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _marketActArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSMarketTabVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketActivityCell" forIndexPath:indexPath];
    WMMarketActivity *market = _marketActArray[indexPath.row];
    
    [cell.marketActivityImg sd_setImageWithURL:[NSURL URLWithString:market.marketingRuleImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMMarketActivity *market = _marketActArray[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
    JSMarketGoodsCVC *marketGoodsVC = [storyboard instantiateViewControllerWithIdentifier:@"MarketGoodsCVC"];
    
    marketGoodsVC.marketActivityId = market.marketingRuleId;
    NSLog(@"marketGoodsVC.marketActivityId = %@",marketGoodsVC.marketActivityId);
    
    [self.navigationController pushViewController:marketGoodsVC animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *timeLab = [[UILabel alloc]init];
    
    timeLab.center = view.center;
    
    timeLab.bounds = CGRectMake(0, 0, WIDTH, 40);
    
    timeLab.font = [UIFont systemFontOfSize:15];
    
    timeLab.textAlignment = NSTextAlignmentCenter;
    
    WMMarketActivity *market = _marketActArray[section];
    timeLab.text = [NSString stringWithFormat:@"上架日期:%@",market.ruleExpiryDate];
    
    [view addSubview:timeLab];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
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
