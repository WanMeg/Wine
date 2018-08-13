//
//  JSRedPackGoodsVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRedPackGoodsVC.h"

#import "JSFootprintTVCell.h"
#import "GetCouponGoodsData.h"

@interface JSRedPackGoodsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *redPackGoodsTabView;

@property (nonatomic, strong) NSMutableArray *couponGoodsArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@end

@implementation JSRedPackGoodsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [_redPackGoodsTabView registerNib:[UINib nibWithNibName:@"JSFootprintTVCell" bundle:nil] forCellReuseIdentifier:@"redPackGoodsCell"];
    
    
    self.redPackGoodsTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getCouponGoodsListRequest];
    }];
    
    self.redPackGoodsTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getCouponGoodsListRequest];
    }];
    
    [self.redPackGoodsTabView.mj_header beginRefreshing];
}

#pragma mark - Private

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.couponGoodsArray = [NSMutableArray array];
    [self.redPackGoodsTabView reloadData];
}

/**
 *  请求红包商品列表数据
 */
- (void)getCouponGoodsListRequest
{
    NSDictionary *param = @{@"couponId":_couponID,@"type":[NSString stringWithFormat:@"%d",_useTheScope],@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetCouponGoodsData getWithUrl:RMRequestStatusRedpacketGoodsList param:param modelClass:[WMCouponGoods class] responseBlock:^(id dataObj, NSError *error)
    {
        [self.redPackGoodsTabView.mj_header endRefreshing];
        [self.redPackGoodsTabView.mj_footer endRefreshing];
        
        if (dataObj)
        {
            weakSelf.currentPage++;
            
            [weakSelf.couponGoodsArray addObjectsFromArray:dataObj];
        }
        
        [weakSelf.redPackGoodsTabView reloadData];
        
        if (error.code == 200 || error.code == 200)
        {
            [weakSelf.redPackGoodsTabView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView Delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMCouponGoods *couponGoods = _couponGoodsArray[indexPath.row];
    
    JSFootprintTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redPackGoodsCell" forIndexPath:indexPath];
    
    [cell.footprintBigImage sd_setImageWithURL:[NSURL URLWithString:couponGoods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.footprintNameLab.text = couponGoods.name;
    
    cell.footprintSubTitleLab.text = couponGoods.des;
    
    cell.footprintPiFaLab.text = [NSString stringWithFormat:@"批:%.2f/%@",couponGoods.price,couponGoods.unit?couponGoods.unit:@""];
    
    cell.footprintRetailLab.text = [NSString stringWithFormat:@"零:%.2f/%@",couponGoods.goodsPrice,couponGoods.unit?couponGoods.unit:@""];
    
    cell.footprintSalesLab.text = [NSString stringWithFormat:@"销量:%@%@",couponGoods.goodsSales,couponGoods.unit?couponGoods.unit:@""];
    ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
