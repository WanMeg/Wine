//
//  WMAlertTool.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/30.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMAlertTool : NSObject

-(void)showAlert:(UIViewController *)viewController withTitle:(NSString *)title withMessage:(NSString *)message withButton1:(NSString *)cancelButtonTitle withButton2:(NSString *) confirmButtonTitle withButton3:(NSString *)otherButtonTitle button1:(void (^)())cancle button2: (void (^)())confirm button3: (void (^)())others;

@end
