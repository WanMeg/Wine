//
//  JSHelpPayVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/28.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSHelpPayVC.h"
#import "GetHelpPayData.h"

@interface JSHelpPayVC ()

@property (nonatomic, strong) WMHelpPay *helpPay;
@property (weak, nonatomic) IBOutlet UILabel *payContentLab;

@end

@implementation JSHelpPayVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_isWhatPayVC isEqualToString:@"a"]) {
        [self getHelpCenterPayRequestWithStatus:@"a"];
    } else if ([_isWhatPayVC isEqualToString:@"b"]) {
        [self getHelpCenterPayRequestWithStatus:@"b"];
    } else if ([_isWhatPayVC isEqualToString:@"c"]) {
        [self getHelpCenterPayRequestWithStatus:@"c"];
    } else {
        [self getHelpCenterPayRequestWithStatus:@"d"];
    }
}

/**
 *  请求帮助中心支付文档的数据
 */
- (void)getHelpCenterPayRequestWithStatus:(NSString *)string
{
    __weak typeof(self) weakSelf = self;
    [GetHelpPayData postWithUrl:RMRequestStatusMemberHelpPay param:@{@"searchName":string} modelClass:[WMHelpPay class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             [SVProgressHUD showSuccessWithStatus:error.domain];
             weakSelf.helpPay = dataObj;
             weakSelf.title = weakSelf.helpPay.name;
             NSString *str1 = [weakSelf.helpPay.content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
             NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
             _payContentLab.text = str2;
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
