//
//  UITextField+Verify.m
//  ELLife
//
//  Created by admin on 15/8/7.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import "UITextField+Verify.h"

@implementation UITextField (Verify)

- (BOOL)isNotEmpty {
    return ![self.text isEqual: @""];
}

- (BOOL)validateString:(NSString *) regEx{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [predicate evaluateWithObject:self.text];
}

- (BOOL)validateEmail {
    return [self validateString:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"];
}

- (BOOL)validatePhoneNumber {
    return [self validateString:@"[1][3578]\\d{9}"];
}

- (BOOL)validatePassword {
    return [self validateString:@"^[0-9a-zA-Z_#]{6,16}$"];
}

- (BOOL)validateBankCard
{
    return [self validateString:@"^\\d{16,19}$|^\\d{6}[- ]\\d{10,13}$|^\\d{4}[- ]\\d{4}[- ]\\d{4}[- ]\\d{4,7}$"];
}

- (BOOL)validateChinese
{
    return [self validateString:@"^[\u4e00-\u9fa5]*$"];
}


@end
