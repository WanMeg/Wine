//
//  JSLogisticsInfoTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/28.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSLogisticsInfoTVC.h"
#import "GetLogisticsInfoData.h"
#import "JSLIOrderNoCell.h"
#import "JSLIGoodsCell.h"
#import "JSLIDataCell.h"
@interface JSLogisticsInfoTVC ()


@property (nonatomic, strong) NSMutableArray *postsArray;
@end

@implementation JSLogisticsInfoTVC


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _postsArray = [NSMutableArray array];
    [self getLogisticsInfoRequestData];
}

#pragma mark - Http Request

/**
 *  获取物流信息请求
 */
- (void)getLogisticsInfoRequestData
{
    __weak typeof(self) weakSelf = self;
    [GetLogisticsInfoData postWithUrl:RMRequestStatusOrderLogisticsInfo param:@{@"orderNo": _logisticsOrderNo} modelClass:[WMLogisticsInfo class] responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            weakSelf.postsArray = dataObj;
            NSLog(@"post = %@",weakSelf.postsArray);
        }
        [weakSelf.tableView reloadData];
    }];
}

/**
 *  返回上个界面
 */
- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _postsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WMLogisticsInfo *info = _postsArray[section];
    // cell数量 =  商品数量 + 物流信息数量 + 1(包裹状态)
    return info.orderGoods.count + info.data.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMLogisticsInfo *info = _postsArray[indexPath.section];
    
    if (indexPath.row == 0) {
        return 100.0f;
    } else if (indexPath.row <= info.orderGoods.count) {
        return 120.0f;
    } else {
        WMLogisticsData *data = info.data[indexPath.row - info.orderGoods.count - 1];
        float height = [WMGeneralTool getHeightWithString:data.context withFontSize:13];
        return height+40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMLogisticsInfo *info = _postsArray[indexPath.section];
    
    if (indexPath.row == 0) {
        
        JSLIOrderNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liOrderNoCell" forIndexPath:indexPath];
        cell.orderNoLab.text = info.nu;
        cell.liNameLab.text = info.comName;
        
        switch (info.state) {
            case 0:
                cell.liStatusLab.text = @"在途中";
                break;
            case 1:
                cell.liStatusLab.text = @"已揽收";
                break;
            case 2:
                cell.liStatusLab.text = @"疑难";
                break;
            case 3:
                cell.liStatusLab.text = @"已签收";
                break;
            case 4:
                cell.liStatusLab.text = @"退签";
                break;
            case 5:
                cell.liStatusLab.text = @"同城派送中";
                break;
            case 6:
                cell.liStatusLab.text = @"退回";
                break;
            default:
                cell.liStatusLab.text = @"转单";
                break;
        }
        return cell;
    } else if (indexPath.row <= info.orderGoods.count) {
        
        //商品 cell
        
        JSLIGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liGoodsCell" forIndexPath:indexPath];
        WMLogisticsGoods *goods = info.orderGoods[indexPath.row - 1];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:goods.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        cell.nameLabel.text = goods.goodsName;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", goods.goodsRealityPrice];
        cell.quantityLabel.text = [NSString stringWithFormat:@"x %d", goods.quantity];
        cell.specLabel.text = goods.goodsSpec;
        
        return cell;

    } else {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 物流数据 cell
        WMLogisticsData *data = info.data[indexPath.row - info.orderGoods.count - 1];
        
        JSLIDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liDataCell" forIndexPath:indexPath];
        
        cell.contentLab.text = data.context;
        cell.dateLab.text = data.ftime;
        
        if (indexPath.row == info.orderGoods.count + 1) {
            cell.leftImgView.image = [UIImage imageNamed:@""];
            cell.leftRedPointImg.image = [UIImage imageNamed:@"wuliu2"];
        }
        if (indexPath.row <= info.data.count + info.orderGoods.count  && indexPath.row > info.orderGoods.count + 1) {
            cell.leftImgView.image = [UIImage imageNamed:@"wuliu1"];
            cell.leftRedPointImg.image = [UIImage imageNamed:@""];
        }
        
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
