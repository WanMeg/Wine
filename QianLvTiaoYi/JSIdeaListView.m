//
//  JSIdeaListView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSIdeaListView.h"
#import "JSIdeaListCell.h"
#import "GetIdeaListData.h"

@implementation JSIdeaListView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.ideaListTabView.delegate = self;
    self.ideaListTabView.dataSource = self;
    
    [_ideaListTabView registerNib:[UINib nibWithNibName:@"JSIdeaListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ideaListCell"];
    
    
    __weak typeof(self) weakSelf = self;
    self.ideaListTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initModelsAndPager];
        [weakSelf getIdeaListRequestData];
    }];
    self.ideaListTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
         [weakSelf getIdeaListRequestData];
    }];
    
    [weakSelf initModelsAndPager];
    [weakSelf getIdeaListRequestData];
}


#pragma mark - Request

/**
 *  设置基本参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = @"10";
    self.ideaListArray = [NSMutableArray array];
    [self.ideaListTabView reloadData];
}

- (void)getIdeaListRequestData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *parma = @{@"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage], @"pageNumber": _pageNumber};
    
    [GetIdeaListData postWithUrl:RMRequestStatusIdeaList param:parma modelClass:[WMIdeaList class] responseBlock:^(id dataObj, NSError *error)
     {
         [self.ideaListTabView.mj_header endRefreshing];
         [self.ideaListTabView.mj_footer endRefreshing];
         
         if (dataObj) {
             weakSelf.currentPage ++;
             [weakSelf.ideaListArray addObjectsFromArray:dataObj];
         }
         [weakSelf.ideaListTabView reloadData];
         if (error.code == 200 || error.code == 200) {
             [weakSelf.ideaListTabView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
}


#pragma mark - UITableViewDatasouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _ideaListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMIdeaList *idea = _ideaListArray[indexPath.section];
    
    if (indexPath.row == 0) {
        float height = [WMGeneralTool getHeightWithString:idea.content withFontSize:13];
        return height + 36;
    } else {
        if (idea.replyContent.length > 0) {
            float height = [WMGeneralTool getHeightWithString:idea.replyContent withFontSize:13];
            return height + 36;
        } else {
            return 100;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMIdeaList *idea = _ideaListArray[indexPath.section];
    JSIdeaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaListCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.ideaPeople.text = [NSString stringWithFormat:@"留言类型:%@",idea.title];
        cell.ideaTime.text = [NSString stringWithFormat:@"留言时间:%@",idea.messageDate];
        cell.ideaContent.text = [NSString stringWithFormat:@"留言内容:%@",idea.content];
        [cell.tipsLab removeFromSuperview];
    } else {
        if (idea.replyContent.length > 0) {
            cell.ideaPeople.text = [NSString stringWithFormat:@"回复人:%@",idea.replyUserId];
            cell.ideaTime.text = [NSString stringWithFormat:@"回复时间:%@",idea.replyDate];
            cell.ideaContent.text = [NSString stringWithFormat:@"回复内容:%@",idea.replyContent];
            [cell.tipsLab removeFromSuperview];
        } else {
            cell.ideaPeople.text = @"";
            cell.ideaTime.text = @"";
            cell.ideaContent.text = @"";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}
@end
