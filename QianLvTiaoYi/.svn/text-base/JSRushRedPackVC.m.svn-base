//
//  JSRushRedPackVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/6.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRushRedPackVC.h"

#import "JSRedPacketTVCell.h"
#import "GetRushRedPacketData.h"
#import "GetBannersData.h"

#import "JSRedPackGoodsTVC.h"
#import "JSGetCouponTVC.h"

@interface JSRushRedPackVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *rushRPTableview;

@property (nonatomic, strong) NSMutableArray *rushRPArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@property (nonatomic, strong) NSMutableArray *rushRPBannerArr;

//@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation JSRushRedPackVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_rushRPTableview registerNib:[UINib nibWithNibName:@"JSRedPacketTVCell" bundle:nil] forCellReuseIdentifier:@"redPacketTVCell"];

    self.rushRPTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getRushRedPacketRequestData];
        [self getRushRedPacketBannerRequest];
    }];
    
    self.rushRPTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getRushRedPacketRequestData];
        [self getRushRedPacketBannerRequest];
    }];
    
    [self.rushRPTableview.mj_header beginRefreshing];
}


#pragma mark - Private Methods

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.rushRPArray = [NSMutableArray array];
    self.rushRPBannerArr = [NSMutableArray array];
    [self.rushRPTableview reloadData];
}

/**
 *  请求主页红包列表的数据
 */
- (void)getRushRedPacketRequestData
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetRushRedPacketData postWithUrl:RMRequestStatusRushRedpacket param:param modelClass:[WMRushRedPacket class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.rushRPTableview.mj_header endRefreshing];
         [self.rushRPTableview.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             
             [weakSelf.rushRPArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.rushRPTableview reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.rushRPTableview.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  请求主页红包banner图
 */
- (void)getRushRedPacketBannerRequest
{
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusRushRedpacketBanner param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
    {
        if (dataObj) {
            [weakSelf.rushRPBannerArr addObjectsFromArray:dataObj];
            // NSLog(@"rushRPBannerArr = %ld",(unsigned long)_rushRPBannerArr.count);
            WMBanners *banner = [_rushRPBannerArr firstObject];
            [_bannerImage sd_setImageWithURL:[NSURL URLWithString:banner.imgUrl]];
        }
    }];
}

#pragma mark - Actions


- (IBAction)backHomePageVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMRushRedPacket *rushRP = _rushRPArray[indexPath.row];
    if (rushRP.applyRange == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        JSRedPackGoodsTVC *redPackGoodsVC = [storyboard instantiateViewControllerWithIdentifier:@"RedPackGoodsTVC"];
        
        redPackGoodsVC.couponID = rushRP.mallCouponId;
        redPackGoodsVC.useTheScope = rushRP.useScope;
        
        [self.navigationController pushViewController:redPackGoodsVC animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"可对所有商品使用"];
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rushRPArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMRushRedPacket *rushRP = _rushRPArray[indexPath.row];
    
    JSRedPacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketTVCell" forIndexPath:indexPath];
    //名称
    cell.activityTitleLab.text = rushRP.couponName;
    //图片
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:rushRP.couponImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    //红包额度
    cell.redPacketNumberLab.text = rushRP.couponQuota;
    
    //领取开始时间
    NSNumber *startTime = rushRP.receiveStartTime[@"time"];
    //结束时间
    NSNumber *endTime = rushRP.receiveEndTime[@"time"];
    //领取期限
    cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",[WMGeneralTool getNowReallyTimeWith:startTime],[WMGeneralTool getNowReallyTimeWith:endTime]];

    //满多少可使用
    cell.useConditionLab.text = [NSString stringWithFormat:@"满%@使用",rushRP.useCondition?rushRP.useCondition:@""];
    
    if (rushRP.applyRange == 0) { //指定商品范围 0 指定 1全部
        if (rushRP.isAutotrophy == 0) { //是否自营优惠券 0是 1否
            cell.goodsDetailLab.text = @"可购买自营店铺指定商品";
        } else {
            cell.goodsDetailLab.text = @"可购买非自营店铺指定商品";
        }
    } else { if (rushRP.isAutotrophy == 0) {
            cell.goodsDetailLab.text = @"可购买自营店铺所有商品";
        } else {
            cell.goodsDetailLab.text = @"可购买非自营店铺所有商品";
        }
    }
    
    cell.nowGetBlock = ^(NSInteger tag) {
        tag = indexPath.row;
        
        WMRushRedPacket *rushRP = _rushRPArray[tag];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        JSGetCouponTVC *getCouponVC = [storyboard instantiateViewControllerWithIdentifier:@"GetCouponTVC"];
        getCouponVC.coupon = rushRP;
        getCouponVC.isWhat = YES;
        [self.navigationController pushViewController:getCouponVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}



@end
