//
//  JSLoginTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/10/29.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSLoginTVC.h"
#import "JSContact.h"
#import "UITextField+Verify.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ShareSDK/ShareSDK.h>
#import "GetUserData.h"
#import "Member.h"
#import "JSSignUpTVC.h"
#import "JSUserPasswordTabVC.h"

@interface JSLoginTVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (nonatomic, strong) Member *member;

@end

@implementation JSLoginTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameTF.delegate = self;
    _passwordTF.delegate = self;
    
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //页面将要消失的时候，关闭键盘
    [self.view endEditing:YES];
}

#pragma mark - Private Functions

- (void)updateUI {
    _loginButton.layer.cornerRadius = 3;
    _loginButton.layer.masksToBounds = YES;
     _loginButton.layer.borderWidth = 0.5;
     _loginButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (BOOL)validateInputs
{
    if (!_nameTF.validatePhoneNumber) {
        [SVProgressHUD showErrorWithStatus:@"登录账号输入不正确"];
        return NO;
    }
    
    if (!_passwordTF.validatePassword) {
       [SVProgressHUD showErrorWithStatus:@"密码输入不正确"];
        return NO;
    }
    return YES;
}

//开始登录
- (void)beginToLogin
{
    [self.view endEditing:YES];
    
    if ([self validateInputs]) {
        [SVProgressHUD showWithStatus:@"请稍后..."];
        NSDictionary *dict = @{@"tel": _nameTF.text,
                               @"password": _passwordTF.text,
                               @"loginMode": @"0"};
        
        __weak typeof(self) weakSelf = self;
        [GetUserData postWithUrl:RMRequestStatusLogin param:dict modelClass: [Member class]responseBlock:^(id dataObj, NSError *error) {
            if (dataObj != nil) {
                [SVProgressHUD showSuccessWithStatus:error.domain];
                weakSelf.member = dataObj;
                [M_USERDEFAULTS setBool:weakSelf.member.isAuthentication forKey:@"UserIsAuthentication"];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
        }];
    };
}

#pragma mark - Actions

/**
 *  开关按钮点击事件
 */
- (IBAction)loginVCSwitchClick:(UISwitch *)sender
{
    if (sender.isOn) {
        _passwordTF.secureTextEntry = NO;
    } else {
        _passwordTF.secureTextEntry = YES;
    }
}

//登录按钮
- (IBAction)loginAction:(id)sender
{
    [self beginToLogin];
}

- (IBAction)forgotAction:(id)sender
{
//忘记密码界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:nil];
    JSUserPasswordTabVC *userPswVC = [storyboard instantiateViewControllerWithIdentifier:@"UserPasswordTabVC"];
    userPswVC.isLoginPswVC = YES;
    userPswVC.isForgetPswVC = YES;
    [self.navigationController pushViewController:userPswVC animated:YES];
}

- (IBAction)closeAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpAction:(UIButton *)sender
{
    JSSignUpTVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_nameTF]) {
        [_passwordTF becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self beginToLogin];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_nameTF] && textField.text.length >= 40) {
        return NO;
    }

    if ([textField isEqual:_passwordTF] && textField.text.length >= 20) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.view endEditing:YES];
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
