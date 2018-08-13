//
//  JSFetchMoneyTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/15.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFetchMoneyTVC.h"

@interface JSFetchMoneyTVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *fmStyleViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *circleImgViews;
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *fmMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, assign) int selectMode;

@end

@implementation JSFetchMoneyTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBasicParam];
}

#pragma mark - Private Method
/**
 *  设置基本参数
 */
- (void)setBasicParam
{
    _fmMoneyTF.placeholder = [NSString stringWithFormat:@"本次最多可转出%@元",_totalMoney];
    
    // 圆圈图片添加点击事件
    [_circleImgViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleImgViewsTapClick:)];
         [obj addGestureRecognizer:tap];
     }];
    
}

/**
 *  提现申请的请求
 */
- (void)fetchMoneyApplyforRequest
{
    NSDictionary *param = @{@"payPassword": _passwordTF.text ,
                            @"czTxMode": [NSString stringWithFormat:@"%d",_selectMode] ,
                            @"price": _fmMoneyTF.text ,
                            @"operateType": @"1" ,
                            @"memberRemark": [NSString stringWithFormat:@"%@,%@",_nameTF.text,_accountNumberTF.text]};
    
    [XLDataService getWithUrl:RMRequestStatusWithdrawals param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             [PRUitls delay:0.3 finished:^{
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


#pragma mark - Actions

/**
 *  圆圈图片的点击手势
 */
- (void)circleImgViewsTapClick:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < _circleImgViews.count; i++)
    {
        UIImageView *img = _circleImgViews[i];
        if (i == sender.view.tag)
        {
            img.image = [UIImage imageNamed:@"xuanzhon.png"];
        } else {
            img.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
        
        /*
        提现方式
        0  下线转账
        1  支付宝
        4	微信
        5	银联  */
        
        switch (i) {
            case 0: //线下转账
                _selectMode = 0;
                break;
            case 1: //银联
                _selectMode = 5;
                break;
            case 2: //微信
                _selectMode = 4;
                break;
            case 3: //支付宝
                _selectMode = 1;
                break;
            default:
                break;
        }
    }
}

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确认提现按钮
 */
- (IBAction)confirmFetchMoneyBtnClick:(id)sender
{
    if ([_fmMoneyTF.text doubleValue] > [_totalMoney doubleValue]) {
        [SVProgressHUD showErrorWithStatus:@"提现金额数不能大于余额数!"];
        return;
    } else {
        [self fetchMoneyApplyforRequest];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
