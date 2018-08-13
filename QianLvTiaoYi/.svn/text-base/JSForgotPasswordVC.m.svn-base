//
//  JSForgotPasswordVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/2/2.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSForgotPasswordVC.h"
#import "XLDataService.h"
#import "JSResetPasswordVC.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface JSForgotPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UILabel *rightCodeLab;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation JSForgotPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 发送验证码
- (IBAction)sendCodeAction:(UIButton *)sender
{
    [self requestForgotPasswordSendCode];
}

//下一步找回密码
- (IBAction)nextSetpAction:(UIButton *)sender
{
    [self requestMatchVerificationWithPhoneNo:_phoneTF.text];
}

- (void)requestForgotPasswordSendCode
{
    [XLDataService postWithUrl:RMRequestStatusForgetPwdVerification param:@{@"tel": _phoneTF.text} modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100)
        {
            [SVProgressHUD showSuccessWithStatus:@"已发送验证码"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}


- (void)requestMatchVerificationWithPhoneNo:(NSString *)phoneNo {
    __weak typeof(self) weakSelf = self;
    [XLDataService postWithUrl:RMRequestStatusMatchVerification param:@{@"tel": phoneNo, @"verifyCode": _codeTF.text} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code == 100) {
            [weakSelf showResetPasswordVCWithPhoneNo:phoneNo];
        }else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)showResetPasswordVCWithPhoneNo:(NSString *)phoneNo {
    JSResetPasswordVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
    vc.tel = phoneNo;
    [self.navigationController pushViewController:vc animated:YES];
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
