//
//  PRAlertManager.m
//  ELLife
//
//  Created by admin on 15/8/8.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import "PRAlertManager.h"
#import "JSContact.h"

typedef void (^myBlock)(BOOL isCancelAction);
@interface PRAlertManager()
@property (strong, nonatomic) UIAlertController *alertVC;
@property (strong, nonatomic) UIAlertView * alertView;
@property (copy, nonatomic) myBlock callBack; //UIView *(^viewGetter)(NSString *imageName);
@end
@implementation PRAlertManager

- (instancetype)initWithTitle:(NSString *)title message: (NSString *)message cancelTitle: (NSString *)cancelTitle otherTitle:(NSString *)otherTitle ownner: (UIViewController *)ownner ActionCallBack:(void (^)(BOOL isCancelAction))callBack{
    if (self = [super init]) {
        [self showAlertViewWithTitle:title message:message cancelTitle:cancelTitle otherTitle:otherTitle ownner:ownner ActionCallBack:callBack];
    }
    return self;
}

- (void)showAlertViewWithTitle:(NSString *)title message: (NSString *)message cancelTitle: (NSString *)cancelTitle otherTitle:(NSString *)otherTitle ownner: (__weak UIViewController *)ownner ActionCallBack:(void (^)(BOOL isCancelAction))callBack {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        if (self.alertVC == nil){
            self.alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        }
        self.alertVC.title = title;
        self.alertVC.message = message;
        
        if (cancelTitle != nil && ![cancelTitle isEqualToString:@""]) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (callBack) {
                    callBack(YES);
                }
            }];
            [self.alertVC addAction:cancelAction];
        }
        
        if (otherTitle != nil && ![otherTitle isEqualToString:@""]){
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                callBack(NO);
            }];
            [self.alertVC addAction:okAction];
        }
        [ownner presentViewController:self.alertVC animated:YES completion:nil];
    }else{
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] init];
        }
        self.alertView.title = title;
        self.alertView.message = message;
        self.alertView.delegate = self;
        self.alertView.cancelButtonIndex = [self.alertView addButtonWithTitle:cancelTitle];
        [self.alertView addButtonWithTitle:otherTitle];
        self.callBack = callBack;
        [self.alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        self.callBack(NO);
    }else{
        self.callBack(YES);
    }
}

- (void)dealloc
{
    NSLog(@"Alert移除");
}

@end
