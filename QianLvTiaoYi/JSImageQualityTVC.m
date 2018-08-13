//
//  JSImageQualityTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/30.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSImageQualityTVC.h"
#import "JDIQualityCell.h"
@interface JSImageQualityTVC ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isClick;
@end

@implementation JSImageQualityTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //本地取出 点击的行数 设置cell右侧的图片
    _index = [M_USERDEFAULTS integerForKey:@"ImageQualityIndex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isClick = NO;
}


- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isClick = YES;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    JDIQualityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.rightImg.image = [UIImage imageNamed:@"red_right.png"];
    
    //把点击的行数保存到本地
    [M_USERDEFAULTS setInteger:indexPath.row forKey:@"ImageQualityIndex"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDIQualityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.rightImg.image = NULL;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDIQualityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IQualityCell" forIndexPath:indexPath];
    NSArray *array = [NSArray arrayWithObjects:@"智能模式",@"高质量(适合WIFI环境)",@"普通(适合3G或者2G环境)", nil];
    
    cell.titleLab.text = array[indexPath.row];
    
    if (_index == NO && _isClick == NO) {
        if (indexPath.row == 0) {
            cell.rightImg.image = [UIImage imageNamed:@"red_right.png"];
        }
    } else {
        cell.rightImg.image = NULL;
    }
    
    if (indexPath.row == _index && _isClick == NO) {
        cell.rightImg.image = [UIImage imageNamed:@"red_right.png"];
    } else {
        cell.rightImg.image = NULL;
    }
    return cell;
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
