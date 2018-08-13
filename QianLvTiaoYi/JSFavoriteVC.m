//
//  JSFavoriteVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/4/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFavoriteVC.h"

#import "JSGoodsFavoriteView.h"
#import "JSStoreFavoriteView.h"

#import "JSGoodsFavFliterVC.h"

#import "JSGoodsDetailVC.h"

#import "StoreDetailVC.h"

#import "JSSearchVC.h"

@interface JSFavoriteVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *favoriteSegmentedC;
@property (weak, nonatomic) IBOutlet UIView *favoriteTopFliterView;

@property (strong, nonatomic) JSGoodsFavoriteView *goodsFavView;
@property (strong, nonatomic) JSStoreFavoriteView *storeFavView;

@end

@implementation JSFavoriteVC


#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _goodsFavView = [[NSBundle mainBundle] loadNibNamed:@"JSGoodsFavView" owner:self options:nil].firstObject;

    _storeFavView = [[NSBundle mainBundle]loadNibNamed:@"JSStoreFavoriteView" owner:self options:nil].firstObject;
    
    //判断是点击的商品收藏还是店铺收藏
    if (_isGoodsFavoriteVC == YES) {
        //商品
        _favoriteSegmentedC.selectedSegmentIndex = 0;
        
        [self.view addSubview:_goodsFavView];
        _goodsFavView.isDefaultStatus = YES;
        
        [_goodsFavView.goodsFavCollectView.mj_header beginRefreshing];
        
    } else {
        //店铺
        _favoriteSegmentedC.selectedSegmentIndex = 1;
        
        [self.view addSubview:_storeFavView];
        [_storeFavView.storeFavCollectView.mj_header beginRefreshing];
    }
    
    //点击商品收藏单元格的通知
    [M_NOTIFICATION addObserver:self selector:@selector(skipGoodsDetailVC:) name:@"GoodsFavSkipDetailVC" object:nil];
    
    //点击进店逛逛通知
    [M_NOTIFICATION addObserver:self selector:@selector(skipStoreDetailVC:) name:@"StoreFavSkipStoreDetailVC" object:nil];
    
    //点击筛选按钮跳转界面
    [M_NOTIFICATION addObserver:self selector:@selector(skipFliterVCClick) name:@"SkipFliterVCNOtifi" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

/**
 *  店铺收藏筛选点击的通知方法
 *
 *  Notification
 */
- (void)skipFliterVCClick
{
    //商品筛选界面
    JSGoodsFavFliterVC *filterVC = [[JSGoodsFavFliterVC alloc]init];
    [self.navigationController presentViewController:filterVC animated:NO completion:nil];
}

/**
 *  店铺收藏进店看看点击的通知方法
 *
 *  Notification
 */
- (void)skipStoreDetailVC:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *wmshopId = dict[@"shopId"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    StoreDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"StoreDetailVC"];
    vc.shopID = wmshopId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  商品收藏单元格点击的通知方法
 * 
 *  Notification
 */
- (void)skipGoodsDetailVC:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *goodsFavID = dict[@"GoodsFavID"];
    //跳转商品详情界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goodsFavID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Click & Actions

- (IBAction)backMemberCenterVCAction:(UIBarButtonItem *)sender
{
    //返回会员中心按钮
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favoriteSearchAction:(UIBarButtonItem *)sender
{
    //搜索按钮
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Category" bundle:nil];
    JSSearchVC *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];

    [self presentViewController:searchVC animated:NO completion:nil];
}

- (IBAction)favoriteSegmentAction:(UISegmentedControl *)sender
{
    //分段按钮
    if (sender.selectedSegmentIndex == 0) {
        //商品
        [_storeFavView removeFromSuperview];
        
        [self.view addSubview:_goodsFavView];
        _goodsFavView.isDefaultStatus = YES;
        [_goodsFavView.goodsFavCollectView.mj_header beginRefreshing];
    } else {
        //店铺
        [_goodsFavView removeFromSuperview];

        [self.view addSubview:_storeFavView];
        
        [_storeFavView.storeFavCollectView.mj_header beginRefreshing];
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
