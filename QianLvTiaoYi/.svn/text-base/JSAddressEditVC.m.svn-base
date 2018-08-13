//
//  JSAddressEditVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/21.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSAddressEditVC.h"
#import "JSAddressEditLabelCell.h"
#import "JSAddressEidtTextFieldCell.h"
#import "JSAddressPickerView.h"
#import "JSContact.h"
#import "GetAreaData.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JSCommitOrderVC.h"
#import "JSAddressDefaultCell.h"

#define PICKER_VIEW_HEIGHT 180.0f

@interface JSAddressEditVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JSAddressPickerView *pickerView;

/**
 *  选择之后的地区信息，分别是省，市，区
 */
@property (nonatomic, strong) NSArray *selectedAreaInfos;

/**
 *  省份名称
 */
@property (nonatomic, copy) NSString *province;
/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *city;
/**
 *  区域名称
 */
@property (nonatomic, copy) NSString *district;



@end

@implementation JSAddressEditVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Private functions

//- (void)requestAreaDataWithAreaLevel:(NSString *)areaLevel {
//     typeof(self) weakSelf = self;
//    [GetAreaData postWithUrl:RMRequestStatusArea param:@{@"areaLevel": areaLevel} modelClass:[Area class] responseBlock:^(id dataObj, NSError *error) {
//        if (dataObj) {
//            weakSelf.datas1 = dataObj;
//             [self initPickerView];
//            [weakSelf.pickerView reloadAllComponents];
//        }
//    }];
//   NSArray *list = [GetAreaData makeAreaDataXml];
//    //NSDictionary转换为XML的plist格式
//    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:list
//                                                                 format:NSPropertyListXMLFormat_v1_0
//                                                       errorDescription:NULL];
//    //创建文件路径
//    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"areaInfo.plist"];
//    [xmlData writeToFile:filePath atomically:YES];
//}

/**
 *  初始化PickerView 从Plist文件读取地区信息到 PickerView
 */
- (void)initPickerView
{
    if (self.pickerView == nil)
    {
        self.pickerView = [[JSAddressPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - PICKER_VIEW_HEIGHT - 64.0, WIDTH, PICKER_VIEW_HEIGHT)];
        
        //pickerView选择回调- 固定3个长度的数组，分别是省，市，区
        __weak typeof(self) weakSelf = self;
        _pickerView.selectCallBack = ^(NSArray *areaInfos){
            weakSelf.selectedAreaInfos = areaInfos;
            [weakSelf updateAddressWith:areaInfos];
        };
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"areaInfo" ofType:@"plist"];
        _pickerView.areaList = [Area mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:plistPath]];
    }
    [self.view addSubview:_pickerView];
}

//拼接 地区名称 并返回
- (void)updateAddressWith: (NSArray *)areaInfos
{
    NSString *name = [self getCellTextFieldTextWithRow:0];
    NSString *phone = [self getCellTextFieldTextWithRow:1];
    NSString *address = [self getCellTextFieldTextWithRow:3];
    NSString *postCode = [self getCellTextFieldTextWithRow:4];
    if (self.address == nil) {
        self.address = [[Address alloc] init];
    }
    self.address.consigneeName = name;
    self.address.consigneePhone = phone;
    
    self.address.provinceArea = areaInfos[0];
    
    self.address.cityArea = areaInfos[1];
    
    self.address.districtArea = areaInfos[2];
    
    self.address.address = address;
    self.address.postcode = postCode;
    [self.tableView reloadData];
}

//取出CellTextField 文本
- (NSString *)getCellTextFieldTextWithRow:(NSInteger)row
{
    JSAddressEidtTextFieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return cell.textField.text;
}


#pragma mark - Http Request

/**
 *  请求保存地址
 */
- (void)requestSaveAddress:(NSDictionary *)param
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    __weak typeof(self) weakSelf = self;
    [GetAreaData postWithUrl:RMRequestStatusAddAddress param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
             [weakSelf popToTargetViewController];
         }else {
             [SVProgressHUD showErrorWithStatus:@"抱歉, 保存失败，请检查网络或者输入是否有误！"];
         }
     }];
}

/**
 *  请求编辑地址
 */
- (void)requestEditAddress:(NSDictionary *)param
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    __weak typeof(self) weakSelf = self;
    [GetAreaData postWithUrl:RMRequestStatusUpdateAddress param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            [weakSelf popToTargetViewController];
        }else {
            [SVProgressHUD showErrorWithStatus:@"抱歉, 保存失败，请检查网络或者输入是否有误！"];
        }
    }];
}

//根据来源视图控制器返回不同到响应的地方
- (void)popToTargetViewController
{
    if (_isCreatOrder && _callBack)
    {
        _callBack(_address);
        UIViewController *addressVC;
        for (UIViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass: [JSCommitOrderVC class]])
            {
                addressVC = vc;
                break;
            }
        }
        [self.navigationController popToViewController:addressVC animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Actions

/**
 *  保存地址按钮
 */
- (IBAction)saveAddressAction:(UIButton *)sender
{
    NSString *name = [self getCellTextFieldTextWithRow:0];
    NSString *phone = [self getCellTextFieldTextWithRow:1];
    NSString *address = [self getCellTextFieldTextWithRow:3];
    NSString *postCode = [self getCellTextFieldTextWithRow:4];
    
    if (name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"收货人姓名不能为空"];
        return;
    }
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号码填写错误"];
        return;
    }
    if (address.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"详细地址不能为空"];
        return;
    }
    
    if (self.address == nil) {
        self.address = [[Address alloc] init];
    }
    self.address.consigneeName = name;
    self.address.consigneePhone = phone;
    self.address.address = address;
    self.address.postcode = postCode;
    
    if (self.address)
    {
        NSDictionary *dict  = @{@"mallDeliveryAddressId":_address.mallDeliveryAddressId ? _address.mallDeliveryAddressId : @"",
                                @"consigneeName": name,
                                @"consigneePhone": phone,
                                @"province": _address.provinceArea.code ? _address.provinceArea.code : @"" ,
                                @"city": _address.cityArea.code ? _address.cityArea.code : @"",
                                @"district": _address.districtArea.code ? _address.districtArea.code : @"",
                                @"address": address,
                                @"postcode": postCode,
                                @"isdefault":[NSString stringWithFormat:@"%d",_switchIsOn]};
        
        //开始提交保存请求 
        if (self.isEditAddress)
        {
            [self requestEditAddress:dict];
        }else
        {
            [self requestSaveAddress:dict];
        }
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"请选择地区信息"];
    }
}

/**
 *  设为默认地址
 */
- (void)setDefaultAddressAction:(UISwitch *)sender
{
    if (sender.isOn)
    {
        _switchIsOn = 1;

    } else
    {
        _switchIsOn = 0;
    }
}

#pragma mark - TextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.pickerView removeFromSuperview];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 2)
    {
        [self initPickerView];
    }else{
        [self.pickerView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"收  货  人", @"手机号码", @"所在地区", @"详细地址", @"邮政编码" ,@"设为默认地址"];
    if (indexPath.row == 2)
    {
        JSAddressEditLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell" forIndexPath:indexPath];
        cell.titileLabel.text = titles[indexPath.row];
        if (self.address) {
            cell.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                   _address.provinceArea.name ? _address.provinceArea.name : @"",
                                   _address.cityArea.name ? _address.cityArea.name : @"",
                                   _address.districtArea.name ? _address.districtArea.name : @""];
        }
        return cell;
    }
    else if (indexPath.row == 5)
    {
        JSAddressDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultAddressCell" forIndexPath:indexPath];
        cell.titleLabel.text = titles[indexPath.row];
        [cell.defaultAddressSwitch addTarget:self action:@selector(setDefaultAddressAction:) forControlEvents:UIControlEventValueChanged];

        cell.defaultAddressSwitch.on = _switchIsOn;

        return cell;
    }
    else
    {
        JSAddressEidtTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
        cell.titleLabel.text = titles[indexPath.row];
        
        switch (indexPath.row)
        {
            case 0:
                cell.textField.placeholder = @"请输入收货人姓名";
                cell.textField.text = self.address ? self.address.consigneeName : @"";
                break;
            case 1:
                cell.textField.placeholder = @"请输入收货人手机号码";
                cell.textField.text = self.address ? self.address.consigneePhone : @"";
                break;
            case 3:
                cell.textField.placeholder = @"请输入收货人详细地址";
                cell.textField.text = self.address ? self.address.address : @"";
                break;
            case 4:
                cell.textField.placeholder = @"请输入邮政编码";
                cell.textField.text = self.address.postcode.boolValue ? self.address.postcode : @"";
                break;
            default:
                break;
        }
        return cell;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
