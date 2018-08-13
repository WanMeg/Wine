//
//  JSIntegralVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSIntegralVC.h"

#import "JSIntegralTabVCell.h"
#import "JSIntegralNoImageCell.h"
#import "GetPointsData.h"
#import "JSContact.h"

@interface JSIntegralVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (weak, nonatomic) IBOutlet UITableView *integralTableView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *integralTopViews;
@property (weak, nonatomic) IBOutlet UILabel *totalPointNumLab;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *integralTopLabs;

//@property (nonatomic, strong) NSMutableArray *pointsArray;

@property (nonatomic, assign) int pageNumber;/**<每页返回数量*/
@property (nonatomic, assign) int currentPage;/**<当前页码*/
@property (assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) WMPoints *pointsObj;

@end

@implementation JSIntegralVC

#pragma mark - L F

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *lab = _integralTopLabs[0];
    lab.textColor = [UIColor redColor];
    
    _integralTableView.delegate = self;
    _integralTableView.dataSource = self;
    _integralTableView.emptyDataSetSource = self;
    _integralTableView.emptyDataSetDelegate = self;
    
    [self addIntegralTopViewsTapGesture];

    [self initModelsAndPager];
    
    self.integralTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initModelsAndPager];
        [self getFootmarkRequestListWithChangeType:@""];
    }];
    
    self.integralTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getFootmarkRequestListWithChangeType:@""];
    }];
    [self initModelsAndPager];
    [self getFootmarkRequestListWithChangeType:@""];
}

#pragma mark - Private Methods

/**
 *  上面排序view添加点击手势
 */
- (void)addIntegralTopViewsTapGesture
{
    
    [_integralTopViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         
         _selectIndex = obj.tag;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfIntegralTopViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.pointsObj = nil;
    [self.integralTableView reloadData];
}

/**
 *  获取积分的请求数据
 */
- (void)getFootmarkRequestListWithChangeType:(NSString *)type
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber],@"changeType":type?type:@""};
    
    __weak typeof(self) weakSelf = self;
    
    [GetPointsData postWithUrl:RMRequestStatusMemberPoints param:param modelClass:[WMPoints class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.integralTableView.mj_header endRefreshing];
         [self.integralTableView.mj_footer endRefreshing];

         if (dataObj) {
             weakSelf.currentPage++;
             weakSelf.pointsObj = dataObj;
         }
         _totalPointNumLab.text = [NSString stringWithFormat:@"%d",_pointsObj.totalPoints];
         [weakSelf.integralTableView reloadData];
         
         if (error.code == 200 || error.code == 200) {
             [weakSelf.integralTableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}

/**
 *  请求删除积分
 */
- (void)requestRemoveGoodsFormCollectListWithPointID:(int)pointsId finish:(void(^)(BOOL success))finish
{
    [XLDataService postWithUrl:RMRequestStatusMemberDeletePoints param:@{@"mallPointsdetailId": [NSString stringWithFormat:@"%d",pointsId]} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (100 == error.code) {
             finish(YES);
         } else {
             finish(NO);
         }
     }];
}

#pragma mark - Actions

- (IBAction)backMemberVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 点击手势方法
 */
- (void)handleTapOfIntegralTopViews:(UITapGestureRecognizer *)sender
{
    
    for (int i = 0; i < _integralTopLabs.count; i++) {
        UILabel *label = _integralTopLabs[i];
        
        if (i == sender.view.tag) {
            label.textColor = [UIColor redColor];
            
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //当前页数重置为1
    self.currentPage = 1;
    self.pointsObj = nil;
    //移除其它状态下数组中的元素
    [self.pointsObj.points removeAllObjects];
    
    switch (sender.view.tag) {
        case 0: {
            //全部
            [self getFootmarkRequestListWithChangeType:@""];
        }
            break;
        case 1: {
            //收入
            [self getFootmarkRequestListWithChangeType:@"0"];
        }
            break;
        default: {
            //支出
            [self getFootmarkRequestListWithChangeType:@"1"];
        }
            break;
    }
}

#pragma mark - tableViewDelegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pointsObj.points.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPointsInfo *points = _pointsObj.points[indexPath.row];
    return [points.pointsType intValue] == 0 ? 114.0f : 59.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMPointsInfo *points = _pointsObj.points[indexPath.row];
    
    if ([points.pointsType intValue] == 0) {
        JSIntegralTabVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralTabVCell" forIndexPath:indexPath];
        [cell.IntegralHeadImg sd_setImageWithURL:[NSURL URLWithString:points.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
        cell.IntegralNameLab.text = points.goodsName?points.goodsName:@"";
        cell.IntegralTimeLab.text = points.changeTime?points.changeTime:@"";
//        cell.IntegralStyleLab.text = points.changeCauseValue?points.changeCauseValue:@"";
        
        switch (points.changeCause) {
            case 0:{
                cell.IntegralStyleLab.text = @"购物返积分";
            }
                break;
            case 1:{
                cell.IntegralStyleLab.text = @"注册赠送";
            }
                break;
            case 2:{
                cell.IntegralStyleLab.text = @"关注微信赠送";
            }
                break;
            case 3:{
                cell.IntegralStyleLab.text = @"活动赠送";
            }
                break;
            case 5:{
                cell.IntegralStyleLab.text = @"签到赠送";
            }
                break;
            case 6:{
                cell.IntegralStyleLab.text = @"购物抵押现金";
            }
                break;
            default:
                break;
        }
        if ([points.changeType intValue] == 0) {
            cell.IntegralNumberLab.text = [NSString stringWithFormat:@"+%@",points.changePoints?points.changePoints:@""];
        } else {
            cell.IntegralNumberLab.text = [NSString stringWithFormat:@"-%@",points.changePoints?points.changePoints:@""];
        }
        
        return cell;
    } else {
        JSIntegralNoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralNoImageCell" forIndexPath:indexPath];
//        cell.leftTypeLab.text = points.changeCauseValue?points.changeCauseValue:@"";
        switch (points.changeCause) {
            case 0:{
                cell.leftTypeLab.text = @"购物返积分";
            }
                break;
            case 1:{
                cell.leftTypeLab.text = @"注册赠送";
            }
                break;
            case 2:{
                cell.leftTypeLab.text = @"关注微信赠送";
            }
                break;
            case 3:{
                cell.leftTypeLab.text = @"活动赠送";
            }
                break;
            case 5:{
                cell.leftTypeLab.text = @"签到赠送";
            }
                break;
            case 6:{
                cell.leftTypeLab.text = @"购物抵押现金";
            }
                break;
            default:
                break;
        }
        cell.rightTimeLab.text = points.changeTime?points.changeTime:@"";
        if ([points.changeType intValue] == 0) {
            cell.integralNumLab.text = [NSString stringWithFormat:@"+%@",points.changePoints?points.changePoints:@""];
        } else {
            cell.integralNumLab.text = [NSString stringWithFormat:@"-%@",points.changePoints?points.changePoints:@""];
        }
        
        return cell;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        WMPointsInfo *points = _pointsObj.points[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        
        [self requestRemoveGoodsFormCollectListWithPointID:points.mallPointsdetailId finish:^(BOOL success) {
             if (success) {
                 [weakSelf.pointsObj.points removeObjectAtIndex:indexPath.row];
                 
                 [weakSelf.integralTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 
                 [PRUitls delay:0.3 finished:^ {
                      [weakSelf.integralTableView reloadData];
                  }];
             } else {
                 [SVProgressHUD showErrorWithStatus:@"删除失败！"];
             }
         }];
    }
}

#pragma mark - DZNEmptyDataSource

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
    NSString *text = @"暂无积分相关信息!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
