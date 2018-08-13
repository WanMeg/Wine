//
//  JSCommentDetailTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/16.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCommentDetailTVC.h"
#import "JSCDFirstCell.h"
#import "JSCDContentCell.h"
#import "JSCDImageCell.h"

@interface JSCommentDetailTVC ()
@property (nonatomic, strong) NSArray *imgArray;
@end

@implementation JSCommentDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = _commentDetail.imgUrl[0];
    _imgArray = [str componentsSeparatedByString:@"png"];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [M_NOTIFICATION postNotificationName:@"backCommentCenterNotifi" object:self userInfo:@{@"commentStatu": @"3"}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : _imgArray.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44.0f;
        } else {
            float height = [WMGeneralTool getHeightWithString:_commentDetail.commentContent withFontSize:13];
            return height + 30.0;
        }
    } else {
        return 280.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JSCDFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDFirstCell" forIndexPath:indexPath];
            
            [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:_commentDetail.headPortrait] placeholderImage:[UIImage imageNamed:@"noimage"]];
            cell.userNameLab.text = _userName;
            cell.buyTimeLab.text = _commentDetail.commentTime;
            
            return cell;
        } else {
            JSCDContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDContentCell" forIndexPath:indexPath];
            
            for (int i = 0; i < _commentDetail.commodityQuality; i ++) {
                UIImageView *image = cell.starImageViews[i];
                image.image = [UIImage imageNamed:@"pjhongxing.png"];
            }
            
            cell.commentLab.text = _commentDetail.commentContent;
            return cell;
        }
    } else {
        
        JSCDImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDImageCell" forIndexPath:indexPath];
        NSString *imgStr = _imgArray[indexPath.row];
        [cell.commentImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@png",imgStr]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        return cell;
    }
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
