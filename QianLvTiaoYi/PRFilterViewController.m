//
//  PRFilterViewController.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterViewController.h"
#import "PRFilterAddressCell.h"
#import "PRFilterListCell.h"
#import "PRFilterExtensionCell.h"
#import "JSContact.h"
#import "FilterModel.h"
#import "PRFilterBottomBar.h"
#import "PRFliterViewNavView.h"

#import "GetFliterInfoData.h"

#define WHITE_WIDTH 50.0f

@interface PRFilterViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray *filterKeywords;
@property (nonatomic, strong) PRFilterBottomBar *bar;
@property (nonatomic, strong) PRFliterViewNavView *fliterNavView;

@property (nonatomic, strong) WMFliterInfo *fliterInfo;
@property (nonatomic, strong) NSMutableArray *customTags;

@property (nonatomic, strong) NSMutableArray *fliterInfoArr;
@property (nonatomic, strong) NSMutableArray *brandsInfoArr;
@property (nonatomic, strong) NSMutableArray *productAttributeValuesInfoArr;

@property (nonatomic, strong) NSMutableDictionary *fliterConditionDict;

@end

@implementation PRFilterViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];

    self.customTags = [NSMutableArray array];
    PRTags *tags1 = [[PRTags alloc] init];
    tags1.text = @"仅看有货";
    [_customTags addObject:tags1];
    PRTags *tags2 = [[PRTags alloc] init];
    tags2.text = @"促销";
    [_customTags addObject:tags2];
    
    _fliterInfoArr = [NSMutableArray array];
    _brandsInfoArr = [NSMutableArray array];
    _productAttributeValuesInfoArr = [NSMutableArray array];
    _fliterConditionDict = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animationViewsIn];
}

#pragma mark - Private Method

/**
 *  先获取到 fliterTag的 值 再调用请求方法
 */
- (void)setFliterTag:(NSString *)fliterTag
{
    _fliterTag = fliterTag;
    
    NSLog(@"ewrwrrrrrrrrrrr = %@",_fliterTag);
    
    [self getFliterInfoRequestData];
}

/**
 *  布局界面
 */
- (void)configUI
{
    
    //TODO:表格
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 64,WIDTH - WHITE_WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //TODO:底部bar
    _bar = [[PRFilterBottomBar alloc] initWithFrame:CGRectMake(WIDTH, HEIGHT - 44, WIDTH - WHITE_WIDTH, 44)];
    [_bar.resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bar.configBtn addTarget:self action:@selector(configBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bar];
    
    
    //TODO:导航bar
    _fliterNavView = [[NSBundle mainBundle] loadNibNamed:@"PRFliterViewNavView" owner:self options:nil].firstObject;
    _fliterNavView.frame = CGRectMake(WIDTH, 0,WIDTH - WHITE_WIDTH , 64);
    [_fliterNavView.cancelButton addTarget:self action:@selector(fliterCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fliterNavView];
    
    
    //TODO:注册单元格
    [_tableView registerClass:[PRFilterAddressCell class] forCellReuseIdentifier:@"addressCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PRFilterListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"listCell"];

    [_tableView registerNib:[UINib nibWithNibName:@"PRFilterExtensionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"extensionCell"];
}

/**
 *  views 进入动画
 */
- (void)animationViewsIn
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.tableView.frame = CGRectMake(WHITE_WIDTH, 64, WIDTH - WHITE_WIDTH, HEIGHT - 64);
        self.bar.frame = CGRectMake(WHITE_WIDTH, HEIGHT - 44, WIDTH - WHITE_WIDTH, 44);
        self.fliterNavView.frame = CGRectMake(WHITE_WIDTH, 0,WIDTH - WHITE_WIDTH , 64);
    } completion:nil];
}

/**
 *  tableView out 动画
 */
- (void)animationViewsOut
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame = CGRectMake(WIDTH, 64, WIDTH - WHITE_WIDTH, HEIGHT - 64);
        self.bar.frame = CGRectMake(WIDTH, HEIGHT - 44, WIDTH - WHITE_WIDTH, 44);
        self.fliterNavView.frame = CGRectMake(WIDTH, 0,WIDTH - WHITE_WIDTH , 64);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - HttpRequest

/**
 *  请求分类筛选信息内容
 */
- (void)getFliterInfoRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetFliterInfoData postWithUrl:RMRequestStatusCategoryFliterGoods param:@{@"tag": _fliterTag} modelClass:[WMFliterInfo class] responseBlock:^(id dataObj, NSError *error)
    {
        if (dataObj) {
            weakSelf.fliterInfo = dataObj;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Actions

/**
 *  触摸方法  退出动画
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animationViewsOut];
}

/**
 *  取消按钮点击事件
 */
- (void)fliterCancelButtonClick
{
    [self animationViewsOut];
}

/**
 *  重置按钮点击事件
 */
- (void)resetBtnClick
{
    for (PRTags *tags in _customTags) {
        tags.isSelected = NO;
    }
    
    for (WMBrands *brand in _fliterInfo.brands) {
        brand.isSelected = NO;
    }
    
    for (WMAttributes *attr in _fliterInfo.attributes)
    {
        for (WMProductAttributeValues *values in attr.productAttributeValues) {
            values.isSelected = NO;
        }
    }
    
    [self.tableView reloadData];
}

/**
 *  确定搜索按钮点击事件
 */
- (void)configBtnClick
{
    for (PRTags *tags in _customTags) {
        if (tags.isSelected) {

            [_fliterInfoArr addObject:tags.text];
        }
    }
    
    for (WMBrands *brands in _fliterInfo.brands) {
        if (brands.isSelected) {
            [_fliterInfoArr addObject:brands.brandName];
        }

    }
    
    for (WMAttributes *attr in _fliterInfo.attributes)
    {
        for (WMProductAttributeValues *values in attr.productAttributeValues) {
            if (values.isSelected) {
                [_fliterInfoArr addObject:values.attributeValue];
            }
        }
    }
    
    //发送确定搜索的通知
    [M_NOTIFICATION postNotificationName:@"ConfigSearchNotifi" object:nil userInfo:@{@"fliterInfo": _fliterInfoArr}];
    
    [PRUitls delay:0.4 finished:^
    {
        [self animationViewsOut];
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:
            return 50;
            break;
        case 2:
          if (_fliterInfo.isExpand) {
                NSUInteger line = _fliterInfo.brands.count % 3 == 0 ? _fliterInfo.brands.count / 3 : _fliterInfo.brands.count / 3 + 1;
                return 30 + line * 40;
            }else {
                return 70;
            }
            break;
        default:
        {
            WMAttributes *attr = _fliterInfo.attributes[indexPath.section - 3];
            if (attr.isExpand) {
                NSUInteger line = attr.productAttributeValues.count % 3 == 0 ? attr.productAttributeValues.count / 3 : attr.productAttributeValues.count / 3 + 1;
                return 30 + line * 40;
            }else {
                return 70;
            }
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 11;
            break;
        case 2:
            return 11;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_fliterInfo.brands.count > 0) {
        return 3 + _fliterInfo.attributes.count;
    }else {
        return 2 + _fliterInfo.attributes.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            //配送地址 section
            
            PRFilterAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
            cell.textLabel.text = @"配送至";
            cell.detailTextLabel.text = @"四川省成都市锦江区";
            return cell;
            break;
        }
        case 1:
        {
            //分类 section
            
            PRFilterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
            //点击事件回调, 更行选中状态
            [cell.collectionView setSelectedBlock:^(NSIndexPath *indexPath) {
                PRTags *tags = weakSelf.customTags[indexPath.item];
                tags.isSelected = !tags.isSelected;
            }];
            
            [cell.collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellStroke sectionCount:2 fetchText:^NSDictionary *(NSInteger idx) {
                return [weakSelf.customTags[idx] mj_keyValues];
            }];
            return cell;
            break;
        }
        case 2:
        {
            //品牌 section
            
            PRFilterExtensionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extensionCell" forIndexPath:indexPath];
            cell.button.tag = indexPath.section -2;
            cell.titleLabel.text = @"品牌";
            
            //点击事件回调, 更行选中状态
            [cell.collectionView setSelectedBlock:^(NSIndexPath *indexPath) {
                WMBrands *brand = weakSelf.fliterInfo.brands[indexPath.item];
                brand.isSelected = !brand.isSelected;
            }];
            
            __weak typeof(self) weakSelf = self;
            [cell setExpandActionBlock:^(BOOL isExpand)
             {
                 weakSelf.fliterInfo.expand = isExpand;
                 [weakSelf.tableView reloadData];
             }];
            
            if (_fliterInfo.isExpand)
            {
                [cell.collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:_fliterInfo.brands.count fetchText:^NSDictionary *(NSInteger idx)
                 {
                     WMBrands *brand = _fliterInfo.brands[idx];
                     return @{@"text": brand.brandName, @"isSelected": @(brand.isSelected)};
                 }];
            }else
            {
                NSInteger count = _fliterInfo.brands.count < 3 ? _fliterInfo.brands.count : 3;
                [cell.collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:count fetchText:^NSDictionary *(NSInteger idx)
                 {
                     WMBrands *brand = _fliterInfo.brands[idx];
                      return @{@"text": brand.brandName, @"isSelected": @(brand.isSelected)};
                 }];
            }
            return cell;
            break;
        }
        default:
        {
            //子属性 section
            
            PRFilterExtensionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extensionCell" forIndexPath:indexPath];
            
            cell.button.tag = indexPath.section -3;
            cell.collectionView.tag = indexPath.section - 3;
            WMAttributes *attr = _fliterInfo.attributes[indexPath.section - 3];
            cell.titleLabel.text = attr.attributeName;
            
            //点击事件回调, 更行选中状态
            [cell.collectionView setSelectedBlock:^(NSIndexPath *indexPath) {
                WMProductAttributeValues *value = attr.productAttributeValues[indexPath.item];
                value.isSelected = !value.isSelected;
            }];
            
            
            
            __weak typeof(self) weakSelf = self;
            [cell setExpandActionBlock:^(BOOL isExpand)
             {
                 attr.expand = isExpand;
                 [weakSelf.tableView reloadData];
             }];
            
            if (attr.isExpand)
            {
                [cell.collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:attr.productAttributeValues.count fetchText:^NSDictionary *(NSInteger idx)
                 {
                     WMProductAttributeValues *value = attr.productAttributeValues[idx];
                     return @{@"text":value.attributeValue, @"isSelected": @(value.isSelected)};
                 }];
            }else
            {
                 NSInteger count = attr.productAttributeValues.count < 3 ? attr.productAttributeValues.count : 3;
                [cell.collectionView updateDatasWithCellStyle:PRFilterCollectionViewCellFill sectionCount:count fetchText:^NSDictionary *(NSInteger idx)
                 {
                     WMProductAttributeValues *value = attr.productAttributeValues[idx];
                     return @{@"text":value.attributeValue, @"isSelected": @(value.isSelected)};
                 }];
            }
            
            return cell;
            break;
        }
    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 11; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 44, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 44, 0);
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
