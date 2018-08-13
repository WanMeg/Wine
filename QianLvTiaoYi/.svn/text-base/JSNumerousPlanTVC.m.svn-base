//
//  JSNumerousPlanTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/1.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSNumerousPlanTVC.h"
#import "JSNumerousPlanCell.h"
#import "GetCrowdfundingData.h"
#import "GetBannersData.h"
#import "JSGoodsDetailVC.h"


@interface JSNumerousPlanTVC ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *crowdfundingArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (nonatomic, strong) NSMutableArray *crowdBannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;
@end

@implementation JSNumerousPlanTVC


#pragma mark - Life style

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.bannerImgArray = [NSMutableArray array];
    self.crowdBannerArray = [NSMutableArray array];
    
    [self setCrowdHeaderViewBannerImg];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getCrowdfundingRequestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getCrowdfundingRequestData];
    }];
    
    [self setBasicParameter];
    [self getCrowdfundingRequestData];
}

#pragma mark - HttpRequest

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.crowdfundingArray = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求商品众筹的数据
 */
- (void)getCrowdfundingRequestData
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetCrowdfundingData postWithUrl:RMRequestStatusCrowdfundingList param:param modelClass:[WMCrowdfunding class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             [weakSelf.crowdfundingArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}


/**
 *  设置banner图
 */
- (void)setCrowdHeaderViewBannerImg
{
    CGRect rect = CGRectMake(0,0,WIDTH,160);
    
    SDCycleScrollView * rushShopScroll = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:nil placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusCrowdBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [weakSelf.crowdBannerArray
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _crowdBannerArray) {
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

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMCrowdfunding *crowdfunding = _crowdfundingArray[indexPath.section];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.activityType = @"2";
    vc.goodsID = crowdfunding.goodsId;
    vc.activityId = crowdfunding.activityId;
    vc.isActivityGoods = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _crowdfundingArray.count;
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
    WMCrowdfunding *crowdfunding = _crowdfundingArray[indexPath.section];
    JSNumerousPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumerousPlanCell" forIndexPath:indexPath];

    [cell.bigImage sd_setImageWithURL:[NSURL URLWithString:crowdfunding.pic] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.activityName.text = crowdfunding.goodsName;
    cell.activitySpec.text = crowdfunding.des;
    
    cell.piFaPrice.text = [NSString stringWithFormat:@"批发价:¥%.2f",crowdfunding.wholesalePrice];
    cell.joinPeopleNum.text = [NSString stringWithFormat:@"%@人参与",crowdfunding.count];
    
    if (WIDTH == 320) {
        cell.downPayment.font = [UIFont boldSystemFontOfSize:12];
    }
    cell.downPayment.text = [NSString stringWithFormat:@"定金:¥%.2f/瓶",crowdfunding.handselScale];
    
    //阶段信息
    WMCrowdfundingStage *lastCs = crowdfunding.list.lastObject;
    cell.npProgress.progress = crowdfunding.salesNum / lastCs.stageStart;
    
    cell.lastNumber.text = [NSString stringWithFormat:@"%.0f件",lastCs.stageStart];
    cell.lastMoney.text = [NSString stringWithFormat:@"¥%@",lastCs.price];
    
    cell.centerNumber.text = [NSString stringWithFormat:@"%.0f件",lastCs.stageStart/2];
    
    cell.numLab.text = [NSString stringWithFormat:@"%.0f",crowdfunding.salesNum];
    
    float progressWidth;
    if (WIDTH == 320) {
        progressWidth = 114.0;
    } else {
        progressWidth = 170.0;
    }
    cell.numLab.frame = CGRectMake(cell.npProgress.frame.origin.x+progressWidth*cell.npProgress.progress, cell.npProgress.frame.origin.y, 8*cell.numLab.text.length, 9);
    
    /********************* 判断中间价格的显示 ************************/
    
    float centerStage = lastCs.stageStart / 2;
    for (WMCrowdfundingStage *cs in crowdfunding.list) {
        float start = cs.stageStart;
        float last = cs.stageEnd;
        if (centerStage >= start && centerStage < last) {
            cell.centerMoney.text = [NSString stringWithFormat:@"¥%@",cs.price];
        }
    }
    
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
