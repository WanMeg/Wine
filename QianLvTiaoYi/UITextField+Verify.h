//
//  UITextField+Verify.h
//  ELLife
//
//  Created by admin on 15/8/7.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Verify)

- (BOOL)isNotEmpty;
- (BOOL)validateEmail;//判断邮箱
- (BOOL)validatePhoneNumber;//判断手机号
- (BOOL)validatePassword;//判断密码
- (BOOL)validateBankCard;//判断银行卡号
- (BOOL)validateChinese;//判断汉字


@end
