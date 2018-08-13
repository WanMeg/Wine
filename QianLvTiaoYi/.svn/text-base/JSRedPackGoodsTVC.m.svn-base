//
//  JSRedPackGoodsTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRedPackGoodsTVC.h"

#import "JSFootprintTVCell.h"
#import "GetCouponGoodsData.h"
#import "JSGoodsDetailVC.h"

@interface JSRedPackGoodsTVC ()


@property (nonatomic, strong) NSMutableArray *couponGoodsArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@end

@implementation JSRedPackGoodsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSFootprintTVCell" bundle:nil] forCellReuseIdentifier:@"redPackGoodsCell"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParameter];
        [self getCouponGoodsListRequest];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getCouponGoodsListRequest];
    }];
    
    [self.tableView.mj_header beginRefreshing];
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
    [self.tableView reloadData];
}

/**
 *  请求红包商品列表数据
 */
- (void)getCouponGoodsListRequest
{
    NSString *useScope = @"";
    
    if (_useTheScope == 0)
    {
        useScope = @"autotrophy";
    } else if (_useTheScope == 1)
    {
        useScope = @"shop";
    } else
    {
        useScope = @"goods";
    }
    
    NSDictionary *param = @{@"couponId":_couponID,@"type":useScope,@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetCouponGoodsData getWithUrl:RMRequestStatusRedpacketGoodsList param:param modelClass:[WMCouponGoods class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             
             [weakSelf.couponGoodsArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}


/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin
{
    if (M_MEMBER_LOGIN) {
        return YES;
    }else {
        PRAlertView *alertView = [[PRAlertView alloc] init];
        __weak typeof(self) weakSelf = self;
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
                UIViewController * NC = [sb instantiateViewControllerWithIdentifier:@"LoginNC"];
                [weakSelf presentViewController:NC animated:YES completion:nil];
            }
        }];
        return NO;
    }
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  加入购物车按钮点击事件
 */
- (void)redPackAddShopCartBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        WMCouponGoods *couponGoods = _couponGoodsArray[sender.tag];
        [WMGeneralTool addShopCarBtnClickwith:couponGoods.goodsId];
    }
}


#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    WMCouponGoods *couponGoods = _couponGoodsArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = couponGoods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableView datasource

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
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.footprintPiFaLab.text = [NSString stringWithFormat:@"批:%.2f/%@",couponGoods.price,couponGoods.unit?couponGoods.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.footprintPiFaLab.text = @"认证可见";
    } else {
        cell.footprintPiFaLab.text = @"登录认证可见";
    }
    
    cell.footprintRetailLab.text = [NSString stringWithFormat:@"零:%.2f/%@",couponGoods.goodsPrice,couponGoods.unit?couponGoods.unit:@""];
    
    cell.footprintSalesLab.text = [NSString stringWithFormat:@"销量:%@%@",couponGoods.goodsSales,couponGoods.unit?couponGoods.unit:@""];
    ;
    
    [cell.addShopCartBtn addTarget:self action:@selector(redPackAddShopCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCartBtn.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
