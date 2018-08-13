//
//  JSUpdatePhoneTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/24.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSUpdatePhoneTVC.h"
#import "JSUPAlertView.h"
#import "GetPersonalInfoData.h"

@interface JSUpdatePhoneTVC ()

@property (nonatomic, strong) JSUPAlertView *customAlert;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) PersonalInfo *info;
@property (nonatomic, copy) NSString *oldPhone;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) BOOL verificTure;

@end

@implementation JSUpdatePhoneTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.customAlert removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


#pragma mark - HttpRequest

/**
 * 获取会员手机号
 */
- (void)getMemberPhoneNumber
{
    __weak typeof(self) weakSelf = self;
    [GetPersonalInfoData postWithUrl:RMRequestStatusPersonalInformation param:nil modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.info = dataObj;
             _oldPhone = weakSelf.info.Mobile;
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
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:@"已发送短信。"];
             _code = error.domain;
         } else {
             [SVProgressHUD showErrorWithStatus:@"发送失败。"];
         }
     }];
}

/**
 *  发送验证码lab点击手势，获取验证码
 */
- (void)sendCodeClick
{
    [self getMessageCodeRequestWithText:_info.Mobile WithType:@"9"];
    
    _customAlert.sendCodeLab.userInteractionEnabled = NO;
    _customAlert.sendCodeLab.backgroundColor = [UIColor grayColor];
    
    [PRUitls countDownWithTimeOut:60 CallBack:^(BOOL isFinished, int curTime)
     {
         if (isFinished) {
             _customAlert.sendCodeLab.userInteractionEnabled = YES;
             _customAlert.sendCodeLab.backgroundColor = QLTY_MAIN_COLOR;
             _customAlert.sendCodeLab.text = [NSString stringWithFormat:@"获取验证码"];
             _customAlert.sendCodeLab.textColor = [UIColor whiteColor];
         } else {
             _customAlert.sendCodeLab.text = [NSString stringWithFormat:@"%d秒重新获取", curTime];
         }
     }];
}


/**
 *  验证手机号/支付密码是否正确
 */
- (void)verificPhoneOrPswRequestWith:(NSString *)type with:(NSString *)psw
{
    [XLDataService postWithUrl:RMRequestStatusVerificTure param:@{@"verificationType":type,@"payPassword":psw} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             _verificTure = YES;
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 *  设置弹出view
 */
- (void)setCustomAlertView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _bottomView.backgroundColor = [UIColor lightGrayColor];
    _bottomView.alpha = 0.5;
    [self.view addSubview:_bottomView];
    
    _customAlert = [[NSBundle mainBundle] loadNibNamed:@"JSUPAlertView" owner:self options:nil].firstObject;
    _customAlert.center = CGPointMake(_bottomView.center.x, _bottomView.center.y- 60);
    _customAlert.bounds = CGRectMake(0, 0, 280, 190);
    
    [_customAlert.cancelBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_customAlert.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_customAlert];
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  取消
 */
- (void)cancleBtnClick
{
    [self.customAlert removeFromSuperview];
    [self.bottomView removeFromSuperview];
}


/**
 *  确定
 */
- (void)confirmBtnClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        //验证手机号
        
        if ([_customAlert.messageCode.text isEqualToString:_code]) {
            
            UIViewController *bingPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindingPhoneTVC"];
            [self.navigationController pushViewController:bingPhoneVC animated:YES];
        }
    } else {
        //验证支付密码
        
        [self verificPhoneOrPswRequestWith:@"2" with:_customAlert.payPswTF.text];
        
        [PRUitls delay:0.2 finished:^ {
             if (_verificTure == YES) {
                 UIViewController *bingPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindingPhoneTVC"];
                 [self.navigationController pushViewController:bingPhoneVC animated:YES];
             }
         }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self setCustomAlertView];
    
    _customAlert.confirmBtn.tag = indexPath.row;
    
    if (indexPath.row == 0) {
        
        [_customAlert.payPswTF removeFromSuperview];
        
        [self getMemberPhoneNumber];
        
        [PRUitls delay:1 finished:^ {
             NSString *str = [_oldPhone substringFromIndex:7];
             _customAlert.phoneNum.text = [NSString stringWithFormat:@"请输入手机尾号%@接收到的短信验证码",str];
         }];
        
        _customAlert.titleLab.text = @"验证手机号";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCodeClick)];
        _customAlert.sendCodeLab.userInteractionEnabled = YES;
        [_customAlert.sendCodeLab addGestureRecognizer:tap];
        
    } else {
        [_customAlert.messageCode removeFromSuperview];
        [_customAlert.sendCodeLab removeFromSuperview];
        
        _customAlert.titleLab.text = @"验证支付密码";
        _customAlert.phoneNum.text = @"请输入支付密码验证";
    }
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
