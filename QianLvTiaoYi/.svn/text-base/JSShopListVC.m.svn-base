//
//  JSShopListVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/17.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSShopListVC.h"
#import "JSGoodsCVCell.h"
#import "JSStoreFavCollRV.h"
#import "GetShopListData.h"
#import "StoreDetailVC.h"
#import "JSGoodsDetailVC.h"
#import <CoreLocation/CoreLocation.h>

@interface JSShopListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *shopListCollectView;
@property (nonatomic, strong) NSMutableArray *shopListArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@property (nonatomic, strong) CLLocationManager* locationMgr;
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, assign) BOOL isGetLocation;//是否获得地址


@end

@implementation JSShopListVC
static dispatch_once_t onceToken;

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isGetLocation = NO;
    _shopListCollectView.delegate = self;
    _shopListCollectView.dataSource = self;
    
    [_shopListCollectView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
    [_shopListCollectView registerNib:[UINib nibWithNibName:@"JSStoreFavCollRV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreFavHeader"];
    
    self.shopListCollectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setBasicParam];
        [self getShopListRequestData];
    }];
    
    self.shopListCollectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getShopListRequestData];
    }];
    
    
    //获取当前位置的经度纬度
    [self getUserLocationMethod];
    
    
    [PRUitls delay:0.5 finished:^{
        [self setBasicParam];
        [self getShopListRequestData];
    }];
}

#pragma mark - Private Methods

/**
 *  设置基本参数
 */
- (void)setBasicParam
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.shopListArray = [NSMutableArray array];
    [self.shopListCollectView reloadData];
}

/**
 *  获取店铺列表的数据
 */
- (void)getShopListRequestData
{
    NSLog(@"@@@@@ = %@----%@",_longitude,_latitude);
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber],@"positionX":_longitude?_longitude:@"",@"positionY":_latitude?_latitude:@""};

    __weak typeof(self) weakSelf = self;
    
    [GetShopListData
     postWithUrl:RMRequestStatusShopList param:param modelClass:[WMShopList class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.shopListCollectView.mj_header endRefreshing];
         [self.shopListCollectView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage ++;
             [weakSelf.shopListArray addObjectsFromArray:dataObj];
         }
         [weakSelf.shopListCollectView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.shopListCollectView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  获取当前用户所在经纬度
 */
- (void)getUserLocationMethod
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _locationMgr =[[CLLocationManager alloc]init];
        _locationMgr.delegate = self;
        _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationMgr requestAlwaysAuthorization];
        _locationMgr.distanceFilter = 100;
        [_locationMgr startUpdatingLocation];
    } else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到手机的设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin
{
    Member *member = [GetUserData fetchActivateMemberData];
    if (member) {
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

#pragma mark - Actions

/**
 *  进店逛逛按钮
 *
 *  传值 shopId
 */
- (void)enterStoreStrollMethod:(UIButton *)sender
{
    WMShopList *shop = _shopListArray[sender.tag];
    StoreDetailVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreDetailVC"];
    vc.shopID = shop.mallShopId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  添加到购物车
 */
- (void)shopListAddShopCarBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        WMShopList *shop = _shopListArray[sender.tag/10000];
        WMShopGoodsList * shopGoods = shop.goodsList[sender.tag%10000];
        [WMGeneralTool addShopCarBtnClickwith:shopGoods.goodsId];
    }
}

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CLLocationManagerDelegate
// 位置更新(移动)了.
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    dispatch_once(&onceToken, ^{
        CLLocation *cl = [locations firstObject];
        _latitude = [NSString stringWithFormat:@"%f",cl.coordinate.latitude];
        _longitude = [NSString stringWithFormat:@"%f",cl.coordinate.longitude];
    });
}

//获取定位失败回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _isGetLocation = NO;
    //定位失败的原因
    NSLog(@"===>%@",error.description);
}

#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMShopList *shop = _shopListArray[indexPath.section];
    
    WMShopGoodsList * shopGoods = shop.goodsList[indexPath.row];
    //跳转商品详情界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = shopGoods.goodsId;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - collectionView delegate & datasouse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _shopListArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMShopList *store = _shopListArray[section];
    return store.goodsList.count;
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
    
    WMShopList *shop = _shopListArray[indexPath.section];

    WMShopGoodsList * shopGoods = shop.goodsList[indexPath.row];
    
    //图片
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:shopGoods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    //名称
    cell.nameLabel.text = shopGoods.name?shopGoods.name:@"";
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:¥%.2f/%@",shopGoods.price, shopGoods.unit?shopGoods.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }

    //零售价格
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:¥%.2f/%@",shopGoods.goodsPrice,shopGoods.unit?shopGoods.unit:@""];
    //销量
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@",shopGoods.goodsSales,shopGoods.unit?shopGoods.unit:@""];
    
    [cell.addShopCarBtn addTarget:self action:@selector(shopListAddShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.section * 10000 + indexPath.row;
    
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
        WMShopList *shop = _shopListArray[indexPath.section];
        
        [headerView.storeFavHeaderIconImg sd_setImageWithURL:[NSURL URLWithString:shop.shopLogo] placeholderImage:[UIImage imageNamed:@"noimage"]];
        headerView.storeFavHeaderNameLab.text = shop.shopName;
        headerView.storeFavHeaderAddressLab.text = shop.companyAddress?shop.companyAddress:@"";
        
        if (_longitude == nil || _latitude == nil) {
            headerView.distanceLab.text = @"位置服务不可用";
            
        } else {
            headerView.distanceLab.text = [NSString stringWithFormat:@"%@ km",shop.distance];
        }
        
        if (shop.shopType == 0)
        {
            headerView.storeFavHeaderBrandLab.text = @"直营店";
        } else {
            headerView.storeFavHeaderBrandLab.text = @"旗舰店";
        }
        
        headerView.enterStoreBtn.tag = indexPath.section;
        [headerView.enterStoreBtn addTarget:self action:@selector(enterStoreStrollMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    }else{
        return nil;
    }
}




@end
