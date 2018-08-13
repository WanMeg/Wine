//
//  JSGDActivityView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/1.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGDActivityView.h"
#import "JSGDActivityCell.h"
#import "GoodsDetail.h"

@implementation JSGDActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gdActionTabView.delegate = self;
    self.gdActionTabView.dataSource = self;
    self.gdActionTabView.rowHeight = 60.0f;

    [self.gdActionTabView registerNib:[UINib nibWithNibName:@"JSGDActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSGDActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    GDActivityList *act  = _actionArray[indexPath.row];
    
    cell.contentLab.text = act.des;
    cell.titleLab.text = act.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

@end
