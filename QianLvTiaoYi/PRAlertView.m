//
//  PRAlertView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/23.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRAlertView.h"

@implementation PRAlertView

- (void)showNoLoginAlertViewWithCallBack:(PRAlertViewCallBack)callBack
{
    self.callBack = callBack;
    self.title = @"提示";
    self.message = @"您尚未登录, 是否立即登录";
    self.delegate =self;
    [self addButtonWithTitle:@"取消"];
    self.cancelButtonIndex = 0;
    [self addButtonWithTitle:@"立即登录"];
    [self show];
}

- (void)show{
    self.delegate = self;
    [super show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.callBack) {
        self.callBack(buttonIndex);
    }
}

@end
