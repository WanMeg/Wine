//
//  JSGoodsDetailVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/18.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#define M_IS_CROWD [_activityType isEqualToString:@"2"]

#import "JSGoodsDetailVC.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "GetUserData.h"

#import "JSGoodsDetailNameCell.h"

#import "JSGoodsDetaillDesc2Cell.h"
#import "JSGoodsDetaillDesc3Cell.h"
#import "JSGoodsDetaillDesc4Cell.h"
#import "JSGoodsDetaillDesc5Cell.h"
#import "JSGoodsDetailImageCell.h"
#import "JSGoodsDetailGroupCell.h"
#import "JSGoodsDetailTimedCell.h"

#import "JSGuessLikeCell.h"
#import "JSEvaluateView.h"
#import "GetGoodsDetailData.h"
#import "GetProductData.h"
#import "PRSliderController.h"
#import "PRAlertView.h"
#import "JSShoppingCartVC.h"
#import "JSCommitOrderVC.h"
#import "StoreDetailVC.h"
#import "CommentModel.h"
#import "MQChatViewManager.h"
#import "JSGDCouponTVC.h"
#import "JSGDActivityView.h"
#import "JSActivityRedView.h"
#import "JSGroupActView.h"
#import "GetCrowdInfoData.h"
#import "JSCrowdfundView.h"
#import "JSCrowdImageCell.h"
#import "JSCrowdInfoCell.h"
#import "JSCrowdCountCell.h"

@interface JSGoodsDetailVC ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UICollectionViewDelegate, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIView *navgationView;/**<*/
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;/**<顶部segment*/
@property (nonatomic, strong) PRSliderController *sc;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;/**<*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;/**<分割线高度*/
//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bigBottomView;

@property (strong, nonatomic) UITableView *goodsTableView;/**<*/
@property (strong, nonatomic) UIWebView *webView;/**<商品详情页*/
@property (strong, nonatomic) JSEvaluateView *evaluateView;/**<评价View*/

@property (strong, nonatomic) GoodsDetail *goodsDetailInfo;/**<商品基础数据*/
@property (strong, nonatomic) Product *product;/**<选择规格之后 请求到product*/
@property (copy, nonatomic) NSString *detailURL;

@property (strong, nonatomic) NSMutableArray *photos;        /**<Banner图片*/
@property (nonatomic, copy) NSString * selectedSpecString;/**<选择之后拼接的规格字符串*/
@property (nonatomic, strong) NSArray *selectedItems;/**<按照规格顺序 选中的item数组*/
@property (nonatomic, assign) NSUInteger currentQuantity;/**<当前选则的商品数量  默认为1*/
@property (nonatomic, assign) NSInteger commentPage;    //商品评论分页
@property (nonatomic, assign) NSInteger pageNumber;    //商品评论分页数量
@property (nonatomic, strong) NSMutableArray *commentList;  //商品评论列表

@property (nonatomic, strong) JSGDActivityView *activityView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) JSActivityRedView *activityRedView;
@property (nonatomic, strong) JSGroupActView *groupActView;
@property (nonatomic, strong) JSCrowdfundView *crowdfundView;
@property (nonatomic, strong) NSDictionary *crowdInfoDict;
@property (nonatomic, strong) JSCrowdImageCell *crowdImageCell;
@property (nonatomic, strong) JSCrowdInfoCell *crowdInfoCell;
@property (nonatomic, strong) JSCrowdCountCell *crowdCountcell;
@property (nonatomic, strong) NSMutableArray *crowdStageArr;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int crowdCount;

/** 根据活动是否开启 或者 是否已结束  来判断是否可以购买*/
@property (nonatomic, assign) int judgeActTimeIsOrNoBuy;

@end

@implementation JSGoodsDetailVC

#pragma mark - Life Cycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.crowdInfoDict = [NSDictionary dictionary];
    self.crowdStageArr = [NSMutableArray array];
    //登录后刷新第0区 第1行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.goodsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if (_isActivityGoods == YES) {
        if ([_activityType isEqualToString:@"1"]) { //限时抢购
            [self createRushActivityRedView];
            if (_timer == nil) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goodsDetailCountTimeTimerMethod:) userInfo:nil repeats:YES];
            }
        } else if ([_activityType isEqualToString:@"0"]) { //今日团购
            [self createGroupActivityRedView];
            [self createJoinCrowdView];
        } else if ([_activityType isEqualToString:@"2"]) { //商品众筹
            if (_timer == nil) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goodsDetailCountTimeTimerMethod:) userInfo:nil repeats:YES];
            }
            [self createJoinCrowdView];
            [self requestCrowdfundingInfoRequest];
            [self requestGoodsDetailURLWithGoodsID:_goodsID];
        }
        
        // 活动方式为众筹活动时 不查询商品产品信息
        if (![_activityType isEqualToString:@"2"]) {
            if (self.goodsDetailInfo == nil) {
                [self requestGoodsDetailURLWithGoodsID:_goodsID];
                [self requestGoodsDetailWithgoodsID:_goodsID];
            }
        }

    } else {
        if (self.goodsDetailInfo == nil) {
            [self requestGoodsDetailURLWithGoodsID:_goodsID];
            [self requestGoodsDetailWithgoodsID:_goodsID];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lineHeight.constant = 0.5f;
    self.currentQuantity = 1;  //设置默认值为1
    [self initPager];
    
    [self setupSegmentedControl];
    
     _segmentedControl.frame = CGRectMake(0, 0, CGRectGetWidth(_navgationView.frame), CGRectGetHeight(_navgationView.frame));
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.scrollView.contentSize = CGSizeMake(WIDTH * 3, CGRectGetHeight(_scrollView.frame));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    //销毁定时器
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Request functions

/**
 *  设置评论页面的值
 */
- (void)initPager {
    _pageNumber = 10;
    _commentPage = 1;
    _evaluateView.commentResults = nil;
    [_evaluateView.tableView reloadData];
}

/**
 *  请求商品详情数据
 *
 *  @param goodsID 入参 goodsID
 */
- (void)requestGoodsDetailWithgoodsID:(NSString *)goodsID
{
    __weak typeof(self) weakSelf = self;
     [SVProgressHUD showWithStatus:@"请稍后..."];
    [GetGoodsDetailData postWithUrl:RMRequestStatusGoodsDetail param:@{@"goodsId": goodsID?goodsID:@"",@"activityId":_activityId?_activityId:@""} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD dismiss];
            weakSelf.goodsDetailInfo = dataObj;
            [weakSelf setDefaultSelectedSpecs];
            [weakSelf.goodsTableView reloadData];
            
            //判断是否自营店铺  0是  1 否
            if (!_goodsDetailInfo.goods.isAutotrophy) {
                // 隐藏店铺按钮
                [_storeButton setImage:nil forState:UIControlStateNormal];
                [_storeButton setTitle:@"" forState:UIControlStateNormal];
                _storeButton.userInteractionEnabled = NO;
                _leftView.backgroundColor = [UIColor whiteColor];
                _customerBtn.frame = CGRectMake(16.0f, 0, 48.0f, 48.0f);
                _collectButton.frame = CGRectMake(80.0f, 0, 48.0f, 48.0f);
            }
            
            if ([_activityType isEqualToString:@"1"]) {
                
                //限时抢购
                
                _activityRedView.rushNumber.text = [NSString stringWithFormat:@"已抢:%@件",_goodsDetailInfo.goods.partakeNumber?_goodsDetailInfo.goods.partakeNumber:@""];
                _activityRedView.activityPrice.text = [NSString stringWithFormat:@"¥ %.2f",_goodsDetailInfo.goods.goodsPrice];
                _activityRedView.price.text = [NSString stringWithFormat:@"¥ %.2f",_goodsDetailInfo.goods.price];
                _activityRedView.rushPercentage.text = [NSString stringWithFormat:@"已抢:%ld%@",(long)_goodsDetailInfo.goods.awardedNum,@"%"];
                _activityRedView.rushProgress.progress = _goodsDetailInfo.goods.awardedNum / 100.0;
                
                NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_activityRedView.price.text attributes:attribtDic];
                _activityRedView.price.attributedText = attribtStr;
                
            } else if ([_activityType isEqualToString:@"0"]) {
                //团购
                
                _groupActView.acticityPrice.text = [NSString stringWithFormat:@"¥ %.2f",_goodsDetailInfo.goods.goodsPrice];
                _groupActView.price.text = [NSString stringWithFormat:@"¥ %.2f",_goodsDetailInfo.goods.price];
                _groupActView.rushNumber.text = [NSString stringWithFormat:@"已抢:%@件",_goodsDetailInfo.goods.partakeNumber];
                
                NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_groupActView.price.text attributes:attribtDic];
                _groupActView.price.attributedText = attribtStr;
            }
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *  请求产品信息数据
 *
 *  @param specValue 规格拼接值，多个参数用逗号隔开
 *  @param goodsID
 */
- (void)requestProductInfo:(NSString *)specValue goodsID:(NSString *)goodsID {
    NSDictionary *parma = @{@"specValue": specValue, @"goodsId": goodsID};
    __weak typeof(self) weakSelf = self;
    [GetProductData postWithUrl:RMRequestStatusGetProductID param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            weakSelf.product = dataObj;
            [weakSelf.goodsTableView reloadData];
        }
    }];
}

/**
 *  请求评论列表
 *
 *  @param specValue 规格拼接值，多个参数用逗号隔开
 *  @param goodsID
 */
- (void)requestGoodsCommentWithGoodsID:(NSString *)goodsID sort:(NSInteger)sort {
    NSString *sortStr = nil;
    switch (sort) {
        case 0:
            sortStr = @"";
            break;
        case 1:
            sortStr = @"goods";
            break;
        case 2:
            sortStr = @"centre";
            break;
        case 3:
            sortStr = @"bad";
            break;
        case 4:
            sortStr = @"image";
            break;
        default:
            break;
    }
    NSDictionary *parma = @{@"goodsId": goodsID, @"currentPage": @(_commentPage), @"pageNumber": @(_pageNumber), @"sort": sortStr};
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [XLDataService postWithUrl:RMRequestStatusGoodsComment param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100 || error.code == 200) {
            [SVProgressHUD dismiss];
            _commentPage++;
            weakSelf.evaluateView.commentResults = [CommentResultsModel mj_objectWithKeyValues:dataObj];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  请求添加购物车
 *
 *  @param productID 产品ID
 *  @param quantity  购买数量
 */
- (void)requestAddtoCartWith:(NSString *)productID quantity:(NSString *)quantity {
    NSDictionary *param = @{@"productId": productID ? productID : @"", @"number": quantity,@"goodsType":@"0"};
    __weak typeof(self) weakSelf = self;
    [XLDataService postWithUrl:RMRequestStatusAddCart param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:error.domain];
            [weakSelf.sc dismissViewControllerAnimated:NO completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  请求添加商品到收藏夹
 *
 *  @param goodsID 商品ID
 */
- (void)requestAddToCollectListWithGoodsID:(NSString *)goodsID
{
    __weak typeof(self) weakSelf = self;
    
    [XLDataService postWithUrl:RMRequestStatusAddCollect param:@{@"goodsId": goodsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            weakSelf.goodsDetailInfo.isCollect = !weakSelf.goodsDetailInfo.isCollect;
            [SVProgressHUD showSuccessWithStatus:error.domain];
        }
    }];
}

/**
 *  请求商品详情URL
 *
 *  @param goodsID
 */
- (void)requestGoodsDetailURLWithGoodsID:(NSString *)goodsID {
    __weak typeof(self) weakSelf = self;
    [XLDataService getWithUrl:RMRequestStatusAppDetails param:@{@"goodsId": goodsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             weakSelf.detailURL = dataObj[@"goodsDetails"];
         }
     }];
}

/**
 *  请求众筹详情信息
 *
 *  @param activityId
 */
- (void)requestCrowdfundingInfoRequest
{
    __weak typeof(self) weakSelf = self;
    [GetCrowdInfoData postWithUrl:RMRequestStatusCrowdfundingInfo param:@{@"activityId": _activityId} modelClass:[WMCrowdInfo class] responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             weakSelf.crowdInfoDict = dataObj[@"info"][@"goods"];
             [_crowdImageCell.actIamge sd_setImageWithURL:[NSURL URLWithString:_crowdInfoDict[@"pic"]] placeholderImage:[UIImage imageNamed:@"noimage"]];
             _crowdInfoCell.goodsName.text = _crowdInfoDict[@"goodsName"];
             float money = [_crowdInfoDict[@"handselScale"] floatValue];
             _crowdInfoCell.downPayment.text = [NSString stringWithFormat:@"定金:¥%.2f/箱",money];
             
             float pfMoney = [_crowdInfoDict[@"wholesalePrice"] floatValue];
             
             if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
                 _crowdInfoCell.piFaPrice.text = [NSString stringWithFormat:@"批发价:¥%.2f/箱",pfMoney];
             } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
                 _crowdInfoCell.piFaPrice.text = [NSString stringWithFormat:@"零售价:¥%.2f/箱",pfMoney];
             } else {
                 _crowdInfoCell.piFaPrice.text = [NSString stringWithFormat:@"零售价:¥%.2f/箱",pfMoney];
             }
             _crowdInfoCell.spec.text = _crowdInfoDict[@"strs"];
             _crowdInfoCell.joinNumber.text = [NSString stringWithFormat:@"%@人参与",_crowdInfoDict[@"count"]];

             //阶段信息
             NSArray *crowdStageArr = _crowdInfoDict[@"list"];
             
             NSDictionary *lastCs = crowdStageArr.lastObject;
             
             float lastStage = [lastCs[@"stageStart"] floatValue];
             float number = [_crowdInfoDict[@"salesNum"] floatValue];
             _crowdInfoCell.crowdProgress.progress = number / lastStage;
             
             _crowdInfoCell.lastNumber.text = [NSString stringWithFormat:@"%.0f件",lastStage];
             _crowdInfoCell.lastMoney.text = [NSString stringWithFormat:@"¥%@",lastCs[@"price"]];
             _crowdInfoCell.centerNumber.text = [NSString stringWithFormat:@"%.0f件",lastStage/2];
             _crowdInfoCell.numLab.text = [NSString stringWithFormat:@"%@",_crowdInfoDict[@"salesNum"]];
             _crowdInfoCell.numLab.frame = CGRectMake(_crowdInfoCell.crowdProgress.frame.origin.x+_crowdInfoCell.crowdProgress.frame.size.width*_crowdInfoCell.crowdProgress.progress, _crowdInfoCell.crowdProgress.frame.origin.y+39, 8*_crowdInfoCell.numLab.text.length, 9);
             
             //规格
             NSArray *specArr = _crowdInfoDict[@"productList"];
             _crowdInfoCell.spec.text = specArr.firstObject[@"value"];
             
        /******************** 判断当前阶段的众筹价格 **********************/
             NSDictionary *firstCS = crowdStageArr.firstObject;
             float firstStageStart = [firstCS[@"stageStart"] floatValue];
             if (number == 0) {
                 _crowdInfoCell.nowCrowdPrice.text = @"当前众筹价格:¥0";
             } else {
                 if (number < firstStageStart) {
                     _crowdInfoCell.nowCrowdPrice.text = @"当前众筹价格:¥0";
                 }
                 if (number >= lastStage) {
                     _crowdInfoCell.nowCrowdPrice.text = [NSString stringWithFormat:@"当前众筹价格:¥%.0f",[lastCs[@"price"] floatValue]];
                 }
                 
                 for (NSDictionary *dict in crowdStageArr) {
                     float start = [dict[@"stageStart"] floatValue];
                     float last = [dict[@"stageEnd"] floatValue];
                     if (number > start && number < last) {
                         _crowdInfoCell.nowCrowdPrice.text = [NSString stringWithFormat:@"当前众筹价格:¥%.0f",[dict[@"price"] floatValue]];
                     }
                 }
             }
             
        /********************* 判断中间价格的显示 ************************/

             for (NSDictionary *dict in crowdStageArr) {
                 float start = [dict[@"stageStart"] floatValue];
                 float last = [dict[@"stageEnd"] floatValue];
                 if (lastStage/2 >= start && lastStage/2 < last) {
                     _crowdInfoCell.centerMoney.text = [NSString stringWithFormat:@"¥%.0f",[dict[@"price"] floatValue]];
                 }
             }
             
         } else {
             //[SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];

}


#pragma mark - Private functions

/**
 *  goodsDetailInfo赋值的时候更新 photos内容
 *
 *  @param goodsDetailInfo
 */
- (void)setGoodsDetailInfo:(GoodsDetail *)goodsDetailInfo
{
    _goodsDetailInfo = goodsDetailInfo;
    
    if (self.photos == nil) {
        self.photos = [NSMutableArray array];
    }
    for (GoodsImage *img in goodsDetailInfo.goodsImg) {
        [_photos addObject:img.imgUrl?img.imgUrl:@""];
    }
    
    // 确定收藏按钮的状态
    if (_goodsDetailInfo.isCollect) {
        [_collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"pjhongxing"] forState:UIControlStateNormal];
    } else {
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"guanzhu0"] forState:UIControlStateNormal];
    }
}

/**
 *  初始化SegmentControl以及 包含的Views
 */
- (void)setupSegmentedControl
{
    NSArray *titles = @[@"商品", @"详情", @"评价"];
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = QLTY_MAIN_COLOR;
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:15]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : QLTY_MAIN_COLOR};
    _segmentedControl.selectedSegmentIndex = 0;
    [_navgationView addSubview:_segmentedControl];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index)
     {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(WIDTH * index, 0, WIDTH, HEIGHT-64-49) animated:YES];
         if(index== 2 && !weakSelf.evaluateView.commentResults) {
             
             if ([weakSelf.activityType isEqualToString:@"2"]) {
                 [weakSelf requestGoodsCommentWithGoodsID:weakSelf.crowdInfoDict[@"goodsId"] sort:0];
             } else {
                 [weakSelf requestGoodsCommentWithGoodsID:weakSelf.goodsDetailInfo.goods.goodsId sort:0];
             }
         }
         if (index == 1) {
             [weakSelf.webView loadHTMLString:weakSelf.detailURL baseURL:nil];
         }
    }];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
   
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _goodsTableView.delegate = self;
    _goodsTableView.dataSource = self;
    _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goodsTableView.showsVerticalScrollIndicator = NO;
    
    _goodsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self registTableViewCell];
    [_scrollView addSubview:_goodsTableView];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-64-49)];
    self.webView.scrollView.showsVerticalScrollIndicator = false;

    [_scrollView addSubview:_webView];
    
    _evaluateView = [[JSEvaluateView alloc] initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT-64-49)];

    //评论 筛选事件
    [self.evaluateView.topBar evaluateTopBarDidChangeSelectedIndex:^(NSUInteger selectedIndex) {
        [weakSelf initPager];
        
        if ([weakSelf.activityType isEqualToString:@"2"]) {
            [weakSelf requestGoodsCommentWithGoodsID:weakSelf.crowdInfoDict[@"goodsId"] sort:selectedIndex];
        } else {
            [weakSelf requestGoodsCommentWithGoodsID:weakSelf.goodsDetailInfo.goods.goodsId sort:selectedIndex];
        }
    }];

    [_scrollView addSubview:_evaluateView];
}

/**
 *  设置注册单元格
 */
- (void)registTableViewCell
{
    [_goodsTableView registerClass:[JSGoodsDetailImageCell class] forCellReuseIdentifier:@"imageCell"];
    
    [_goodsTableView registerNib:[UINib nibWithNibName:@"JSGoodsDetailNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"nameCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"JSGoodsDetaillDesc1Cell" bundle:[NSBundle mainBundle]];
    [_goodsTableView registerNib:nib1 forCellReuseIdentifier:@"desc1Cell"];
    UINib *nib2 = [UINib nibWithNibName:@"JSGoodsDetaillDesc2Cell" bundle:[NSBundle mainBundle]];
    [_goodsTableView registerNib:nib2 forCellReuseIdentifier:@"desc2Cell"];
    UINib *nib3 = [UINib nibWithNibName:@"JSGoodsDetaillDesc3Cell" bundle:[NSBundle mainBundle]];
    [_goodsTableView registerNib:nib3 forCellReuseIdentifier:@"desc3Cell"];
    UINib *nib4 = [UINib nibWithNibName:@"JSGoodsDetaillDesc4Cell" bundle:[NSBundle mainBundle]];
    [_goodsTableView registerNib:nib4 forCellReuseIdentifier:@"desc4Cell"];
    
    [_goodsTableView registerClass:[JSGoodsDetaillDesc5Cell class] forCellReuseIdentifier:@"desc5Cell"];
    
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"JSCrowdImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"crowdImageCell"];
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"JSCrowdInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"crowdInfoCell"];
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"JSCrowdCountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"crowdCountCell"];
}

/**
 *  显示photoBrowser
 *
 *  @param index 当前的图片下标
 */
- (void)pushToPhotoBrowserWith:(NSUInteger)index  {
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}

/**
 *  显示SliderViewController
 */
- (void)showSliderViewController {

     //侧滑视图，取值，回调
    __weak typeof(self) weakSelf = self;
    self.sc = [[PRSliderController alloc] initWithTotals: _goodsDetailInfo.goodsSpecificationss.count header:nil getData:^id (NSUInteger currentIndex) {
        //返回每一行要显示的 规格内容
        return weakSelf.goodsDetailInfo.goodsSpecificationss[currentIndex];
    } callBack:^(NSArray *selectedItems, NSInteger quantity) {
        //保存选择的值
        weakSelf.selectedItems = selectedItems;
        weakSelf.currentQuantity = quantity;
        //设置选中后的规格信息
        [weakSelf createCurrentSelectedSpecsWithSectedItems:selectedItems];
        
        [weakSelf.goodsTableView reloadData];
    }];
    
    GoodsImage *img = _goodsDetailInfo.goodsImg.firstObject;
    _sc.imageUrl = img.imgUrl ? img.imgUrl : @"";
    _sc.pifaPrice = [NSString stringWithFormat:@"零售价:%.2f",_goodsDetailInfo.goods.price];
    _sc.lingsPrice = [NSString stringWithFormat:@"批发价:%.2f",_goodsDetailInfo.goods.goodsPrice];
    if ([_activityType isEqualToString:@"0"]) {
        _sc.isGroupActivity = YES;
    } else {
        _sc.isGroupActivity = NO;
    }
    
    //传入已经选择的值
    _sc.currentQuantity = self.currentQuantity;
    _sc.selectedItems = [NSMutableArray arrayWithArray:self.selectedItems];
    
    //SliderController购物车点击事件
    [_sc setAddCartCallBack: ^(){
        [weakSelf.sc dismissViewControllerAnimated:NO completion:nil];
        //判断是否登录
        if ([weakSelf isLogin]) {
            
            if (_isActivityGoods == YES) {
                if (_judgeActTimeIsOrNoBuy == YES) {
                    //判断是不是团购活动
                    if (weakSelf.sc.isGroupActivity) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
                        JSCommitOrderVC *vc = [sb instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
                        //加入团购
                        vc.productID = weakSelf.product.goodsProductId;
                        vc.goodsCount = weakSelf.currentQuantity;
                        vc.goodsAciType = @"1";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        [weakSelf requestAddtoCartWith:weakSelf.product.goodsProductId quantity:[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.currentQuantity]];
                    }

                } else if (_judgeActTimeIsOrNoBuy == NO) {
                    [SVProgressHUD showErrorWithStatus:@"活动尚未开始或已结束!"];
                }
            } else {
                //判断是不是团购活动
                if (weakSelf.sc.isGroupActivity) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
                    JSCommitOrderVC *vc = [sb instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
                    //加入团购
                    vc.productID = weakSelf.product.goodsProductId;
                    vc.goodsCount = weakSelf.currentQuantity;
                    vc.goodsAciType = @"1";
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [weakSelf requestAddtoCartWith:weakSelf.product.goodsProductId quantity:[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.currentQuantity]];
                }
            }
        }
    }];
    [self.navigationController presentViewController:_sc animated:NO completion:nil];
}

/**
 *  设置默认选中的规格值
 *
 *  默认选择规格中的第一个
 */
- (void)setDefaultSelectedSpecs
{
    NSInteger count = self.goodsDetailInfo.goodsSpecificationss.count;
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [mArr addObject:@(0)];
    }
    self.selectedItems = mArr;
    [self createCurrentSelectedSpecsWithSectedItems:mArr];
}

/**
 *  根据当前选择的规格下标 按照规格数组顺序保存下标
 *
 *  @param selectedItems 当前的规格下标数组
 */
- (void)createCurrentSelectedSpecsWithSectedItems:(NSArray *)selectedItems
{
    NSMutableString *mValue = [NSMutableString string];
    NSMutableString *specValue = [NSMutableString string];
    for (int i = 0; i < selectedItems.count; i++) {
        NSNumber *num = selectedItems[i];
        GoodsSpecifications *goodsSpec = _goodsDetailInfo.goodsSpecificationss[i];
        ProductSpecificationsValue * value = goodsSpec.productSpecificationsValues[num.intValue];
        if (i == selectedItems.count - 1) {
            [mValue appendString:[NSString stringWithFormat:@"%@", value.specificationsValue]];
            [specValue appendString:[NSString stringWithFormat:@"%@", value.productSpecificationsValueId]];
        } else {
            [mValue appendString:[NSString stringWithFormat:@"%@ ", value.specificationsValue]];
            [specValue appendString:[NSString stringWithFormat:@"%@,", value.productSpecificationsValueId]];
        }
    }
    self.selectedSpecString = [NSString stringWithFormat:@"%@ %ld%@", mValue, (long)_currentQuantity, _goodsDetailInfo.goods.unit];
    [self requestProductInfo:specValue goodsID:_goodsDetailInfo.goods.goodsId];
}

/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin {
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
 *  创建抢购的红色view
 */
- (void)createRushActivityRedView
{
    _activityRedView = [[NSBundle mainBundle]loadNibNamed:@"JSActivityRedView" owner:self options:nil].firstObject;
    _activityRedView.frame = CGRectMake(0, WIDTH - 50.0 ,WIDTH , 50.0f);
    [self.goodsTableView addSubview:_activityRedView];
}

/**
 *  创建团购的红色view
 */
- (void)createGroupActivityRedView
{
    _groupActView = [[NSBundle mainBundle]loadNibNamed:@"JSGroupActView" owner:self options:nil].firstObject;
    _groupActView.frame = CGRectMake(0, WIDTH - 50.0 ,WIDTH , 50.0f);
    [self.goodsTableView addSubview:_groupActView];
}

/**
 *  创建底部加入众筹view
 */
- (void)createJoinCrowdView
{
    _crowdfundView = [[NSBundle mainBundle]loadNibNamed:@"JSCrowdfundView" owner:self options:nil].firstObject;
    _crowdfundView.frame = CGRectMake(0, 0, _bigBottomView.frame.size.width , 49.0f);
    if (!M_IS_CROWD) {
        [_crowdfundView.crowdJoinCrowdBtn setTitle:@"加入团购" forState:UIControlStateNormal];
    }
    [_crowdfundView.crowdKeFuBtn addTarget:self action:@selector(crowdButtonClicks:) forControlEvents:UIControlEventTouchUpInside];
    [_crowdfundView.crowdJoinCrowdBtn addTarget:self action:@selector(crowdButtonClicks:) forControlEvents:UIControlEventTouchUpInside];
    [self.bigBottomView addSubview:_crowdfundView];
}

/**
 *  跳转确认订单页面
 */
- (void)skipCommitOrderVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
    JSCommitOrderVC *vc = [sb instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
    vc.productID = _product.goodsProductId;
    vc.goodsCount = _currentQuantity;
    vc.goodsAciType = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  众筹跳转到CommitOrderVC
 */
- (void)crowdSkipCommitOrderVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
    JSCommitOrderVC *vc = [sb instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
    //加入众筹
    vc.productID = _crowdInfoDict[@"productId"];
    if (_crowdCountcell.countTF.text == nil) {
        vc.goodsCount = 1;
    } else {
        vc.goodsCount = [_crowdCountcell.countTF.text intValue];
    }

    vc.goodsAciType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSTimer method

/**
 *  定时器控制活动时间展示
 */
- (void)goodsDetailCountTimeTimerMethod:(NSTimer *)timer
{
    NSDate *today = [NSDate date];
    if ([_activityType isEqualToString:@"1"]) {
        //显示抢购
        
        if ([WMGeneralTool judgeAssignTimeWith:[_goodsDetailInfo.goods.beginTime longLongValue]]) {
            //活动已开始  显示 距离结束时间  展示当前距离结束的时间
            
            NSString *countTime = [WMGeneralTool getCountTimeWithOneTime:[today timeIntervalSince1970] withTwoTime:[_goodsDetailInfo.goods.endTime longLongValue]];
            if ([countTime isEqualToString:@"活动已结束"]) {
                _judgeActTimeIsOrNoBuy = NO;
                _activityRedView.endTime.text = @"活动已结束";
            } else {
                _judgeActTimeIsOrNoBuy = YES;
                _activityRedView.endTime.text = [NSString stringWithFormat:@"距离结束:%@",countTime];
            }
        } else {
            //活动未开始  显示 距离开始时间  展示开始时间距离当前的时间
            _judgeActTimeIsOrNoBuy = NO;
            _activityRedView.endTime.text = [NSString stringWithFormat:@"距离开始:%@",[WMGeneralTool getCountTimeWithOneTime:[today timeIntervalSince1970] withTwoTime:[_goodsDetailInfo.goods.beginTime longLongValue]]];
        }
    }
    
    if ([_activityType isEqualToString:@"2"]) {
        // 众筹
        
        NSString *countTime = [WMGeneralTool getCountTimeWithOneTime:[today timeIntervalSince1970] withTwoTime:[_crowdInfoDict[@"endTime"] longLongValue]];
        if ([countTime isEqualToString:@"活动已结束"]) {
            _judgeActTimeIsOrNoBuy = NO;
            _crowdInfoCell.overTime.text = @"活动已结束";
        } else {
            _judgeActTimeIsOrNoBuy = YES;
            _crowdInfoCell.overTime.text = [NSString stringWithFormat:@"距离结束:%@",countTime];
        }
    }
}

#pragma mark - Acitons

/**
 *  购物车按钮点击事件
 */
- (IBAction)showShoppingCart:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
    JSShoppingCartVC *vc = [sb instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
    vc.isHaveBarItem = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  加入购物车按钮点击事件
 *
 *  @param sender UIButton
 */
- (IBAction)addToCartAction:(UIButton *)sender {
    //判断是否登录
    if (![self isLogin]) {
        return;
    }
    
    if (_isActivityGoods == YES) {
        if (_judgeActTimeIsOrNoBuy == YES) {
            [self requestAddtoCartWith:_product.goodsProductId quantity:[NSString stringWithFormat:@"%lu", (unsigned long)_currentQuantity]];
        } else if (_judgeActTimeIsOrNoBuy == NO) {
            [SVProgressHUD showErrorWithStatus:@"活动尚未开始或已结束!"];
        }
    } else {
        [self requestAddtoCartWith:_product.goodsProductId quantity:[NSString stringWithFormat:@"%lu", (unsigned long)_currentQuantity]];
    }
}

/**
 *  立即购买按钮
 */
- (IBAction)buyNow:(id)sender {
    //判断是否登录
    if (![self isLogin]) {
        return;
    } else {
        if (_isActivityGoods == YES) {
            if (_judgeActTimeIsOrNoBuy == YES) {
                [self skipCommitOrderVC];
            } else if (_judgeActTimeIsOrNoBuy == NO) {
                [SVProgressHUD showErrorWithStatus:@"活动尚未开始或已结束!"];
            }
        } else {
            [self skipCommitOrderVC];
        }
    }
}

/**
 *  跳转店铺按钮点击事件
 *
 *  传参 shopId
 */
- (IBAction)shareAction:(UIButton *)sender {
    
    StoreDetailVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreDetailVC"];
    vc.shopID = _goodsDetailInfo.goods.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  联系客服按钮点击事件
 */
- (IBAction)callServiceAction:(UIButton *)sender {
    if (![self isLogin]) {
        return;
    } else {
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        [chatViewManager presentMQChatViewControllerInViewController:self];
    }
}

/**
 *  收藏按钮点击事件
 *
 *  延时方法 改变按钮图片
 */
- (IBAction)favoriteAction:(UIButton *)sender
{
    if (![self isLogin]) {
        return;
    }
    [self requestAddToCollectListWithGoodsID:_goodsID];
    
    //延时执行刷新方法
    [PRUitls delay:1.0 finished:^ {
         [self requestGoodsDetailWithgoodsID:_goodsID];
     }];
}

/**
 *  分享按钮点击事件
 */
- (void)shareButtonClick
{
    GoodsImage *images = _goodsDetailInfo.goodsImg[0];
    [WMGeneralTool shareMethodWithImg:images.imgUrl withUrlStr:_goodsDetailInfo.goods.sharePath withTitle:_goodsDetailInfo.goods.name];
}

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  众筹.团购 页面底部按钮点击事件
 */
- (void)crowdButtonClicks:(UIButton *)sender
{
    if (sender.tag == 10) { //客服
        [self callServiceAction:sender];
    } else {
        //购买

        //判断是否登录
        if (![self isLogin]) {
            return;
        } else {
            if ([sender.titleLabel.text isEqualToString:@"加入团购"]) {
                //加入团购
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
                JSCommitOrderVC *vc = [sb instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
                vc.productID = _product.goodsProductId;
                vc.goodsCount = _currentQuantity;
                vc.goodsAciType = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([sender.titleLabel.text isEqualToString:@"加入众筹"]) {
                //加入众筹
                if (_judgeActTimeIsOrNoBuy == YES) {
                    [self crowdSkipCommitOrderVC];
                } else if (_judgeActTimeIsOrNoBuy == NO) {
                    [SVProgressHUD showErrorWithStatus:@"活动尚未开始或已结束!"];
                }
            }
        }
    }
}

/**
 *  众筹详情分享按钮点击事件
 */
- (void)crowdInfoShareBtnClick
{
    [WMGeneralTool shareMethodWithImg:_crowdInfoDict[@"pic"] withUrlStr:_crowdInfoDict[@"sharePath"] withTitle:_crowdInfoDict[@"goodsName"]];
}

/**
 *  众筹详情数量cell按钮点击事件
 */
- (void)crowdCountBtnClick:(UIButton *)sender
{
    int count = [_crowdCountcell.countTF.text intValue];
    if (sender.tag == 50) {
    // + 按钮
        _crowdCountcell.countTF.text = [NSString stringWithFormat:@"%d",count+1];
    } else {
    // - 按钮
        if (count <= 1) {
            return;
        } else {
            _crowdCountcell.countTF.text = [NSString stringWithFormat:@"%d",count -1];
        }
    }
}

#pragma mark - MWPhotoBrowser Delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [MWPhoto photoWithURL:[NSURL URLWithString:_photos[index]]];
}

#pragma mark - SDCycleScrollView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self pushToPhotoBrowserWith:index];
}


#pragma mark - scroll view delegate
/**
 *  更新segemntedControl当前页
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:NO];

    if(page== 2 && !self.evaluateView.commentResults) {
        
        if (M_IS_CROWD) {
            [self requestGoodsCommentWithGoodsID:_crowdInfoDict[@"goodsId"] sort:0];
        } else {
            [self requestGoodsCommentWithGoodsID:self.goodsDetailInfo.goods.goodsId sort:0];
        }
    }
    
    if (page == 1) {
        [self.webView loadHTMLString:self.detailURL baseURL:nil];
    }
}

#pragma mark - Table view delegate

/**
 *  灰色view点击事件
 */
- (void)bottomViewTapClick
{
    [_activityView removeFromSuperview];
    [_bottomView removeFromSuperview];
}

/**
 *  添加灰色和活动视图
 */
- (void)addGaryViewAndActivityView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomViewTapClick)];
    _bottomView.userInteractionEnabled = YES;
    [_bottomView addGestureRecognizer:tap];
    
    [self.view addSubview:_bottomView];

    _activityView = [[NSBundle mainBundle]loadNibNamed:@"JSGDActivityView" owner:self options:nil].firstObject;
    _activityView.frame = CGRectMake(0, self.view.frame.size.height - 220.0 ,WIDTH , 220.0f);
    [self.view addSubview:_activityView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //领取红包
    if (indexPath.section == 0 && indexPath.row == 4) {
        
        if (_goodsDetailInfo.couponList.count != 0) {
            JSGDCouponTVC *couponVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GDCouponTVC"];
            couponVC.gdCouponArray = _goodsDetailInfo.couponList;
            [self.navigationController pushViewController:couponVC animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂无红包"];
        }
    }
    
    //促销活动
    if (indexPath.section == 1) {
        
        if (_goodsDetailInfo.activityList.count != 0) {
            [self addGaryViewAndActivityView];
            _activityView.actionArray = _goodsDetailInfo.activityList;
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂无活动"];
            return;
        }
    }
    
    //选择规格
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self showSliderViewController];
    }
}

#pragma mark - Table view datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return M_HEADER_HIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (M_IS_CROWD) {
        return M_HEADER_HIGHT;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (M_IS_CROWD) {
        if (indexPath.row == 0) {
            return WIDTH;
        } else if (indexPath.row == 1){
            return 180;
        } else {
            return 44;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return WIDTH;
            }
            if (indexPath.row == 1) {
                return 137;
            }
        }
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (M_IS_CROWD) {
        return 1;
    } else {
        return _goodsDetailInfo ? 3 : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (M_IS_CROWD) {
        return 3;
    } else {
        if (section == 0) {
            return 5;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (M_IS_CROWD) {
        if (indexPath.row == 0) {
            _crowdImageCell = [tableView dequeueReusableCellWithIdentifier:@"crowdImageCell" forIndexPath:indexPath];
            
            return _crowdImageCell;
        } else if (indexPath.row == 1) {
            _crowdInfoCell = [tableView dequeueReusableCellWithIdentifier:@"crowdInfoCell" forIndexPath:indexPath];
            
            [_crowdInfoCell.shareBtn addTarget:self action:@selector(crowdInfoShareBtnClick) forControlEvents:UIControlEventTouchUpInside];

            return _crowdInfoCell;
        } else {
            _crowdCountcell = [tableView dequeueReusableCellWithIdentifier:@"crowdCountCell" forIndexPath:indexPath];
            [_crowdCountcell.addBtn addTarget:self action:@selector(crowdCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            _crowdCountcell.addBtn.tag = 50;
            [_crowdCountcell.minusBtn addTarget:self action:@selector(crowdCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            _crowdCountcell.minusBtn.tag = 51;
            
            return _crowdCountcell;
        }
    } else {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0: {
                    // 图片cell
                    
                    JSGoodsDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier: @"imageCell" forIndexPath:indexPath];
                    cell.scrollView.imageURLStringsGroup = _photos;
                    cell.scrollView.delegate = self;
                    cell.scrollView.placeholderImage = [UIImage imageNamed:@"noimage.png"];
                    return cell;
                    break;
                }
                case 1: {
                    // 商品信息 cell
                    JSGoodsDetailNameCell *cell = [tableView dequeueReusableCellWithIdentifier: @"nameCell" forIndexPath:indexPath];
                    
                    // 分享按钮
                    [cell.shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.nameLabel.text = _goodsDetailInfo.goods.name;
                    
                    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
                        //登录并认证
                        
                        //折扣
                        cell.discountLabel.text = [NSString stringWithFormat:@"折扣:%.2f",_product.retailPrice-_product.wholesalePrice];
                        //产品批发价
                        cell.wholesaleLabel.text = [NSString stringWithFormat:@"￥%.2f/箱", _product.wholesalePrice];
                        //产品零售价
                        cell.priceLabel.text = [NSString stringWithFormat:@"零售价:￥%.2f/箱", _product.retailPrice];
                        //产品库存
                        cell.stockLabel.text = _product.salesStock;
                        //产品净含量
                        cell.jingHanLiangLab.text = [NSString stringWithFormat:@"%@kg",_product.weight];
                    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
                        //登录未认证

                        //折扣
                        cell.discountLabel.text = @"折扣:认证可见";
                        //批发价
                        cell.wholesaleLabel.text = @"认证可见";
                        //产品净含量
                        cell.jingHanLiangLab.text = [NSString stringWithFormat:@"%@kg",_product.weight];
                        //产品零售价
                        cell.priceLabel.text = [NSString stringWithFormat:@"零售价:￥%.2f/箱", _product.retailPrice];
                        //产品库存
                        cell.stockLabel.text = _product.salesStock;
                    } else {
                        //未登录
                        
                        //折扣
                        cell.discountLabel.text = @"折扣:登录认证可见";
                        //批发价
                        cell.wholesaleLabel.text = @"登录认证可见";
                        //产品净含量
                        cell.jingHanLiangLab.text = [NSString stringWithFormat:@"%@kg",_product.weight];
                        //产品零售价
                        cell.priceLabel.text = [NSString stringWithFormat:@"零售价:￥%.2f/箱", _product.retailPrice];
                        //产品库存
                        cell.stockLabel.text = _product.salesStock;
                    }
                    
                    if ([_activityType isEqualToString:@"0"]) {
                        cell.activityNameLab.text = @"商品团购";
                        //折扣
                        cell.discountLabel.text = [NSString stringWithFormat:@"折扣:%.2f",_goodsDetailInfo.goods.price-_goodsDetailInfo.goods.goodsPrice];
                    } else if ([_activityType isEqualToString:@"1"]) {
                        cell.activityNameLab.text = @"限时抢购";
                        //折扣
                        cell.discountLabel.text = [NSString stringWithFormat:@"折扣:%.2f",_goodsDetailInfo.goods.price-_goodsDetailInfo.goods.goodsPrice];
                    } else if ([_activityType isEqualToString:@"2"]) {
                        cell.activityNameLab.text = @"商品众筹";
                    } else {
                        [cell.activityView removeFromSuperview];
                        [cell.activityNameLab removeFromSuperview];
                    }
                    
                    cell.soldCountLabel.text = [NSString stringWithFormat:@"%ld人付款", (long)_goodsDetailInfo.goods.goodsSales];
                    cell.commentLabel.text = [NSString stringWithFormat:@"%ld人评价", (long)_goodsDetailInfo.goods.commentCount];
                    //起订量
                    cell.minBuyLabel.text = [NSString stringWithFormat:@"%ld%@", (long)_goodsDetailInfo.goods.startNum, _goodsDetailInfo.goods.unit];
                    
                    return cell;
                    
                    break;
                }
                case 2: {
                    //正品保证 cell
                    
                    JSGoodsDetaillDesc2Cell *cell = [tableView dequeueReusableCellWithIdentifier: @"desc2Cell"forIndexPath:indexPath];
                    return cell;
                    break;
                }
                case 3: {
                    //送积分 cell
                    
                    JSGoodsDetaillDesc3Cell *cell = [tableView dequeueReusableCellWithIdentifier: @"desc3Cell"forIndexPath:indexPath];
                    cell.pointLabel.text = [NSString stringWithFormat:@"%ld", (long)_goodsDetailInfo.goods.usingIntegralLimit];
                    return cell;
                    break;
                }
                default: {
                    //红包 cell
                    
                    JSGoodsDetaillDesc4Cell *cell = [tableView dequeueReusableCellWithIdentifier: @"desc4Cell"forIndexPath:indexPath];
                    
                    return cell;
                    break;
                }
            }
        } else if (indexPath.section == 1){
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            cell.textLabel.text = @"促销活动";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            //产品规格 cell
            
            JSGoodsDetaillDesc5Cell *cell = [tableView dequeueReusableCellWithIdentifier: @"desc5Cell"forIndexPath:indexPath]; 
            cell.detailTextLabel.text = _selectedSpecString;
            
            return cell;
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
