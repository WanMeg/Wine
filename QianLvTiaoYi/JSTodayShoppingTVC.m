//
//  JSTodayShoppingTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSTodayShoppingTVC.h"

#import "JSTodayShopTVCell.h"

#import "GetActivityGoodsListData.h"
#import "GetBannersData.h"

#import "JSGoodsDetailVC.h"

@interface JSTodayShoppingTVC ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) NSMutableArray *todayShopArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (nonatomic, strong) NSMutableArray *todayShopBannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;



@end

@implementation JSTodayShoppingTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSTodayShopTVCell" bundle:nil] forCellReuseIdentifier:@"todayShopCell"];
    
    self.todayShopBannerArray = [NSMutableArray array];
    self.bannerImgArray = [NSMutableArray array];
    
    [self setHeaderViewBannerImage];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getTodayShoppingRequestData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getTodayShoppingRequestData];
        
    }];
    [self setBasicParameter];
    [self getTodayShoppingRequestData];
}

#pragma mark - Private

/**
 *  设置banner图
 */
- (void)setHeaderViewBannerImage
{
    CGRect rect = CGRectMake(0,0,WIDTH,160);
    SDCycleScrollView * rushShopScroll = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:nil placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusTodayShoppingBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [weakSelf.todayShopBannerArray
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _todayShopBannerArray) {
                 NSString *imgStr = banner.imgUrl;
                 
                 [_bannerImgArray addObject:imgStr];
             }
             rushShopScroll.imageURLStringsGroup = self.bannerImgArray;
         }
     }];
    
    rushShopScroll.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    rushShopScroll.showPageControl = YES;
    rushShopScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    rushShopScroll.currentPageDotColor = [UIColor blackColor];
    rushShopScroll.pageDotColor = [UIColor grayColor];
    
    [_headerView addSubview:rushShopScroll];
}

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.todayShopArray = [NSMutableArray array];

    [self.tableView reloadData];
}

/**
 *  请求今日团购的数据
 */
- (void)getTodayShoppingRequestData
{
    
    NSDictionary *param = @{@"activityType":[NSString stringWithFormat:@"%d",0],@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetActivityGoodsListData postWithUrl:RMRequestStatusActivityGoodsList param:param modelClass:[WMActivityGoodsList class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             
             [weakSelf.todayShopArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}


#pragma mark - Actions

- (IBAction)backHomePageVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMActivityGoodsList *activity = _todayShopArray[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = activity.goodsId;
    vc.activityType = @"0";
    vc.activityId = activity.activityId;
    vc.isActivityGoods = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _todayShopArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSTodayShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayShopCell" forIndexPath:indexPath];
    
    WMActivityGoodsList *activity = _todayShopArray[indexPath.row];

    [cell.todayShopGoodsImg sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.todayShopGoodsName.text = activity.title;
    cell.todayShopSubTitle.text = activity.activityLabel;
    cell.todayShopDesLab.text = activity.des;
    cell.todayShopSaleLab.text = [NSString stringWithFormat:@"已付款:%d人",activity.goodsSales];
    cell.todayShopStartPrice.text = [NSString stringWithFormat:@"市场价:¥%.2f",activity.marketPrice];
    cell.todayShopNowPrice.text = [NSString stringWithFormat:@"¥%.2f",activity.activityPrice];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
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
