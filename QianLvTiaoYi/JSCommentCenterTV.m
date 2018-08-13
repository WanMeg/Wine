//
//  JSCommentCenterTV.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCommentCenterTV.h"
#import "JSCommentCenterTVCell.h"
#import "GetCommentsData.h"
#import "GetBannersData.h"
#import "JSCommentBaskTVC.h"
#import "JSSendCommentVC.h"
#import "GetCommentCenterData.h"

#import "JSCommentDetailTVC.h"

@interface JSCommentCenterTV ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pjTopViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *pjTopLabels;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) WMComments *comment;
@property (nonatomic, strong) NSMutableArray *commentCArray;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int currentPage;

@property (assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray *commentCenterBannerArr;

@property (nonatomic, strong) NSMutableArray *bannerImgArray;

@property (nonatomic, assign) int showCellStatus;
@property (nonatomic, copy) NSString *userName;
@end

@implementation JSCommentCenterTV

static dispatch_once_t onceToken;

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    self.comment = nil;
    [self getCommentsCenterRequest];
    
    
    dispatch_once(&onceToken, ^{
        //注册接收返回评价中心的通知
        [M_NOTIFICATION addObserver:self selector:@selector(updateCommentCenterData:) name:@"backCommentCenterNotifi" object:nil];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    
    _selectIndex = 0;
    UILabel *lab = _pjTopLabels[0];
    lab.textColor = [UIColor redColor];
    
    [self addPjTopViewsTapGestureMethod];//调用views手势方法
    
    self.bannerImgArray = [NSMutableArray array];
    self.commentCenterBannerArr = [NSMutableArray array];
    [self setCommentCenterHeaderViewBannerImage];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initModelsAndPager];
        [self getCommentsCenterRequest];
        [self getCommentsCenterRequestDataWithStatus:@"noComment"];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getCommentsCenterRequest];
        [self getCommentsCenterRequestDataWithStatus:@"noComment"];
    }];
    
    [self initModelsAndPager];
    [self getCommentsCenterRequestDataWithStatus:@"noComment"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification method
/**
 *  返回评价中心通知方法
 *
 *  @NotificationCenter
 */
- (void)updateCommentCenterData:(NSNotification *)notifi
{
    [self initModelsAndPager];
    
    NSDictionary *dict = [notifi userInfo];
    int status = [dict[@"commentStatu"] intValue];
    switch (status) {
        case 1:{
            //商品评价
            _showCellStatus = 1;
            [self getCommentsCenterRequestDataWithStatus:@"noComment"];
        }
            break;
        case 2:{
            //追加晒单
            _showCellStatus = 2;
            [self getCommentsCenterRequestDataWithStatus:@"commentNotImage"];
        }
            break;
        case 3:{
            //晒单完成
            _showCellStatus = 3;
            [self getCommentsCenterRequestDataWithStatus:@"commentAndImage"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

/**
 *  设置banner图
 */
- (void)setCommentCenterHeaderViewBannerImage
{
    CGRect rect = CGRectMake(0,0,WIDTH,122.0f);
    SDCycleScrollView * commentScroll = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:nil placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    __weak typeof(self) weakSelf = self;
    
    [GetBannersData postWithUrl:RMRequestStatusCommentBannerImage param:nil modelClass:[WMBanners class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [weakSelf.commentCenterBannerArr
              addObjectsFromArray:dataObj];
             
             for (WMBanners *banner in _commentCenterBannerArr) {
                 NSString *imgStr = banner.imgUrl;
                 
                 [_bannerImgArray addObject:imgStr];
             }
             commentScroll.imageURLStringsGroup = self.bannerImgArray;
         }
     }];
    
    commentScroll.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    commentScroll.showPageControl = YES;
    commentScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    commentScroll.currentPageDotColor = [UIColor blackColor];
    commentScroll.pageDotColor = [UIColor grayColor];
    
    [_headerView addSubview:commentScroll];
}

/*
 *  初始化模型类和页数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.commentCArray = [NSMutableArray array];
    [self.tableView reloadData];
}

/*
 *  获取评价中心数量的数据
 */
- (void)getCommentsCenterRequest
{
    NSDictionary *param = @{@"sort":@"noComment",@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    __weak typeof(self) weakSelf = self;
    [GetCommentsData postWithUrl:RMRequestStatusCommentsCenter param:param modelClass:[WMComments class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.comment = dataObj;

             UILabel *label1 = _pjTopLabels[0];
             label1.text = [NSString stringWithFormat:@"商品评价 %@",weakSelf.comment.allCount];
             UILabel *label2 = _pjTopLabels[1];
             label2.text = [NSString stringWithFormat:@"追加晒单 %@",weakSelf.comment.notImgCount];
             UILabel *label3 = _pjTopLabels[2];
             label3.text = [NSString stringWithFormat:@"晒单完成 %@",weakSelf.comment.yesImgCount];
             weakSelf.userName = weakSelf.comment.nameUser;
         }
     }];
}

/*
 *  获取评价中心不同状态的数据
 */
- (void)getCommentsCenterRequestDataWithStatus:(NSString *)status
{
    NSDictionary *param = @{@"sort":status,@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;
    
    [GetCommentCenterData postWithUrl:RMRequestStatusCommentsCenter param:param modelClass:[WMCommentData class] responseBlock:^(id dataObj, NSError *error) {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage ++;
             [weakSelf.commentCArray addObjectsFromArray:dataObj];
         }
         
         [weakSelf.tableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}


/*
 *  添加顶部views的点击手势
 */
- (void)addPjTopViewsTapGestureMethod
{
    [_pjTopViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfTopViews:)];
         [obj addGestureRecognizer:tap];
    }];

}

#pragma mark - Actions

/**
 *  views点击手势的方法
 */
- (void)handleTapOfTopViews:(UITapGestureRecognizer *)sender
{
    _selectIndex = sender.view.tag;
    
    for (int i = 0; i < _pjTopLabels.count; i++) {
        UILabel *label = _pjTopLabels[i];
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //当前页数重置为1
    self.currentPage = 1;
    //移除其它状态下数组中的元素
    [self.commentCArray removeAllObjects];
    
    switch (sender.view.tag) {
        case 0: {   //商品评价
            _showCellStatus = 1;
            [self getCommentsCenterRequestDataWithStatus:@"noComment"];
        }
            break;
        case 1: {   //追加晒单
            _showCellStatus = 2;
            [self getCommentsCenterRequestDataWithStatus:@"commentNotImage"];
            
        }
            break;
        default: {   //晒单完成
            _showCellStatus = 3;
            [self getCommentsCenterRequestDataWithStatus:@"commentAndImage"];
        }
            break;
    }
}

- (IBAction)backMemberVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  进入对应界面
 *
 *  传值 comments对象
 */
- (void)commentCBaskBtnClick:(UIButton *)sender
{
    WMCommentData *info = _commentCArray[sender.tag];
    
    if (_selectIndex == 0) {
        
        //去评论界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
        JSSendCommentVC *sendVC = [storyboard instantiateViewControllerWithIdentifier:@"SendCommentVC"];
        
        sendVC.sendOrderNo = info.orderNo;
        sendVC.sendGoodsId = info.goodsId;
        sendVC.sendGoodsImg = info.goodsImg;
        
        [self.navigationController pushViewController:sendVC animated:YES];
        
    } else if (_selectIndex == 1) {
        
        //评价晒单界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
        JSCommentBaskTVC *commentBaskVC = [sb instantiateViewControllerWithIdentifier:@"CommentBaskTVC"];
        //传值给下个界面
        commentBaskVC.comments = info;
        [self.navigationController pushViewController:commentBaskVC animated:YES];
        
    } else {
        
        //评价详情界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
        JSCommentDetailTVC *cdVC = [sb instantiateViewControllerWithIdentifier:@"CommentDetailTVC"];
        //传值给下个界面
        cdVC.commentDetail = info;
        cdVC.userName = _userName;
        [self.navigationController pushViewController:cdVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentCArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     WMCommentsInfo *comments = _commentCArray[indexPath.row];
    
    JSCommentCenterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCenterTVCell" forIndexPath:indexPath];
    
    switch (_showCellStatus) {
        case 1:
            [cell.commentCBaskBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
            [cell.commentCBaskBtn setImage:[UIImage imageNamed:@"pjshaidan-3"] forState:UIControlStateNormal];
            break;
        case 2:
            [cell.commentCBaskBtn setTitle:@"追加晒图" forState:UIControlStateNormal];
            [cell.commentCBaskBtn setImage:[UIImage imageNamed:@"zhuijiast.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [cell.commentCBaskBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            [cell.commentCBaskBtn setImage:[UIImage imageNamed:@"chakanpj.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [cell.commentCBaskBtn addTarget:self action:@selector(commentCBaskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentCBaskBtn.tag = indexPath.row;
    
    [cell.commentCenterHeadImg sd_setImageWithURL:[NSURL URLWithString:comments.goodsImg] placeholderImage:[UIImage imageNamed:@"noimage"]];

    cell.commentCInfoLab.text = comments.goodsSpec;
    cell.commentCTitleLab.text = comments.goodsName;
    
    return cell;
}

#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无信息!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
