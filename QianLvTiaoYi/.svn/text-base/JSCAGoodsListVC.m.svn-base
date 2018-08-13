//
//  JSCAGoodsListVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCAGoodsListVC.h"
#import "JSContact.h"
#import "JSCollectionReView.h"
#import "JSSearchButtonBar.h"
#import "GetGoodsListData.h"
#import "JSGoodsDetailVC.h"
#import "PRFilterViewController.h"

#import "JSGoodsCVCell.h"
#import "GetUserData.h"

#import "JSCAGoodsPopupView.h"

@interface JSCAGoodsListVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewY;

@property (nonatomic, assign) int pageNumber; /**<每页返回数量*/
@property (nonatomic, assign) int currentPage; /**<当前页码*/

@property (strong, nonatomic) NSMutableArray *goodsList;
@property (nonatomic, copy) NSString *emptyDataString;

@property (assign, nonatomic) CGFloat oldOffsetY;  //临时变量：滑动的上次位置
@property (copy, nonatomic) NSString *sortString; //当前的排序条件
@property (nonatomic, assign) BOOL isPriceAsc; // 区分价格是升序还是降序

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *glTopFourViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *glTopFourLabs;
@property (weak, nonatomic) IBOutlet UIImageView *glPriceImgView;
@property (weak, nonatomic) IBOutlet UIImageView *glSortImgView;

@property (nonatomic, strong) JSCAGoodsPopupView *popupView;

@property (nonatomic, strong) UIView *popGaryView;
@property (nonatomic, assign) BOOL isPopupView; // 区分是否弹出view

@property (nonatomic, copy) NSMutableString *fliterString;

@end

@implementation JSCAGoodsListVC


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isPriceAsc = YES;
    _isPopupView = YES;
    
    UILabel *label = _glTopFourLabs[0];
    label.textColor = [UIColor redColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GoodsItem"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    
    [self setupSearchNavigationBar];
    [self setupFourViewsTapClick];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_collectionView.mj_header.isRefreshing) {
            [_collectionView.mj_header endRefreshing];
        }
        [self searchGoodsListWithSort:@""];
    }];
    
    
    //注册确定搜索通知的监听者
    [M_NOTIFICATION addObserver:self selector:@selector(configSearchGoodsMethods:) name:@"ConfigSearchNotifi" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //设置监听SearchVC回调信息
    [M_NOTIFICATION addObserver:self selector:@selector(handleSearchAction:) name:@"SearchKeyWords" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing: YES];
    [self.navigationController.navigationBar setHidden:NO];
    //视图将要消失移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private functions

- (void)setTag:(NSString *)tag
{
    _tag = tag;
    
    [self initModelsAndPager];
    [self searchGoodsListWithSort:@""];
}

//- (void)setCategoryID:(NSString *)categoryID {
//    _categoryID = categoryID;
//
//    [self initModelsAndPager];
//    [self searchGoodsListWithSort:@""];
//}

/**
 *  确定搜索的通知方法
 *
 *  Notification  @param  搜索条件
 */
- (void)configSearchGoodsMethods:(NSNotification *)notifi
{
    NSMutableArray *array = notifi.userInfo[@"fliterInfo"];
    NSMutableString *addStr = [[NSMutableString alloc]init];

    //判断是否选择了筛选条目
    if (array.count >= 1) {
        for (NSString *fliterStr in array) {
            //遍历筛选条件信息的数组 用逗号拼接
            [addStr appendString:[NSString stringWithFormat:@"%@,",fliterStr]];
        }
        // 减去最后一个逗号
        NSString *addNewStr = [addStr substringToIndex:[addStr length] - 1];
        
        NSLog(@"addNewStr = %@",addNewStr);
        
        [self searchFliterGoodsListWithFliterStr:addNewStr];
    } else {
        //没有选择
        
        [self setTag:_tag];
    }
}

/**
 *  通过NSNotificationCenter 监听 搜索关键字
 *
 *  @param sender SearchVC传递的搜索关键字
 */
-(void)handleSearchAction:(NSNotification*)sender
{
    self.tag = sender.userInfo[@"keywords"];
    
    NSLog(@"goodslist tag = %@",_tag);
}

/**
 *  设置搜索导航栏
 */
- (void)setupSearchNavigationBar
{
    JSSearchButtonBar *searchBar = [[NSBundle mainBundle] loadNibNamed:@"JSSearchButtonBar" owner:self options:nil].firstObject;
    [searchBar.rightButton setTitle:@"" forState:UIControlStateNormal];
    [searchBar.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [searchBar setButtonActionsBlock:^(NSInteger idx) {
        switch (idx) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            case 1: {
                UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
                [self presentViewController:VC animated:NO completion:nil];
            }
                break;
                default:
                break;
        }
    }];
    [self.view addSubview:searchBar];
}


/**
 *  给灰黑色view上的四个view添加点击手势
 */
- (void)setupFourViewsTapClick
{
    [_glTopFourViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFourViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

/**
 *  添加弹出视图 和 给按钮添加点击事件
 */
- (void)addPopupViewAndButtonClick
{
    _popupView = [[NSBundle mainBundle] loadNibNamed:@"JSCAGoodsPopupView" owner:self options:nil].firstObject;
    _popupView.frame = CGRectMake(0, 104, WIDTH, 89.0f);
    [self.view addSubview:_popupView];
    [_popupView.commentButton addTarget:self action:@selector(goodCommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_popupView.mustNewGoodsButton addTarget:self action:@selector(mustNewGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _glSortImgView.image = [UIImage imageNamed:@"arrow_down"];

    
    _popGaryView = [[UIView alloc]initWithFrame:CGRectMake(0, 193, WIDTH, HEIGHT - 193)];
    _popGaryView.backgroundColor = [UIColor blackColor];
    _popGaryView.alpha = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(garyViewTapClick)];
    [_popGaryView addGestureRecognizer:tap];
    [self.view addSubview:_popGaryView];
}

/**
 *  改变筛选视图上子控件的状态
 */
- (void)changeFliterBarSubViewStatus
{
    _isPopupView = YES;
    [_popupView removeFromSuperview];
    [_popGaryView removeFromSuperview];
    _glSortImgView.image = [UIImage imageNamed:@"arrow_up"];
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

#pragma mark - HttpRequest

/**
 *  设置基本参数
 */
- (void)initModelsAndPager {
    self.currentPage = 1;
    self.pageNumber = 10;
    self.goodsList = [NSMutableArray array];
    [self.collectionView reloadData];
}

/**
 *  获取搜索商品列表数据
 */
- (void)searchGoodsListWithSort:(NSString *)sort
{
    NSDictionary *param = @{@"currentPage":[NSString stringWithFormat:@"%d", _currentPage],  @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber],  @"tag":_tag?_tag:@"", @"productCategoryId": _categoryID?_categoryID:@"",@"sort": sort};
    
    __weak typeof(self) weakSelf = self;
    [GetGoodsListData postWithUrl:RMRequestStatusGoodsList param:param modelClass:[Goods class] responseBlock:^(id dataObj, NSError *error) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (dataObj) {
            weakSelf.currentPage++;
            [weakSelf.goodsList addObjectsFromArray:dataObj];
        }
        [weakSelf.collectionView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


/**
 *  获取筛选商品列表数据
 */
- (void)searchFliterGoodsListWithFliterStr:(NSString *)fliterStr
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage],  @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber],  @"tag":fliterStr? fliterStr:@""};
    
    __weak typeof(self) weakSelf = self;
    [GetGoodsListData postWithUrl:RMRequestStatusGoodsList param:param modelClass:[Goods class] responseBlock:^(id dataObj, NSError *error) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (dataObj) {
            [weakSelf.goodsList addObjectsFromArray:dataObj];
            weakSelf.currentPage++;
        }else {
            weakSelf.goodsList = [NSMutableArray array];
            weakSelf.emptyDataString = @"抱歉, 没有找到相关的商品！";
        }
        [weakSelf.collectionView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - Actions

/**
 *  顶部筛选viwe的点击事件
 */
- (void)handleTapFourViews:(UITapGestureRecognizer *)sender
{
    
    for (int i = 0; i < _glTopFourLabs.count; i++) {
        UILabel *label = _glTopFourLabs[i];
        
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //当前页数重置为1
    self.currentPage = 1;
    //移除其它状态下数组中的元素
    [self.goodsList removeAllObjects];
    
    //点击事件
    switch (sender.view.tag) {
        case 0:{
            // 综合排序
            _glPriceImgView.image = [UIImage imageNamed:@"GL_Price"];
            
            if (_isPopupView == YES) {
               
                [self addPopupViewAndButtonClick];
                
                _isPopupView = NO;
                
            } else {

                [_popupView removeFromSuperview];
                [_popGaryView removeFromSuperview];
                _glSortImgView.image = [UIImage imageNamed:@"arrow_up"];
                _isPopupView = YES;
            }
            
            break;
        }
        case 1:{
            //销量
            
            [self changeFliterBarSubViewStatus];
            _glPriceImgView.image = [UIImage imageNamed:@"GL_Price"];
            
            [self searchGoodsListWithSort:@"salesVolume"];
            
            break;
        }
        case 2:{
            
            //价格
            [self changeFliterBarSubViewStatus];
            _glPriceImgView.image = [UIImage imageNamed:@"GL_Price"];
            
            if (_isPriceAsc) //升序
            {
                _glPriceImgView.image = [UIImage imageNamed:@"GL_Price1"];
                
                [self searchGoodsListWithSort:@"priceAsc"];
                
                _isPriceAsc = NO;
                
            } else  //降序
            {
                _glPriceImgView.image = [UIImage imageNamed:@"GL_Price2"];
                
                [self searchGoodsListWithSort:@"priveDesc"];
                
                _isPriceAsc = YES;
            }
            break;
        }
        case 3:{
            //筛选
            
            [self changeFliterBarSubViewStatus];
            _glPriceImgView.image = [UIImage imageNamed:@"GL_Price"];

            PRFilterViewController *fliterVC = [[PRFilterViewController alloc] init];
            fliterVC.fliterTag = _tag;
            NSLog(@"fliterVC.fliterTag ==== %@",fliterVC.fliterTag);
            [self.navigationController presentViewController:fliterVC animated:NO completion:nil];
            
            break;
        }
        default:
            break;
    }
}

/**
 *  灰色透明view的点击手势
 */
- (void)garyViewTapClick
{
    [self changeFliterBarSubViewStatus];
    
}

/**
 *  评价最好筛选按钮点击事件
 */
- (void)goodCommentButtonClick
{
    [self changeFliterBarSubViewStatus];
    [self searchGoodsListWithSort:@"synthesize"];
}

/**
 *  最新商品筛选按钮点击事件
 */
- (void)mustNewGoodsButtonClick
{
    [self changeFliterBarSubViewStatus];
    [self searchGoodsListWithSort:@"newProduct"];
}


/**
 *  加入购物车按钮
 */
- (void)addShopCarBtnClick:(UIButton *)sender
{
    
    if ([self isLogin]) {
        Goods *goods = _goodsList[sender.tag];
        
        [WMGeneralTool addShopCarBtnClickwith:goods.goodsId];
    }
}


#pragma mark - collectionView delegate & datasouce

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goods = _goodsList[indexPath.row];
    JSGoodsDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _goodsList.count;
}
// 设置每一行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return M_HEADER_HIGHT;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = WIDTH / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.15f+52.0f);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"headerView";
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];
    Goods *goods = _goodsList[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.goodsImage] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    cell.nameLabel.text = goods.goodsName;
    
    //wm 用户没有登录只显示零售价  登录后显示零售和批发价
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:￥%.2f/%@", goods.price, goods.unit];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.2f/%@", goods.goodsPrice, goods.unit];
    
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d%@", goods.goodsSales, goods.unit];
    
    [cell.addShopCarBtn addTarget:self action:@selector(addShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;


    return cell;
}

/**
 *  重写方法
 *
 *  @param scrollView 根据滑动的位置 是顶部View实现动画效果
 */
/**
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 80 && scrollView.contentOffset.y > _oldOffsetY) {
        _topViewY.constant = _topViewY.constant < -104 ? -104 :  _topViewY.constant-(scrollView.contentOffset.y - _oldOffsetY);
    }else {
        if (scrollView.contentOffset.y > 80) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _topBackView.frame = CGRectMake(0, 0, CGRectGetWidth(_topBackView.frame), CGRectGetHeight(_topBackView.frame));
                _topView.frame = CGRectMake(0, 64, CGRectGetWidth(_topView.frame), CGRectGetHeight(_topView.frame));
            } completion:^(BOOL finished) {
                _topViewY.constant = 0.0f;
            }];
        }
    }
    _oldOffsetY = scrollView.contentOffset.y;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
