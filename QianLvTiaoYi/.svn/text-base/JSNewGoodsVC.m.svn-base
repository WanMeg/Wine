//
//  JSNewGoodsVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSNewGoodsVC.h"
#import "JSNewGoodsCVCell.h"
#import "GetNewGoodsData.h"
#import "JSGoodsDetailVC.h"
#import "GetUserData.h"

@interface JSNewGoodsVC ()<UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *upNewGoodsViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *upNewGoodsLabs;
@property (weak, nonatomic) IBOutlet UIImageView *upNewGoodsPriceImg;
@property (weak, nonatomic) IBOutlet UIImageView *upNewGoodsSaleImg;
@property (weak, nonatomic) IBOutlet UIImageView *upNewGoodsNewImg;

@property (weak, nonatomic) IBOutlet UICollectionView *upNGCollectionView;

@property (nonatomic, strong) NSMutableArray *upNewGoodsArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/

@property (nonatomic, assign) BOOL isPriceAsc; // 区分是升序还是降序

@end

@implementation JSNewGoodsVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.upNGCollectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = _upNewGoodsLabs[0];
    label.textColor = [UIColor redColor];
    
    [self setupThreeViewsTapGesture];
    
    _isPriceAsc = YES;
    
    [_upNGCollectionView registerNib:[UINib nibWithNibName:@"JSNewGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"upNewGoodsCell"];
    
    self.upNGCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self setBasicParameter];
        [self getNewGoodsRequestDataWithSort:@""];
    }];
    
    self.upNGCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getNewGoodsRequestDataWithSort:@""];
    }];
    
    [self.upNGCollectionView.mj_header beginRefreshing];
}

#pragma mark - Private Method

/**
 *  给view添加点击手势
 */
- (void)setupThreeViewsTapGesture
{
    [_upNewGoodsViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeViewsTapGestureClick:)];
         [obj addGestureRecognizer:tap];
     }];
}

/**
 *  设置基本参数
 */
- (void)setBasicParameter
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.upNewGoodsArray = [NSMutableArray array];
    [self.upNGCollectionView reloadData];
}

/**
 *  请求主页红包列表的数据
 */
- (void)getNewGoodsRequestDataWithSort:(NSString *)sort
{
    NSDictionary *param = @{@"sort":sort,@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetNewGoodsData postWithUrl:RMRequestStatusNewUpGoods param:param modelClass:[WMNewGoods class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.upNGCollectionView.mj_header endRefreshing];
         [self.upNGCollectionView.mj_footer endRefreshing];
         
         if (dataObj)
         {
             weakSelf.currentPage++;
             
             [weakSelf.upNewGoodsArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.upNGCollectionView reloadData];
         
         if (error.code == 200 || error.code == 200)
         {
             [weakSelf.upNGCollectionView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
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

#pragma mark - Actions

/**
 *  给view上的三个view添加点击手势
 */
- (void)threeViewsTapGestureClick:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < _upNewGoodsLabs.count; i++)
    {
        UILabel *label = _upNewGoodsLabs[i];
        
        if (i == sender.view.tag)
        {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //当前页数重置为1
    self.currentPage = 1;
    
    //移除其它状态下数组中的元素
    [self.upNewGoodsArray removeAllObjects];
    
    switch (sender.view.tag)
    {
        case 0:
        {
            //最新
            _upNewGoodsPriceImg.image = [UIImage imageNamed:@"GL_Price"];
            _upNewGoodsSaleImg.image = [UIImage imageNamed:@"mustNewBlack"];
            _upNewGoodsNewImg.image = [UIImage imageNamed:@"saleRed"];
            
            [self getNewGoodsRequestDataWithSort:@""];
            break;
        };
        case 1:
        {
            //销量
            _upNewGoodsPriceImg.image = [UIImage imageNamed:@"GL_Price"];
            _upNewGoodsSaleImg.image = [UIImage imageNamed:@"mustNewRed"];
            _upNewGoodsNewImg.image = [UIImage imageNamed:@"saleBlack"];
            
            [self getNewGoodsRequestDataWithSort:@"salesVolume"];
            break;
        }
        default:
        {
            //价格
            _upNewGoodsSaleImg.image = [UIImage imageNamed:@"mustNewBlack"];
            _upNewGoodsNewImg.image = [UIImage imageNamed:@"saleBlack"];
            if (_isPriceAsc) //升序
            {
                _upNewGoodsPriceImg.image = [UIImage imageNamed:@"GL_Price1"];
                [self getNewGoodsRequestDataWithSort:@"priceAsc"];
                
                _isPriceAsc = NO;
                
            } else  //降序
            {
                _upNewGoodsPriceImg.image = [UIImage imageNamed:@"GL_Price2"];
                [self getNewGoodsRequestDataWithSort:@"priveDesc"];
                
                _isPriceAsc = YES;
            }
            
            break;
        }
    }
}




/**
 *  加入购物车按钮
 */
- (void)upNewAddShopCarClick:(UIButton *)sender
{
    if ([self isLogin]) {
        WMNewGoods *upGoods = _upNewGoodsArray[sender.tag];
        [WMGeneralTool addShopCarBtnClickwith:upGoods.goodsId];
    }
}


- (IBAction)backHomePageVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collectionViewdelegate & datasouse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _upNewGoodsArray.count;
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
    JSNewGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upNewGoodsCell" forIndexPath:indexPath];
    
    WMNewGoods *upGoods = _upNewGoodsArray[indexPath.row];
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        cell.upNewGoodsPFLab.text = [NSString stringWithFormat:@"批:¥%.2f/%@",upGoods.wholesalePrice,upGoods.unit];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.upNewGoodsPFLab.text = @"认证可见";
    } else {
        cell.upNewGoodsPFLab.text = @"登录认证可见";
    }
    cell.upNewGoodsLSLab.text = [NSString stringWithFormat:@"零:¥%.2f/%@",upGoods.retailPrice,upGoods.unit];
    
    [cell.upNewGoodsImg sd_setImageWithURL:[NSURL URLWithString:upGoods.goodsImage] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.upNewGoodsName.text = upGoods.goodsName?upGoods.goodsName:@"";
    cell.upNewGoodsXLLab.text = [NSString stringWithFormat:@"销量:%d%@",upGoods.goodsSales,upGoods.unit];
    
    [cell.addShopCarBtn addTarget:self action:@selector(upNewAddShopCarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;

    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMNewGoods *goods = _upNewGoodsArray[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
