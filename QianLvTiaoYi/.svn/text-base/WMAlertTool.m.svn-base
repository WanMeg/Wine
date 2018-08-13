//
//  WMAlertTool.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/30.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "WMAlertTool.h"

typedef void (^confirm)();
typedef void (^cancle)();
typedef void (^others)();

@interface WMAlertTool()
{
    confirm confirmParam;
    cancle  cancleParam;
    others otherParam;
}
@end

@implementation WMAlertTool

- (void)showAlert:(UIViewController *)viewController withTitle:(NSString *)title withMessage:(NSString *)message withButton1:(NSString *)cancelButtonTitle withButton2:(NSString *) confirmButtonTitle withButton3:(NSString *)otherButtonTitle button1:(void (^)())cancle button2: (void (^)())confirm button3: (void (^)())others
{
    cancleParam = cancle;
    confirmParam = confirm;
    otherParam = others;
    
    if (IAIOS8)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
        {
            cancle();
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            confirm();
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            others();
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [alertController addAction:otherAction];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle,otherButtonTitle,nil];
        
        [TitleAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        cancleParam();
    } else if (buttonIndex == 1)
    {
        confirmParam();
    } else
    {
        otherParam();
    }
}

@end
