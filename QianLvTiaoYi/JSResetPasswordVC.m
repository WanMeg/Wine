//
//  JSResetPasswordVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/2/2.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSResetPasswordVC.h"
#import "XLDataService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UITextField+Verify.h"

@interface JSResetPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWDTF;

@end

@implementation JSResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)commitAction:(UIButton *)sender {
    [self verifyInputPasswords];
}


- (void)verifyInputPasswords {
    if ([_passwordTF.text isEqualToString:@""] || [_confirmPWDTF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (![_passwordTF validatePassword] && ![_confirmPWDTF validatePassword]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码格式"];
        _passwordTF.text = @"";
        _confirmPWDTF.text = @"";
        return;
    }
    
    if (![_passwordTF.text isEqualToString:_confirmPWDTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不正确"];
        return;
    }
    
    [self requestUpdateMemberPassword:_passwordTF.text];
}

- (void)requestUpdateMemberPassword:(NSString *)password {
    __weak typeof(self) weakSelf  = self;
    [XLDataService postWithUrl:RMRequestStatusUpdatememberPwd param:@{@"tel": _tel, @"pwd": password} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
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
