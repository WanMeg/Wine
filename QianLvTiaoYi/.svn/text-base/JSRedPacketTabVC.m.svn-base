//
//  JSRedPacketTabVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/27.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRedPacketTabVC.h"
#import "JSRedPacketTVCell.h"

#import "GetRedPacketData.h"
#import "JSRedPackGoodsTVC.h"
@interface JSRedPacketTabVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topThreeViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *topThreeLabs;
@property (nonatomic, strong) WMRedPacket *redPacket;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (nonatomic, assign) int isSelectIndex;

@end

@implementation JSRedPacketTabVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UILabel *label = _topThreeLabs[0];
    label.textColor = [UIColor redColor];
    
    [self addThreeViewsTapClick];
    
    self.tableView.rowHeight = 160;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSRedPacketTVCell" bundle:nil] forCellReuseIdentifier:@"redPacketTVCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [self initModelsAndPager];
        [self getRedPacketRequestDataWithStatus:0];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
    {
        [self getRedPacketRequestDataWithStatus:0];
    }];
    
    [self initModelsAndPager];
    [self getRedPacketRequestDataWithStatus:0];
}

#pragma mark - Private methods

/**
 *  设置参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.redPacket = nil;
    [self.tableView reloadData];
}

/**
 *  获取红包数据的请求
 */
- (void)getRedPacketRequestDataWithStatus:(int)status
{
    NSDictionary *param = @{@"status":[NSString stringWithFormat:@"%d",status],@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetRedPacketData postWithUrl:RMRequestStatusMemberRedPacket param:param modelClass:[WMRedPacket class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         WMRedPacket *obj = dataObj;
         if (obj) {
             if (weakSelf.redPacket.couponList == nil) {
                 weakSelf.redPacket = obj;
             } else {
                 [weakSelf.redPacket.couponList addObject:obj.couponList];
             }
             weakSelf.currentPage++;
             [weakSelf updateUIWithInfo:obj.countAll];
         }

         [weakSelf.tableView reloadData];
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  设置三个数量的值
 */
- (void)updateUIWithInfo:(NSMutableArray *)countAll
{
    //赋值
    UILabel *label1 = _topThreeLabs[0];
    UILabel *label2 = _topThreeLabs[1];
    UILabel *label3 = _topThreeLabs[2];
    
    for (WMRedCount *count in countAll) {
        switch (count.status) {
            case 0:{
                label1.text = [NSString stringWithFormat:@"未使用(%d)",count.count];
            }
                break;
            case 1:{
                label2.text = [NSString stringWithFormat:@"已使用(%d)",count.count];
            }
                break;
            default:{
                label3.text = [NSString stringWithFormat:@"已过期(%d)",count.count];
            }
                break;
        }
    }
}

/**
 *  上面三个view添加点击手势
 */
- (void)addThreeViewsTapClick
{
    [_topThreeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfThreeViews:)];
         [obj addGestureRecognizer:tap];
     }];
}


/**
 *  红包商品列表
 */
- (void)couponGoodsListWith:(NSInteger)index
{
    WMCoupon *coupon = _redPacket.couponList[index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
    JSRedPackGoodsTVC *redPackGoodsVC = [storyboard instantiateViewControllerWithIdentifier:@"RedPackGoodsTVC"];
    redPackGoodsVC.couponID = coupon.mallCouponId;
    redPackGoodsVC.useTheScope = coupon.useScope;
    [self.navigationController pushViewController:redPackGoodsVC animated:YES];
}

#pragma mark - Actions

/**
 *  上面三个view点击手势方法
 */
- (void)handleTapOfThreeViews:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < _topThreeLabs.count; i++) {
        UILabel *label = _topThreeLabs[i];
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //当前页数重置为1
    self.currentPage = 1;
    self.redPacket = nil;
    //移除其它状态下数组中的元素
    [self.redPacket.couponList removeAllObjects];
    
    switch (sender.view.tag) {
        case 0:{

            [self getRedPacketRequestDataWithStatus:0];
        }
            break;
        case 1:{
            
            [self getRedPacketRequestDataWithStatus:1];
        }
            break;
        default:{
            
            [self getRedPacketRequestDataWithStatus:2];
        }
            break;
    }
}

- (IBAction)backMemberVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _redPacket.couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSRedPacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketTVCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WMCoupon *coupon = _redPacket.couponList[indexPath.row];


    cell.activityTitleLab.text = coupon.couponName;
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:coupon.couponImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.redPacketNumberLab.text = coupon.couponQuota;
    cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",coupon.validStartTime?coupon.validStartTime:@"",coupon.validEndTime?coupon.validEndTime:@""];
    
    //领取开始时间
    NSNumber *startTime = coupon.validStartTime[@"time"];
    //结束时间
    NSNumber *endTime = coupon.validEndTime[@"time"];
    
    //领取期限
    cell.timeLimitLab.text = [NSString stringWithFormat:@"%@ 到 %@",[WMGeneralTool getNowReallyTimeWith:startTime],[WMGeneralTool getNowReallyTimeWith:endTime]];
    
    if (coupon.useScope == 0) {
        cell.goodsDetailLab.text = @"可购买平台商品";
    } else if (coupon.useScope == 1) {
        cell.goodsDetailLab.text = @"可购买店铺商品";
    } else {
        cell.goodsDetailLab.text = @"仅可购买指定商品";
    }
    
    cell.useConditionLab.text = [NSString stringWithFormat:@"满%@使用",coupon.useCondition?coupon.useCondition:@""];
    

    cell.getNowLab.text = @"立即使用";
    
    cell.nowGetBlock = ^(NSInteger tag) {
        tag = indexPath.row;
        
        [self couponGoodsListWith:tag];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self couponGoodsListWith:indexPath.row];
}

#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有红包信息";
    
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
