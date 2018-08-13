//
//  PRAlertManager.h
//  ELLife
//
//  Created by admin on 15/8/8.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PRAlertManager : NSObject<UIAlertViewDelegate>
- (instancetype)initWithTitle:(NSString *)title message: (NSString *)message cancelTitle: (NSString *)cancelTitle otherTitle:(NSString *)otherTitle ownner: (UIViewController *)ownner ActionCallBack:(void (^)(BOOL isCancelAction))callBack;

- (void)showAlertViewWithTitle:(NSString *)title message: (NSString *)message cancelTitle: (NSString *)cancelTitle otherTitle:(NSString *)otherTitle ownner: (__weak UIViewController *)ownner ActionCallBack:(void (^)(BOOL isCancelAction))callBack;
@end
