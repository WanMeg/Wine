//
//  StoreDetailVC.m
//  QianLvTiaoYi
//
//  Created by Gollum on 16/4/17.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "StoreDetailVC.h"
#import "StoreNavigationBar.h"
#import "GetShopGoodsData.h"
#import "GetGoodsListData.h"
#import "JSCAGoodsItem.h"
#import "JSGoodsFavCollRV.h"
#import "JSGoodsDetailVC.h"
#import "JSStoreDetailTVC.h"

@interface StoreDetailVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) StoreNavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIView *sgClearView;
@property (weak, nonatomic) IBOutlet UIImageView *sgBannerImg;
@property (weak, nonatomic) IBOutlet UIImageView *sgLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *sgNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sgShopKindLab;
@property (weak, nonatomic) IBOutlet UIButton *sgCollectButton;
@property (weak, nonatomic) IBOutlet UILabel *sgFansLab;
@property (weak, nonatomic) IBOutlet UILabel *allGoodsCountLab;
@property (weak, nonatomic) IBOutlet UILabel *upNemGCLab;
@property (weak, nonatomic) IBOutlet UILabel *shopActivitCLab;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *threeViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *threeLabels;

@property (nonatomic, strong) WMShopGoods *shopGoods;

@property (nonatomic, strong) NSMutableArray *shopGoodsList;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@property (nonatomic, assign) BOOL isCollectShop;

@end

@implementation StoreDetailVC


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sgClearView.alpha = 0.5;
    UILabel *label = _threeLabels[0];
    label.textColor = [UIColor redColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"JSCAGoodsItem" bundle:nil] forCellWithReuseIdentifier:@"shopGoodsItem"];
    [_collectionView registerNib:[UINib nibWithNibName:@"JSGoodsFavCollRV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GoodsFavHeader"];
    
    [self createNavigationBar];
    [self setThreeViewsTapClick];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        [self setBasicParam];
        [self getShopGoodsListRequestDataWithStatus:@"count"];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
        [self getShopGoodsListRequestDataWithStatus:@"count"];
    }];
    
    [self setBasicParam];
    [self getShopGoodsListRequestDataWithStatus:@"count"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //获取店铺信息数据
    [self getShopInfoRequestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - HttpRequest

/**
 *  获取店铺的数据
 */
- (void)getShopInfoRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetShopGoodsData postWithUrl:RMRequestStatusShopGoods param:@{@"shopId": _shopID} modelClass:[WMShopGoods class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.shopGoods = dataObj;

             [_sgBannerImg sd_setImageWithURL:[NSURL URLWithString:_shopGoods.mallShop.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
             [_sgLogoImg sd_setImageWithURL:[NSURL URLWithString:_shopGoods.mallShop.shopLogo] placeholderImage:[UIImage imageNamed:@"noimage"]];
             _sgNameLab.text = _shopGoods.mallShop.shopName;
             _sgFansLab.text = _shopGoods.mallShop.collectNum;
             
             if (_shopGoods.mallShop.shopType == 1) {
                 _sgShopKindLab.text = @"品牌旗舰店";
             } else {
                 _sgShopKindLab.text = @"品牌专营店";
             }
             
             if (_shopGoods.isCollect) {
                 [_sgCollectButton setTitle:@"已收藏" forState:UIControlStateNormal];
             } else {
                 [_sgCollectButton setTitle:@"收藏" forState:UIControlStateNormal];
             }
             
             _upNemGCLab.text = _shopGoods.counts.upNewGoods;
             _shopActivitCLab.text = _shopGoods.counts.activity;
             _allGoodsCountLab.text = _shopGoods.counts.count;
         }
     }];
}


/**
 *  设置参数
 */
- (void)setBasicParam
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.shopGoodsList = [NSMutableArray array];
    [self.collectionView reloadData];
}

/**
 *  获取店铺内商品列表的数据
 */
- (void)getShopGoodsListRequestDataWithStatus:(NSString *)status
{
    NSDictionary *param = @{@"sort":status,@"shopId":_shopID,@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    __weak typeof(self) weakSelf = self;
    
    [GetGoodsListData postWithUrl:RMRequestStatusGoodsList param:param modelClass:[Goods class] responseBlock:^(id dataObj, NSError *error) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (dataObj) {
            weakSelf.currentPage++;
            [weakSelf.shopGoodsList addObjectsFromArray:dataObj];
        }
        [weakSelf.collectionView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 *  收藏店铺的请求
 */
- (void)getShopCollectRequest
{
    __weak typeof(self) weakSelf = self;
    
    [XLDataService postWithUrl:RMRequestStatusAddCollect param:@{@"shopId": _shopID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             weakSelf.shopGoods.isCollect = _isCollectShop;
             [SVProgressHUD showSuccessWithStatus:error.domain];
         }
     }];
}

/**
 *  获取搜索店铺商品列表数据
 */
- (void)searchGoodsListWithText:(NSString *)text
{
    NSDictionary *param = @{@"currentPage": [@"" stringByAppendingString: [NSString stringWithFormat:@"%d", _currentPage]],  @"pageNumber": [@"" stringByAppendingString: [NSString stringWithFormat:@"%d", _pageNumber]],  @"tag": text ,@"shopId":_shopID};
    
    __weak typeof(self) weakSelf = self;
    [GetGoodsListData postWithUrl:RMRequestStatusGoodsList param:param modelClass:[Goods class] responseBlock:^(id dataObj, NSError *error) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (dataObj) {
            [weakSelf.shopGoodsList addObjectsFromArray:dataObj];
            weakSelf.currentPage++;
        } else {
            weakSelf.shopGoodsList = [NSMutableArray array];
        }
        [weakSelf.collectionView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


#pragma mark - Private Methods

/**
 *  创建导航条
 */
- (void)createNavigationBar
{
    _navBar = [[NSBundle mainBundle] loadNibNamed:@"StoreNavigationBar" owner:self options:nil].firstObject;
    
    //暂时屏蔽右侧分类按钮
    [_navBar.rightButton setImage:NULL forState:UIControlStateNormal];
    [_navBar.rightButton setTitle:nil forState:UIControlStateNormal];
    _navBar.rightButton.userInteractionEnabled = NO;
    
    [self.view addSubview:_navBar];
    
    _navBar.searchTF.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [_navBar setButtonActionBlock:^(UIButton *sender) {
        if (sender.tag == 0) {
            // 取消按钮点击
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *  给三个view添加点击手势
 */
- (void)setThreeViewsTapClick
{
    [_threeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeViewsTapGesture:)];
         [obj addGestureRecognizer:tap];
     }];
}

#pragma mark - Actions

/**
 *  views的点击手势
 */
- (void)threeViewsTapGesture:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < _threeLabels.count; i++) {
        UILabel *label = _threeLabels[i];
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //点击时 当前页数重置为1
    self.currentPage = 1;
    //移除其它状态下数组中的元素
    [self.shopGoodsList removeAllObjects];
    
    switch (sender.view.tag) {
        case 0:{
            //全部
            [self getShopGoodsListRequestDataWithStatus:@"count"];
        }
            break;
        case 1:{
            //上新
            [self getShopGoodsListRequestDataWithStatus:@"upNewGoods"];
        }
            break;
        default:{
            //活动
            [self getShopGoodsListRequestDataWithStatus:@"activity"];
        }
            break;
    }
}

/**
 *  收藏按钮点击事件
 *
 *  延时刷新数据
 */
- (IBAction)collectButtonClick:(UIButton *)sender
{
    [self getShopCollectRequest];
    [PRUitls delay:0.2 finished:^{
        [self getShopInfoRequestData];
    }];
}


/**
 *  底部三个button的点击事件
 */
- (IBAction)bottomThreeButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1: {   //店铺详情
            JSStoreDetailTVC *storeDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreDetailTVC"];
            storeDetailVC.shopDetailId = _shopID;
            [self.navigationController pushViewController:storeDetailVC animated:YES];
        }
            break;
        default: {   //联系客服
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打客服热线" message:_shopGoods.mallShop.mobile delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            [alert show];
        }
            break;
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
    } else {
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

/**
 *  添加到购物车
 */
- (void)storeAddShopCarClick:(UIButton *)sender
{
    if ([self isLogin]) {
        Goods *goods = _shopGoodsList[sender.tag];
        [WMGeneralTool addShopCarBtnClickwith:goods.goodsId];
    }
}

#pragma mark - UITextFieldDelegate

/**
 *  点击搜索键的时候 发送搜索请求
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _currentPage = 1;
    [_shopGoodsList removeAllObjects];
    [self searchGoodsListWithText:textField.text];
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //拨打客服电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_shopGoods.mallShop.mobile]]];
    }
}

#pragma mark - collectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goods = _shopGoodsList[indexPath.row];
    JSGoodsDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - collectionView datasouce

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _shopGoodsList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH - 16, 160);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSCAGoodsItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopGoodsItem" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    Goods *goods = _shopGoodsList[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.goodsImage] placeholderImage:[UIImage imageNamed:@"noimage"]];
    cell.nameLabel.text = goods.goodsName;
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.wholesalePrice.text = [NSString stringWithFormat:@"批:%.2f/%@", goods.goodsPrice, goods.unit];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.wholesalePrice.text = @"认证可见";
    } else {
        cell.wholesalePrice.text = @"登录认证可见";
    }
    
    cell.retailPrice.text = [NSString stringWithFormat:@"零:%.2f/%@", goods.price, goods.unit];
    cell.soldNum.text = [NSString stringWithFormat:@"销量:%d", goods.goodsSales];
    
    [cell.addShopCarBtn addTarget:self action:@selector(storeAddShopCarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;
    
    return cell;
}
// 设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 160);
}
// 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 设置区头
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        return headerView;
    } else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
