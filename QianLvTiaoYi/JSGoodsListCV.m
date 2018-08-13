//
//  JSGoodsListCV.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsListCV.h"
#import "JSContact.h"
#import "JSGoodsCVCell.h"

#import "GetUserData.h"

@implementation JSGoodsListCV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"JSGoodsCVCell" bundle:[NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:@"GoodsItem"];
}


- (void)updateDatasWithSectionCount:(NSInteger)itemsCount fetchText:(FetchGoodsBlcok)fetchGoodsBlock
{
    _itemsCount = itemsCount;
    _fetchGoodsBlock = fetchGoodsBlock;
    [self reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedBlock) {
        _selectedBlock(indexPath.row);
    }
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
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [M_NOTIFICATION postNotificationName:@"addShopCarNotifi" object:nil];
            }
        }];
        return NO;
    }
}

/**
 *  加入购物车按钮
 */
- (void)addShopCarBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        Goods *goods = _fetchGoodsBlock(sender.tag);
        
        [WMGeneralTool addShopCarBtnClickwith:goods.goodsId];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemsCount;
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
    
    if (_fetchGoodsBlock) {
        Goods *goods = _fetchGoodsBlock(indexPath.row);
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        cell.nameLabel.text = goods.name;
        
        //wm 用户没有登录只显示零售价  登录并认证后显示零售和批发价
        
        if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
            cell.piPriceLabel.text = [NSString stringWithFormat:@"批:￥%.2f/%@", goods.price, goods.unit];
            cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.2f/%@", goods.goodsPrice, goods.unit];
        } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
            cell.piPriceLabel.text = @"认证可见";
        } else {
            cell.piPriceLabel.text = @"登录认证可见";
        }
        cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.2f/%@", goods.goodsPrice, goods.unit];
        
        cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@", goods.goodsSales, goods.unit];
        [cell.addShopCarBtn addTarget:self action:@selector(addShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.addShopCarBtn.tag = indexPath.row;
    }
    
    return cell;
}

@end
