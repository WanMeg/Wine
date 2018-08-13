//
//  HomePageVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "HomePageVC.h"
#import "JSGoodsListCell.h"
#import "JSHomePageADCell.h"
#import "JSToosButtonCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GetHomePageData.h"
#import "JSHomePageFooterView.h"
#import "JSHomePageSectionView.h"
#import "JSSearchVC.h"
#import "JSCAGoodsListVC.h"
#import "JSGoodsDetailVC.h"
#import "JSShopListVC.h"
#import "GetUserData.h"
#import "JSSystemMessageTVC.h"
#import "JSCategoryVC.h"


@interface HomePageVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) HomePage *homePage;
@property (strong, nonatomic) NSArray *floorImages;

//全部数据数组
@property (strong, nonatomic) NSMutableArray *totalDataArray;

@end

@implementation HomePageVC


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchButton.layer.cornerRadius = 5.0f;
    _searchButton.layer.masksToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _totalDataArray = [NSMutableArray array];
    
    UINib *nib1 = [UINib nibWithNibName:@"JSGoodsListCell" bundle:[NSBundle mainBundle]];
    UINib *nib2 = [UINib nibWithNibName:@"JSHomePageADCell" bundle:[NSBundle mainBundle]];
    UINib *nib3 = [UINib nibWithNibName:@"JSToosButtonCell" bundle:[NSBundle mainBundle]];
    UINib *nib4 = [UINib nibWithNibName:@"JSHomePageFooterView" bundle:[NSBundle mainBundle]];
    UINib *nib5 = [UINib nibWithNibName:@"JSHomePageSectionView" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib1 forCellReuseIdentifier:@"GoodsListCell"];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"ADCell"];
    [_tableView registerNib:nib3 forCellReuseIdentifier:@"ToolsCell"];
    [_tableView registerNib:nib4 forHeaderFooterViewReuseIdentifier:@"FooterView"];
    [_tableView registerNib:nib5 forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestHomePageData];
    }];
    [self requestHomePageData];
    
    _floorImages = @[@"floor1.png", @"floor2.png", @"floor3.png", @"floor4.png",@"floor5.png", @"floor6.png", @"floor7.png", @"floor8.png"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    //设置监听SearchVC回调信息
    [M_NOTIFICATION addObserver:self selector:@selector(handleSearchAction:) name:@"SearchKeyWords" object:nil];
    
    //点击添加购物车按钮注册的监听者
    [M_NOTIFICATION addObserver:self selector:@selector(skipLoginVCNotifiClick) name:@"addShopCarNotifi" object:nil];
    
    //wm 判断用户是否登录， 去登陆之后返回主页 需要刷新界面 显示出批发价
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    //视图将要消失移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Requests

/**
 *  请求 主页数据
 */
- (void)requestHomePageData
{
    __weak typeof(self) weakSelf = self;
    [GetHomePageData getWithUrl:RMRequestStatusGetHomePage param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.homePage = dataObj;
        
        [weakSelf.tableView reloadData];
    }];
}

/**
 *  请求 签到获取积分
 */
- (void)reqeustSignGetPoint
{
    [XLDataService postWithUrl:RMRequestStatusSignGetPoint param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100)
        {
            [SVProgressHUD showSuccessWithStatus:@"签到成功。"];
        }else  {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

#pragma mark - Private functions
/**
 *  监听 用户没登录 点击立即登录 跳转登录界面
 *
 *  Notification
 */
- (void)skipLoginVCNotifiClick
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
    UIViewController * NC = [sb instantiateViewControllerWithIdentifier:@"LoginNC"];
    [self presentViewController:NC animated:YES completion:nil];
}

/**
 *  通过NSNotificationCenter 监听 搜索关键字
 *
 *  @param sender SearchVC传递的搜索关键字
 */
-(void)handleSearchAction:(NSNotification*)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSCAGoodsListVC *vc = [sb instantiateViewControllerWithIdentifier:@"CAGoodsListVC"];
    vc.tag = sender.userInfo[@"keywords"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setHomePage:(HomePage *)homePage
{
    _homePage= homePage;
    [self updateBannerImages:homePage.indexImgs];
}

- (void)updateBannerImages:(NSArray *)indexImgs
{
    NSMutableArray *list = [NSMutableArray array];

    for (IndexImg* idxImg in indexImgs)
    {
        [list addObject:idxImg.imgUrl];
    }
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    _cycleScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_cycleScrollView setImageURLStringsGroup:list];
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"noimage"];
}

/**
 *  跳转到商品详情页面
 *
 *  @param goods GoodsModel
 */
-(void)showGoodsDetailWithGoods:(Goods *)goods
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

/**
 *  分享按钮点击方法
 */
- (IBAction)shareButtonClick:(UIButton *)sender
{
    UIImage *image = [UIImage imageNamed:@"weixinfenx"];
    [WMGeneralTool shareMethodWithImg:image withUrlStr:M_WXURLS withTitle:@"中国酒类批发网"];
}

/**
 *  消息按钮点击方法
 */
- (IBAction)newsButtonClick:(UIButton *)sender
{
    if (M_MEMBER_LOGIN) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
        JSSystemMessageTVC *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"SystemMessageTVC"];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else {
        PRAlertView *alertView = [[PRAlertView alloc] init];
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                UIViewController * NC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
                [self.navigationController presentViewController:NC animated:YES completion:nil];
            }
        }];
    }
}

/**
 *  搜索按钮点击方法
 */
- (IBAction)navigationSearchAction:(UIButton *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"SearchVC"];
    [self presentViewController:VC animated:NO completion:nil];
}



#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_homePage) {
        return 2;
    } else {
        return _homePage ? _homePage.activity.count + _homePage.floors.count + 1 : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return M_HEADER_HIGHT;
    } else {
        return 35.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (section < _homePage.activity.count) {
        WMActivity *floor = _homePage.activity[section];

        if (floor.adverts.count > 0) {
            return 82.0f;
        }
    }

    if (section >= _homePage.activity.count && section < _homePage.activity.count + _homePage.floors.count) {
        WMActivity *floor = _homePage.floors[section - _homePage.activity.count];

        if (floor.adverts.count > 0) {
            return 82.0f;
        }
    }
    return M_HEADER_HIGHT;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 176;
                break;
            case 1:
                return 53;
            default:
                return 0;
                break;
        }
    } else {
        CGFloat rowHeight = WIDTH / 2 *1.15f+52.0f;
        WMActivity *floor;
        if (indexPath.section <= _homePage.activity.count) {
            floor = _homePage.activity[indexPath.section -1];
        } else {
            floor = _homePage.floors[indexPath.section - 1 - _homePage.activity.count];
        }
        
        NSInteger lineCount = (floor.goods.count % 2 == 0 ? floor.goods.count / 2 : floor.goods.count / 2 + 1);
        //行高 * 行数 + 行距（行数 * 当行距 + 底部行距）
        return rowHeight * lineCount;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        
        JSHomePageSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
        view.imgView.image = [UIImage imageNamed:_floorImages[section -1]];
        if (section <= _homePage.activity.count) {
            WMActivity *floor = _homePage.activity[section - 1];
            view.titleLabel.text = floor.detlName;
        }else {
            Floor *floor = _homePage.floors[section - 1 - _homePage.activity.count];
            view.titleLabel.text = floor.name;
        }
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    Floor *floor;
    //section 在activity上面 返回广告图  整体往上移一层 取出 activity
    if (section < _homePage.activity.count) {
        floor = _homePage.activity[section];
        //section 在floors上面 返回广告图,  整体往上移一层 取出 floor
    } else if (section >= _homePage.activity.count && section < _homePage.activity.count + _homePage.floors.count) {
        floor = _homePage.floors[section - _homePage.activity.count];
    }
    
    if (floor.adverts.count > 0) {
        JSHomePageFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FooterView"];
        ImageAd *iAd = floor.adverts.firstObject;
        [view.imgView sd_setImageWithURL:[NSURL URLWithString:iAd.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                JSToosButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolsCell" forIndexPath:indexPath];
                __weak typeof(self) weakSelf = self;
                
                [cell setButtonActionBlock:^(UIButton *sender) {
                    switch (sender.tag) {
                        case 0:{ //推荐商家
                            // 店铺列表
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
                            JSShopListVC *slVC = [sb instantiateViewControllerWithIdentifier:@"ShopListVC"];
                            [self.navigationController pushViewController:slVC animated:YES];
                            break;
                        }
                        case 1:{ //限时抢购
                            
                            UIViewController *rushShopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RushShoppingTVC"];
                            [self.navigationController pushViewController:rushShopVC animated:YES];
                            break;
                        }
                        case 2:{ //今日团购
                            
                            UIViewController *nowShopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayShoppingTVC"];
                            [self.navigationController pushViewController:nowShopVC animated:YES];
                            break;
                        }
                        case 3:{ //商品众筹
                            
                            UIViewController *npVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NumerousPlanTVC"];
                            [self.navigationController pushViewController:npVC animated:YES];
                            break;
                        }
                        case 4:{ //新品上市
                            
                            UIViewController *newGoodsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGoodsVC"];
                            [self.navigationController pushViewController:newGoodsVC animated:YES];
                            break;
                        }
                        case 5:{ //我要签到
                            
                            [weakSelf reqeustSignGetPoint];
                            break;
                        }
                        case 6:{ //抢红包
                            
                            UIViewController *rushRedPackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RushRedPackVC"];
                            [self.navigationController pushViewController:rushRedPackVC animated:YES];
                            break;
                        }
                        case 7:{ //商城活动
                            
                            UIViewController *marketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MarketActivityTVC"];
                            [self.navigationController pushViewController:marketVC animated:YES];
                            break;
                        }
                            
                        default:
                            break;
                    }
                }];
                return cell;
            }
                break;
            default: {
                JSHomePageADCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADCell" forIndexPath:indexPath];
                if (_homePage.lables.count != 0) {
                    cell.labels = _homePage.lables;
                }
                
                return cell;
            }
        }
    } else {
        
        JSGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListCell" forIndexPath:indexPath];
        
        WMActivity *floor;
        if (indexPath.section <= _homePage.activity.count) {
            floor = _homePage.activity[indexPath.section - 1];
        } else {
            floor = _homePage.floors[indexPath.section - 1 - _homePage.activity.count];
        }
        
        //刷新collectionView显示内容
        [cell.collectionView updateDatasWithSectionCount:floor.goods.count fetchText:^Goods *(NSInteger idx)
         {
            return floor.goods[idx];
        }];
        
        //CollectionView点击事件
        [cell.collectionView setSelectedBlock:^(NSInteger idx) {
            Goods *goods = floor.goods[idx];
            [weakSelf showGoodsDetailWithGoods:goods];
        }];
        return cell;
    }
}


//navigationView 动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.contentOffset.y < - 3.0f) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _navigationView.alpha = 0.0f;
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _navigationView.alpha = 1.0f;
            } completion:nil];
        }
        CGFloat limit = scrollView.contentOffset.y * 0.01;
        if (scrollView.contentOffset.y > 64.0f) {
            _navigationView.backgroundColor = [UIColor colorWithRed:0xdd/255.0 green:0x27/255.0 blue:0x27/255.0 alpha:limit];
        }else {
            _navigationView.backgroundColor = [UIColor clearColor];
        }
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
