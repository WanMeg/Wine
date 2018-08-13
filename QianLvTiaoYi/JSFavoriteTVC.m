//
//  JSFavoriteTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSFavoriteTVC.h"
#import "Goods.h"
#import "JSFavoriteCell.h"
#import "JSContact.h"
#import "GetFavoriteData.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "JSGoodsDetailVC.h"

@interface JSFavoriteTVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SWTableViewCellDelegate>

@property(nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, copy) NSString *pageNumber;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation JSFavoriteTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //去除多余的分割线
    self.tableView.tableFooterView = [UIView new];
    
    
//    _goodsList = [NSMutableArray arrayWithArray:[Goods creatTempGoodsListWithCount:10]];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initModelsAndPager];
        [weakSelf requestFavoriteList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestFavoriteList];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initModelsAndPager {
    self.currentPage = 1;
    self.pageNumber = @"10";
    self.goodsList = [NSMutableArray array];
    [self.tableView reloadData];
}
//- (IBAction)dislikeGoods:(UIButton *)sender {
////    [_goodsList removeObjectAtIndex:sender.tag];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
////    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////    [self.tableView reloadData];
//    [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
//    [self.tableView.indexPathsForVisibleRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%ld", (long)obj.row);
//    }];
//}


- (void)requestFavoriteList
{
     __weak typeof(self) weakSelf = self;
    
    NSDictionary *parma = @{@"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage], @"pageNumber": _pageNumber};
    
    [GetFavoriteData postWithUrl:RMRequestStatusCollectList param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
         
        if (dataObj)
        {
            weakSelf.currentPage++;
            [weakSelf.goodsList addObjectsFromArray:dataObj];
        }
         
        [weakSelf.tableView reloadData];
         
        if (error.code == 200 || error.code == 200)
        {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 *  请求从收藏夹移除商品
 *
 *  @param goodsID 商品ID
 */
- (void)requestRemoveGoodsFormCollectListWithGoodsID:(NSString *)goodsID finish:(void(^)(BOOL success))finish
{
//    __weak typeof(self) weakSelf = self;
    [XLDataService postWithUrl:RMRequestStatusRemoveCollect param:@{@"goodsId": goodsID} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
        if (100 == error.code)
        {
            finish(YES);
        }else
        {
            finish(NO);
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goods = _goodsList[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = goods.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    cell.delegate = self;
    Goods *goods = _goodsList[indexPath.row];
    cell.goodsName.text = goods.name;
    if ([goods.maxPrice isEqualToString:goods.minPrice])
    {
      cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@", goods.minPrice];
    }else
    {
        cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@ ~ ￥%@", goods.minPrice, goods.maxPrice];
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
//    cell.likeButton.tag = indexPath.row;
    cell.tag = indexPath.row;

    return cell;
}

#pragma  SWTable view Cell delegate 
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        Goods *goods = _goodsList[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [self requestRemoveGoodsFormCollectListWithGoodsID:goods.goodsId finish:^(BOOL success) {
            if (success) {
                [weakSelf.goodsList removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [PRUitls delay:0.3 finished:^{
                    [weakSelf.tableView reloadData];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"取消收藏失败！"];
            }
        }];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [_goodsList removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [PRUitls delay:0.3 finished:^{
//            [tableView reloadData];
//        }];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

#pragma mark - DZNEmptyDataSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"placeholder_instagram"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"收藏夹是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/**
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有添加商品\n立即去选购";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
 */

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor groupTableViewBackgroundColor];
}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//
//    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
//}
//
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"button_image"];
//}



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
