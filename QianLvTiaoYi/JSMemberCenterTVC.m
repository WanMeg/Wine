//
//  JSMemberCenterTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/10.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#define NAVBAR_CHANGE_POINT 5

#import "JSMemberCenterTVC.h"
#import "JSContact.h"
#import "JSGuessLikeCV.h"
#import "UINavigationBar+Awesome.h"
#import "GetUserData.h"
#import "PRAlertView.h"
#import "UINavigationController+CustomStyle.h"
#import "JSFavoriteVC.h"
#import "JSFootprintTableVC.h"
#import "JSOrderListVC.h"
#import "GetThreeCountData.h"

#import "GetGuessLikeData.h"
#import "JSGoodsDetailVC.h"
#import "JSGoodsCVCell.h"
#import "GetPersonalInfoData.h"
#import "JSUserPasswordTabVC.h"
#import "GetOSCountData.h"
#import "GetSystemNewsData.h"
@interface JSMemberCenterTVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarIV;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;

//灰黑色view上的三个view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *grayViewFourViews;
//全部订单下的五个view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allOrderFiveViews;
//我的资产四个view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *myAssetFourViews;
//第三区四个view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *thirdSectionFourViews;

@property (weak, nonatomic) IBOutlet JSGuessLikeCV *guessLikeCV;//猜你喜欢collV

@property (weak, nonatomic) IBOutlet UILabel *goodsFavTotalNum;
@property (weak, nonatomic) IBOutlet UILabel *storeFavTotalNum;
@property (weak, nonatomic) IBOutlet UILabel *footmarkTotalNum;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *orderStatusCountImgs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *orderStatusCountLabs;
@property (strong, nonatomic) UIBarButtonItem *messageItem;
@property (copy, nonatomic) NSString *mIImageName;
@property (assign, nonatomic) BOOL isNoRead;
@property (nonatomic, strong) WMThreeCount *tCount;

@property (nonatomic, strong) NSMutableArray *guessLikeArray;
@property (nonatomic, strong) WMGuessLike *guessLike;

@property (nonatomic, copy) NSString *headerImageUrl;
@property (nonatomic, strong) PersonalInfo *memberInfo;
@property (nonatomic, strong) NSArray *orderStatusCountArr;
@end

@implementation JSMemberCenterTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    self.tableView.delegate = self;
    //隐藏navigationBar 调用
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self updateUI];
    [self setupLoginButton];
    [self getGuessLikeRequestData]; // 获取猜你喜欢数据
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isNoRead = NO;
    self.guessLikeArray = [NSMutableArray array];
    self.orderStatusCountArr = [NSArray array];
    
    
    [self setupGrayViewThreeViewsTapClick];
    [self setupAllOrderFiveViewsTapClick];
    [self setupThirdSectionFourViewsTapClick];
    [self setupMyAssetFourViewsTapClick];
    
    _guessLikeCV.dataSource = self;
    _guessLikeCV.delegate = self;

    [_guessLikeCV registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitePoint.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"colorLine1"];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Private Functions

/**
 *  设置头像、登陆按钮
 */
- (void)setupLoginButton
{
    _avatarIV.layer.cornerRadius = 30;
    _avatarIV.layer.masksToBounds = YES;
    
    Member *member = [GetUserData fetchActivateMemberData];
    if (member) {
        //登录之后调用
        [self getTopThreeCountRequestData]; // 获取数量数据
        [self getOrderStatusCountRequestData]; // 获取订单状态数量的数据
        [self getPersonalInfoRequest]; //获取会员个人信息 设置头像
        
        [_accountButton setTitle:member.userName forState:UIControlStateNormal];
        _accountButton.userInteractionEnabled = NO;
        
    } else {
        [_accountButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        _accountButton.userInteractionEnabled = YES;
        
        _footmarkTotalNum.text = @"0";
        _storeFavTotalNum.text = @"0";
        _goodsFavTotalNum.text = @"0";
        [_avatarIV setImage:[UIImage imageNamed:@"noimage"] forState:UIControlStateNormal];
        for (int i = 0; i < _orderStatusCountLabs.count; i ++)
        {
            UILabel *label = _orderStatusCountLabs[i];
            UIImageView *imageView = _orderStatusCountImgs[i];
            label.text = @"";
            imageView.image = nil;
        }
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
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                UIViewController * NC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
                [self.navigationController presentViewController:NC animated:YES completion:nil];
            }
        }];
        return NO;
    }
}

/**
 *  设置顶部导航消息按钮
 */
- (void)updateUI
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    //导航栏右侧按钮
    
    if (M_MEMBER_LOGIN) {
        [self getSystemMessageRequestData];
    } else {
        _mIImageName = @"xiaoxi.png";
    }
    
    [PRUitls delay:0.5 finished:^{
        UIImage *image = [[UIImage imageNamed:_mIImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _messageItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleRightButtons:)];
        self.navigationItem.rightBarButtonItem = _messageItem;
    }];

}

/**
 *  给灰黑色view上的四个view添加点击手势
 */
- (void)setupGrayViewThreeViewsTapClick
{
    [_grayViewFourViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfGrayViewThreeViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

/**
 *  给全部订单下的五个view添加点击手势
 */
- (void)setupAllOrderFiveViewsTapClick
{
    [_allOrderFiveViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = idx;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfAllOrderFiveViews:)];
        [obj addGestureRecognizer:tap];
    }];
}
/**
 *  给我的资产四个view添加点击手势
 */
- (void)setupMyAssetFourViewsTapClick
{
    [_myAssetFourViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOfMyAssetFourViews:)];
         [obj addGestureRecognizer:tap];
    }];
}

/**
 *  给第三区四个view添加点击手势
 */
- (void)setupThirdSectionFourViewsTapClick
{
    [_thirdSectionFourViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfThirdSectionFourViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

#pragma mark - HttpRequest

/**
 * 获取个人信息请求
 */
- (void)getPersonalInfoRequest
{
    __weak typeof(self) weakSelf = self;
    
    [GetPersonalInfoData postWithUrl:RMRequestStatusPersonalInformation param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error) {
         if (dataObj) {
             //[SVProgressHUD showSuccessWithStatus:error.domain];
             weakSelf.memberInfo = dataObj;
             [_avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.memberInfo.headPortrait]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"noimage"]];
         } else {
             //[SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 *  获取猜你喜欢数据
 */
- (void)getGuessLikeRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetGuessLikeData postWithUrl:RMRequestStatusRecommentGoods param:nil modelClass:[WMGuessLike class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.guessLike = dataObj;
             [weakSelf.guessLikeCV reloadData];
         }
     }];
}

/**
 *  获取顶部三个数量的数据
 */
- (void)getTopThreeCountRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetThreeCountData postWithUrl:RMRequestStatusMemberThreeCount param:nil modelClass:[WMThreeCount class] responseBlock:^(id dataObj, NSError *error) {
         if (dataObj) {
             weakSelf.tCount = dataObj;
             
             //赋值
             _footmarkTotalNum.text = _tCount.footmarkcount;
             _storeFavTotalNum.text = _tCount.coliectShopcount;
             _goodsFavTotalNum.text = _tCount.collectGoodscount;
         }
     }];
}

/**
 *  获取订单状态数量的数据
 */
- (void)getOrderStatusCountRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetOSCountData postWithUrl:RMRequestStatusOrderStatusInfo param:nil modelClass:[WMOrderStatusCount class] responseBlock:^(id dataObj, NSError *error) {
         if (dataObj) {
             weakSelf.orderStatusCountArr = dataObj;
             
             for (int i = 0; i < weakSelf.orderStatusCountArr.count; i ++)
             {
                 WMOrderStatusCount *orderStatu = _orderStatusCountArr[i];
                 int statu = orderStatu.status;
                 //NSString *string = orderStatu.count;
                 //NSLog(@"---%d--%@",statu,string);
                 switch (statu) {
                     case 0:{   //待付款
                         UILabel *label = _orderStatusCountLabs[0];
                         UIImageView *image = _orderStatusCountImgs[0];
                         if ([orderStatu.count isEqualToString:@"0"]) {
                             label.text = @"";
                             image.image = nil;
                         } else {
                             label.text = orderStatu.count;
                             image.image = [UIImage imageNamed:@"orderStatusQuan"];
                         }
                     }
                         break;
                     case 1:{   //待发货
                         UILabel *label = _orderStatusCountLabs[1];
                         UIImageView *image = _orderStatusCountImgs[1];
                         if ([orderStatu.count isEqualToString:@"0"]) {
                             label.text = @"";
                             image.image = nil;
                         } else {
                             label.text = orderStatu.count;
                             image.image = [UIImage imageNamed:@"orderStatusQuan"];
                         }
                     }
                         break;
                     case 2:{   //待收货
                         UILabel *label = _orderStatusCountLabs[2];
                         UIImageView *image = _orderStatusCountImgs[2];
                         if ([orderStatu.count isEqualToString:@"0"]) {
                             label.text = @"";
                             image.image = nil;
                         } else {
                             label.text = orderStatu.count;
                             image.image = [UIImage imageNamed:@"orderStatusQuan"];
                         }
                     }
                         break;
                     case 3:{
                     
                     }
                         break;
                     case 4:{   //换货，售后
                         UILabel *label = _orderStatusCountLabs[4];
                         UIImageView *image = _orderStatusCountImgs[4];
                         if ([orderStatu.count isEqualToString:@"0"]) {
                             label.text = @"";
                             image.image = nil;
                         } else {
                             label.text = orderStatu.count;
                             image.image = [UIImage imageNamed:@"orderStatusQuan"];
                         }
                     }
                         break;
                     case 5:    //待退款
                         break;
                     case 6:{   //待评价 已完结
                         UILabel *label = _orderStatusCountLabs[3];
                         UIImageView *image = _orderStatusCountImgs[3];
                         if ([orderStatu.count isEqualToString:@"0"]) {
                             label.text = @"";
                             image.image = nil;
                         } else {
                             label.text = orderStatu.count;
                             image.image = [UIImage imageNamed:@"orderStatusQuan"];
                         }

                     }
                         break;
                     default:   //已取消
                         break;
                 }
             }
         }
     }];
}

/**
 *  获取系统消息数据
 */
- (void)getSystemMessageRequestData
{
    NSDictionary *param = @{@"currentPage": @"1", @"pageNumber": @"1"};
    [GetSystemNewsData postWithUrl:RMRequestStatusSystemNews param:param modelClass:[WMSystemNews class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             for (WMSystemNews *news in dataObj) {
                 if (news.isRead == 0) {
                     _isNoRead = YES;
                 } else {
                     _isNoRead = NO;
                 }
             }
             
             if (_isNoRead) {
                 _mIImageName = @"xiaoxi2.png";
             } else {
                 _mIImageName = @"xiaoxi.png";
             }
         }
     }];
}


#pragma mark - Click Actions

/**
 *  头像、登录按钮点击事件
 */
- (IBAction)someAction:(UIButton *)sender
{
    if (sender.tag == 78) {
        Member *member = [GetUserData fetchActivateMemberData];
        if (!member) {
            //登陆界面
            UIViewController * NC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
            [self.navigationController presentViewController:NC animated:YES completion:nil];
        }
    } else {
//头像按钮点击事件
        if (![self isLogin]) {
            return;
        }
        //会员信息界面
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *  导航条右侧按钮点击事件
 *
 *  @param sender barItem
 */
- (void)handleRightButtons:(UIBarButtonItem *)sender
{
    if (![self isLogin]) {
        return;
    } else {
        //系统消息界面
        UIViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemMessageTVC"];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

/**
 *  灰黑色view上四个view的点击事件
 *
 *  @param sender 点击手势
 */
- (void)handleTapOfGrayViewThreeViews:(UITapGestureRecognizer *)sender
{
    if (![self isLogin]) {
        return;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
        JSFavoriteVC *favoriteVC = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteVC"];
        
        switch (sender.view.tag) {
            case 0: {
                //商品收藏界面
                favoriteVC.isGoodsFavoriteVC = YES;
                [self.navigationController pushViewController:favoriteVC animated:YES];
            }
                break;
            case 1: {
                //店铺收藏界面
                favoriteVC.isGoodsFavoriteVC = NO;
                [self.navigationController pushViewController:favoriteVC animated:YES];
            }
                break;
            default: {
                //我的足迹界面
                
                UIViewController *footprintTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FootprintTableVC"];
                [self.navigationController pushViewController:footprintTableVC animated:YES];
            }
                break;
        }
    }
}

/**
 *  全部订单下view的点击事件
 *
 *  @param sender 点击手势
 */
- (void)handleTapOfAllOrderFiveViews:(UITapGestureRecognizer *)sender
{
    if (![self isLogin]) {
        return;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
        JSOrderListVC *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
        
        switch (sender.view.tag) {
            case 0: {   //待付款界面
                orderVC.goToWhatVC = 1;
                orderVC.title = @"待付款";
            }
                break;
            case 1: {   //待发货界面
                orderVC.goToWhatVC = 2;
                orderVC.title = @"待发货";
            }
                break;
            case 2: {   //待收货界面
                orderVC.goToWhatVC = 3;
                orderVC.title = @"待收货";
            }
                break;
            case 3: {   //待评价界面
                orderVC.goToWhatVC = 4;
                orderVC.title = @"待评价";
                
            }
                break;
            default: {   //售后界面
                orderVC.goToWhatVC = 5;
                orderVC.title = @"补货";
            }
                break;
        }
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}
/**
 *  我的资产下view的点击事件
 *
 *  @param sender 点击手势
 */
- (void)handleTapOfMyAssetFourViews:(UITapGestureRecognizer *)sender
{
    if (![self isLogin]) {
        return;
    } else {
        switch (sender.view.tag) {
            case 0: {   //积分界面
                UIViewController *myzichanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAssetsTabVC"];
                [self.navigationController pushViewController:myzichanVC animated:YES];
            }
                break;
            case 1: {   //积分界面
                UIViewController *jiFenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntegralVC"];
                [self.navigationController pushViewController:jiFenVC animated:YES];
            }
                break;
            case 2: {   //红包界面
                UIViewController *redVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketTabVC"];
                [self.navigationController pushViewController:redVC animated:YES];
            }
                break;
            default: {   //资金安全
                
                //修改登录密码界面
                JSUserPasswordTabVC *userPswVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserPasswordTabVC"];
                userPswVC.isLoginPswVC = YES;
                [self.navigationController pushViewController:userPswVC animated:YES];
            }
                break;
        }
    }
}

/**
 *  第三区view的点击事件
 *
 *  @param sender 点击手势
 */
- (void)handleTapOfThirdSectionFourViews:(UITapGestureRecognizer *)sender
{
    if (![self isLogin]) {
        return;
    } else {
        switch (sender.view.tag) {
            case 0: {
                //地址管理界面
               
                UIViewController *addressVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AdressListTVC"];
                [self.navigationController pushViewController:addressVC animated:YES];
            }
                break;
            case 1: {
                //账号管理界面
                
                UIViewController *userManagerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserManagerTabVC"];
                [self.navigationController pushViewController:userManagerVC animated:YES];
            }
                break;
            case 2: {
                //帮助中心界面
                
                UIViewController *helpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpCenterTVC"];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            default: {
                //评价界面
                
                UIViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentCenterTV"];
                [self.navigationController pushViewController:commentVC animated:YES];
            }
                break;
        }
    }
}

/**
 *  加入购物车按钮
 */
- (void)memberCenterAddShopCarBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        WMGuess *guess = _guessLike.remaiGoods[sender.tag];
        [WMGeneralTool addShopCarBtnClickwith:guess.goodsId];
    }
}

#pragma mark - scrollView delegate

/**
 *  导航条滑动渐变动画  关联UINavigationBar+Awesome 分类
 *
 *  @param scrollView 滚动视图
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动设置导航条是否显示
    UIColor * color = QLTY_MAIN_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = WIDTH / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.15f+52.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _guessLike.remaiGoods.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];
    
    WMGuess *guess = _guessLike.remaiGoods[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:guess.imgUrl]];
    
    cell.nameLabel.text = guess.name;
    
    //wm 用户没有登录只显示零售价  登录并认证后显示零售和批发价
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:￥%.2f/%@", guess.wholesalePrice,guess.unit?guess.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }
    
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.2f/%@", guess.goods_retail_price,guess.unit?guess.unit:@""];
    
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d", guess.goodsSales];
    [cell.addShopCarBtn addTarget:self action:@selector(memberCenterAddShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 //跳转商品详情界面
    
    WMGuess *guess = _guessLike.remaiGoods[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = guess.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isLogin]) {
        return;
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                //全部订单界面
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
                JSOrderListVC *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListVC"];
                orderVC.goToWhatVC = 0;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //我的资产界面
                UIViewController *myzichanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAssetsTabVC"];
                [self.navigationController pushViewController:myzichanVC animated:YES];
            }
        } else if (indexPath.section == 3) {
            //设置界面
            UIViewController *setVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberSetTVC"];
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 || section == 3 || section == 4) {
        return 1;
    } else {
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        
        //宽度（设备宽度 - 间距） / Item数量
        CGFloat width = WIDTH / 2;
        // 高度（宽度 * 宽高比例） + 文字高度
        return width*1.15f+52.0f + 41.0f;
    } else if (indexPath.section == 0 || indexPath.section == 1) {
        return indexPath.row == 0 ? 44.0f : 64.0f;
    } else if (indexPath.section == 2) {
        return 86.0f;
    } else {
        return 44.0f;
    }
}

@end
