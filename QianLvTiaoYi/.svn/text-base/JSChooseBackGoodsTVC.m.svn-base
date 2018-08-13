//
//  JSChooseBackGoodsTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/8.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSChooseBackGoodsTVC.h"
#import "JSCBGoodsCell.h"
#import "JSBackOrderTVC.h"

@interface JSChooseBackGoodsTVC ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *oederTimeLab;

@end

@implementation JSChooseBackGoodsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderNoLab.text = [NSString stringWithFormat:@"订单号: %@",_mOrderNo];
    _oederTimeLab.text = [NSString stringWithFormat:@"下单时间: %@",_mOrderTime];
}


- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMOrderGoods *orderGoods = _backGoodsArray[indexPath.row];
    
    JSBackOrderTVC *boVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BackOrderTVC"];
    boVC.backOrderGoods = orderGoods;
    boVC.backOrderNo = _mOrderNo;
    [self.navigationController pushViewController:boVC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _backGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCBGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBGoodsCell" forIndexPath:indexPath];
    
    WMOrderGoods *orderGoods = _backGoodsArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:orderGoods.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    cell.nameLabel.text = orderGoods.goodsName;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", orderGoods.goodsRealityPrice];
    cell.quantityLabel.text = [NSString stringWithFormat:@"x %d", orderGoods.quantity];
    cell.specLabel.text = orderGoods.goodsSpec;
    
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
