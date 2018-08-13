//
//  JSCmGoodsActionView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/2.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCmGoodsActionView.h"
#import "JSGDActivityCell.h"
#import "CommitOrder.h"
@implementation JSCmGoodsActionView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.goodsActionTabView.delegate = self;
    self.goodsActionTabView.dataSource = self;
    self.goodsActionTabView.rowHeight = 60.0f;
    
    [self.goodsActionTabView registerNib:[UINib nibWithNibName:@"JSGDActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Privilege *pri  = _actionArray[indexPath.row];

    [M_NOTIFICATION postNotificationName:@"choisePrivilegeNotifi" object:nil userInfo:@{@"privilegeId":pri.hdId,@"privilegeType":pri.hdType,@"privilegeName":pri.privilegeName,@"privilegeIndex":[NSString stringWithFormat:@"%ld",(long)_index]}];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSGDActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    Privilege *pri  = _actionArray[indexPath.row];
    
    if ([pri.hdType isEqualToString:@"0"]) {
        cell.titleLab.text = @"平台活动";
    } else {
        cell.titleLab.text = @"促销活动折扣";
    }
    cell.contentLab.text = pri.privilegeName;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

@end
