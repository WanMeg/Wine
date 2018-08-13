//
//  JSSearchVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/13.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSSearchVC.h"
#import "JSContact.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "DXPopover.h"
#import "GetHotSearch.h"
#import "JSTagViewCell.h"
#import "JSSearchNavigationBar.h"

@interface JSSearchVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DWTagListDelegate>
@property (weak, nonatomic) IBOutlet UIView *navigationBackView;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *keywords;
//@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *lineHeight;
@property (strong, nonatomic) JSSearchNavigationBar *snBar;
@property (strong, nonatomic) DXPopover *pop;
@property (strong, nonatomic) NSMutableArray *hotSearchs;
@end

@implementation JSSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setupSearchNavigationBar];
    [self requestHotSearch];
    
    //添加点击tableView 收键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
    
    //获取历史搜索记录
    _keywords = [JSSearchNavigationBar getHistorySearchKeyword];
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [_snBar.searchTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Request

/**
 *  请求热搜的数据
 */
- (void)requestHotSearch
{
    __weak typeof(self) weakSelf = self;
    [GetHotSearch getWithUrl:RMRequestStatusGetHotSearch param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        NSArray *hotkeys = dataObj;
        weakSelf.hotSearchs = [NSMutableArray array];
        for (HotSearchs *words in hotkeys) {
            [weakSelf.hotSearchs addObject:words.name];
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Private functions

- (void)commentTableViewTouchInSide
{
    [self.view endEditing:YES];
}

-(void)startSearchKeywords:(NSString *)keywords
{
    [self dismissViewControllerAnimated:NO completion:^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchKeyWords" object:self userInfo:@{@"keywords": keywords}];
    }];
}

/**
 *  设置搜索导航条
 */
- (void)setupSearchNavigationBar
{
    _snBar = [[NSBundle mainBundle] loadNibNamed:@"JSSearchNavigationBar" owner:self options:nil].firstObject;
    [_navigationBackView addSubview:_snBar];
    
    __weak typeof(self) weakSelf = self;
    [_snBar setButtonActionBlock:^(NSInteger idx){
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
    //开始搜索关键字
    [_snBar setStartSearchBlock:^(NSString *text)
    {
        //判断输入是否为空格，空格的话就默认搜索全部
        if ([WMGeneralTool isEmpty:text]) {
            text = @"";
        }
        [weakSelf startSearchKeywords:text];
    }];
}

#pragma mark - Actions

/**
 *  清除历史记录
 *
 *  @param sender UIButton
 */
- (IBAction)cleanHistory:(id)sender
{
     [JSSearchNavigationBar cleanSearchHistory];
    _keywords = nil;
    [_tableView reloadData];
}

#pragma mark - Searchbar delegate
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    _pop = [[DXPopover alloc] initWithFrame:_tableView.bounds];
//    UITableView *tv = [[UITableView alloc] initWithFrame:_tableView.bounds style:UITableViewStylePlain];
//    [_pop showAtPoint:CGPointMake(WIDTH/2, 0) popoverPostion:DXPopoverPositionDown withContentView:tv inView:_tableView];
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [_pop dismiss];
//}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //计算文字的高度，View在这里并没有实际用处
    DWTagList *tagView = [[DWTagList alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 30, 44)];
    tagView.verticalPadding = 6;
    tagView.labelMargin = 8;
    tagView.font = [UIFont systemFontOfSize:12];
    switch (indexPath.row) {
        case 1:
            if (_keywords && _keywords.count > 0) {
                [tagView setTags:_keywords];
                return [tagView fittedSize].height;
            }
            return 44.0f;
            break;
        case 3:
            if (_hotSearchs && _hotSearchs.count > 0) {
                [tagView setTags:_hotSearchs];
                return [tagView fittedSize].height;
            }
            return 44.0f;
            break;
        default:
            return 36.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1: {
            JSTagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
            cell.tagView.tagDelegate = self;
            [cell.tagView setTags:_keywords];
            _keywords && _keywords.count > 0?[cell.warnLabel setHidden: YES]:[cell.warnLabel setHidden:NO];
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell2" forIndexPath:indexPath];
            return cell;
        }
        default: {
            JSTagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
            cell.tagView.tagDelegate = self;
            [cell.warnLabel setHidden:YES];
            [cell.tagView setTags:_hotSearchs];
            return cell;
        }
            break;
    }
}

#pragma mark - DWTaglist

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    [self startSearchKeywords:tagName];
}

@end
