//
//  JSGoodsFavoriteView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsFavoriteView.h"
#import "JSGoodsCVCell.h"
#import "JSGoodsFavCollRV.h"
#import "GetFavoriteData.h"
#import "GetGoodsFavData.h"
#import "JSGoodsFavoFliterBar.h"

@interface JSGoodsFavoriteView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *goodsFavTopBarView;
@property (weak, nonatomic) JSGoodsFavoFliterBar *goodsFavFilterBar;


@end

@implementation JSGoodsFavoriteView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self addGoodsFavFitlerToolBar];//顶部分类按钮方法
    
    _goodsFavCollectView.delegate = self;
    _goodsFavCollectView.dataSource = self;


    [_goodsFavCollectView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
    
    [_goodsFavCollectView registerNib:[UINib nibWithNibName:@"JSGoodsFavCollRV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GoodsFavHeader"];
    
    __weak typeof(self) weakSelf = self;
    
    self.goodsFavCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        [weakSelf initModelsAndPager];
        [weakSelf requestFavoriteListWithStatus:@""];
    }];
    self.goodsFavCollectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
        [weakSelf requestFavoriteListWithStatus:@""];
    }];
    
    //筛选有货的通知
    [M_NOTIFICATION addObserver:self selector:@selector(fliterHaveGoodsNotifiMethod) name:@"FliterHaveGoodsNotifi" object:nil];
}


#pragma mark - Private Methods

/**
 *  设置基本参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = @"10";
    self.goodsFavArray = [NSMutableArray array];
    [self.goodsFavCollectView reloadData];
}

/**
 * 请求商品收藏的数据
 */
- (void)requestFavoriteListWithStatus:(NSString *)status
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *parma = @{@"sort":status,@"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage], @"pageNumber": _pageNumber};
    
    [GetGoodsFavData postWithUrl:RMRequestStatusGoodsCollectList param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error) {
         [self.goodsFavCollectView.mj_header endRefreshing];
         [self.goodsFavCollectView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage ++;
             [weakSelf.goodsFavArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.goodsFavCollectView reloadData];
         
        // 设置没有数据时候的提示语句
         
         if (_goodsFavArray.count == 0) {
             _goodsFavTipsLab.text = @"收藏夹是空的。";
         } else {
             [_goodsFavTipsLab removeFromSuperview];
         }
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.goodsFavCollectView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  商品收藏顶部筛选工具栏
 */
- (void)addGoodsFavFitlerToolBar
{
    _goodsFavFilterBar = [[NSBundle mainBundle] loadNibNamed:@"JSGoodsFavoFliterTool" owner:self options:nil].firstObject;
    [_goodsFavFilterBar setGoodsFavSelectedIndex:0];
    
    //点击事件
    [_goodsFavFilterBar setGoodsFavSelectBlock:^(NSInteger idx) {
        //当前页数重置为1
        self.currentPage = 1;
        //移除其它状态下数组中的元素
        [self.goodsFavArray removeAllObjects];
        
        switch (idx) {
            case 0:{    //默认
                [self requestFavoriteListWithStatus:@""];
            }
                break;
            case 1:{    //降价优先
                [self requestFavoriteListWithStatus:@"depreciate"];
            }
                break;
            case 2:{    //促销优先
                [self requestFavoriteListWithStatus:@"promotion"];
            }
                break;
            default:{   //筛选界面
                
                [M_NOTIFICATION postNotificationName:@"SkipFliterVCNOtifi" object:nil];
            }
                break;
        }
    }];
    
    [self.goodsFavTopBarView addSubview:_goodsFavFilterBar];
}

#pragma mark - Actions
/**
 *  筛选有货通知的方法
 *
 *  Notificaion
 */
- (void)fliterHaveGoodsNotifiMethod
{
    [self requestFavoriteListWithStatus:@"stock"];
}

/**
 *  添加购物车按钮
 */
- (void)goodsFavAddShopCarBtnClick:(UIButton *)sender
{
    Goods *goods = _goodsFavArray[sender.tag];
    [WMGeneralTool addShopCarBtnClickwith:goods.goodsId];
}

#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goods = _goodsFavArray[indexPath.row];
    
//发跳转商品详情的通知
    [M_NOTIFICATION postNotificationName:@"GoodsFavSkipDetailVC" object:nil userInfo:@{@"GoodsFavID":goods.goodsId}];
}

#pragma mark - collectionView datasouse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _goodsFavArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = WIDTH / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.15f+52.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];
    WMGoodsFav *goods = _goodsFavArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.nameLabel.text = goods.name?goods.name:@"";
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:¥%.2f%@",goods.goodsWholesalePrice,goods.unit?goods.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:¥%.2f%@",goods.goodsRetailPrice,goods.unit?goods.unit:@""];
    
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@",goods.goodsSales,goods.unit?goods.unit:@""];
    
    [cell.addShopCarBtn addTarget:self action:@selector(goodsFavAddShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;
    
    return cell;
}

// 设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 160);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 设置区头
        JSGoodsFavCollRV *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GoodsFavHeader" forIndexPath:indexPath];
        
        return headerView;
    } else {
        return nil;
    }
}

@end
