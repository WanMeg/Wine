//
//  JSCategoryVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSCategoryVC.h"
#import "PRSegmentControl.h"
#import "JSCategoryLeftCell.h"
#import "JSCollectionHeaderView.h"
#import "JSContact.h"
#import "JSCategoryCV.h"
#import "GetCategoryData.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UINavigationController+CustomStyle.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "JSCAGoodsListVC.h"
#import "JSSearchButtonBar.h"

#import "JSSystemMessageTVC.h"
#import "HomePageVC.h"
@interface JSCategoryVC ()<UICollectionViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *leftTV;
@property (weak, nonatomic) IBOutlet JSCategoryCV *collectionView;
@property (nonatomic, strong) NSMutableArray *categoryList;   /**<分类模型数组*/
//@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

//@property (nonatomic, strong) UIView *indicator;                        /**<左侧标记View*/
@property (nonatomic, assign) NSUInteger selectedIndex;           /**<当前选中的cell index*/

@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation JSCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
   
    _leftTV.delegate = self;
    _leftTV.dataSource = self;
    _leftTV.tableFooterView = [UIView new];
    _collectionView.delegate = self;
    
    
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
    [self setupSearchNavigationBar];
    [self getCategoryList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    //设置监听SearchVC回调信息
    [M_NOTIFICATION addObserver:self selector:@selector(handleSearchAction:) name:@"SearchKeyWords" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing: YES];
    [self.navigationController.navigationBar setHidden:NO];
    //视图将要消失移除监听
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

#pragma mark - private functions

/**
 *  通过NSNotificationCenter 监听 搜索关键字
 *
 *  @param sender SearchVC传递的搜索关键字
 */
-(void)handleSearchAction:(NSNotification*)sender
{
    JSCAGoodsListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CAGoodsListVC"];
    vc.tag = sender.userInfo[@"keywords"];
    [self.navigationController pushViewController:vc  animated:YES];
}

/**
 *  设置顶部搜索框
 */
- (void)setupSearchNavigationBar
{
    JSSearchButtonBar *searchBar = [[NSBundle mainBundle] loadNibNamed:@"JSSearchButtonBar" owner:self options:nil].firstObject;
   // searchBar.frame = CGRectMake(0, 0, WIDTH, 64);
    
    [searchBar setButtonActionsBlock:^(NSInteger idx){
        switch (idx) {
            case 0: {   //返回主页
            
                self.tabBarController.selectedIndex = 0;
            }
                break;
            case 1: {   //搜索界面
                
                UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
                [self presentViewController:VC animated:NO completion:nil];
            }
                break;
            case 2: {   //消息界面
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
                JSSystemMessageTVC *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"SystemMessageTVC"];
                [self.navigationController pushViewController:messageVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    [self.view addSubview:searchBar];
}

/**
 *  请求分类信息列表
 */
- (void)getCategoryList {
    [SVProgressHUD showWithStatus:@"请稍后..."];
    __weak typeof(self) weakSelf = self;
    _isRequesting = YES;
    [GetCategoryData postWithUrl:RMRequestStatusCategory param:nil modelClass:[CategoryInfo class] responseBlock:^(id dataObj, NSError *error) {
        weakSelf.isRequesting = NO;
        if (dataObj) {
            [SVProgressHUD dismiss];
            weakSelf.categoryList = dataObj;
//            [self createIndicator];
            [weakSelf.leftTV reloadData];
            //请求完成 设置默认点击的行数
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
            [weakSelf tableView:_leftTV setCurrentSelectedCellWithIndexPath:indexPath];
        }else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
        [weakSelf.collectionView reloadData];
    }];
}

/**
 *  创建左侧标记View
 */
/**
- (void)createIndicator {
    if (self.indicator == nil) {
        self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 38)];
    }
    _indicator.backgroundColor = QLTY_MAIN_COLOR;
    [_leftTV addSubview:_indicator];
    _selectedIndex = 0;
}
 */

/**
 *  更新左侧标记位置
 *
 *  @param frame 目标Cell的frame
 */
/**
- (void)updateIndicatorFrame:(CGRect)frame {
    _indicator.frame = CGRectMake(frame.origin.x, frame.origin.y + 6, 4, CGRectGetHeight(frame)-12);
}
 */

/**
 *  设置点中的Cell
 *
 *  @param tableView 左侧TableView
 *  @param indexPath Cell的indexPath
 */
- (void)tableView:(UITableView *)tableView setCurrentSelectedCellWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    JSCategoryLeftCell *cell = [_leftTV cellForRowAtIndexPath:indexPath];
//    [self updateIndicatorFrame:cell.frame];
    
    CategoryInfo * info = _categoryList[indexPath.row];
    
    _collectionView.categoryList = info.childrenCategorys;
    _collectionView.categoryBanner = info.advert.imgUrl;
    
    [_collectionView reloadData];
    
    info.picked = YES;
    cell.titleLabel.textColor = QLTY_MAIN_COLOR;
   }

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [self tableView:tableView setCurrentSelectedCellWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //还原上一次点击的cell 字体颜色, 更新模型picked状态
    JSCategoryLeftCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor darkGrayColor];
    
    CategoryInfo * info = _categoryList[indexPath.row];
    info.picked = NO;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取点击的 Item的 商品模型 跳转到 商品列表 并查询
    CategoryInfo *info = _categoryList[_selectedIndex];
    CategoryInfo *info1 = info.childrenCategorys[indexPath.section];
    CategoryInfo *info2 = info1.childrenCategorys[indexPath.item];
    
    JSCAGoodsListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CAGoodsListVC"];
    
    vc.tag = info2.categoryName;

    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度：减去间隔 除以4个Item，高度：缩放比例 减去底部view高度 减去边距间隔 除以3个Item
    CGFloat width = (WIDTH - CGRectGetWidth(_leftTV.frame) - 30) / 3;
    return CGSizeMake(width, width+20);
}

#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_categoryList) {
        return 1;
    }else {
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    CategoryInfo *info = _categoryList[indexPath.row];
    cell.titleLabel.text = info.categoryName;
    if (info.picked) {
        cell.titleLabel.textColor = QLTY_MAIN_COLOR;
    }else {
        cell.titleLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}

#pragma mark - DZNEmptyDataSource

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self getCategoryList];
}


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (_categoryList || _isRequesting) {
        return NO;
    }else {
        return YES;
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"网络请求失败";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请检查您的网络";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0);
    
    NSString *imgName = @"button_background_icloud_normal";
    if (state == UIControlStateHighlighted) imgName =@"button_background_icloud_highlight";
    
    return [[[UIImage imageNamed:imgName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIColor *textColor = [UIColor lightGrayColor];
    if (state == UIControlStateHighlighted) textColor = [UIColor groupTableViewBackgroundColor];    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: textColor};
    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:attributes];
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
