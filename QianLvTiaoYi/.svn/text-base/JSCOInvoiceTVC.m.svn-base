//
//  JSCOInvoiceTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/21.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCOInvoiceTVC.h"

@interface JSCOInvoiceTVC ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *leftImgViews;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (nonatomic, assign) int invoiceType;

@end

@implementation JSCOInvoiceTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _invoiceType = 9;
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确定按钮
 */
- (IBAction)confirmBarItemClick:(id)sender
{
    if (_invoiceType == 9) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择发票类型"];
        return;
    } else {
        
        NSString *type = nil;
        NSString *name = nil;
        if (_invoiceType == 1) {
            //个人
            type = @"0";
            name = @"个人";
        } else if (_invoiceType == 2) {
            //公司
            type = @"1";
            if (_companyNameTF.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"您还没有填写公司名称"];
                return;
            } else {
                name = _companyNameTF.text;
            }
        }
        [M_NOTIFICATION postNotificationName:@"setInvoiceMessageNotifi" object:nil userInfo:@{@"invoiceType":type, @"invoiceName":name}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _invoiceType = 1;
    } else {
        _invoiceType = 2;
    }
    
    for (int i = 0; i < _leftImgViews.count; i ++) {
        UIImageView *img = _leftImgViews[i];
        if (indexPath.row == i) {
            img.image = [UIImage imageNamed:@"xuanzhon.png"];
        } else {
            img.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
