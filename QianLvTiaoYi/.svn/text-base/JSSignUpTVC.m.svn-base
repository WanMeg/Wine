//
//  JSSignUpTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/10/30.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSSignUpTVC.h"
#import "JSContact.h"
#import "GetUserData.h"

#import "PRImageManager.h"

#import "JSPickerView.h"
#import "Area.h"
#import "GetAreaData.h"
#import "SubModel.h"
#import "JSGDActivityView.h"
@interface JSSignUpTVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *registeCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *sendCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UILabel *selectAddressLab;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UITextField *shopAddressTF;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (weak, nonatomic) UIImageView *currentIV;  //当前选择上传的图片视图

@property (nonatomic, strong) JSPickerView *pickerView;
@property (nonatomic, strong) SubModel * model;

/**
 *  选择之后的地区信息，分别是省，市，区
 */
@property (nonatomic, strong) NSArray *selectedAreaInfos;

//省
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *provinceCode;
//市
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityCode;
//区
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *districtCode;

@end

@implementation JSSignUpTVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
    _nameTF.delegate = self;
    _textCodeTF.delegate = self;
    _passwordTF.delegate = self;
    _registeCodeTF.delegate = self;
    _shopNameTF.delegate = self;
    _realNameTF.delegate = self;
    _shopAddressTF.delegate = self;
    
    [_imageViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadBusinessPhoto:)];
         [obj addGestureRecognizer:tap];
     }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //页面将要消失的时候，关闭键盘
    [self.view endEditing:YES];
}

/**
 *  初始化PickerView 从Plist文件读取地区信息到 PickerView
 */
- (void)initPickerView
{
    _pickerView = [[NSBundle mainBundle] loadNibNamed:@"JSPickerView" owner:self options:nil].firstObject;
    _pickerView.frame = CGRectMake(0, HEIGHT - 202.0, WIDTH, 202.0);
    [_pickerView.pickerCancleBtn addTarget:self action:@selector(pickerCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView.pickerConfirmBtn addTarget:self action:@selector(pickerConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_pickerView];
   
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"areaInfo" ofType:@"plist"];
    _pickerView.areaList = [Area mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:plistPath]];
    
    //pickerView选择回调- 固定3个长度的数组，分别是省，市，区
    __weak typeof(self) weakSelf = self;
    _pickerView.selectCallBack = ^(NSArray *areaInfos){
        weakSelf.selectedAreaInfos = areaInfos;
    };
}

- (void)uploadBusinessPhoto:(UITapGestureRecognizer *)sender
{
    [_pickerView removeFromSuperview];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = sender.view.tag;
    _currentIV = (UIImageView *)sender.view;
    [sheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    switch (buttonIndex) {
        case 0:{
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//相机
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 1:{
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//相册
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            // 取消
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *selectedImage = [PRImageManager imageCompressForSize:image targetSize:CGSizeMake(500, 500)];
   _currentIV.image = selectedImage;
    self.selectedImages[_currentIV.tag] = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private functions

/**
 *  布局ui
 */
- (void)updateUI
{
    _registButton.layer.cornerRadius = 3.0f;
    _registButton.layer.masksToBounds = YES;
    
    //获取验证码lab添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendTextCode)];
    [_sendCodeLabel addGestureRecognizer:tap];
    _sendCodeLabel.userInteractionEnabled = YES;
}

/**
 *  判断账号密码输入是否正确
 */
- (BOOL)validateInputs
{
    if (!(_nameTF.validatePhoneNumber)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码输入有误！"];
        return NO;
    }
    
    if (!_passwordTF.validatePassword) {
        [SVProgressHUD showErrorWithStatus:@"密码输入有误！"];
        return NO;
    }
    
    if (!_realNameTF.validateChinese) {
        [SVProgressHUD showErrorWithStatus:@"姓名输入有误！"];
        return NO;
    }
    return YES;
}

/**
 *  注册的请求方法
 **/
- (void)requestSignUpWithURls:(NSMutableArray *)URLs
{
    NSString *licence = [NSString stringWithFormat:@"%@,%@", URLs[0], URLs[1]];
    NSString *doorPhoto = [NSString stringWithFormat:@"%@,%@", URLs[2], URLs[3]];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    
    NSDictionary *param = @{@"tel": _nameTF.text,
                            @"verifyCode": _textCodeTF.text,
                            @"password": _passwordTF.text,
                            @"proValue":_registeCodeTF.text,
                            @"realName" : _realNameTF.text,
                            @"storeName" : _shopNameTF.text,
                            @"storeAddress" : _shopAddressTF.text.length > 0 ? _shopAddressTF.text : @"",
                            @"businessLicencePicUrl" : licence,
                            @"doorHeadPhoto" : doorPhoto,
                            @"province" : _provinceCode,
                            @"city" : _cityCode,
                            @"district" : _districtCode};
    
    [GetUserData postWithUrl:RMRequestStatusSignUp param:param modelClass: [Member class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}


/**
 *  开始上传图片
 */
- (void)beginToUploadImagesWithUpdateHandler:(void (^)(BOOL success, NSMutableArray *imgURLs))updateHandler
{
    NSMutableArray *images = [NSMutableArray array];
    for (id obj in _selectedImages) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [images addObject: obj];
        }
    }
    
    if (images.count != 4) {
        [SVProgressHUD showInfoWithStatus:@"请检查图片是否全部选择完成"];
        return;
    }
    
    __block int count  = 0;
    NSMutableArray *uploadedURLs = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    
    for (int i = 0; i < images.count; i++) {
        UIImage *img = images[i];
        [WMGeneralTool uploadImages:img name:@"file" fileName:[NSString stringWithFormat:@"business%d.png", i] mimeType:@"image/png" callBack:^(BOOL success, NSString *url) {
            if (success) {
                uploadedURLs[i] = url;
                count++;
                if (count == images.count) {
                    //[SVProgressHUD showSuccessWithStatus:@"图片上传完成"];
                    if (updateHandler) updateHandler(YES, uploadedURLs);
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                 if (updateHandler) updateHandler(NO, nil);
            }
        }];
    }

}

/**
 *  注册
 */
- (void)beginToSignUp
{
    [self.view endEditing:YES];
    
    //检查用户名密码输入是否正确
    if (![self validateInputs]){
        return;
    } else {
        if (_realNameTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名!"];
            return;
        } else {
            if (_shopNameTF.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入门店的名称!"];
                return;
            } else {
                if (_provinceCode == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请选择店铺所在区域!"];
                    return;
                } else {
                    //上传图片
                    __weak typeof(self) weakSelf = self;
                    
                    [self beginToUploadImagesWithUpdateHandler:^(BOOL success, NSMutableArray *imgURLs) {
                        if (success) {
                            //注册请求
                            [weakSelf requestSignUpWithURls:imgURLs];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                        }
                    }];
                }
            }
        }
    }
}


#pragma mark - Actions

/*
 * 获取验证码lab的点击手势
 */
- (void)sendTextCode
{
    if (!_nameTF.validatePhoneNumber) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSDictionary *param = @{@"mobileNo":_nameTF.text,@"messageType":@"2"};
        
        [XLDataService postWithUrl:RMRequestStatusSendMessage param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
             if (error.code == 0) {
                 [SVProgressHUD showSuccessWithStatus:@"已发送验证码"];
             } else {
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }
        }];
        
        _sendCodeLabel.userInteractionEnabled = NO;
        _sendCodeLabel.backgroundColor = [UIColor grayColor];
        
        [PRUitls countDownWithTimeOut:60 CallBack:^(BOOL isFinished, int curTime)
         {
             if (isFinished) {
                 _sendCodeLabel.userInteractionEnabled = YES;
                 _sendCodeLabel.backgroundColor = QLTY_MAIN_COLOR;
                 _sendCodeLabel.text = [NSString stringWithFormat:@"获取验证码"];
             } else {
                 _sendCodeLabel.text = [NSString stringWithFormat:@"%d秒重新获取", curTime];
             }
         }];
    }
}

/**
 *  pickerView取消按钮事件
 */
- (void)pickerCancelButtonClick
{
    [self.pickerView removeFromSuperview];
}

/**
 *  pickerView确定按钮事件
 */
- (void)pickerConfirmButtonClick
{
    SubModel *model1 = [[SubModel alloc]init];
    model1 = _selectedAreaInfos[0];
    _province = model1.name;
    _provinceCode = model1.code;
    
    SubModel *model2 = [[SubModel alloc]init];
    model2 = _selectedAreaInfos[1];
    _city = model2.name;
    _cityCode = model2.code;
    
    SubModel *model3 = [[SubModel alloc]init];
    model3 = _selectedAreaInfos[2];
    _districtCode = model3.code;
    _district = model3.name;

    _selectAddressLab.text = [NSString stringWithFormat:@"%@ %@ %@",_province?_province:@"",_city?_city:@"",_district?_district:@""];
    _selectAddressLab.textColor = [UIColor blackColor];
    
    [PRUitls delay:0.5 finished:^{
        [self.pickerView removeFromSuperview];
    }];
}

/**
 *  注册按钮点击方法
 */
- (IBAction)signUpAction:(id)sender
{
    [self beginToSignUp];
}

- (IBAction)closeAction:(id)sender
{
    [self.pickerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFeild delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.pickerView removeFromSuperview];
    return YES;
}

//“return”键按下时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_nameTF]) {
        [_textCodeTF becomeFirstResponder];
    }
    if ([textField isEqual:_textCodeTF]) {
        [_passwordTF becomeFirstResponder];
    }
    if ([textField isEqual:_passwordTF]) {
        [textField resignFirstResponder];
        [self beginToSignUp];
    }
    return YES;
}

//输入框结束编辑
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([textField isEqual:_nameTF] && textField.text.length > 40)
//    {
//        
//    }
//}

//用户输入长度限制
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([textField isEqual:_nameTF] && textField.text.length >= 40) {
//        return NO;
//    }
//    if ([textField isEqual:_textCodeTF] && textField.text.length >= 6) {
//        return NO;
//    }
//    if ([textField isEqual:_passwordTF] && textField.text.length >= 20) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        [self initPickerView];
        
    }else{
        [self.pickerView removeFromSuperview];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 4;
    }else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 44;
    } else {
        if (indexPath.row == 5 || indexPath.row == 7) {
            return 100;
        } else {
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    } else {
        return 18.0f;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1)
//    {
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
//        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:headerView.frame];
//        label.text = @"(以下内容如果不完善，账户不能被认证)";
//        label.textColor = [UIColor redColor];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textAlignment = NSTextAlignmentCenter;
//        [headerView addSubview:label];
//        
//        return headerView;
//    } else {
//        return nil;
//    }
//}


#pragma mark - 重写Setter 和 Getter

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
    }
    return _selectedImages;
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
