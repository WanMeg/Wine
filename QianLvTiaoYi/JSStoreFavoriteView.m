//
//  JSStoreFavoriteView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSStoreFavoriteView.h"
#import "JSGoodsCVCell.h"
#import "JSStoreFavCollRV.h"
#import "GetStoreFavData.h"
#import "JSStoreFavFliterBar.h"


@interface JSStoreFavoriteView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIView *storeFavTopBarView;
@property (weak, nonatomic) JSStoreFavFliterBar *storeFavFilterBar;
@property (nonatomic, strong) NSMutableArray *storeFavArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation JSStoreFavoriteView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self addStoreFavFitlerToolBar];//添加顶部分类按钮
    
    _storeFavCollectView.delegate = self;
    _storeFavCollectView.dataSource = self;
    _storeFavCollectView.emptyDataSetSource = self;
    _storeFavCollectView.emptyDataSetDelegate = self;
    
    [_storeFavCollectView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
    [_storeFavCollectView registerNib:[UINib nibWithNibName:@"JSStoreFavCollRV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreFavHeader"];
    
    
    self.storeFavCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initModelsAndPager];
        [self getStoreFavRequestListWithSort:@""];
    }];
    
    self.storeFavCollectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getStoreFavRequestListWithSort:@""];
    }];
    
}

#pragma mark - Private Methods

/**
 *  设置基本参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.storeFavArray = [NSMutableArray array];
    [self.storeFavCollectView reloadData];
}

/**
 *  获取店铺收藏的请求数据
 */
- (void)getStoreFavRequestListWithSort:(NSString *)sort
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber],@"sort":sort?sort:@""};
    
    __weak typeof(self) weakSelf = self;
    
    [GetStoreFavData postWithUrl:RMRequestStatusStoreCollectList param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         [self.storeFavCollectView.mj_header endRefreshing];
         [self.storeFavCollectView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage++;
             [weakSelf.storeFavArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.storeFavCollectView reloadData];
         
        // 设置没有数据时候的提示语句
         
         if (_storeFavArray.count == 0) {
             _tipsLabel.text = @"收藏夹是空的。";
         } else {
             [_tipsLabel removeFromSuperview];
         }
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.storeFavCollectView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  店铺收藏顶部筛选工具栏
 */
- (void)addStoreFavFitlerToolBar
{
    
    _storeFavFilterBar = [[NSBundle mainBundle] loadNibNamed:@"JSStoreFavFliterTool" owner:self options:nil].firstObject;
    [_storeFavFilterBar setStoreFavSelectedIndex:0];
    
    //点击事件
    [_storeFavFilterBar setStoreFavSelectBlock:^(NSInteger idx) {
        //当前页数重置为1
        self.currentPage = 1;
        //移除其它状态下数组中的元素
        [self.storeFavArray removeAllObjects];
        
        switch (idx) {
            case 0:{
                [self getStoreFavRequestListWithSort:@""];
            }
                break;
            case 1:{
                [self getStoreFavRequestListWithSort:@"activity"];
            }
                break;
            default:{
                [self getStoreFavRequestListWithSort:@"coupon"];
            }
                break;
        }
    }];
    [self.storeFavTopBarView addSubview:_storeFavFilterBar];
}

#pragma mark - Actions

/**
 *  进店逛逛按钮
 *
 *  传值 shopId
 */
- (void)enterStoreStrollClick:(UIButton *)sender
{
    WMStoreFav *store = _storeFavArray[sender.tag/1000];
    
    [M_NOTIFICATION postNotificationName:@"StoreFavSkipStoreDetailVC" object:nil userInfo:@{@"shopId": store.shopId}];
}

/**
 *  加入购物车按钮
 */
- (void)storeFavAddShopCarBtnClick:(UIButton *)sender
{
    WMStoreFav *store = _storeFavArray[sender.tag/1000];
    WMMapGoods * mapGoods = store.mapGoods[sender.tag%1000];
    [WMGeneralTool addShopCarBtnClickwith:mapGoods.goodsId];
}

#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMStoreFav *store = _storeFavArray[indexPath.section];
    WMMapGoods * mapGoods = store.mapGoods[indexPath.row];
    
    //点击item时 给favoriteVC发送通知 通知跳转到商品详情界面
    [M_NOTIFICATION postNotificationName:@"GoodsFavSkipDetailVC" object:nil userInfo:@{@"GoodsFavID":mapGoods.goodsId}];
}

#pragma mark - collectionView datasouse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _storeFavArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMStoreFav *store = _storeFavArray[section];
    return store.mapGoods.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = WIDTH / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.15f+52.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];
    
    WMStoreFav *store = _storeFavArray[indexPath.section];
    WMMapGoods * mapGoods = store.mapGoods[indexPath.row];
    
    //图片
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:mapGoods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    //名称
    cell.nameLabel.text = mapGoods.goodsName?mapGoods.goodsName:@"";
   
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:¥%.2f/%@",mapGoods.goodsWholesalePrice, mapGoods.unit?mapGoods.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }

    //销量
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@",mapGoods.goodsSales,mapGoods.unit?mapGoods.unit:@""];
    
    [cell.addShopCarBtn addTarget:self action:@selector(storeFavAddShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.section  * 1000 + indexPath.row;

    
    return cell;
}

// 设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 65);
}
//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 设置区头
        JSStoreFavCollRV *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreFavHeader" forIndexPath:indexPath];
        WMStoreFav *store = _storeFavArray[indexPath.section];
        
        [headerView.storeFavHeaderIconImg sd_setImageWithURL:[NSURL URLWithString:store.shopLogo] placeholderImage:[UIImage imageNamed:@"noimage"]];
        headerView.storeFavHeaderNameLab.text = store.shopname;
        headerView.storeFavHeaderAddressLab.text = store.province;
        
        headerView.distanceLab.text = @"";
        
        if (store.shopType == 0) {
            headerView.storeFavHeaderBrandLab.text = @"直营店";
        } else {
            headerView.storeFavHeaderBrandLab.text = @"旗舰店";
        }
        
        headerView.enterStoreBtn.tag = indexPath.section;
        [headerView.enterStoreBtn addTarget:self action:@selector(enterStoreStrollClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    } else {
        return nil;
    }
}




@end