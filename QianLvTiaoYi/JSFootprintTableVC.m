//
//  JSFootprintTableVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFootprintTableVC.h"

#import "JSFootprintTVCell.h"
#import "JSContact.h"
#import "GetFootmarkData.h"

#import "JSGoodsDetailVC.h"

@interface JSFootprintTableVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *footmarkArray;
@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/


@end

@implementation JSFootprintTableVC


#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSFootprintTVCell" bundle:nil] forCellReuseIdentifier:@"FootprintCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initModelsAndPager];
        [self getFootmarkRequestList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getFootmarkRequestList];
    }];
    
    [self initModelsAndPager];
    [self getFootmarkRequestList];
}

#pragma mark - Private Methods

- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.footmarkArray = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求浏览记录的数据
 */
- (void)getFootmarkRequestList
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
    __weak typeof(self) weakSelf = self;

    [GetFootmarkData postWithUrl:RMRequestStatusFootmark param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (dataObj) {
            weakSelf.currentPage++;
            
            [weakSelf.footmarkArray addObjectsFromArray:dataObj];
        }
        
        [weakSelf.tableView reloadData];
        
        if (error.code == 200 || error.code == 200) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 *  请求从浏览记录移除单个记录
 *
 *  @param mallFootmarkId 浏览ID
 */
- (void)requestRemoveFootmarkListWithMallFootmarkId:(NSString *)mallFootmarkId finish:(void(^)(BOOL success))finish
{

    [XLDataService getWithUrl:RMRequestStatusRemoveOneFootmark param:@{@"mallFootmarkId": mallFootmarkId} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             finish(YES);
         } else {
             finish(NO);
         }
     }];
}

/**
 *  请求清空浏览记录
 */
- (void)getClearAllFootmarkRequest
{
    [XLDataService postWithUrl:RMRequestStatusDeleteFootmark param:nil modelClass: nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"清空浏览记录成功。"];
            
            [_footmarkArray removeAllObjects];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:@"清空失败，请检查网络是否正常！"];
        }
    }];
}

#pragma mark - Clicks Actions

- (IBAction)backMemberCenter:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  清空浏览记录按钮
 */
- (IBAction)emptyRecordAction:(UIBarButtonItem *)sender
{
    if (_footmarkArray.count == 0) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有浏览记录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
    } else {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"确定要清空所有浏览记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    }
}


/**
 *  加入购物车按钮点击事件
 */
- (void)footPrintAddShopCartBtnClick:(UIButton *)sender
{
    WMFootmarkModel *footmarkObj = _footmarkArray[sender.tag/1000];
    WMFootmarInfo *foot = footmarkObj.footmarInfo[sender.tag%1000];
    [WMGeneralTool addShopCarBtnClickwith:foot.goodsId];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //清空所有记录
        [self getClearAllFootmarkRequest];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到商品详情界面
    
    WMFootmarkModel *model = _footmarkArray[indexPath.section];
    WMFootmarInfo *info = model.footmarInfo[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = info.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _footmarkArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WMFootmarkModel *footmark = _footmarkArray[section];
    return footmark.footmarInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSFootprintTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FootprintCell" forIndexPath:indexPath];
    WMFootmarkModel *footmarkObj = _footmarkArray[indexPath.section];
    WMFootmarInfo *foot = footmarkObj.footmarInfo[indexPath.row];
    //图片
    [cell.footprintBigImage sd_setImageWithURL:[NSURL URLWithString:foot.goodsImg?foot.goodsImg:@""] placeholderImage:[UIImage imageNamed:@"noimage"]];
    //名称
    cell.footprintNameLab.text = foot.goodsName?foot.goodsName:@"";
    //标题
    cell.footprintSubTitleLab.text = foot.goodsTitle?foot.goodsTitle:@"";
    
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        //批发价格
        cell.footprintPiFaLab.text = [NSString stringWithFormat:@"批:¥%.2f/%@",foot.wholesalePrice, foot.unit?foot.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.footprintPiFaLab.text = @"认证可见";
    } else {
        cell.footprintPiFaLab.text = @"登录认证可见";
    }
    //零售价格
    cell.footprintRetailLab.text = [NSString stringWithFormat:@"零:¥%.2f/%@",foot.retailPrice,foot.unit?foot.unit:@""];
    //销量
    cell.footprintSalesLab.text = [NSString stringWithFormat:@"销量:%d%@",foot.goodsSales,foot.unit?foot.unit:@""];
    
    [cell.addShopCartBtn addTarget:self action:@selector(footPrintAddShopCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCartBtn.tag = indexPath.section * 1000 + indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 200, 44)];
    WMFootmarkModel *footmarkObj = [_footmarkArray objectAtIndex:section];
    timeLab.text = footmarkObj.browseTime;
    
    timeLab.font = [UIFont systemFontOfSize:15];
    timeLab.textColor = [UIColor blackColor];
    
    [headerView addSubview:timeLab];
    
    return headerView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置编辑风格为删除风格
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        WMFootmarkModel *model = _footmarkArray[indexPath.section];
        WMFootmarInfo *foot = model.footmarInfo[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        
        [self requestRemoveFootmarkListWithMallFootmarkId:[NSString stringWithFormat:@"%d",foot.mallFootmarkId] finish:^(BOOL success)
         {
             if (success) {
                 [model.footmarInfo removeObjectAtIndex:indexPath.row];
                 
                 if (model.footmarInfo.count == 0) {
                     [self.tableView.mj_header beginRefreshing];
                 } else {
                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 }
                 [weakSelf.tableView reloadData];
             } else {
                 [SVProgressHUD showErrorWithStatus:@"删除记录失败！"];
             }
         }];
    }
}


#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无浏览记录。";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
