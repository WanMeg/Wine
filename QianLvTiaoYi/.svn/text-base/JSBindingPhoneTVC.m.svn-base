//
//  JSBindingPhoneTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSBindingPhoneTVC.h"
#import "UITextField+Verify.h"

@interface JSBindingPhoneTVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;

@property (weak, nonatomic) IBOutlet UILabel *sendCodeLab;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation JSBindingPhoneTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCodeClick)];
    _sendCodeLab.userInteractionEnabled = YES;
    [_sendCodeLab addGestureRecognizer:tap];
    
}

#pragma mark - Request

/**
 *  更换绑定手机的请求
 */
- (void)changeBindingPhoneRequest
{
    
    [XLDataService postWithUrl:RMRequestStatusChangeBindingPhone param:@{@"mobile":_phoneTF.text,@"verifyCode":_codeTF.text} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 1) {
             [SVProgressHUD showSuccessWithStatus:@"修改成功"];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];

}

#pragma mark - Private

/**
 *  判断账号密码输入是否正确
 */
- (BOOL)validateInputs
{
    if (!_phoneTF.validatePhoneNumber) {
        [SVProgressHUD showErrorWithStatus:@"输入的手机号有误!"];
        return NO;
    }
    
    return YES;
}


/**
 *  发送验证码lab点击手势，获取验证码
 */
- (void)sendCodeClick
{
    if (!_phoneTF.validatePhoneNumber) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSDictionary *param = @{@"mobileNo":_phoneTF.text,@"messageType":@"2"};
        
        [XLDataService postWithUrl:RMRequestStatusSendMessage param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
             if (error.code == 0) {
                 [SVProgressHUD showSuccessWithStatus:@"已发送验证码"];
             } else {
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }
         }];
        
        _sendCodeLab.userInteractionEnabled = NO;
        _sendCodeLab.backgroundColor = [UIColor grayColor];
        
        [PRUitls countDownWithTimeOut:60 CallBack:^(BOOL isFinished, int curTime)
         {
             if (isFinished) {
                 _sendCodeLab.userInteractionEnabled = YES;
                 _sendCodeLab.backgroundColor = QLTY_MAIN_COLOR;
                 _sendCodeLab.text = [NSString stringWithFormat:@"获取验证码"];
             } else {
                 _sendCodeLab.text = [NSString stringWithFormat:@"%d秒重新获取", curTime];
             }
         }];
    }
}

#pragma mark - Actions

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确定绑定按钮
 */
- (IBAction)confirmBindingBtnClick:(id)sender
{
    [self changeBindingPhoneRequest];
}


//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (_phoneTF.validatePhoneNumber && _codeTF.text.length == 6) {
//        _bindingBtn.backgroundColor = [UIColor redColor];
//    } else {
//        _bindingBtn.backgroundColor = [UIColor lightGrayColor];
//    }
//    return YES;
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
