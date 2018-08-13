//
//  JSMemberInfoTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/21.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSMemberInfoTVC.h"

#import "JSContact.h"
#import "GetUserData.h"
#import "GetPersonalInfoData.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "UWDatePickerView.h"
#import "PRImageManager.h"


@interface JSMemberInfoTVC ()<UWDatePickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) PersonalInfo *info;

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;

@property (nonatomic, strong)UWDatePickerView *pickerView;

@property (nonatomic, copy) NSString *headerImgUrl;
@property (nonatomic, assign) BOOL isChangeHeaderImg;

@end

@implementation JSMemberInfoTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getPersonalInfoRequest];
}

#pragma mark - Private Methods

/**
 * 获取个人信息请求
 */
- (void)getPersonalInfoRequest
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    __weak typeof(self) weakSelf = self;
    
    [GetPersonalInfoData postWithUrl:RMRequestStatusPersonalInformation param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
        if (dataObj) {
            [SVProgressHUD showSuccessWithStatus:error.domain];
            weakSelf.info = dataObj;
            [self updateUIWithInfo:dataObj];
            [weakSelf.tableView reloadData];
            
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 * 个人信息
 */
- (void)updateUIWithInfo:(PersonalInfo *)info
{
    _avatarIV.clipsToBounds = YES;
    _avatarIV.layer.cornerRadius = 30;
    
    [_avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info.headPortrait]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    // 如果没有昵称的话 默认显示用户的手机号
    if ([info.nickName isEqualToString:@""] || info.nickName == NULL) {
        _nickName.text = info.Mobile;
    } else {
        _nickName.text = info.nickName;
    }
    
    _sexLabel.text = info.sex;
    _birthLabel.text = info.birthday;
}

/**
 * 请求修改昵称
 */
- (void)getChangeNicknameRequestWithString:(NSString *)nickname
{

    [XLDataService getWithUrl:RMRequestStatusChangePersonalInfo param:@{@"nickName":nickname} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功。"];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 * 请求修改性别
 */
- (void)getChangeSexRequestWithSex:(int)sex
{
    
    [XLDataService getWithUrl:RMRequestStatusChangePersonalInfo param:@{@"sex":[NSString stringWithFormat:@"%d",sex]} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:@"修改成功。"];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 * 请求修改生日
 */
- (void)getChangeBirthRequestWithBirth:(NSString *)birth
{
    [XLDataService getWithUrl:RMRequestStatusChangePersonalInfo param:@{@"birthday":birth} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:@"修改成功。"];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 * 请求修改头像
 */
- (void)getUploadHeaderImageRequestWithImage:(NSString *)image
{
    [XLDataService postWithUrl:RMRequestStatusChangePersonalInfo param:@{@"headPortrait":image} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  上传头像
 */
- (void)uploadHeaderImageWithImage:(UIImage *)image
{
    XLFileConfig *config = [[XLFileConfig alloc] init];
    config.fileData = UIImageJPEGRepresentation(image, 0.5);
    config.fileName = @"headImage.jpg";
    config.name = @"file";
    config.mimeType = @"image/png";
    
    __weak typeof(self) weakSelf = self;
    
    [XLDataService updateWithUrl:RMRequestStatusUploadImage param:nil fileConfig:config responseBlock:^(id dataObj, NSError *error)
    {
        NSLog(@"%@", dataObj);
        if (error.code == 100) {
            [weakSelf getUploadHeaderImageRequestWithImage:dataObj[@"object"]];
            _headerImgUrl = dataObj[@"object"];
        }
    }];
}


/**
 * 修改头像点击方法
 */
- (void)changeHeaderImgMethod
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}

/**
 *  修改性别方法
 */
- (void)changeSexMethod
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

#pragma mark - Click Actions

/**
 *  返回按钮点击方法
 */
- (IBAction)backSetTVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  退出登录按钮点击方法
 */
- (IBAction)logoutAction:(id)sender
{
    [GetUserData deleteMemberLoginStatus];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  单元格的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {   //头像
  
            [self changeHeaderImgMethod];
        }
            break;
        case 1: {   //昵称
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *nickText = [alert textFieldAtIndex:0];
            nickText.text = _nickName.text;
            [alert show];
            
        }
            break;
        case 2: {   //性别
            
            [self changeSexMethod];
        }
            break;
            
        default: {   //生日
            
            _pickerView = [UWDatePickerView instanceDatePickerView];
            [_pickerView setBackgroundColor:[UIColor clearColor]];
            _pickerView.delegate = self;
            [self.view addSubview:_pickerView];
        }
            break;
    }

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _avatarIV.image = [PRImageManager imageCompressForSize:image targetSize:CGSizeMake(100, 100)];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadHeaderImageWithImage:_avatarIV.image];
}

#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
                _sexLabel.text = @"男";
                [self getChangeSexRequestWithSex:(int)buttonIndex];
                break;
            case 1:
                _sexLabel.text = @"女";
                [self getChangeSexRequestWithSex:(int)buttonIndex];
                break;
            case 2:
                _sexLabel.text = @"保密";
                [self getChangeSexRequestWithSex:(int)buttonIndex];
                break;
            default:
                // 取消
                break;
        }
        
    } else {
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
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *changeText = [alertView textFieldAtIndex:0];
        _nickName.text = changeText.text;
        
        [self getChangeNicknameRequestWithString:_nickName.text];
    }
}

#pragma mark - UWDatePickerViewDelegate

- (void)getSelectDate:(NSString *)date
{
    _birthLabel.text = date;
    
    [self getChangeBirthRequestWithBirth:_birthLabel.text];
}

#pragma mark - Table view data source & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _info?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
