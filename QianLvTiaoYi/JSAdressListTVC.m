//
//  JSAdressListTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSAdressListTVC.h"
#import "JSAddressEditVC.h"
#import "JSAdressListCell.h"
#import "PRAlertView.h"
#import "JSContact.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "GetAreaData.h"

@interface JSAdressListTVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray* addressList;
@property (nonatomic, assign) int pageNumber;  /**<每页返回数量*/
@property (nonatomic, assign) int currentPage;  /**<当前页码*/

@property (nonatomic, strong) JSAdressListCell *addressListcell;
@property (nonatomic, assign) int isDefaultAddress;

@end

@implementation JSAdressListTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        [self initModelsAndPager];
        [self getAdressList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
        [self getAdressList];
    }];
    
    [self initModelsAndPager];
    [self getAdressList];
}

#pragma mark - Private functions

- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = 10;
    self.addressList = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求获取地址列表
 */
- (void)getAdressList
{
    NSDictionary *param = @{@"currentPage": [NSString stringWithFormat:@"%d", _currentPage], @"pageNumber": [NSString stringWithFormat:@"%d", _pageNumber]};
    
      __weak typeof(self) weakSelf = self;
    
    [GetAddressListData postWithUrl:RMRequestStatusAddressList param:param modelClass:[Address class] responseBlock:^(id dataObj, NSError *error)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (dataObj) {
            weakSelf.currentPage++;
            [weakSelf.addressList addObjectsFromArray:dataObj];
        }
        
        [weakSelf.tableView reloadData];
        
        if (error.code == 200 || error.code == 200) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 *  编辑地址请求
 */
- (void)requestEditAddress:(NSInteger)tag
{
    Address *address = _addressList[tag];
    NSDictionary *dict  = @{@"mallDeliveryAddressId":address.mallDeliveryAddressId ? address.mallDeliveryAddressId : @"",
                            @"consigneeName": address.consigneeName,
                            @"consigneePhone": address.consigneePhone,
                            @"province": address.provinceArea.code ? address.provinceArea.code : @"" ,
                            @"city": address.cityArea.code ? address.cityArea.code : @"",
                            @"district": address.districtArea.code ? address.districtArea.code : @"",
                            @"address": address.address,
                            @"postcode": address.postcode,
                            @"isdefault":[NSString stringWithFormat:@"%d",_isDefaultAddress]};
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    
    __weak typeof(self) weakSelf = self;
    
    [GetAreaData postWithUrl:RMRequestStatusUpdateAddress param:dict modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            //调用下面 设置收货地址方法
            [weakSelf setDefaultConsigneesAddressWithIndex:tag];
        } else {
            [SVProgressHUD showErrorWithStatus:@"抱歉, 保存失败，请检查网络或者输入是否有误！"];
        }
    }];
}

/**
 *  删除地址请求
 */
-(void)deleteAddressWithIndex:(NSInteger)index
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
      Address *address = _addressList[index];
    
    __weak typeof(self) weakSelf = self;
    
    [GetAddressListData postWithUrl:RMRequestStatusDelAddress param:@{@"mallDeliveryAddressId": address.mallDeliveryAddressId} modelClass: nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
            
            [weakSelf deleteRowInTableViewWithIndex:index];
            
            //如果是创建订单选择进来 删除后 回调 空地址
            if (_isCreatOrder && _callBack) {
                _callBack(nil);
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"删除失败，请检查网络是否正常！"];
        }
    }];
}

/**
 *  根据索引删除单元格
 */
-(void)deleteRowInTableViewWithIndex:(NSInteger)index
{
    
    [_addressList removeObjectAtIndex: index];
    
    if (_isCreatOrder && _callBack && (_addressList == nil || _addressList.count == 0))
    {
        self.callBack(nil);
    }
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    //刷新按钮的tag，如果不刷新tag值将会有问题。
    [PRUitls delay:0.3 finished:^{
        [self.tableView reloadData];
    }];
}

/**
 *  设置为默认收货地址
 */
- (void)setDefaultConsigneesAddressWithIndex:(NSUInteger)index
{
    
    for (int i = 0; i < _addressList.count; i++) {
        Address *address = _addressList[i];
        if (i == index) {
            address.isdefault = YES;
        } else {
            address.isdefault = NO;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)backMemberCenterVCAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  选中按钮 设置为默认收货地址
 */
- (IBAction)selectButtonActions:(UIButton *)sender
{
    __weak __typeof(self) weakSelf = self;
    PRAlertView *alertView = [[PRAlertView alloc] initWithTitle:@"提示" message:@"是否确定要把该地址设为默认的收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setCallBack:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            _isDefaultAddress = 1;
            
            [weakSelf requestEditAddress:sender.tag];
            
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    
    [alertView show];
}

/**
 *  删除收货地址按钮
 */
- (IBAction)deleteButtonActions:(UIButton *)sender
{
    [self deleteAddressWithIndex:sender.tag];
}

/**
 *  添加收货地址按钮
 */
- (IBAction)addButtonAction:(UIBarButtonItem *)sender
{
     JSAddressEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressEditVC"];
    vc.isCreatOrder = YES;
    vc.callBack = self.callBack;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  编辑收货地址按钮
 */
- (IBAction)editButtonActions:(UIButton *)sender
{
    Address *address = _addressList[sender.tag];
    
    JSAddressEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressEditVC"];
    vc.address = address;
    vc.isCreatOrder = YES;
    vc.callBack = self.callBack;
    vc.isEditAddress = YES;
    vc.switchIsOn = address.isdefault;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCreatOrder && self.callBack) {
        self.callBack(_addressList[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return M_HEADER_HIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _addressList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _addressListcell = [tableView dequeueReusableCellWithIdentifier:@"adressCell" forIndexPath:indexPath];
    _addressListcell.deleteButton.tag = indexPath.section;
    _addressListcell.editButton.tag = indexPath.section;
    _addressListcell.selectButton.tag = indexPath.section;
    
    
    Address *address = _addressList[indexPath.section];
    _addressListcell.nameLabel.text = address.consigneeName;
    _addressListcell.phoneNumberLabel.text = address.consigneePhone;

    _addressListcell.adressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             address.provinceArea?address.provinceArea.name:@"",
                             address.cityArea?address.cityArea.name:@"",
                             address.districtArea?address.districtArea.name:@"",
                             address.address];
    
    _addressListcell.selectButton.selected = address.isdefault;
    
    _isDefaultAddress = address.isdefault;
    
    
    if (address.isdefault == YES) {
        _addressListcell.moRenLab.text = @"默认地址";
        [_addressListcell.selectButton setImage:[UIImage imageNamed:@"xuanzhon"] forState:UIControlStateNormal];
    } else {
        _addressListcell.moRenLab.text = @"";
        [_addressListcell.selectButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    return _addressListcell;
}


#pragma mark - Navigation
/**
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - DZNEmptyDataSource
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"CartEmpty"];
//}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请设置收货地址";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"主人快给我挑点宝贝吧";
//    
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
//                                 NSParagraphStyleAttributeName: paragraph};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor groupTableViewBackgroundColor];
}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//
//    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
//}
//
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"button_image"];
//}


@end
