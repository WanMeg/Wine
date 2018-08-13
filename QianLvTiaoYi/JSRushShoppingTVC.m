//
//  JSRushShoppingTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRushShoppingTVC.h"
#import "JSRushShoppingTVCell.h"
#import "GetActivityGoodsListData.h"
#import "GetBannersData.h"
#import "JSGoodsDetailVC.h"

@interface JSRushShoppingTVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *rushShopArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (nonatomic, strong) NSMutableArray *rushShopBannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JSRushShoppingTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.bannerImgArray = [NSMutableArray array];
    self.rushShopBannerArray = [NSMutableArray array];
    
    [self setRushShopHeaderViewBannerImg];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSRushShoppingTVCell" bundle:nil] forCellReuseIdentifier:@"rushShoppingCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getRushShoppingRequestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getRushShoppingRequestData];
    }];
    
    [self setBasicParameter];
    [self getRushShoppingRequestData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Private

/**
 *  设置banner图
 **/
- (void)setRushShopHeaderViewBannerImg
{
    CGRect rect = CGRectMake(0,0,WIDTH,160);
    
    SDCycleScrollView * rushShopScroll = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:nil placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusRushShoppingBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [weakSelf.rushShopBannerArray
              addObjectsFromArray:dataObj];
             for (WMBanners *banner in _rushShopBannerArray) {
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
    self.rushShopArray = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求限时抢购的数据
 */
- (void)getRushShoppingRequestData
{
    NSDictionary *param = @{@"activityType":@"1",@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetActivityGoodsListData postWithUrl:RMRequestStatusActivityGoodsList param:param modelClass:[WMActivityGoodsList class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             [weakSelf.rushShopArray addObjectsFromArray:dataObj];
         }
         [weakSelf.tableView reloadData];
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
    }];
}

#pragma mark - NSTimer method

/**
 *  定时器控制倒计时方法
 */
- (void)timerMethod:(NSTimer *)timer
{
    NSDictionary *dict = [timer userInfo];
    
    JSRushShoppingTVCell *cell = dict[@"cell"];
    NSInteger index = [dict[@"cellIndex"] integerValue];
    WMActivityGoodsList *activity = _rushShopArray[index];
    NSDate *today = [NSDate date];
    if ([WMGeneralTool judgeAssignTimeWith:[activity.beginTime longLongValue]]) {
        //活动已开始  显示 距离结束时间  展示当前距离结束的时间
        NSString *countTime = [WMGeneralTool getCountTimeWithOneTime:[today timeIntervalSince1970] withTwoTime:[activity.endTime longLongValue]];
        if ([countTime isEqualToString:@"活动已结束"]) {
            cell.rushShopEndTime.text = @"活动已结束";
        } else {
            cell.rushShopEndTime.text = [NSString stringWithFormat:@"距离结束:%@",countTime];
        }
    } else {
        //活动未开始  显示 距离开始时间  展示开始时间距离当前的时间
        cell.rushShopEndTime.text = [NSString stringWithFormat:@"距离开始:%@",[WMGeneralTool getCountTimeWithOneTime:[today timeIntervalSince1970] withTwoTime:[activity.beginTime longLongValue]]];
    }
}

#pragma mark - Actions

- (IBAction)backHomePageVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMActivityGoodsList *activity = _rushShopArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = activity.goodsId;
    vc.activityType = @"1";
    vc.activityId = activity.activityId;
    vc.isActivityGoods = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rushShopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSRushShoppingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rushShoppingCell" forIndexPath:indexPath];
    
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:@{@"cell":cell ,@"cellIndex":index} repeats:YES];
    
    WMActivityGoodsList *activity = _rushShopArray[indexPath.row];
    
    [cell.rushShopGoodsImg sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.rushShopNameLab.text = activity.title;
    cell.rushShopSubTitle.text = activity.activityTitle;
    cell.rushShopSaleScaleLab.text = [NSString stringWithFormat:@"已售%.2f%@",activity.awardedNum,@"%"];
    cell.rushShopSaleLab.text = [NSString stringWithFormat:@"已抢购:%d",activity.goodsSales];
    cell.rushShopStartPrice.text = [NSString stringWithFormat:@"原价:¥%.2f",activity.marketPrice];
    cell.rushShopNowPrice.text = [NSString stringWithFormat:@"¥%.2f",activity.activityPrice];
    cell.rushShopProgress.progress = activity.awardedNum / 100.0;
    
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


#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无信息。";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



@end
