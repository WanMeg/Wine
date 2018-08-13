//
//  JSUserPasswordTabVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSUserPasswordTabVC.h"
#import "PRUitls.h"
#import "JSContact.h"
#import "XLDataService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "GetPersonalInfoData.h"
#import "UITextField+Verify.h"
#import "JSMemberCenterTVC.h"
#import "GetUserData.h"

@interface JSUserPasswordTabVC ()

//用户手机号
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumTF;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumLab;

@property (weak, nonatomic) IBOutlet UIButton *userGetCodeBtn;
//短信验证码
@property (weak, nonatomic) IBOutlet UITextField *userNoteVerityTF;
//旧密码
@property (weak, nonatomic) IBOutlet UITextField *userOldPassWTF;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *userNewPassWTF;

@property (weak, nonatomic) IBOutlet UIButton *confirmChangeBtn;

@property (nonatomic, strong) PersonalInfo *info;

@property (nonatomic, strong)NSDictionary *paramCode;
@end

@implementation JSUserPasswordTabVC


#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isLoginPswVC == YES)
    {
        if (self.isForgetPswVC == YES)
        {
            self.title = @"忘记密码";
            [_userPhoneNumLab removeFromSuperview];
            
        } else {
            self.title = @"登录密码";
            [_userPhoneNumTF removeFromSuperview];
            [self getMemberPhoneNumber];
        }
    } else {
        self.title = @"支付密码";
        [_userPhoneNumTF removeFromSuperview];
        [self getMemberPhoneNumber];
    }
}

#pragma mark - Private
/**
 *  修改密码 验证密码是否正确
 */
- (BOOL)changePswValidateInputs
{
    if (!_userNewPassWTF.validatePassword) {
        [SVProgressHUD showErrorWithStatus:@"密码输入有误！"];
        return NO;
    }
    return YES;
}

/**
 *  忘记密码 验证输入是否正确
 */
- (BOOL)forgetPswValidateInputs{
    
    if (!(_userPhoneNumTF.validatePhoneNumber)) {
        [SVProgressHUD showErrorWithStatus:@"账号输入有误！"];
        return NO;
    }
    
    if (!_userNewPassWTF.validatePassword) {
        [SVProgressHUD showErrorWithStatus:@"密码输入有误！"];
        return NO;
    }
    
    return YES;
}

/**
 * 获取会员手机号
 */
- (void)getMemberPhoneNumber
{
    __weak typeof(self) weakSelf = self;
    [GetPersonalInfoData postWithUrl:RMRequestStatusPersonalInformation param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj)
         {
             weakSelf.info = dataObj;
             _userPhoneNumLab.text = weakSelf.info.Mobile;
         }
     }];
}

/**
 *  设置验证码按钮的点击状态
 */
- (void)setCodeBtnStatusClick
{
    _userGetCodeBtn.userInteractionEnabled = NO;
    _userGetCodeBtn.backgroundColor = [UIColor grayColor];
    
    [PRUitls countDownWithTimeOut:60 CallBack:^(BOOL isFinished, int curTime)
     {
         if (isFinished)
         {
             _userGetCodeBtn.userInteractionEnabled = YES;
             _userGetCodeBtn.backgroundColor = QLTY_MAIN_COLOR;
             [_userGetCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
         }else{
             [_userGetCodeBtn setTitle:[NSString stringWithFormat:@"%d秒重新获取", curTime] forState:UIControlStateNormal];
         }
     }];
}

/**
 *  获取相应验证码的请求
 */
- (void)getMessageCodeRequestWithText:(NSString *)text WithType:(NSString *)type
{
    [XLDataService postWithUrl:RMRequestStatusSendMessage param:@{@"mobileNo":text,@"messageType":type} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj)
         {
             [SVProgressHUD showSuccessWithStatus:@"已发送短信。"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发送失败。"];
         }
     }];
}

/**
 * 获取修改登录密码 & 支付密码 请求
 */
- (void)getChangePswRequestWith:(NSString *)password
{
    NSDictionary *param = @{password:_userNewPassWTF.text,@"tel":_userPhoneNumLab.text,@"verifyCode":_userNoteVerityTF.text};
    [XLDataService postWithUrl:RMRequestStatusChangeLoginPsw param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100)
         {
             [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
             
             [PRUitls delay:0.3 finished:^
              {
                  if (_isLoginPswVC == YES && _isForgetPswVC == NO)
                  {
                      [GetUserData deleteMemberLoginStatus];//退出登录
                      [M_NOTIFICATION postNotificationName:@"exitLogoutNotifi" object:nil];
                      NSArray * controller=[self.navigationController viewControllers];
                      JSMemberCenterTVC * memberVC=[controller objectAtIndex:0];
                      [self.navigationController popToViewController:memberVC animated:YES];
                  }
                  
                  if (!_isLoginPswVC) {
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }
              }];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"修改失败。"];
         }
     }];
}


/**
 * 获取忘记密码请求
 */
- (void)getForgetPswRequest
{
    NSDictionary *param = @{@"password":_userNewPassWTF.text,@"tel":_userPhoneNumTF.text,@"verifyCode":_userNoteVerityTF.text};
    [XLDataService postWithUrl:RMRequestStatusForgetPsw param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100)
         {
             [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
             
             NSArray * controller=[self.navigationController viewControllers];
             JSMemberCenterTVC * memberVC=[controller objectAtIndex:0];
             [self.navigationController popToViewController:memberVC animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"修改失败。"];
         }
     }];
}
#pragma mark - Actions

/**
 * 验证码按钮点击事件
 */
- (IBAction)getVerityCodeClick:(UIButton *)sender
{
    [self setCodeBtnStatusClick];
    
    if (self.isLoginPswVC == YES)
    {
        if (self.isForgetPswVC == YES)
        {
            [self getMessageCodeRequestWithText:_userPhoneNumTF.text WithType:[NSString stringWithFormat:@"%d",6]];
        }
        else
        {
            [self getMessageCodeRequestWithText:_userPhoneNumLab.text WithType:[NSString stringWithFormat:@"%d",3]];
        }
    }
    else
    {
        [self getMessageCodeRequestWithText:_userPhoneNumLab.text WithType:[NSString stringWithFormat:@"%d",4]];
    }
}

/**
 * 确认修改按钮
 */
- (IBAction)confirmChangeClick:(UIButton *)sender
{
    if ([_userNoteVerityTF.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"输入不能为空！"];
        
        return;
    }
    
    if (self.isLoginPswVC == YES)
    {
        if (self.isForgetPswVC == YES)
        {   //找回密码
            if ([self forgetPswValidateInputs])
            {
                [self getForgetPswRequest];
            }
        }
        else
        {   //修改登录密码
            if ([self changePswValidateInputs])
            {
                [self getChangePswRequestWith:@"password"];
            }
        }
    }
    else
    {   //支付密码
        if ([self changePswValidateInputs])
        {
            [self getChangePswRequestWith:@"payPassword"];
        }
    }
}
/**
 * switch点击事件
 */
- (IBAction)showPasswordSwitchClick:(UISwitch *)sender
{
    if (sender.tag == 1000)
    {
        //旧密码
        if (sender.isOn)
        {
            _userOldPassWTF.secureTextEntry = NO;
        } else {
            _userOldPassWTF.secureTextEntry = YES;
        }
    } else {
        //新密码
        if (sender.isOn)
        {
            _userNewPassWTF.secureTextEntry = NO;
        } else {
            _userNewPassWTF.secureTextEntry = YES;
        }
    }
}

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


@end
