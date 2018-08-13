//
//  PRTranslucentController.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRTranslucentController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PRTranslucentController ()

@end

@implementation PRTranslucentController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }else{
            [[[UIApplication sharedApplication] delegate] window].rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
