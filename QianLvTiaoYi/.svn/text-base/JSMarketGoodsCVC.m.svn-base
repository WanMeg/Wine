//
//  JSMarketGoodsCVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSMarketGoodsCVC.h"

#import "GetMarketGoodsData.h"
#import "JSGoodsCVCell.h"
#import "JSGoodsDetailVC.h"


@interface JSMarketGoodsCVC ()

@property (nonatomic, strong) NSMutableArray *marketGoodsArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@property (nonatomic, strong) WMMarketGoods *marketGoods;
@end

@implementation JSMarketGoodsCVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self setBasicParameter];
        [self getMarketGoodsRequestData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getMarketGoodsRequestData];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Private Method

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.marketGoods = nil;
    [self.collectionView reloadData];
}

/**
 *  请求商城活动商品的数据
 */
- (void)getMarketGoodsRequestData
{
    NSDictionary *param = @{@"marketingActivityId":_marketActivityId, @"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetMarketGoodsData postWithUrl:RMRequestStatusMarketActivityGoods param:param modelClass:[WMMarketGoods class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.collectionView.mj_header endRefreshing];
         [self.collectionView.mj_footer endRefreshing];
         
         WMMarketGoods *obj = dataObj;
         if (obj)
         {
             if (weakSelf.marketGoods.goods == nil)
             {
                 weakSelf.marketGoods = obj;
             } else {
                 [weakSelf.marketGoods.goods addObjectsFromArray:obj.goods];
             }
             
             weakSelf.currentPage ++;
         }
         
         [weakSelf.collectionView reloadData];
         
         if (error.code == 200 || error.code == 200)
         {
             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _marketGoods.goods.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = (WIDTH - 15) / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.02+60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];
    
    WMMarketActGoods *goods = _marketGoods.goods[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.goodsImage] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    cell.nameLabel.text = goods.goodsName;
    cell.piPriceLabel.text = [NSString stringWithFormat:@"批:￥%.0f/%@", goods.wholesalePrice, goods.unit?goods.unit:@""];
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.0f/%@", goods.retailPrice, goods.unit?goods.unit:@""];
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@", goods.goodsSales, goods.unit?goods.unit:@""];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMMarketActGoods *goods = _marketGoods.goods[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
